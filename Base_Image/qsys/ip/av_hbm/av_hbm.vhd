---------------------------------------------------------------------------
--
--     NALLATECH IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
--     BY PROVIDING THIS DESIGN, CODE, OR INFORMATION
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION
--     OR STANDARD, NALLATECH IS MAKING NO REPRESENTATION THAT THIS
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
--     FOR YOUR IMPLEMENTATION.  NALLATECH EXPRESSLY DISCLAIMS ANY
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
--     FOR A PARTICULAR PURPOSE.
--
--     Nallatech products are not intended for use in life support
--     appliances, devices, or systems. Use in such applications is
--     expressly prohibited.
--
---------------------------------------------------------------------------
-- Title       : av_hbm
-- Project     : 
---------------------------------------------------------------------------
-- Description : This module handles the interface to the LMS core.
--
--
--
---------------------------------------------------------------------------
-- Known Issues and Omissions:
--
--
---------------------------------------------------------------------------
-- Copyright © 2018 Nallatech Ltd. All rights reserved.
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity av_hbm is
  port(
    -- clocks
    rst : in std_logic;
    clk : in std_logic;

    bottom_core_clk_iopll_refclk_clk : in std_logic;
    bottom_pll_ref_clk_clk           : in std_logic;
    top_core_clk_iopll_ref_clk_clk   : in std_logic;
    top_pll_ref_clk_clk              : in std_logic;

    -- HBM bottom boundary scan interface
    bottom_m2u_bridge_cattrip   : in  std_logic;
    bottom_m2u_bridge_temp      : in  std_logic_vector(2 downto 0);
    bottom_m2u_bridge_wso       : in  std_logic_vector(7 downto 0);
    bottom_m2u_bridge_reset_n   : out std_logic;
    bottom_m2u_bridge_wrst_n    : out std_logic;
    bottom_m2u_bridge_wrck      : out std_logic;
    bottom_m2u_bridge_shiftwr   : out std_logic;
    bottom_m2u_bridge_capturewr : out std_logic;
    bottom_m2u_bridge_updatewr  : out std_logic;
    bottom_m2u_bridge_selectwir : out std_logic;
    bottom_m2u_bridge_wsi       : out std_logic;

    -- HBM top boundary scan interface

    top_m2u_bridge_cattrip   : in  std_logic;
    top_m2u_bridge_temp      : in  std_logic_vector(2 downto 0);
    top_m2u_bridge_wso       : in  std_logic_vector(7 downto 0);
    top_m2u_bridge_reset_n   : out std_logic;
    top_m2u_bridge_wrst_n    : out std_logic;
    top_m2u_bridge_wrck      : out std_logic;
    top_m2u_bridge_shiftwr   : out std_logic;
    top_m2u_bridge_capturewr : out std_logic;
    top_m2u_bridge_updatewr  : out std_logic;
    top_m2u_bridge_selectwir : out std_logic;
    top_m2u_bridge_wsi       : out std_logic;


    -- avalon slave mode control interface
    av_address     : in  std_logic_vector(0 downto 0);
    av_read        : in  std_logic;
    av_waitrequest : out std_logic;
    av_write       : in  std_logic;
    av_readdata    : out std_logic_vector(31 downto 0);
    av_writedata   : in  std_logic_vector(31 downto 0)
    );
end av_hbm;

