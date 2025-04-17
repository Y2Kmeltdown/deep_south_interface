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
-- Title       : DDR4 SDRAM Interface
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : Wrapper for memory BIST and EMIF IP for 4 banks of DDR4 SDRAM.
--
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


entity ddr4_sdram_if is
  port (
    -- Clocks & Reset
    config_clk      : in    std_logic;
    config_rstn     : in    std_logic_vector(NUM_DDR4_IF-1 downto 0);
    mem_usrclk      : out   std_logic_vector(NUM_DDR4_IF-1 downto 0);
    mem_usr_stat    : out   std_logic_vector(NUM_DDR4_IF-1 downto 0);
    -- DDR4 SDRAM Bank 0
    mem0_ck         : out   std_logic;
    mem0_ck_n       : out   std_logic;
    mem0_a          : out   std_logic_vector(16 downto 0);
    mem0_act_n      : out   std_logic;
    mem0_ba         : out   std_logic_vector(1 downto 0);
    mem0_bg         : out   std_logic_vector(1 downto 0);
    mem0_cke        : out   std_logic_vector(0 downto 0);
    mem0_cs_n       : out   std_logic_vector(0 downto 0);
    mem0_odt        : out   std_logic_vector(0 downto 0);
    mem0_reset_n    : out   std_logic;
    mem0_par        : out   std_logic;
    mem0_alert_n    : in    std_logic;
    mem0_dqs        : inout std_logic_vector(17 downto 0);
    mem0_dqs_n      : inout std_logic_vector(17 downto 0);
    mem0_dq         : inout std_logic_vector(71 downto 0);
    mem0_oct_rzqin  : in    std_logic;
    mem0_refclk     : in    std_logic;
    -- DDR4 SDRAM Bank 1
    mem1_ck         : out   std_logic;
    mem1_ck_n       : out   std_logic;
    mem1_a          : out   std_logic_vector(16 downto 0);
    mem1_act_n      : out   std_logic;
    mem1_ba         : out   std_logic_vector(1 downto 0);
    mem1_bg         : out   std_logic_vector(1 downto 0);
    mem1_cke        : out   std_logic_vector(0 downto 0);
    mem1_cs_n       : out   std_logic_vector(0 downto 0);
    mem1_odt        : out   std_logic_vector(0 downto 0);
    mem1_reset_n    : out   std_logic;
    mem1_par        : out   std_logic;
    mem1_alert_n    : in    std_logic;
    mem1_dqs        : inout std_logic_vector(17 downto 0);
    mem1_dqs_n      : inout std_logic_vector(17 downto 0);
    mem1_dq         : inout std_logic_vector(71 downto 0);
    mem1_oct_rzqin  : in    std_logic;
    mem1_refclk     : in    std_logic;
    -- Host Interface
    avmm_writedata  : in    std_logic_vector(31 downto 0);
    avmm_address    : in    std_logic_vector(11 downto 0);
    avmm_write      : in    std_logic;
    avmm_read       : in    std_logic;
    avmm_byteenable : in    std_logic_vector(3 downto 0);
    dout_mem0       : out   T_mem_status;
    dout_mem1       : out   T_mem_status;
    dout_mem_stat0  : out   std_logic_vector(31 downto 0);
    dout_mem_ctrl0  : out   std_logic_vector(31 downto 0);
    dout_depth0     : out   std_logic_vector(31 downto 0);
    dout_send_buf0  : out   std_logic_vector(31 downto 0);
    dout_read_buf0  : out   std_logic_vector(31 downto 0);
    dout_mem_stat1  : out   std_logic_vector(31 downto 0);
    dout_mem_ctrl1  : out   std_logic_vector(31 downto 0);
    dout_depth1     : out   std_logic_vector(31 downto 0);
    dout_send_buf1  : out   std_logic_vector(31 downto 0);
    dout_read_buf1  : out   std_logic_vector(31 downto 0)
    );
end ddr4_sdram_if;


