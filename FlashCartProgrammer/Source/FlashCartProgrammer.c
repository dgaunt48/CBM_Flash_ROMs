//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
//----                                                                                        ----
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

enum vga_pins {
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
	PIN_FLASH_CE
};

#define ADDRESS_BUS_SIZE		(20)

enum rgbColours {RGB_BLACK, RGB_RED, RGB_GREEN, RGB_YELLOW, RGB_BLUE, RGB_MAGENTA, RGB_CYAN, RGB_WHITE};

static volatile u8 s_aReadBuffer[1024];

//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
void FormatHexDumpLine(u32 uCharX, u32 uCharY, const u32 uAddress, const u8* pLineBuffer, const u8 uColour)
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

		// Write ASCII version of byte.
		DrawPetsciiChar((uCharX + 57 + uIndex) << 3, uCharY << 3, pLineBuffer[uIndex], uColour);
	}
}

//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
void flash_command_byte(const u32 uAddress, const u8 uData)
{
	gpio_put(PIN_DATA_OE, false);														// Disable Data Bus
	gpio_put(PIN_LATCH_ADDRESS, true);													// Load Address Latch
	gpio_put_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0, uAddress << PIN_IO0);		// Set Address On IO Lines
	busy_wait_at_least_cycles(5);														// Wait Until Address Is Stable
	gpio_put(PIN_LATCH_ADDRESS, false);													// Latch Address On Bus
	gpio_put(PIN_FLASH_WE, false);														// Load Address To Flash On Falling Edge Of WE
	gpio_put_masked(0xFF << PIN_IO0, (u32)uData << PIN_IO0);							// Set Data On IO Lines
	gpio_put(PIN_DATA_OE, true);														// Assert OE High To Write
	busy_wait_at_least_cycles(40);														// Wait Until Stable ... 30 Seems About Minimum ... So Add A Bit For Safety
	gpio_put(PIN_FLASH_WE, true);														// Write Byte On Rising Edge Of WE
}


static volatile u8 s_uTest = 0;

//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
int main()
{
    stdio_init_all();

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

	// Flash IC Is Enabled (Only For 16 Bit IC Socket)
	gpio_init(PIN_FLASH_CE);
    gpio_set_dir(PIN_FLASH_CE, GPIO_OUT);
	gpio_put(PIN_FLASH_CE, false);

	// Set All IO Lines To Output
	for(u32 i=0; i<ADDRESS_BUS_SIZE; ++i)
	{
	    gpio_init(PIN_IO0 + i);
	    gpio_set_dir(PIN_IO0 + i, GPIO_OUT);
		gpio_put(PIN_IO0 + i, 0);
	}

    initVGA(PIN_RED, PIN_HSYNC, PIN_VSYNC);
	FilledRectangle(0, 0, VGA_RESOLUTION_X, VGA_RESOLUTION_Y, RGB_GREEN);
	FilledRectangle(1, 1, VGA_RESOLUTION_X-2, VGA_RESOLUTION_Y-2, RGB_BLACK);

	char szTempString[128];

	gpio_put(PIN_FLASH_OE, true);
	gpio_put(PIN_FLASH_WE, true);
	gpio_set_dir_out_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0);


//    SST39SF0_SoftwareIDEntry();
	flash_command_byte(0x5555, 0xAA);
	flash_command_byte(0x2AAA, 0x55);
	flash_command_byte(0x5555, 0x90);
    sleep_ms(16);                        // Give the IC time to exit standby mode.

	// Set Address 0x0000
	gpio_put(PIN_DATA_OE, false);
	gpio_put(PIN_FLASH_OE, false);
	gpio_put(PIN_LATCH_ADDRESS, true);
	gpio_put_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0, 0x0000 << PIN_IO0);
	busy_wait_at_least_cycles(5);
	gpio_put(PIN_LATCH_ADDRESS, false);

	gpio_set_dir_in_masked(((1 << 16) - 1) << PIN_IO0);
	gpio_put(PIN_DATA_OE, true);

	busy_wait_at_least_cycles(15);
	s_uTest = (gpio_get_all() >> PIN_IO0) & 0xFF;

	sprintf(szTempString, "Manufacturer Id = 0x%02x (BF)", s_uTest);
	DrawString(2, 56, szTempString, RGB_GREEN);

