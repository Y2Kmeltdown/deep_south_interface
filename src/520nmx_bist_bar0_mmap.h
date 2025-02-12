////////////////////////////////////////////////////////////////////////////////
//      Nallatech is providing this design, code, or information "as is".
//      solely for use on Nallatech systems and equipment.
//      By providing this design, code, or information
//      as one possible implementation of this feature, application
//      or standard, NALLATECH IS MAKING NO REPRESENTATION THAT THIS
//      IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
//      AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
//      FOR YOUR IMPLEMENTATION.  NALLATECH EXPRESSLY DISCLAIMS ANY
//      WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
//      IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
//      REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
//      INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//      FOR A PARTICULAR PURPOSE.
//
//      USE OF SOFTWARE. This software contains elements of software code
//      which are the property of Nallatech Limited (Nallatech Software).
//      Use of the Nallatech Software by you is permitted only if you hold a
//      valid license from Nallatech Limited or a valid sub-license from a
//      licensee of Nallatech Limited. Use of such software shall be governed
//      by the terms of such license or sub-license agreement.
//      The Nallatech software is for use solely on Nallatech hardware
//      unless you hold a license permitting use on other hardware.
//
//      This Nallatech Software is protected by copyright law and
//      international treaties. Unauthorized reproduction or distribution of
//      this software, or any portion of it, may result in severe civil and
//      criminal penalties, and will be prosecuted to the maximum extent
//      possible under law. Nallatech products are covered by one or more
//      patents. Other US and international patents pending.
//      Please see www.nallatech.com for more information
//
//      Nallatech products are not intended for use in life support
//      appliances, devices, or systems. Use in such applications is
//      expressly prohibited.
//
//      Copyright © 1998-2012 Nallatech Limited. All rights reserved.
////////////////////////////////////////////////////////////////////////////////
/*
**
** (c) Nallatech Ltd
**
** This is header file for the Nallatech 385A-SOC BIT
**
** Subversion info:
** Revision of last commit: $Rev:$
** Author of last commit:   $Author:$
** Date of last commit:     $Date:$
** repo url:                $HeadURL:$
** $Id:$
**
*/

/*!
  \file 520nmx_bist_bar0_mmap.h
  \brief header file for the 385A-SOC BIST PCIe I/F Bar0 memory map
*/

#ifndef _520nmx_BIST_BAR0_MMAP
#define _520nmx_BIST_BAR0_MMAP

#include <stdint.h>

#define PCIE520nmx_BAR_VERSION_ID 0x0
#define PCIE520nmx_BAR_TEST_REGISTER0 0x4
#define PCIE520nmx_BAR_TEST_REGISTER1 0x8
#define PCIE520nmx_BAR_TEST_REGISTER2 0xC
#define PCIE520nmx_BAR_LED_CONTROL 0x10
#define PCIE520nmx_BAR_COOKER_CONTROL 0x14
#define PCIE520nmx_BAR_UNIQUE_CHIP_ID_LOWER 0x18
#define PCIE520nmx_BAR_UNIQUE_CHIP_ID_UPPER 0x1C
#define PCIE520nmx_BAR_CLOCKS_TEST 0x20
#define PCIE520nmx_BAR_DEVICE_TEMPERATURE_CTRL_STAT 0x80
#define PCIE520nmx_BAR_CORE_FABRIC_TEMP 			0x84
#define PCIE520nmx_BAR_TRANSCEIVER_TILE_CHAN_1_TEMP 0x88
#define PCIE520nmx_BAR_TRANSCEIVER_TILE_CHAN_2_TEMP 0x8C
#define PCIE520nmx_BAR_TRANSCEIVER_TILE_CHAN_3_TEMP 0x90
#define PCIE520nmx_BAR_TRANSCEIVER_TILE_CHAN_4_TEMP 0x94
#define PCIE520nmx_BAR_TRANSCEIVER_TILE_CHAN_5_TEMP 0x98
#define PCIE520nmx_BAR_TRANSCEIVER_TILE_CHAN_6_TEMP 0x9C
#define PCIE520nmx_BAR_TOP_HBM2_TEMP				0xA0
#define PCIE520nmx_BAR_BOTTOM_HBM2_TEMP				0xA4

