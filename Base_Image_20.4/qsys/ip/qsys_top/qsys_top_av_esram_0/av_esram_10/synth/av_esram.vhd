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
-- Title       : av_esram
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


entity av_esram is
  generic (
    c_ADDR_BITS :     integer := 11;
    chan0       :     boolean := true
    );
  port(
    -- clocks
    refclk      : in  std_logic;
    esram_clk   : out std_logic;
    esram_rst   : out std_logic;
    iopll_lock  : out std_logic;

    -- avalon slave mode control interface
    av_address     : in  std_logic_vector(c_ADDR_BITS-1 downto 0);
    av_read        : in  std_logic;
    av_waitrequest : out std_logic;
    av_write       : in  std_logic;
    av_readdata    : out std_logic_vector(31 downto 0);
    av_writedata   : in  std_logic_vector(31 downto 0)
    );
end av_esram;

architecture rtl of av_esram is

  component esram_0
    port (
      c0_q_0          : out std_logic_vector(31 downto 0);
      esram2f_clk     : out std_logic;
      iopll_lock2core : out std_logic;
      c0_data_0       : in  std_logic_vector(31 downto 0) := (others => '0');
      c0_rdaddress_0  : in  std_logic_vector(10 downto 0) := (others => '0');
      c0_rden_n_0     : in  std_logic                     := '0';
      c0_sd_n_0       : in  std_logic                     := '0';
      c0_wraddress_0  : in  std_logic_vector(10 downto 0) := (others => '0');
      c0_wren_n_0     : in  std_logic                     := '0';
      refclk          : in  std_logic                     := '0');
  end component;

  component esram_7
    port (
      c7_q_0          : out std_logic_vector(31 downto 0);
      esram2f_clk     : out std_logic;
      iopll_lock2core : out std_logic;
      c7_data_0       : in  std_logic_vector(31 downto 0) := (others => '0');
      c7_rdaddress_0  : in  std_logic_vector(10 downto 0) := (others => '0');
      c7_rden_n_0     : in  std_logic                     := '0';
      c7_sd_n_0       : in  std_logic                     := '0';
      c7_wraddress_0  : in  std_logic_vector(10 downto 0) := (others => '0');
      c7_wren_n_0     : in  std_logic                     := '0';
      refclk          : in  std_logic                     := '0');
  end component;

  component bretime
    generic (
      DEPTH :     integer);
    port (
      reset : in  std_logic;
      clock : in  std_logic;
      d     : in  std_logic;
      q     : out std_logic);
  end component;


  signal esram_clk_i : std_logic;

  signal read_waitrequest_n : std_logic;
  signal q                  : std_logic_vector(31 downto 0);
  signal esram2f_clk        : std_logic;
  signal iopll_lock2core    : std_logic;
  signal data               : std_logic_vector(31 downto 0) := (others => '0');
  signal rdaddress          : std_logic_vector(10 downto 0) := (others => '0');
  signal rden_n             : std_logic                     := '0';
  signal sd_n               : std_logic;
  signal wraddress          : std_logic_vector(10 downto 0) := (others => '0');
  signal wren_n             : std_logic                     := '0';
  signal rden               : std_logic;
  signal wren               : std_logic;
  signal sd                 : std_logic                     := '0';
  signal rst_i              : std_logic;


begin

  G0 : if chan0 generate

    i_esram : esram_0
      port map (
        c0_q_0          => q,                -- out 
        esram2f_clk     => esram_clk_i,      -- out 
        iopll_lock2core => iopll_lock2core,  -- out 
        c0_data_0       => data,             -- in  
        c0_rdaddress_0  => rdaddress,        -- in  
        c0_rden_n_0     => rden_n,           -- in  
        c0_sd_n_0       => sd_n,             -- in  
        c0_wraddress_0  => wraddress,        -- in  
        c0_wren_n_0     => wren_n,           -- in  
        refclk          => refclk);          -- in

  end generate G0;

  G7 : if not chan0 generate

    i_esram : esram_7
      port map (
        c7_q_0          => q,                -- out 
        esram2f_clk     => esram_clk_i,      -- out 
        iopll_lock2core => iopll_lock2core,  -- out 
        c7_data_0       => data,             -- in  
        c7_rdaddress_0  => rdaddress,        -- in  
        c7_rden_n_0     => rden_n,           -- in  
        c7_sd_n_0       => sd_n,             -- in  
        c7_wraddress_0  => wraddress,        -- in  
        c7_wren_n_0     => wren_n,           -- in  
        refclk          => refclk);          -- in

  end generate G7;

  i_bretime : bretime
    generic map (
      DEPTH => 13)
    port map (
      reset => rst_i,                   -- in  
      clock => esram_clk_i,             -- in  
      d     => av_read,                 -- in  
      q     => read_waitrequest_n);     -- out


  process (esram_clk_i) is
  begin
    if rising_edge(esram_clk_i) then
      if (iopll_lock2core = '0') then
        rden           <= '0';
        wren           <= '0';
        av_waitrequest <= '1';
        rst_i          <= '1';
      else
        rst_i          <= '0';
        wraddress      <= av_address;
        rdaddress      <= av_address;
        wren           <= av_write;
        rden           <= av_read;
        data           <= av_writedata;
        av_readdata    <= q;

        if (av_write = '1') then
          -- no delay on write
          av_waitrequest <= '0';
        elsif (av_read = '1') then
          av_waitrequest <= not read_waitrequest_n;
        else
          -- to cover 1 cycle latency on determination of read, wait request by default
          av_waitrequest <= '1';
        end if;

      end if;
    end if;
  end process;


  rden_n <= not rden;
  wren_n <= not wren;
  sd_n   <= not sd;

  esram_clk <= esram_clk_i;
  esram_rst <= rst_i;

  iopll_lock <= iopll_lock2core;

end rtl;