architecture rtl of av_hbm is

  component ed_synth
    is
      port (
        bottom_core_clk_iopll_reset_reset       : in  std_logic                    := 'X';  -- reset
        bottom_core_clk_iopll_refclk_clk        : in  std_logic                    := 'X';  -- clk
        bottom_pll_ref_clk_clk                  : in  std_logic                    := 'X';  -- clk
        bottom_wmcrst_n_in_reset_n              : in  std_logic                    := 'X';  -- reset_n
        bottom_only_reset_in_reset              : in  std_logic                    := 'X';  -- reset
        bottom_m2u_bridge_cattrip               : in  std_logic                    := 'X';  -- cattrip
        bottom_m2u_bridge_temp                  : in  std_logic_vector(2 downto 0) := (others => 'X');  -- temp
        bottom_m2u_bridge_wso                   : in  std_logic_vector(7 downto 0) := (others => 'X');  -- wso
        bottom_m2u_bridge_reset_n               : out std_logic;  -- reset_n
        bottom_m2u_bridge_wrst_n                : out std_logic;  -- wrst_n
        bottom_m2u_bridge_wrck                  : out std_logic;  -- wrck
        bottom_m2u_bridge_shiftwr               : out std_logic;  -- shiftwr
        bottom_m2u_bridge_capturewr             : out std_logic;  -- capturewr
        bottom_m2u_bridge_updatewr              : out std_logic;  -- updatewr
        bottom_m2u_bridge_selectwir             : out std_logic;  -- selectwir
        bottom_m2u_bridge_wsi                   : out std_logic;  -- wsi
        top_pll_ref_clk_clk                     : in  std_logic                    := 'X';  -- clk
        top_wmcrst_n_in_reset_n                 : in  std_logic                    := 'X';  -- reset_n
        top_only_reset_in_reset                 : in  std_logic                    := 'X';  -- reset
        top_m2u_bridge_cattrip                  : in  std_logic                    := 'X';  -- cattrip
        top_m2u_bridge_temp                     : in  std_logic_vector(2 downto 0) := (others => 'X');  -- temp
        top_m2u_bridge_wso                      : in  std_logic_vector(7 downto 0) := (others => 'X');  -- wso
        top_m2u_bridge_reset_n                  : out std_logic;  -- reset_n
        top_m2u_bridge_wrst_n                   : out std_logic;  -- wrst_n
        top_m2u_bridge_wrck                     : out std_logic;  -- wrck
        top_m2u_bridge_shiftwr                  : out std_logic;  -- shiftwr
        top_m2u_bridge_capturewr                : out std_logic;  -- capturewr
        top_m2u_bridge_updatewr                 : out std_logic;  -- updatewr
        top_m2u_bridge_selectwir                : out std_logic;  -- selectwir
        top_m2u_bridge_wsi                      : out std_logic;  -- wsi
        tg_bottom0_0_status_traffic_gen_pass    : out std_logic;  -- traffic_gen_pass
        tg_bottom0_0_status_traffic_gen_fail    : out std_logic;  -- traffic_gen_fail
        tg_bottom0_0_status_traffic_gen_timeout : out std_logic;  -- traffic_gen_timeout
        tg_bottom0_1_status_traffic_gen_pass    : out std_logic;  -- traffic_gen_pass
        tg_bottom0_1_status_traffic_gen_fail    : out std_logic;  -- traffic_gen_fail
        tg_bottom0_1_status_traffic_gen_timeout : out std_logic;  -- traffic_gen_timeout
        tg_top0_0_status_traffic_gen_pass       : out std_logic;  -- traffic_gen_pass
        tg_top0_0_status_traffic_gen_fail       : out std_logic;  -- traffic_gen_fail
        tg_top0_0_status_traffic_gen_timeout    : out std_logic;  -- traffic_gen_timeout
        tg_top0_1_status_traffic_gen_pass       : out std_logic;  -- traffic_gen_pass
        tg_top0_1_status_traffic_gen_fail       : out std_logic;  -- traffic_gen_fail
        tg_top0_1_status_traffic_gen_timeout    : out std_logic;  -- traffic_gen_timeout
        top_core_clk_iopll_reset_reset          : in  std_logic                    := 'X';  -- reset
        top_core_clk_iopll_ref_clk_clk          : in  std_logic                    := 'X'  -- clk
        );
  end component ed_synth;

  signal bottom_only_reset_in_reset : std_logic := '0';
  signal top_only_reset_in_reset    : std_logic := '0';

  signal bottom_core_clk_iopll_reset_reset : std_logic;
  signal bottom_wmcrst_n_in_reset_n        : std_logic := '1';

  signal top_core_clk_iopll_reset_reset : std_logic;
  signal top_wmcrst_n_in_reset_n        : std_logic := '1';


  signal tg_bottom0_0_status_traffic_gen_pass    : std_logic;
  signal tg_bottom0_0_status_traffic_gen_fail    : std_logic;
  signal tg_bottom0_0_status_traffic_gen_timeout : std_logic;
  signal tg_bottom0_1_status_traffic_gen_pass    : std_logic;
  signal tg_bottom0_1_status_traffic_gen_fail    : std_logic;
  signal tg_bottom0_1_status_traffic_gen_timeout : std_logic;
  signal tg_top0_0_status_traffic_gen_pass       : std_logic;
  signal tg_top0_0_status_traffic_gen_fail       : std_logic;
  signal tg_top0_0_status_traffic_gen_timeout    : std_logic;
  signal tg_top0_1_status_traffic_gen_pass       : std_logic;
  signal tg_top0_1_status_traffic_gen_fail       : std_logic;
  signal tg_top0_1_status_traffic_gen_timeout    : std_logic;

  signal readdata_i    : std_logic_vector(31 downto 0) := (others => '0');
  signal readdata_d1   : std_logic_vector(31 downto 0);
  signal av_readdata_i : std_logic_vector(31 downto 0);


