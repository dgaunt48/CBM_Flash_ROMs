//------------------------------------------------------------------------------------------------
//---- CBM Flash Cart Programmer                                                              ----
//------------------------------------------------------------------------------------------------
//---- v1.0 - 2022 Dave Gaunt                                                                 ----
//---- v2.0 - 2026 Complete Rewrite                                                           ----
//------------------------------------------------------------------------------------------------

#include <stdio.h>
#include "types.h"
#include "pico/stdlib.h"
#include "vga111.h"

// See FatFs - Generic FAT Filesystem Module, "Application Interface",
// http://elm-chan.org/fsw/ff/00index_e.html
#include "f_util.h"
#include "ff.h"
#include "hw_config.h"

enum flash_manufacturer
{
	FLASH_MANUFACTURER_UNKNOWN		= 0x00,
	FLASH_MANUFACTURER_SST			= 0xBF,
	FLASH_MANUFACTURER_MACRONIX		= 0xC2
};

enum flash_boot_sector
{
	FLASH_BOOT_SECTOR_NONE = 0,
	FLASH_BOOT_SECTOR_TOP,
	FLASH_BOOT_SECTOR_BOTTOM
};

enum flash_voltage
{
	FLASH_VOLTAGE_3V3 = 0x33,
	FLASH_VOLTAGE_5V0 = 0x50
};

typedef struct 
{
	u8		m_bInitialised;
	u8		m_eManufacturer;
	u8		m_eVoltage;
	u8		m_eBootSector;

	u8		m_u16Bit;
	u8		m_uSoftwareIdExit;
	u8		m_uPadding;
	u8		m_uNumSectors;

	u32		m_uSize;
	u16		m_aSectorBase4k[256+1];
} flashROM;

enum mcu_pins
{
	PIN_RED = 0,
	PIN_GREEN,
	PIN_BLUE,
	PIN_HSYNC = 4,
	PIN_VSYNC,
	PIN_IO0 = 12,
	PIN_DATA_OE = 32,
	PIN_LATCH_ADDRESS,
	PIN_LATCH_OE,
	PIN_BYTE_MODE = 36,
	PIN_FLASH_WE,
	PIN_FLASH_OE,
	PIN_FLASH_RESET
};

#define ADDRESS_BUS_SIZE		(20)

enum rgbColours {RGB_BLACK, RGB_RED, RGB_GREEN, RGB_YELLOW, RGB_BLUE, RGB_MAGENTA, RGB_CYAN, RGB_WHITE};

static volatile u8 s_aReadBuffer[1024];
static flashROM s_flashROM = {0};

//------------------------------------------------------------------------------------------------
//---- ascii_to_petscii                                                                       ----
//------------------------------------------------------------------------------------------------
u8 ascii_to_petscii(const u8 c)
{
    // Handle ASCII Lowercase (97-122) Maps 'a'-'z' to ROM Lowwercase (1-26)
    if (c >= 97 && c <= 122)
		return c - 96;

    // Special Case For '@'
    if (c == 64)
		return 0;

    // Handle Space (32) through 'Z' (90)
	// This includes numbers and maps ASCII Uppercase (65-90) to ROM Uppercase (65-90)
    if (c >= 32 && c <= 90)
		return c;

    // Default to Space
    return 32; 
}

//------------------------------------------------------------------------------------------------
//---- FormatHexDumpLine	                                                                  ----
//------------------------------------------------------------------------------------------------
void FormatHexDumpLine(u32 uCharX, u32 uCharY, const u32 uAddress, const u8* pLineBuffer, const u8 uColour, const bool bASCII)
{
	// Write Address Offset in 6 byte hex.
	for(int i=5; i>=0; --i)
		DrawPetsciiChar((uCharX + 5 - i) << 3, uCharY << 3, g_aHexTable[(uAddress >> (i << 2)) & 15], uColour);

	// Write 16 bytes worth of hex values.
 	for(u32 uIndex=0; uIndex<16; ++uIndex)
	{
    	const u16 uHexPair = byteToHex(pLineBuffer[uIndex]);
		DrawPetsciiChar((uCharX + 8 + (uIndex * 3)) << 3, uCharY << 3, uHexPair >> 8, uColour);
		DrawPetsciiChar((uCharX + 9 + (uIndex * 3)) << 3, uCharY << 3, uHexPair & 255, uColour);

		// Write ASCII or PETSCII version of byte.
		const u8 uCurrentChar = (bASCII) ? ascii_to_petscii(pLineBuffer[uIndex]) : pLineBuffer[uIndex];
		DrawPetsciiChar((uCharX + 57 + uIndex) << 3, uCharY << 3, uCurrentChar, uColour);
	}
}

