/*
 * linux/arch/arm/mach-at91/board-boff.c
 *
 *  Copyright (C) 2007 Boff Corp.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <linux/types.h>
#include <linux/init.h>
#include <linux/mm.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/spi/spi.h>
#include <linux/mtd/physmap.h>

#include <asm/setup.h>
#include <asm/mach-types.h>
#include <asm/irq.h>

#include <asm/mach/arch.h>
#include <asm/mach/map.h>
#include <asm/mach/irq.h>

#include <mach/board.h>
#include <mach/gpio.h>
#include <mach/at91rm9200_mc.h>

#include "generic.h"


static void __init bf_map_io(void)
{
	/* Initialize processor: 18.432 MHz crystal */
	at91rm9200_initialize(18432000, AT91RM9200_PQFP);

	/* DBGU on ttyS0. (Rx & Tx only) */
	at91_register_uart(0, 0, 0);

	/* USART1 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
	at91_register_uart(AT91RM9200_ID_US1, 1, ATMEL_UART_CTS | ATMEL_UART_RTS
			   | ATMEL_UART_DTR | ATMEL_UART_DSR | ATMEL_UART_DCD
			   | ATMEL_UART_RI);

	/* Register USART2 at ttyS2 */
	at91_register_uart(AT91RM9200_ID_US2,2,0);

	/* set serial console to ttyS0 (ie, DBGU) */
	at91_set_serial_console(0);
}

static void __init bf_init_irq(void)
{
	at91rm9200_init_interrupts(NULL);
}

static struct at91_eth_data __initdata bf_eth_data = {
	.phy_irq_pin	= 0,
	.is_rmii	= 0,
};

static struct at91_usbh_data __initdata bf_usbh_data = {
	.ports		= 1,
};

static struct at91_udc_data __initdata bf_udc_data = {
	.vbus_pin	= AT91_PIN_PC11,
	.pullup_pin	= AT91_PIN_PB28,
};

static struct at91_mmc_data __initdata bf_mmc_data = {
	.slot_b		= 0,
	.wire4		= 1,
	.det_pin	= AT91_PIN_PB27,
};

static struct spi_board_info bf_spi_devices[] = {
	{	/* DataFlash chip */
		.modalias	= "mtd_dataflash",
		.chip_select	= 0,
		.max_speed_hz	= 15 * 1000 * 1000,
	}
};

static struct i2c_board_info __initdata bf_i2c_devices[] = {
	{
		I2C_BOARD_INFO("pcf8583", 0x51),
	},
};

static void __init bf_board_init(void)
{
	/* Serial */
	at91_add_device_serial();
	/* Ethernet */
	at91_add_device_eth(&bf_eth_data);
	/* USB Host */
	at91_add_device_usbh(&bf_usbh_data);
	/* USB Device */
	at91_add_device_udc(&bf_udc_data);
	at91_set_multi_drive(bf_udc_data.pullup_pin, 1);	/* pullup_pin is connected to reset */
	/* I2C */
	at91_add_device_i2c(bf_i2c_devices,ARRAY_SIZE(bf_i2c_devices));
	/* SPI */
	at91_add_device_spi(bf_spi_devices, ARRAY_SIZE(bf_spi_devices));

	/* MMC */
	at91_set_gpio_output(AT91_PIN_PB7, 1);	/* this MMC card slot can optionally use SPI signaling (CS3). */
	at91_add_device_mmc(0, &bf_mmc_data);
}

MACHINE_START(AT91RM9200, "Boff Armputera BF-210")
	/* Maintainer: Andrzej Telszewski */
	.phys_io	= AT91_BASE_SYS,
	.io_pg_offst	= (AT91_VA_BASE_SYS >> 18) & 0xfffc,
	.boot_params	= AT91_SDRAM_BASE + 0x100,
	.timer		= &at91rm9200_timer,
	.map_io		= bf_map_io,
	.init_irq	= bf_init_irq,
	.init_machine	= bf_board_init,
MACHINE_END

