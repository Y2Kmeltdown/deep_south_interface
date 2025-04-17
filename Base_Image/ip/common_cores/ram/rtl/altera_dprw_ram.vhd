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
--                    NNNN---NNNN         (a subsidiary of
--                   NNNN-----NNNN        Interconnect Systems Inc.)
--                  NNNN-------NNNN
--                 NNNN---------NNNN
--                NNNNNNNN---NNNNNNNN
--               NNNNNNNNN---NNNNNNNNN
--                -------------------
--               ---------------------
--
--------------------------------------------------------------------------------
-- Title       : Altera Dual-Port RAM
-- Project     : Common Firmware
--------------------------------------------------------------------------------
-- Description : This component infers dual port RAM with asynchronous
--               write and read access through each port.
--
--
--------------------------------------------------------------------------------
-- Known Issues and Omissions:
--
--
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity altera_dprw_ram is
  generic
    (
    AWIDTH   : natural := 9;
    DWIDTH   : natural := 32
      );
  port(
    clka     : in  std_logic;
    clkb     : in  std_logic;
    wea      : in  std_logic;
    web      : in  std_logic;
    addra    : in  std_logic_vector(AWIDTH-1 downto 0);
    addrb    : in  std_logic_vector(AWIDTH-1 downto 0);
    dia      : in  std_logic_vector(DWIDTH-1 downto 0);
    dib      : in  std_logic_vector(DWIDTH-1 downto 0);
    doa      : out std_logic_vector(DWIDTH-1 downto 0);
    dob      : out std_logic_vector(DWIDTH-1 downto 0)
    );
end altera_dprw_ram;

architecture syn of altera_dprw_ram is
  type T_mem is array (0 to (2**AWIDTH)-1) of std_logic_vector(DWIDTH-1 downto 0);
  shared variable RAM_shared : T_mem    := (others => (others => '0'));

begin

  process (clka)
  begin
    if rising_edge(clka) then
      if wea = '1' then
        RAM_shared(conv_integer(addra)) := dia;
      end if;

      doa <= RAM_shared(conv_integer(addra));

    end if;
  end process;


  process (clkb)
  begin
    if rising_edge(clkb) then
      if web = '1' then
        RAM_shared(conv_integer(addrb)) := dib;
      end if;

      dob <= RAM_shared(conv_integer(addrb));

    end if;
  end process;


end syn;

