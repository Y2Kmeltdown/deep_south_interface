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
--      Copyright ÃÂÃÂ© 1998-2020 Nallatech Limited. All rights reserved.
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
-- Title       : 520N-MX Stratix-10 BIST (top level)
-- Project     : 520N-MX
--------------------------------------------------------------------------------
-- Description : This is the top level of the 520N-MX BIST.
--
-- 2 x 32GB DDR4 DIMM version (4-bit, no byte write)
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
use ieee.std_logic_arith.all;

use work.pkg_user_registers.all;


entity bist_top_me1 is
  port (
    led_user_red     : out   std_logic_vector(1 downto 0);
    led_user_grn     : out   std_logic_vector(1 downto 0);
    led_qsfp         : out   std_logic_vector(3 downto 0);
    u1pps            : in    std_logic;
    config_clk       : in    std_logic;
    usr_refclk0      : in    std_logic;
    usr_refclk1      : in    std_logic;
    -----------------------------------------------------------------------------
    -- Clock test outputs
    -----------------------------------------------------------------------------
    test             : out   std_logic_vector(1 downto 0);
    -----------------------------------------------------------------------------
    -- PCIe Gen3 x16
    -----------------------------------------------------------------------------
    pcie_perstn      : in    std_logic;
    pcie_refclk      : in    std_logic;
    pcie_rx          : in    std_logic_vector(15 downto 0);
    pcie_tx          : out   std_logic_vector(15 downto 0);
    -----------------------------------------------------------------------------
    -- System Manager Interface
    -----------------------------------------------------------------------------
    conf_c_in        : in    std_logic_vector(3 downto 0);
    conf_c_out       : out   std_logic_vector(3 downto 0);
    conf_d           : inout std_logic_vector(07 downto 0);
    soft_recfg_req_n : out   std_logic;
    -----------------------------------------------------------------------------
    -- BMC SPI Interface
    -----------------------------------------------------------------------------
    spi_mosi         : in    std_logic;
    spi_nss          : in    std_logic;
    spi_sclk         : in    std_logic;
    spi_miso         : inout std_logic;
    bmc_irq          : out   std_logic;
    fpga_gpio_1      : in    std_logic;
    fpga_rst_n       : in    std_logic;
    -----------------------------------------------------------------------------
    -- HBM2 catastrophic trip
    -----------------------------------------------------------------------------
    uib_cattrip      :  out std_logic_vector(1 downto 0);
    -----------------------------------------------------------------------------
    -- QSFP I2C - inc arbitration
    -- --------------------------------------------------------------------------
    qsfp_i2c         : inout std_logic_vector(3 downto 0);
    qsfp_irq_n       : in    std_logic_vector(3 downto 0);
    -----------------------------------------------------------------------------
    -- ESRAM ref
    -----------------------------------------------------------------------------
    esram_0_refclk   : in    std_logic;
    esram_1_refclk   : in    std_logic;

    -----------------------------------------------------------------------------
    -- HBM UIB reference clocks
    -----------------------------------------------------------------------------
    hbm_bottom_ref_clks_pll_ref_clk : in    std_logic;
    hbm_top_ref_clks_pll_ref_clk    : in    std_logic;
    --------------------------------------------------------
    -- HBM boundary scan pins - (no explicit pin assignments)
    --------------------------------------------------------
    hbm_bottom_m2u_cattrip          : in    std_logic;
    hbm_bottom_m2u_temp             : in    std_logic_vector(2 downto 0);
    hbm_bottom_m2u_wso              : in    std_logic_vector(7 downto 0);
    hbm_bottom_m2u_reset            : out   std_logic;  -- reset
    hbm_bottom_m2u_wrst             : out   std_logic;  -- wrst
    hbm_bottom_m2u_wrck             : out   std_logic;  -- wrck
    hbm_bottom_m2u_shiftwr          : out   std_logic;  -- shiftwr
    hbm_bottom_m2u_capturewr        : out   std_logic;  -- capturewr
    hbm_bottom_m2u_updatewr         : out   std_logic;  -- updatewr
    hbm_bottom_m2u_selectwir        : out   std_logic;  -- selectwir
    hbm_bottom_m2u_wsi              : out   std_logic;  -- wsi
    hbm_top_m2u_cattrip             : in    std_logic;
    hbm_top_m2u_temp                : in    std_logic_vector(2 downto 0);
    hbm_top_m2u_wso                 : in    std_logic_vector(7 downto 0);
    hbm_top_m2u_reset               : out   std_logic;  -- reset
    hbm_top_m2u_wrst                : out   std_logic;  -- wrst
    hbm_top_m2u_wrck                : out   std_logic;  -- wrck
    hbm_top_m2u_shiftwr             : out   std_logic;  -- shiftwr
    hbm_top_m2u_capturewr           : out   std_logic;  -- capturewr
    hbm_top_m2u_updatewr            : out   std_logic;  -- updatewr
    hbm_top_m2u_selectwir           : out   std_logic;  -- selectwir
    hbm_top_m2u_wsi                 : out   std_logic;  -- wsi
    -----------------------------------------------------------------------------
    -- 100G Serial Links
    -----------------------------------------------------------------------------
    xcvr_refclk_0                   : in    std_logic;
    rcvrd_refclk_0                  : in    std_logic;
    tx_serial_data_0                : out   std_logic_vector(3 downto 0);
    rx_serial_data_0                : in    std_logic_vector(3 downto 0);
    xcvr_refclk_1                   : in    std_logic;
    rcvrd_refclk_1                  : in    std_logic;
    tx_serial_data_1                : out   std_logic_vector(3 downto 0);
    rx_serial_data_1                : in    std_logic_vector(3 downto 0);
    xcvr_refclk_2                   : in    std_logic;
    rcvrd_refclk_2                  : in    std_logic;
    tx_serial_data_2                : out   std_logic_vector(3 downto 0);
    rx_serial_data_2                : in    std_logic_vector(3 downto 0);
    xcvr_refclk_3                   : in    std_logic;
    rcvrd_refclk_3                  : in    std_logic;
    tx_serial_data_3                : out   std_logic_vector(3 downto 0);
    rx_serial_data_3                : in    std_logic_vector(3 downto 0);
    -----------------------------------------------------------------------------
    -- XCVR Recovered clock outputs
    -----------------------------------------------------------------------------
    rx_clkout_0                     : out   std_logic;
    rx_clkout_1                     : out   std_logic;
    -----------------------------------------------------------------------------
    -- PCIe OCuLink GPIO
    -----------------------------------------------------------------------------
    oc0_gpio                        : inout std_logic_vector(15 downto 0);
    oc1_gpio                        : inout std_logic_vector(15 downto 0);
    oc0_gpio_dir                    : out   std_logic_vector(15 downto 0);
    oc1_gpio_dir                    : out   std_logic_vector(15 downto 0);
    oc_buff_en_n                    : out   std_logic_vector(7 downto 2);
    opci_buff_in_sel                : out   std_logic_vector(3 downto 2);
    oc_perst_n                      : in    std_logic_vector(3 downto 2);
    -----------------------------------------------------------------------------
    -- UART
    ------------------------------------------------------------------------------
    uart_tx                         : in    std_logic;
    uart_rx                         : out   std_logic;
    -----------------------------------------------------------------------------
    -- OcuLink Serial (RHS PCIe HIP capable, limited to 12.5G)
    -----------------------------------------------------------------------------
    xcvr_refclk_4                   : in    std_logic;
    tx_serial_data_4                : out   std_logic_vector(3 downto 0);
    rx_serial_data_4                : in    std_logic_vector(3 downto 0);
-- xcvr_refclk_5 : in std_logic;
    tx_serial_data_5                : out   std_logic_vector(3 downto 0);
    rx_serial_data_5                : in    std_logic_vector(3 downto 0);
    xcvr_refclk_6                   : in    std_logic;
    tx_serial_data_6                : out   std_logic_vector(3 downto 0);
    rx_serial_data_6                : in    std_logic_vector(3 downto 0);
-- xcvr_refclk_7 : in std_logic;
    tx_serial_data_7                : out   std_logic_vector(3 downto 0);
    rx_serial_data_7                : in    std_logic_vector(3 downto 0);
    -----------------------------------------------------------------------------
    -- OcuLink Serial (RHS non PCIe HIP, 100G)
    -----------------------------------------------------------------------------
    xcvr_refclk_8                   : in    std_logic;
    xcvr_refclk_9                   : in    std_logic;
    xcvr_refclk_10                  : in    std_logic;
    xcvr_refclk_11                  : in    std_logic
    );
