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
--      Copyright © 1998-2018 Nallatech Limited. All rights reserved.
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
--                    NNNN              ---NNNN         (a molex company)
--                   NNNN               -----NNNN
--                  NNNN                -------NNNN
--                 NNNN                 ---------NNNN
--                NNNNNNNN              ---NNNNNNNN
--               NNNNNNNNN              ---NNNNNNNNN
--                -------------------
--               ---------------------
--
--------------------------------------------------------------------------------
-- Title       : Memory BIST Wrapper
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : Wrapper for Memory BIST component.
--
--               Includes:
--                 * Memory BIST with Parity (data generator/verifier)
--                 * HSD to AvMM Conversion for DDR4 SDRAM component
--                 * AvMM Host Interface
--                 * Results BRAM
--
--
--------------------------------------------------------------------------------
-- Known Issues and Omissions:
--
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.pkg_user_registers.all;


entity memory_bist_wrapper is
  generic (
    ADDRESS_OFFSET    :     std_logic_vector(11 downto 0) := (others => '0');  -- Host Address offset
    ADDRESS_WIDTH     :     integer                       := 40;
    ADDRESS_SIZE      :     integer                       := 27  -- Memory Address Size (Avalon) - must not be greater than 29
    );
  port (
    mem_usr_rst       : in  std_logic;
    mem_usr_clk       : in  std_logic;
    mem_usr_stat      : out std_logic;
    -- Memory AvMM Interface
    mem_waitrequest   : in  std_logic;
    mem_read          : out std_logic;
    mem_write         : out std_logic;
    mem_address       : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
    mem_readdata      : in  std_logic_vector(575 downto 0);
    mem_writedata     : out std_logic_vector(575 downto 0);
    mem_byteenable    : out std_logic_vector(71 downto 0);
    mem_readdatavalid : in  std_logic;
    mem_cal_success   : in  std_logic;
    mem_cal_fail      : in  std_logic;
    mem_reset_req     : out std_logic;
    mem_reset_done    : in  std_logic;
    -- Status
    test_running      : out std_logic;
    -- Host Interface
    config_clk        : in  std_logic;
    config_rstn       : in  std_logic;
    avmm_writedata    : in  std_logic_vector(31 downto 0);
    avmm_address      : in  std_logic_vector(11 downto 0);
    avmm_write        : in  std_logic;
    avmm_byteenable   : in  std_logic_vector(3 downto 0);
    dout_mem          : out T_mem_status
    );
end entity memory_bist_wrapper;


architecture rtl of memory_bist_wrapper is
  -------------
  -- Constants
  -------------
  constant HSD_WR : std_logic_vector(2 downto 0) := "001";
  constant HSD_RD : std_logic_vector(2 downto 0) := "010";

  -----------
  -- Signals
  -----------
  signal hsd_maddr         : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
  signal hsd_mcmd          : std_logic_vector(2 downto 0);
  signal hsd_mdata         : std_logic_vector(511 downto 0);
  signal hsd_mbyte_en      : std_logic_vector(71 downto 0);
  signal hsd_scmd_accept   : std_logic;
  signal hsd_sdata         : std_logic_vector(511 downto 0);
  signal hsd_sresp         : std_logic_vector(1 downto 0);
  signal hsd_status        : std_logic_vector(64 downto 0);
  signal hsd_control       : std_logic_vector(63 downto 0);
  signal rst_count         : std_logic_vector(3 downto 0)   := (others => '0');
  signal rst_pulse         : std_logic                      := '1';
  signal reg_test_enable   : std_logic                      := '0';
  signal reg_pattern_sel   : std_logic_vector(5 downto 0)   := "100000";
  signal reg_write_stop    : std_logic                      := '0';
  signal reg_results_ctrl  : std_logic_vector(9 downto 0)   := (others => '0');
  signal recal_count       : std_logic_vector(3 downto 0)   := (others => '0');
  signal recal_pulse       : std_logic                      := '0';
  signal bist_reset_meta   : std_logic_vector(1 downto 0)   := (others => '0');
  signal bist_enable_meta  : std_logic_vector(1 downto 0)   := (others => '0');
  signal write_stop_meta   : std_logic_vector(1 downto 0)   := (others => '0');
  signal mem_usr_stat_i    : std_logic                      := '0';
  signal test_running_i    : std_logic;
  signal test_fail         : std_logic;
  signal test_running_meta : std_logic_vector(1 downto 0)   := (others => '0');
  signal test_fail_meta    : std_logic_vector(1 downto 0)   := (others => '0');
  signal cal_complete_meta : std_logic_vector(1 downto 0)   := (others => '0');
  signal cal_fail_meta     : std_logic_vector(1 downto 0)   := (others => '0');
  signal reset_done_meta   : std_logic_vector(1 downto 0)   := (others => '0');
  signal tests_completed   : std_logic_vector(31 downto 0);
  signal error_count       : std_logic_vector(31 downto 0);
  signal error_bits        : std_logic_vector(63 downto 0);
  signal error_parity_bits : std_logic_vector(7 downto 0);
  signal address_mem_wr    : std_logic;
  signal address_mem_addr  : std_logic_vector(9 downto 0);
  signal address_mem_data  : std_logic_vector(255 downto 0);
  signal expected_mem_wr   : std_logic;
  signal expected_mem_addr : std_logic_vector(9 downto 0);
  signal expected_mem_data : std_logic_vector(575 downto 0);
  signal received_mem_wr   : std_logic;
  signal received_mem_addr : std_logic_vector(9 downto 0);
  signal received_mem_data : std_logic_vector(575 downto 0);
  signal error_addr        : std_logic_vector(31 downto 0);
  signal zero576           : std_logic_vector(575 downto 0) := (others => '0');
  signal expected_data     : std_logic_vector(575 downto 0);
  signal received_data     : std_logic_vector(575 downto 0);


