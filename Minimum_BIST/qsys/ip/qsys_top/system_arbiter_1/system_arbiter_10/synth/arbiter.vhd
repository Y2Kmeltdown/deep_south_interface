-- arbiter.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor. It ties off all outputs to ground and
-- ignores all inputs. It needs to be edited to make it do something
-- useful.
--
-- This file will not be automatically regenerated. You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity arbiter is
  port (
    clk                : in  std_logic                     := '0';  -- clock.clk
    reset              : in  std_logic                     := '0';  -- reset.reset
    avs_s0_address     : in  std_logic_vector(1 downto 0)  := (others => '0');  --    s0.address
    avs_s0_read        : in  std_logic                     := '0';  --      .read
    avs_s0_readdata    : out std_logic_vector(31 downto 0);  --      .readdata
    avs_s0_write       : in  std_logic                     := '0';  --      .write
    avs_s0_writedata   : in  std_logic_vector(31 downto 0) := (others => '0');  --      .writedata
    avs_s0_waitrequest : out std_logic;  --      .waitrequest
    hps_gp_o           : in  std_logic_vector(31 downto 0);
    hps_gp_i           : out std_logic_vector(31 downto 0)
    );
end entity arbiter;

architecture rtl of arbiter is

  component arbiter_frr
    generic (
      width   :     natural);
    port (
      clock   : in  std_logic;
      reset   : in  std_logic;
      request : in  std_logic_vector(width-1 downto 0);
      grant   : out std_logic_vector(width-1 downto 0));
  end component;

  constant ARB_WIDTH : integer := 2;

  signal read_d1 : std_logic;
  signal request : std_logic_vector(ARB_WIDTH-1 downto 0);
  signal grant   : std_logic_vector(ARB_WIDTH-1 downto 0);

begin

  i_arbiter_frr : arbiter_frr
    generic map (
      width   => ARB_WIDTH)
    port map (
      clock   => clk,                   -- in  
      reset   => reset,                 -- in  
      request => request,               -- in  
      grant   => grant);                -- out

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_d1 <= '0';
        request <= (others => '0');
      else
        read_d1 <= avs_s0_read and not read_d1;

        if avs_s0_write = '1' then
          if avs_s0_address = "00" then
            request <= avs_s0_writedata(1 downto 0);
          end if;
        end if;

        if avs_s0_read = '1' then
          if avs_s0_address = "00" then
            avs_s0_readdata <= (0 => request(0), 1 => request(1), 4 => grant(0), 5 => grant(1), others => '0');
          else
            avs_s0_readdata <= (others => '0');
          end if;
        end if;

      end if;
    end if;
  end process;

  avs_s0_waitrequest <= avs_s0_read and not read_d1;


end architecture rtl;
