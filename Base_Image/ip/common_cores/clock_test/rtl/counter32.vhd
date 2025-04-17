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
--                    NNNN---NNNN         (a subsidiary of
--                   NNNN-----NNNN        Interconnect Systems Inc.)
--                  NNNN-------NNNN
--                 NNNN---------NNNN
--                NNNNNNNN---NNNNNNNN
--               NNNNNNNNN---NNNNNNNNN
--                -------------------
--               ---------------------
--
--------------------------------------------------------------------------------
-- Title       : Counter32
-- Project     : Common Firmware
--------------------------------------------------------------------------------
-- Description : This component provides a 32-bit counter with a synchronous
--               reset and an enable. The counter resets to 0x00000000 and
--               counts (when enabled) up to 0xFFFFFFFF, the count does not
--               roll over.
--
--               To easily meet timing constraints when the clock frequency is
--               greater that 250MHz, the counter is implemented as two
--               cascaded 16-bit counters.
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

entity counter32 is
  port (
    clock               : in  std_logic;
    reset               : in  std_logic;
    enable              : in  std_logic;
    count               : out std_logic_vector(31 downto 0)
    );
end counter32;

architecture rtl of counter32 is

  -----------
  -- Signals
  -----------
  signal count_1              : std_logic_vector(15 downto 0)        := (others => '0');
  signal count_2              : std_logic_vector(15 downto 0)        := (others => '0');
  signal count_1_carry        : std_logic                            := '0';
  signal count_2_max          : std_logic                            := '0';


begin
  process (clock)
  begin
    if rising_edge(clock) then
      if (reset = '1') then
        count_1       <= (others => '0');
        count_2       <= (others => '0');
        count_1_carry <= '0';
        count_2_max   <= '0';

      elsif (enable = '1') then
        if (count_1_carry = '0') or (count_2_max = '0') then
          -- Lower 16-bit counter
          count_1 <= count_1 + '1';

          -- Create carry signal from first counter.
          if count_1 = x"FFFE" then
            count_1_carry <= '1';
          else
            count_1_carry <= '0';
          end if;

          -- Upper 16-bit counter
          if count_1_carry = '1' then
            count_2 <= count_2 + '1';
            if (count_2 = x"FFFE") then
              count_2_max <= '1';
            end if;
          end if;

        end if;
      end if;
    end if;
  end process;


  -- Connect up output
  count <= (count_2 & count_1);


end rtl;