#define PCIE520nmx_BAR_DEVICE_VOLTAGE_CTRL_STATUS	0xB0
#define PCIE520nmx_BAR_VCC							0xB4
#define PCIE520nmx_BAR_VCCIO_SDM					0xB8
#define PCIE520nmx_BAR_VCCPT						0xBC
#define PCIE520nmx_BAR_VCCERAM						0xC0
#define PCIE520nmx_BAR_VCCADC						0xC4

#define NUM_OCULINK_SIDEBANDS						2  // Only OC0 & OC1
#define NUM_OCULINK_EXTENDED_SIDEBANDS				2  // OC2 & OC3 were added in revB but only have a single reset bit that's read only at the FPGA end
#define PCIE520nmx_BAR_OCULINK0_GPIO                0xD0
#define PCIE520nmx_BAR_OCULINK1_GPIO                0xD4
#define PCIE520nmx_BAR_OCULINK_GPIO_BUFFER_CTRL     0xD8

#define PCIE520nmx_BAR_DDR4_BANK0 0x100
#define PCIE520nmx_BAR_DDR4_BANK1 0x200
#define PCIE520nmx_BAR_DDR4_BANK2 0x300
#define PCIE520nmx_BAR_DDR4_BANK3 0x400
#define PCIE520nmx_BAR_QSFP0 0x500
#define PCIE520nmx_BAR_QSFP1 0x520
#define PCIE520nmx_BAR_QSFP2 0x540
#define PCIE520nmx_BAR_QSFP3 0x560

#define NUM_OCULINKS 8
#define NUM_LANES_PER_OCULINK 4
#define PCIE520nmx_BAR_OCULINK0 0x600
#define PCIE520nmx_BAR_OCULINK1 0x700
#define PCIE520nmx_BAR_OCULINK2 0x800
#define PCIE520nmx_BAR_OCULINK3 0x900
#define PCIE520nmx_BAR_OCULINK4 0xA00
#define PCIE520nmx_BAR_OCULINK5 0xB00
#define PCIE520nmx_BAR_OCULINK6 0xC00
#define PCIE520nmx_BAR_OCULINK7 0xD00

#define PCIE520nmx_BAR_MAX10 0x2000 // System Manager memory map (QSPI Flash controller & peripherals interface)
#define PCIE520nmx_BAR_MAX10_OCR 0x3000 // System Manager On Chip (QSPI Flash loading memory)

#define PCIE520nmx_BAR_BMC_SHARED_MEMORY 	0x4000
#define SPI_REQUEST_COUNT_ADDRESS			PCIE520nmx_BAR_BMC_SHARED_MEMORY
#define SPI_REQUEST_ADDRESS					(PCIE520nmx_BAR_BMC_SHARED_MEMORY + 4)
#define SPI_RESPONSE_COUNT_ADDRESS			(PCIE520nmx_BAR_BMC_SHARED_MEMORY + 0x800)
#define SPI_RESPONSE_ADDRESS				(PCIE520nmx_BAR_BMC_SHARED_MEMORY + 0x804)
#define PCIE520nmx_BAR_ARBITER 				0x5000
#define PCIE520nmx_BAR_PCIE_TO_BMC_IRQ_GEN 0x5010
#define PCIE520nmx_BAR_BMC_TO_PCIE_IRQ_GEN 0x5020

#define NUM_ESRAM_CHANNELS 2
#define ESRAM_CHANNEL0 0x6000
#define ESRAM_CHANNEL7 0x8000
#define HBM2_TESTER_CONTROL_AND_STATUS 0xA000

// QSFP DFE registers
#define PCIE520nmx_BAR_QSFP0_DFE_BASE 0x40000
#define PCIE520nmx_BAR_QSFP1_DFE_BASE 0x48000
#define PCIE520nmx_BAR_QSFP2_DFE_BASE 0x50000
#define PCIE520nmx_BAR_QSFP3_DFE_BASE 0x58000

// Oculink DFE registers
#define PCIE520nmx_BAR_OCULINK4_DFE_BASE 0x60000
#define PCIE520nmx_BAR_OCULINK5_DFE_BASE 0x68000
#define PCIE520nmx_BAR_OCULINK6_DFE_BASE 0x70000
#define PCIE520nmx_BAR_OCULINK7_DFE_BASE 0x78000

