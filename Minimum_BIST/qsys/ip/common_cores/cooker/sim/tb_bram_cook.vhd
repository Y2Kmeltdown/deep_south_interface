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
-- Title       : Testbench for BRAM Cooker
-- Project     : Common Firmware
--------------------------------------------------------------------------------
-- Description : This is the testbench for the BRAM Cooker.
--
--
--
--------------------------------------------------------------------------------
-- Known Issues and Omissions:
--
--               The testbench provides basic stimulus to allow visual
--               waveform checking of the UUT functionality. It provides a
--               limited amount of auto-checking of the simulation results.
--
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity tb_bist_cook is
end tb_bist_cook;


architecture test of tb_bist_cook is
  -------------
  -- Constants
  -------------
  constant PERIOD_CLK         : time                                  := 10000 ps;

  -----------
  -- Signals
  -----------
  signal clk                  : std_logic                             := '1';
  signal byte_en              : std_logic_vector(7 downto 0)          := (others => '1');
  signal bram_out             : std_logic;


begin

  uut : entity work.bram_cook_test
  generic map (
    NUM_BRAM                  => 6
    )
  port map (
    clk                       => clk,                           -- in  std_logic
    async_rst                 => '0',                           -- in  std_logic
    byte_en                   => byte_en,                       -- in  std_logic_vector(7 downto 0)
    bram_out                  => bram_out                       -- out std_logic
    );

  -----------------------------
  -- Infinite Clock Generators
  -----------------------------
  clk <= not clk after PERIOD_CLK/2;


  -----------------------------------------------------------------------------
  -- Simulation Sequence
  -----------------------------------------------------------------------------
  stimulation : process
  begin
    wait for 4 us;

    byte_en <= "11110000";

    wait for 4 us;

    byte_en <= (others => '0');

    wait for 4 us;

    byte_en <= (others => '1');

    wait for 4 us;


    --------------------------
    -- End of Simulation
    --------------------------
    wait for 2 us;
    assert FALSE
      report "=> Simulation Complete"
      severity failure;
  end process stimulation;


end test;