end bist_top_me1;


architecture rtl of bist_top_me1 is
  --------------------------
  -- Component Declarations
  --------------------------
  component qsys_top is
                       port (
                         -- BMC irq
                         bmc_irq_irq                                         : out   std_logic;
                         -- PCIe irq
                         pcie_irq_irq                                        : out   std_logic;
                         -- esram
                         esram_0_refclk_clk                                  : in    std_logic;
                         esram_0_iopll_lock_iopll_lock                       : out   std_logic;
--                         esram_1_refclk_clk                                  : in    std_logic;
--                         esram_1_iopll_lock_iopll_lock                       : out   std_logic;
                         -- Avalon MM Master
                         avmm_master_waitrequest                             : in    std_logic;
                         avmm_master_readdata                                : in    std_logic_vector(31 downto 0);
                         avmm_master_readdatavalid                           : in    std_logic;
                         avmm_master_burstcount                              : out   std_logic_vector(0 downto 0);
                         avmm_master_writedata                               : out   std_logic_vector(31 downto 0);
                         avmm_master_address                                 : out   std_logic_vector(11 downto 0);
                         avmm_master_write                                   : out   std_logic;
                         avmm_master_read                                    : out   std_logic;
                         avmm_master_byteenable                              : out   std_logic_vector(3 downto 0);
                         avmm_master_debugaccess                             : out   std_logic;
                         -- Clocks and Resets
                         config_clk_clk                                      : in    std_logic;
                         config_rstn_reset_n                                 : in    std_logic;
                         -- System Manager Interface
                         conf_c_in_conf_c_in                                 : in    std_logic_vector(3 downto 0);
                         conf_c_out_conf_c_out                               : out   std_logic_vector(3 downto 0);
                         conf_d_conf_d                                       : inout std_logic_vector(07 downto 0);
                         soft_recfg_req_n_soft_reconfigure_req_n             : out   std_logic;
                         -- BMC SPI Slave 
                         spi_mosi_to_the_spislave_inst_for_spichain          : in    std_logic;
                         spi_nss_to_the_spislave_inst_for_spichain           : in    std_logic;
                         spi_sclk_to_the_spislave_inst_for_spichain          : in    std_logic;
                         spi_miso_to_and_from_the_spislave_inst_for_spichain : inout std_logic;
                         -- PCIe Gen3 x16
                         pcie_hip_ctrl_simu_mode_pipe                        : in    std_logic;
                         pcie_hip_ctrl_test_in                               : in    std_logic_vector(66 downto 0);
                         pcie_npor_npor                                      : in    std_logic;
                         pcie_npor_pin_perst                                 : in    std_logic;
                         pcie_refclk_clk                                     : in    std_logic;
                         pcie_serial_rx_in0                                  : in    std_logic;
                         pcie_serial_rx_in1                                  : in    std_logic;
                         pcie_serial_rx_in2                                  : in    std_logic;
                         pcie_serial_rx_in3                                  : in    std_logic;
                         pcie_serial_rx_in4                                  : in    std_logic;
                         pcie_serial_rx_in5                                  : in    std_logic;
                         pcie_serial_rx_in6                                  : in    std_logic;
                         pcie_serial_rx_in7                                  : in    std_logic;
                         pcie_serial_rx_in8                                  : in    std_logic;
                         pcie_serial_rx_in9                                  : in    std_logic;
                         pcie_serial_rx_in10                                 : in    std_logic;
                         pcie_serial_rx_in11                                 : in    std_logic;
                         pcie_serial_rx_in12                                 : in    std_logic;
                         pcie_serial_rx_in13                                 : in    std_logic;
                         pcie_serial_rx_in14                                 : in    std_logic;
                         pcie_serial_rx_in15                                 : in    std_logic;
                         pcie_serial_tx_out0                                 : out   std_logic;
                         pcie_serial_tx_out1                                 : out   std_logic;
                         pcie_serial_tx_out2                                 : out   std_logic;
                         pcie_serial_tx_out3                                 : out   std_logic;
                         pcie_serial_tx_out4                                 : out   std_logic;
                         pcie_serial_tx_out5                                 : out   std_logic;
                         pcie_serial_tx_out6                                 : out   std_logic;
                         pcie_serial_tx_out7                                 : out   std_logic;
                         pcie_serial_tx_out8                                 : out   std_logic;
                         pcie_serial_tx_out9                                 : out   std_logic;
                         pcie_serial_tx_out10                                : out   std_logic;
                         pcie_serial_tx_out11                                : out   std_logic;
                         pcie_serial_tx_out12                                : out   std_logic;
                         pcie_serial_tx_out13                                : out   std_logic;
                         pcie_serial_tx_out14                                : out   std_logic;
                         pcie_serial_tx_out15                                : out   std_logic;
                         pcie_user_clk_clk                                   : out   std_logic;
                         pcie_user_rst_reset                                 : out   std_logic
                         );
  end component;

  component s10_reset_release is
		         port (
			   ninit_done : out std_logic
		           );
  end component s10_reset_release;