//------------------------------------------------------------------------------------------------
//---- flash_latch_address                                                                    ----
//------------------------------------------------------------------------------------------------
void flash_latch_address(const u32 uAddress)
{
	gpio_put(PIN_DATA_OE, false);														// Disable Data Bus
	gpio_set_dir_out_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0);					// Set All IO Lines To Output
	gpio_put(PIN_LATCH_ADDRESS, true);													// Load Address Latch
	gpio_put_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0, uAddress << PIN_IO0);		// Set Address On IO Lines
	busy_wait_at_least_cycles(5);														// Wait Until Address Is Stable
	gpio_put(PIN_LATCH_ADDRESS, false);													// Latch Address On Bus
}

//------------------------------------------------------------------------------------------------
//---- flash_command_byte                                                                     ----
//------------------------------------------------------------------------------------------------
void flash_command_byte(const u32 uAddress, const u8 uData)
{
	flash_latch_address(uAddress);
	gpio_put(PIN_FLASH_WE, false);														// Load Address To Flash On Falling Edge Of WE
	gpio_put_masked(0xFF << PIN_IO0, (u32)uData << PIN_IO0);							// Set Data On IO Lines
	gpio_put(PIN_DATA_OE, true);														// Assert OE High To Write
	busy_wait_at_least_cycles(40);														// Wait Until Stable ... 30 Seems About Minimum ... So Add A Bit For Safety
	gpio_put(PIN_FLASH_WE, true);														// Write Byte On Rising Edge Of WE
}

//------------------------------------------------------------------------------------------------
//---- flash_command_word                                                                     ----
//------------------------------------------------------------------------------------------------
void flash_command_word(const u32 uAddress, const u16 uData)
{
	flash_latch_address(uAddress);
	gpio_put(PIN_FLASH_WE, false);														// Load Address To Flash On Falling Edge Of WE
	gpio_put_masked(0xFFFF << PIN_IO0, (u32)uData << PIN_IO0);							// Set Data On IO Lines
	gpio_put(PIN_DATA_OE, true);														// Assert OE High To Write
	busy_wait_at_least_cycles(40);														// Wait Until Stable ... 30 Seems About Minimum ... So Add A Bit For Safety
	gpio_put(PIN_FLASH_WE, true);														// Write Byte On Rising Edge Of WE
}

//------------------------------------------------------------------------------------------------
//---- flash_command_mode_read                                                                ----
//------------------------------------------------------------------------------------------------
void flash_command_mode_read(void)
{
	gpio_put(PIN_FLASH_WE, true);
	gpio_put(PIN_FLASH_OE, false);
}

//------------------------------------------------------------------------------------------------
//---- flash_command_mode_write                                                               ----
//------------------------------------------------------------------------------------------------
void flash_command_mode_write(void)
{
	gpio_put(PIN_FLASH_OE, true);
	gpio_put(PIN_FLASH_WE, true);
}

//------------------------------------------------------------------------------------------------
//---- flash_command_sequence                                                                 ----
//------------------------------------------------------------------------------------------------
void flash_command_sequence(const u32 uAddress, const u8 uData)
{
	flash_command_byte(0x5555, 0xAA);
	flash_command_byte(0x2AAA, 0x55);
	flash_command_byte(uAddress, uData);
}

//------------------------------------------------------------------------------------------------
//---- flash_read_byte                                                                        ----
//------------------------------------------------------------------------------------------------
u8 flash_read_byte(const u32 uAddress)
{
	flash_latch_address(uAddress);
	gpio_set_dir_in_masked(((1 << 16) - 1) << PIN_IO0);
	gpio_put(PIN_DATA_OE, true);
	busy_wait_at_least_cycles(15);
	return (gpio_get_all() >> PIN_IO0) & 0xFF;
}