begin

  i_ed_synth : ed_synth
    port map (
      bottom_core_clk_iopll_reset_reset       => bottom_core_clk_iopll_reset_reset,
                                        -- in  
      bottom_core_clk_iopll_refclk_clk        => bottom_core_clk_iopll_refclk_clk,
                                        -- in  
      bottom_pll_ref_clk_clk                  => bottom_pll_ref_clk_clk,  -- in  
      bottom_wmcrst_n_in_reset_n              => bottom_wmcrst_n_in_reset_n,  -- in  
      bottom_only_reset_in_reset              => bottom_only_reset_in_reset,  -- in  
      bottom_m2u_bridge_cattrip               => bottom_m2u_bridge_cattrip,  -- in  
      bottom_m2u_bridge_temp                  => bottom_m2u_bridge_temp,  -- in  
      bottom_m2u_bridge_wso                   => bottom_m2u_bridge_wso,  -- in  
      bottom_m2u_bridge_reset_n               => bottom_m2u_bridge_reset_n,  -- out 
      bottom_m2u_bridge_wrst_n                => bottom_m2u_bridge_wrst_n,  -- out 
      bottom_m2u_bridge_wrck                  => bottom_m2u_bridge_wrck,  -- out 
      bottom_m2u_bridge_shiftwr               => bottom_m2u_bridge_shiftwr,  -- out 
      bottom_m2u_bridge_capturewr             => bottom_m2u_bridge_capturewr,  -- out 
      bottom_m2u_bridge_updatewr              => bottom_m2u_bridge_updatewr,  -- out 
      bottom_m2u_bridge_selectwir             => bottom_m2u_bridge_selectwir,  -- out 
      bottom_m2u_bridge_wsi                   => bottom_m2u_bridge_wsi,  -- out 
      top_pll_ref_clk_clk                     => top_pll_ref_clk_clk,  -- in  
      top_wmcrst_n_in_reset_n                 => top_wmcrst_n_in_reset_n,  -- in  
      top_only_reset_in_reset                 => top_only_reset_in_reset,  -- in  
      top_m2u_bridge_cattrip                  => top_m2u_bridge_cattrip,  -- in  
      top_m2u_bridge_temp                     => top_m2u_bridge_temp,  -- in  
      top_m2u_bridge_wso                      => top_m2u_bridge_wso,  -- in  
      top_m2u_bridge_reset_n                  => top_m2u_bridge_reset_n,  -- out 
      top_m2u_bridge_wrst_n                   => top_m2u_bridge_wrst_n,  -- out 
      top_m2u_bridge_wrck                     => top_m2u_bridge_wrck,  -- out 
      top_m2u_bridge_shiftwr                  => top_m2u_bridge_shiftwr,  -- out 
      top_m2u_bridge_capturewr                => top_m2u_bridge_capturewr,  -- out 
      top_m2u_bridge_updatewr                 => top_m2u_bridge_updatewr,  -- out 
      top_m2u_bridge_selectwir                => top_m2u_bridge_selectwir,  -- out 
      top_m2u_bridge_wsi                      => top_m2u_bridge_wsi,  -- out 
      tg_bottom0_0_status_traffic_gen_pass    => tg_bottom0_0_status_traffic_gen_pass,
                                        -- out 
      tg_bottom0_0_status_traffic_gen_fail    => tg_bottom0_0_status_traffic_gen_fail,
                                        -- out 
      tg_bottom0_0_status_traffic_gen_timeout => tg_bottom0_0_status_traffic_gen_timeout,
                                        -- out 
      tg_bottom0_1_status_traffic_gen_pass    => tg_bottom0_1_status_traffic_gen_pass,
                                        -- out 
      tg_bottom0_1_status_traffic_gen_fail    => tg_bottom0_1_status_traffic_gen_fail,
                                        -- out 
      tg_bottom0_1_status_traffic_gen_timeout => tg_bottom0_1_status_traffic_gen_timeout,
                                        -- out 
      tg_top0_0_status_traffic_gen_pass       => tg_top0_0_status_traffic_gen_pass,
                                        -- out 
      tg_top0_0_status_traffic_gen_fail       => tg_top0_0_status_traffic_gen_fail,
                                        -- out 
      tg_top0_0_status_traffic_gen_timeout    => tg_top0_0_status_traffic_gen_timeout,
                                        -- out 
      tg_top0_1_status_traffic_gen_pass       => tg_top0_1_status_traffic_gen_pass,
                                        -- out 
      tg_top0_1_status_traffic_gen_fail       => tg_top0_1_status_traffic_gen_fail,
                                        -- out 
      tg_top0_1_status_traffic_gen_timeout    => tg_top0_1_status_traffic_gen_timeout,
                                        -- out 
      top_core_clk_iopll_reset_reset          => top_core_clk_iopll_reset_reset,
                                        -- in  
      top_core_clk_iopll_ref_clk_clk          => top_core_clk_iopll_ref_clk_clk);
                                        -- in


  process (clk) is
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        top_core_clk_iopll_reset_reset      <= '0';
        top_wmcrst_n_in_reset_n             <= '1';
        bottom_core_clk_iopll_reset_reset   <= '0';
        bottom_wmcrst_n_in_reset_n          <= '1';
        av_waitrequest                      <= '1';
      else
        -- wait request by default
        av_waitrequest                      <= '1';
        readdata_d1                         <= readdata_i;
        if (av_write = '1') then
          -- no delay on write
          av_waitrequest                    <= '0';
          top_core_clk_iopll_reset_reset    <= av_writedata(25);
          top_wmcrst_n_in_reset_n           <= av_writedata(24);
          bottom_core_clk_iopll_reset_reset <= av_writedata(17);
          bottom_wmcrst_n_in_reset_n        <= av_writedata(16);
        elsif (av_read = '1') then
          av_readdata                       <= (others => '0');
          -- drive with valid data
          av_waitrequest                    <= '0';
          av_readdata                       <= readdata_d1;
        end if;

      end if;
    end if;
  end process;

  readdata_i(25) <= top_core_clk_iopll_reset_reset;
  readdata_i(24) <= top_wmcrst_n_in_reset_n;
  readdata_i(17) <= bottom_core_clk_iopll_reset_reset;
  readdata_i(16) <= bottom_wmcrst_n_in_reset_n;

  readdata_i(13) <= tg_top0_1_status_traffic_gen_pass;
  readdata_i(12) <= tg_top0_1_status_traffic_gen_fail;
  readdata_i(11) <= tg_top0_1_status_traffic_gen_timeout;
  readdata_i(10) <= tg_top0_0_status_traffic_gen_pass;
  readdata_i(09) <= tg_top0_0_status_traffic_gen_fail;
  readdata_i(08) <= tg_top0_0_status_traffic_gen_timeout;

  readdata_i(05) <= tg_bottom0_1_status_traffic_gen_pass;
  readdata_i(04) <= tg_bottom0_1_status_traffic_gen_fail;
  readdata_i(03) <= tg_bottom0_1_status_traffic_gen_timeout;
  readdata_i(02) <= tg_bottom0_0_status_traffic_gen_pass;
  readdata_i(01) <= tg_bottom0_0_status_traffic_gen_fail;
  readdata_i(00) <= tg_bottom0_0_status_traffic_gen_timeout;



end rtl;