--  component pll_cooker is
--                         port (
--                           locked   : out std_logic;
--                           outclk_0 : out std_logic;
--                           refclk   : in  std_logic;
--                           rst      : in  std_logic
--                           );
--  end component;

  component s10_clock_mux is
                            port (
                              inclk0x   : in  std_logic;
                              inclk1x   : in  std_logic;
                              clkselect : in  std_logic;
                              outclk    : out std_logic
                              );
  end component;

  -------------
  -- Constants
  -------------
  constant NUM_X8_REG : integer := 2000;  -- Limit = 68000
  constant NUM_BRAM   : integer := 64;    -- Limit = 1800
  constant NUM_DSP    : integer := 64;    -- Limit = 5000

  -- 2.0 Mb/s @ 50 MHz
  constant SAMPLE_RATIO : std_logic_vector(11 downto 0) := x"019";

  constant UART_BR_AWIDTH : integer := 9;

  -----------
  -- Signals
  -----------
  signal hrt_beat           : std_logic_vector(4 downto 0);
  signal config_rstn        : std_logic_vector(NUM_RSTS-1 downto 0);
  signal config_rstn_init   : std_logic_vector(NUM_RSTS-1 downto 0);
  signal config_rstn_i      : std_logic;
  signal config_rst         : std_logic;
  signal init_done_n        : std_logic;
  signal fpga_rst_n_sync    : std_logic;
  signal pcie_user_rst_sync : std_logic;
  signal pcie_test_in       : std_logic_vector(66 downto 0);
  signal pcie_user_clk      : std_logic;
  signal pcie_user_rst      : std_logic;
  signal avmm_waitrequest   : std_logic;
  signal avmm_readdata      : std_logic_vector(31 downto 0);
  signal avmm_readdatavalid : std_logic;
  signal avmm_burstcount    : std_logic_vector(0 downto 0);
  signal avmm_writedata     : std_logic_vector(31 downto 0);
  signal avmm_address       : std_logic_vector(11 downto 0);
  signal avmm_write         : std_logic;
  signal avmm_read          : std_logic;
  signal avmm_byteenable    : std_logic_vector(3 downto 0);
  signal avmm_debugaccess   : std_logic;
  signal slave_wait         : std_logic;
  signal user_regs          : T_user_registers;
  signal test_reg_0         : std_logic_vector(31 downto 0);
  signal test_reg_1         : std_logic_vector(31 downto 0);
  signal led_control        : std_logic_vector(2 downto 0);
  signal cook_size          : std_logic_vector(1 downto 0);
  signal cook_sreg          : std_logic_vector(7 downto 0);
  signal cook_bram          : std_logic_vector(7 downto 0);
  signal cook_dsp           : std_logic_vector(7 downto 0);
  signal cook_cken          : std_logic;
  signal cook_clk           : std_logic;
  signal cook_clk_n         : std_logic;
  signal pll_cook_clk       : std_logic;
  signal rcvrd_refclk       : std_logic_vector(NUM_QSFP_GRPS-1 downto 0);
  signal test_clock         : std_logic_vector(NUM_CLKS-1 downto 0);
  signal test_clock_stat    : std_logic_vector(NUM_CLKS-1 downto 0);
  signal mem_usrclk         : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal mem_usr_stat       : std_logic_vector(NUM_DDR4_IF-1 downto 0);
  signal dout_mem0          : T_mem_status;
  signal dout_mem1          : T_mem_status;
  signal xcvr_user_clk      : std_logic_vector(NUM_XCVR_GRPS-1 downto 0);
  signal xcvr_user_clk_lock : std_logic_vector(NUM_XCVR_GRPS-1 downto 0);
  signal rx_rcvr_clkout     : std_logic_vector(4 downto 0);
  signal ocu_rx_rcvr_clkout : std_logic_vector(4 downto 0);
  signal unused_gnd         : std_logic_vector(127 downto 0) := (others => '0');
  signal clock_count        : T_count_out;
  signal sreg_cook_out      : std_logic_vector(1 downto 0);
  signal bram_cook_out      : std_logic_vector(1 downto 0);
  signal dsp_cook_out       : std_logic_vector(1 downto 0);
  signal xcvr_pll_cal_busy  : std_logic_vector(1 downto 0);
  signal xcvr_pll_locked    : std_logic_vector(1 downto 0);
  signal xcvr_tx_serial_clk : std_logic_vector(1 downto 0);
  signal esram_0_iopll_lock : std_logic;
  signal esram_1_iopll_lock : std_logic;
  signal oc0_gpio_dir_i     : std_logic_vector(15 downto 0);
  signal oc1_gpio_dir_i     : std_logic_vector(15 downto 0);
  signal oc0_gpio_control   : std_logic_vector(15 downto 0);
  signal oc1_gpio_control   : std_logic_vector(15 downto 0);
  signal oc0_gpio_status    : std_logic_vector(15 downto 0);
  signal oc1_gpio_status    : std_logic_vector(15 downto 0);
  signal uart_addr          : std_logic_vector(31 downto 0);
  signal uart_wr_data       : std_logic_vector(31 downto 0);
  signal uart_wr_en         : std_logic;
  signal uart_rd_en         : std_logic;
  signal uart_rd_en_d1      : std_logic                      := '0';
  signal uart_rd_data       : std_logic_vector(31 downto 0);
  signal uart_rd_rdy        : std_logic;


