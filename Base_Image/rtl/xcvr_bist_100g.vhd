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
-- Title       : Transceiver BIST (2x 25G L-Tile)
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : BIST component for Transceiver (2x 25G) testing.
--
--               Following a reset, each transmitter starts sending 64B/66B
--               encoded data. The connected receiver automatically aligns to
--               this encoded data. Once all four receivers are aligned, the
--               data arriving from each receiver is deskewed to give a fully
--               bonded 100G channel.
--
--               To test this channel, a PRBS pattern is transmitted at
--               maximum rate and the received data checked for errors. Bit
--               errors can be injected into the transmitted data. Status
--               registers indicate the received error count and the data
--               transfer rate.
--
--               ============
--               Register Map
--               ============
--
--               Status (offset 0x00)
--               --------------------
--               [03:00]  rx_enh_blk_lock (1111 is locked)
--               [07:04]  rx_ready (1111 is ready)
--               [11:08]  tx_ready (1111 is ready)
--               [12]     tx_pll_locked (1 is locked)
--
--               Control (offset 0x04)
--               ---------------------
--               [00]     Rx PHY reset
--               [01]     Tx PHY reset
--               [04]     Reg Capture
--               [08]     PRBS Enable
--               [09]     PRBS Checker ReSync
--               [15:12]  PRBS Checker Locked (status: 1 is locked))
--               [23:16]  Error Inject (8-bit)
--
--               Error Counts for PHY #0 (offset 0x08)
--               -------------------------------------
--               [15:00]  Ctrl Word (16-bit)
--               [31:16]  Data Word (16-bit)
--
--               Error Counts for PHY #1 (offset 0x0C)
--               -------------------------------------
--               [15:00]  Ctrl Word (16-bit)
--               [31:16]  Data Word (16-bit)
--
--               Error Counts for PHY #2 (offset 0x10)
--               -------------------------------------
--               [15:00]  Ctrl Word (16-bit)
--               [31:16]  Data Word (16-bit)
--
--               Error Counts for PHY #3 (offset 0x14)
--               -------------------------------------
--               [15:00]  Ctrl Word (16-bit)
--               [31:16]  Data Word (16-bit)
--
--               Rx Stats (offset 0x18)
--               ----------------------
--               [15:00]  Rx Data Rate (16-bit) (MBytes/sec)
--               [31:24]  Channel Skew (8-bit)
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


entity xcvr_bist_100g is
  generic (
    ADDRESS_OFFSET      : std_logic_vector(11 downto 0)     := (others => '0')
    );
  port (
    tx_refclk           : in  std_logic;
    rx_refclk           : in  std_logic;
    tx_user_clk         : out std_logic;
    tx_user_clk_locked  : out std_logic;
    tx_serial_data      : out std_logic_vector(3 downto 0);
    rx_serial_data      : in  std_logic_vector(3 downto 0);
    -- Host Interface
    config_clk          : in  std_logic;
    config_rstn         : in  std_logic;
    avmm_writedata      : in  std_logic_vector(31 downto 0);
    avmm_address        : in  std_logic_vector(11 downto 0);
    avmm_write          : in  std_logic;
    avmm_byteenable     : in  std_logic_vector(3 downto 0);
    dout_0              : out std_logic_vector(31 downto 0);
    dout_1              : out std_logic_vector(31 downto 0);
    dout_2              : out std_logic_vector(31 downto 0);
    dout_3              : out std_logic_vector(31 downto 0);
    dout_4              : out std_logic_vector(31 downto 0);
    dout_5              : out std_logic_vector(31 downto 0);
    dout_6              : out std_logic_vector(31 downto 0);
    -- PHY Dynamic Reconfig Port
    dr_phy_write        : in  std_logic;
    dr_phy_read         : in  std_logic;
    dr_phy_address      : in  std_logic_vector(12 downto 0);
    dr_phy_writedata    : in  std_logic_vector(31 downto 0);
    dr_phy_readdata     : out std_logic_vector(31 downto 0);
    dr_phy_readdatavalid: out std_logic;
    dr_phy_waitrequest  : out std_logic
    );
end xcvr_bist_100g;


