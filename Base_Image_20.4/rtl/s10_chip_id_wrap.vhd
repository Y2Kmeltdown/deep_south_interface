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
-- Title       : Stratix-10 Chip ID Wrapper
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : This is a wrapper for the Stratix-10 Chip ID component.
--
--
--
--------------------------------------------------------------------------------
-- Known Issues and Omissions :
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity s10_chip_id_wrap is
  port (
    config_clk                    : in  std_logic;
    config_rstn                   : in  std_logic;
    chip_id_l                     : out std_logic_vector(31 downto 0);
    chip_id_h                     : out std_logic_vector(31 downto 0)
    );
end entity s10_chip_id_wrap;


architecture rtl of s10_chip_id_wrap is
  --------------------------
  -- Component Declarations
  --------------------------
  component s10_chip_id is
  port (
    clk                           : in  std_logic;
    data_valid                    : out std_logic;
    chip_id                       : out std_logic_vector(63 downto 0);
    reset                         : in  std_logic;
    readid                        : in  std_logic 
    );
  end component;


  -----------
  -- Signals
  -----------
  signal chip_id_rst              : std_logic;
  signal chip_id_vld              : std_logic;
  signal chip_id_a1               : std_logic_vector(63 downto 0);
  signal chip_id_i                : std_logic_vector(63 downto 0)     := (others => '0');
  signal chip_id_rd               : std_logic                         := '0';
  signal rd_count                 : std_logic_vector(5 downto 0)      := (others => '0');


begin

  u0 : s10_chip_id
  port map (
    clk                           => config_clk,                      -- in  std_logic
    data_valid                    => chip_id_vld,                     -- out std_logic
    chip_id                       => chip_id_a1,                      -- out std_logic_vector(63 downto 0)
    reset                         => chip_id_rst,                     -- in  std_logic
    readid                        => chip_id_rd                       -- in  std_logic 
    );

  chip_id_rst <= not config_rstn;


  process(config_clk)
  begin
    if rising_edge(config_clk) then
      if config_rstn = '0' then
        rd_count   <= (others => '0');
        chip_id_rd <= '0';
        chip_id_i  <= (others => '0');

      else
        if rd_count /= "111111" then
          rd_count <= rd_count + 1;
        end if;
        
        if rd_count(5 downto 4) = "01" then
          chip_id_rd <= '1';
        else
          chip_id_rd <= '0';
        end if;

        if chip_id_vld = '0' then
          chip_id_i <= (others => '0');
        else
          chip_id_i <= chip_id_a1;
        end if;

      end if;
    end if;
  end process;


  chip_id_l <= chip_id_i(31 downto 0);
  chip_id_h <= chip_id_i(63 downto 32);


end rtl;
