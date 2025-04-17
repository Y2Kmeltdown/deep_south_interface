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
-- Title       : Shift Reg Cooker Test
-- Project     : Common Firmware
--------------------------------------------------------------------------------
-- Description : This component instantiates a byte wide chain of LUT-FF pairs
--               and drives them with a PRBS test pattern.
--
--
--
--------------------------------------------------------------------------------
-- Known Issues and Omissions:
--
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity sreg_cook_test is
  generic (
    NUM_X8_REG                : integer := 2000   -- No of x8 LUT-FF blocks
    );
  port (
    clk                       : in  std_logic;
    async_rst                 : in  std_logic;
    reg_en                    : in  std_logic_vector(7 downto 0);
    reg_out                   : out std_logic
    );
end entity sreg_cook_test;


architecture rtl of sreg_cook_test is

  ---------
  -- Types
  ---------
  type T_sreg is array (0 to NUM_X8_REG-1) of std_logic_vector(7 downto 0);

  -----------
  -- Signals
  -----------
  signal prbs_gen             : std_logic_vector(8 downto 0)          := (others => '1');
  signal sreg                 : T_sreg;

begin

  process(clk, async_rst)

  variable prbs_v             : std_logic_vector(8 downto 0);
  variable reg_out_v          : std_logic;

  begin
    if async_rst = '1' then 
      prbs_gen <= (others => '1');

    elsif rising_edge(clk) then
      -- PRBS generator.
      if prbs_gen = "000000000" then
        prbs_gen <= (others => '1');
      else
        prbs_v := prbs_gen;
        for i in 0 to 1 loop
          prbs_v := (prbs_v(7 downto 0) & (prbs_v(4) xor prbs_v(8)));
        end loop;
        prbs_gen <= prbs_v;
      end if;
    end if;

    if rising_edge(clk) then
      -- Create input byte (each bit has an associated enable).
      for i in 0 to 7 loop
        sreg(0)(i) <= prbs_gen(i+1) and reg_en(i);
      end loop;

      -- Create byte wide chain of LUT-FF pairs (bit 7 controls
      -- the polarity of the next byte).
      for j in 1 to (NUM_X8_REG-1) loop
        for k in 0 to 6 loop
          sreg(j)(k) <= sreg(j-1)(k) xor sreg(j-1)(7);
        end loop;
        sreg(j)(7) <= not sreg(j-1)(7);           -- Polarity
      end loop;

      -- Create the final output.
      reg_out_v := '0';
      for i in 0 to 7 loop
        reg_out_v := reg_out_v xor sreg(NUM_X8_REG-1)(i);
      end loop;
      reg_out <= reg_out_v;

    end if;

  end process;


end rtl;
