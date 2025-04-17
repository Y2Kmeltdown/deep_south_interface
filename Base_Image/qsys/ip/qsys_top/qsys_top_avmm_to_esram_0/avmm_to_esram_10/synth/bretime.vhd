--===========================================================================
--
-- File        : bretime.vhd
-- Author      : Kenneth Morrison
-- Company     : Nallatech Ltd
--
-- Description : Bit Retime module
--
-- Omissions, Limitations, Issues :
--  - none
--
-- This module delays a scalar by n clock cycles.
-- 
--===========================================================================
library ieee;
use ieee.std_logic_1164.all;

entity bretime is
  generic (
    DEPTH :     integer := 2);           -- depth of retime (in clock cycles)
  port (
    reset : in  std_logic;
    clock : in  std_logic;
    d     : in  std_logic;
    q     : out std_logic);

end bretime;

architecture rtl of bretime is

  type retType is
    array (0 to DEPTH-1) of std_logic;

  signal q_i : retType;

begin

  process (clock) is


  begin
    if rising_edge(clock) then
    
      if (reset = '1') then
        q_i        <= (others => '0');
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




