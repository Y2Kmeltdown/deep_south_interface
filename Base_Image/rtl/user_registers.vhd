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
--      Copyright © 1998-2019 Nallatech Limited. All rights reserved.
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
-- Title       : User Registers
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : This component provides the memory mapped status and control
--               register interface for the 520 BIST.
--
--               The user register interface is in the config_clk domain.
--               Depending on the user application it may be necessary to
--               transfer signals to and from a different clock domain. When
--               reading data, that data must be static when sampled by the
--               config_clk.
--
--               All register status signals are brought in via the record
--               called 'user_regs'. To add, remove or rename signals in this
--               record, the VHDL package pkg_user_registers must be updated.
--
--
--               Timing - Write without Slave Wait (standard)
--               --------------------------------------------
--               config_clk         __.--.__.--.__.--.__.--.__.--.__.  --.
--               avmm_write         _________.  -----.____________________
--               avmm_read          ____________________________________
--               avmm_address       xxxxxxxxx.AAAAA.xxxxxxxxxxxxxxxxxxxx
--               avmm_byteenable    xxxxxxxxx.BBBBB.xxxxxxxxxxxxxxxxxxxx
--               avmm_writedata     xxxxxxxxx.DDDDD.xxxxxxxxxxxxxxxxxxxx
--               avmm_waitrequest   ____________________________________
--               avmm_readdata      ____________________________________
--               avmm_readdatavalid ____________________________________
--               slave_wait         ____________________________________
--
--
--               Timing - Write with Slave Wait
--               ------------------------------
--               config_clk         __.--.__.--.__.--.__.--.__.--.__.  --.
--               avmm_write         _________.  -----------.______________
--               avmm_read          ____________________________________
--               avmm_address       xxxxxxxxx.AAAAAAAAAAA.xxxxxxxxxxxxxx
--               avmm_byteenable    xxxxxxxxx.BBBBBBBBBBB.xxxxxxxxxxxxxx
--               avmm_writedata     xxxxxxxxx.DDDDDDDDDDD.xxxxxxxxxxxxxx
--               avmm_waitrequest   ____________.  -----._________________
--               avmm_readdata      ____________________________________
--               avmm_readdatavalid ____________________________________
--               slave_wait         ___________.  -----.__________________
--
--
--               Timing - Read without Slave Wait (standard)
--               -------------------------------------------
--               config_clk         __.--.__.--.__.--.__.--.__.--.__.  --.
--               avmm_write         ____________________________________
--               avmm_read          _________.  -----------.______________
--               avmm_address       xxxxxxxxx.AAAAAAAAAAA.xxxxxxxxxxxxxx
--               avmm_byteenable    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
--               avmm_writedata     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
--               avmm_waitrequest   _________.  -----.____________________
--               avmm_readdata      _______________.DDDDD.______________
--               avmm_readdatavalid _______________.  -----.______________
--               slave_wait         ____________________________________
--
--
--               Timing - Read with Slave Wait
--               -----------------------------
--               config_clk         __.--.__.--.__.--.__.--.__.--.__.  --.
--               avmm_write         ____________________________________
--               avmm_read          _________.  -----------------.________
--               avmm_address       xxxxxxxxx.AAAAAAAAAAAAAAAAA.xxxxxxxx
--               avmm_byteenable    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
--               avmm_writedata     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
--               avmm_waitrequest   _________.  -----------.______________
--               avmm_readdata      _____________________.DDDDD.________
--               avmm_readdatavalid _____________________.  -----.________
--               slave_wait         ___________.  -----.__________________
--
--
--               Read and Write commands can be concatinated in any
--               combination.
--
--               The slave_wait input can be used to force an AvMM transaction
--               (read or write) to be held (avmm_waitrequest = '1') until
--               the slave is ready to proceed.
--
--
--------------------------------------------------------------------------------
-- Known Issues and Omissions :
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use work.pkg_user_registers.all;
use work.pkg_svn_revision.all;


