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
--      Copyright © 1998-2017 Nallatech Limited. All rights reserved.
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
--                    NNNN              ---NNNN         (a molex company)
--                   NNNN               -----NNNN
--                  NNNN                -------NNNN
--                 NNNN                 ---------NNNN
--                NNNNNNNN              ---NNNNNNNN
--               NNNNNNNNN              ---NNNNNNNNN
--                -------------------
--               ---------------------
--
--------------------------------------------------------------------------------
-- Title       : Package for System Manager Interface
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : This is the Package for the System Manager Interface.
--
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
use ieee.std_logic_arith.all;

package pkg_sys_man is

  -------------------------------------------------------------------------------
  -- System Manager version number captured here
  -------------------------------------------------------------------------------
  constant MAJOR_VER   : std_logic_vector(7 downto 0)  := x"de";
  constant MINOR_VER   : std_logic_vector(7 downto 0)  := x"07";
  constant VERSION_NUM : std_logic_vector(15 downto 0) := MAJOR_VER & MINOR_VER;
  -------------------------------------------------------------------------------

  constant NUM_SAMP_REGS   : integer := 32;
  constant NUM_PSENS       : integer := 9;
  constant SAMP_REG_WIDTH  : integer := 12;
  constant NUM_PSU_THRESH  : integer := 18;
  constant NUM_PSU_EN      : integer := 15;
  constant NUM_CLK_OPS     : integer := 4;
  constant PS_WD_CNT_WIDTH : integer := 14;

  constant ARB_RESET_KEY : std_logic_vector(11 downto 0) := x"CAF";

  -------------------------------------------------------------------------------
  -- field identifiers
  -------------------------------------------------------------------------------

  -------------------------------------------------------------------------------
  -- Grant vector
  constant F0   : integer := 0;
  constant F1   : integer := 1;
  constant UART : integer := 2;

  --=============================================================================
  -- Command word bit positions

  -- system manager control register bit position
  constant C_HMC_HST_SEL : integer := 28;
  constant C_SEL_M       : integer := 26;
  constant C_SEL_L       : integer := 24;
  constant C_TRI_M       : integer := 23;
  constant C_TRI_L       : integer := 16;
  constant C_START       : integer := 7;
  constant C_RD          : integer := 6;
  constant C_END         : integer := 5;
  constant C_CNT_M       : integer := 4;
  constant C_CNT_L       : integer := 0;

  -- system manager i2c status register bit position
  constant S_DONE : integer := 0;
  constant S_BUSY : integer := 4;

  -- ram size paramaters
  constant RAWIDTH : integer := 9;
  constant RDWIDTH : integer := 32;

  -- supply count timebase width
  constant SUPPLY_CNT_WIDTH : integer := 12;

  -- 2.0 Mb/s line rate at 50MHz system clock (as per BeMicro card) 