begin
  -------------
  -- Heartbeat
  -------------
  u10 : entity work.heartbeat_50m
    port map (
      clk      => config_clk,           -- in  std_logic
      hrt_beat => hrt_beat              -- out std_logic_vector(4 downto 0)
      );

  -- User LEDs
  led_user_red(0) <= '1' when (led_control(1 downto 0) = "10") or (led_control(2) = '1') else not hrt_beat(1);
  led_user_grn(0) <= '1' when (led_control(1 downto 0) = "01") or (led_control(2) = '1') else not hrt_beat(1);
  led_user_red(1) <= '1' when (led_control(1 downto 0) = "10") or (led_control(2) = '1') else not hrt_beat(2);
  led_user_grn(1) <= '1' when (led_control(1 downto 0) = "01") or (led_control(2) = '1') else not hrt_beat(2);

  -- Front Panel QSFP LEDs
  led_qsfp <= "1111" when (led_control(2 downto 0) = "010") or (led_control(2) = '1') else "0000";

  --------------------
  -- 1PPS Test Source
  --------------------
  u11 : entity work.clock_gen
    generic map (
      DIVISOR => 5
      )
    port map (
      clk     => config_clk,            -- in  std_logic
      clk_out => test(0)                -- out std_logic
      );

  u13 : entity work.clock_gen
    generic map (
      DIVISOR => 5
      )
    port map (
      clk     => config_clk,            -- in  std_logic
      clk_out => test(1)                -- out std_logic
      );


  ------------------
  -- Power On Reset
  ------------------
  u12 : entity work.pwr_on_rst_init_dist
    generic map (
      NUMBER_OF_CYCLES => x"0007A120",  -- 10ms
      FAN_OUT          => NUM_RSTS
      )
    port map (
      clk              => config_clk,   -- in  std_logic
      init_done_n      => config_rstn_i,  -- in  std_logic
      por_n            => config_rstn_init   -- out std_logic_vector(NUM_RSTS-1 downto 0)
      );

  u14 : s10_reset_release
    port map (
      ninit_done       => init_done_n   -- out std_logic
      );

  u15 : entity work.reset_filter
  port map (
    enable                      => '1',
    rstn_raw                    => init_done_n,
    clk                         => config_clk,
    rstn_filtered               => config_rstn_i
  );
  
  u16 : entity work.bretime_async_rst
    generic map (
      DEPTH     => 3
      )
    port map (
      clock     => config_clk,
      d         => fpga_rst_n,
      q         => fpga_rst_n_sync
    );

  u17 : entity work.bretime_async_rst
    generic map (
      DEPTH     => 3
      )
    port map (
      clock     => config_clk,
      d         => pcie_user_rst,
      q         => pcie_user_rst_sync
    );
  
  process (config_clk)
  begin
    if rising_edge(config_clk) then
      for i in 0 to NUM_RSTS-1 loop
        config_rstn(i) <= config_rstn_init(i) and fpga_rst_n_sync and (not (pcie_user_rst_sync));
      end loop;
    end if;
  end process;
