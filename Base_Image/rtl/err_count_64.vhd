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
-- Title       : Error Counter (64-bit)
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : An pipelined Error Counter component that takes in a 64-bit
--               'data' vector where every '1' indicates an error. The total
--               number of errors indicated on each enabled 'data' vector are
--               added to a 16-bit accumulator. The accumulator stops when it
--               reaches full scale (0xFFFF).
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


entity err_count_64 is
  port (
    clock               : in  std_logic;
    sync_reset          : in  std_logic;
    enable              : in  std_logic;
    data                : in  std_logic_vector(63 downto 0);
    count               : out std_logic_vector(15 downto 0)
    );
end err_count_64;


architecture rtl of err_count_64 is
  ---------
  -- Types
  ---------
  type T_sum_error_8x4 is array (0 to 7) of std_logic_vector(3 downto 0);
  type T_sum_error_2x6 is array (0 to 1) of std_logic_vector(5 downto 0);

  -----------
  -- Signals
  -----------
  signal sum_error_8x4        : T_sum_error_8x4                       := (others => (others => '0'));
  signal sum_error_2x6        : T_sum_error_2x6                       := (others => (others => '0'));
  signal sum_error            : std_logic_vector(6 downto 0)          := (others => '0');
  signal err_count            : std_logic_vector(15 downto 0)         := (others => '0');


begin
  process(clock)

    variable sum_error_v      : std_logic_vector(3 downto 0);

  begin
    if rising_edge(clock) then
      if sync_reset = '1' then
        sum_error_8x4 <= (others => (others => '0'));
        sum_error_2x6 <= (others => (others => '0'));
        sum_error     <= (others => '0');
        err_count     <= (others => '0');

      elsif enable = '1' then
        -- First stage adders (8) - each sums 8-bits of the 'data' vector.
        for j in 0 to 7 loop
          sum_error_v := (others => '0');
          for i in 0 to 7 loop
            if data(i+(j*8)) = '1' then
              sum_error_v := sum_error_v + 1;
            end if;
          end loop;
          sum_error_8x4(j) <= sum_error_v;
        end loop;

        -- Second stage adders (2) - each sums the outputs of 4 first stage adders.
        for i in 0 to 1 loop
          sum_error_2x6(i) <= ("00" & sum_error_8x4(0+(i*4))) +
                              ("00" & sum_error_8x4(1+(i*4))) +
                              ("00" & sum_error_8x4(2+(i*4))) +
                              ("00" & sum_error_8x4(3+(i*4)));
        end loop;

        -- Third stage adder (1) - sums the outputs of the 2 second stage adders.
        sum_error <= ('0' & sum_error_2x6(0)) +
                     ('0' & sum_error_2x6(1));

        -- Stop error count from wrapping around. This is done by parking the counter 
        -- at its maximum count (0xFFFF) when it reaches a value of greater than its 
        -- maximum count minus 64.
        if err_count > x"FFBF" then
          err_count <= x"FFFF";
        else
          err_count <= err_count + sum_error;
        end if;
      end if;

    end if;
  end process;


  count <= err_count;


end rtl;