//	  SST39SF0_SoftwareIDExit();
	gpio_put(PIN_FLASH_OE, true);
	gpio_put(PIN_FLASH_WE, true);
	gpio_set_dir_out_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0);

	flash_command_byte(0x5555, 0xAA);
	flash_command_byte(0x2AAA, 0x55);
	flash_command_byte(0x5555, 0xF0);

	gpio_put(PIN_FLASH_OE, false);


	sd_card_t *pSD = sd_get_by_num(0);

	FRESULT fr = f_mount(&pSD->fatfs, pSD->pcName, 1);
	if (FR_OK == fr)
	{
		FIL fil;
		const char* const filename = "VicTestRom.bin";

		fr = f_open(&fil, filename, FA_OPEN_EXISTING | FA_READ);
		if (FR_OK == fr)
		{
			const u32 uRomSize = f_size(&fil);
			u32 uRomOffset = 0;
			u32 uBytesRead;
			bool bVerifySuccess = true;

			while(bVerifySuccess)
			{
				f_read(&fil, (void*)&s_aReadBuffer, 1024, &uBytesRead);
				
				if(uBytesRead > 0)
				{
					for(u32 i=0; i<uBytesRead; ++i)
					{
						// Disable Data Bus And Set Address
						gpio_put(PIN_DATA_OE, false);
						gpio_set_dir_out_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0);
						gpio_put(PIN_LATCH_ADDRESS, true);
						gpio_put_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0, (uRomOffset + i) << PIN_IO0);

						// Latch Address Lines
						busy_wait_at_least_cycles(5);
						gpio_put(PIN_LATCH_ADDRESS, false);

						// Enable And Read The Data Bus
						gpio_set_dir_in_masked(((1 << 16) - 1) << PIN_IO0);
						gpio_put(PIN_DATA_OE, true);

						busy_wait_at_least_cycles(15);
						const u8 uDataBus = (gpio_get_all() >> PIN_IO0) & 0xFF;

						if (s_aReadBuffer[i] != uDataBus)
						{
							bVerifySuccess = false;
							break;
						}
					}

					uRomOffset += uBytesRead;
				}
				else
				{
					break;
				}
			}

			if (bVerifySuccess)
			{
				DrawString(2, 2, "ROM Verify Success!!!", RGB_GREEN);
			}
			else
			{
				DrawString(2, 2, "ROM Verify Failed!!!", RGB_RED);
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

	u32 uOnTime = 0;
	const u32 uFlashOffset = 0;

	for (u32 uLine=0; uLine<40; ++uLine)
	{
		u8 aLineBuffer[16];
		const u32 uAddress = uFlashOffset + (uLine << 4);

		for (u32 i=0; i<16; ++i)
		{
			// Disable Data Bus And Set Address
			gpio_put(PIN_DATA_OE, false);
			gpio_set_dir_out_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0);
			gpio_put(PIN_LATCH_ADDRESS, true);
			gpio_put_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0, (uAddress + i) << PIN_IO0);

			// Latch Address Lines
			busy_wait_at_least_cycles(5);
			gpio_put(PIN_LATCH_ADDRESS, false);

			// Enable And Read The Data Bus
			gpio_set_dir_in_masked(((1 << 16) - 1) << PIN_IO0);
			gpio_put(PIN_DATA_OE, true);

			busy_wait_at_least_cycles(15);
			aLineBuffer[i] = (gpio_get_all() >> PIN_IO0) & 0xFF;

			// if (Vic8kCombo[uAddress + i] != aLineBuffer[i])
			// 	aLineBuffer[i] = '*';
		}

//		SpiNorFlash_Read(uAddress, 16, aLineBuffer);
		FormatHexDumpLine(3, 10 + uLine, uAddress, aLineBuffer, RGB_CYAN);
	}

	while(true)
	{
		sprintf(szTempString, "Time On = %d.%d", uOnTime / 50, (uOnTime % 50) * 2);
		DrawString(2, 58, szTempString, RGB_YELLOW);
		sleep_ms(16);
		uOnTime++;
	}
}