architecture rtl of ddr4_sdram_if is
  --------------------------
  -- Component Declarations
  --------------------------
  component mem0 is
                   port (
                     amm_ready_0         : out   std_logic;
                     amm_read_0          : in    std_logic;
                     amm_write_0         : in    std_logic;
                     amm_address_0       : in    std_logic_vector(27 downto 0);
                     amm_readdata_0      : out   std_logic_vector(575 downto 0);
                     amm_writedata_0     : in    std_logic_vector(575 downto 0);
                     amm_burstcount_0    : in    std_logic_vector(6 downto 0);
                     amm_readdatavalid_0 : out   std_logic;
                     emif_usr_clk        : out   std_logic;
                     emif_usr_reset_n    : out   std_logic;
                     local_reset_req     : in    std_logic;
                     local_reset_done    : out   std_logic;
                     mem_ck              : out   std_logic_vector(0 downto 0);
                     mem_ck_n            : out   std_logic_vector(0 downto 0);
                     mem_a               : out   std_logic_vector(16 downto 0);
                     mem_act_n           : out   std_logic_vector(0 downto 0);
                     mem_ba              : out   std_logic_vector(1 downto 0);
                     mem_bg              : out   std_logic_vector(1 downto 0);
                     mem_cke             : out   std_logic_vector(0 downto 0);
                     mem_cs_n            : out   std_logic_vector(0 downto 0);
                     mem_odt             : out   std_logic_vector(0 downto 0);
                     mem_reset_n         : out   std_logic_vector(0 downto 0);
                     mem_par             : out   std_logic_vector(0 downto 0);
                     mem_alert_n         : in    std_logic_vector(0 downto 0);
                     mem_dqs             : inout std_logic_vector(17 downto 0);
                     mem_dqs_n           : inout std_logic_vector(17 downto 0);
                     mem_dq              : inout std_logic_vector(71 downto 0);
                     oct_rzqin           : in    std_logic;
                     pll_ref_clk         : in    std_logic;
                     local_cal_success   : out   std_logic;
                     local_cal_fail      : out   std_logic
                     );
  end component;

  component mem1 is
                   port (
                     amm_ready_0         : out   std_logic;
                     amm_read_0          : in    std_logic;
                     amm_write_0         : in    std_logic;
                     amm_address_0       : in    std_logic_vector(27 downto 0);
                     amm_readdata_0      : out   std_logic_vector(575 downto 0);
                     amm_writedata_0     : in    std_logic_vector(575 downto 0);
                     amm_burstcount_0    : in    std_logic_vector(6 downto 0);
                     amm_readdatavalid_0 : out   std_logic;
                     emif_usr_clk        : out   std_logic;
                     emif_usr_reset_n    : out   std_logic;
                     local_reset_req     : in    std_logic;
                     local_reset_done    : out   std_logic;
                     mem_ck              : out   std_logic_vector(0 downto 0);
                     mem_ck_n            : out   std_logic_vector(0 downto 0);
                     mem_a               : out   std_logic_vector(16 downto 0);
                     mem_act_n           : out   std_logic_vector(0 downto 0);
                     mem_ba              : out   std_logic_vector(1 downto 0);
                     mem_bg              : out   std_logic_vector(1 downto 0);
                     mem_cke             : out   std_logic_vector(0 downto 0);
                     mem_cs_n            : out   std_logic_vector(0 downto 0);
                     mem_odt             : out   std_logic_vector(0 downto 0);
                     mem_reset_n         : out   std_logic_vector(0 downto 0);
                     mem_par             : out   std_logic_vector(0 downto 0);
                     mem_alert_n         : in    std_logic_vector(0 downto 0);
                     mem_dqs             : inout std_logic_vector(17 downto 0);
                     mem_dqs_n           : inout std_logic_vector(17 downto 0);
                     mem_dq              : inout std_logic_vector(71 downto 0);
                     oct_rzqin           : in    std_logic;
                     pll_ref_clk         : in    std_logic;
                     local_cal_success   : out   std_logic;
                     local_cal_fail      : out   std_logic
                     );
  end component;


  component pipe_mm_bridge_0 is
                               port (
                                 clk              : in  std_logic;
                                 m0_waitrequest   : in  std_logic;
                                 m0_readdata      : in  std_logic_vector(575 downto 0);
                                 m0_readdatavalid : in  std_logic;
                                 m0_burstcount    : out std_logic_vector(6 downto 0);
                                 m0_writedata     : out std_logic_vector(575 downto 0);
                                 m0_address       : out std_logic_vector(27 downto 0);
                                 m0_write         : out std_logic;
                                 m0_read          : out std_logic;
                                 m0_byteenable    : out std_logic_vector(71 downto 0);
                                 m0_debugaccess   : out std_logic;
                                 reset            : in  std_logic;
                                 s0_waitrequest   : out std_logic;
                                 s0_readdata      : out std_logic_vector(575 downto 0);
                                 s0_readdatavalid : out std_logic;
                                 s0_burstcount    : in  std_logic_vector(6 downto 0);
                                 s0_writedata     : in  std_logic_vector(575 downto 0);
                                 s0_address       : in  std_logic_vector(27 downto 0);
                                 s0_write         : in  std_logic;
                                 s0_read          : in  std_logic;
                                 s0_byteenable    : in  std_logic_vector(71 downto 0);
                                 s0_debugaccess   : in  std_logic
                                 );
  end component;

  -------------
  -- Constants
  -------------
  constant ADDRESS_SIZE : integer := 28;  -- Memory Address Size (Avalon) - must not be greater than 29
                                        -- Value of 27 => 4GBytes
  ---------
  -- Types
  ---------
  type T_4x_addr_bits is array (0 to NUM_DDR4_IF-1) of std_logic_vector(ADDRESS_SIZE-1 downto 0);
  type T_4x_640_bits is array (0 to NUM_DDR4_IF-1) of std_logic_vector(639 downto 0);
  type T_4x_576_bits is array (0 to NUM_DDR4_IF-1) of std_logic_vector(575 downto 0);
  type T_4x_80_bits is array (0 to NUM_DDR4_IF-1) of std_logic_vector(79 downto 0);
  type T_4x_72_bits is array (0 to NUM_DDR4_IF-1) of std_logic_vector(71 downto 0);
  type T_4x_32_bits is array (0 to NUM_DDR4_IF-1) of std_logic_vector(31 downto 0);
  type T_4x_7_bits is array (0 to NUM_DDR4_IF-1) of std_logic_vector(6 downto 0);
  type T_4x_mem_status is array (0 to NUM_DDR4_IF-1) of T_mem_status;

  -----------
  -- Signals
  -----------
  signal mem_cal_success     : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_cal_fail        : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_reset_req       : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_reset_done      : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_usr_clk         : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_usr_reset_n     : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_usr_rst         : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal amm_waitrequest     : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal amm_ready           : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal amm_read            : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal amm_write           : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal amm_address         : T_4x_addr_bits;
  signal amm_readdata        : T_4x_576_bits;
  signal amm_writedata       : T_4x_576_bits;
  signal amm_burstcount      : T_4x_7_bits;
  signal amm_readdatavalid   : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_b_waitrequest   : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_b_read          : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_b_write         : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_b_address       : T_4x_addr_bits;
  signal mem_b_readdata      : T_4x_576_bits;
  signal mem_b_writedata     : T_4x_576_bits;
  signal mem_b_burstcount    : T_4x_7_bits;
  signal mem_b_byteenable    : T_4x_72_bits;
  signal mem_b_readdatavalid : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_waitrequest     : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_read            : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_write           : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_address         : T_4x_addr_bits;
  signal mem_readdata        : T_4x_576_bits;
  signal mem_writedata       : T_4x_576_bits;
  signal mem_byteenable      : T_4x_72_bits;
  signal mem_readdatavalid   : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_bw_read         : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_bw_write        : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_bw_address      : T_4x_addr_bits;
  signal mem_bw_writedata    : T_4x_576_bits;
  signal mem_bw_byteenable   : T_4x_72_bits;
  signal mem_pp_read         : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_pp_write        : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_pp_address      : T_4x_addr_bits;
  signal mem_pp_readdata     : T_4x_640_bits;
  signal mem_pp_writedata    : T_4x_640_bits;
  signal mem_pp_byteenable   : T_4x_80_bits;
  signal bw_test_running     : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal dout_mem            : T_4x_mem_status;
  signal dout_mem_stat       : T_4x_32_bits;
  signal dout_mem_ctrl       : T_4x_32_bits;
  signal dout_depth          : T_4x_32_bits;
  signal dout_send_buf       : T_4x_32_bits;
  signal dout_read_buf       : T_4x_32_bits;