// DFE byte offsets
#define PCIE520nmx_BAR_DFE_LANE_OFFSET	          0x2000
#define PCIE520nmx_BAR_DFE_BACK_CAL_OFFSET	      0x1508 // Background calibration
#define PCIE520nmx_BAR_DFE_ACCESS_REQUEST_OFFSET  0x0000 // Request user access (0x000) - Should be rd-mod-wr, setting bit [0] to '0'
#define PCIE520nmx_BAR_DFE_CHECK_CAL_OFFSET       0x1204 // Check calibration status (0x481) - bit [2] must be '0'
#define PCIE520nmx_BAR_DFE_RESET_OFFSET           0x0520 // DFE reset - Should be rd-mod-wr, setting bit [0] to '0'
#define PCIE520nmx_BAR_DFE_ADAPTATION_OFFSET      0x0530 // DFE adaption - Should be rd-mod-wr, setting bit [0] to '1'

#define PCIE520nmx_BAR_DFE_CAL_MASK				  0x4
#define DFE_TIMEOUT								  10

// Oculink GPIO defines
#define PCIE520nmx_BAR_OCULINK_GPIO_BUFFER_ENABLE 0xFC
#define PCIE520nmx_BAR_OCULINK_GPIO_ALL_OUTPUTS 0xFCF00000 // Only 10 available as outputs
#define PCIE520nmx_BAR_OCULINK_GPIO_ALL_INPUTS 0x00000000 // Only 10 available as inputs

#define PCIE520nmx_BAR_OCULINK_GPIO_OC2_PERST 0x4000
#define PCIE520nmx_BAR_OCULINK_GPIO_OC3_PERST 0x8000


// Altera Voltage and Temperature poll enable
#define ALTERA_POLL_ENABLE_MASK 0x10

#define PCIE520nmx_BAR_QSFP_PLL_CAL_ENABLE_OFFSET 0x400
#define PCIE520nmx_BAR_QSFP_PMA_TXRX_CAL_ENABLE_OFFSET 0x400
#define PCIE520nmx_BAR_QSFP_PLL_STATUS_OFFSET 0x1200
#define PCIE520nmx_BAR_QSFP_LANE_STATUS_OFFSET 0x1204
#define PCIE520nmx_BAR_QSFP_PLL_STATUS_PreSICE_MASK 0x4
#define PCIE520nmx_BAR_QSFP_PLL_STATUS_PLL_CAL_COMPLETE_MASK 0x2
#define PCIE520nmx_BAR_QSFP_PLL_STATUS_PMA_TX_CAL_COMPLETE_MASK 0x1
#define PCIE520nmx_BAR_QSFP_PLL_STATUS_PMA_RX_CAL_COMPLETE_MASK 0x2

#define PCIE520nmx_BAR_QSFP_LANE0_DYNAMIC_RECONFIG_OFFSET 0x8000  //           Start of Channel 0, Lane 0 PHY Dynamic Reconfiguration Registers
#define PCIE520nmx_BAR_QSFP_LANE1_DYNAMIC_RECONFIG_OFFSET 0xA000  //          Start of Channel 0, Lane 1 PHY Dynamic Reconfiguration Registers
#define PCIE520nmx_BAR_QSFP_LANE2_DYNAMIC_RECONFIG_OFFSET 0xC000  //          Start of Channel 0, Lane 2 PHY Dynamic Reconfiguration Registers
#define PCIE520nmx_BAR_QSFP_LANE3_DYNAMIC_RECONFIG_OFFSET 0xE000  //          Start of Channel 0, Lane 3 PHY Dynamic Reconfiguration Registers

#define PCIE520nmx_BAR_QSFP_INTERNAL_CONFIG_BUSVAL 0x2
#define PCIE520nmx_BAR_QSFP_PLL_CAL_ENABLE_MASK 0x2
#define PCIE520nmx_BAR_QSFP_PMA_TXRX_CAL_ENABLE_MASK 0x3
#define PCIE520nmx_BAR_QSFP_PLL_DO_CALIBRATION 0x1
#define PCIE520nmx_BAR_QSFP_PMA_TXRX_DO_CALIBRATION 0x1

