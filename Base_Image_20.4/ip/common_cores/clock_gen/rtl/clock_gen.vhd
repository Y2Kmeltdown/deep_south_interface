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
-- Title       : Clock Generator
-- Project     : Common Firmware
--------------------------------------------------------------------------------
-- Description : The clock generator runs continuously from 'clk'.
--               It divides 'clk' to produce an output at the desired
--               frequency with a 50/50 mark/space ratio.
--
--               Example
--               -------
--               For a 'clk' frequency of 100MHz and a desired 'clk_out'
--               frequency of 1kHz, set DIVISOR = 100000000/1000 = 100000
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


entity clock_gen is
  generic (
    DIVISOR             : integer       := 100000
    );
  port (
    clk                 : in  std_logic;
    clk_out             : out std_logic
    );
end clock_gen;


architecture rtl of clock_gen is
  -----------
  -- Signals
  -----------
  signal count                : std_logic_vector(15 downto 0)         := (others => '0');
  signal clk_out_a1           : std_logic                             := '0';
  signal clk_out_i            : std_logic                             := '0';

begin

  process(clk)
  begin
    if rising_edge(clk) then
      -- Counter to divide the 'clk' input
      if (count = (DIVISOR/2) - 1) then
        count      <= (others => '0');
        clk_out_a1 <= not clk_out_a1;
      else
        count      <= count + 1;
      end if;

      -- Pipeline the output so it can be mapped into a GPIO register
      clk_out_i <= clk_out_a1;

    end if;
  end process;


  -- Connect up output
  clk_out <= clk_out_i;


end rtl;