--  constant UART_SAMPLE_RATIO : std_logic_vector(31 downto 0) := x"00000019";
  -- 2.0 Mb/s line rate at 100 MHz system clock (as per product)
  constant UART_SAMPLE_RATIO : std_logic_vector(31 downto 0) := x"00000032";

  -------------------------------------------------------------------------------
  -- conditional parameter

  constant USE_CFGTR_CE : boolean := true;

  -------------------------------------------------------------------------------
  -- field identifiers
  -------------------------------------------------------------------------------

  --=============================================================================
  --  Header field bit positions

  constant TYPE_LSB    : integer := 00;
  constant TYPE_MSB    : integer := 03;
  constant FLEN_MSB    : integer := 15;
  constant FLEN_LSB    : integer := 07;
  constant CMD_MSB     : integer := 07;
  constant CMD_LSB     : integer := 00;
  constant HI_ADDR_MSB : integer := 15;
  constant HI_ADDR_LSB : integer := 08;
  constant LO_ADDR_MSB : integer := 15;
  constant LO_ADDR_LSB : integer := 00;


  -------------------------------------------------------------------------------
  -- bus widths
  -------------------------------------------------------------------------------

  constant NUM_QSPI    : integer := 8;
  constant QSPI_DWIDTH : integer := 4;
  constant QLEN_WIDTH  : integer := 9;
  constant QADDR_WIDTH : integer := 32;
  constant QCMD_WIDTH  : integer := 8;

  constant UDATA_WIDTH : integer := 8;

  -- depth of mestability retime
  constant META_DEPTH : integer                        := 2;
  constant gnd        : std_logic_vector(127 downto 0) := (others => '0');

  -------------------------------------------------------------------------------
  -- encodings
  -------------------------------------------------------------------------------

  constant MEM_WR_FA   : std_logic_vector(3 downto 0) := "0000";
  constant MEM_RD_FA   : std_logic_vector(3 downto 0) := "0001";
  constant MEM_WR_FR   : std_logic_vector(3 downto 0) := "0010";
  constant MEM_RD_FR   : std_logic_vector(3 downto 0) := "0011";
  constant MEM_WR_CR   : std_logic_vector(3 downto 0) := "0100";
  constant MEM_RD_CR   : std_logic_vector(3 downto 0) := "0101";
  constant MEM_POLL_FR : std_logic_vector(3 downto 0) := "0110";
  constant MEM_ERAS_FA : std_logic_vector(3 downto 0) := "0111";
  constant MEM_WR_LR   : std_logic_vector(3 downto 0) := "1000";
  constant MEM_RD_LR   : std_logic_vector(3 downto 0) := "1001";


  -------------------------------------------------------------------------------
  -- supported flash command set

  -- program, WR_FA
  constant EXT_DUAL_INPUT_FAST_PROGRAM : std_logic_vector(7 downto 0) := x"d2";
  -- read, RD_FA 
  constant DUAL_IO_FAST_READ           : std_logic_vector(7 downto 0) := x"bb";
  -- reset operations
  constant RESET_ENABLE                : std_logic_vector(7 downto 0) := x"66";  -- WR_FR, 0
  constant RESET_MEMORY                : std_logic_vector(7 downto 0) := x"99";  -- WR_FR, 0
  -- write operations
  constant WRITE_ENABLE                : std_logic_vector(7 downto 0) := x"06";  -- WR_FR, 0
  constant WRITE_DISABLE               : std_logic_vector(7 downto 0) := x"04";  -- WR_FR, 0
  -- register operations
  constant READ_ID_REG1                : std_logic_vector(7 downto 0) := x"9E";  -- RD_FR
  constant READ_ID_REG2                : std_logic_vector(7 downto 0) := x"9F";  -- RD_FR
  constant READ_STATUS_REG             : std_logic_vector(7 downto 0) := x"05";  -- RD_FR
  constant WRITE_STATUS_REG            : std_logic_vector(7 downto 0) := x"01";  -- WR_FR
  constant READ_LOCK_REG               : std_logic_vector(7 downto 0) := x"e8";  -- LK_FR
  constant WRITE_LOCK_REG              : std_logic_vector(7 downto 0) := x"e5";  -- LK_FR
  constant READ_FLAG_SREG              : std_logic_vector(7 downto 0) := x"70";  -- RD_FR
  constant CLEAR_FLAG_SREG             : std_logic_vector(7 downto 0) := x"50";  -- WR_FR, 0
  constant READ_NONV_CREG              : std_logic_vector(7 downto 0) := x"b5";  -- RD_FR
  constant WRITE_NONV_CREG             : std_logic_vector(7 downto 0) := x"b1";  -- WR_FR
  constant READ_VOL_CREG               : std_logic_vector(7 downto 0) := x"85";  -- RD_FR
  constant WRITE_VOL_CREG              : std_logic_vector(7 downto 0) := x"81";  -- WR_FR
  constant READ_EVOL_CREG              : std_logic_vector(7 downto 0) := x"65";  -- RD_FR
  constant WRITE_EVOL_CREG             : std_logic_vector(7 downto 0) := x"61";  -- WR_FR
  constant READ_EADDR_REG              : std_logic_vector(7 downto 0) := x"c8";  -- RD_FR
  constant WRITE_EADDR_REG             : std_logic_vector(7 downto 0) := x"c5";  -- WR_FR
  -- erase operations
  constant SUBSECTOR_ERASE             : std_logic_vector(7 downto 0) := x"20";  -- ER_FA, 0
  constant SUBSECTOR_ERASE_32KB        : std_logic_vector(7 downto 0) := x"52";  -- ER_FA, 0
  constant SECTOR_ERASE                : std_logic_vector(7 downto 0) := x"d8";  -- ER_FA, 0
  constant BULK_ERASE                  : std_logic_vector(7 downto 0) := x"c7";  -- WR_FR, 0
  constant DIE_ERASE                   : std_logic_vector(7 downto 0) := x"c4";  -- WR_FR, 0
  -- "lite" command
  constant LITE                        : std_logic_vector(7 downto 0) := x"00";

  -------------------------------------------------------------------------------
  -- Memory Map

  -- word addesses to match Avalon bus
  constant ADDR_QSTATUS  : std_logic_vector(7 downto 0) := x"00";
  constant ADDR_QCONTROL : std_logic_vector(7 downto 0) := x"01";
  constant QSPI_SADDR    : std_logic_vector(7 downto 0) := x"02";
  constant OCR_SADDR     : std_logic_vector(7 downto 0) := x"03";
  constant RCFG_ADDR     : std_logic_vector(7 downto 0) := x"04";
  constant ADDR_PSTATUS  : std_logic_vector(7 downto 0) := x"05";
  constant ADDR_PCONTROL : std_logic_vector(7 downto 0) := x"06";

  -- Memory Map
  constant REG_OFFSET         : std_logic_vector(31 downto 8) := (others => '0');
  constant BRAM_00_OFFSET     : std_logic_vector(31 downto 9) := (x"0000_5" & "000");
  constant ADC_SEQ_CSR_OFFSET : std_logic_vector(31 downto 9) := (x"0000_6" & "000");
  constant ADC_SST_CSR_OFFSET : std_logic_vector(31 downto 9) := (x"0000_7" & "000");


  -------------------------------------------------------------------------------
  -- function prototypes
  -------------------------------------------------------------------------------

  -- Converts from binary to gray code
  function bin_to_gray (b : std_logic_vector) return std_logic_vector;

  -- Converts from gray to binary code
  function gray_to_bin (g : std_logic_vector) return std_logic_vector;

  -- returns difference between two vectors
  function gray_diff (g1, g2 : std_logic_vector) return natural;

  function to_std_logic (b : boolean) return std_logic;

  function to_boolean (s : std_logic) return boolean;

  function boolean_to_int (b : boolean) return integer;

  function int_to_boolean (i : integer) return boolean;

  function to_natural (b : boolean) return natural;

  function or_reduce (V : std_logic_vector) return std_logic;

  function and_reduce (V : std_logic_vector) return std_logic;

  function xor_reduce (V : std_logic_vector) return std_logic;

  function swap_dw (qw : std_logic_vector) return std_logic_vector;

  function swap_bytes (dw : std_logic_vector(31 downto 0)) return std_logic_vector;

  function swap_bits (v : std_logic_vector) return std_logic_vector;

  function conv_endian (dw : std_logic_vector) return std_logic_vector;

  function swap_nybble_bits (dw : std_logic_vector) return std_logic_vector;

  function conv_dual_to_quad (v : std_logic_vector(7 downto 0)) return std_logic_vector;

  function conv_quad_to_dual (v : std_logic_vector(7 downto 0)) return std_logic_vector;

  -- Function to repeat a vector N times to create a new larger vector V
  function repeat(N : natural; V : std_logic_vector) return std_logic_vector;