architecture rtl of xcvr_bist_100g is
  --------------------------
  -- Component Declarations
  --------------------------
  component xcvr_phy_prod is
  port (
    rx_analogreset            : in  std_logic_vector(3 downto 0);
    rx_analogreset_stat       : out std_logic_vector(3 downto 0);
    rx_cal_busy               : out std_logic_vector(3 downto 0);
    rx_cdr_refclk0            : in  std_logic;
    rx_clkout                 : out std_logic_vector(3 downto 0);
    rx_clkout2                : out std_logic_vector(3 downto 0);
    rx_control                : out std_logic_vector(7 downto 0);
    rx_coreclkin              : in  std_logic_vector(3 downto 0);
    rx_digitalreset           : in  std_logic_vector(3 downto 0);
    rx_digitalreset_stat      : out std_logic_vector(3 downto 0);
    rx_enh_blk_lock           : out std_logic_vector(3 downto 0);
    rx_enh_data_valid         : out std_logic_vector(3 downto 0);
    rx_fifo_empty             : out std_logic_vector(3 downto 0);
    rx_fifo_full              : out std_logic_vector(3 downto 0);
    rx_fifo_rd_en             : in  std_logic_vector(3 downto 0);
    rx_is_lockedtodata        : out std_logic_vector(3 downto 0);
    rx_is_lockedtoref         : out std_logic_vector(3 downto 0);
    rx_parallel_data          : out std_logic_vector(255 downto 0);
    rx_serial_data            : in  std_logic_vector(3 downto 0);
    tx_analogreset            : in  std_logic_vector(3 downto 0);
    tx_analogreset_stat       : out std_logic_vector(3 downto 0);
    tx_cal_busy               : out std_logic_vector(3 downto 0);
    tx_clkout                 : out std_logic_vector(3 downto 0);
    tx_control                : in  std_logic_vector(7 downto 0);
    tx_coreclkin              : in  std_logic_vector(3 downto 0);
    tx_digitalreset           : in  std_logic_vector(3 downto 0);
    tx_digitalreset_stat      : out std_logic_vector(3 downto 0);
    tx_enh_data_valid         : in  std_logic_vector(3 downto 0);
    tx_fifo_empty             : out std_logic_vector(3 downto 0);
    tx_fifo_full              : out std_logic_vector(3 downto 0);
    tx_parallel_data          : in  std_logic_vector(255 downto 0);
    tx_serial_clk0            : in  std_logic_vector(3 downto 0);
    tx_serial_data            : out std_logic_vector(3 downto 0);
    unused_rx_parallel_data   : out std_logic_vector(51 downto 0);
    unused_tx_parallel_data   : in  std_logic_vector(51 downto 0);
    reconfig_clk              : in  std_logic_vector(0 downto 0);
    reconfig_reset            : in  std_logic_vector(0 downto 0);
    reconfig_write            : in  std_logic_vector(0 downto 0);
    reconfig_read             : in  std_logic_vector(0 downto 0);
    reconfig_address          : in  std_logic_vector(12 downto 0);
    reconfig_writedata        : in  std_logic_vector(31 downto 0);
    reconfig_readdata         : out std_logic_vector(31 downto 0);
    reconfig_waitrequest      : out std_logic_vector(0 downto 0)
    );
  end component;

  component xcvr_rst_tx_prod is
  port (
    clock                     : in  std_logic;
    pll_locked                : in  std_logic_vector(0 downto 0);
    pll_select                : in  std_logic_vector(0 downto 0);
    reset                     : in  std_logic;
    tx_analogreset            : out std_logic_vector(3 downto 0);
    tx_analogreset_stat       : in  std_logic_vector(3 downto 0);
    tx_cal_busy               : in  std_logic_vector(3 downto 0);
    tx_digitalreset           : out std_logic_vector(3 downto 0);
    tx_digitalreset_stat      : in  std_logic_vector(3 downto 0);
    tx_ready                  : out std_logic_vector(3 downto 0)
    );
  end component;

  component xcvr_rst_rx_prod is
  port (
    clock                     : in  std_logic;
    reset                     : in  std_logic;
    rx_analogreset            : out std_logic_vector(0 downto 0);
    rx_analogreset_stat       : in  std_logic_vector(0 downto 0);
    rx_cal_busy               : in  std_logic_vector(0 downto 0);
    rx_digitalreset           : out std_logic_vector(0 downto 0);
    rx_digitalreset_stat      : in  std_logic_vector(0 downto 0);
    rx_is_lockedtodata        : in  std_logic_vector(0 downto 0);
    rx_ready                  : out std_logic_vector(0 downto 0)
    );
  end component;

  component xcvr_atxpll_prod is
  port (
    pll_cal_busy              : out std_logic;
    pll_locked                : out std_logic;
    pll_refclk0               : in  std_logic;
    tx_serial_clk_gxt         : out std_logic
    );
  end component;

  ---------
  -- Types
  ---------
  type T_16x16_bits is array (0 to 15) of std_logic_vector(15 downto 0);
  type T_4x16_bits  is array (0 to 3)  of std_logic_vector(15 downto 0);
  type T_2x4_bits   is array (0 to 1)  of std_logic_vector(3 downto 0);

  -------------
  -- Constants
  -------------
  constant SAMPLE_PERIOD          : integer                           := 1600;  -- Measurement period in config_clk cycles
  constant PRBS_SEED              : T_16x16_bits                      := (x"0001", x"0002", x"0004", x"0008",
                                                                          x"0010", x"0020", x"0040", x"0080",
                                                                          x"0100", x"0200", x"0400", x"0800",
                                                                          x"1000", x"2000", x"4000", x"8000");

  -----------
  -- Signals
  -----------
  signal rx_analogreset           : std_logic_vector(3 downto 0);
  signal rx_analogreset_stat      : std_logic_vector(3 downto 0);
  signal rx_cal_busy              : std_logic_vector(3 downto 0);
  signal rx_clkout                : std_logic_vector(3 downto 0);
  signal rx_control               : std_logic_vector(7 downto 0);
  signal rx_coreclkin             : std_logic_vector(3 downto 0);
  signal rx_digitalreset          : std_logic_vector(3 downto 0);
  signal rx_digitalreset_stat     : std_logic_vector(3 downto 0);
  signal rx_ready                 : std_logic_vector(3 downto 0);
  signal rx_enh_blk_lock          : std_logic_vector(3 downto 0);
  signal rx_is_lockedtodata       : std_logic_vector(3 downto 0);
  signal rx_enh_data_valid        : std_logic_vector(3 downto 0);
  signal rx_parallel_data         : std_logic_vector(255 downto 0);
  signal tx_reset                 : std_logic;
  signal tx_analogreset           : std_logic_vector(3 downto 0);
  signal tx_analogreset_stat      : std_logic_vector(3 downto 0);
  signal tx_cal_busy              : std_logic_vector(3 downto 0);
  signal tx_clkout                : std_logic_vector(3 downto 0);
  signal tx_coreclkin             : std_logic_vector(3 downto 0);
  signal tx_digitalreset          : std_logic_vector(3 downto 0);
  signal tx_digitalreset_stat     : std_logic_vector(3 downto 0);
  signal tx_ready                 : std_logic_vector(3 downto 0);
  signal tx_serial_clk0           : std_logic_vector(3 downto 0);
  signal pll_cal_busy             : std_logic_vector(1 downto 0);
  signal pll_locked               : std_logic_vector(1 downto 0);
  signal tx_serial_clk            : std_logic_vector(1 downto 0);
  signal atxpll_locked            : std_logic;
  signal config_rst               : std_logic;
  signal dr_phy_waitrequest_i     : std_logic;

  signal rst_tx_count             : std_logic_vector(3 downto 0)      := (others => '0');
  signal rst_tx_pulse             : std_logic                         := '1';
  signal rst_rx_count             : std_logic_vector(3 downto 0)      := (others => '0');
  signal rst_rx_pulse             : std_logic                         := '1';
  signal rst_rx_ctrl              : std_logic                         := '1';
  signal capt_count               : std_logic_vector(3 downto 0)      := (others => '0');
  signal capt_pls                 : std_logic                         := '0';
  signal resync_count             : std_logic_vector(3 downto 0)      := (others => '0');
  signal resync_pls               : std_logic                         := '0';
  signal err_inj_count            : std_logic_vector(3 downto 0)      := (others => '0');
  signal err_inj_pls              : std_logic                         := '0';
  signal prbs_enab                : std_logic                         := '0';
  signal error_inj                : std_logic_vector(7 downto 0)      := (others => '0');
  signal sample_count             : std_logic_vector(11 downto 0)     := (others => '0');
  signal sample_toggle            : std_logic                         := '0';
  signal rx_ready_meta            : T_2x4_bits                        := (others => (others => '0'));
  signal chkr_rst_fbk_meta        : std_logic_vector(1 downto 0)      := (others => '0');
  signal pll_locked_meta          : std_logic_vector(1 downto 0)      := (others => '0');
  signal rx_blk_lock_meta         : T_2x4_bits                        := (others => (others => '0'));
  signal rst_rx_req               : std_logic_vector(3 downto 0);

  signal tx_data_rst              : std_logic;
  signal tx_data_rst_meta         : std_logic_vector(1 downto 0)      := (others => '1');
  signal err_inj_pls_meta         : std_logic_vector(2 downto 0)      := (others => '0');
  signal error_load               : std_logic                         := '0';
  signal prbs_enab_meta           : std_logic_vector(1 downto 0)      := (others => '0');
  signal tx_pls_count             : std_logic_vector(9 downto 0)      := (others => '0');
  signal tx_ctrl_en               : std_logic                         := '0';
  signal prbs_err_acc             : std_logic_vector(7 downto 0)      := (others => '0');
  signal prbs_err_mask            : std_logic_vector(31 downto 0)     := (others => '0');
  signal tx_parallel_data_a1      : std_logic_vector(255 downto 0)    := (others => '1');
  signal tx_control_a1            : std_logic_vector(7 downto 0)      := "01010101";
  signal tx_parallel_data         : std_logic_vector(255 downto 0)    := (others => '1');
  signal tx_control               : std_logic_vector(7 downto 0)      := "01010101";
  signal tx_enh_data_valid        : std_logic_vector(3 downto 0);
  signal prbs_data                : std_logic_vector(255 downto 0);
  signal prbs_reset               : std_logic;
  signal prbs_enable              : std_logic;

  signal rst_rx_req_meta          : T_2x4_bits                        := (others => (others => '0'));
  signal resync_pls_meta          : std_logic_vector(1 downto 0)      := (others => '0');
  signal checker_rst              : std_logic_vector(15 downto 0)     := (others => '0');
  signal checker_rst_d1           : std_logic_vector(15 downto 0)     := (others => '0');
  signal counter_rst              : std_logic_vector(15 downto 0)     := (others => '0');
  signal chkr_rst_fbk             : std_logic;
  signal rx_data_d1               : std_logic_vector(255 downto 0)    := (others => '0');
  signal prbs_chk_en              : std_logic_vector(15 downto 0)     := (others => '0');
  signal ctrl_chk_en              : std_logic_vector(15 downto 0)     := (others => '0');
  signal prbs_chk_lock            : std_logic_vector(15 downto 0);
  signal prbs_chk_err             : std_logic_vector(255 downto 0);
  signal ctrl_chk_err             : std_logic_vector(255 downto 0);
  signal prbs_lock                : std_logic_vector(3 downto 0)      := (others => '0');
  signal sample_tgl_meta          : std_logic_vector(2 downto 0)      := (others => '0');
  signal sample_pls               : std_logic                         := '0';
  signal capt_pls_meta            : std_logic_vector(2 downto 0)      := (others => '0');
  signal capture                  : std_logic                         := '0';
  signal rx_word_count            : std_logic_vector(15 downto 0)     := (others => '0');
  signal rx_word_store            : std_logic_vector(15 downto 0)     := (others => '0');
  signal ctrl_pls                 : std_logic_vector(3 downto 0)      := (others => '0');
  signal ctrl_pls_pipe            : std_logic_vector(1 downto 0)      := (others => '0');
  signal rx_skew_count            : std_logic_vector(7 downto 0)      := (others => '0');
  signal rx_skew_capt             : std_logic_vector(7 downto 0)      := (others => '0');
  signal rx_skew_store            : std_logic_vector(7 downto 0)      := (others => '0');
  signal prbs_err_count           : T_4x16_bits;
  signal ctrl_err_count           : T_4x16_bits;
  signal capt_prbs_err_count      : T_4x16_bits                       := (others => (others => '0'));
  signal capt_ctrl_err_count      : T_4x16_bits                       := (others => (others => '0'));
  signal capt_rx_word_store       : std_logic_vector(15 downto 0)     := (others => '0');
  signal capt_rx_skew_store       : std_logic_vector(7 downto 0)      := (others => '0');


