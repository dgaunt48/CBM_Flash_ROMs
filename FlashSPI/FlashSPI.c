//------------------------------------------------------------------------------------------------
//---- FlashSpi.c (C) 2023 Dave Gaunt                                                         ----
//------------------------------------------------------------------------------------------------
//---- v1.0 - Writes Binary Image To FPGA Flash ROM                                           ----
//------------------------------------------------------------------------------------------------

#include <stdio.h>
#include "types.h"
#include "pico/stdlib.h"
#include "hardware/clocks.h"

#include "vga111.h"
#include "SpiNorFlash.h"
#include "iCE40_BitStream.h"

#define SPI_BAUD_RATE	(5 * 1000 * 1000)	/* 5Mhz */
#define VGA_PAL_CLOCK	(25000000)

enum board_pins{
	PIN_RED = 0, PIN_GREEN, PIN_BLUE, PIN_FPGA_RESET,
	PIN_SPI_MOSI, PIN_SPI_CS, PIN_SPI_CLOCK, PIN_SPI_MISO,
	PIN_HSYNC, PIN_VSYNC, PIN_FPGA_DONE,
	PIN_25MHZ_CLOCK = 21
};

static_assert(21 == PIN_25MHZ_CLOCK, "Pico only exposes PIN_21 for external clocks!");

//------------------------------------------------------------------------------------------------
//----                                                                                        ----
//------------------------------------------------------------------------------------------------
int main()
{
	stdio_init_all();

	// Hold the FPGA in reset while we program it's SPI flash ROM.
    gpio_init(PIN_FPGA_RESET);
    gpio_set_dir(PIN_FPGA_RESET, GPIO_OUT);
    gpio_put(PIN_FPGA_RESET, false);

	vga_Init(PIN_RED, PIN_HSYNC, PIN_VSYNC);
	vga_FilledRect(0, 0, VGA_RESOLUTION_X, VGA_RESOLUTION_Y, RGB111_GREEN);
	vga_FilledRect(1, 1, VGA_RESOLUTION_X-2, VGA_RESOLUTION_Y-2, RGB111_BLACK);

	if(SpiNorFlash_Initialise(spi0, SPI_BAUD_RATE, PIN_SPI_CLOCK, PIN_SPI_MOSI, PIN_SPI_MISO, PIN_SPI_CS))
	{
		vga_FilledRect(0, 0, VGA_RESOLUTION_X, VGA_RESOLUTION_Y, RGB111_GREEN);

		if (SpiNorFlash_Verify(0, iCE40_BitStream_size, iCE40_BitStream))
		{
			// Flash Data Verified And Correct - Nothing To Do !!!
			vga_FilledRect(1, 1, VGA_RESOLUTION_X-2, VGA_RESOLUTION_Y-2, RGB111_BLACK);
			vga_DrawString(4, 4, "FPGA Binary Valid.", RGB111_GREEN);
		}
		else
		{
			// Erase Flash Memory And Attempt To Rewrite Data.
			SpiNorFlash_Erase64kBlock(0);
			SpiNorFlash_Erase64kBlock(1);
			SpiNorFlash_Erase64kBlock(2);

			if (SpiNorFlash_Write(0, iCE40_BitStream_size, iCE40_BitStream, true))
			{
				// Rewrite Success - Flash Data Is Valid And Up To Date.
				vga_FilledRect(1, 1, VGA_RESOLUTION_X-2, VGA_RESOLUTION_Y-2, RGB111_BLACK);
				vga_DrawString(4, 4, "FPGA Binary Updated And Valid.", RGB111_GREEN);
			}
			else
			{
				// Rewrite Failed - Flash Data Is Corrupt!!!
				vga_FilledRect(0, 0, VGA_RESOLUTION_X, VGA_RESOLUTION_Y, RGB111_RED);
				vga_FilledRect(1, 1, VGA_RESOLUTION_X-2, VGA_RESOLUTION_Y-2, RGB111_BLACK);
				vga_DrawString(4, 4, "FPGA Binary Corrupt!!!", RGB111_RED);
			}
		}
	}
	else
	{
		vga_DrawString(4, 4, "Can't Communicate With Flash ROM!!!", RGB111_RED);
	}
	
	// Change SS to input mode to allow FPGA to drive it
    gpio_set_dir(PIN_SPI_CS, GPIO_IN);

	// Release FPGA from RESET state
    gpio_put(PIN_FPGA_RESET, true);

	// Start Clock
	clock_gpio_init(PIN_25MHZ_CLOCK, CLOCKS_CLK_GPOUT0_CTRL_AUXSRC_VALUE_CLK_SYS, ((float)SYS_CLK_HZ / (float)VGA_PAL_CLOCK));
	sleep_ms(1000);

	while(true)
	{
		sleep_ms(16);
	}
}