--  ----------
--  -- Cooker
--  ----------
--  u21 : pll_cooker
--    port map (
--      locked   => open,                 -- out std_logic
--      outclk_0 => pll_cook_clk,         -- out std_logic
--      refclk   => usr_refclk0,          -- in  std_logic
--      rst      => '0'                   -- in  std_logic
--      );
--
--  u22 : s10_clock_mux
--    port map (
--      inclk0x   => '0',                 -- in  std_logic
--      inclk1x   => pll_cook_clk,        -- in  std_logic
--      clkselect => cook_cken,           -- in  std_logic
--      outclk    => cook_clk             -- out std_logic
--      );
--
--  u23 : entity work.cooker_wrapper
--    generic map (
--      NUM_X8_REG    => NUM_X8_REG/2,
--      NUM_BRAM      => NUM_BRAM/2,
--      NUM_DSP       => NUM_DSP/2
--      )
--    port map (
--      cook_clk      => cook_clk,          -- in  std_logic
--      cook_sreg_en  => cook_sreg,         -- in  std_logic_vector(7 downto 0)
--      cook_bram_en  => cook_bram,         -- in  std_logic_vector(7 downto 0)
--      cook_dsp_en   => cook_dsp,          -- in  std_logic_vector(7 downto 0)
--      cook_size     => cook_size(0),      -- in  std_logic
--      sreg_cook_out => sreg_cook_out(0),  -- out std_logic
--      bram_cook_out => bram_cook_out(0),  -- out std_logic
--      dsp_cook_out  => dsp_cook_out(0)    -- out std_logic
--      );
--
--  u24 : entity work.cooker_wrapper
--    generic map (
--      NUM_X8_REG    => NUM_X8_REG/2,
--      NUM_BRAM      => NUM_BRAM/2,
--      NUM_DSP       => NUM_DSP/2
--      )
--    port map (
--      cook_clk      => cook_clk_n,        -- in  std_logic
--      cook_sreg_en  => cook_sreg,         -- in  std_logic_vector(7 downto 0)
--      cook_bram_en  => cook_bram,         -- in  std_logic_vector(7 downto 0)
--      cook_dsp_en   => cook_dsp,          -- in  std_logic_vector(7 downto 0)
--      cook_size     => cook_size(1),      -- in  std_logic
--      sreg_cook_out => sreg_cook_out(1),  -- out std_logic
--      bram_cook_out => bram_cook_out(1),  -- out std_logic
--      dsp_cook_out  => dsp_cook_out(1)    -- out std_logic
--      );
--
--  -- Use both edges of cook_clk to spread the switching load.
--  cook_clk_n <= not cook_clk;
--
--  -- Connect up the cooker outputs to a status register to prevent
--  -- removal during logic optimization.
--  user_regs.reg_cook_preserve <= (x"000000" & "00" & dsp_cook_out & bram_cook_out & sreg_cook_out);

  ---------------
  -- PCIe & JTAG
  ---------------
  u30 : qsys_top
    port map (
      -- BMC IRQ
      bmc_irq_irq                                         => bmc_irq,  -- out std_logic
      -- PCIe irq
      pcie_irq_irq                                        => open,  -- out std_logic
      -- ESRAM
      esram_0_refclk_clk                                  => esram_0_refclk,  -- in std_logic
      esram_0_iopll_lock_iopll_lock                       => esram_0_iopll_lock,  -- out std_logic
--      esram_1_refclk_clk                                  => esram_1_refclk,  -- in std_logic
--      esram_1_iopll_lock_iopll_lock                       => esram_1_iopll_lock,  -- out std_logic
      -- Avalon MM Master
      avmm_master_waitrequest                             => avmm_waitrequest,  -- in    std_logic
      avmm_master_readdata                                => avmm_readdata,  -- in    std_logic_vector(31 downto 0)
      avmm_master_readdatavalid                           => avmm_readdatavalid,  -- in    std_logic
      avmm_master_burstcount                              => avmm_burstcount,  -- out   std_logic_vector(0 downto 0)
      avmm_master_writedata                               => avmm_writedata,  -- out   std_logic_vector(31 downto 0)
      avmm_master_address                                 => avmm_address,  -- out   std_logic_vector(11 downto 0)
      avmm_master_write                                   => avmm_write,  -- out   std_logic
      avmm_master_read                                    => avmm_read,  -- out   std_logic
      avmm_master_byteenable                              => avmm_byteenable,  -- out   std_logic_vector(3 downto 0)
      avmm_master_debugaccess                             => avmm_debugaccess,  -- out   std_logic
      -- Clocks and Resets
      config_clk_clk                                      => config_clk,  -- in    std_logic
      config_rstn_reset_n                                 => config_rstn(1),  -- in    std_logic
      -- System Manager Interface
      conf_c_in_conf_c_in                                 => conf_c_in,  -- in    std_logic_vector(3 downto 0)
      conf_c_out_conf_c_out                               => conf_c_out,  -- out   std_logic_vector(3 downto 0)
      conf_d_conf_d                                       => conf_d,  -- inout std_logic_vector(7 downto 0)
      soft_recfg_req_n_soft_reconfigure_req_n             => soft_recfg_req_n,  -- out   std_logic
      -- BMC SPI Slave 
      spi_mosi_to_the_spislave_inst_for_spichain          => spi_mosi,  -- in std_logic;
      spi_nss_to_the_spislave_inst_for_spichain           => spi_nss,  --  in std_logic;           
      spi_sclk_to_the_spislave_inst_for_spichain          => spi_sclk,  -- in std_logic;          
      spi_miso_to_and_from_the_spislave_inst_for_spichain => spi_miso,  -- inout std_logic;
      -- PCIe Gen3 x16
      pcie_hip_ctrl_simu_mode_pipe                        => '0',  -- in    std_logic
      pcie_hip_ctrl_test_in                               => pcie_test_in,  -- in    std_logic_vector(66 downto 0)
      pcie_npor_npor                                      => pcie_perstn,  -- in    std_logic
      pcie_npor_pin_perst                                 => pcie_perstn,  -- in    std_logic
      pcie_refclk_clk                                     => pcie_refclk,  -- in    std_logic
      pcie_serial_rx_in0                                  => pcie_rx(0),  -- in    std_logic
      pcie_serial_rx_in1                                  => pcie_rx(1),  -- in    std_logic
      pcie_serial_rx_in2                                  => pcie_rx(2),  -- in    std_logic
      pcie_serial_rx_in3                                  => pcie_rx(3),  -- in    std_logic
      pcie_serial_rx_in4                                  => pcie_rx(4),  -- in    std_logic
      pcie_serial_rx_in5                                  => pcie_rx(5),  -- in    std_logic
      pcie_serial_rx_in6                                  => pcie_rx(6),  -- in    std_logic
      pcie_serial_rx_in7                                  => pcie_rx(7),  -- in    std_logic
      pcie_serial_rx_in8                                  => pcie_rx(8),  -- in    std_logic
      pcie_serial_rx_in9                                  => pcie_rx(9),  -- in    std_logic
      pcie_serial_rx_in10                                 => pcie_rx(10),  -- in    std_logic
      pcie_serial_rx_in11                                 => pcie_rx(11),  -- in    std_logic
      pcie_serial_rx_in12                                 => pcie_rx(12),  -- in    std_logic
      pcie_serial_rx_in13                                 => pcie_rx(13),  -- in    std_logic
      pcie_serial_rx_in14                                 => pcie_rx(14),  -- in    std_logic
      pcie_serial_rx_in15                                 => pcie_rx(15),  -- in    std_logic
      pcie_serial_tx_out0                                 => pcie_tx(0),  -- out   std_logic
      pcie_serial_tx_out1                                 => pcie_tx(1),  -- out   std_logic
      pcie_serial_tx_out2                                 => pcie_tx(2),  -- out   std_logic
      pcie_serial_tx_out3                                 => pcie_tx(3),  -- out   std_logic
      pcie_serial_tx_out4                                 => pcie_tx(4),  -- out   std_logic
      pcie_serial_tx_out5                                 => pcie_tx(5),  -- out   std_logic
      pcie_serial_tx_out6                                 => pcie_tx(6),  -- out   std_logic
      pcie_serial_tx_out7                                 => pcie_tx(7),  -- out   std_logic
      pcie_serial_tx_out8                                 => pcie_tx(8),  -- out   std_logic
      pcie_serial_tx_out9                                 => pcie_tx(9),  -- out   std_logic
      pcie_serial_tx_out10                                => pcie_tx(10),  -- out   std_logic
      pcie_serial_tx_out11                                => pcie_tx(11),  -- out   std_logic
      pcie_serial_tx_out12                                => pcie_tx(12),  -- out   std_logic
      pcie_serial_tx_out13                                => pcie_tx(13),  -- out   std_logic
      pcie_serial_tx_out14                                => pcie_tx(14),  -- out   std_logic
      pcie_serial_tx_out15                                => pcie_tx(15),  -- out   std_logic
      pcie_user_clk_clk                                   => pcie_user_clk, -- out   std_logic
      pcie_user_rst_reset                                 => pcie_user_rst -- out  std_logic
      );

  pcie_test_in <= (others => '0');

  ------------------
  -- User Registers
  ------------------
  u31 : entity work.user_registers
    port map (
      -- Clocks & Reset
      config_clk         => config_clk,  -- in  std_logic
      config_rstn        => config_rstn(2),  -- in  std_logic
      -- Host Interface
      avmm_waitrequest   => avmm_waitrequest,  -- out std_logic
      avmm_readdata      => avmm_readdata,  -- out std_logic_vector(31 downto 0)
      avmm_readdatavalid => avmm_readdatavalid,  -- out std_logic
      avmm_burstcount    => avmm_burstcount,  -- in  std_logic_vector(0 downto 0)
      avmm_writedata     => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
      avmm_address       => avmm_address,  -- in  std_logic_vector(11 downto 0)
      avmm_write         => avmm_write,  -- in  std_logic
      avmm_read          => avmm_read,  -- in  std_logic
      avmm_byteenable    => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
      -- Registers
      reg_0_out          => open,       -- out std_logic_vector(31 downto 0)
      reg_1_out          => open,       -- out std_logic_vector(31 downto 0)
      led_control        => led_control,  -- out std_logic_vector(2 downto 0)
      cook_sreg          => cook_sreg,  -- out std_logic_vector(7 downto 0)
      cook_bram          => cook_bram,  -- out std_logic_vector(7 downto 0)
      cook_dsp           => cook_dsp,   -- out std_logic_vector(7 downto 0)
      cook_size          => cook_size,  -- out std_logic_vector(1 downto 0)
      cook_cken          => cook_cken,  -- out std_logic
      slave_wait         => slave_wait,  -- in  std_logic
      oc0_gpio_status    => oc0_gpio_status,  -- in  std_logic_vector(15 downto 0);
      oc1_gpio_status    => oc1_gpio_status,  -- in  std_logic_vector(15 downto 0);
      oc0_gpio_control   => oc0_gpio_control,  -- out std_logic_vector(15 downto 0)
      oc1_gpio_control   => oc1_gpio_control,  -- out std_logic_vector(15 downto 0)
      oc0_gpio_dir       => oc0_gpio_dir_i,  -- out std_logic_vector(15 downto 0)
      oc1_gpio_dir       => oc1_gpio_dir_i,  -- out std_logic_vector(15 downto 0)
      oc0_gpio_dir_ext   => oc0_gpio_dir,  -- out std_logic_vector(15 downto 0)
      oc1_gpio_dir_ext   => oc1_gpio_dir,  -- out std_logic_vector(15 downto 0)
      oc_buff_en_n       => oc_buff_en_n,  -- out std_logic_vector(7 downto 2)
      opci_buff_in_sel   => opci_buff_in_sel,  -- out std_logic_vector(3 downto 2)
      oc_perst_n         => oc_perst_n,  -- in  std_logic_vector(3 downto 2)
      fpga_gpio_1        => fpga_gpio_1,  -- in  std_logic
      fpga_rst_n         => fpga_rst_n,  -- in std_logic
      qsfp_irq_n         => qsfp_irq_n,  -- in  std_logic_vector(3 downto 0)
      user_regs          => user_regs,  -- in  T_user_registers
      dout_mem0          => dout_mem0,  -- in  T_mem_status
      dout_mem1          => dout_mem1   -- in  T_mem_status
      );

  slave_wait <= '0';

  u32 : entity work.s10_chip_id_wrap
    port map (
      config_clk  => config_clk,        -- in  std_logic
      config_rstn => config_rstn(3),    -- in  std_logic
      chip_id_l   => user_regs.reg_chip_id_l,  -- out std_logic_vector(63 downto 0)
      chip_id_h   => user_regs.reg_chip_id_h  -- out std_logic_vector(63 downto 0)
      );

