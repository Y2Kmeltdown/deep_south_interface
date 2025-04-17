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
-- Title       : Cooker Wrapper
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : Wrapper for the Cooker components.
--
--               Includes:
--                 * sreg_cook_test
--                 * bram_cook_test
--                 * dsp_cook_test
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


entity cooker_wrapper is
  generic (
    NUM_X8_REG          : integer                 := 2000;
    NUM_BRAM            : integer                 := 64;
    NUM_DSP             : integer                 := 64
    );
  port (
    cook_clk            : in  std_logic;
    cook_sreg_en        : in  std_logic_vector(7 downto 0);
    cook_bram_en        : in  std_logic_vector(7 downto 0);
    cook_dsp_en         : in  std_logic_vector(7 downto 0);
    cook_size           : in  std_logic;
    sreg_cook_out       : out std_logic;
    bram_cook_out       : out std_logic;
    dsp_cook_out        : out std_logic
    );
end entity cooker_wrapper;


architecture rtl of cooker_wrapper is
  -----------
  -- Signals
  -----------
  signal cook_sreg            : std_logic_vector(7 downto 0);
  signal cook_bram            : std_logic_vector(7 downto 0);
  signal cook_dsp             : std_logic_vector(7 downto 0);


begin

  cook_sreg <= cook_sreg_en when cook_size = '0' else (others => '0');
  cook_bram <= cook_bram_en when cook_size = '0' else (others => '0');
  cook_dsp  <= cook_dsp_en  when cook_size = '0' else (others => '0');


  u20 : entity work.sreg_cook_test
  generic map (
    NUM_X8_REG          => NUM_X8_REG
    )
  port map (
    clk                 => cook_clk,        -- in  std_logic
    async_rst           => '0',             -- in  std_logic
    reg_en              => cook_sreg,       -- in  std_logic_vector(7 downto 0)
    reg_out             => sreg_cook_out    -- out std_logic
    );

  u21 : entity work.bram_cook_test
  generic map (
    NUM_BRAM            => NUM_BRAM
    )
  port map (
    clk                 => cook_clk,        -- in  std_logic
    async_rst           => '0',             -- in  std_logic
    byte_en             => cook_bram,       -- in  std_logic_vector(7 downto 0)
    bram_out            => bram_cook_out    -- out std_logic
    );

  u22 : entity work.dsp_cook_test
  generic map (
    NUM_DSP             => NUM_DSP
    )
  port map (
    clk                 => cook_clk,        -- in  std_logic
    async_rst           => '0',             -- in  std_logic
    dsp_en              => cook_dsp,        -- in  std_logic_vector(7 downto 0)
    dsp_out             => dsp_cook_out     -- out std_logic
    );


end rtl;