begin
  -------------------
  -- DDR4 SDRAM Test
  -------------------
  u00 : entity work.memory_bist_with_parity
    generic map (
      ADDRESS_WIDTH            => ADDRESS_WIDTH,
      MEMORY_BYTE_WIDTH        => 64,   -- HSD Byte Width
      PARITY_BYTE_WIDTH        => 8,
      ACTUAL_MEMORY_BYTE_WIDTH => 8,    -- Memory Byte Width
      ACTUAL_PARITY_BYTE_WIDTH => 1,
-- MEM_DEPTH => x"02_0000_0000",        -- Memory Address Range (e.g. 2^30 x 8 = 8GBytes => x"0040000000" )
      MEM_TOP_BIT              => 31,
      SIM                      => false,  -- Simulation Mode (reduces amount of memory tested)
      STATUS_WIDTH             => 65,   -- Must be at least (ACTUAL_PARITY_BYTE_WIDTH*64)+1 to include calibration_complete
      CONTROL_WIDTH            => 64    -- Must be at least (ACTUAL_PARITY_BYTE_WIDTH*64)
      )
    port map (
      reset                    => mem_usr_rst,  -- in  std_logic
      clk                      => mem_usr_clk,  -- in  std_logic
      -- Nallatech HSD Port
      maddr                    => hsd_maddr,  -- out std_logic_vector(39 downto 0)
      mcmd                     => hsd_mcmd,  -- out std_logic_vector(2 downto 0)
      mdata                    => hsd_mdata,  -- out std_logic_vector((MEMORY_BYTE_WIDTH*8)-1 downto 0)
      mbyte_en                 => hsd_mbyte_en,  -- out std_logic_vector(MEMORY_BYTE_WIDTH+PARITY_BYTE_WIDTH-1 downto 0)
      scmd_accept              => hsd_scmd_accept,  -- in  std_logic
      sdata                    => hsd_sdata,  -- in  std_logic_vector((MEMORY_BYTE_WIDTH*8)-1 downto 0)
      sresp                    => hsd_sresp,  -- in  std_logic_vector(1 downto 0)
      status                   => hsd_status,  -- in  std_logic_vector(STATUS_WIDTH-1 downto 0)
      control                  => hsd_control,  -- out std_logic_vector(CONTROL_WIDTH-1 downto 0)
      -- Control/Status
      bist_enable              => bist_enable_meta(1),  -- in  std_logic
      bist_reset               => bist_reset_meta(1),  -- in  std_logic
      pattern_select           => reg_pattern_sel,  -- in  std_logic_vector(5 downto 0)
      pattern3_byte0           => "00000000",  -- in  std_logic_vector(7 downto 0)
      pattern3_byte1           => "00000000",  -- in  std_logic_vector(7 downto 0)
      write_stop               => write_stop_meta(1),  -- in  std_logic
      test_running             => test_running_i,  -- out std_logic
      test_fail                => test_fail,  -- out std_logic
      pipe_clean               => open,  -- out std_logic
      tests_completed          => tests_completed,  -- out std_logic_vector(31 downto 0)
      error_count              => error_count,  -- out std_logic_vector(31 downto 0)
      error_bits               => error_bits,  -- out std_logic_vector((ACTUAL_MEMORY_BYTE_WIDTH*8)-1 downto 0)
      error_parity_bits        => error_parity_bits,  -- out std_logic_vector((ACTUAL_PARITY_BYTE_WIDTH*8)-1 downto 0)
      words_stored             => open,  -- out std_logic_vector(15 downto 0)
      address_mem_wr           => address_mem_wr,  -- out std_logic
      address_mem_addr         => address_mem_addr,  -- out std_logic_vector(9 downto 0)
      address_mem_data         => address_mem_data,  -- out std_logic_vector(((MEMORY_BYTE_WIDTH/ACTUAL_MEMORY_BYTE_WIDTH)*32)-1 downto 0)
      expected_mem_wr          => expected_mem_wr,  -- out std_logic
      expected_mem_addr        => expected_mem_addr,  -- out std_logic_vector(9 downto 0)
      expected_mem_data        => expected_mem_data,  -- out std_logic_vector(((MEMORY_BYTE_WIDTH+PARITY_BYTE_WIDTH)*8)-1 downto 0)
      expected_mem_data_fixed  => open,  -- out std_logic_vector(((MEMORY_BYTE_WIDTH+PARITY_BYTE_WIDTH)*8)-1 downto 0)
      received_mem_wr          => received_mem_wr,  -- out std_logic
      received_mem_addr        => received_mem_addr,  -- out std_logic_vector(9 downto 0)
      received_mem_data        => received_mem_data,  -- out std_logic_vector(((MEMORY_BYTE_WIDTH+PARITY_BYTE_WIDTH)*8)-1 downto 0)
      received_mem_data_fixed  => open  -- out std_logic_vector(((MEMORY_BYTE_WIDTH+PARITY_BYTE_WIDTH)*8)-1 downto 0)
      );

  --------------------------
  -- HSD to AvMM Conversion
  --------------------------

  -- Nallatech HSD Port
  -- ==================
  -- maddr           40-bit byte-address from master
  -- mcmd            3-bit command from master ("000" = Idle, "001" = Write, "010" = Read)
  -- mdata           512-bit data from master to SDRAM
  -- mbyte_en        72-bit byte enable from master
  -- scmd_accept     Command Accept from slave
  -- sdata           512-bit data from SDRAM to master
  -- sresp           2-bit slave response ("00" = No response, "01" = Valid)
  -- status          65-bit status from SDRAM to master (63:0 = data from SDRAM to master, bit 64 = calibration_complete)
  -- control         64-bit control from master to SDRAM (63:0 = data from master to SDRAM)

  -- Intel AvMM Interface
  -- ====================
  -- waitrequest     SDRAM wait request to master
  -- read            Read command from master
  -- write           Write command from master
  -- address         27-bit address (word addressing, min step = 1)
  -- readdata        576-bit read data from SDRAM
  -- writedata       576-bit write data to SDRAM
  -- burstcount      7-bit burst count from master (burst size, min = "0000001")
  -- byteenable      72-bit byte enable for write data
  -- readdatavalid   Read data valid flag from SDRAM aligned with pipelined read data

  mem_address <= hsd_maddr(ADDRESS_SIZE+5 downto 6);
  mem_write   <= '1' when hsd_mcmd = HSD_WR else '0';
  mem_read    <= '1' when hsd_mcmd = HSD_RD else '0';

  mem_writedata <= hsd_control(63 downto 56) & hsd_mdata(511 downto 448) &
                     hsd_control(55 downto 48) & hsd_mdata(447 downto 384) &
                     hsd_control(47 downto 40) & hsd_mdata(383 downto 320) &
                     hsd_control(39 downto 32) & hsd_mdata(319 downto 256) &
                     hsd_control(31 downto 24) & hsd_mdata(255 downto 192) &
                     hsd_control(23 downto 16) & hsd_mdata(191 downto 128) &
                     hsd_control(15 downto 8) & hsd_mdata(127 downto 64) &
                     hsd_control(7 downto 0) & hsd_mdata( 63 downto 0);

  mem_byteenable <= hsd_mbyte_en(71) & hsd_mbyte_en(63 downto 56) &
                     hsd_mbyte_en(70) & hsd_mbyte_en(55 downto 48) &
                     hsd_mbyte_en(69) & hsd_mbyte_en(47 downto 40) &
                     hsd_mbyte_en(68) & hsd_mbyte_en(39 downto 32) &
                     hsd_mbyte_en(67) & hsd_mbyte_en(31 downto 24) &
                     hsd_mbyte_en(66) & hsd_mbyte_en(23 downto 16) &
                     hsd_mbyte_en(65) & hsd_mbyte_en(15 downto 8) &
                     hsd_mbyte_en(64) & hsd_mbyte_en( 7 downto 0);

  hsd_scmd_accept <= '1' when ((hsd_mcmd = HSD_WR or hsd_mcmd = HSD_RD) and mem_waitrequest = '0') else '0';

  hsd_sdata <= mem_readdata(567 downto 504) &
                     mem_readdata(495 downto 432) &
                     mem_readdata(423 downto 360) &
                     mem_readdata(351 downto 288) &
                     mem_readdata(279 downto 216) &
                     mem_readdata(207 downto 144) &
                     mem_readdata(135 downto 72) &
                     mem_readdata( 63 downto 0);

  hsd_status <= mem_cal_success &
                     mem_readdata(575 downto 568) &
                     mem_readdata(503 downto 496) &
                     mem_readdata(431 downto 424) &
                     mem_readdata(359 downto 352) &
                     mem_readdata(287 downto 280) &
                     mem_readdata(215 downto 208) &
                     mem_readdata(143 downto 136) &
                     mem_readdata( 71 downto 64);

  hsd_sresp <= "01" when mem_readdatavalid = '1' else "00";

  ----------------------
  -- Register Interface
  ----------------------
  process(config_clk)
  begin
    if rising_edge(config_clk) then
      if config_rstn = '0' then
        rst_count        <= (others => '0');
        rst_pulse        <= '1';
        reg_test_enable  <= '0';
        reg_pattern_sel  <= "100000";
        reg_write_stop   <= '0';
        reg_results_ctrl <= (others => '0');
        recal_count      <= (others => '0');
        recal_pulse      <= '0';

      else
        -- Reset pulse for DDR4 SDRAM Test
        if (avmm_write = '1') and (avmm_address = ADDRESS_OFFSET) and
          (avmm_byteenable(0) = '1') and (avmm_writedata(1) = '1') then
          rst_count <= (others => '0');
          rst_pulse <= '1';
        elsif rst_count /= "1111" then
          rst_count <= rst_count + 1;
        else
          rst_pulse <= '0';
        end if;

        -- Control Bits for DDR4 SDRAM Test
        if avmm_write = '1' then
          if (avmm_address = ADDRESS_OFFSET) then
            if (avmm_byteenable(0) = '1') then
              reg_test_enable <= avmm_writedata(0);
              reg_pattern_sel <= avmm_writedata(7 downto 2);
            end if;
            if (avmm_byteenable(1) = '1') then
              reg_write_stop  <= avmm_writedata(8);
            end if;
          end if;

          if (avmm_address = ADDRESS_OFFSET + 32) then
            if avmm_byteenable(0) = '1' then
              reg_results_ctrl(7 downto 0) <= avmm_writedata(7 downto 0);
            end if;
            if avmm_byteenable(1) = '1' then
              reg_results_ctrl(9 downto 8) <= avmm_writedata(9 downto 8);
            end if;
          end if;
        end if;

        -- Recalibrate pulse for DDR4 SDRAM EMIF
        if (avmm_write = '1') and (avmm_address = ADDRESS_OFFSET) and
          (avmm_byteenable(1) = '1') and (avmm_writedata(9) = '1') then
          recal_count <= (others => '1');
          recal_pulse <= '1';
        elsif recal_count /= 0 then
          recal_count <= recal_count - 1;
        else
          recal_pulse <= '0';
        end if;

      end if;

      -- No sync reset applied
      test_running_meta <= (test_running_meta(0) & test_running_i);
      test_fail_meta    <= (test_fail_meta(0) & test_fail);
      cal_complete_meta <= (cal_complete_meta(0) & mem_cal_success);
      cal_fail_meta     <= (cal_fail_meta(0) & mem_cal_fail);
      reset_done_meta   <= (reset_done_meta(0) & mem_reset_done);

    end if;
  end process;

  process(mem_usr_clk)
  begin
    if rising_edge(mem_usr_clk) then
      -- Create mem_usr_stat for clock test register
      mem_usr_stat_i <= not mem_usr_rst;

      -- Transfer to mem_usr_clk domain
      bist_reset_meta  <= (bist_reset_meta(0) & rst_pulse);
      bist_enable_meta <= (bist_enable_meta(0) & reg_test_enable);
      write_stop_meta  <= (write_stop_meta(0) & reg_write_stop);

    end if;
  end process;

  ----------------
  -- Results BRAM
  ----------------
  u10 : entity work.altera_dprw_ram
    generic map
    (
      AWIDTH => 10,
      DWIDTH => 32
      )
    port map (
      clka   => config_clk,             -- in  std_logic
      clkb   => mem_usr_clk,            -- in  std_logic
      wea    => '0',                    -- in  std_logic
      web    => address_mem_wr,         -- in  std_logic
      addra  => reg_results_ctrl,       -- in  std_logic_vector(AWIDTH-1 downto 0)
      addrb  => address_mem_addr,       -- in  std_logic_vector(AWIDTH-1 downto 0)
      dia    => x"00000000",            -- in  std_logic_vector(DWIDTH-1 downto 0)
      dib    => address_mem_data(31 downto 0),  -- in  std_logic_vector(DWIDTH-1 downto 0)
      doa    => error_addr,             -- out std_logic_vector(DWIDTH-1 downto 0)
      dob    => open                    -- out std_logic_vector(DWIDTH-1 downto 0)
      );

  u11 : entity work.altera_dprw_ram
    generic map
    (
      AWIDTH => 10,
      DWIDTH => 576
      )
    port map (
      clka   => config_clk,             -- in  std_logic
      clkb   => mem_usr_clk,            -- in  std_logic
      wea    => '0',                    -- in  std_logic
      web    => expected_mem_wr,        -- in  std_logic
      addra  => reg_results_ctrl,       -- in  std_logic_vector(AWIDTH-1 downto 0)
      addrb  => expected_mem_addr,      -- in  std_logic_vector(AWIDTH-1 downto 0)
      dia    => zero576,                -- in  std_logic_vector(DWIDTH-1 downto 0)
      dib    => expected_mem_data,      -- in  std_logic_vector(DWIDTH-1 downto 0)
      doa    => expected_data,          -- out std_logic_vector(DWIDTH-1 downto 0)
      dob    => open                    -- out std_logic_vector(DWIDTH-1 downto 0)
      );

  u12 : entity work.altera_dprw_ram
    generic map
    (
      AWIDTH => 10,
      DWIDTH => 576
      )
    port map (
      clka   => config_clk,             -- in  std_logic
      clkb   => mem_usr_clk,            -- in  std_logic
      wea    => '0',                    -- in  std_logic
      web    => received_mem_wr,        -- in  std_logic
      addra  => reg_results_ctrl,       -- in  std_logic_vector(AWIDTH-1 downto 0)
      addrb  => received_mem_addr,      -- in  std_logic_vector(AWIDTH-1 downto 0)
      dia    => zero576,                -- in  std_logic_vector(DWIDTH-1 downto 0)
      dib    => received_mem_data,      -- in  std_logic_vector(DWIDTH-1 downto 0)
      doa    => received_data,          -- out std_logic_vector(DWIDTH-1 downto 0)
      dob    => open                    -- out std_logic_vector(DWIDTH-1 downto 0)
      );

  zero576 <= (others => '0');

  -------------------
  -- Connect Outputs
  -------------------
  mem_usr_stat  <= mem_usr_stat_i;
  mem_reset_req <= recal_pulse;         -- Asynchronous pulse
  test_running  <= test_running_i;

  dout_mem.reg_ctrl               <= (x"00000" & "000" & reg_write_stop & reg_pattern_sel & '0' & reg_test_enable);
  dout_mem.reg_status             <= (x"0000000" & "00" & test_fail_meta(1) & test_running_meta(1));
  dout_mem.reg_tests_completed    <= tests_completed;
  dout_mem.reg_error_count        <= error_count;
  dout_mem.reg_error_bits_l       <= error_bits(31 downto 0);
  dout_mem.reg_error_bits_h       <= error_bits(63 downto 32);
  dout_mem.reg_memory_status      <= (x"0000000" & '0' & reset_done_meta(1) & cal_fail_meta(1) & cal_complete_meta(1));
  dout_mem.reg_error_bits_p       <= (x"000000" & error_parity_bits);
  dout_mem.reg_rslts_ctrl_status  <= (x"00000" & "00" & reg_results_ctrl);
  dout_mem.reg_rslts_err_ess_base <= error_addr;
  dout_mem.reg_rslts_exp_data0    <= expected_data(31 downto 0);
  dout_mem.reg_rslts_exp_data1    <= expected_data(63 downto 32);
  dout_mem.reg_rslts_exp_data2    <= (x"000000" & expected_data(71 downto 64));
  dout_mem.reg_rslts_exp_data3    <= expected_data(103 downto 72);
  dout_mem.reg_rslts_exp_data4    <= expected_data(135 downto 104);
  dout_mem.reg_rslts_exp_data5    <= (x"000000" & expected_data(143 downto 136));
  dout_mem.reg_rslts_exp_data6    <= expected_data(175 downto 144);
  dout_mem.reg_rslts_exp_data7    <= expected_data(207 downto 176);
  dout_mem.reg_rslts_exp_data8    <= (x"000000" & expected_data(215 downto 208));
  dout_mem.reg_rslts_exp_data9    <= expected_data(247 downto 216);
  dout_mem.reg_rslts_exp_data10   <= expected_data(279 downto 248);
  dout_mem.reg_rslts_exp_data11   <= (x"000000" & expected_data(287 downto 280));
  dout_mem.reg_rslts_exp_data12   <= expected_data(319 downto 288);
  dout_mem.reg_rslts_exp_data13   <= expected_data(351 downto 320);
  dout_mem.reg_rslts_exp_data14   <= (x"000000" & expected_data(359 downto 352));
  dout_mem.reg_rslts_exp_data15   <= expected_data(391 downto 360);
  dout_mem.reg_rslts_exp_data16   <= expected_data(423 downto 392);
  dout_mem.reg_rslts_exp_data17   <= (x"000000" & expected_data(431 downto 424));
  dout_mem.reg_rslts_exp_data18   <= expected_data(463 downto 432);
  dout_mem.reg_rslts_exp_data19   <= expected_data(495 downto 464);
  dout_mem.reg_rslts_exp_data20   <= (x"000000" & expected_data(503 downto 496));
  dout_mem.reg_rslts_exp_data21   <= expected_data(535 downto 504);
  dout_mem.reg_rslts_exp_data22   <= expected_data(567 downto 536);
  dout_mem.reg_rslts_exp_data23   <= (x"000000" & expected_data(575 downto 568));
  dout_mem.reg_rslts_rec_data0    <= received_data(31 downto 0);
  dout_mem.reg_rslts_rec_data1    <= received_data(63 downto 32);
  dout_mem.reg_rslts_rec_data2    <= (x"000000" & received_data(71 downto 64));
  dout_mem.reg_rslts_rec_data3    <= received_data(103 downto 72);
  dout_mem.reg_rslts_rec_data4    <= received_data(135 downto 104);
  dout_mem.reg_rslts_rec_data5    <= (x"000000" & received_data(143 downto 136));
  dout_mem.reg_rslts_rec_data6    <= received_data(175 downto 144);
  dout_mem.reg_rslts_rec_data7    <= received_data(207 downto 176);
  dout_mem.reg_rslts_rec_data8    <= (x"000000" & received_data(215 downto 208));
  dout_mem.reg_rslts_rec_data9    <= received_data(247 downto 216);
  dout_mem.reg_rslts_rec_data10   <= received_data(279 downto 248);
  dout_mem.reg_rslts_rec_data11   <= (x"000000" & received_data(287 downto 280));
  dout_mem.reg_rslts_rec_data12   <= received_data(319 downto 288);
  dout_mem.reg_rslts_rec_data13   <= received_data(351 downto 320);
  dout_mem.reg_rslts_rec_data14   <= (x"000000" & received_data(359 downto 352));
  dout_mem.reg_rslts_rec_data15   <= received_data(391 downto 360);
  dout_mem.reg_rslts_rec_data16   <= received_data(423 downto 392);
  dout_mem.reg_rslts_rec_data17   <= (x"000000" & received_data(431 downto 424));
  dout_mem.reg_rslts_rec_data18   <= received_data(463 downto 432);
  dout_mem.reg_rslts_rec_data19   <= received_data(495 downto 464);
  dout_mem.reg_rslts_rec_data20   <= (x"000000" & received_data(503 downto 496));
  dout_mem.reg_rslts_rec_data21   <= received_data(535 downto 504);
  dout_mem.reg_rslts_rec_data22   <= received_data(567 downto 536);
  dout_mem.reg_rslts_rec_data23   <= (x"000000" & received_data(575 downto 568));


end rtl;