entity user_registers is
  port (
    -- Clocks & Reset
    config_clk         : in  std_logic;
    config_rstn        : in  std_logic;
    -- PCIe Interface
    avmm_waitrequest   : out std_logic;
    avmm_readdata      : out std_logic_vector(31 downto 0);
    avmm_readdatavalid : out std_logic;
    avmm_burstcount    : in  std_logic_vector(0 downto 0);
    avmm_writedata     : in  std_logic_vector(31 downto 0);
    avmm_address       : in  std_logic_vector(11 downto 0);
    avmm_write         : in  std_logic;
    avmm_read          : in  std_logic;
    avmm_byteenable    : in  std_logic_vector(3 downto 0);
    -- Registers
    reg_0_out          : out std_logic_vector(31 downto 0);
    reg_1_out          : out std_logic_vector(31 downto 0);
    led_control        : out std_logic_vector(2 downto 0);
    cook_sreg          : out std_logic_vector(7 downto 0);
    cook_bram          : out std_logic_vector(7 downto 0);
    cook_dsp           : out std_logic_vector(7 downto 0);
    cook_size          : out std_logic_vector(1 downto 0);
    cook_cken          : out std_logic;
    slave_wait         : in  std_logic;
    -- OCuLink GPIO
    oc0_gpio_status    : in  std_logic_vector(15 downto 0);
    oc1_gpio_status    : in  std_logic_vector(15 downto 0);
    oc0_gpio_control   : out std_logic_vector(15 downto 0);
    oc1_gpio_control   : out std_logic_vector(15 downto 0);
    oc0_gpio_dir       : out std_logic_vector(15 downto 0);
    oc1_gpio_dir       : out std_logic_vector(15 downto 0);
    oc0_gpio_dir_ext   : out std_logic_vector(15 downto 0);
    oc1_gpio_dir_ext   : out std_logic_vector(15 downto 0);
    oc_buff_en_n       : out std_logic_vector(7 downto 2);
    opci_buff_in_sel   : out std_logic_vector(3 downto 2);
    oc_perst_n         : in  std_logic_vector(3 downto 2);
    fpga_gpio_1        : in  std_logic;
    fpga_rst_n         : in  std_logic;
    qsfp_irq_n         : in  std_logic_vector(3 downto 0);
    user_regs          : in  T_user_registers;
    dout_mem0          : in  T_mem_status;
    dout_mem1          : in  T_mem_status
    );
end entity user_registers;


architecture rtl of user_registers is
  -----------
  -- Signals
  -----------
  signal read_ctrl               : std_logic                     := '0';
  signal read_reg                : std_logic_vector(31 downto 0) := (others => '0');
  signal reg_0                   : std_logic_vector(31 downto 0) := (others => '0');
  signal reg_1                   : std_logic_vector(31 downto 0) := (others => '0');
  signal led_ctrl_reg            : std_logic_vector(2 downto 0)  := (others => '0');
  signal reg_cook_sreg           : std_logic_vector(7 downto 0)  := (others => '0');
  signal reg_cook_bram           : std_logic_vector(7 downto 0)  := (others => '0');
  signal reg_cook_dsp            : std_logic_vector(7 downto 0)  := (others => '0');
  signal reg_cook_size           : std_logic_vector(1 downto 0)  := (others => '0');
  signal reg_cook_cken           : std_logic                     := '0';
  signal reg_oc0_gpio_control    : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc1_gpio_control    : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc0_gpio_dir        : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc1_gpio_dir        : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc0_gpio_dir_ext    : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc1_gpio_dir_ext    : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc0_gpio_control_d1 : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc1_gpio_control_d1 : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc0_gpio_dir_d1     : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc1_gpio_dir_d1     : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc1_gpio_dir_ext_d1 : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc0_gpio_dir_ext_d1 : std_logic_vector(15 downto 0) := (others => '0');
  signal reg_oc_buff_en          : std_logic_vector(7 downto 2)  := (others => '0');
  signal reg_buff_in_sel         : std_logic_vector(3 downto 2)  := (others => '0');