--  --------------
--  -- Clock Test
--  --------------
--  u40 : entity work.clock_test
--    generic map (
--      NUM_CLKS        => NUM_CLKS
--      )
--    port map (
--      config_clk      => config_clk,    -- in  std_logic
--      config_rstn     => config_rstn(4),  -- in  std_logic
--      -- Host Interface
--      avmm_writedata  => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
--      avmm_address    => avmm_address,  -- in  std_logic_vector(11 downto 0)
--      avmm_write      => avmm_write,    -- in  std_logic
--      avmm_byteenable => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
--      -- Test Clocks
--      test_clock      => test_clock,    -- in  std_logic_vector(14 downto 0)
--      test_clock_stat => test_clock_stat,  -- in  std_logic_vector(14 downto 0)
--      count_stcl      => user_regs.reg_count_stcl,  -- out std_logic_vector(31 downto 0)
--      count           => clock_count
--      );
--
--  rcvrd_refclk               <= (rcvrd_refclk_3 & rcvrd_refclk_2 & rcvrd_refclk_1 & rcvrd_refclk_0);
--  xcvr_user_clk(11 downto 8) <= (xcvr_refclk_11 & xcvr_refclk_10 & xcvr_refclk_9 & xcvr_refclk_8);
--
--  test_clock <= ( rcvrd_refclk &
--                  xcvr_user_clk &
--                  u1pps &
--                  mem_usrclk &
--                  pcie_user_clk &
--                  usr_refclk1 &
--                  usr_refclk0 &
--                  config_clk);          -- Reference clock at 50MHz
--
--  xcvr_user_clk_lock(11 downto 8) <= (others => '1');
--
--  test_clock_stat <= ext(
--    unused_gnd(1 downto 0) &
--    xcvr_user_clk_lock &
--    unused_gnd(3 downto 2) &
--    mem_usr_stat &
--    "111", test_clock_stat'length);
--
--
--  user_regs.reg_count_00 <= clock_count(00);
--  user_regs.reg_count_01 <= clock_count(01);
--  user_regs.reg_count_02 <= clock_count(02);
--  user_regs.reg_count_03 <= clock_count(03);
--  user_regs.reg_count_04 <= clock_count(04);
--  user_regs.reg_count_05 <= clock_count(05);
--  user_regs.reg_count_06 <= clock_count(06);
--  user_regs.reg_count_07 <= clock_count(07);
--  user_regs.reg_count_08 <= clock_count(08);
--  user_regs.reg_count_09 <= clock_count(09);
--  user_regs.reg_count_10 <= clock_count(10);
--  user_regs.reg_count_11 <= clock_count(11);
--  user_regs.reg_count_12 <= clock_count(12);
--  user_regs.reg_count_13 <= clock_count(13);
--  user_regs.reg_count_14 <= clock_count(14);
--  user_regs.reg_count_15 <= clock_count(15);
--  user_regs.reg_count_16 <= clock_count(16);
--  user_regs.reg_count_17 <= clock_count(17);
--  user_regs.reg_count_18 <= clock_count(18);
--  user_regs.reg_count_19 <= clock_count(19);
--  user_regs.reg_count_20 <= clock_count(20);
--  user_regs.reg_count_21 <= clock_count(21);
--  user_regs.reg_count_22 <= clock_count(22);

  -------------------------
  -- Temperature & Voltage
  -------------------------
  u41 : entity work.s10_auto_adc
    port map (
      -- Clocks & Reset
      config_clk      => config_clk,    -- in  std_logic
      config_rstn     => config_rstn(5),  -- in  std_logic
      -- Host Interface
      avmm_writedata  => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
      avmm_address    => avmm_address,  -- in  std_logic_vector(11 downto 0)
      avmm_write      => avmm_write,    -- in  std_logic
      avmm_read       => avmm_read,     -- in  std_logic
      avmm_byteenable => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
      slave_wait      => slave_wait,    -- in  std_logic
      -- Registers
      temp_stcl       => user_regs.reg_temp_stcl,  -- out std_logic_vector(31 downto 0)
      temp_chan_0     => user_regs.reg_temp_chan_0,  -- out std_logic_vector(31 downto 0)
      temp_chan_1     => user_regs.reg_temp_chan_1,  -- out std_logic_vector(31 downto 0)
      temp_chan_2     => user_regs.reg_temp_chan_2,  -- out std_logic_vector(31 downto 0)
      temp_chan_3     => user_regs.reg_temp_chan_3,  -- out std_logic_vector(31 downto 0)
      temp_chan_4     => user_regs.reg_temp_chan_4,  -- out std_logic_vector(31 downto 0)
      temp_chan_5     => user_regs.reg_temp_chan_5,  -- out std_logic_vector(31 downto 0)
      temp_chan_6     => user_regs.reg_temp_chan_6,  -- out std_logic_vector(31 downto 0)
      temp_chan_7     => user_regs.reg_temp_chan_7,  -- out std_logic_vector(31 downto 0)
      temp_chan_8     => user_regs.reg_temp_chan_8,  -- out std_logic_vector(31 downto 0)
      volt_stcl       => user_regs.reg_volt_stcl,  -- out std_logic_vector(31 downto 0)
      volt_chan_2     => user_regs.reg_volt_chan_2,  -- out std_logic_vector(31 downto 0)
      volt_chan_3     => user_regs.reg_volt_chan_3,  -- out std_logic_vector(31 downto 0)
      volt_chan_4     => user_regs.reg_volt_chan_4,  -- out std_logic_vector(31 downto 0)
      volt_chan_6     => user_regs.reg_volt_chan_6,  -- out std_logic_vector(31 downto 0)
      volt_chan_9     => user_regs.reg_volt_chan_9  -- out std_logic_vector(31 downto 0)

      );

  ---------------------------------------------------------------------------------
  -- UART Edge
  -------------------------------------------------------------------------------
  ub0 : entity work.uart_edge
    port map (
      -- Clocks & Reset
      uart_clk     => config_clk,       -- in  std_logic
      sync_rst     => config_rst,       -- in  std_logic
      -- Serial Communications
      sample_ratio => SAMPLE_RATIO,     -- in  std_logic_vector(11 downto 0)
      fpga_id      => "0000",           -- in  std_logic_vector(3 downto 0)
      host_proc_tx => uart_tx,          -- in  std_logic
      host_proc_rx => uart_rx,          -- out std_logic
      -- Register Interface
      reg_addr     => uart_addr,        -- out std_logic_vector(31 downto 0)
      reg_wr_data  => uart_wr_data,     -- out std_logic_vector(31 downto 0)
      reg_wr_en    => uart_wr_en,       -- out std_logic
      reg_rd_en    => uart_rd_en,       -- out std_logic
      reg_rd_data  => uart_rd_data,     -- in  std_logic_vector(31 downto 0)
      reg_rd_rdy   => uart_rd_rdy       -- in  std_logic
      );

  ub1 : entity work.altera_dprw_ram
    generic map (
      awidth => UART_BR_AWIDTH,
      dwidth => 32
      )
    port map (
      clka   => config_clk,             -- in  std_logic
      clkb   => config_clk,             -- in  std_logic
      wea    => uart_wr_en,             -- in  std_logic
      web    => unused_gnd(0),          -- in  std_logic
      addra  => uart_addr(UART_BR_AWIDTH-1 downto 0),  -- in  std_logic_vector(awidth-1 downto 0)
      addrb  => unused_gnd(UART_BR_AWIDTH-1 downto 0),  -- in  std_logic_vector(awidth-1 downto 0)
      dia    => uart_wr_data,           -- in  std_logic_vector(dwidth-1 downto 0)
      dib    => unused_gnd(31 downto 0),  -- in  std_logic_vector(dwidth-1 downto 0)
      doa    => uart_rd_data,           -- out std_logic_vector(dwidth-1 downto 0)
      dob    => open                    -- out std_logic_vector(dwidth-1 downto 0)
      );


  ub2 : entity work.bretime_async_rst
    generic map (
      DEPTH => 1
      )
    port map (
      clock => config_clk,
      d     => uart_rd_en,
      q     => uart_rd_en_d1
      );

  uart_rd_rdy <= uart_rd_en_d1 and uart_rd_en;

  config_rst <= not config_rstn(0);

  rx_clkout_0 <= rx_rcvr_clkout(0);     -- Divide by 2
  rx_clkout_1 <= rx_rcvr_clkout(1);     -- Divide by 4

  oc0_gpio_status <= oc0_gpio;
  oc1_gpio_status <= oc1_gpio;

  oc0_gpio(00) <= 'Z';
  oc0_gpio(01) <= 'Z';
  oc0_gpio(02) <= 'Z';
  oc0_gpio(03) <= 'Z';
  oc0_gpio(04) <= oc0_gpio_control(04) when (oc0_gpio_dir_i(04) = '1') else 'Z';
  oc0_gpio(05) <= oc0_gpio_control(05) when (oc0_gpio_dir_i(05) = '1') else 'Z';
  oc0_gpio(06) <= oc0_gpio_control(06) when (oc0_gpio_dir_i(06) = '1') else 'Z';
  oc0_gpio(07) <= oc0_gpio_control(07) when (oc0_gpio_dir_i(07) = '1') else 'Z';
  oc0_gpio(08) <= 'Z';
  oc0_gpio(09) <= 'Z';
  oc0_gpio(10) <= oc0_gpio_control(10) when (oc0_gpio_dir_i(10) = '1') else 'Z';
  oc0_gpio(11) <= oc0_gpio_control(11) when (oc0_gpio_dir_i(11) = '1') else 'Z';
  oc0_gpio(12) <= oc0_gpio_control(12) when (oc0_gpio_dir_i(12) = '1') else 'Z';
  oc0_gpio(13) <= oc0_gpio_control(13) when (oc0_gpio_dir_i(13) = '1') else 'Z';
  oc0_gpio(14) <= oc0_gpio_control(14) when (oc0_gpio_dir_i(14) = '1') else 'Z';
  oc0_gpio(15) <= oc0_gpio_control(15) when (oc0_gpio_dir_i(15) = '1') else 'Z';

  oc1_gpio(00) <= 'Z';
  oc1_gpio(01) <= 'Z';
  oc1_gpio(02) <= 'Z';
  oc1_gpio(03) <= 'Z';
  oc1_gpio(04) <= oc1_gpio_control(04) when (oc1_gpio_dir_i(04) = '1') else 'Z';
  oc1_gpio(05) <= oc1_gpio_control(05) when (oc1_gpio_dir_i(05) = '1') else 'Z';
  oc1_gpio(06) <= oc1_gpio_control(06) when (oc1_gpio_dir_i(06) = '1') else 'Z';
  oc1_gpio(07) <= oc1_gpio_control(07) when (oc1_gpio_dir_i(07) = '1') else 'Z';
  oc1_gpio(08) <= 'Z';
  oc1_gpio(09) <= 'Z';
  oc1_gpio(10) <= oc1_gpio_control(10) when (oc1_gpio_dir_i(10) = '1') else 'Z';
  oc1_gpio(11) <= oc1_gpio_control(11) when (oc1_gpio_dir_i(11) = '1') else 'Z';
  oc1_gpio(12) <= oc1_gpio_control(12) when (oc1_gpio_dir_i(12) = '1') else 'Z';
  oc1_gpio(13) <= oc1_gpio_control(13) when (oc1_gpio_dir_i(13) = '1') else 'Z';
  oc1_gpio(14) <= oc1_gpio_control(14) when (oc1_gpio_dir_i(14) = '1') else 'Z';
  oc1_gpio(15) <= oc1_gpio_control(15) when (oc1_gpio_dir_i(15) = '1') else 'Z';

  -- tie off unused at present
  uib_cattrip <= (others => '0');


end rtl;
