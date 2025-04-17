--------------------------------------------------------------------------------
--      Nallatech is providing this design, code, or information "as is",
--      solely for use on Nallatech systems and equipment. By providing
--      this design, code, or information as one possible implementation
--      of this feature, application or standard, NALLATECH IS MAKING NO
--      REPRESENTATION THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS
--      OF INFRINGEMENT, AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS
--      YOU MAY REQUIRE FOR YOUR IMPLEMENTATION. NALLATECH EXPRESSLY
--      DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF
--      THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES
--      OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS
--      OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND
--      FITNESS FOR A PARTICULAR PURPOSE.
--
--      USE OF SOFTWARE. This software contains elements of software code
--      which are the property of Nallatech Limited (Nallatech Software).
--      Use of the Nallatech Software by you is permitted only if you
--      hold a valid license from Nallatech Limited or a valid sub-license
--      from a licensee of Nallatech Limited. Use of such software shall
--      be governed by the terms of such license or sub-license agreement.
--      The Nallatech Software is for use solely on Nallatech hardware
--      unless you hold a license permitting use on other hardware.
--
--      This Nallatech Software is protected by copyright law and
--      international treaties. Unauthorized reproduction or distribution
--      of this software, or any portion of it, may result in severe civil
--      and criminal penalties, and will be prosecuted to the maximum
--      extent possible under law. Nallatech products are covered by one
--      or more patents. Other US and international patents pending.
--
--      Please see www.nallatech.com for more information.
--
--      Nallatech products are not intended for use in life support
--      appliances, devices, or systems. Use in such applications is
--      expressly prohibited.
--
--      Copyright © 1998-2020 Nallatech Limited. All rights reserved.
--
--      UNCLASSIFIED//FOR OFFICIAL USE ONLY
--------------------------------------------------------------------------------
-- $Id$
--------------------------------------------------------------------------------
--
--                         N
--                        NNN
--                       NNNNN
--                      NNNNNNN
--                     NNNN-NNNN          Nallatech
--                    NNNN---NNNN         (a molex company)
--                   NNNN-----NNNN
--                  NNNN-------NNNN
--                 NNNN---------NNNN
--                NNNNNNNN---NNNNNNNN
--               NNNNNNNNN---NNNNNNNNN
--                -------------------
--               ---------------------
--
--------------------------------------------------------------------------------
-- Title       : Package for User Registers
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : This package contains:
--
--            1/ A list of constants that indicates the allocated 12-bit memory
--               mapped addresses.
--
--            2/ A record of all the register status signals that pass between
--               the user application and the User Register component.
--
--
--------------------------------------------------------------------------------
-- Known Issues and Omissions:
--
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package pkg_user_registers is

  signal unused_gnd : std_logic_vector(127 downto 0) := (others => '0');

  --------------------------------------------
  -- Memory Mapped Addresses:
  --------------------------------------------
  constant DEVICE_STAT : std_logic_vector(11 downto 0) := x"000";
  constant TEST_REG_0  : std_logic_vector(11 downto 0) := x"004";
  constant TEST_REG_1  : std_logic_vector(11 downto 0) := x"008";
  constant TEST_REG_2  : std_logic_vector(11 downto 0) := x"00C";

  constant LED_CTRL    : std_logic_vector(11 downto 0) := x"010";
  constant COOKER_CTRL : std_logic_vector(11 downto 0) := x"014";
  constant CHIP_ID_L   : std_logic_vector(11 downto 0) := x"018";
  constant CHIP_ID_H   : std_logic_vector(11 downto 0) := x"01C";

  constant CLK_COUNT_STCL : std_logic_vector(11 downto 0) := x"020";
  constant CLK_COUNT_0    : std_logic_vector(11 downto 0) := x"024";
  constant CLK_COUNT_1    : std_logic_vector(11 downto 0) := x"028";
  constant CLK_COUNT_2    : std_logic_vector(11 downto 0) := x"02C";
  constant CLK_COUNT_3    : std_logic_vector(11 downto 0) := x"030";
  constant CLK_COUNT_4    : std_logic_vector(11 downto 0) := x"034";
  constant CLK_COUNT_5    : std_logic_vector(11 downto 0) := x"038";
  constant CLK_COUNT_6    : std_logic_vector(11 downto 0) := x"03C";
  constant CLK_COUNT_7    : std_logic_vector(11 downto 0) := x"040";
  constant CLK_COUNT_8    : std_logic_vector(11 downto 0) := x"044";
  constant CLK_COUNT_9    : std_logic_vector(11 downto 0) := x"048";
  constant CLK_COUNT_10   : std_logic_vector(11 downto 0) := x"04C";
  constant CLK_COUNT_11   : std_logic_vector(11 downto 0) := x"050";
  constant CLK_COUNT_12   : std_logic_vector(11 downto 0) := x"054";
  constant CLK_COUNT_13   : std_logic_vector(11 downto 0) := x"058";
  constant CLK_COUNT_14   : std_logic_vector(11 downto 0) := x"05C";
  constant CLK_COUNT_15   : std_logic_vector(11 downto 0) := x"060";
  constant CLK_COUNT_16   : std_logic_vector(11 downto 0) := x"064";
  constant CLK_COUNT_17   : std_logic_vector(11 downto 0) := x"068";
  constant CLK_COUNT_18   : std_logic_vector(11 downto 0) := x"06C";
  constant CLK_COUNT_19   : std_logic_vector(11 downto 0) := x"070";
  constant CLK_COUNT_20   : std_logic_vector(11 downto 0) := x"074";
  constant CLK_COUNT_21   : std_logic_vector(11 downto 0) := x"078";
  constant CLK_COUNT_22   : std_logic_vector(11 downto 0) := x"07C";

  constant TEMP_ADC_STCL  : std_logic_vector(11 downto 0) := x"080";
  constant TEMP_ADC_CHAN0 : std_logic_vector(11 downto 0) := x"084";
  constant TEMP_ADC_CHAN1 : std_logic_vector(11 downto 0) := x"088";
  constant TEMP_ADC_CHAN2 : std_logic_vector(11 downto 0) := x"08C";
  constant TEMP_ADC_CHAN3 : std_logic_vector(11 downto 0) := x"090";
  constant TEMP_ADC_CHAN4 : std_logic_vector(11 downto 0) := x"094";
  constant TEMP_ADC_CHAN5 : std_logic_vector(11 downto 0) := x"098";
  constant TEMP_ADC_CHAN6 : std_logic_vector(11 downto 0) := x"09C";
  constant TEMP_ADC_CHAN7 : std_logic_vector(11 downto 0) := x"0A0";
  constant TEMP_ADC_CHAN8 : std_logic_vector(11 downto 0) := x"0A4";

  constant VOLT_ADC_STCL  : std_logic_vector(11 downto 0) := x"0B0";
  constant VOLT_ADC_CHAN2 : std_logic_vector(11 downto 0) := x"0B4";
  constant VOLT_ADC_CHAN3 : std_logic_vector(11 downto 0) := x"0B8";
  constant VOLT_ADC_CHAN4 : std_logic_vector(11 downto 0) := x"0BC";
  constant VOLT_ADC_CHAN6 : std_logic_vector(11 downto 0) := x"0C0";
  constant VOLT_ADC_CHAN9 : std_logic_vector(11 downto 0) := x"0C4";

  constant OC0_GPIO     : std_logic_vector(11 downto 0) := x"0D0";
  constant OC1_GPIO     : std_logic_vector(11 downto 0) := x"0D4";
  constant OC_BUFF_CTRL : std_logic_vector(11 downto 0) := x"0D8";

  constant MEM0_CTRL               : std_logic_vector(11 downto 0) := x"100";
  constant MEM0_STATUS             : std_logic_vector(11 downto 0) := x"104";
  constant MEM0_TESTS_COMPLETED    : std_logic_vector(11 downto 0) := x"108";
  constant MEM0_ERROR_COUNT        : std_logic_vector(11 downto 0) := x"10C";
  constant MEM0_ERROR_BITS_L       : std_logic_vector(11 downto 0) := x"110";
  constant MEM0_ERROR_BITS_H       : std_logic_vector(11 downto 0) := x"114";
  constant MEM0_MEMORY_STATUS      : std_logic_vector(11 downto 0) := x"118";
  constant MEM0_ERROR_BITS_P       : std_logic_vector(11 downto 0) := x"11C";
  constant MEM0_RSLTS_CTRL_STATUS  : std_logic_vector(11 downto 0) := x"120";
  constant MEM0_RSLTS_ERR_ESS_BASE : std_logic_vector(11 downto 0) := x"124";
  constant MEM0_RSLTS_EXP_DATA0    : std_logic_vector(11 downto 0) := x"128";
  constant MEM0_RSLTS_EXP_DATA1    : std_logic_vector(11 downto 0) := x"12C";
  constant MEM0_RSLTS_EXP_DATA2    : std_logic_vector(11 downto 0) := x"130";
  constant MEM0_RSLTS_EXP_DATA3    : std_logic_vector(11 downto 0) := x"134";
  constant MEM0_RSLTS_EXP_DATA4    : std_logic_vector(11 downto 0) := x"138";
  constant MEM0_RSLTS_EXP_DATA5    : std_logic_vector(11 downto 0) := x"13C";
  constant MEM0_RSLTS_EXP_DATA6    : std_logic_vector(11 downto 0) := x"140";
  constant MEM0_RSLTS_EXP_DATA7    : std_logic_vector(11 downto 0) := x"144";
  constant MEM0_RSLTS_EXP_DATA8    : std_logic_vector(11 downto 0) := x"148";
  constant MEM0_RSLTS_EXP_DATA9    : std_logic_vector(11 downto 0) := x"14C";
  constant MEM0_RSLTS_EXP_DATA10   : std_logic_vector(11 downto 0) := x"150";
  constant MEM0_RSLTS_EXP_DATA11   : std_logic_vector(11 downto 0) := x"154";
  constant MEM0_RSLTS_EXP_DATA12   : std_logic_vector(11 downto 0) := x"158";
  constant MEM0_RSLTS_EXP_DATA13   : std_logic_vector(11 downto 0) := x"15C";
  constant MEM0_RSLTS_EXP_DATA14   : std_logic_vector(11 downto 0) := x"160";
  constant MEM0_RSLTS_EXP_DATA15   : std_logic_vector(11 downto 0) := x"164";
  constant MEM0_RSLTS_EXP_DATA16   : std_logic_vector(11 downto 0) := x"168";
  constant MEM0_RSLTS_EXP_DATA17   : std_logic_vector(11 downto 0) := x"16C";
  constant MEM0_RSLTS_EXP_DATA18   : std_logic_vector(11 downto 0) := x"170";
  constant MEM0_RSLTS_EXP_DATA19   : std_logic_vector(11 downto 0) := x"174";
  constant MEM0_RSLTS_EXP_DATA20   : std_logic_vector(11 downto 0) := x"178";
  constant MEM0_RSLTS_EXP_DATA21   : std_logic_vector(11 downto 0) := x"17C";
  constant MEM0_RSLTS_EXP_DATA22   : std_logic_vector(11 downto 0) := x"180";
  constant MEM0_RSLTS_EXP_DATA23   : std_logic_vector(11 downto 0) := x"184";
  constant MEM0_RSLTS_REC_DATA0    : std_logic_vector(11 downto 0) := x"188";
  constant MEM0_RSLTS_REC_DATA1    : std_logic_vector(11 downto 0) := x"18C";
  constant MEM0_RSLTS_REC_DATA2    : std_logic_vector(11 downto 0) := x"190";
  constant MEM0_RSLTS_REC_DATA3    : std_logic_vector(11 downto 0) := x"194";
  constant MEM0_RSLTS_REC_DATA4    : std_logic_vector(11 downto 0) := x"198";
  constant MEM0_RSLTS_REC_DATA5    : std_logic_vector(11 downto 0) := x"19C";
  constant MEM0_RSLTS_REC_DATA6    : std_logic_vector(11 downto 0) := x"1A0";
  constant MEM0_RSLTS_REC_DATA7    : std_logic_vector(11 downto 0) := x"1A4";
  constant MEM0_RSLTS_REC_DATA8    : std_logic_vector(11 downto 0) := x"1A8";
  constant MEM0_RSLTS_REC_DATA9    : std_logic_vector(11 downto 0) := x"1AC";
  constant MEM0_RSLTS_REC_DATA10   : std_logic_vector(11 downto 0) := x"1B0";
  constant MEM0_RSLTS_REC_DATA11   : std_logic_vector(11 downto 0) := x"1B4";
  constant MEM0_RSLTS_REC_DATA12   : std_logic_vector(11 downto 0) := x"1B8";
  constant MEM0_RSLTS_REC_DATA13   : std_logic_vector(11 downto 0) := x"1BC";
  constant MEM0_RSLTS_REC_DATA14   : std_logic_vector(11 downto 0) := x"1C0";
  constant MEM0_RSLTS_REC_DATA15   : std_logic_vector(11 downto 0) := x"1C4";
  constant MEM0_RSLTS_REC_DATA16   : std_logic_vector(11 downto 0) := x"1C8";
  constant MEM0_RSLTS_REC_DATA17   : std_logic_vector(11 downto 0) := x"1CC";
  constant MEM0_RSLTS_REC_DATA18   : std_logic_vector(11 downto 0) := x"1D0";
  constant MEM0_RSLTS_REC_DATA19   : std_logic_vector(11 downto 0) := x"1D4";
  constant MEM0_RSLTS_REC_DATA20   : std_logic_vector(11 downto 0) := x"1D8";
  constant MEM0_RSLTS_REC_DATA21   : std_logic_vector(11 downto 0) := x"1DC";
  constant MEM0_RSLTS_REC_DATA22   : std_logic_vector(11 downto 0) := x"1E0";
  constant MEM0_RSLTS_REC_DATA23   : std_logic_vector(11 downto 0) := x"1E4";

  constant MEM0_PP_STAT     : std_logic_vector(11 downto 0) := x"1E8";
  constant MEM0_PP_CTRL     : std_logic_vector(11 downto 0) := x"1EC";
  constant MEM0_PP_DEPTH    : std_logic_vector(11 downto 0) := x"1F0";
  constant MEM0_PP_SEND_BUF : std_logic_vector(11 downto 0) := x"1F4";
  constant MEM0_PP_READ_BUF : std_logic_vector(11 downto 0) := x"1F8";

  constant MEM1_CTRL               : std_logic_vector(11 downto 0) := x"200";
  constant MEM1_STATUS             : std_logic_vector(11 downto 0) := x"204";
  constant MEM1_TESTS_COMPLETED    : std_logic_vector(11 downto 0) := x"208";
  constant MEM1_ERROR_COUNT        : std_logic_vector(11 downto 0) := x"20C";
  constant MEM1_ERROR_BITS_L       : std_logic_vector(11 downto 0) := x"210";
  constant MEM1_ERROR_BITS_H       : std_logic_vector(11 downto 0) := x"214";
  constant MEM1_MEMORY_STATUS      : std_logic_vector(11 downto 0) := x"218";
  constant MEM1_ERROR_BITS_P       : std_logic_vector(11 downto 0) := x"21C";
  constant MEM1_RSLTS_CTRL_STATUS  : std_logic_vector(11 downto 0) := x"220";
  constant MEM1_RSLTS_ERR_ESS_BASE : std_logic_vector(11 downto 0) := x"224";
  constant MEM1_RSLTS_EXP_DATA0    : std_logic_vector(11 downto 0) := x"228";
  constant MEM1_RSLTS_EXP_DATA1    : std_logic_vector(11 downto 0) := x"22C";
  constant MEM1_RSLTS_EXP_DATA2    : std_logic_vector(11 downto 0) := x"230";
  constant MEM1_RSLTS_EXP_DATA3    : std_logic_vector(11 downto 0) := x"234";
  constant MEM1_RSLTS_EXP_DATA4    : std_logic_vector(11 downto 0) := x"238";
  constant MEM1_RSLTS_EXP_DATA5    : std_logic_vector(11 downto 0) := x"23C";
  constant MEM1_RSLTS_EXP_DATA6    : std_logic_vector(11 downto 0) := x"240";
  constant MEM1_RSLTS_EXP_DATA7    : std_logic_vector(11 downto 0) := x"244";
  constant MEM1_RSLTS_EXP_DATA8    : std_logic_vector(11 downto 0) := x"248";
  constant MEM1_RSLTS_EXP_DATA9    : std_logic_vector(11 downto 0) := x"24C";
  constant MEM1_RSLTS_EXP_DATA10   : std_logic_vector(11 downto 0) := x"250";
  constant MEM1_RSLTS_EXP_DATA11   : std_logic_vector(11 downto 0) := x"254";
  constant MEM1_RSLTS_EXP_DATA12   : std_logic_vector(11 downto 0) := x"258";
  constant MEM1_RSLTS_EXP_DATA13   : std_logic_vector(11 downto 0) := x"25C";
  constant MEM1_RSLTS_EXP_DATA14   : std_logic_vector(11 downto 0) := x"260";
  constant MEM1_RSLTS_EXP_DATA15   : std_logic_vector(11 downto 0) := x"264";
  constant MEM1_RSLTS_EXP_DATA16   : std_logic_vector(11 downto 0) := x"268";
  constant MEM1_RSLTS_EXP_DATA17   : std_logic_vector(11 downto 0) := x"26C";
  constant MEM1_RSLTS_EXP_DATA18   : std_logic_vector(11 downto 0) := x"270";
  constant MEM1_RSLTS_EXP_DATA19   : std_logic_vector(11 downto 0) := x"274";
  constant MEM1_RSLTS_EXP_DATA20   : std_logic_vector(11 downto 0) := x"278";
  constant MEM1_RSLTS_EXP_DATA21   : std_logic_vector(11 downto 0) := x"27C";
  constant MEM1_RSLTS_EXP_DATA22   : std_logic_vector(11 downto 0) := x"280";
  constant MEM1_RSLTS_EXP_DATA23   : std_logic_vector(11 downto 0) := x"284";
  constant MEM1_RSLTS_REC_DATA0    : std_logic_vector(11 downto 0) := x"288";
  constant MEM1_RSLTS_REC_DATA1    : std_logic_vector(11 downto 0) := x"28C";
  constant MEM1_RSLTS_REC_DATA2    : std_logic_vector(11 downto 0) := x"290";
  constant MEM1_RSLTS_REC_DATA3    : std_logic_vector(11 downto 0) := x"294";
  constant MEM1_RSLTS_REC_DATA4    : std_logic_vector(11 downto 0) := x"298";
  constant MEM1_RSLTS_REC_DATA5    : std_logic_vector(11 downto 0) := x"29C";
  constant MEM1_RSLTS_REC_DATA6    : std_logic_vector(11 downto 0) := x"2A0";
  constant MEM1_RSLTS_REC_DATA7    : std_logic_vector(11 downto 0) := x"2A4";
  constant MEM1_RSLTS_REC_DATA8    : std_logic_vector(11 downto 0) := x"2A8";
  constant MEM1_RSLTS_REC_DATA9    : std_logic_vector(11 downto 0) := x"2AC";
  constant MEM1_RSLTS_REC_DATA10   : std_logic_vector(11 downto 0) := x"2B0";
  constant MEM1_RSLTS_REC_DATA11   : std_logic_vector(11 downto 0) := x"2B4";
  constant MEM1_RSLTS_REC_DATA12   : std_logic_vector(11 downto 0) := x"2B8";
  constant MEM1_RSLTS_REC_DATA13   : std_logic_vector(11 downto 0) := x"2BC";
  constant MEM1_RSLTS_REC_DATA14   : std_logic_vector(11 downto 0) := x"2C0";
  constant MEM1_RSLTS_REC_DATA15   : std_logic_vector(11 downto 0) := x"2C4";
  constant MEM1_RSLTS_REC_DATA16   : std_logic_vector(11 downto 0) := x"2C8";
  constant MEM1_RSLTS_REC_DATA17   : std_logic_vector(11 downto 0) := x"2CC";
  constant MEM1_RSLTS_REC_DATA18   : std_logic_vector(11 downto 0) := x"2D0";
  constant MEM1_RSLTS_REC_DATA19   : std_logic_vector(11 downto 0) := x"2D4";
  constant MEM1_RSLTS_REC_DATA20   : std_logic_vector(11 downto 0) := x"2D8";
  constant MEM1_RSLTS_REC_DATA21   : std_logic_vector(11 downto 0) := x"2DC";
  constant MEM1_RSLTS_REC_DATA22   : std_logic_vector(11 downto 0) := x"2E0";
  constant MEM1_RSLTS_REC_DATA23   : std_logic_vector(11 downto 0) := x"2E4";

  constant MEM1_PP_STAT     : std_logic_vector(11 downto 0) := x"2E8";
  constant MEM1_PP_CTRL     : std_logic_vector(11 downto 0) := x"2EC";
  constant MEM1_PP_DEPTH    : std_logic_vector(11 downto 0) := x"2F0";
  constant MEM1_PP_SEND_BUF : std_logic_vector(11 downto 0) := x"2F4";
  constant MEM1_PP_READ_BUF : std_logic_vector(11 downto 0) := x"2F8";

  constant XCVR0_STAT            : std_logic_vector(11 downto 0) := x"500";
  constant XCVR0_CTRL            : std_logic_vector(11 downto 0) := x"504";
  constant XCVR0_PHY0_ERR_COUNTS : std_logic_vector(11 downto 0) := x"508";
  constant XCVR0_PHY1_ERR_COUNTS : std_logic_vector(11 downto 0) := x"50C";
  constant XCVR0_PHY2_ERR_COUNTS : std_logic_vector(11 downto 0) := x"510";
  constant XCVR0_PHY3_ERR_COUNTS : std_logic_vector(11 downto 0) := x"514";
  constant XCVR0_STATISTICS      : std_logic_vector(11 downto 0) := x"518";

  constant XCVR1_STAT            : std_logic_vector(11 downto 0) := x"520";
  constant XCVR1_CTRL            : std_logic_vector(11 downto 0) := x"524";
  constant XCVR1_PHY0_ERR_COUNTS : std_logic_vector(11 downto 0) := x"528";
  constant XCVR1_PHY1_ERR_COUNTS : std_logic_vector(11 downto 0) := x"52C";
  constant XCVR1_PHY2_ERR_COUNTS : std_logic_vector(11 downto 0) := x"530";
  constant XCVR1_PHY3_ERR_COUNTS : std_logic_vector(11 downto 0) := x"534";
  constant XCVR1_STATISTICS      : std_logic_vector(11 downto 0) := x"538";

  constant XCVR2_STAT            : std_logic_vector(11 downto 0) := x"540";
  constant XCVR2_CTRL            : std_logic_vector(11 downto 0) := x"544";
  constant XCVR2_PHY0_ERR_COUNTS : std_logic_vector(11 downto 0) := x"548";
  constant XCVR2_PHY1_ERR_COUNTS : std_logic_vector(11 downto 0) := x"54C";
  constant XCVR2_PHY2_ERR_COUNTS : std_logic_vector(11 downto 0) := x"550";
  constant XCVR2_PHY3_ERR_COUNTS : std_logic_vector(11 downto 0) := x"554";
  constant XCVR2_STATISTICS      : std_logic_vector(11 downto 0) := x"558";

  constant XCVR3_STAT            : std_logic_vector(11 downto 0) := x"560";
  constant XCVR3_CTRL            : std_logic_vector(11 downto 0) := x"564";
  constant XCVR3_PHY0_ERR_COUNTS : std_logic_vector(11 downto 0) := x"568";
  constant XCVR3_PHY1_ERR_COUNTS : std_logic_vector(11 downto 0) := x"56C";
  constant XCVR3_PHY2_ERR_COUNTS : std_logic_vector(11 downto 0) := x"570";
  constant XCVR3_PHY3_ERR_COUNTS : std_logic_vector(11 downto 0) := x"574";
  constant XCVR3_STATISTICS      : std_logic_vector(11 downto 0) := x"578";

  constant XCVR4_STAT            : std_logic_vector(11 downto 0) := x"600";
  constant XCVR4_CTRL            : std_logic_vector(11 downto 0) := x"604";
  constant XCVR4_PHY0_ERR_COUNTS : std_logic_vector(11 downto 0) := x"608";
  constant XCVR4_PHY1_ERR_COUNTS : std_logic_vector(11 downto 0) := x"60C";
  constant XCVR4_PHY2_ERR_COUNTS : std_logic_vector(11 downto 0) := x"610";
  constant XCVR4_PHY3_ERR_COUNTS : std_logic_vector(11 downto 0) := x"614";
  constant XCVR4_STATISTICS      : std_logic_vector(11 downto 0) := x"618";

  constant XCVR5_STAT            : std_logic_vector(11 downto 0) := x"700";
  constant XCVR5_CTRL            : std_logic_vector(11 downto 0) := x"704";
  constant XCVR5_PHY0_ERR_COUNTS : std_logic_vector(11 downto 0) := x"708";
  constant XCVR5_PHY1_ERR_COUNTS : std_logic_vector(11 downto 0) := x"70C";
  constant XCVR5_PHY2_ERR_COUNTS : std_logic_vector(11 downto 0) := x"710";
  constant XCVR5_PHY3_ERR_COUNTS : std_logic_vector(11 downto 0) := x"714";
  constant XCVR5_STATISTICS      : std_logic_vector(11 downto 0) := x"718";

  constant XCVR6_STAT            : std_logic_vector(11 downto 0) := x"800";
  constant XCVR6_CTRL            : std_logic_vector(11 downto 0) := x"804";
  constant XCVR6_PHY0_ERR_COUNTS : std_logic_vector(11 downto 0) := x"808";
  constant XCVR6_PHY1_ERR_COUNTS : std_logic_vector(11 downto 0) := x"80C";
  constant XCVR6_PHY2_ERR_COUNTS : std_logic_vector(11 downto 0) := x"810";
  constant XCVR6_PHY3_ERR_COUNTS : std_logic_vector(11 downto 0) := x"814";
  constant XCVR6_STATISTICS      : std_logic_vector(11 downto 0) := x"818";

  constant XCVR7_STAT            : std_logic_vector(11 downto 0) := x"900";
  constant XCVR7_CTRL            : std_logic_vector(11 downto 0) := x"904";
  constant XCVR7_PHY0_ERR_COUNTS : std_logic_vector(11 downto 0) := x"908";
  constant XCVR7_PHY1_ERR_COUNTS : std_logic_vector(11 downto 0) := x"90C";
  constant XCVR7_PHY2_ERR_COUNTS : std_logic_vector(11 downto 0) := x"910";
  constant XCVR7_PHY3_ERR_COUNTS : std_logic_vector(11 downto 0) := x"914";
  constant XCVR7_STATISTICS      : std_logic_vector(11 downto 0) := x"918";

  constant COOKER_PRESERVE : std_logic_vector(11 downto 0) := x"e00";

  -------------------------------------------------------------------------------
  -- Width parameters
  -------------------------------------------------------------------------------

  constant NUM_DDR4_IF        : integer := 2;
  constant NUM_XCVR_GRPS      : integer := 12;
  constant NUM_RSTS           : integer := 22;
  constant NUM_CLKS           : integer := 23;
  constant NUM_QSFP_GRPS      : integer := 4;
  constant NUM_VOLT_SAMP_REGS : integer := 16;
  constant NUM_TEMP_SAMP_REGS : integer := 16;

  -------------------------------------------------------------------------------
  -- Types
  -------------------------------------------------------------------------------

  type T_count_out is array (0 to NUM_CLKS-1) of std_logic_vector(31 downto 0);



  ----------------------------------------------------------------------
  -- Add all the register status signals to this record.
  ----------------------------------------------------------------------
  type T_user_registers is record

                             -- User Register Status
                             reg_chip_id_l : std_logic_vector(31 downto 0);
                             reg_chip_id_h : std_logic_vector(31 downto 0);

                             reg_count_stcl : std_logic_vector(31 downto 0);
                             reg_count_00   : std_logic_vector(31 downto 0);
                             reg_count_01   : std_logic_vector(31 downto 0);
                             reg_count_02   : std_logic_vector(31 downto 0);
                             reg_count_03   : std_logic_vector(31 downto 0);
                             reg_count_04   : std_logic_vector(31 downto 0);
                             reg_count_05   : std_logic_vector(31 downto 0);
                             reg_count_06   : std_logic_vector(31 downto 0);
                             reg_count_07   : std_logic_vector(31 downto 0);
                             reg_count_08   : std_logic_vector(31 downto 0);
                             reg_count_09   : std_logic_vector(31 downto 0);
                             reg_count_10   : std_logic_vector(31 downto 0);
                             reg_count_11   : std_logic_vector(31 downto 0);
                             reg_count_12   : std_logic_vector(31 downto 0);
                             reg_count_13   : std_logic_vector(31 downto 0);
                             reg_count_14   : std_logic_vector(31 downto 0);
                             reg_count_15   : std_logic_vector(31 downto 0);
                             reg_count_16   : std_logic_vector(31 downto 0);
                             reg_count_17   : std_logic_vector(31 downto 0);
                             reg_count_18   : std_logic_vector(31 downto 0);
                             reg_count_19   : std_logic_vector(31 downto 0);
                             reg_count_20   : std_logic_vector(31 downto 0);
                             reg_count_21   : std_logic_vector(31 downto 0);
                             reg_count_22   : std_logic_vector(31 downto 0);

                             reg_temp_stcl   : std_logic_vector(31 downto 0);
                             reg_temp_chan_0 : std_logic_vector(31 downto 0);
                             reg_temp_chan_1 : std_logic_vector(31 downto 0);
                             reg_temp_chan_2 : std_logic_vector(31 downto 0);
                             reg_temp_chan_3 : std_logic_vector(31 downto 0);
                             reg_temp_chan_4 : std_logic_vector(31 downto 0);
                             reg_temp_chan_5 : std_logic_vector(31 downto 0);
                             reg_temp_chan_6 : std_logic_vector(31 downto 0);
                             reg_temp_chan_7 : std_logic_vector(31 downto 0);
                             reg_temp_chan_8 : std_logic_vector(31 downto 0);

                             reg_volt_stcl   : std_logic_vector(31 downto 0);
                             reg_volt_chan_2 : std_logic_vector(31 downto 0);
                             reg_volt_chan_3 : std_logic_vector(31 downto 0);
                             reg_volt_chan_4 : std_logic_vector(31 downto 0);
                             reg_volt_chan_6 : std_logic_vector(31 downto 0);
                             reg_volt_chan_9 : std_logic_vector(31 downto 0);

                             reg_mem0_pp_stat     : std_logic_vector(31 downto 0);
                             reg_mem0_pp_ctrl     : std_logic_vector(31 downto 0);
                             reg_mem0_pp_depth    : std_logic_vector(31 downto 0);
                             reg_mem0_pp_send_buf : std_logic_vector(31 downto 0);
                             reg_mem0_pp_read_buf : std_logic_vector(31 downto 0);

                             reg_mem1_pp_stat     : std_logic_vector(31 downto 0);
                             reg_mem1_pp_ctrl     : std_logic_vector(31 downto 0);
                             reg_mem1_pp_depth    : std_logic_vector(31 downto 0);
                             reg_mem1_pp_send_buf : std_logic_vector(31 downto 0);
                             reg_mem1_pp_read_buf : std_logic_vector(31 downto 0);

                             reg_mem2_pp_stat     : std_logic_vector(31 downto 0);
                             reg_mem2_pp_ctrl     : std_logic_vector(31 downto 0);
                             reg_mem2_pp_depth    : std_logic_vector(31 downto 0);
                             reg_mem2_pp_send_buf : std_logic_vector(31 downto 0);
                             reg_mem2_pp_read_buf : std_logic_vector(31 downto 0);

                             reg_mem3_pp_stat     : std_logic_vector(31 downto 0);
                             reg_mem3_pp_ctrl     : std_logic_vector(31 downto 0);
                             reg_mem3_pp_depth    : std_logic_vector(31 downto 0);
                             reg_mem3_pp_send_buf : std_logic_vector(31 downto 0);
                             reg_mem3_pp_read_buf : std_logic_vector(31 downto 0);

                             reg_xcvr0_stat            : std_logic_vector(31 downto 0);
                             reg_xcvr0_ctrl            : std_logic_vector(31 downto 0);
                             reg_xcvr0_phy0_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr0_phy1_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr0_phy2_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr0_phy3_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr0_statistics      : std_logic_vector(31 downto 0);

                             reg_xcvr1_stat            : std_logic_vector(31 downto 0);
                             reg_xcvr1_ctrl            : std_logic_vector(31 downto 0);
                             reg_xcvr1_phy0_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr1_phy1_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr1_phy2_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr1_phy3_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr1_statistics      : std_logic_vector(31 downto 0);

                             reg_xcvr2_stat            : std_logic_vector(31 downto 0);
                             reg_xcvr2_ctrl            : std_logic_vector(31 downto 0);
                             reg_xcvr2_phy0_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr2_phy1_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr2_phy2_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr2_phy3_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr2_statistics      : std_logic_vector(31 downto 0);

                             reg_xcvr3_stat            : std_logic_vector(31 downto 0);
                             reg_xcvr3_ctrl            : std_logic_vector(31 downto 0);
                             reg_xcvr3_phy0_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr3_phy1_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr3_phy2_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr3_phy3_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr3_statistics      : std_logic_vector(31 downto 0);

                             reg_xcvr4_stat            : std_logic_vector(31 downto 0);
                             reg_xcvr4_ctrl            : std_logic_vector(31 downto 0);
                             reg_xcvr4_phy0_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr4_phy1_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr4_phy2_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr4_phy3_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr4_statistics      : std_logic_vector(31 downto 0);

                             reg_xcvr5_stat            : std_logic_vector(31 downto 0);
                             reg_xcvr5_ctrl            : std_logic_vector(31 downto 0);
                             reg_xcvr5_phy0_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr5_phy1_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr5_phy2_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr5_phy3_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr5_statistics      : std_logic_vector(31 downto 0);

                             reg_xcvr6_stat            : std_logic_vector(31 downto 0);
                             reg_xcvr6_ctrl            : std_logic_vector(31 downto 0);
                             reg_xcvr6_phy0_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr6_phy1_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr6_phy2_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr6_phy3_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr6_statistics      : std_logic_vector(31 downto 0);

                             reg_xcvr7_stat            : std_logic_vector(31 downto 0);
                             reg_xcvr7_ctrl            : std_logic_vector(31 downto 0);
                             reg_xcvr7_phy0_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr7_phy1_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr7_phy2_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr7_phy3_err_counts : std_logic_vector(31 downto 0);
                             reg_xcvr7_statistics      : std_logic_vector(31 downto 0);

                             reg_cook_preserve : std_logic_vector(31 downto 0);

                           end record;

  ----------------------------------------------------------------------
  -- Add all DDR4 SDRAM status signals to this record.
  ----------------------------------------------------------------------
  type T_mem_status is record

                         -- DDR4 SDRAM Status
                         reg_ctrl               : std_logic_vector(31 downto 0);
                         reg_status             : std_logic_vector(31 downto 0);
                         reg_tests_completed    : std_logic_vector(31 downto 0);
                         reg_error_count        : std_logic_vector(31 downto 0);
                         reg_error_bits_l       : std_logic_vector(31 downto 0);
                         reg_error_bits_h       : std_logic_vector(31 downto 0);
                         reg_memory_status      : std_logic_vector(31 downto 0);
                         reg_error_bits_p       : std_logic_vector(31 downto 0);
                         reg_rslts_ctrl_status  : std_logic_vector(31 downto 0);
                         reg_rslts_err_ess_base : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data0    : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data1    : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data2    : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data3    : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data4    : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data5    : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data6    : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data7    : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data8    : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data9    : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data10   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data11   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data12   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data13   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data14   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data15   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data16   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data17   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data18   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data19   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data20   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data21   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data22   : std_logic_vector(31 downto 0);
                         reg_rslts_exp_data23   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data0    : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data1    : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data2    : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data3    : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data4    : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data5    : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data6    : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data7    : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data8    : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data9    : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data10   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data11   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data12   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data13   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data14   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data15   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data16   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data17   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data18   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data19   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data20   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data21   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data22   : std_logic_vector(31 downto 0);
                         reg_rslts_rec_data23   : std_logic_vector(31 downto 0);

                       end record;

  ----------------------------------------------------------------------
  -- Records for Dynamic Reconfig Ports
  ----------------------------------------------------------------------
  type T_dr_phy is record

    waitrequest               : std_logic;
    readdata                  : std_logic_vector(31 downto 0);
    readdatavalid             : std_logic;
    writedata                 : std_logic_vector(31 downto 0);
    address                   : std_logic_vector(12 downto 0);
    write                     : std_logic;
    read                      : std_logic;

  end record;


end pkg_user_registers;


package body pkg_user_registers is
end pkg_user_registers;
