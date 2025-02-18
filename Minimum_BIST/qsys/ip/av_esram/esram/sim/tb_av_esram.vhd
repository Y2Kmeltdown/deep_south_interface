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


---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------------

entity av_esram_tb is
end av_esram_tb;

---------------------------------------------------------------------------------

architecture bench of av_esram_tb is

  component av_esram
    generic (
      c_ADDR_BITS    :     integer := 11;
      chan0          :     boolean := true
      );
    port (
      refclk         : in  std_logic;
      esram_clk      : out std_logic;
      esram_rst      : out std_logic;
      iopll_lock     : out std_logic;
      av_address     : in  std_logic_vector(c_ADDR_BITS-1 downto 0);
      av_read        : in  std_logic;
      av_waitrequest : out std_logic;
      av_write       : in  std_logic;
      av_readdata    : out std_logic_vector(31 downto 0);
      av_writedata   : in  std_logic_vector(31 downto 0));
  end component;

  constant c_ADDR_BITS : integer := 11;

  signal refclk         : std_logic                                := '0';
  signal esram_clk      : std_logic;
  signal esram_rst      : std_logic;
  signal iopll_lock     : std_logic;
  signal av_address     : std_logic_vector(c_ADDR_BITS-1 downto 0) := (others => '0');
  signal av_read        : std_logic                                := '0';
  signal av_waitrequest : std_logic;
  signal av_write       : std_logic                                := '0';
  signal av_readdata    : std_logic_vector(31 downto 0);
  signal av_writedata   : std_logic_vector(31 downto 0)            := (others => '0');

  constant PERIOD   : time    := 5 ns;
  signal   stop_sim : boolean := false;

begin

  DUT : av_esram
    generic map (c_ADDR_BITS => 11,
                 chan0       => true)
    port map (
      refclk                 => refclk,          -- in  
      esram_clk              => esram_clk,       -- out 
      esram_rst              => esram_rst,       -- out  
      iopll_lock             => iopll_lock,      -- out 
      av_address             => av_address,      -- in  
      av_read                => av_read,         -- in  
      av_waitrequest         => av_waitrequest,  -- out 
      av_write               => av_write,        -- in  
      av_readdata            => av_readdata,     -- out 
      av_writedata           => av_writedata);   -- in

  -- Background clock process
  refclk <= '1' when stop_sim else not refclk after PERIOD/2;

  -- main process
  stim : process
  begin

    wait for 1000*PERIOD;

-- rst <= '0';

-- wait until (iopll_lock = '1');

    wait for 16*PERIOD;

    -----------------------------------------------------------------------------
    -- write, read location 0x0

    wait until rising_edge(esram_clk);

    av_write <= '1';

    av_writedata <= x"deadbeef";

    wait until rising_edge(esram_clk);

    wait until rising_edge(esram_clk);

    av_write <= '0';

    wait until rising_edge(esram_clk);

    wait until rising_edge(esram_clk);

    av_read <= '1';

    for i in 0 to 15 loop
      wait until rising_edge(esram_clk);
    end loop;

    av_read <= '0';

    wait for 100*PERIOD;

    -----------------------------------------------------------------------------
    -- write, read top location

    wait until rising_edge(esram_clk);

    av_address <= (others => '1');

    av_write <= '1';

    av_writedata <= x"cafebabe";

    wait until rising_edge(esram_clk);

    wait until rising_edge(esram_clk);

    av_write <= '0';

    wait until rising_edge(esram_clk);

    wait until rising_edge(esram_clk);

    av_read <= '1';

    for i in 0 to 15 loop
      wait until rising_edge(esram_clk);
    end loop;


    stop_sim <= true;
    wait;
  end process stim;



end bench;



