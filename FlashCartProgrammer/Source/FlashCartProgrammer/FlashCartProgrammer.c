//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------

#include <stdio.h>
#include "types.h"
#include "pico/stdlib.h"

// See FatFs - Generic FAT Filesystem Module, "Application Interface",
// http://elm-chan.org/fsw/ff/00index_e.html
#include "f_util.h"
#include "ff.h"
#include "hw_config.h"

#include "hardware/pio.h"
#include "hardware/dma.h"
#include "hardware/spi.h"

#include "hsync.pio.h"
#include "vsync.pio.h"
#include "rgb.pio.h"

#include "VicChars.h"

#define VGA_RESOLUTION_X    	(640)
#define VGA_RESOLUTION_Y  		(480)
#define TERMINAL_CHARS_WIDE		(VGA_RESOLUTION_X >> 3)
#define TERMINAL_CHARS_HIGH		(VGA_RESOLUTION_Y >> 3)

enum vga_pins {PIN_RED = 0, PIN_GREEN, PIN_BLUE, PIN_HSYNC = 4, PIN_VSYNC, PIN_IO0 = 12, PIN_DATA_OE = 32, PIN_LATCH_ADDRESS, PIN_LATCH_OE, PIN_BYTE = 36, PIN_WE, PIN_OE, PIN_CE};
#define ADDRESS_BUS_SIZE		(20)

enum rgbColours {RGB_BLACK, RGB_RED, RGB_GREEN, RGB_YELLOW, RGB_BLUE, RGB_MAGENTA, RGB_CYAN, RGB_WHITE};

u8 aVGAScreenBuffer[(VGA_RESOLUTION_X * VGA_RESOLUTION_Y) >> 1];
u8* address_pointer = aVGAScreenBuffer;

static volatile u8 s_aReadBuffer[1024];

//-----------------------------------------------------------------------------------------------'-
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
void initVGA()
{
	// Choose which PIO instance to use (there are two instances, each with 4 state machines)
	PIO pio = pio0;
	const uint hsync_offset = pio_add_program(pio, &hsync_program);
	const uint vsync_offset = pio_add_program(pio, &vsync_program);
	const uint rgb_offset = pio_add_program(pio, &rgb_program);

	// Manually select a few state machines from pio instance pio0.
	uint hsync_sm = 0;
	uint vsync_sm = 1;
	uint rgb_sm = 2;
	hsync_program_init(pio, hsync_sm, hsync_offset, PIN_HSYNC);
	vsync_program_init(pio, vsync_sm, vsync_offset, PIN_VSYNC);
	rgb_program_init(pio, rgb_sm, rgb_offset, PIN_RED);

	/////////////////////////////////////////////////////////////////////////////////////////////////////
	// ============================== PIO DMA Channels =================================================
	/////////////////////////////////////////////////////////////////////////////////////////////////////

	// DMA channels - 0 sends color data, 1 reconfigures and restarts 0
	int rgb_chan_0 = 2;		// Use Channels 2 & 3 As 1 & 2 Are Used By The SD_Card Library.
	int rgb_chan_1 = 3;

	// Channel Zero (sends color data to PIO VGA machine)
	dma_channel_config c0 = dma_channel_get_default_config(rgb_chan_0);  	// default configs
	channel_config_set_transfer_data_size(&c0, DMA_SIZE_8);              	// 8-bit txfers
	channel_config_set_read_increment(&c0, true);                        	// yes read incrementing
	channel_config_set_write_increment(&c0, false);                      	// no write incrementing
	channel_config_set_dreq(&c0, DREQ_PIO0_TX2) ;                        	// DREQ_PIO0_TX2 pacing (FIFO)
	channel_config_set_chain_to(&c0, rgb_chan_1);                        	// chain to other channel

	dma_channel_configure
	(
		rgb_chan_0,                                                        	// Channel to be configured
		&c0,                                                               	// The configuration we just created
		&pio->txf[rgb_sm],                                                 	// write address (RGB PIO TX FIFO)
		&aVGAScreenBuffer,                                                 	// The initial read address (pixel color array)
		(VGA_RESOLUTION_X * VGA_RESOLUTION_Y) >> 1,                        	// Number of transfers; in this case each is 1 byte.
		false                                                              	// Don't start immediately.
	);

	// Channel One (reconfigures the first channel)
	dma_channel_config c1 = dma_channel_get_default_config(rgb_chan_1);  	// default configs
	channel_config_set_transfer_data_size(&c1, DMA_SIZE_32);             	// 32-bit txfers
	channel_config_set_read_increment(&c1, false);                       	// no read incrementing
	channel_config_set_write_increment(&c1, false);                      	// no write incrementing
	channel_config_set_chain_to(&c1, rgb_chan_0);                        	// chain to other channel

	dma_channel_configure
	(
		rgb_chan_1,                         	// Channel to be configured
		&c1,                                	// The configuration we just created
		&dma_hw->ch[rgb_chan_0].read_addr,  	// Write address (channel 0 read address)
		&address_pointer,                   	// Read address (POINTER TO AN ADDRESS)
		1,                                 	 	// Number of transfers, in this case each is 4 byte
		false                               	// Don't start immediately.
	);

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////

	// Initialize PIO state machine counters. This passes the information to the state machines
	// that they retrieve in the first 'pull' instructions, before the .wrap_target directive
	// in the assembly. Each uses these values to initialize some counting registers.
	#define H_ACTIVE   655    // (active + frontporch - 1) - one cycle delay for mov
	#define V_ACTIVE   479    // (active - 1)
	#define RGB_ACTIVE 319    // (horizontal active)/2 - 1
	// #define RGB_ACTIVE 639 // change to this if 1 pixel/byte
	pio_sm_put_blocking(pio, hsync_sm, H_ACTIVE);
	pio_sm_put_blocking(pio, vsync_sm, V_ACTIVE);
	pio_sm_put_blocking(pio, rgb_sm, RGB_ACTIVE);

	// Start the two pio machine IN SYNC
	// Note that the RGB state machine is running at full speed,
	// so synchronization doesn't matter for that one. But, we'll
	// start them all simultaneously anyway.
	pio_enable_sm_mask_in_sync(pio, ((1u << hsync_sm) | (1u << vsync_sm) | (1u << rgb_sm)));

	// Start DMA channel 0. Once started, the contents of the pixel color array
	// will be continously DMA's to the PIO machines that are driving the screen.
	// To change the contents of the screen, we need only change the contents
	// of that array.
	dma_start_channel_mask((1u << rgb_chan_0)) ;
}

