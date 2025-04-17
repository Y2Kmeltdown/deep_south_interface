--Revision number:: $Rev: 2167 $ Date:: $Date: 2006-12-20 11:47:49 +0000 (Wed, 20 Dec 2006) $
--===========================================================================
--
-- File        : zbt_if.vhd
-- Author      : Kenneth Morrison
-- Company     : Nallatech Ltd
--
-- Description : Retime module
--
-- Omissions, Limitations, Issues :
--  - none
--
-- This module delays an m width bus by n clock cycles.
-- 
--===========================================================================
library ieee;
use ieee.std_logic_1164.all;

entity retime is
  generic (
    DEPTH :     integer := 2;           -- depth of retime (in clock cycles)
    WIDTH :     integer := 1);          -- width of retime (in bits)
  port (
    reset : in  std_logic;
    clock : in  std_logic;
    d     : in  std_logic_vector(WIDTH-1 downto 0);
    q     : out std_logic_vector(WIDTH-1 downto 0));

end retime;

architecture rtl of retime is

  type retType is
    array (0 to DEPTH-1) of std_logic_vector(WIDTH-1 downto 0);

  signal q_i : retType;

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

  q <= q_i(DEPTH-1);

end rtl;





