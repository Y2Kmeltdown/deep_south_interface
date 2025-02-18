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
--      Copyright � 1998-2018 Nallatech Limited. All rights reserved.
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
-- Title       : DSP Cooker Test
-- Project     : Common Firmware
--------------------------------------------------------------------------------
-- Description : This component instantiates chains of DSP multiplier logic
--               and supplies them with PRBS test data.
--
--
--
--------------------------------------------------------------------------------
-- Known Issues and Omissions:
--
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity dsp_cook_test is
  generic (
    NUM_DSP                   : integer := 32     -- No of DSPs
    );
  port (
    clk                       : in  std_logic;
    async_rst                 : in  std_logic;
    dsp_en                    : in  std_logic_vector(7 downto 0);
    dsp_out                   : out std_logic
    );
end entity dsp_cook_test;


architecture rtl of dsp_cook_test is
  ---------
  -- Types
  ---------
  type T_prbs           is array (0 to 7)                   of std_logic_vector(8 downto 0);
  type T_reg_wrd        is array (0 to ((NUM_DSP/8)*2)-1)   of std_logic_vector(17 downto 0);
  type T_reg_wrd_x8     is array (0 to 7)                   of T_reg_wrd;
  type T_reg_pipe       is array (0 to 3)                   of std_logic_vector(17 downto 0);
  type T_reg_dsp        is array (0 to (NUM_DSP/8)-1)       of T_reg_pipe;
  type T_reg_dsp_x8     is array (0 to 7)                   of T_reg_dsp;
  type T_reg_out        is array (0 to (NUM_DSP/8)-1)       of std_logic_vector(35 downto 0);
  type T_reg_out_x8     is array (0 to 7)                   of T_reg_out;
  type T_reg_xor_x8     is array (0 to 7)                   of std_logic_vector((NUM_DSP/8)-1 downto 0);

  -------------
  -- Constants
  -------------
  constant PRBS_INIT          : T_prbs                      := ("111111110","111111101","111111011","111110111",
                                                                "111101111","111011111","110111111","101111111");

  -----------
  -- Signals
  -----------
  signal prbs_gen             : T_prbs                      := PRBS_INIT;
  signal reg_wrd_pipe         : T_reg_wrd_x8                := (others => (others => (others => '0')));
  signal reg_dsp_a            : T_reg_dsp_x8                := (others => (others => (others => (others => '0'))));
  signal reg_dsp_b            : T_reg_dsp_x8                := (others => (others => (others => (others => '0'))));
  signal reg_dsp_out          : T_reg_out_x8                := (others => (others => (others => '0')));
  signal reg_dsp_xor          : T_reg_xor_x8                := (others => (others => '0'));
  signal dsp_out_a1           : std_logic                   := '0';


begin
  process(clk, async_rst)
    variable prbs_v           : std_logic_vector(8 downto 0);
  begin
    if async_rst = '1' then 
      prbs_gen <= PRBS_INIT;

    elsif rising_edge(clk) then
      -- PRBS Generators (8x 9-bit)
      for j in 0 to 7 loop
        if prbs_gen(j) = "000000000" then
          prbs_gen(j) <= PRBS_INIT(j);
        else
          prbs_v := prbs_gen(j);
          for i in 0 to 7 loop
            prbs_v := (prbs_v(7 downto 0) & (prbs_v(4) xor prbs_v(8)));
          end loop;
          prbs_gen(j) <= prbs_v;
        end if;
      end loop;
    end if;
  end process;


  g0 : for k in 0 to 7 generate
  begin
    process(clk)
      variable dsp_xor_v      : std_logic;
    begin
      if rising_edge(clk) then
        -- Create 8x DSP input word pipelines (each word has an associated enable)
        if dsp_en(k) = '1' then
          for i in 0 to 8 loop
            reg_wrd_pipe(k)(0)(i)   <= prbs_gen(k)(i);
            reg_wrd_pipe(k)(0)(9+i) <= not prbs_gen(k)(i);
          end loop;
        else
          reg_wrd_pipe(k)(0) <= (others => '0');
        end if;

        for j in 1 to ((NUM_DSP/8)*2)-1 loop
          reg_wrd_pipe(k)(j) <= reg_wrd_pipe(k)(j-1);
        end loop;

        -- DSP IP core pipelines
        for j in 0 to (NUM_DSP/8)-1 loop
          reg_dsp_a(k)(j)(0) <= reg_wrd_pipe(k)(2*j);
          reg_dsp_a(k)(j)(1) <= reg_dsp_a(k)(j)(0);
          reg_dsp_a(k)(j)(2) <= reg_dsp_a(k)(j)(1);

          reg_dsp_b(k)(j)(0) <= reg_wrd_pipe(k)((2*j)+1);
          reg_dsp_b(k)(j)(1) <= reg_dsp_b(k)(j)(0);
          reg_dsp_b(k)(j)(2) <= reg_dsp_b(k)(j)(1);

          reg_dsp_out(k)(j)  <= reg_dsp_a(k)(j)(2) * reg_dsp_b(k)(j)(2);
        end loop;

        -- XOR reduce each DSP output
        dsp_xor_v := '0';
        for i in 0 to 8 loop
          dsp_xor_v := dsp_xor_v xor reg_dsp_out(k)(0)((4*i)+3);
        end loop;
        reg_dsp_xor(k)(0) <= dsp_xor_v;

        for j in 1 to (NUM_DSP/8)-1 loop
          dsp_xor_v := reg_dsp_xor(k)(j-1);
          for i in 0 to 8 loop
            dsp_xor_v := dsp_xor_v xor reg_dsp_out(k)(j)((4*i)+3);
          end loop;
          reg_dsp_xor(k)(j) <= dsp_xor_v;
        end loop;

      end if;
    end process;
  end generate;


  process(clk)
    variable dsp_out_v        : std_logic;
  begin
    if rising_edge(clk) then
      -- Combine bits for final output
      dsp_out_v := '0';
      for k in 0 to 7 loop
        dsp_out_v := dsp_out_v xor reg_dsp_xor(k)((NUM_DSP/8)-1);
      end loop;
      dsp_out_a1 <= dsp_out_v;
      dsp_out    <= dsp_out_a1;
    end if;
  end process;


end rtl;