//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
void FilledRectangle(u32 uPositionX, u32 uPositionY, u32 uWidth, u32 uHeight, u32 uColour)
{
	if (uPositionX + uWidth >= VGA_RESOLUTION_X)
		uWidth = VGA_RESOLUTION_X - uPositionX;

	if (uPositionY + uHeight >= VGA_RESOLUTION_Y)
		uHeight = VGA_RESOLUTION_Y - uPositionY;

	if ((uWidth > 0) && (uHeight > 0))
	{
		u32 uPixelOffset = ((uPositionY * VGA_RESOLUTION_X) + uPositionX) >> 1;

		if (uPositionX & 1)
		{
			u32 uOffset = uPixelOffset++;
			--uWidth;

			for(u32 y=0; y<uHeight; ++y)
			{
				aVGAScreenBuffer[uOffset] = (aVGAScreenBuffer[uOffset] & 0b11000111) | (uColour << 3);
				uOffset += VGA_RESOLUTION_X >> 1;
			}
		}

		while (uWidth > 1)
		{
		u32 uOffset = uPixelOffset++;
		uWidth -= 2;

		for(u32 y=0; y<uHeight; ++y)
		{
			aVGAScreenBuffer[uOffset] = (uColour << 3) | uColour;
			uOffset += VGA_RESOLUTION_X >> 1;
		}
		}

		if (1 == uWidth)
		{
			for(u32 y=0; y<uHeight; ++y)
			{
				aVGAScreenBuffer[uPixelOffset] = (aVGAScreenBuffer[uPixelOffset] & 0b11111000) | uColour;
				uPixelOffset += VGA_RESOLUTION_X >> 1;
			}
		}
	}
}

//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
void DrawPetsciiChar(const u32 uXPos, const u32 uYPos, const u8 uChar, const u8 uColour)
{
	for (u32 uLine=0; uLine<8; ++uLine)
	{
		u32 uPixelOffset = ((((uYPos + uLine) * VGA_RESOLUTION_X ) + uXPos) >> 1) + 3;
		u32 uCharLine = VicChars901460_03[2048 + (uChar << 3) + uLine];

		for (u32 x=0; x<4; ++x)
		{
			u8 uPixelPair = 0;

			if (uCharLine & 2)
				uPixelPair = uColour;

			if (uCharLine & 1)
				uPixelPair |= (uColour << 3);

			aVGAScreenBuffer[uPixelOffset--] = uPixelPair;
			uCharLine >>= 2;
		}
	}
}

//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
void DrawString(uint32_t uCharX, uint32_t uCharY, const char* pszString, const uint8_t uColour)
{
	while (*pszString)
	{
		if (uCharX >= (TERMINAL_CHARS_WIDE-1))
		{
			uCharX = 1;
			++uCharY;
		}

		if (uCharY >= (TERMINAL_CHARS_HIGH-1))
			return;

		uint8_t c = *pszString++;

		if (c >= '`')
			c -= '`';

		DrawPetsciiChar(uCharX << 3, uCharY << 3, c, uColour);
		++uCharX;
	}
}