begin
  --------------------
  -- DDR4 SDRAM Cores
  --------------------
  u0 : mem0
    port map (
      amm_ready_0         => amm_ready(0),  -- out   std_logic
      amm_read_0          => amm_read(0),  -- in    std_logic
      amm_write_0         => amm_write(0),  -- in    std_logic
      amm_address_0       => amm_address(0),  -- in    std_logic_vector(26 downto 0)
      amm_readdata_0      => amm_readdata(0),  -- out   std_logic_vector(575 downto 0)
      amm_writedata_0     => amm_writedata(0),  -- in    std_logic_vector(575 downto 0)
      amm_burstcount_0    => amm_burstcount(0),  -- in    std_logic_vector(6 downto 0)
      amm_readdatavalid_0 => amm_readdatavalid(0),  -- out   std_logic
      emif_usr_clk        => mem_usr_clk(0),  -- out   std_logic
      emif_usr_reset_n    => mem_usr_reset_n(0),  -- out   std_logic
      local_reset_req     => mem_reset_req(0),  -- in    std_logic
      local_reset_done    => mem_reset_done(0),  -- out   std_logic
      mem_ck(0)           => mem0_ck,   -- out   std_logic_vector(0 downto 0)
      mem_ck_n(0)         => mem0_ck_n,  -- out   std_logic_vector(0 downto 0)
      mem_a               => mem0_a,    -- out   std_logic_vector(16 downto 0)
      mem_act_n(0)        => mem0_act_n,  -- out   std_logic_vector(0 downto 0)
      mem_ba              => mem0_ba,   -- out   std_logic_vector(1 downto 0)
      mem_bg              => mem0_bg,   -- out   std_logic_vector(1 downto 0)
      mem_cke             => mem0_cke,  -- out   std_logic_vector(0 downto 0)
      mem_cs_n            => mem0_cs_n,  -- out   std_logic_vector(0 downto 0)
      mem_odt             => mem0_odt,  -- out   std_logic_vector(0 downto 0)
      mem_reset_n(0)      => mem0_reset_n,  -- out   std_logic_vector(0 downto 0)
      mem_par(0)          => mem0_par,  -- out   std_logic_vector(0 downto 0)
      mem_alert_n(0)      => mem0_alert_n,  -- in    std_logic_vector(0 downto 0)
      mem_dqs             => mem0_dqs,  -- inout std_logic_vector(8 downto 0)
      mem_dqs_n           => mem0_dqs_n,  -- inout std_logic_vector(8 downto 0)
      mem_dq              => mem0_dq,   -- inout std_logic_vector(71 downto 0)
      oct_rzqin           => mem0_oct_rzqin,  -- in    std_logic
      pll_ref_clk         => mem0_refclk,  -- in    std_logic
      local_cal_success   => mem_cal_success(0),  -- out   std_logic
      local_cal_fail      => mem_cal_fail(0)  -- out   std_logic
      );

  u1 : mem1
    port map (
      amm_ready_0         => amm_ready(1),  -- out   std_logic
      amm_read_0          => amm_read(1),  -- in    std_logic
      amm_write_0         => amm_write(1),  -- in    std_logic
      amm_address_0       => amm_address(1),  -- in    std_logic_vector(26 downto 0)
      amm_readdata_0      => amm_readdata(1),  -- out   std_logic_vector(575 downto 0)
      amm_writedata_0     => amm_writedata(1),  -- in    std_logic_vector(575 downto 0)
      amm_burstcount_0    => amm_burstcount(1),  -- in    std_logic_vector(6 downto 0)
      amm_readdatavalid_0 => amm_readdatavalid(1),  -- out   std_logic
      emif_usr_clk        => mem_usr_clk(1),  -- out   std_logic
      emif_usr_reset_n    => mem_usr_reset_n(1),  -- out   std_logic
      local_reset_req     => mem_reset_req(1),  -- in    std_logic
      local_reset_done    => mem_reset_done(1),  -- out   std_logic
      mem_ck(0)           => mem1_ck,   -- out   std_logic_vector(0 downto 0)
      mem_ck_n(0)         => mem1_ck_n,  -- out   std_logic_vector(0 downto 0)
      mem_a               => mem1_a,    -- out   std_logic_vector(16 downto 0)
      mem_act_n(0)        => mem1_act_n,  -- out   std_logic_vector(0 downto 0)
      mem_ba              => mem1_ba,   -- out   std_logic_vector(1 downto 0)
      mem_bg              => mem1_bg,   -- out   std_logic_vector(1 downto 0)
      mem_cke             => mem1_cke,  -- out   std_logic_vector(0 downto 0)
      mem_cs_n            => mem1_cs_n,  -- out   std_logic_vector(0 downto 0)
      mem_odt             => mem1_odt,  -- out   std_logic_vector(0 downto 0)
      mem_reset_n(0)      => mem1_reset_n,  -- out   std_logic_vector(0 downto 0)
      mem_par(0)          => mem1_par,  -- out   std_logic_vector(0 downto 0)
      mem_alert_n(0)      => mem1_alert_n,  -- in    std_logic_vector(0 downto 0)
      mem_dqs             => mem1_dqs,  -- inout std_logic_vector(8 downto 0)
      mem_dqs_n           => mem1_dqs_n,  -- inout std_logic_vector(8 downto 0)
      mem_dq              => mem1_dq,   -- inout std_logic_vector(71 downto 0)
      oct_rzqin           => mem1_oct_rzqin,  -- in    std_logic
      pll_ref_clk         => mem1_refclk,  -- in    std_logic
      local_cal_success   => mem_cal_success(1),  -- out   std_logic
      local_cal_fail      => mem_cal_fail(1)  -- out   std_logic
      );

  -------------------
  -- DDR4 SDRAM Test
  -------------------
  amm_waitrequest <= not amm_ready;
  mem_usr_rst     <= not mem_usr_reset_n;

  gen0 : for i in 0 to NUM_DDR4_IF-1 generate
    -------------------------
    -- Memory test Component
    -------------------------
    u1 : entity work.memory_bist_wrapper
      generic map (
        ADDRESS_OFFSET    => (MEM0_CTRL + (256*i)),
        ADDRESS_SIZE      => ADDRESS_SIZE
        )
      port map (
        mem_usr_rst       => mem_usr_rst(i),  -- in  std_logic
        mem_usr_clk       => mem_usr_clk(i),  -- in  std_logic
        mem_usr_stat      => mem_usr_stat(i),  -- out std_logic
        -- Memory AvMM Interface
        mem_waitrequest   => mem_waitrequest(i),  -- in  std_logic
        mem_read          => mem_bw_read(i),  -- out std_logic
        mem_write         => mem_bw_write(i),  -- out std_logic
        mem_address       => mem_bw_address(i),  -- out std_logic_vector(ADDRESS_SIZE-1 downto 0)
        mem_readdata      => mem_readdata(i),  -- in  std_logic_vector(575 downto 0)
        mem_writedata     => mem_bw_writedata(i),  -- out std_logic_vector(575 downto 0)
        mem_byteenable    => mem_bw_byteenable(i),  -- out std_logic_vector(71 downto 0)
        mem_readdatavalid => mem_readdatavalid(i),  -- in  std_logic
        mem_cal_success   => mem_cal_success(i),  -- in  std_logic
        mem_cal_fail      => mem_cal_fail(i),  -- in  std_logic
        mem_reset_req     => mem_reset_req(i),  -- out std_logic
        mem_reset_done    => mem_reset_done(i),  -- in  std_logic
        -- Status
        test_running      => bw_test_running(i),  -- out std_logic
        -- Host Interface
        config_clk        => config_clk,  -- in  std_logic
        config_rstn       => config_rstn(i),  -- in  std_logic
        avmm_writedata    => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
        avmm_address      => avmm_address,  -- in  std_logic_vector(11 downto 0)
        avmm_write        => avmm_write,  -- in  std_logic
        avmm_byteenable   => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
        dout_mem          => dout_mem(i)  -- out T_mem_stat
        );

    -- One pipeline stage is necessary to achieve timing closure when only the
    -- memory_bist_wrapper is present.
    u2a : pipe_mm_bridge_0
      port map (
        clk              => mem_usr_clk(i),  -- in  std_logic
        m0_waitrequest   => mem_b_waitrequest(i),  -- in  std_logic
        m0_readdata      => mem_b_readdata(i),  -- in  std_logic_vector(575 downto 0)
        m0_readdatavalid => mem_b_readdatavalid(i),  -- in  std_logic
        m0_burstcount    => mem_b_burstcount(i),  -- out std_logic_vector(5 downto 0)
        m0_writedata     => mem_b_writedata(i),  -- out std_logic_vector(575 downto 0)
        m0_address       => mem_b_address(i),  -- out std_logic_vector(26 downto 0)
        m0_write         => mem_b_write(i),  -- out std_logic
        m0_read          => mem_b_read(i),  -- out std_logic
        m0_byteenable    => mem_b_byteenable(i),  -- out std_logic_vector(71 downto 0)
        m0_debugaccess   => open,       -- out std_logic
        reset            => mem_usr_rst(i),  -- in  std_logic
        s0_waitrequest   => mem_waitrequest(i),  -- out std_logic
        s0_readdata      => mem_readdata(i),  -- out std_logic_vector(575 downto 0)
        s0_readdatavalid => mem_readdatavalid(i),  -- out std_logic
        s0_burstcount    => "0000001",  -- in  std_logic_vector(6 downto 0)
        s0_writedata     => mem_writedata(i),  -- in  std_logic_vector(575 downto 0)
        s0_address       => mem_address(i),  -- in  std_logic_vector(26 downto 0)
        s0_write         => mem_write(i),  -- in  std_logic
        s0_read          => mem_read(i),  -- in  std_logic
        s0_byteenable    => mem_byteenable(i),  -- in  std_logic_vector(71 downto 0)
        s0_debugaccess   => '0'         -- in  std_logic
        );

    -- A second pipeline stage is necessary when both the memory_bist_wrapper and
    -- memory_peek_poke are multiplexed together.
    u2b : pipe_mm_bridge_0
      port map (
        clk              => mem_usr_clk(i),  -- in  std_logic
        m0_waitrequest   => amm_waitrequest(i),  -- in  std_logic
        m0_readdata      => amm_readdata(i),  -- in  std_logic_vector(575 downto 0)
        m0_readdatavalid => amm_readdatavalid(i),  -- in  std_logic
        m0_burstcount    => amm_burstcount(i),  -- out std_logic_vector(5 downto 0)
        m0_writedata     => amm_writedata(i),  -- out std_logic_vector(575 downto 0)
        m0_address       => amm_address(i),  -- out std_logic_vector(26 downto 0)
        m0_write         => amm_write(i),  -- out std_logic
        m0_read          => amm_read(i),  -- out std_logic
        m0_byteenable    => open,  -- out std_logic_vector(71 downto 0)
        m0_debugaccess   => open,  -- out std_logic
        reset            => mem_usr_rst(i),  -- in  std_logic
        s0_waitrequest   => mem_b_waitrequest(i),  -- out std_logic
        s0_readdata      => mem_b_readdata(i),  -- out std_logic_vector(575 downto 0)
        s0_readdatavalid => mem_b_readdatavalid(i),  -- out std_logic
        s0_burstcount    => mem_b_burstcount(i),  -- in  std_logic_vector(6 downto 0)
        s0_writedata     => mem_b_writedata(i),  -- in  std_logic_vector(575 downto 0)
        s0_address       => mem_b_address(i),  -- in  std_logic_vector(26 downto 0)
        s0_write         => mem_b_write(i),  -- in  std_logic
        s0_read          => mem_b_read(i),  -- in  std_logic
        s0_byteenable    => mem_b_byteenable(i),  -- in  std_logic_vector(71 downto 0)
        s0_debugaccess   => '0'         -- in  std_logic
        );

    u3 : entity work.memory_peek_poke
      generic map (
        ADDRESS_OFFSET    => (MEM0_PP_STAT + (256*i)),
        ADDRESS_SIZE      => ADDRESS_SIZE
        )
      port map (
        mem_usr_rst       => mem_usr_rst(i),  -- in  std_logic
        mem_usr_clk       => mem_usr_clk(i),  -- in  std_logic
        -- Memory AvMM Interface
        mem_waitrequest   => mem_waitrequest(i),  -- in  std_logic
        mem_read          => mem_pp_read(i),  -- out std_logic
        mem_write         => mem_pp_write(i),  -- out std_logic
        mem_address       => mem_pp_address(i),  -- out std_logic_vector(ADDRESS_SIZE-1 downto 0)
        mem_readdata      => mem_pp_readdata(i),  -- in  std_logic_vector(639 downto 0)
        mem_writedata     => mem_pp_writedata(i),  -- out std_logic_vector(639 downto 0)
        mem_byteenable    => mem_pp_byteenable(i),  -- out std_logic_vector(79 downto 0)
        mem_readdatavalid => mem_readdatavalid(i),  -- in  std_logic
        mem_cal_success   => mem_cal_success(i),  -- in  std_logic
        mem_cal_fail      => mem_cal_fail(i),  -- in  std_logic
        mem_reset_done    => mem_reset_done(i),  -- in  std_logic
        -- Host Interface
        config_clk        => config_clk,  -- in  std_logic
        config_rstn       => config_rstn(i),  -- in  std_logic
        avmm_writedata    => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
        avmm_address      => avmm_address,  -- in  std_logic_vector(11 downto 0)
        avmm_write        => avmm_write,  -- in  std_logic
        avmm_read         => avmm_read,  -- in  std_logic
        avmm_byteenable   => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
        dout_mem_stat     => dout_mem_stat(i),  -- out std_logic_vector(31 downto 0)
        dout_mem_ctrl     => dout_mem_ctrl(i),  -- out std_logic_vector(31 downto 0)
        dout_depth        => dout_depth(i),  -- out std_logic_vector(31 downto 0)
        dout_send_buf     => dout_send_buf(i),  -- out std_logic_vector(31 downto 0)
        dout_read_buf     => dout_read_buf(i)  -- out std_logic_vector(31 downto 0)
        );

    -- Multiplex AvMM between memory_bist_wrapper and memory_peek_poke
    mem_read(i)    <= mem_bw_read(i)    when (bw_test_running(i) = '1') else mem_pp_read(i);
    mem_write(i)   <= mem_bw_write(i)   when (bw_test_running(i) = '1') else mem_pp_write(i);
    mem_address(i) <= mem_bw_address(i) when (bw_test_running(i) = '1') else mem_pp_address(i);

    mem_writedata(i) <= mem_bw_writedata(i) when (bw_test_running(i) = '1') else (mem_pp_writedata(i)(631 downto 560) &
                                                                                    mem_pp_writedata(i)(551 downto 480) &
                                                                                    mem_pp_writedata(i)(471 downto 400) &
                                                                                    mem_pp_writedata(i)(391 downto 320) &
                                                                                    mem_pp_writedata(i)(311 downto 240) &
                                                                                    mem_pp_writedata(i)(231 downto 160) &
                                                                                    mem_pp_writedata(i)(151 downto 80)  &
                                                                                    mem_pp_writedata(i)(71  downto 0));

    mem_byteenable(i) <= mem_bw_byteenable(i) when (bw_test_running(i) = '1') else (mem_pp_byteenable(i)(78 downto 70) &
                                                                                    mem_pp_byteenable(i)(68 downto 60) &
                                                                                    mem_pp_byteenable(i)(58 downto 50) &
                                                                                    mem_pp_byteenable(i)(48 downto 40) &
                                                                                    mem_pp_byteenable(i)(38 downto 30) &
                                                                                    mem_pp_byteenable(i)(28 downto 20) &
                                                                                    mem_pp_byteenable(i)(18 downto 10) &
                                                                                    mem_pp_byteenable(i)(8  downto 0));

    mem_pp_readdata(i) <= (x"00" & mem_readdata(i)(575 downto 504) &
                           x"00" & mem_readdata(i)(503 downto 432) &
                           x"00" & mem_readdata(i)(431 downto 360) &
                           x"00" & mem_readdata(i)(359 downto 288) &
                           x"00" & mem_readdata(i)(287 downto 216) &
                           x"00" & mem_readdata(i)(215 downto 144) &
                           x"00" & mem_readdata(i)(143 downto 72) &
                           x"00" & mem_readdata(i)(71  downto 0));

  end generate;

  -------------------
  -- Connect Outputs
  -------------------
  mem_usrclk <= mem_usr_clk;

  dout_mem0 <= dout_mem(0);
  dout_mem1 <= dout_mem(1);

  dout_mem_stat0 <= dout_mem_stat(0);
  dout_mem_ctrl0 <= dout_mem_ctrl(0);
  dout_depth0    <= dout_depth(0);
  dout_send_buf0 <= dout_send_buf(0);
  dout_read_buf0 <= dout_read_buf(0);

  dout_mem_stat1 <= dout_mem_stat(1);
  dout_mem_ctrl1 <= dout_mem_ctrl(1);
  dout_depth1    <= dout_depth(1);
  dout_send_buf1 <= dout_send_buf(1);
  dout_read_buf1 <= dout_read_buf(1);


end rtl;