begin
  ---------------
  -- Transceiver
  ---------------
  u0 : xcvr_phy_prod
  port map (
    rx_analogreset            => rx_analogreset,            -- in  std_logic_vector(3 downto 0)
    rx_analogreset_stat       => rx_analogreset_stat,       -- out std_logic_vector(3 downto 0)
    rx_cal_busy               => rx_cal_busy,               -- out std_logic_vector(3 downto 0)
    rx_cdr_refclk0            => rx_refclk,                 -- in  std_logic
    rx_clkout                 => rx_clkout,                 -- out std_logic_vector(3 downto 0)
    rx_clkout2                => open,                      -- out std_logic_vector(3 downto 0)
    rx_control                => rx_control,                -- out std_logic_vector(7 downto 0)
    rx_coreclkin              => rx_coreclkin,              -- in  std_logic_vector(3 downto 0)
    rx_digitalreset           => rx_digitalreset,           -- in  std_logic_vector(3 downto 0)
    rx_digitalreset_stat      => rx_digitalreset_stat,      -- out std_logic_vector(3 downto 0)
    rx_enh_blk_lock           => rx_enh_blk_lock,           -- out std_logic_vector(3 downto 0)
    rx_enh_data_valid         => rx_enh_data_valid,         -- out std_logic_vector(3 downto 0)
    rx_fifo_empty             => open,                      -- out std_logic_vector(3 downto 0)
    rx_fifo_full              => open,                      -- out std_logic_vector(3 downto 0)
    rx_fifo_rd_en             => "1111",                    -- out std_logic_vector(3 downto 0)
    rx_is_lockedtodata        => rx_is_lockedtodata,        -- out std_logic_vector(3 downto 0)
    rx_is_lockedtoref         => open,                      -- out std_logic_vector(3 downto 0)
    rx_parallel_data          => rx_parallel_data,          -- out std_logic_vector(255 downto 0)
    rx_serial_data            => rx_serial_data,            -- in  std_logic_vector(3 downto 0)
    tx_analogreset            => tx_analogreset,            -- in  std_logic_vector(3 downto 0)
    tx_analogreset_stat       => tx_analogreset_stat,       -- out std_logic_vector(3 downto 0)
    tx_cal_busy               => tx_cal_busy,               -- out std_logic_vector(3 downto 0)
    tx_clkout                 => tx_clkout,                 -- out std_logic_vector(3 downto 0)
    tx_control                => tx_control,                -- in  std_logic_vector(7 downto 0)
    tx_coreclkin              => tx_coreclkin,              -- in  std_logic_vector(3 downto 0)
    tx_digitalreset           => tx_digitalreset,           -- in  std_logic_vector(3 downto 0)
    tx_digitalreset_stat      => tx_digitalreset_stat,      -- out std_logic_vector(3 downto 0)
    tx_enh_data_valid         => tx_enh_data_valid,         -- in  std_logic_vector(3 downto 0)
    tx_fifo_empty             => open,                      -- out std_logic_vector(3 downto 0)
    tx_fifo_full              => open,                      -- out std_logic_vector(3 downto 0)
    tx_parallel_data          => tx_parallel_data,          -- in  std_logic_vector(255 downto 0)
    tx_serial_clk0            => tx_serial_clk0,            -- in  std_logic_vector(3 downto 0)
    tx_serial_data            => tx_serial_data,            -- out std_logic_vector(3 downto 0)
    unused_rx_parallel_data   => open,                      -- out std_logic_vector(51 downto 0)
    unused_tx_parallel_data   => x"0000000000000",          -- in  std_logic_vector(51 downto 0)
    -- Dynamic Reconfig Port
    reconfig_clk(0)           => config_clk,                -- in  std_logic_vector(0 downto 0)
    reconfig_reset(0)         => config_rst,                -- in  std_logic_vector(0 downto 0)
    reconfig_write(0)         => dr_phy_write,              -- in  std_logic_vector(0 downto 0)
    reconfig_read(0)          => dr_phy_read,               -- in  std_logic_vector(0 downto 0)
    reconfig_address          => dr_phy_address,            -- in  std_logic_vector(12 downto 0)
    reconfig_writedata        => dr_phy_writedata,          -- in  std_logic_vector(31 downto 0)
    reconfig_readdata         => dr_phy_readdata,           -- out std_logic_vector(31 downto 0)
    reconfig_waitrequest(0)   => dr_phy_waitrequest_i       -- out std_logic_vector(0 downto 0)
    );

  rx_coreclkin      <= (others => rx_clkout(2));
  tx_enh_data_valid <= (others => not tx_data_rst_meta(1));
  tx_serial_clk0    <= (tx_serial_clk(1) & tx_serial_clk(1) & tx_serial_clk(0) & tx_serial_clk(0));
  tx_coreclkin      <= (others => tx_clkout(2));
  config_rst        <= (not config_rstn);

  u1 : xcvr_rst_tx_prod
  port map (
    clock                     => config_clk,                -- in  std_logic
    pll_locked(0)             => atxpll_locked,             -- in  std_logic_vector(0 downto 0)
    pll_select                => "0",                       -- in  std_logic_vector(0 downto 0)
    reset                     => tx_reset,                  -- in  std_logic
    tx_analogreset            => tx_analogreset,            -- out std_logic_vector(3 downto 0)
    tx_analogreset_stat       => tx_analogreset_stat,       -- in  std_logic_vector(3 downto 0)
    tx_cal_busy               => tx_cal_busy,               -- in  std_logic_vector(3 downto 0)
    tx_digitalreset           => tx_digitalreset,           -- out std_logic_vector(3 downto 0)
    tx_digitalreset_stat      => tx_digitalreset_stat,      -- in  std_logic_vector(3 downto 0)
    tx_ready                  => tx_ready                   -- out std_logic_vector(3 downto 0)
    );

  tx_reset      <= rst_tx_pulse or pll_cal_busy(1) or pll_cal_busy(0);    -- Asynchronous reset
  atxpll_locked <= pll_locked(1) and pll_locked(0);

  -- Use four separate rx reset components to allow full lane independence.
  g3 : for i in 0 to 3 generate
    u2 : xcvr_rst_rx_prod
    port map (
      clock                   => config_clk,                -- in  std_logic
      reset                   => rst_rx_pulse,              -- in  std_logic
      rx_analogreset(0)       => rx_analogreset(i),         -- out std_logic_vector(0 downto 0)
      rx_analogreset_stat(0)  => rx_analogreset_stat(i),    -- in  std_logic_vector(0 downto 0)
      rx_cal_busy(0)          => rx_cal_busy(i),            -- in  std_logic_vector(0 downto 0)
      rx_digitalreset(0)      => rx_digitalreset(i),        -- out std_logic_vector(0 downto 0)
      rx_digitalreset_stat(0) => rx_digitalreset_stat(i),   -- in  std_logic_vector(0 downto 0)
      rx_is_lockedtodata(0)   => rx_is_lockedtodata(i),     -- in  std_logic_vector(0 downto 0)
      rx_ready(0)             => rx_ready(i)                -- out std_logic_vector(0 downto 0)
      );
  end generate g3;

  u3 : xcvr_atxpll_prod
  port map (
    pll_cal_busy              => pll_cal_busy(0),           -- out std_logic
    pll_locked                => pll_locked(0),             -- out std_logic
    pll_refclk0               => tx_refclk,                 -- in  std_logic
    tx_serial_clk_gxt         => tx_serial_clk(0)           -- out std_logic
    );

  u4 : xcvr_atxpll_prod
  port map (
    pll_cal_busy              => pll_cal_busy(1),           -- out std_logic
    pll_locked                => pll_locked(1),             -- out std_logic
    pll_refclk0               => tx_refclk,                 -- in  std_logic
    tx_serial_clk_gxt         => tx_serial_clk(1)           -- out std_logic
    );

  ----------------------
  -- Register Interface
  ----------------------
  process(config_clk)
  begin
    if rising_edge(config_clk) then
      -- Transfer signals into config_clk domain
      chkr_rst_fbk_meta <= (chkr_rst_fbk_meta(0) & chkr_rst_fbk);
      pll_locked_meta   <= (pll_locked_meta(0) & atxpll_locked);
      rx_blk_lock_meta  <= (rx_enh_blk_lock, rx_blk_lock_meta(0));

      if config_rstn = '0' then
        rst_tx_count   <= (others => '0');
        rst_tx_pulse   <= '1';
        rst_rx_count   <= (others => '0');
        rst_rx_pulse   <= '1';
        rst_rx_ctrl    <= '1';
        capt_count     <= (others => '0');
        capt_pls       <= '0';
        resync_count   <= (others => '0');
        resync_pls     <= '0';
        err_inj_count  <= (others => '0');
        err_inj_pls    <= '0';
        prbs_enab      <= '0';
        error_inj      <= (others => '0');
        sample_count   <= (others => '0');
        sample_toggle  <= '0';

      else
        -- Reset Pulse for Tx PHYs.
        if (avmm_write = '1') and (avmm_address = ADDRESS_OFFSET + 4) and
           (avmm_byteenable(0) = '1') and (avmm_writedata(1) = '1') then
          rst_tx_count <= (others => '0');
          rst_tx_pulse <= '1';
        elsif rst_tx_count /= "1111" then
          rst_tx_count <= rst_tx_count + 1;
        else
          rst_tx_pulse <= '0';
        end if;

        -- Reset Pulse for Rx PHYs.
        if (avmm_write = '1') and (avmm_address = ADDRESS_OFFSET + 4) and
           (avmm_byteenable(0) = '1') and (avmm_writedata(0) = '1') then
          rst_rx_count <= (others => '0');
          rst_rx_pulse <= '1';
        elsif rst_rx_count /= "1111" then
          rst_rx_count <= rst_rx_count + 1;
        else
          rst_rx_pulse <= '0';
        end if;

        -- Reset Control for Rx Checkers and Counters.
        if (avmm_write = '1') and (avmm_address = ADDRESS_OFFSET + 4) and
           (avmm_byteenable(0) = '1') and (avmm_writedata(0) = '1') then
          rst_rx_ctrl <= '1';
        elsif chkr_rst_fbk_meta(1) = '1' then
          rst_rx_ctrl <= '0';
        end if;

        -- Capture Pulse for grabbing counts from rx_clkout domain.
        if (avmm_write = '1') and (avmm_address = ADDRESS_OFFSET + 4) and
           (avmm_byteenable(0) = '1') and (avmm_writedata(4) = '1') then
          capt_count <= (others => '0');
          capt_pls   <= '1';
        elsif capt_count /= "1111" then
          capt_count <= capt_count + 1;
        else
          capt_pls   <= '0';
        end if;

        -- PRBS Checker Resync Pulse.
        if (avmm_write = '1') and (avmm_address = ADDRESS_OFFSET + 4) and
           (avmm_byteenable(1) = '1') and (avmm_writedata(9) = '1') then
          resync_count <= (others => '0');
          resync_pls   <= '1';
        elsif capt_count /= "1111" then
          resync_count <= resync_count + 1;
        else
          resync_pls   <= '0';
        end if;

        -- Error Injection Pulse.
        if (avmm_write = '1') and (avmm_address = ADDRESS_OFFSET + 4) and
           (avmm_byteenable(2) = '1') and (avmm_writedata(23 downto 16) > 0) then
          err_inj_count <= (others => '0');
          err_inj_pls   <= '1';
        elsif err_inj_count /= "1111" then
          err_inj_count <= err_inj_count + 1;
        else
          err_inj_pls   <= '0';
        end if;

        -- Control Register bits.
        if (avmm_write = '1') and (avmm_address = ADDRESS_OFFSET + 4) then
          if (avmm_byteenable(1) = '1') then
            prbs_enab <= avmm_writedata(8);
          end if;
          if (avmm_byteenable(2) = '1') then
            error_inj <= avmm_writedata(23 downto 16);
          end if;
        end if;

        -- Sample Period for the Received Data Rate measurement
        if (sample_count = SAMPLE_PERIOD - 1) then
          sample_count  <= (others => '0');
          sample_toggle <= not sample_toggle;
        else
          sample_count  <= sample_count + 1;
        end if;

      end if;
    end if;
  end process;

  rst_rx_req <= not rx_ready when rst_rx_ctrl = '1' else "0000";

  --------------------
  -- Tx PHY Interface
  --------------------
  tx_data_rst <= '1' when tx_ready /= "1111" else '0'; 

  process(tx_clkout(2))
  begin
    if rising_edge(tx_clkout(2)) then
      -- Transfer control signals into the tx_clkout domain.
      tx_data_rst_meta <= (tx_data_rst_meta(0) & tx_data_rst);
      err_inj_pls_meta <= (err_inj_pls_meta(1 downto 0) & err_inj_pls);
      error_load       <= (err_inj_pls_meta(2) and not err_inj_pls_meta(1));    -- falling edge
      prbs_enab_meta   <= (prbs_enab_meta(0) & prbs_enab);

      if tx_data_rst_meta(1) = '1' then
        tx_pls_count        <= (others => '0');
        tx_ctrl_en          <= '0';
        tx_parallel_data_a1 <= (others => '1');
        tx_control_a1       <= "01010101";
        prbs_err_acc        <= (others => '0');
        prbs_err_mask       <= (others => '0');

      else
        -- Pulse Generator - Used for timing the control word injection.
        if tx_pls_count = "1111111111" then
          tx_pls_count <= (others => '0');
          tx_ctrl_en   <= '1';
        else
          tx_pls_count <= tx_pls_count + 1;
          tx_ctrl_en   <= '0';
        end if;

        -- Data Mux - Selects the source of data (PRBS or Control).
        if tx_ctrl_en = '1' then            -- Control Word
          for i in 0 to 15 loop
            tx_parallel_data_a1((i*16)+15 downto (i*16)) <= PRBS_SEED(i);
          end loop;
          tx_control_a1       <= "10101010";
        else                                -- Data Word
          tx_parallel_data_a1 <= prbs_data;
          tx_control_a1       <= "01010101";
        end if;

        -- Error Injection.
        if error_load = '1' then            -- Transfer the number of errors into accumulator
          prbs_err_acc <= error_inj;
        else
          -- Calculate the next accumulator value.
          if prbs_err_acc >= 32 then
            prbs_err_acc <= prbs_err_acc - 32;
          else
            prbs_err_acc <= (others => '0');
          end if;
        end if;

        -- Set the error inject mask.
        for i in 0 to 31 loop
          if prbs_err_acc > i then
            prbs_err_mask(i) <= '1';
          else
            prbs_err_mask(i) <= '0';
          end if;
        end loop;

        -- Toggle the errored data bits (error mask is applied to 1 in 8 bits).
        for i in 0 to 31 loop
          if prbs_err_mask(i) = '1' then
            tx_parallel_data(i*8) <= not tx_parallel_data_a1(i*8);
          else
            tx_parallel_data(i*8) <= tx_parallel_data_a1(i*8);
          end if;
          tx_parallel_data((i*8)+7 downto (i*8)+1) <= tx_parallel_data_a1((i*8)+7 downto (i*8)+1);
        end loop;
        tx_control <= tx_control_a1;

      end if;
    end if;
  end process;

  prbs_reset  <= tx_data_rst_meta(1) or not prbs_enab_meta(1);
  prbs_enable <= not tx_ctrl_en;

  g0 : for i in 0 to 15 generate
    i_prbs_gen : entity work.prbs_gen
    generic map (
      width               => 16,
      data_width          => 16 
      )
    port map (
      clock               => tx_clkout(2),                            -- in  std_logic
      sync_reset          => prbs_reset,                              -- in  std_logic
      enable              => prbs_enable,                             -- in  std_logic
      load                => '0',                                     -- in  std_logic
      prbs_context_in     => PRBS_SEED(i),                            -- in  std_logic_vector(width-1 downto 0)
      prbs_context_out    => open,                                    -- out std_logic_vector(width-1 downto 0)
      data                => prbs_data((i*16)+15 downto (i*16))       -- out std_logic_vector(data_width-1 downto 0)
      );
  end generate g0;

  --------------------
  -- Rx PHY Interface
  --------------------
  process(rx_clkout(2))
  begin
    if rising_edge(rx_clkout(2)) then
      -- Transfer control signals into the rx_clkout domain.
      rst_rx_req_meta <= (rst_rx_req, rst_rx_req_meta(0));
      rx_ready_meta   <= (rx_ready, rx_ready_meta(0));
      resync_pls_meta <= (resync_pls_meta(0) & resync_pls);
      sample_tgl_meta <= (sample_tgl_meta(1 downto 0) & sample_toggle);
      sample_pls      <= (sample_tgl_meta(1) xor sample_tgl_meta(2));
      capt_pls_meta   <= (capt_pls_meta(1 downto 0) & capt_pls);
      capture         <= (capt_pls_meta(1) and not capt_pls_meta(2));          -- rising edge

      -- Reset Control for Rx Checkers and Counters.
      for i in 0 to 3 loop
        if (rst_rx_req_meta(1)(i) = '1') or (resync_pls_meta(1) = '1') then
          checker_rst((i*4)+3 downto (i*4)) <= "1111";
        elsif (rx_ready_meta(1)(i) and rx_enh_blk_lock(i) and rx_enh_data_valid(i)) = '1' then
          checker_rst((i*4)+3 downto (i*4)) <= "0000";
        end if;
      end loop;

      -- Pipeline Checker Reset.
      checker_rst_d1 <= checker_rst;

      if checker_rst /= x"0000" then
        counter_rst <= (others => '1');
      else
        for i in 0 to 3 loop
          if prbs_chk_lock((i*4)+3 downto (i*4)) = "1111" then
            counter_rst((i*4)+3 downto (i*4)) <= "0000";
          end if;
        end loop;
      end if;

      -- Pipeline Data and Control.
      rx_data_d1 <= rx_parallel_data;

      -- Determine enables for Checkers.
      for i in 0 to 3 loop
        if rx_enh_data_valid(i) = '1' then
          if rx_control((i*2)+1 downto (i*2)) = "10" then
            prbs_chk_en((i*4)+3 downto (i*4)) <= "0000";
            ctrl_chk_en((i*4)+3 downto (i*4)) <= "1111";
          else
            prbs_chk_en((i*4)+3 downto (i*4)) <= "1111";
            ctrl_chk_en((i*4)+3 downto (i*4)) <= "0000";
          end if;
        else
          prbs_chk_en((i*4)+3 downto (i*4)) <= "0000";
          ctrl_chk_en((i*4)+3 downto (i*4)) <= "0000";
        end if;
      end loop;

      -- Combine PRBS Locked status.
      if checker_rst /= x"0000" then
        prbs_lock    <= (others => '0');
      else
        for i in 0 to 3 loop
          prbs_lock(i) <= (prbs_chk_lock((i*4)+3) and prbs_chk_lock((i*4)+2) and 
                           prbs_chk_lock((i*4)+1) and prbs_chk_lock((i*4)));
        end loop;
      end if;

      -- Continually measure the received data rate.
      if sample_pls = '1' then
        rx_word_count <= (others => '0');
        rx_word_store <= rx_word_count;
      elsif (chkr_rst_fbk = '0') and (rx_enh_data_valid(2) = '1') and (rx_word_count /= x"FFFF") then
        rx_word_count <= rx_word_count + 1;
      end if;

      -- Continually measure the channel skew.
      for i in 0 to 3 loop
        if (rx_control((i*2)+1 downto (i*2)) = "10") and (rx_enh_data_valid(i) = '1') then
          ctrl_pls(i) <= '1';
        else
          ctrl_pls(i) <= '0';
        end if;
      end loop;

      ctrl_pls_pipe <= (ctrl_pls_pipe(0) & (ctrl_pls(0) or ctrl_pls(1) or ctrl_pls(2) or ctrl_pls(3)));

      if (rx_skew_count = x"00") and (ctrl_pls_pipe(0) = '1') then
        rx_skew_count <= rx_skew_count + 1; -- Skew counter, must be at least half the size of the tx control word injection counter
      elsif rx_skew_count /= x"00" then
        rx_skew_count <= rx_skew_count + 1;
      end if;

      if ctrl_pls_pipe(1) = '1' then
        rx_skew_capt <= rx_skew_count;      -- Capture the skew count for each rx control word pulse
      end if;

      if rx_skew_count = x"00" then
        rx_skew_store <= rx_skew_capt;      -- Store the last captured skew count value
      end if;

      -- Capture the count values for reading from the config_clk domain.
      if checker_rst /= x"0000" then
        capt_prbs_err_count <= (others => (others => '0'));
        capt_ctrl_err_count <= (others => (others => '0'));
        capt_rx_word_store  <= (others => '0');
        capt_rx_skew_store  <= (others => '0');
      elsif capture = '1' then
        capt_prbs_err_count <= prbs_err_count;
        capt_ctrl_err_count <= ctrl_err_count;
        capt_rx_word_store  <= rx_word_store;
        capt_rx_skew_store  <= rx_skew_store;
      end if;

    end if;
  end process;

  chkr_rst_fbk <= '1' when checker_rst = x"FFFF" else '0';

  g1 : for i in 0 to 15 generate
    i_prbs_chk : entity work.prbs_checker
    generic map (
      width               => 16,
      data_width          => 16,
      lock_width          => 4
      )
    port map (
      clock               => rx_clkout(2),                            -- in  std_logic
      sync_reset          => checker_rst_d1(i),                       -- in  std_logic
      enable              => prbs_chk_en(i),                          -- in  std_logic
      load                => '0',                                     -- in  std_logic
      prbs_context_in     => x"00000",                                -- in  std_logic_vector(lock_width+width-1 downto 0)
      prbs_context_out    => open,                                    -- out std_logic_vector(lock_width+width-1 downto 0)
      prbs                => rx_data_d1((i*16)+15 downto (i*16)),     -- in  std_logic_vector(data_width-1 downto 0)
      data                => prbs_chk_err((i*16)+15 downto (i*16)),   -- out std_logic_vector(data_width-1 downto 0)
      match               => open,                                    -- out std_logic
      prbs_lock           => prbs_chk_lock(i)                         -- out std_logic
      );

    i_ctrl_chk : entity work.bit_checker
    generic map (
      data_width          => 16
      )
    port map (
      clock               => rx_clkout(2),                            -- in  std_logic
      sync_reset          => checker_rst_d1(i),                       -- in  std_logic
      enable              => ctrl_chk_en(i),                          -- in  std_logic
      input_0             => rx_data_d1((i*16)+15 downto (i*16)),     -- in  std_logic_vector(data_width-1 downto 0)
      input_1             => PRBS_SEED(i),                            -- in  std_logic_vector(data_width-1 downto 0)
      data                => ctrl_chk_err((i*16)+15 downto (i*16))    -- out std_logic_vector(data_width-1 downto 0)
      );
  end generate g1;

  g2 : for i in 0 to 3 generate
    i_prbs_count : entity work.err_count_64
    port map (
      clock               => rx_clkout(2),                            -- in  std_logic
      sync_reset          => counter_rst(i*4),                        -- in  std_logic
      enable              => prbs_chk_en(i*4),                        -- in  std_logic
      data                => prbs_chk_err((i*64)+63 downto (i*64)),   -- in  std_logic_vector(63 downto 0)
      count               => prbs_err_count(i)                        -- out std_logic_vector(15 downto 0)
      );

    i_ctrl_count : entity work.err_count_64
    port map (
      clock               => rx_clkout(2),                            -- in  std_logic
      sync_reset          => counter_rst(i*4),                        -- in  std_logic
      enable              => ctrl_chk_en(i*4),                        -- in  std_logic
      data                => ctrl_chk_err((i*64)+63 downto (i*64)),   -- in  std_logic_vector(63 downto 0)
      count               => ctrl_err_count(i)                        -- out std_logic_vector(15 downto 0)
      );
  end generate g2;

  ----------------------
  -- Connect up Outputs
  ----------------------
  dout_0 <= (x"0000" & "000" & pll_locked_meta(1) & tx_ready & rx_ready & rx_blk_lock_meta(1));
  dout_1 <= (x"0000" & prbs_lock & "000" & prbs_enab & x"00");
  dout_2 <= (capt_prbs_err_count(0) & capt_ctrl_err_count(0));
  dout_3 <= (capt_prbs_err_count(1) & capt_ctrl_err_count(1));
  dout_4 <= (capt_prbs_err_count(2) & capt_ctrl_err_count(2));
  dout_5 <= (capt_prbs_err_count(3) & capt_ctrl_err_count(3));
  dout_6 <= (capt_rx_skew_store & x"00" & capt_rx_word_store);

  tx_user_clk        <= tx_clkout(2);
  tx_user_clk_locked <= tx_ready(2);

  dr_phy_readdatavalid <= not dr_phy_waitrequest_i when dr_phy_read = '1' else '0';
  dr_phy_waitrequest   <= dr_phy_waitrequest_i;


end rtl;