#define FIRMWARE_VERSION_MASK 0xFF0000
#define FIRMWARE_BISTID_MASK 0xFF000000
#define FIRMWARE_VERSION_NMX_BISTID 0x53000000
#define FIRMWARE_VERSION_NX_BISTID 0x54000000

#define FW_MAJOR_REV_NO_COOKERS 0x80

#define PCIE520nmx_BAR_MAJOR_REV_HTILE_PROD_4X100G 0x3

// LEDS defines
#define PCIE520nmx_BAR_LEDS_RED 0x1
#define PCIE520nmx_BAR_LEDS_GREEN 0x2
#define PCIE520nmx_BAR_LEDS_YELLOW (PCIE520nmx_BAR_LEDS_RED | PCIE520nmx_BAR_LEDS_GREEN)

// Cooker (Burner)
#define PCIE520nmx_BAR_COOKER_CONTROL_SREG_MASK 0xFF
#define PCIE520nmx_BAR_COOKER_CONTROL_SREG_LSB 0
#define PCIE520nmx_BAR_COOKER_CONTROL_BRAM_MASK 0xFF00
#define PCIE520nmx_BAR_COOKER_CONTROL_BRAM_LSB 8
#define PCIE520nmx_BAR_COOKER_CONTROL_DSP_MASK 0xFF0000
#define PCIE520nmx_BAR_COOKER_CONTROL_DSP_LSB 16
#define PCIE520nmx_BAR_COOKER_CONTROL_ENABLE_MASK 0x80000000

// Clocks test Register offsets
#define CLOCKS_CTRL_OFFSET 				(0x00)
#define CONFIG_CLOCK_OFFSET 			(0x4)
#define USER_REFCLOCK0_OFFSET			(0x8)
#define USER_REFCLOCK1_OFFSET			(0xC)
#define PCIE_USER_CLOCK_OFFSET			(0x10)
#define MEM_USER_CLOCK0_OFFSET			(0x14)
#define MEM_USER_CLOCK1_OFFSET			(0x18)
#define CLOCK_1PPS_OFFSET				(0x1C)
#define PHY_USER_CLOCK0_OFFSET			(0x20) // QSFP0 100G capable
#define PHY_USER_CLOCK1_OFFSET			(0x24) // QSFP1 100G capable
#define PHY_USER_CLOCK2_OFFSET			(0x28) // QSFP2 100G capable
#define PHY_USER_CLOCK3_OFFSET			(0x2C) // QSFP3 100G capable
#define PHY_USER_CLOCK4_OFFSET			(0x30) // Oculink0 40G capable
#define PHY_USER_CLOCK5_OFFSET			(0x34) // Oculink1 40G capable
#define PHY_USER_CLOCK6_OFFSET			(0x38) // Oculink2 40G capable
#define PHY_USER_CLOCK7_OFFSET			(0x3C) // Oculink3 40G capable
#define PHY_USER_CLOCK8_OFFSET			(0x40) // Oculink0 100G capable
#define PHY_USER_CLOCK9_OFFSET			(0x44) // Oculink1 100G capable
#define PHY_USER_CLOCK10_OFFSET			(0x48) // Oculink2 100G capable
#define PHY_USER_CLOCK11_OFFSET			(0x4C) // Oculink3 100G capable
#define RECOVERED_CLOCK0_OFFSET			(0x50)
#define RECOVERED_CLOCK1_OFFSET			(0x54)
#define RECOVERED_CLOCK2_OFFSET			(0x58)
#define RECOVERED_CLOCK3_OFFSET			(0x5C)

#define PCIE520nmx_BAR_DDR4_RESET_ON 1
#define PCIE520nmx_BAR_DDR4_RESET_OFF 0

// DDR4 test byte offsets
#define DDR4_CONTROL 0x0
#define DDR4_STATUS 0x4
#define DDR4_TESTS_COMPLETED 0x8
#define DDR4_ERROR_COUNT 0xC
#define DDR4_ERROR_BITS_LOWER 0x10
#define DDR4_ERROR_BITS_UPPER 0x14
#define DDR4_MEMORY_STATUS 0x18
#define DDR4_ERROR_BITS_PARITY 0x1C
#define DDR4_RESULTS_CONTROL 0x20
#define DDR4_OFFSET_ADDRESS 0x24