begin
  -------------
  -- Registers
  -------------
  process(config_clk)
  begin
    if rising_edge(config_clk) then
      -- Register Write
      if config_rstn = '0' then
        reg_0                <= (others => '0');
        reg_1                <= (others => '0');
        led_ctrl_reg         <= (others => '0');
        reg_cook_sreg        <= (others => '0');
        reg_cook_bram        <= (others => '0');
        reg_cook_dsp         <= (others => '0');
        reg_cook_size        <= (others => '0');
        reg_cook_cken        <= '0';
        reg_oc0_gpio_control <= (others => '0');
        reg_oc1_gpio_control <= (others => '0');
        reg_oc0_gpio_dir     <= (others => '0');
        reg_oc1_gpio_dir     <= (others => '0');
        reg_oc0_gpio_dir_ext <= (others => '0');
        reg_oc1_gpio_dir_ext <= (others => '0');
        reg_oc_buff_en       <= (others => '0');
        reg_buff_in_sel      <= (others => '0');


      elsif avmm_write = '1' then
        if (avmm_address = TEST_REG_0) then
          for i in 0 to 3 loop
            if avmm_byteenable(i) = '1' then
              reg_0((8*i)+7 downto 8*i) <= avmm_writedata((8*i)+7 downto 8*i);
            end if;
          end loop;
        end if;

        if (avmm_address = TEST_REG_1) then
          for i in 0 to 3 loop
            if avmm_byteenable(i) = '1' then
              reg_1((8*i)+7 downto 8*i) <= avmm_writedata((8*i)+7 downto 8*i);
            end if;
          end loop;
        end if;

        if (avmm_address = LED_CTRL) then
          if avmm_byteenable(0) = '1' then
            led_ctrl_reg <= avmm_writedata(2 downto 0);
          end if;
        end if;

        if (avmm_address = OC0_GPIO) then
          if avmm_byteenable(0) = '1' then
            reg_oc0_gpio_control(07 downto 00) <= avmm_writedata(07 downto 00);
          end if;
          if avmm_byteenable(1) = '1' then
            reg_oc0_gpio_control(15 downto 08) <= avmm_writedata(15 downto 08);
          end if;
          if avmm_byteenable(2) = '1' then
            reg_oc0_gpio_dir(07 downto 00)     <= avmm_writedata(23 downto 16);
            reg_oc0_gpio_dir_ext(07 downto 00) <= avmm_writedata(23 downto 16);
          end if;
          if avmm_byteenable(3) = '1' then
            reg_oc0_gpio_dir(15 downto 08)     <= avmm_writedata(31 downto 24);
            reg_oc0_gpio_dir_ext(15 downto 08) <= avmm_writedata(31 downto 24);
          end if;
        end if;

        if (avmm_address = OC1_GPIO) then
          if avmm_byteenable(0) = '1' then
            reg_oc1_gpio_control(07 downto 00) <= avmm_writedata(07 downto 00);
          end if;
          if avmm_byteenable(1) = '1' then
            reg_oc1_gpio_control(15 downto 08) <= avmm_writedata(15 downto 08);
          end if;
          if avmm_byteenable(2) = '1' then
            reg_oc1_gpio_dir(07 downto 00)     <= avmm_writedata(23 downto 16);
            reg_oc1_gpio_dir_ext(07 downto 00) <= avmm_writedata(23 downto 16);
          end if;
          if avmm_byteenable(3) = '1' then
            reg_oc1_gpio_dir(15 downto 08)     <= avmm_writedata(31 downto 24);
            reg_oc1_gpio_dir_ext(15 downto 08) <= avmm_writedata(31 downto 24);
          end if;
        end if;

        if (avmm_address = OC_BUFF_CTRL) then
          if avmm_byteenable(0) = '1' then
            reg_oc_buff_en  <= avmm_writedata(7 downto 2);
          end if;
          if avmm_byteenable(1) = '1' then
            reg_buff_in_sel <= avmm_writedata(11 downto 10);
          end if;
        end if;

        if (avmm_address = COOKER_CTRL) then
          if avmm_byteenable(0) = '1' then
            reg_cook_sreg <= avmm_writedata(7 downto 0);
          end if;
          if avmm_byteenable(1) = '1' then
            reg_cook_bram <= avmm_writedata(15 downto 8);
          end if;
          if avmm_byteenable(2) = '1' then
            reg_cook_dsp  <= avmm_writedata(23 downto 16);
          end if;
          if avmm_byteenable(3) = '1' then
            reg_cook_size <= avmm_writedata(25 downto 24);
            reg_cook_cken <= avmm_writedata(31);
          end if;
        end if;
      end if;

      -- Register Read
      if (config_rstn = '0') or (avmm_read = '0') then
        read_ctrl <= '0';
      else
        read_ctrl <= read_ctrl nor slave_wait;
      end if;

      if avmm_read = '1' then
        case avmm_address is
          when DEVICE_STAT    => read_reg <= (BIST_ID & REV_MAJOR & SVN_REVISION);

          when TEST_REG_0     => read_reg <= reg_0;
          when TEST_REG_1     => read_reg <= reg_1;
          when TEST_REG_2     => read_reg <= not reg_0;

          when LED_CTRL       => read_reg <= (x"0000000" & '0' & led_ctrl_reg);

          when OC0_GPIO       => read_reg <= (reg_oc0_gpio_dir(15 downto 10) & unused_gnd(9 downto 8) &
                                              reg_oc0_gpio_dir(7 downto 4) & unused_gnd(3 downto 0) &
                                              oc0_gpio_status);
          when OC1_GPIO       => read_reg <= (reg_oc1_gpio_dir(15 downto 10) & unused_gnd(9 downto 8) &
                                              reg_oc1_gpio_dir(7 downto 4) & unused_gnd(3 downto 0) &
                                              oc1_gpio_status);
          when OC_BUFF_CTRL   => read_reg <= (x"00" & not qsfp_irq_n &
                                              fpga_gpio_1 & not fpga_rst_n & unused_gnd(17 downto 16) &
                                              not oc_perst_n & unused_gnd(13 downto 12) &
                                              reg_buff_in_sel & unused_gnd(9 downto 8) &
                                              reg_oc_buff_en & unused_gnd(1 downto 0));

          when COOKER_CTRL    => read_reg <= (reg_cook_cken & "00000" & reg_cook_size &
                                              reg_cook_dsp & reg_cook_bram & reg_cook_sreg);

          when CHIP_ID_L      => read_reg <= user_regs.reg_chip_id_l;
          when CHIP_ID_H      => read_reg <= user_regs.reg_chip_id_h;

          when CLK_COUNT_STCL => read_reg <= user_regs.reg_count_stcl;
          when CLK_COUNT_0    => read_reg <= user_regs.reg_count_00;
          when CLK_COUNT_1    => read_reg <= user_regs.reg_count_01;
          when CLK_COUNT_2    => read_reg <= user_regs.reg_count_02;
          when CLK_COUNT_3    => read_reg <= user_regs.reg_count_03;
          when CLK_COUNT_4    => read_reg <= user_regs.reg_count_04;
          when CLK_COUNT_5    => read_reg <= user_regs.reg_count_05;
          when CLK_COUNT_6    => read_reg <= user_regs.reg_count_06;
          when CLK_COUNT_7    => read_reg <= user_regs.reg_count_07;
          when CLK_COUNT_8    => read_reg <= user_regs.reg_count_08;
          when CLK_COUNT_9    => read_reg <= user_regs.reg_count_09;
          when CLK_COUNT_10   => read_reg <= user_regs.reg_count_10;
          when CLK_COUNT_11   => read_reg <= user_regs.reg_count_11;
          when CLK_COUNT_12   => read_reg <= user_regs.reg_count_12;
          when CLK_COUNT_13   => read_reg <= user_regs.reg_count_13;
          when CLK_COUNT_14   => read_reg <= user_regs.reg_count_14;
          when CLK_COUNT_15   => read_reg <= user_regs.reg_count_15;
          when CLK_COUNT_16   => read_reg <= user_regs.reg_count_16;
          when CLK_COUNT_17   => read_reg <= user_regs.reg_count_17;
          when CLK_COUNT_18   => read_reg <= user_regs.reg_count_18;
          when CLK_COUNT_19   => read_reg <= user_regs.reg_count_19;
          when CLK_COUNT_20   => read_reg <= user_regs.reg_count_20;
          when CLK_COUNT_21   => read_reg <= user_regs.reg_count_21;
          when CLK_COUNT_22   => read_reg <= user_regs.reg_count_22;

          when TEMP_ADC_STCL  => read_reg <= user_regs.reg_temp_stcl;
          when TEMP_ADC_CHAN0 => read_reg <= user_regs.reg_temp_chan_0;
          when TEMP_ADC_CHAN1 => read_reg <= user_regs.reg_temp_chan_1;
          when TEMP_ADC_CHAN2 => read_reg <= user_regs.reg_temp_chan_2;
          when TEMP_ADC_CHAN3 => read_reg <= user_regs.reg_temp_chan_3;
          when TEMP_ADC_CHAN4 => read_reg <= user_regs.reg_temp_chan_4;
          when TEMP_ADC_CHAN5 => read_reg <= user_regs.reg_temp_chan_5;
          when TEMP_ADC_CHAN6 => read_reg <= user_regs.reg_temp_chan_6;
          when TEMP_ADC_CHAN7 => read_reg <= user_regs.reg_temp_chan_7;
          when TEMP_ADC_CHAN8 => read_reg <= user_regs.reg_temp_chan_8;

          when VOLT_ADC_STCL  => read_reg <= user_regs.reg_volt_stcl;
          when VOLT_ADC_CHAN2 => read_reg <= user_regs.reg_volt_chan_2;
          when VOLT_ADC_CHAN3 => read_reg <= user_regs.reg_volt_chan_3;
          when VOLT_ADC_CHAN4 => read_reg <= user_regs.reg_volt_chan_4;
          when VOLT_ADC_CHAN6 => read_reg <= user_regs.reg_volt_chan_6;
          when VOLT_ADC_CHAN9 => read_reg <= user_regs.reg_volt_chan_9;

          when MEM0_CTRL               => read_reg <= dout_mem0.reg_ctrl;
          when MEM0_STATUS             => read_reg <= dout_mem0.reg_status;
          when MEM0_TESTS_COMPLETED    => read_reg <= dout_mem0.reg_tests_completed;
          when MEM0_ERROR_COUNT        => read_reg <= dout_mem0.reg_error_count;
          when MEM0_ERROR_BITS_L       => read_reg <= dout_mem0.reg_error_bits_l;
          when MEM0_ERROR_BITS_H       => read_reg <= dout_mem0.reg_error_bits_h;
          when MEM0_MEMORY_STATUS      => read_reg <= dout_mem0.reg_memory_status;
          when MEM0_ERROR_BITS_P       => read_reg <= dout_mem0.reg_error_bits_p;
          when MEM0_RSLTS_CTRL_STATUS  => read_reg <= dout_mem0.reg_rslts_ctrl_status;
          when MEM0_RSLTS_ERR_ESS_BASE => read_reg <= dout_mem0.reg_rslts_err_ess_base;
          when MEM0_RSLTS_EXP_DATA0    => read_reg <= dout_mem0.reg_rslts_exp_data0;
          when MEM0_RSLTS_EXP_DATA1    => read_reg <= dout_mem0.reg_rslts_exp_data1;
          when MEM0_RSLTS_EXP_DATA2    => read_reg <= dout_mem0.reg_rslts_exp_data2;
          when MEM0_RSLTS_EXP_DATA3    => read_reg <= dout_mem0.reg_rslts_exp_data3;
          when MEM0_RSLTS_EXP_DATA4    => read_reg <= dout_mem0.reg_rslts_exp_data4;
          when MEM0_RSLTS_EXP_DATA5    => read_reg <= dout_mem0.reg_rslts_exp_data5;
          when MEM0_RSLTS_EXP_DATA6    => read_reg <= dout_mem0.reg_rslts_exp_data6;
          when MEM0_RSLTS_EXP_DATA7    => read_reg <= dout_mem0.reg_rslts_exp_data7;
          when MEM0_RSLTS_EXP_DATA8    => read_reg <= dout_mem0.reg_rslts_exp_data8;
          when MEM0_RSLTS_EXP_DATA9    => read_reg <= dout_mem0.reg_rslts_exp_data9;
          when MEM0_RSLTS_EXP_DATA10   => read_reg <= dout_mem0.reg_rslts_exp_data10;
          when MEM0_RSLTS_EXP_DATA11   => read_reg <= dout_mem0.reg_rslts_exp_data11;
          when MEM0_RSLTS_EXP_DATA12   => read_reg <= dout_mem0.reg_rslts_exp_data12;
          when MEM0_RSLTS_EXP_DATA13   => read_reg <= dout_mem0.reg_rslts_exp_data13;
          when MEM0_RSLTS_EXP_DATA14   => read_reg <= dout_mem0.reg_rslts_exp_data14;
          when MEM0_RSLTS_EXP_DATA15   => read_reg <= dout_mem0.reg_rslts_exp_data15;
          when MEM0_RSLTS_EXP_DATA16   => read_reg <= dout_mem0.reg_rslts_exp_data16;
          when MEM0_RSLTS_EXP_DATA17   => read_reg <= dout_mem0.reg_rslts_exp_data17;
          when MEM0_RSLTS_EXP_DATA18   => read_reg <= dout_mem0.reg_rslts_exp_data18;
          when MEM0_RSLTS_EXP_DATA19   => read_reg <= dout_mem0.reg_rslts_exp_data19;
          when MEM0_RSLTS_EXP_DATA20   => read_reg <= dout_mem0.reg_rslts_exp_data20;
          when MEM0_RSLTS_EXP_DATA21   => read_reg <= dout_mem0.reg_rslts_exp_data21;
          when MEM0_RSLTS_EXP_DATA22   => read_reg <= dout_mem0.reg_rslts_exp_data22;
          when MEM0_RSLTS_EXP_DATA23   => read_reg <= dout_mem0.reg_rslts_exp_data23;
          when MEM0_RSLTS_REC_DATA0    => read_reg <= dout_mem0.reg_rslts_rec_data0;
          when MEM0_RSLTS_REC_DATA1    => read_reg <= dout_mem0.reg_rslts_rec_data1;
          when MEM0_RSLTS_REC_DATA2    => read_reg <= dout_mem0.reg_rslts_rec_data2;
          when MEM0_RSLTS_REC_DATA3    => read_reg <= dout_mem0.reg_rslts_rec_data3;
          when MEM0_RSLTS_REC_DATA4    => read_reg <= dout_mem0.reg_rslts_rec_data4;
          when MEM0_RSLTS_REC_DATA5    => read_reg <= dout_mem0.reg_rslts_rec_data5;
          when MEM0_RSLTS_REC_DATA6    => read_reg <= dout_mem0.reg_rslts_rec_data6;
          when MEM0_RSLTS_REC_DATA7    => read_reg <= dout_mem0.reg_rslts_rec_data7;
          when MEM0_RSLTS_REC_DATA8    => read_reg <= dout_mem0.reg_rslts_rec_data8;
          when MEM0_RSLTS_REC_DATA9    => read_reg <= dout_mem0.reg_rslts_rec_data9;
          when MEM0_RSLTS_REC_DATA10   => read_reg <= dout_mem0.reg_rslts_rec_data10;
          when MEM0_RSLTS_REC_DATA11   => read_reg <= dout_mem0.reg_rslts_rec_data11;
          when MEM0_RSLTS_REC_DATA12   => read_reg <= dout_mem0.reg_rslts_rec_data12;
          when MEM0_RSLTS_REC_DATA13   => read_reg <= dout_mem0.reg_rslts_rec_data13;
          when MEM0_RSLTS_REC_DATA14   => read_reg <= dout_mem0.reg_rslts_rec_data14;
          when MEM0_RSLTS_REC_DATA15   => read_reg <= dout_mem0.reg_rslts_rec_data15;
          when MEM0_RSLTS_REC_DATA16   => read_reg <= dout_mem0.reg_rslts_rec_data16;
          when MEM0_RSLTS_REC_DATA17   => read_reg <= dout_mem0.reg_rslts_rec_data17;
          when MEM0_RSLTS_REC_DATA18   => read_reg <= dout_mem0.reg_rslts_rec_data18;
          when MEM0_RSLTS_REC_DATA19   => read_reg <= dout_mem0.reg_rslts_rec_data19;
          when MEM0_RSLTS_REC_DATA20   => read_reg <= dout_mem0.reg_rslts_rec_data20;
          when MEM0_RSLTS_REC_DATA21   => read_reg <= dout_mem0.reg_rslts_rec_data21;
          when MEM0_RSLTS_REC_DATA22   => read_reg <= dout_mem0.reg_rslts_rec_data22;
          when MEM0_RSLTS_REC_DATA23   => read_reg <= dout_mem0.reg_rslts_rec_data23;

          when MEM0_PP_STAT            => read_reg <= user_regs.reg_mem0_pp_stat;
          when MEM0_PP_CTRL            => read_reg <= user_regs.reg_mem0_pp_ctrl;
          when MEM0_PP_DEPTH           => read_reg <= user_regs.reg_mem0_pp_depth;
          when MEM0_PP_SEND_BUF        => read_reg <= user_regs.reg_mem0_pp_send_buf;
          when MEM0_PP_READ_BUF        => read_reg <= user_regs.reg_mem0_pp_read_buf;

          when MEM1_CTRL               => read_reg <= dout_mem1.reg_ctrl;
          when MEM1_STATUS             => read_reg <= dout_mem1.reg_status;
          when MEM1_TESTS_COMPLETED    => read_reg <= dout_mem1.reg_tests_completed;
          when MEM1_ERROR_COUNT        => read_reg <= dout_mem1.reg_error_count;
          when MEM1_ERROR_BITS_L       => read_reg <= dout_mem1.reg_error_bits_l;
          when MEM1_ERROR_BITS_H       => read_reg <= dout_mem1.reg_error_bits_h;
          when MEM1_MEMORY_STATUS      => read_reg <= dout_mem1.reg_memory_status;
          when MEM1_ERROR_BITS_P       => read_reg <= dout_mem1.reg_error_bits_p;
          when MEM1_RSLTS_CTRL_STATUS  => read_reg <= dout_mem1.reg_rslts_ctrl_status;
          when MEM1_RSLTS_ERR_ESS_BASE => read_reg <= dout_mem1.reg_rslts_err_ess_base;
          when MEM1_RSLTS_EXP_DATA0    => read_reg <= dout_mem1.reg_rslts_exp_data0;
          when MEM1_RSLTS_EXP_DATA1    => read_reg <= dout_mem1.reg_rslts_exp_data1;
          when MEM1_RSLTS_EXP_DATA2    => read_reg <= dout_mem1.reg_rslts_exp_data2;
          when MEM1_RSLTS_EXP_DATA3    => read_reg <= dout_mem1.reg_rslts_exp_data3;
          when MEM1_RSLTS_EXP_DATA4    => read_reg <= dout_mem1.reg_rslts_exp_data4;
          when MEM1_RSLTS_EXP_DATA5    => read_reg <= dout_mem1.reg_rslts_exp_data5;
          when MEM1_RSLTS_EXP_DATA6    => read_reg <= dout_mem1.reg_rslts_exp_data6;
          when MEM1_RSLTS_EXP_DATA7    => read_reg <= dout_mem1.reg_rslts_exp_data7;
          when MEM1_RSLTS_EXP_DATA8    => read_reg <= dout_mem1.reg_rslts_exp_data8;
          when MEM1_RSLTS_EXP_DATA9    => read_reg <= dout_mem1.reg_rslts_exp_data9;
          when MEM1_RSLTS_EXP_DATA10   => read_reg <= dout_mem1.reg_rslts_exp_data10;
          when MEM1_RSLTS_EXP_DATA11   => read_reg <= dout_mem1.reg_rslts_exp_data11;
          when MEM1_RSLTS_EXP_DATA12   => read_reg <= dout_mem1.reg_rslts_exp_data12;
          when MEM1_RSLTS_EXP_DATA13   => read_reg <= dout_mem1.reg_rslts_exp_data13;
          when MEM1_RSLTS_EXP_DATA14   => read_reg <= dout_mem1.reg_rslts_exp_data14;
          when MEM1_RSLTS_EXP_DATA15   => read_reg <= dout_mem1.reg_rslts_exp_data15;
          when MEM1_RSLTS_EXP_DATA16   => read_reg <= dout_mem1.reg_rslts_exp_data16;
          when MEM1_RSLTS_EXP_DATA17   => read_reg <= dout_mem1.reg_rslts_exp_data17;
          when MEM1_RSLTS_EXP_DATA18   => read_reg <= dout_mem1.reg_rslts_exp_data18;
          when MEM1_RSLTS_EXP_DATA19   => read_reg <= dout_mem1.reg_rslts_exp_data19;
          when MEM1_RSLTS_EXP_DATA20   => read_reg <= dout_mem1.reg_rslts_exp_data20;
          when MEM1_RSLTS_EXP_DATA21   => read_reg <= dout_mem1.reg_rslts_exp_data21;
          when MEM1_RSLTS_EXP_DATA22   => read_reg <= dout_mem1.reg_rslts_exp_data22;
          when MEM1_RSLTS_EXP_DATA23   => read_reg <= dout_mem1.reg_rslts_exp_data23;
          when MEM1_RSLTS_REC_DATA0    => read_reg <= dout_mem1.reg_rslts_rec_data0;
          when MEM1_RSLTS_REC_DATA1    => read_reg <= dout_mem1.reg_rslts_rec_data1;
          when MEM1_RSLTS_REC_DATA2    => read_reg <= dout_mem1.reg_rslts_rec_data2;
          when MEM1_RSLTS_REC_DATA3    => read_reg <= dout_mem1.reg_rslts_rec_data3;
          when MEM1_RSLTS_REC_DATA4    => read_reg <= dout_mem1.reg_rslts_rec_data4;
          when MEM1_RSLTS_REC_DATA5    => read_reg <= dout_mem1.reg_rslts_rec_data5;
          when MEM1_RSLTS_REC_DATA6    => read_reg <= dout_mem1.reg_rslts_rec_data6;
          when MEM1_RSLTS_REC_DATA7    => read_reg <= dout_mem1.reg_rslts_rec_data7;
          when MEM1_RSLTS_REC_DATA8    => read_reg <= dout_mem1.reg_rslts_rec_data8;
          when MEM1_RSLTS_REC_DATA9    => read_reg <= dout_mem1.reg_rslts_rec_data9;
          when MEM1_RSLTS_REC_DATA10   => read_reg <= dout_mem1.reg_rslts_rec_data10;
          when MEM1_RSLTS_REC_DATA11   => read_reg <= dout_mem1.reg_rslts_rec_data11;
          when MEM1_RSLTS_REC_DATA12   => read_reg <= dout_mem1.reg_rslts_rec_data12;
          when MEM1_RSLTS_REC_DATA13   => read_reg <= dout_mem1.reg_rslts_rec_data13;
          when MEM1_RSLTS_REC_DATA14   => read_reg <= dout_mem1.reg_rslts_rec_data14;
          when MEM1_RSLTS_REC_DATA15   => read_reg <= dout_mem1.reg_rslts_rec_data15;
          when MEM1_RSLTS_REC_DATA16   => read_reg <= dout_mem1.reg_rslts_rec_data16;
          when MEM1_RSLTS_REC_DATA17   => read_reg <= dout_mem1.reg_rslts_rec_data17;
          when MEM1_RSLTS_REC_DATA18   => read_reg <= dout_mem1.reg_rslts_rec_data18;
          when MEM1_RSLTS_REC_DATA19   => read_reg <= dout_mem1.reg_rslts_rec_data19;
          when MEM1_RSLTS_REC_DATA20   => read_reg <= dout_mem1.reg_rslts_rec_data20;
          when MEM1_RSLTS_REC_DATA21   => read_reg <= dout_mem1.reg_rslts_rec_data21;
          when MEM1_RSLTS_REC_DATA22   => read_reg <= dout_mem1.reg_rslts_rec_data22;
          when MEM1_RSLTS_REC_DATA23   => read_reg <= dout_mem1.reg_rslts_rec_data23;

          when MEM1_PP_STAT            => read_reg <= user_regs.reg_mem1_pp_stat;
          when MEM1_PP_CTRL            => read_reg <= user_regs.reg_mem1_pp_ctrl;
          when MEM1_PP_DEPTH           => read_reg <= user_regs.reg_mem1_pp_depth;
          when MEM1_PP_SEND_BUF        => read_reg <= user_regs.reg_mem1_pp_send_buf;
          when MEM1_PP_READ_BUF        => read_reg <= user_regs.reg_mem1_pp_read_buf;

          when XCVR0_STAT              => read_reg <= user_regs.reg_xcvr0_stat;
          when XCVR0_CTRL              => read_reg <= user_regs.reg_xcvr0_ctrl;
          when XCVR0_PHY0_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr0_phy0_err_counts;
          when XCVR0_PHY1_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr0_phy1_err_counts;
          when XCVR0_PHY2_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr0_phy2_err_counts;
          when XCVR0_PHY3_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr0_phy3_err_counts;
          when XCVR0_STATISTICS        => read_reg <= user_regs.reg_xcvr0_statistics;

          when XCVR1_STAT              => read_reg <= user_regs.reg_xcvr1_stat;
          when XCVR1_CTRL              => read_reg <= user_regs.reg_xcvr1_ctrl;
          when XCVR1_PHY0_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr1_phy0_err_counts;
          when XCVR1_PHY1_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr1_phy1_err_counts;
          when XCVR1_PHY2_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr1_phy2_err_counts;
          when XCVR1_PHY3_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr1_phy3_err_counts;
          when XCVR1_STATISTICS        => read_reg <= user_regs.reg_xcvr1_statistics;

          when XCVR2_STAT              => read_reg <= user_regs.reg_xcvr2_stat;
          when XCVR2_CTRL              => read_reg <= user_regs.reg_xcvr2_ctrl;
          when XCVR2_PHY0_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr2_phy0_err_counts;
          when XCVR2_PHY1_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr2_phy1_err_counts;
          when XCVR2_PHY2_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr2_phy2_err_counts;
          when XCVR2_PHY3_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr2_phy3_err_counts;
          when XCVR2_STATISTICS        => read_reg <= user_regs.reg_xcvr2_statistics;

          when XCVR3_STAT              => read_reg <= user_regs.reg_xcvr3_stat;
          when XCVR3_CTRL              => read_reg <= user_regs.reg_xcvr3_ctrl;
          when XCVR3_PHY0_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr3_phy0_err_counts;
          when XCVR3_PHY1_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr3_phy1_err_counts;
          when XCVR3_PHY2_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr3_phy2_err_counts;
          when XCVR3_PHY3_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr3_phy3_err_counts;
          when XCVR3_STATISTICS        => read_reg <= user_regs.reg_xcvr3_statistics;

          when XCVR4_STAT              => read_reg <= user_regs.reg_xcvr4_stat;
          when XCVR4_CTRL              => read_reg <= user_regs.reg_xcvr4_ctrl;
          when XCVR4_PHY0_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr4_phy0_err_counts;
          when XCVR4_PHY1_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr4_phy1_err_counts;
          when XCVR4_PHY2_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr4_phy2_err_counts;
          when XCVR4_PHY3_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr4_phy3_err_counts;
          when XCVR4_STATISTICS        => read_reg <= user_regs.reg_xcvr4_statistics;

          when XCVR5_STAT              => read_reg <= user_regs.reg_xcvr5_stat;
          when XCVR5_CTRL              => read_reg <= user_regs.reg_xcvr5_ctrl;
          when XCVR5_PHY0_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr5_phy0_err_counts;
          when XCVR5_PHY1_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr5_phy1_err_counts;
          when XCVR5_PHY2_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr5_phy2_err_counts;
          when XCVR5_PHY3_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr5_phy3_err_counts;
          when XCVR5_STATISTICS        => read_reg <= user_regs.reg_xcvr5_statistics;

          when XCVR6_STAT              => read_reg <= user_regs.reg_xcvr6_stat;
          when XCVR6_CTRL              => read_reg <= user_regs.reg_xcvr6_ctrl;
          when XCVR6_PHY0_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr6_phy0_err_counts;
          when XCVR6_PHY1_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr6_phy1_err_counts;
          when XCVR6_PHY2_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr6_phy2_err_counts;
          when XCVR6_PHY3_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr6_phy3_err_counts;
          when XCVR6_STATISTICS        => read_reg <= user_regs.reg_xcvr6_statistics;

          when XCVR7_STAT              => read_reg <= user_regs.reg_xcvr7_stat;
          when XCVR7_CTRL              => read_reg <= user_regs.reg_xcvr7_ctrl;
          when XCVR7_PHY0_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr7_phy0_err_counts;
          when XCVR7_PHY1_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr7_phy1_err_counts;
          when XCVR7_PHY2_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr7_phy2_err_counts;
          when XCVR7_PHY3_ERR_COUNTS   => read_reg <= user_regs.reg_xcvr7_phy3_err_counts;
          when XCVR7_STATISTICS        => read_reg <= user_regs.reg_xcvr7_statistics;

          when COOKER_PRESERVE         => read_reg <= user_regs.reg_cook_preserve;

          when others => read_reg <= (others => '0');
        end case;
      end if;

      -- pipeline these signals to simplify output logic at I/O
      reg_oc0_gpio_control_d1 <= reg_oc0_gpio_control;
      reg_oc1_gpio_control_d1 <= reg_oc1_gpio_control;
      reg_oc0_gpio_dir_d1     <= reg_oc0_gpio_dir;
      reg_oc1_gpio_dir_d1     <= reg_oc1_gpio_dir;
      reg_oc0_gpio_dir_ext_d1 <= reg_oc0_gpio_dir_ext;
      reg_oc1_gpio_dir_ext_d1 <= reg_oc1_gpio_dir_ext;

    end if;
  end process;

  -------------------
  -- Connect Outputs
  -------------------
  avmm_readdata      <= read_reg;
  avmm_waitrequest   <= slave_wait or (avmm_read and not read_ctrl);
  avmm_readdatavalid <= read_ctrl;

  reg_0_out        <= reg_0;
  reg_1_out        <= reg_1;
  led_control      <= led_ctrl_reg;
  cook_sreg        <= reg_cook_sreg;
  cook_bram        <= reg_cook_bram;
  cook_dsp         <= reg_cook_dsp;
  cook_size        <= reg_cook_size;
  cook_cken        <= reg_cook_cken;
  oc_buff_en_n     <= not reg_oc_buff_en;
  opci_buff_in_sel <= reg_buff_in_sel;
  oc0_gpio_control <= reg_oc0_gpio_control_d1;
  oc1_gpio_control <= reg_oc1_gpio_control_d1;
  oc0_gpio_dir     <= (reg_oc0_gpio_dir_d1(15 downto 10) & "00" & reg_oc0_gpio_dir_d1(7 downto 4) & "0000");
  oc1_gpio_dir     <= (reg_oc1_gpio_dir_d1(15 downto 10) & "00" & reg_oc1_gpio_dir_d1(7 downto 4) & "0000");
  oc0_gpio_dir_ext <= (reg_oc0_gpio_dir_ext_d1(15 downto 10) & "00" & reg_oc0_gpio_dir_ext_d1(7 downto 4) & "0000");
  oc1_gpio_dir_ext <= (reg_oc1_gpio_dir_ext_d1(15 downto 10) & "00" & reg_oc1_gpio_dir_ext_d1(7 downto 4) & "0000");

end rtl;