//------------------------------------------------------------------------------------------------
//---- flash_read_word                                                                        ----
//------------------------------------------------------------------------------------------------
u16 flash_read_word(const u32 uAddress)
{
	flash_latch_address(uAddress);
	gpio_set_dir_in_masked(((1 << 16) - 1) << PIN_IO0);
	gpio_put(PIN_DATA_OE, true);
	busy_wait_at_least_cycles(15);
	return swap_u16(gpio_get_all() >> PIN_IO0);
}

//------------------------------------------------------------------------------------------------
//---- flash_write_byte                                                                       ----
//------------------------------------------------------------------------------------------------
void flash_write_byte(const u32 uAddress, const u8 uData)
{
	flash_command_mode_write();
	flash_command_sequence(0x5555, 0xA0);
	flash_command_word(uAddress, uData);
	flash_command_mode_read();
	gpio_set_dir_in_masked(((1 << 16) - 1) << PIN_IO0);
	do
	{
		busy_wait_at_least_cycles(9);
	} while ( ((gpio_get_all() >> PIN_IO0) & 0x80) != (uData & 0x80));
}

//------------------------------------------------------------------------------------------------
//---- flash_write_word                                                                       ----
//------------------------------------------------------------------------------------------------
void flash_write_word(const u32 uAddress, const u16 uData)
{
	flash_command_mode_write();
	flash_command_sequence(0x5555, 0xA0);
	flash_command_word(uAddress, uData);
	flash_command_mode_read();
	gpio_set_dir_in_masked(((1 << 16) - 1) << PIN_IO0);
	do
	{
		busy_wait_at_least_cycles(9);
	} while ( ((gpio_get_all() >> PIN_IO0) & 0x80) != (uData & 0x80));
}

//------------------------------------------------------------------------------------------------
//---- flash_software_id_entry                                                                ----
//------------------------------------------------------------------------------------------------
void flash_software_id_entry()
{
	flash_command_mode_write();
	flash_command_sequence(0x5555, 0x90);
	flash_command_mode_read();
}

//------------------------------------------------------------------------------------------------
//---- flash_reset                                                                            ----
//------------------------------------------------------------------------------------------------
void flash_reset()
{
	gpio_put(PIN_FLASH_RESET, false);
	sleep_us(1);
	gpio_put(PIN_FLASH_RESET, true);
}

//------------------------------------------------------------------------------------------------
//---- flash_software_id_exit                                                                 ----
//------------------------------------------------------------------------------------------------
void flash_software_id_exit()
{
	if (s_flashROM.m_bInitialised)
	{
		if (s_flashROM.m_uSoftwareIdExit)
		{
			flash_command_mode_write();
			flash_command_sequence(0x5555, 0xF0);
			flash_command_mode_read();
		}
		else
		{
			// If The Flash ROM Does Not Support Software Id Exit
			// We Must Reset The Flash To Return To Read Mode.
			flash_reset();
		}
	}
}