#define DDR4_CONTROL_RECAL_MASK 0x200
#define DDR4_MEMORY_STATUS_RESET_DONE 0x4

#define DDR4_CALIBRATED 0x1
#define DDR4_CALIBRATION_FAILED 0x2
#define DDR4_STATUS_TEST_FAILED_MASK 0x2
#define DDR4_RESET_DONE 0x4

// There are 24 expected data0 4 byte registers followed by 24 received data0.
#define DDR4_NUM_EXPECTED_DATA_REGS 24
#define DDR4_NUM_ERROR_REGISTERS 1024
#define DDR4_EXPECTED_DATA0 0x28
#define DDR4_RECEIVED_DATA0 0x88

// QSFPS test byte offsets
#define QSFP_STATUS 0x0
#define QSFP_CTRL 0x4
#define QSFP_ERROR_COUNT_LANE0 0x8
#define QSFP_ERROR_COUNT_LANE1 0xC
#define QSFP_ERROR_COUNT_LANE2 0x10
#define QSFP_ERROR_COUNT_LANE3 0x14
#define QSFP_STATISTICS 0x18
#define NUM_QSFP_REGS (((QSFP_STATISTICS - QSFP_STATUS)/4)+1)

// Channmel status register masks
#define QSFPS_RX_BLOCK_LOCKED (0xF)
#define QSFPS_RX_READY (0xF0)
#define QSFPS_TX_READY (0xF00)
#define QSFPS_PLL_LOCKED (0x1000)

// Control register values & masks
#define QSFPS_PRBS_RX_RESET (0x1)
#define QSFPS_PRBS_TX_RESET (0x2)
#define QSFPS_REGISTER_CAPTURE (0x10)
#define QSFPS_PRBS_GEN_ENABLE (0x100)
#define QSFPS_RESET_ERRORCOUNT (0x200)
#define QSFPS_PRBS_LOCKED (0xF000)
#define QSFPS_INSERT_ERROR_MASK 0xFF0000 // Write number of errors to be inserted to bits 23:16

// Error count masks
#define QSFPS_CONTROL_WORD_ERROR_MASK 0xFFFF
#define QSFPS_PRBS_DATA_ERROR_MASK 0xFFFF0000

// Statistics register
#define QSFPS_RX_DATA_RATE_MASK 0xFFFF
#define QSFPS_CHANNEL_SKEW_MASK 0xFF000000

#define QSFPS_WAITFORPLL_LOCK 100000

#define QSFP_IRQ_MASK 0xF00000
#define QSFP_IRQ_LSB 20

// Oculink defines
// Aurora reg offsets
#define OCULINK_STATUS 0x0
#define OCULINK_CTRL 0x4
#define OCULINK_ERROR_COUNT_LANE0 0x8
#define OCULINK_ERROR_COUNT_LANE1 0xC
#define OCULINK_ERROR_COUNT_LANE2 0x10
#define OCULINK_ERROR_COUNT_LANE3 0x14
#define OCULINK_STATISTICS 0x18
#define NUM_OCULINK_REGS (((OCULINK_STATISTICS - OCULINK_STATUS)/4)+1)

#define OCULINKS_RX_BLOCK_LOCKED (0xF)
#define OCULINKS_RX_READY (0xF0)
#define OCULINKS_TX_READY (0xF00)
#define OCULINKS_PLL_LOCKED (0x1000)


// Control register values & masks
#define OCULINKS_PRBS_RX_RESET (0x1)
#define OCULINKS_PRBS_TX_RESET (0x2)
#define OCULINKS_REGISTER_CAPTURE (0x10)
#define OCULINKS_PRBS_GEN_ENABLE (0x100)
#define OCULINKS_RESET_ERRORCOUNT (0x200)
#define OCULINKS_PRBS_LOCKED (0xF000)
#define OCULINKS_INSERT_ERROR_MASK 0xFF0000 // Write number of errors to be inserted to bits 23:16

