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
-- Title       : Combinatorial Muliplexer
-- Project     : Common Firmware
--------------------------------------------------------------------------------
-- Description : This component is a parameterised AND-OR multiplexer. Each
--               mux input has a one-hot select which is ANDed with the data.
--               The AND outputs are then ORed together. The input that is
--               enabled is the only one which propagates through to the mux
--               output.
--
--
--------------------------------------------------------------------------------
-- Known Issues and Omissions:
--
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity cmux is
  generic (
    WIDTH     : integer := 8;           -- width of each bus
    SELSZ     : integer := 8            -- number of busses
    );
  port (
    -- concatenated input data vectors
    data      : in  std_logic_vector((WIDTH*SELSZ)-1 downto 0);
    -- 'one hot' input mux select vector
    sel       : in  std_logic_vector(SELSZ-1 downto 0);
    -- output of final mux stage
    z         : out std_logic_vector(WIDTH-1 downto 0)
    );
end cmux;

architecture rtl of cmux is

begin

  process(data, sel)
    variable and_en     : std_logic_vector((WIDTH*SELSZ)-1 downto 0);
    variable casc       : std_logic_vector(SELSZ-1 downto 0);
    variable or_op      : std_logic_vector(WIDTH-1 downto 0);

  begin
    -- This block ANDs all the data inputs with the relevant select 
    for j in 0 to SELSZ-1 loop
      for i in 0 to WIDTH-1 loop
        and_en(i+j*WIDTH) := sel(j) and data(i+j*WIDTH);
      end loop;
    end loop;

    for j in 0 to WIDTH-1 loop
      -- This inner loop ORs all the terms together for that
      -- mux bit output position
      for k in 0 to SELSZ-1 loop
        if (k = 0) then
          casc(k)  := and_en(j);
        else
          casc(k)  := and_en(j+(k*WIDTH)) or casc(k-1);
          -- result of the OR of all the AND terms for that bit
          -- position 
          or_op(j) := casc(k);
        end if;
      end loop;
    end loop;

    z <= or_op;

  end process;

end rtl;