end package pkg_sys_man;

package body pkg_sys_man is

  -- Converts from binary to gray code
  function bin_to_gray (b : std_logic_vector)
    return std_logic_vector is
    variable r            : std_logic_vector(b'length downto 1) := b;
  begin
    for i in 1 to r'left-1 loop
      r(i)                                                      := r(i) xor r(i+1);
    end loop;
    return (r);
  end;

  -- Converts from gray to binary code
  function gray_to_bin (g : std_logic_vector)
    return std_logic_vector is
    variable r            : std_logic_vector(g'length downto 1) := g;
  begin
    for i in r'left-1 downto 1 loop
      r(i)                                                      := r(i) xor r(i+1);
    end loop;
    return (r);
  end;

  -- returns difference between two gray encoded vectors
  function gray_diff (g1, g2 : std_logic_vector)
    return natural is
  begin
    return conv_integer(gray_to_bin(g1) - gray_to_bin(g2));
  end;

  -- Convert boolean to std_logic
  function to_std_logic(b : boolean)
    return std_logic is
  begin
    if (b) then
      return ('1');
    else
      return ('0');
    end if;
  end;

  -- Convert std_logic to boolean
  function to_boolean(s : std_logic)
    return boolean is
  begin
    if (s = '1') then
      return (true);
    else
      return (false);
    end if;
  end;

  -- Convert boolean to integer flag
  function boolean_to_int(b : boolean)
    return integer is
  begin
    if b then
      return 1;
    else
      return 0;
    end if;
  end;

  -- Convert integer flag to boolean 
  function int_to_boolean(i : integer)
    return boolean is
  begin
    if i = 0 then
      return false;
    else
      return true;
    end if;
  end;


  -- Convert boolean to natural
  function to_natural(b : boolean)
    return natural is
  begin
    if b then
      return (1);
    else
      return (0);
    end if;
  end;

  -- bitwise OR of a vector (i.e. OR all the bits of a vector together)
  function or_reduce(V : std_logic_vector) return std_logic is

    variable result : std_logic;

  begin
    for i in V'range loop
      if i = V'left then                -- first value
        result := V(i);
      else
        result := result or V(i);
      end if;
    end loop;
    return result;
  end or_reduce;

  -- bitwise AND of a vector (i.e. AND all the bits of a vector together)
  function and_reduce(V : std_logic_vector) return std_logic is

    variable result : std_logic;

  begin
    for i in V'range loop
      if i = V'left then
        result := V(i);
      else
        result := result and V(i);
      end if;
    end loop;
    return result;
  end and_reduce;

  -- bitwise XOR of a vector (i.e. XOR all the bits of a vector together)
  function xor_reduce(V : std_logic_vector) return std_logic is

    variable result : std_logic;

  begin
    for i in V'range loop
      if i = V'left then
        result := V(i);
      else
        result := result xor V(i);
      end if;
    end loop;
    return result;
  end xor_reduce;



  function swap_dw (qw : std_logic_vector) return std_logic_vector is
    variable result    : std_logic_vector(63 downto 0);
  begin
    result(63 downto 32) := qw(31 downto 00);
    result(31 downto 00) := qw(63 downto 32);
    return result;
  end swap_dw;

  function swap_bytes (dw : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable result       : std_logic_vector(31 downto 00);
  begin
    result(31 downto 24) := dw(07 downto 00);
    result(23 downto 16) := dw(15 downto 08);
    result(15 downto 08) := dw(23 downto 16);
    result(07 downto 00) := dw(31 downto 24);
    return result;
  end swap_bytes;

  function swap_bits (v : std_logic_vector) return std_logic_vector is

    variable result : std_logic_vector(v'length-1 downto 0);

  begin
    for i in v'range loop
      result(v'high - i) := v(i);
    end loop;

    return result;
  end swap_bits;



  -- Convert big endian to little endian byte format (and vise versa)
  function conv_endian (dw : std_logic_vector) return std_logic_vector is

    variable result : std_logic_vector(31 downto 00);

  begin
    if dw'high = 31 then
      result(31 downto 24) := dw(07 downto 00);
      result(23 downto 16) := dw(15 downto 08);
      result(15 downto 08) := dw(23 downto 16);
      result(07 downto 00) := dw(31 downto 24);
    else
      result(31 downto 24) := dw(07+32 downto 00+32);
      result(23 downto 16) := dw(15+32 downto 08+32);
      result(15 downto 08) := dw(23+32 downto 16+32);
      result(07 downto 00) := dw(31+32 downto 24+32);
    end if;
    return result;
  end conv_endian;

  function swap_nybble_bits (dw : std_logic_vector) return std_logic_vector is
    variable result             : std_logic_vector(31 downto 00);
  begin
    result(31 downto 28) := dw(28) & dw(29) & dw(30) & dw(31);
    result(27 downto 24) := dw(24) & dw(25) & dw(26) & dw(27);
    result(23 downto 20) := dw(20) & dw(21) & dw(22) & dw(23);
    result(19 downto 16) := dw(16) & dw(17) & dw(18) & dw(19);
    result(15 downto 12) := dw(12) & dw(13) & dw(14) & dw(15);
    result(11 downto 08) := dw(08) & dw(09) & dw(10) & dw(11);
    result(07 downto 04) := dw(04) & dw(05) & dw(06) & dw(07);
    result(03 downto 00) := dw(00) & dw(01) & dw(02) & dw(03);
    return result;
  end swap_nybble_bits;


  -- This function performs the bit position conversion required for writes to
  -- the QSPI. Dual writes represented in a Quad fashion.
  function conv_dual_to_quad (v : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable result             : std_logic_vector(7 downto 0);
  begin
    result(00) := v(03);
    result(01) := v(02);
    result(02) := v(07);
    result(03) := v(06);
    result(04) := v(01);
    result(05) := v(00);
    result(06) := v(05);
    result(07) := v(04);
    return result;
  end conv_dual_to_quad;


  -- This function performs the bit position conversion required for reads from
  -- the QSPI. Quad format converted to dual reads (2 QSPI array version)
  function conv_quad_to_dual (v : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable result             : std_logic_vector(7 downto 0);
  begin
    -- first dual slice
    -- QSPI 0
    result(03) := v(00);
    result(02) := v(01);
    -- QSPI 1
    result(07) := v(02);
    result(06) := v(03);
    -- second slice
    -- QSPI 0
    result(01) := v(04);
    result(00) := v(05);
    -- QSPI 1
    result(05) := v(06);
    result(04) := v(07);
    return result;
  end conv_quad_to_dual;



  ---------------------------------------------------------------------------
  -- Function to repeat a vector N times to create a new larger vector V
  ---------------------------------------------------------------------------
  function repeat(N : natural; V : std_logic_vector) return std_logic_vector is

    constant L : natural := V'length;

    variable result : std_logic_vector(0 to N*L - 1);
  begin
    for i in 0 to N-1 loop
      result(i*L to i*L + L - 1) := V;
    end loop;
    return result;
  end;


end package body pkg_sys_man;