// Error count masks
#define OCULINKS_CONTROL_WORD_ERROR_MASK 0xFFFF
#define OCULINKS_PRBS_DATA_ERROR_MASK 0xFFFF0000

// Statistics register
#define OCULINKS_RX_DATA_RATE_MASK 0xFFFF
#define OCULINKS_CHANNEL_SKEW_MASK 0xFF000000

#define OCULINKS_WAITFORPLL_LOCK 100000

// System manager MAX10 interface offsets
//////////////////////////////////////////
#define QSPI_INT_STATUS 0x0
#define QSPI_INT_CONTROL 0x4

// This is the QSPI address for any command that has an address associated with it.
// This includes program, read, write, write lock register, read lock register, sector and subsector erase.
#define QSPI_START_ADDR 0x8

// OCR is On Chip RAM. It is where data is put to be written to flash or read from flash
#define OCR_START_ADDR 0xC
#define FPGA_RECONFIG_REG 0x10
#define PERIPHERAL_INT_STATUS 0x14
#define PERIPHERAL_INT_CONTROL 0x18

// QSPI Status bit masks
// Unusually writing a 1 to the DONE bit clears it
#define QSPI_INT_STATUS_DONE 0x1
#define QSPI_INT_STATUS_BUSY 0x2

// QSPI control commands
#define QSPI_INT_CONTROL_ENABLE_DMA 0x1
#define QSPI_INT_CONTROL_LENGTH_MASK 0xF0
#define QSPI_INT_CONTROL_COMMAND_MASK 0xF000

// QSPI command codes
#define QSPI_COMMAND_RESET_ENABLE 0x66
#define QSPI_COMMAND_RESET_MEMORY 0x99
#define QSPI_COMMAND_READ_ID 0x9E
#define QSPI_COMMAND_FLASH_ARRAY_READ	0xBB
#define QSPI_COMMAND_WRITE_ENABLE	0x06
#define QSPI_COMMAND_READ_STATUS_REG	0x05
#define QSPI_COMMAND_WRITE_STATUS_REG	0x01
#define QSPI_COMMAND_READ_LOCK_REG	0xE8
#define QSPI_COMMAND_WRITE_LOCK_REG	0xE5
#define QSPI_COMMAND_FLASH_ARRAY_WRITE	0xD2
#define QSPI_COMMAND_SUBSECTOR_ERASE	0x20
#define QSPI_COMMAND_SECTOR_ERASE	0xD8
#define QSPI_COMMAND_DIE_ERASE	0xC4
#define QSPI_COMMAND_READ_EXT_ADDR_REG	0xC8
#define QSPI_COMMAND_WRITE_EXT_ADDR_REG	0xC5
#define QSPI_COMMAND_READ_NONVOL_CONFIG_REG 0xB5
#define QSPI_COMMAND_WRITE_NONVOL_CONFIG_REG 0xB1
#define QSPI_COMMAND_READ_VOL_CONFIG_REG 0x85
#define QSPI_COMMAND_READ_FLAG_STATUS_REG 0x70

// QSPI start address mask
#define QSPI_START_ADDR_MASK 0x7FFFFFF

// OCR start address mask
#define OCR_START_ADDR_MASK 0xFFF

// No need to clear this bit after writing
#define FPGA_RECONFIG 0x1

// Peripheral interaface status masks
/////////////////////////////////////
// Unusually writing a 1 to the DONE bit clears it
#define PERIPHERAL_INT_STATUS_DONE 0x1
#define PERIPHERAL_INT_STATUS_BUSY 0x2

// Local access request
// Before accessing the system manager the user should assert this bit and check that LGRANT has been asserted in response before proceeding
// with the access. Adopting this technique will ensure atomic access which can be important for QSPI and i2c slave accesses.
#define PERIPHERAL_INT_STATUS_LREQUEST 0x100
#define PERIPHERAL_INT_STATUS_LGRANT 0x10000

#define PERIPHERAL_INT_STATUS_RGRANT0 0x20000
#define PERIPHERAL_INT_STATUS_RGRANT1 0x40000