//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
static const uint8_t aHexTable[16] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};

static inline uint16_t byteToHex(const uint8_t uByte)
{
  return (aHexTable[(uByte >> 4) & 15] << 8) | aHexTable[uByte & 15];
}

//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
void FormatHexDumpLine(uint32_t uCharX, uint32_t uCharY, const uint32_t uAddress, const uint8_t* pLineBuffer, const uint8_t uColour)
{
	// Write Address Offset in 6 byte hex.
	for(int i=5; i>=0; --i)
		DrawPetsciiChar((uCharX + 5 - i) << 3, uCharY << 3, aHexTable[(uAddress >> (i << 2)) & 15], uColour);

	// Write 16 bytes worth of hex values.
 	for(uint32_t uIndex=0; uIndex<16; ++uIndex)
	{
    const uint16_t uHexPair = byteToHex(pLineBuffer[uIndex]);
		DrawPetsciiChar((uCharX + 8 + (uIndex * 3)) << 3, uCharY << 3, uHexPair >> 8, uColour);
		DrawPetsciiChar((uCharX + 9 + (uIndex * 3)) << 3, uCharY << 3, uHexPair & 255, uColour);

		// Write ASCII version of byte.
		DrawPetsciiChar((uCharX + 57 + uIndex) << 3, uCharY << 3, pLineBuffer[uIndex], uColour);
	}
}

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
	gpio_init(PIN_BYTE);
    gpio_set_dir(PIN_BYTE, GPIO_OUT);
	gpio_put(PIN_BYTE, true);

	// Write Is Disabled
	gpio_init(PIN_WE);
    gpio_set_dir(PIN_WE, GPIO_OUT);
	gpio_put(PIN_WE, true);

	// Flash IC Output Is Enabled
	gpio_init(PIN_OE);
    gpio_set_dir(PIN_OE, GPIO_OUT);
	gpio_put(PIN_OE, false);

	// Flash IC Is Enabled (Only For 16 Bit IC Socket)
	gpio_init(PIN_CE);
    gpio_set_dir(PIN_CE, GPIO_OUT);
	gpio_put(PIN_CE, false);

	// Set All IO Lines To Output
	for(u32 i=0; i<ADDRESS_BUS_SIZE; ++i)
	{
	    gpio_init(PIN_IO0 + i);
	    gpio_set_dir(PIN_IO0 + i, GPIO_OUT);
		gpio_put(PIN_IO0 + i, 0);
	}

    initVGA();
	FilledRectangle(0, 0, VGA_RESOLUTION_X, VGA_RESOLUTION_Y, RGB_GREEN);
	FilledRectangle(1, 1, VGA_RESOLUTION_X-2, VGA_RESOLUTION_Y-2, RGB_BLACK);

	char szTempString[128];
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
						// Diable Data Bus And Set Address
						gpio_put(PIN_DATA_OE, false);
						gpio_set_dir_out_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0);
						gpio_put(PIN_LATCH_ADDRESS, true);
						gpio_put_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0, (uRomOffset + i) << PIN_IO0);

						// Latch Address Lines
						delay_120ns();
						gpio_put(PIN_LATCH_ADDRESS, false);

						// Enable And Read The Data Bus
						gpio_set_dir_in_masked(((1 << 16) - 1) << PIN_IO0);
						gpio_put(PIN_DATA_OE, true);
						delay_120ns();
						delay_120ns();
						delay_120ns();

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

	for (uint32_t uLine=0; uLine<40; ++uLine)
	{
		u8 aLineBuffer[16];
		const u32 uAddress = uFlashOffset + (uLine << 4);

		for (u32 i=0; i<16; ++i)
		{
			// Diable Data Bus And Set Address
			gpio_put(PIN_DATA_OE, false);
			gpio_set_dir_out_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0);
			gpio_put(PIN_LATCH_ADDRESS, true);
			gpio_put_masked(((1 << ADDRESS_BUS_SIZE) - 1) << PIN_IO0, (uAddress + i) << PIN_IO0);

			// Latch Address Lines
			delay_120ns();
			gpio_put(PIN_LATCH_ADDRESS, false);

			// Enable And Read The Data Bus
			gpio_set_dir_in_masked(((1 << 16) - 1) << PIN_IO0);
			gpio_put(PIN_DATA_OE, true);
			delay_120ns();
			delay_120ns();
			delay_120ns();

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
		DrawString(2, 62, szTempString, RGB_YELLOW);
		sleep_ms(16);
		uOnTime++;
	}
}