//------------------------------------------------------------------------------------------------
//---- FlashInitialise                                                                        ----
//------------------------------------------------------------------------------------------------
bool FlashInitialise(void)
{
	if (s_flashROM.m_bInitialised)
		return false;

	flash_software_id_entry();
	sleep_ms(16);                        // Give the IC time to exit standby mode.

	s_flashROM.m_eManufacturer = flash_read_byte(0);
	switch(s_flashROM.m_eManufacturer)
	{
		case FLASH_MANUFACTURER_SST:
		{
	 		const u8 uFlashID = flash_read_byte(1);
			switch (uFlashID >> 4)
			{
				case 0xB:
					s_flashROM.m_eVoltage = FLASH_VOLTAGE_5V0;
				break;

				case 0xD:
					s_flashROM.m_eVoltage = FLASH_VOLTAGE_3V3;
				break;

				default:
					return (false);
			}

			if ( ((uFlashID & 15) < 4) || ((uFlashID & 15) > 7) )
				return (false);

			s_flashROM.m_eBootSector = FLASH_BOOT_SECTOR_NONE;
			s_flashROM.m_uSoftwareIdExit = true;
			s_flashROM.m_u16Bit = false;

			// Simple Linear Flash, 4k Sector Base Is Just The Sector Index.
			const u32 uNumSectors = 1 << (uFlashID & 15);
			for (u32 uSectorIndex=0; uSectorIndex<uNumSectors+1; ++uSectorIndex)
				s_flashROM.m_aSectorBase4k[uSectorIndex] = uSectorIndex;

			s_flashROM.m_uNumSectors = uNumSectors;
			s_flashROM.m_uSize = uNumSectors << 12;
			s_flashROM.m_bInitialised = true;
		}
		break;

		case FLASH_MANUFACTURER_MACRONIX:
		{
			s_flashROM.m_eVoltage = FLASH_VOLTAGE_5V0;
			s_flashROM.m_u16Bit = true;
			s_flashROM.m_uSoftwareIdExit = false;
				
			const u16 uFlashType = swap_u16(flash_read_word(1));
			switch (uFlashType)
			{
				case 0x2251:
				{
					s_flashROM.m_eBootSector = FLASH_BOOT_SECTOR_TOP;
					s_flashROM.m_aSectorBase4k[0] = 0;		// 64k
					s_flashROM.m_aSectorBase4k[1] = 16;		// 64k
					s_flashROM.m_aSectorBase4k[2] = 32;		// 64k
					s_flashROM.m_aSectorBase4k[3] = 48;		// 32k
					s_flashROM.m_aSectorBase4k[4] = 56;		// 8k
					s_flashROM.m_aSectorBase4k[5] = 58;		// 8k
					s_flashROM.m_aSectorBase4k[6] = 60;		// 16k
					s_flashROM.m_aSectorBase4k[7] = 64;		// End
				}					
				break;

				case 0x2257:
				{
					s_flashROM.m_eBootSector = FLASH_BOOT_SECTOR_BOTTOM;
					s_flashROM.m_aSectorBase4k[0] = 0;		// 16k
					s_flashROM.m_aSectorBase4k[1] = 4;		// 8k
					s_flashROM.m_aSectorBase4k[2] = 6;		// 8k
					s_flashROM.m_aSectorBase4k[3] = 8;		// 32k
					s_flashROM.m_aSectorBase4k[4] = 16;		// 64k
					s_flashROM.m_aSectorBase4k[5] = 32;		// 64k
					s_flashROM.m_aSectorBase4k[6] = 48;		// 64k
					s_flashROM.m_aSectorBase4k[7] = 64;		// End
				}
				break;

				default:
					return (false);
			}

			s_flashROM.m_uNumSectors = 7;
			s_flashROM.m_uSize = 256 << 10;
			s_flashROM.m_bInitialised = true;
		}
		break;

		default:
			return (false);
	}

	flash_software_id_exit();

	return (s_flashROM.m_bInitialised);
}

//------------------------------------------------------------------------------------------------
//---- FlashRead                                                                              ----
//------------------------------------------------------------------------------------------------
bool FlashRead(void* pData, const u32 uAddress, const u32 uLength)
{
    assert(s_flashROM.m_bInitialised);

	if ((uAddress + uLength) > s_flashROM.m_uSize)
		return false;

	if (s_flashROM.m_u16Bit)
	{
	    assert(0 == (uAddress & 1));
	    assert(0 == (uLength & 1));
		u16* pWordData = (u16*)pData;
		const u32 uWordLength = (uLength + 1) >> 1;

		for (u32 i=0; i<uWordLength; ++i)
			pWordData[i] = flash_read_word((uAddress >> 1) + i);

		return true;
	}

	u8* pByteData = (u8*)pData;

	for (u32 i=0; i<uLength; ++i)
		pByteData[i] = flash_read_byte(uAddress + i);

	return true;
}

//------------------------------------------------------------------------------------------------
//---- FlashVerify                                                                            ----
//------------------------------------------------------------------------------------------------
bool FlashVerify(const void* pCompareData, const u32 uAddress, const u32 uLength)
{
    assert(s_flashROM.m_bInitialised);

	if ((uAddress + uLength) > s_flashROM.m_uSize)
		return false;

	if (s_flashROM.m_u16Bit)
	{
	    assert(0 == (uAddress & 1));
	    assert(0 == (uLength & 1));
		u16* pWordData = (u16*)pCompareData;
		const u32 uWordLength = (uLength + 1) >> 1;

		for (u32 i=0; i<uWordLength; ++i)
		{
			if (pWordData[i] != flash_read_word((uAddress >> 1) + i))
				return false;
		}

		return true;
	}

	u8* pByteData = (u8*)pCompareData;

	for (u32 i=0; i<uLength; ++i)
	{
		if (pByteData[i] != flash_read_byte(uAddress + i))
			return false;
	}

	return true;
}

