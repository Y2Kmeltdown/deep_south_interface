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
-- Title       : Heartbeat Generator
-- Project     : Common Firmware
--------------------------------------------------------------------------------
-- Description : The heartbeat generator runs continuously from a
--               50MHz clock. It divides the clock down to produce
--               an output that is a double pulse once every second
--               (like a heartbeat).
--
--               Using a 50MHz clock (20ns period), the timing constraints
--               cannot be met while using a single large counter. To
--               overcome this limitation, the counter is constructed
--               by cascading three small counters (8-bit, 8-bit and 10-bit).
--
--
-- <Timing Diagram>
--
-- hrt_beat ___.--.__.--.______________.--.__.--.______________.--.__.--.__
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


entity heartbeat_50m is
  port (
    clk             : in  std_logic;
    hrt_beat        : out std_logic_vector(4 downto 0)
    );
end heartbeat_50m;


architecture rtl of heartbeat_50m is

  -- Constants
  constant COUNT_1_DECODE     : std_logic_vector(7 downto 0)    := "11111101";
  constant COUNT_2_DECODE     : std_logic_vector(7 downto 0)    := "10111110";

  -- Signals
  signal count_1              : std_logic_vector(7 downto 0)    := (others => '0');
  signal count_2              : std_logic_vector(7 downto 0)    := (others => '0');
  signal count_3              : std_logic_vector(10 downto 0)   := (others => '0');
  signal count_1_early        : std_logic                       := '0';
  signal count_1_carry        : std_logic                       := '0';
  signal count_2_carry        : std_logic                       := '0';
  signal hrt_beat_i           : std_logic_vector(4 downto 0)    := (others => '0');

begin

  process(clk)
  begin
    if rising_edge(clk) then
      -- Free running 8-bit counter (first counter). 
      count_1 <= count_1 + 1;

      -- Look ahead decoding of first counter.
      if count_1 = COUNT_1_DECODE then
        count_1_early <= '1';
      else
        count_1_early <= '0';
      end if;

      -- Create carry signal from first counter.
      count_1_carry <= count_1_early;

      -- Use first counter carry to enable second counter.
      if count_1_carry = '1' then
        if count_2 = COUNT_2_DECODE then
          count_2 <= (others => '0');
        else
          count_2 <= count_2 + 1;
        end if;
      end if;

      -- Create carry signal from second counter (runs at 1024Hz)
      if (count_2 = COUNT_2_DECODE) and (count_1_early = '1') then
        count_2_carry <= '1';
      else
        count_2_carry <= '0';
      end if;

      -- Use second counter carry to enable third counter.
      if count_2_carry = '1' then
        count_3 <= count_3 + 1;
      end if;

      -- Create heartbeat signals.
      hrt_beat_i(0) <= count_3(9) and count_3(7);                                         -- Regular beat
      hrt_beat_i(1) <= count_3(9) and count_3(7) and not count_3(10);                     -- Alternating beat phase #0
      hrt_beat_i(2) <= count_3(9) and count_3(7) and count_3(10);                         -- Alternating beat phase #1
      hrt_beat_i(3) <= count_3(9) and count_3(7) and not count_3(1) and not count_3(10);  -- Alternating beat half brightness (PWM) ph #0
      hrt_beat_i(4) <= count_3(9) and count_3(7) and not count_3(1) and count_3(10);      -- Alternating beat half brightness (PWM) ph #1

    end if;
  end process;


  -- Connect up outputs.
  hrt_beat <= hrt_beat_i;


end rtl;