// Peripheral interaface control masks
/////////////////////////////////////
#define PERIPHERAL_INT_CONTROL_ENABLE 0x1
#define PERIPHERAL_INT_CONTROL_READ 0x2
#define PERIPHERAL_INT_CONTROL_LENGTH_MASK 0xFF00
#define PERIPHERAL_INT_CONTROL_PERIPH_INT_ADDR_MASK 0xFFFF0000

// Arbiter defines
#define ARBITER_HOST_REQUEST 0x1
#define ARBITER_BMC_REQUEST 0x2
#define ARBITER_HOST_GRANTED 0x10
#define ARBITER_BMC_GRANTED 0x20

// Interrupt offsets
#define INTERRUPT_GENERATOR_OFFSET	0x0
#define IRQ_MASK_OFFSET 			0x8
#define IRQ_STATUS_OFFSET			0xC

// There are 24 contiguous Expected data registers
#define NUM_DDR4_EXPECTED_DATA_REGS 24
#define DDR4_EXPECTED_DATA0 0x28
//...
//...
// DDR4_EXPECTED_DATA23 0x84


// There are 24 contiguous Received data registers
#define DDR4_RECEIVED_DATA0 0x88
//...
//...
// DDR4_RECEIVED_DATA23 0xE4

// HBM bottom defines
#define HBM_TEST_BOTTOM_CHAN0_TRAFFICGEN_TIMEOUT 	0x00000001
#define HBM_TEST_BOTTOM_CHAN0_TRAFFICGEN_FAIL 		0x00000002
#define HBM_TEST_BOTTOM_CHAN0_TRAFFICGEN_PASS 		0x00000004
#define HBM_TEST_BOTTOM_CHAN1_TRAFFICGEN_TIMEOUT	0x00000008
#define HBM_TEST_BOTTOM_CHAN1_TRAFFICGEN_FAIL		0x00000010
#define HBM_TEST_BOTTOM_CHAN1_TRAFFICGEN_PASS 		0x00000020
#define HBM_TEST_BOTTOM_CHAN0_TEST_NOT_RUNNING		(HBM_TEST_BOTTOM_CHAN0_TRAFFICGEN_TIMEOUT | HBM_TEST_BOTTOM_CHAN0_TRAFFICGEN_FAIL | HBM_TEST_BOTTOM_CHAN0_TRAFFICGEN_PASS)
#define HBM_TEST_BOTTOM_CHAN1_TEST_NOT_RUNNING		(HBM_TEST_BOTTOM_CHAN1_TRAFFICGEN_TIMEOUT | HBM_TEST_BOTTOM_CHAN1_TRAFFICGEN_FAIL | HBM_TEST_BOTTOM_CHAN1_TRAFFICGEN_PASS)

// HBM top defines
#define HBM_TEST_TOP_CHAN0_TRAFFICGEN_TIMEOUT 		0x00000100
#define HBM_TEST_TOP_CHAN0_TRAFFICGEN_FAIL 			0x00000200
#define HBM_TEST_TOP_CHAN0_TRAFFICGEN_PASS 			0x00000400
#define HBM_TEST_TOP_CHAN1_TRAFFICGEN_TIMEOUT		0x00000800
#define HBM_TEST_TOP_CHAN1_TRAFFICGEN_FAIL			0x00001000
#define HBM_TEST_TOP_CHAN1_TRAFFICGEN_PASS 			0x00002000
#define HBM_TEST_TOP_CHAN0_TEST_NOT_RUNNING			(HBM_TEST_TOP_CHAN0_TRAFFICGEN_TIMEOUT | HBM_TEST_TOP_CHAN0_TRAFFICGEN_FAIL | HBM_TEST_TOP_CHAN0_TRAFFICGEN_PASS)
#define HBM_TEST_TOP_CHAN1_TEST_NOT_RUNNING			(HBM_TEST_TOP_CHAN1_TRAFFICGEN_TIMEOUT | HBM_TEST_TOP_CHAN1_TRAFFICGEN_FAIL | HBM_TEST_TOP_CHAN1_TRAFFICGEN_PASS)

// Resets are active low
#define HBM_TEST_BOTTOM_WMC_NOT_RST					0x00010000
#define HBM_TEST_TOP_WMC_NOT_RST					0x01000000


#endif