//------------------------------------------------------------------------------------------------
//---- FlashGetSectorBase                                                                     ----
//------------------------------------------------------------------------------------------------
u32 FlashGetSectorBase(const u32 uAddress)
{
    assert(s_flashROM.m_bInitialised);
	assert(uAddress < s_flashROM.m_uSize);
	u32 uSectorIndex = s_flashROM.m_uNumSectors;

	while((s_flashROM.m_aSectorBase4k[uSectorIndex] << 12) > uAddress)
		--uSectorIndex;

	return (s_flashROM.m_aSectorBase4k[uSectorIndex] << 12);
}

//------------------------------------------------------------------------------------------------
//---- FlashGetSectorLength                                                                   ----
//------------------------------------------------------------------------------------------------
u32 FlashGetSectorLength(const u32 uAddress)
{
    assert(s_flashROM.m_bInitialised);
	assert(uAddress < s_flashROM.m_uSize);
	u32 uSectorIndex = s_flashROM.m_uNumSectors;
	while((s_flashROM.m_aSectorBase4k[uSectorIndex] << 12) > uAddress)
		--uSectorIndex;

	return ((s_flashROM.m_aSectorBase4k[uSectorIndex + 1] - s_flashROM.m_aSectorBase4k[uSectorIndex]) << 12);
}

//------------------------------------------------------------------------------------------------
//---- FlashIsErased                                                                          ----
//------------------------------------------------------------------------------------------------
bool FlashIsErased(const u32 uAddress, const u32 uLength)
{
    assert(s_flashROM.m_bInitialised);

	if ((uAddress + uLength) > s_flashROM.m_uSize)
		return false;

	if (s_flashROM.m_u16Bit)
	{
	    assert(0 == uAddress & 1);
	    assert(0 == uLength & 1);
		const u32 uWordLength = (uLength + 1) >> 1;

		for (u32 i=0; i<uWordLength; ++i)
		{
			if (0xFFFF != flash_read_word((uAddress >> 1) + i))
				return false;
		}

		return true;
	}

	for (u32 i=0; i<uLength; ++i)
	{
		if (0xFF != flash_read_byte(uAddress + i))
			return false;
	}

	return true;
}

//------------------------------------------------------------------------------------------------
//---- FlashEraseSector                                                                       ----
//------------------------------------------------------------------------------------------------
bool FlashEraseSector(const u32 uAddress)
{
    assert(s_flashROM.m_bInitialised);
	const u32 uSectorAddress = FlashGetSectorBase(uAddress);
	const u32 uLength = FlashGetSectorLength(uSectorAddress);

	if (!FlashIsErased(uSectorAddress, uLength))
	{
		flash_command_mode_write();
		flash_command_sequence(0x5555, 0x80);
		flash_command_sequence(uAddress, 0x30);

		busy_wait_at_least_cycles(15);
		flash_command_mode_read();
		gpio_set_dir_in_masked(((1 << 16) - 1) << PIN_IO0);

		do
		{
			busy_wait_at_least_cycles(9);
		} while ( 0 == ((gpio_get_all() >> PIN_IO0) & 0x80) );
	}

    return true;
}

//------------------------------------------------------------------------------------------------
//---- FlashWrite                                                                             ----
//------------------------------------------------------------------------------------------------
bool FlashWrite(const void* pData, const u32 uAddress, const u32 uLength, const bool bVerify)
{
    assert(s_flashROM.m_bInitialised);

	if ((uAddress + uLength) > s_flashROM.m_uSize)
		return false;

	if (!FlashIsErased(uAddress, uLength))
		return false;

	if (s_flashROM.m_u16Bit)
	{
	    assert(0 == (uAddress & 1));
	    assert(0 == (uLength & 1));
		u16* pWordData = (u16*)pData;
		const u32 uWordLength = (uLength + 1) >> 1;

		for (u32 i=0; i<uWordLength; ++i)
			flash_write_word((uAddress >> 1) + i, swap_u16(pWordData[i]));
	}
	else
	{
		u8* pByteData = (u8*)pData;
		
		for (u32 i=0; i<uLength; ++i)
			flash_write_byte(uAddress + i, pByteData[i]);
	}

	if (!bVerify)
        return true;

    return FlashVerify(pData, uAddress, uLength);
}

