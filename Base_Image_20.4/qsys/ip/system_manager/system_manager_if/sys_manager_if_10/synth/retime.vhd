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
-- Title       : Retime
-- Project     : Common Firmware
--------------------------------------------------------------------------------
-- Description : This component piplines a bus by number of clock cycles:
--
--                 WIDTH = Width of the bus
--                 DEPTH = Number of clock cycles of delay
--
--
--------------------------------------------------------------------------------
-- Known Issues and Omissions:
--
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity retime is
  generic (
    DEPTH     : integer := 2;           -- depth of retime (in clock cycles)
    WIDTH     : integer := 1            -- width of retime (in bits)
    );
  port (
    reset     : in  std_logic;
    clock     : in  std_logic;
    d         : in  std_logic_vector(WIDTH-1 downto 0);
    q         : out std_logic_vector(WIDTH-1 downto 0)
    );
end retime;

architecture rtl of retime is

  ---------
  -- Types
  ---------
  type retType is array (0 to DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);

  -----------
  -- Signals
  -----------
  signal q_i            : retType       := (others => (others => '0'));

begin

  process (clock) is
  begin
    if rising_edge(clock) then
      if (reset = '1') then
        q_i        <= (others => (others => '0'));
      else
        for i in 0 to DEPTH-1 loop
          if i = 0 then
            q_i(i) <= d;
          else
            q_i(i) <= q_i(i-1);
          end if;
        end loop;
      end if;
    end if;
  end process;

  -- Connect up output.
  q <= q_i(DEPTH-1);

end rtl;
