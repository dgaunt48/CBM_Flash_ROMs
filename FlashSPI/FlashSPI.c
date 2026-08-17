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

#define SPI_BAUD_RATE	(20 * 1000 * 1000)	/* 20Mhz */
#define VGA_PAL_CLOCK	(25000000)

enum board_pins{
	PIN_RED = 0, PIN_GREEN, PIN_BLUE,
	PIN_HSYNC = 8, PIN_VSYNC,
	PIN_SPI_CS = 17,
	PIN_SPI_CLOCK,
	PIN_SPI_MOSI,
	PIN_SPI_MISO,
	PIN_25MHZ_CLOCK,
	PIN_FPGA_CDONE,
	PIN_FPGA_RESET = 41
};

static_assert(21 == PIN_25MHZ_CLOCK, "Pico only exposes PIN_21 for external clocks!");

//------------------------------------------------------------------------------------------------
//---- Program SPI Nor Flash                                                                  ----
//------------------------------------------------------------------------------------------------
/*
int main()
{
	stdio_init_all();

	// Hold the FPGA in reset while we program it's SPI flash ROM.
    gpio_init(PIN_FPGA_RESET);
    gpio_set_dir(PIN_FPGA_RESET, GPIO_OUT);
    gpio_put(PIN_FPGA_RESET, false);
	sleep_ms(10);

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

	// Start Clock
	clock_gpio_init(PIN_25MHZ_CLOCK, CLOCKS_CLK_GPOUT0_CTRL_AUXSRC_VALUE_CLK_SYS, ((float)SYS_CLK_HZ / (float)VGA_PAL_CLOCK));
	sleep_ms(10);
	
	// Change SS to input mode to allow FPGA to drive it
    gpio_set_dir(PIN_SPI_CS, GPIO_IN);

	// Release FPGA from RESET state
    gpio_put(PIN_FPGA_RESET, true);

	while(true)
	{
		sleep_ms(16);
	}
}
*/

//------------------------------------------------------------------------------------------------
//---- Directly Upload BitStream To iCE40                                                     ----
//------------------------------------------------------------------------------------------------
int main()
{
	stdio_init_all();
    const u32 uSpiSpeed = spi_init(spi0, SPI_BAUD_RATE);

    gpio_init(PIN_FPGA_RESET);
    gpio_set_dir(PIN_FPGA_RESET, GPIO_OUT);
    gpio_put(PIN_FPGA_RESET, false);

    gpio_init(PIN_SPI_CS);
    gpio_init(PIN_FPGA_CDONE);
    gpio_set_dir(PIN_FPGA_CDONE, GPIO_IN);

    gpio_set_function(PIN_SPI_CS, GPIO_FUNC_SIO);
    gpio_set_function(PIN_SPI_CLOCK, GPIO_FUNC_SPI);
    gpio_set_function(PIN_SPI_MOSI, GPIO_FUNC_SPI);
    gpio_set_function(PIN_SPI_MISO, GPIO_FUNC_SPI);
    gpio_set_dir(PIN_SPI_CS, GPIO_OUT);
	gpio_put(PIN_SPI_CS, true);

	vga_Init(PIN_RED, PIN_HSYNC, PIN_VSYNC);
	vga_FilledRect(0, 0, VGA_RESOLUTION_X, VGA_RESOLUTION_Y, RGB111_GREEN);
	vga_FilledRect(1, 1, VGA_RESOLUTION_X-2, VGA_RESOLUTION_Y-2, RGB111_BLACK);

	// CS Low While Reset is Low to select Slave Mode.
	sleep_ms(2);
    gpio_put(PIN_SPI_CS, false);
    gpio_put(PIN_FPGA_RESET, true);
    sleep_us(1200);					// iCE40HX requires max 1200us clearing time

    spi_write_blocking(spi0, iCE40_BitStream, iCE40_BitStream_size);
    gpio_put(PIN_SPI_CS, true);

    // iCE40 needs at least 49 cycles with CS high to enter user mode
    uint8_t dummy_padding[8] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
    spi_write_blocking(spi0, dummy_padding, sizeof(dummy_padding));

	// Start Clock
	clock_gpio_init(PIN_25MHZ_CLOCK, CLOCKS_CLK_GPOUT0_CTRL_AUXSRC_VALUE_CLK_SYS, ((float)SYS_CLK_HZ / (float)VGA_PAL_CLOCK));

	if( gpio_get(PIN_FPGA_CDONE) )
	{
		vga_DrawString(4, 4, "Bitstream Upload Complete", RGB111_GREEN);
	}
	else
	{
		vga_DrawString(4, 4, "FPGA Init Failed!!!", RGB111_RED);
	}

	// char szTempString[128];
	// sprintf(szTempString, "Spi Speed %d", uSpiSpeed);
	// vga_DrawString(4, 4, szTempString, RGB111_GREEN);

	while(true)
	{
		sleep_ms(16);
	}
}
