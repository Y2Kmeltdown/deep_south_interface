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
-- Title       : Clock Test
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : A bank of fifteen identical 32-bit counters that are used for
--               clock frequency measurement. It is assumed that each counter
--               is clocked by a different (and un-related) clock. All the
--               counters share a common synchronous reset and enable control.
--               The counters reset to 0x00000000 and count up (when enabled)
--               to a maximum of 0xFFFFFFFF, they do not roll over.
--
--               Typically a reliable reference clock is used to clock counter
--               'count_0' while the clocks to be measured are used to clock
--               the remaining counters. All the counters are initailly
--               disabled and reset (count_control = "01"). Next the counters
--               are enabled (count_control = "10") for an appropriate period
--               of time and then disabled (count_control = "00"). The counter
--               values are then read via the host interface and this allows
--               the frequency of each clock to be determined by calculating
--               the ratio:
--
--                 Clk 'n' Freq = Ref Clk Freq * (count_n/count_0)
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

use work.pkg_user_registers.all;


entity clock_test is
  port (
    config_clk          : in  std_logic;
    config_rstn         : in  std_logic;
    -- Host Interface
    avmm_writedata      : in  std_logic_vector(31 downto 0);
    avmm_address        : in  std_logic_vector(11 downto 0);
    avmm_write          : in  std_logic;
    avmm_byteenable     : in  std_logic_vector(3 downto 0);
    -- Test Clocks
    test_clock          : in  std_logic_vector(14 downto 0);
    test_clock_stat     : in  std_logic_vector(14 downto 0);
    count_stcl          : out std_logic_vector(31 downto 0);
    count_0             : out std_logic_vector(31 downto 0);
    count_1             : out std_logic_vector(31 downto 0);
    count_2             : out std_logic_vector(31 downto 0);
    count_3             : out std_logic_vector(31 downto 0);
    count_4             : out std_logic_vector(31 downto 0);
    count_5             : out std_logic_vector(31 downto 0);
    count_6             : out std_logic_vector(31 downto 0);
    count_7             : out std_logic_vector(31 downto 0);
    count_8             : out std_logic_vector(31 downto 0);
    count_9             : out std_logic_vector(31 downto 0);
    count_10            : out std_logic_vector(31 downto 0);
    count_11            : out std_logic_vector(31 downto 0);
    count_12            : out std_logic_vector(31 downto 0);
    count_13            : out std_logic_vector(31 downto 0);
    count_14            : out std_logic_vector(31 downto 0)
    );
end clock_test;


architecture rtl of clock_test is

  component bretime_async_rst
  generic (
    DEPTH     : integer
    );
  port (
    clock     : in  std_logic;
    d         : in  std_logic;
    q         : out std_logic
    );
  end component;

  component counter32
  port (
    clock     : in  std_logic;
    reset     : in  std_logic;
    enable    : in  std_logic;
    count     : out std_logic_vector(31 downto 0)
    );
  end component;


---------
-- Types
---------
type T_count_out is array (0 to 14) of std_logic_vector(31 downto 0);

-----------
-- Signals
-----------
signal count_ctrl             : std_logic_vector(1 downto 0)          := (others => '0');
signal count_reset            : std_logic_vector(14 downto 0);
signal count_enable           : std_logic_vector(14 downto 0);
signal count_out              : T_count_out;


begin
  --------------------
  -- Control Register
  --------------------
  process(config_clk)
  begin
    if rising_edge(config_clk) then
      if config_rstn = '0' then
        count_ctrl <= (others => '0');
      elsif avmm_write = '1' then
        if (avmm_address = CLK_COUNT_STCL) then
          if avmm_byteenable(0) = '1' then
            count_ctrl <= avmm_writedata(1 downto 0);
          end if;
        end if;
      end if;
    end if;
  end process;


  ---------------------
  -- Generate Counters
  ---------------------
  gen_counters : for i in 0 to 14 generate

    retime_reset : bretime_async_rst
    generic map (
      DEPTH => 2
      )
    port map (
      clock   => test_clock(i),
      d       => count_ctrl(0),
      q       => count_reset(i)
      );

    retime_enable : bretime_async_rst
    generic map (
      DEPTH   => 2
      )
    port map (
      clock   => test_clock(i),
      d       => count_ctrl(1),
      q       => count_enable(i)
      );

    clk_counter : counter32
    port map (
      clock   => test_clock(i),
      reset   => count_reset(i),
      enable  => count_enable(i),
      count   => count_out(i)
      );

  end generate;


  -------------------
  -- Connect outputs
  -------------------
  count_stcl <= ('0' & test_clock_stat & x"000" & "00" & count_ctrl);
  count_0    <= count_out(0);
  count_1    <= count_out(1);
  count_2    <= count_out(2);
  count_3    <= count_out(3);
  count_4    <= count_out(4);
  count_5    <= count_out(5);
  count_6    <= count_out(6);
  count_7    <= count_out(7);
  count_8    <= count_out(8);
  count_9    <= count_out(9);
  count_10   <= count_out(10);
  count_11   <= count_out(11);
  count_12   <= count_out(12);
  count_13   <= count_out(13);
  count_14   <= count_out(14);


end rtl;
