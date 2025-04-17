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
-- Title       : Clock Generator (fast)
-- Project     : Common Firmware
--------------------------------------------------------------------------------
-- Description : The clock divider runs continuously from 'clk'. It divides
--               'clk' by 2, 4, 6, 8 and 10 to produce individual outputs.
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


entity clock_gen_fast is
  port (
    clk                 : in  std_logic;
    clk_out             : out std_logic_vector(4 downto 0)
    );
end clock_gen_fast;


architecture rtl of clock_gen_fast is
  -----------
  -- Signals
  -----------
  signal clk_out_a1           : std_logic_vector(4 downto 0)          := (others => '0');
  signal clk_out_i            : std_logic_vector(4 downto 0)          := (others => '0');
  signal div_2                : std_logic                             := '0';
  signal div_4                : std_logic_vector(1 downto 0)          := (others => '0');
  signal div_6                : std_logic_vector(2 downto 0)          := (others => '0');
  signal div_8                : std_logic_vector(3 downto 0)          := (others => '0');
  signal div_10               : std_logic_vector(4 downto 0)          := (others => '0');

begin

  process(clk)
  begin
    if rising_edge(clk) then
      -- Divide by 2
      div_2         <= not div_2;
      clk_out_a1(0) <= div_2;

      -- Divide by 4
      div_4         <= (div_4(0) & not div_4(1));
      clk_out_a1(1) <= div_4(1);

      -- Divide by 6
      div_6(1 downto 0) <= (div_6(0) & not div_6(2));
      div_6(2)          <= (div_6(0) or div_6(2)) and div_6(1);
      clk_out_a1(2)     <= div_6(2);

      -- Divide by 8
      div_8(1 downto 0) <= (div_8(0) & not div_8(3));
      div_8(2)          <= (div_8(0) or div_8(2)) and div_8(1);
      div_8(3)          <= div_8(2);
      clk_out_a1(3)     <= div_8(3);

      -- Divide by 10
      div_10(1 downto 0) <= (div_10(0) & not div_10(4));
      div_10(2)          <= (div_10(0) or div_10(2)) and div_10(1);
      div_10(4 downto 3) <= (div_10(3) & div_10(2));
      clk_out_a1(4)      <= div_10(4);

      -- Pipeline the output so it can be mapped into a GPIO registers
      clk_out_i <= clk_out_a1;

    end if;
  end process;


  -- Connect up output
  clk_out <= clk_out_i;


end rtl;