//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
int main()
{
    stdio_init_all();
	s_flashROM.m_bInitialised = false;

	gpio_init(PIN_FLASH_RESET);
    gpio_set_dir(PIN_FLASH_RESET, GPIO_OUT);
	gpio_put(PIN_FLASH_RESET, false);

	// Data Bus Off
	gpio_init(PIN_DATA_OE);
    gpio_set_dir(PIN_DATA_OE, GPIO_OUT);
	gpio_put(PIN_DATA_OE, false);

	// Address Latch Transparent
	gpio_init(PIN_LATCH_ADDRESS);
    gpio_set_dir(PIN_LATCH_ADDRESS, GPIO_OUT);
	gpio_put(PIN_LATCH_ADDRESS, true);

	// Address Output On
	gpio_init(PIN_LATCH_OE);
    gpio_set_dir(PIN_LATCH_OE, GPIO_OUT);
	gpio_put(PIN_LATCH_OE, false);

	// Word Mode (Only For 16 Bit Flash IC"s)
	gpio_init(PIN_BYTE_MODE);
    gpio_set_dir(PIN_BYTE_MODE, GPIO_OUT);
	gpio_put(PIN_BYTE_MODE, true);

	// Write Is Disabled
	gpio_init(PIN_FLASH_WE);
    gpio_set_dir(PIN_FLASH_WE, GPIO_OUT);
	gpio_put(PIN_FLASH_WE, true);

	// Flash IC Output Is Enabled
	gpio_init(PIN_FLASH_OE);
    gpio_set_dir(PIN_FLASH_OE, GPIO_OUT);
	gpio_put(PIN_FLASH_OE, false);

	// Set All IO Lines To Output
	for(u32 i=0; i<ADDRESS_BUS_SIZE; ++i)
	{
	    gpio_init(PIN_IO0 + i);
	    gpio_set_dir(PIN_IO0 + i, GPIO_OUT);
		gpio_put(PIN_IO0 + i, 0);
	}

	gpio_put(PIN_FLASH_RESET, true);

    initVGA(PIN_RED, PIN_HSYNC, PIN_VSYNC);

	char szTempString[128];
	FilledRectangle(0, 0, VGA_RESOLUTION_X, VGA_RESOLUTION_Y, RGB_GREEN);
	FilledRectangle(1, 1, VGA_RESOLUTION_X-2, VGA_RESOLUTION_Y-2, RGB_BLACK);

	if (!FlashInitialise())
	{
		// Can't Initialise Flash So Take A Guess That A Mask ROM Is Inserted.
		s_flashROM.m_eManufacturer = FLASH_MANUFACTURER_UNKNOWN;
		s_flashROM.m_eVoltage = FLASH_VOLTAGE_5V0;
		s_flashROM.m_eBootSector = FLASH_BOOT_SECTOR_NONE;
		s_flashROM.m_u16Bit = true;
		s_flashROM.m_uSoftwareIdExit = false;
		s_flashROM.m_uNumSectors = 0;
		s_flashROM.m_uSize = 256 << 10;
		s_flashROM.m_aSectorBase4k[0] = s_flashROM.m_uSize >> 2;
		s_flashROM.m_bInitialised = true;
	}

	switch (s_flashROM.m_eManufacturer)
	{
		case FLASH_MANUFACTURER_SST:
			DrawString(2, 52, "Flash Manufacturer SST", RGB_GREEN);
		break;

		case FLASH_MANUFACTURER_MACRONIX:
			DrawString(2, 52, "Flash Manufacturer MACRONIX", RGB_GREEN);
		break;

		default:
			DrawString(2, 52, "Flash Manufacturer UNKNOWN", RGB_GREEN);
		break;
	}

	sprintf(szTempString, "Voltage %d.%d    %d Bit", s_flashROM.m_eVoltage >> 4, s_flashROM.m_eVoltage & 15, s_flashROM.m_u16Bit ? 16 : 8);
	DrawString(32, 52, szTempString, RGB_GREEN);

	switch (s_flashROM.m_eBootSector)
	{
		case FLASH_BOOT_SECTOR_TOP:
			DrawString(2, 54, "Boot Sector Top", RGB_GREEN);
		break;

		case FLASH_BOOT_SECTOR_BOTTOM:
			DrawString(2, 54, "Boot Sector Bottom", RGB_GREEN);
		break;

		default:
			DrawString(2, 54, "Boot Sector None", RGB_GREEN);
		break;
	}

	sprintf(szTempString, "Sector Count = %d   Size = %d KBytes", s_flashROM.m_uNumSectors, s_flashROM.m_uSize >> 10);
	DrawString(22, 54, szTempString, RGB_GREEN);

	sd_card_t *pSD = sd_get_by_num(0);

	FRESULT fr = f_mount(&pSD->fatfs, pSD->pcName, 1);
	if (FR_OK == fr)
	{
		FIL fil;
		const char* const filename = "VicTestRom.bin";
//		const char* const filename = "Kickstart_1_2.rom";
//		FlashEraseSector(5000);

		fr = f_open(&fil, filename, FA_OPEN_EXISTING | FA_READ);
		if (FR_OK == fr)
		{
			const u32 uRomSize = f_size(&fil);
			bool bVerifySuccess = true;
			u32 uRomOffset = 0;
			u32 uBytesRead;

			while(bVerifySuccess)
			{
				f_read(&fil, (void*)&s_aReadBuffer, 1024, &uBytesRead);

				if(0 == uBytesRead)
					break;

				if (FlashIsErased(uRomOffset, uBytesRead))
				{
					bVerifySuccess = FlashWrite((void*)&s_aReadBuffer, uRomOffset, uBytesRead, true);
				}
				else
				{
					bVerifySuccess = FlashVerify((void*)&s_aReadBuffer, uRomOffset, uBytesRead);
				}

				uRomOffset += uBytesRead;
			}

			if (bVerifySuccess)
			{
				DrawString(2, 2, "Flash Verify Success!!!", RGB_GREEN);
			}
			else
			{
				if (FlashIsErased(0, uRomSize))
				{
					DrawString(2, 2, "Flash Empty!!!", RGB_MAGENTA);
				}
				else
				{
					DrawString(2, 2, "Flash Verify Failed!!!", RGB_RED);
				}
			}

			f_close(&fil);
		}
		else
		{
			sprintf(szTempString, "can't open file: %s", filename);
		}

	    f_unmount(pSD->pcName);
	}
	else
	{
		sprintf(szTempString, "f_mount error: %s (%d)", FRESULT_str(fr), fr);
		DrawString(2, 2, szTempString, RGB_RED);
	}

	// FIL fil;
    // const char* const filename = "filename.txt";
    // fr = f_open(&fil, filename, FA_OPEN_APPEND | FA_WRITE);

    // if (FR_OK != fr && FR_EXIST != fr)
    //     panic("f_open(%s) error: %s (%d)\n", filename, FRESULT_str(fr), fr);

    // if (f_printf(&fil, "Dave Waz Ere Again!!!\n") < 0)
    //     printf("f_printf failed\n");

    // fr = f_close(&fil);

    // if (FR_OK != fr)
    //     printf("f_close error: %s (%d)\n", FRESULT_str(fr), fr);

	const u32 uFlashOffset = 4090;
	for (u32 uLine=0; uLine<40; ++uLine)
	{
		u8 aLineBuffer[16];
		const u32 uAddress = uFlashOffset + (uLine << 4);

		if (FlashRead(aLineBuffer, uAddress, 16))
			FormatHexDumpLine(3, 10 + uLine, uAddress, aLineBuffer, RGB_CYAN, s_flashROM.m_u16Bit ? true : false);
	}

	u32 uOnTime = 0;
	while(true)
	{
		sprintf(szTempString, "Time On = %d.%d", uOnTime / 50, (uOnTime % 50) * 2);
		DrawString(58, 2, szTempString, RGB_YELLOW);
		sleep_ms(16);
		uOnTime++;
	}
}
