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
-- Title       : Memory BIST (Data Generator/Verifier)
-- Project     : Common Firmware
--------------------------------------------------------------------------------
-- Description : BIST component for memory (SDRAM) testing.
--
--                 * Free-running write/read (to give maximum possible
--                   bandwidth)
--                 * Supports multiple test patterns
--                 * Outputs test results and SDRAM status
--
--
--------------------------------------------------------------------------------
-- Known Issues and Omissions:
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity memory_bist_with_parity is
  generic (
    ADDRESS_WIDTH            :     integer := 40;
    MEMORY_BYTE_WIDTH        :     integer := 64;  -- HSD Byte Width
    PARITY_BYTE_WIDTH        :     integer := 8;
    ACTUAL_MEMORY_BYTE_WIDTH :     integer := 8;  -- Memory Byte Width
    ACTUAL_PARITY_BYTE_WIDTH :     integer := 1;
    MEM_TOP_BIT              :     integer := 30;
-- MEM_DEPTH : std_logic_vector(ADDRESS_WIDTH-1 downto 0) := (others => '0');  -- Memory Depth
    SIM                      :     boolean := false;  -- Simulation Mode (reduces amount of memory tested)
    STATUS_WIDTH             :     integer := 65;  -- Must be at least (ACTUAL_PARITY_BYTE_WIDTH*64)+1 to include calibration_complete
    CONTROL_WIDTH            :     integer := 64  -- Must be at least (ACTUAL_PARITY_BYTE_WIDTH*64)
    );
  port (
    reset                    : in  std_logic;
    clk                      : in  std_logic;
    -- Nallatech HSD Port
    maddr                    : out std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    mcmd                     : out std_logic_vector(2 downto 0);
    mdata                    : out std_logic_vector((MEMORY_BYTE_WIDTH*8)-1 downto 0);
    mbyte_en                 : out std_logic_vector(MEMORY_BYTE_WIDTH+PARITY_BYTE_WIDTH-1 downto 0);
    scmd_accept              : in  std_logic;
    sdata                    : in  std_logic_vector((MEMORY_BYTE_WIDTH*8)-1 downto 0);
    sresp                    : in  std_logic_vector(1 downto 0);
    status                   : in  std_logic_vector(STATUS_WIDTH-1 downto 0);
    control                  : out std_logic_vector(CONTROL_WIDTH-1 downto 0);
    -- BIST Control/Status
    bist_enable              : in  std_logic;
    bist_reset               : in  std_logic;
    pattern_select           : in  std_logic_vector(5 downto 0);
    pattern3_byte0           : in  std_logic_vector(7 downto 0);
    pattern3_byte1           : in  std_logic_vector(7 downto 0);
    write_stop               : in  std_logic;
    test_running             : out std_logic;
    test_fail                : out std_logic;
    pipe_clean               : out std_logic;
    tests_completed          : out std_logic_vector(31 downto 0);
    error_count              : out std_logic_vector(31 downto 0);
    error_bits               : out std_logic_vector((ACTUAL_MEMORY_BYTE_WIDTH*8)-1 downto 0);
    error_parity_bits        : out std_logic_vector((ACTUAL_PARITY_BYTE_WIDTH*8)-1 downto 0);
    words_stored             : out std_logic_vector(15 downto 0);
    address_mem_wr           : out std_logic;
    address_mem_addr         : out std_logic_vector(9 downto 0);
    address_mem_data         : out std_logic_vector(((MEMORY_BYTE_WIDTH/ACTUAL_MEMORY_BYTE_WIDTH)*32)-1 downto 0);
    expected_mem_wr          : out std_logic;
    expected_mem_addr        : out std_logic_vector(9 downto 0);
    expected_mem_data        : out std_logic_vector(((MEMORY_BYTE_WIDTH+PARITY_BYTE_WIDTH)*8)-1 downto 0);
    expected_mem_data_fixed  : out std_logic_vector(((MEMORY_BYTE_WIDTH+PARITY_BYTE_WIDTH)*8)-1 downto 0);
    received_mem_wr          : out std_logic;
    received_mem_addr        : out std_logic_vector(9 downto 0);
    received_mem_data        : out std_logic_vector(((MEMORY_BYTE_WIDTH+PARITY_BYTE_WIDTH)*8)-1 downto 0);
    received_mem_data_fixed  : out std_logic_vector(((MEMORY_BYTE_WIDTH+PARITY_BYTE_WIDTH)*8)-1 downto 0)
    );
end entity memory_bist_with_parity;

architecture rtl of memory_bist_with_parity is

--------------------------
-- Component Declarations
--------------------------
  component wide_prbs_gen
    generic (
      width            :     integer := 11;  -- width of prbs 
      data_width       :     integer := 128  -- width of output data pipe
      );
    port (
      clock            : in  std_logic;
      sync_reset       : in  std_logic;
      enable           : in  std_logic;
      load             : in  std_logic;
      prbs_context_in  : in  std_logic_vector(data_width-1 downto 0);
      prbs_context_out : out std_logic_vector(data_width-1 downto 0);
      data             : out std_logic_vector(data_width-1 downto 0)
      );
  end component;

-------------
-- Constants
-------------
  constant MEM_DEPTH          : std_logic_vector(ADDRESS_WIDTH-1 downto 0) := (MEM_TOP_BIT => '1', others => '0');
  constant BURST_WIDTH        : integer                                    := MEMORY_BYTE_WIDTH/ACTUAL_MEMORY_BYTE_WIDTH;
  constant ACTUAL_BYTE_WIDTH  : integer                                    := ACTUAL_MEMORY_BYTE_WIDTH+ACTUAL_PARITY_BYTE_WIDTH;
  constant TEST_DATA_WIDTH    : integer                                    := 8*((ACTUAL_MEMORY_BYTE_WIDTH+ACTUAL_PARITY_BYTE_WIDTH)*BURST_WIDTH);
  constant CHECK_DATA_WIDTH   : integer                                    := 8*(ACTUAL_MEMORY_BYTE_WIDTH*BURST_WIDTH);
  constant CHECK_STATUS_WIDTH : integer                                    := 8*(ACTUAL_PARITY_BYTE_WIDTH*BURST_WIDTH);
  constant ZERO_ERRORS        : std_logic_vector(BURST_WIDTH-1 downto 0)   := (others      => '0');
  constant MAX_WORDS_STORED   : std_logic_vector(10 downto 0)              := "10000000000";
  constant MAX_ERRORS         : std_logic_vector(31 downto 0)              := x"FFFFFFFF";
  constant ZERO32             : std_logic_vector(31 downto 0)              := (others      => '0');

  constant TEMP_FIVES : std_logic_vector(287 downto 0) := x"555555555555555555555555555555555555555555555555555555555555555555555555";
  constant TEMP_AS    : std_logic_vector(287 downto 0) := x"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
  constant TEMP_ZEROS : std_logic_vector(287 downto 0) := x"000000000000000000000000000000000000000000000000000000000000000000000000";
  constant TEMP_FS    : std_logic_vector(287 downto 0) := x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";

  constant IDLE_CMD  : std_logic_vector(2 downto 0) := "000";
  constant WRITE_CMD : std_logic_vector(2 downto 0) := "001";
  constant READ_CMD  : std_logic_vector(2 downto 0) := "010";

  constant IDLE_RESP  : std_logic_vector(1 downto 0) := "00";
  constant VALID_RESP : std_logic_vector(1 downto 0) := "01";

-----------
-- Signals
-----------
  type bist_states is (IDLE, WAIT_FOR_CALIBRATE, CHECK_MODE, WAIT_WRITE, WRITE_DATA, WAIT_READ, READ_DATA, CHANGE_MODE);
  signal bist_fsm : bist_states;

  signal fsm_reset    : std_logic;
  signal test_mode    : integer range 1 to 6;
  signal test_mode_d1 : integer range 1 to 6;
  signal test_mode_d2 : integer range 1 to 6;

  signal data_reset            : std_logic_vector(1 downto 0);
  signal seq_data              : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal seq_data_chk          : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal rolling_one_data      : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal rolling_one_data_chk  : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal rolling_zero_data     : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal rolling_zero_data_chk : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal fives_as_data         : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal fives_as_data_chk     : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal zeros_fs_data         : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal zeros_fs_data_chk     : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal random_data           : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal random_data_chk       : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal prbs_data             : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal prbs_data_chk         : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal chk_data              : std_logic_vector(CHECK_DATA_WIDTH-1 downto 0);
  signal chk_data_d1           : std_logic_vector(CHECK_DATA_WIDTH-1 downto 0);
  signal chk_data_d2           : std_logic_vector(CHECK_DATA_WIDTH-1 downto 0);
  signal chk_status            : std_logic_vector(CHECK_STATUS_WIDTH-1 downto 0);
  signal chk_status_d1         : std_logic_vector(CHECK_STATUS_WIDTH-1 downto 0);
  signal chk_status_d2         : std_logic_vector(CHECK_STATUS_WIDTH-1 downto 0);

  signal prbs_reset       : std_logic;
  signal prbs_test_enable : std_logic;
  signal prbs_chk_enable  : std_logic;

  signal address_reset : std_logic;
  signal write_addr    : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
  signal read_addr     : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
  signal read_count    : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
  signal read_done     : std_logic;

  signal end_address : std_logic_vector(ADDRESS_WIDTH-1 downto 0);

  signal test_reset          : std_logic;
  signal test_running_i      : std_logic;
  signal test_fail_i         : std_logic;
  signal data_error_i        : std_logic_vector(BURST_WIDTH-1 downto 0);
  signal status_error_i      : std_logic_vector(BURST_WIDTH-1 downto 0);
  signal error_data_bits_i   : std_logic_vector(CHECK_DATA_WIDTH-1 downto 0);
  signal error_parity_bits_i : std_logic_vector(CHECK_STATUS_WIDTH-1 downto 0);
  signal error_count_i       : std_logic_vector(31 downto 0);
  signal error_temp          : std_logic;

  signal error_bits_i       : std_logic_vector((ACTUAL_MEMORY_BYTE_WIDTH*8)-1 downto 0);
  signal error_extra_bits_i : std_logic_vector((ACTUAL_PARITY_BYTE_WIDTH*8)-1 downto 0);

  signal tests_completed_i : std_logic_vector(31 downto 0);

  signal memory_reset        : std_logic_vector(1 downto 0);
  signal words_stored_i      : std_logic_vector(10 downto 0);
  signal address_mem_addr_i  : std_logic_vector(9 downto 0);
  signal expected_mem_addr_i : std_logic_vector(9 downto 0);
  signal received_mem_addr_i : std_logic_vector(9 downto 0);

  signal address_mem_data_tmp      : std_logic_vector((32*BURST_WIDTH)-1 downto 0);
  signal address_mem_data_i        : std_logic_vector((32*BURST_WIDTH)-1 downto 0);
  signal expected_mem_data_i       : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal received_mem_data_i       : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal expected_mem_data_fixed_i : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal received_mem_data_fixed_i : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);

  signal calibration_complete : std_logic;

  signal mcmd_i         : std_logic_vector(2 downto 0);
  signal scmd_accept_d1 : std_logic;
  signal sresp_d1       : std_logic_vector(1 downto 0);
  signal sresp_d2       : std_logic_vector(1 downto 0);
  signal sresp_d3       : std_logic_vector(1 downto 0);
  signal sdata_d1       : std_logic_vector((MEMORY_BYTE_WIDTH*8)-1 downto 0);
  signal sdata_d2       : std_logic_vector((MEMORY_BYTE_WIDTH*8)-1 downto 0);
  signal status_d1      : std_logic_vector((PARITY_BYTE_WIDTH*8)-1 downto 0);
  signal status_d2      : std_logic_vector((PARITY_BYTE_WIDTH*8)-1 downto 0);

  signal temp_prbs00 : std_logic_vector(26 downto 0);
  signal temp_prbs10 : std_logic_vector(26 downto 0);
  signal temp_prbs20 : std_logic_vector(17 downto 0);
  signal temp_prbs01 : std_logic_vector(26 downto 0);
  signal temp_prbs11 : std_logic_vector(26 downto 0);
  signal temp_prbs21 : std_logic_vector(17 downto 0);
  signal temp_prbs02 : std_logic_vector(26 downto 0);
  signal temp_prbs12 : std_logic_vector(26 downto 0);
  signal temp_prbs22 : std_logic_vector(17 downto 0);
  signal temp_prbs03 : std_logic_vector(26 downto 0);
  signal temp_prbs13 : std_logic_vector(26 downto 0);
  signal temp_prbs23 : std_logic_vector(17 downto 0);
  signal temp_prbs04 : std_logic_vector(26 downto 0);
  signal temp_prbs14 : std_logic_vector(26 downto 0);
  signal temp_prbs24 : std_logic_vector(17 downto 0);
  signal temp_prbs05 : std_logic_vector(26 downto 0);
  signal temp_prbs15 : std_logic_vector(26 downto 0);
  signal temp_prbs25 : std_logic_vector(17 downto 0);
  signal temp_prbs06 : std_logic_vector(26 downto 0);
  signal temp_prbs16 : std_logic_vector(26 downto 0);
  signal temp_prbs26 : std_logic_vector(17 downto 0);
  signal temp_prbs07 : std_logic_vector(26 downto 0);
  signal temp_prbs17 : std_logic_vector(26 downto 0);
  signal temp_prbs27 : std_logic_vector(17 downto 0);

  signal pattern_written : std_logic;
  signal null_prbs       : std_logic_vector(TEST_DATA_WIDTH-1 downto 0);
  signal error_byte      : std_logic_vector(ACTUAL_BYTE_WIDTH-1 downto 0);
  signal wait_count      : std_logic_vector(15 downto 0);


begin

  g1_nosim          : if not (sim) generate
    g2_burstwidth_2 : if BURST_WIDTH = 2 generate
      g3_mbw_4      : if MEMORY_BYTE_WIDTH = 4 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-2 downto 1) & "00")-4;
      end generate;
      g3_mbw_8      : if MEMORY_BYTE_WIDTH = 8 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-3 downto 1) & "000")-8;
      end generate;
      g3_mbw_16     : if MEMORY_BYTE_WIDTH = 16 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-4 downto 1) & "0000")-16;
      end generate;
      g3_mbw_32     : if MEMORY_BYTE_WIDTH = 32 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-5 downto 1) & "00000")-32;
      end generate;
      g3_mbw_64     : if MEMORY_BYTE_WIDTH = 64 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-6 downto 1) & "000000")-64;
      end generate;
    end generate;
    g2_burstwidth_4 : if BURST_WIDTH = 4 generate
      g3_mbw_4      : if MEMORY_BYTE_WIDTH = 4 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-1 downto 2) & "00")-4;
      end generate;
      g3_mbw_8      : if MEMORY_BYTE_WIDTH = 8 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-2 downto 2) & "000")-8;
      end generate;
      g3_mbw_16     : if MEMORY_BYTE_WIDTH = 16 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-3 downto 2) & "0000")-16;
      end generate;
      g3_mbw_32     : if MEMORY_BYTE_WIDTH = 32 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-4 downto 2) & "00000")-32;
      end generate;
      g3_mbw_64     : if MEMORY_BYTE_WIDTH = 32 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-5 downto 2) & "000000")-64;
      end generate;
    end generate;
    g2_burstwidth_8 : if BURST_WIDTH = 8 generate
      g3_mbw_4      : if MEMORY_BYTE_WIDTH = 4 generate
        end_address <= ("0" & MEM_DEPTH(ADDRESS_WIDTH-1 downto 3) & "00")-4;
      end generate;
      g3_mbw_8      : if MEMORY_BYTE_WIDTH = 8 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-1 downto 3) & "000")-8;
      end generate;
      g3_mbw_16     : if MEMORY_BYTE_WIDTH = 16 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-2 downto 3) & "0000")-16;
      end generate;
      g3_mbw_32     : if MEMORY_BYTE_WIDTH = 32 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-3 downto 3) & "00000")-32;
      end generate;
      g3_mbw_64     : if MEMORY_BYTE_WIDTH = 64 generate
        end_address <= (MEM_DEPTH(ADDRESS_WIDTH-4 downto 3) & "000000")-64;
      end generate;
    end generate;
  end generate;

  g1_sim            : if sim generate
    g2_burstwidth_2 : if BURST_WIDTH = 2 generate
      g3_mbw_4      : if MEMORY_BYTE_WIDTH = 4 generate
        end_address <= ext( (MEM_DEPTH(ADDRESS_WIDTH-2 downto 14) & "00")-4, end_address'length);
      end generate;
      g3_mbw_8      : if MEMORY_BYTE_WIDTH = 8 generate
        end_address <= ext( (MEM_DEPTH(ADDRESS_WIDTH-3 downto 14) & "000")-8, end_address'length);
      end generate;
      g3_mbw_16     : if MEMORY_BYTE_WIDTH = 16 generate
        end_address <= ext( (MEM_DEPTH(ADDRESS_WIDTH-4 downto 14) & "0000")-16, end_address'length);
      end generate;
      g3_mbw_32     : if MEMORY_BYTE_WIDTH = 32 generate
        end_address <= ext( (MEM_DEPTH(ADDRESS_WIDTH-5 downto 14) & "00000")-32, end_address'length);
      end generate;
      g3_mbw_64     : if MEMORY_BYTE_WIDTH = 64 generate
        end_address <= ext( (MEM_DEPTH(ADDRESS_WIDTH-6 downto 14) & "000000")-64, end_address'length);
      end generate;
    end generate;
    g2_burstwidth_4 : if BURST_WIDTH = 4 generate
      g3_mbw_4      : if MEMORY_BYTE_WIDTH = 4 generate
        end_address <= ext( (MEM_DEPTH(ADDRESS_WIDTH-1 downto 15) & "00")-4, end_address'length);
      end generate;
      g3_mbw_8      : if MEMORY_BYTE_WIDTH = 8 generate
        end_address <= ext ( (MEM_DEPTH(ADDRESS_WIDTH-2 downto 15) & "000")-8, end_address'length);
      end generate;
      g3_mbw_16     : if MEMORY_BYTE_WIDTH = 16 generate
        end_address <= ext ( (MEM_DEPTH(ADDRESS_WIDTH-3 downto 15) & "0000")-16, end_address'length);
      end generate;
      g3_mbw_32     : if MEMORY_BYTE_WIDTH = 32 generate
        end_address <= ext ( (MEM_DEPTH(ADDRESS_WIDTH-4 downto 15) & "00000")-32, end_address'length);
      end generate;
      g3_mbw_64     : if MEMORY_BYTE_WIDTH = 64 generate
        end_address <= ext ( (MEM_DEPTH(ADDRESS_WIDTH-5 downto 15) & "000000")-64, end_address'length);
      end generate;
    end generate;
    g2_burstwidth_8 : if BURST_WIDTH = 8 generate
      g3_mbw_4      : if MEMORY_BYTE_WIDTH = 4 generate
        end_address <= ext ( (MEM_DEPTH(ADDRESS_WIDTH-1 downto 16) & "00")-4, end_address'length);
      end generate;
      g3_mbw_8      : if MEMORY_BYTE_WIDTH = 8 generate
        end_address <= ext ( (MEM_DEPTH(ADDRESS_WIDTH-1 downto 16) & "000")-8, end_address'length);
      end generate;
      g3_mbw_16     : if MEMORY_BYTE_WIDTH = 16 generate
        end_address <= ext ( (MEM_DEPTH(ADDRESS_WIDTH-2 downto 16) & "0000")-16, end_address'length);
      end generate;
      g3_mbw_32     : if MEMORY_BYTE_WIDTH = 32 generate
        end_address <= ext ( (MEM_DEPTH(ADDRESS_WIDTH-3 downto 16) & "00000")-32, end_address'length);
      end generate;
      g3_mbw_64     : if MEMORY_BYTE_WIDTH = 64 generate
        end_address <= ext ( (MEM_DEPTH(ADDRESS_WIDTH-4 downto 16) & "000000")-64, end_address'length);
      end generate;
    end generate;
  end generate;

-- Reduced memory depth (for speedy simulation)
--g1_end_address_sim : if sim /= 0 generate
--
--end_address <= (x"0" & MEM_DEPTH(31 downto 14) & "00" & x"00") - MEMORY_BYTE_WIDTH;
--
--end generate;
--
--g2_end_address_full : if sim=0 generate
--
--end_address <= (MEM_DEPTH(21 downto 0) & "00" & x"00") - MEMORY_BYTE_WIDTH;
--
--end generate;

-- MSB of status field should be calibration_complete status signal
  calibration_complete <= status(STATUS_WIDTH-1);

  null_prbs <= (others => '0');

-- PRBS Generators
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        prbs_reset     <= '1';
      else
        if bist_reset = '1' then
          prbs_reset   <= '1';
        else
          prbs_reset   <= '0';
          if bist_fsm = CHANGE_MODE then
            prbs_reset <= '1';
          else
            prbs_reset <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;

  random_test_pattern : wide_prbs_gen
    generic map (
      width            => 23,
      data_width       => (MEMORY_BYTE_WIDTH*(ACTUAL_MEMORY_BYTE_WIDTH+ACTUAL_PARITY_BYTE_WIDTH))
      )
    port map (
      clock            => clk,
      sync_reset       => prbs_reset,
      enable           => prbs_test_enable,
      load             => '0',
      prbs_context_in  => null_prbs,
      prbs_context_out => open,
      data             => prbs_data
      );

  prbs_test_enable <= '1' when test_mode_d1 = 6 and bist_fsm = write_data and scmd_accept = '1' else '0';

  random_chk_pattern : wide_prbs_gen
    generic map (
      width            => 23,
      data_width       => (MEMORY_BYTE_WIDTH*(ACTUAL_MEMORY_BYTE_WIDTH+ACTUAL_PARITY_BYTE_WIDTH))
      )
    port map (
      clock            => clk,
      sync_reset       => prbs_reset,
      enable           => prbs_chk_enable,
      load             => '0',
      prbs_context_in  => null_prbs,
      prbs_context_out => open,
      data             => prbs_data_chk
      );

  prbs_chk_enable <= '1' when test_mode_d2 = 6 and sresp = VALID_RESP else '0';

-- Test Data Patterns
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        data_reset     <= "11";
      else
        if bist_reset = '1' then
          data_reset   <= "11";
        else
          data_reset   <= "00";
          if bist_fsm = CHANGE_MODE then
            data_reset <= "11";
          else
            data_reset <= "00";
          end if;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      -- (32-bit) Data alternates between all 5's and all A's
      -- (32-bit) Data alternates between all 0's and all F's
      for i in 0 to ((BURST_WIDTH/2)-1) loop
        for j in 0 to ACTUAL_BYTE_WIDTH-1 loop
          fives_as_data((((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+7)) downto (((i*8)*(2*ACTUAL_BYTE_WIDTH))+(j*8)))                                               <= TEMP_FIVES(7 downto 0);
          fives_as_data((((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+(ACTUAL_BYTE_WIDTH*8)+7)) downto (((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+(ACTUAL_BYTE_WIDTH*8)))) <= TEMP_AS(7 downto 0);
          zeros_fs_data((((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+7)) downto (((i*8)*(2*ACTUAL_BYTE_WIDTH))+(j*8)))                                               <= TEMP_ZEROS(7 downto 0);
          zeros_fs_data((((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+(ACTUAL_BYTE_WIDTH*8)+7)) downto (((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+(ACTUAL_BYTE_WIDTH*8)))) <= TEMP_FS(7 downto 0);
        end loop;
      end loop;
      if data_reset(0) = '1' then
        for i in 0 to (BURST_WIDTH-1) loop
          for j in 0 to ACTUAL_BYTE_WIDTH-1 loop
            seq_data((((i*8)*ACTUAL_BYTE_WIDTH)+((j*8)+7)) downto (((i*8)*ACTUAL_BYTE_WIDTH)+(j*8)))                                                          <= conv_std_logic_vector(i, 8);
          end loop;
        end loop;
        for i in 0 to (BURST_WIDTH-1) loop
          rolling_one_data(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                              <= (others => '0');
          rolling_one_data((i*(ACTUAL_BYTE_WIDTH*8))+i)                                                                                                       <= '1';
          rolling_zero_data(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                             <= (others => '1');
          rolling_zero_data((i*(ACTUAL_BYTE_WIDTH*8))+i)                                                                                                      <= '0';
        end loop;
      else
        if bist_fsm = WRITE_DATA and scmd_accept = '1' then
          -- Sequential Data
          -- Increment each byte separately
          -- Each sample written to memory will increment from the one before.
          for i in 0 to (BURST_WIDTH-1) loop
            for j in 0 to (ACTUAL_BYTE_WIDTH-1) loop
              seq_data((((i*8)*ACTUAL_BYTE_WIDTH)+((j*8)+7)) downto (((i*8)*ACTUAL_BYTE_WIDTH)+(j*8)))                                                        <= seq_data((((i*8)*ACTUAL_BYTE_WIDTH)+((j*8)+7)) downto (((i*8)*ACTUAL_BYTE_WIDTH)+(j*8)))+BURST_WIDTH;
            end loop;
          end loop;
          -- Rolling One Data
          -- Each word written to memory has a different start point
          -- Each word written will shift by the burst count
          -- This ensures that the '1' rolls to the next bit (for each word written to memory)
          for i in 0 to (BURST_WIDTH-1) loop
            rolling_one_data(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto ((i*(ACTUAL_BYTE_WIDTH*8))+BURST_WIDTH))                              <= rolling_one_data((((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-BURST_WIDTH)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)));
            rolling_one_data((((i*(ACTUAL_BYTE_WIDTH*8))+BURST_WIDTH)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                    <= rolling_one_data(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-BURST_WIDTH));
          end loop;
          -- Rolling Zero Data
          -- Similar to Rolling One Data (with data inversed)
          for i in 0 to (BURST_WIDTH-1) loop
            rolling_zero_data(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto ((i*(ACTUAL_BYTE_WIDTH*8))+BURST_WIDTH))                             <= rolling_zero_data((((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-BURST_WIDTH)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)));
            rolling_zero_data((((i*(ACTUAL_BYTE_WIDTH*8))+BURST_WIDTH)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                   <= rolling_zero_data(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-BURST_WIDTH));
          end loop;
        end if;
      end if;
    end if;
  end process;
  random_data                                                                                                                                                 <= prbs_data;

  temp_prbs00 <= prbs_data(26 downto 0);
  temp_prbs10 <= prbs_data(53 downto 27);
  temp_prbs20 <= prbs_data(71 downto 54);
  temp_prbs01 <= prbs_data(98 downto 72);
  temp_prbs11 <= prbs_data(125 downto 99);
  temp_prbs21 <= prbs_data(143 downto 126);
  temp_prbs02 <= prbs_data(170 downto 144);
  temp_prbs12 <= prbs_data(197 downto 171);
  temp_prbs22 <= prbs_data(215 downto 198);
  temp_prbs03 <= prbs_data(242 downto 216);
  temp_prbs13 <= prbs_data(269 downto 243);
  temp_prbs23 <= prbs_data(287 downto 270);
  temp_prbs04 <= prbs_data(314 downto 288);
  temp_prbs14 <= prbs_data(341 downto 315);
  temp_prbs24 <= prbs_data(359 downto 342);
  temp_prbs05 <= prbs_data(386 downto 360);
  temp_prbs15 <= prbs_data(413 downto 387);
  temp_prbs25 <= prbs_data(431 downto 414);
  temp_prbs06 <= prbs_data(458 downto 432);
  temp_prbs16 <= prbs_data(485 downto 459);
  temp_prbs26 <= prbs_data(503 downto 486);
  temp_prbs07 <= prbs_data(530 downto 504);
  temp_prbs17 <= prbs_data(557 downto 531);
  temp_prbs27 <= prbs_data(575 downto 558);

-- Verification Data Patterns
  process (clk)
  begin
    if rising_edge(clk) then
      -- All 5's, all A's
      -- All 0's. all F's
      -- See Test Data Pattern for further information
      for i in 0 to ((BURST_WIDTH/2)-1) loop
        for j in 0 to ACTUAL_BYTE_WIDTH-1 loop
          fives_as_data_chk((((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+7)) downto (((i*8)*(2*ACTUAL_BYTE_WIDTH))+(j*8)))                                               <= TEMP_FIVES(7 downto 0);
          fives_as_data_chk((((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+(ACTUAL_BYTE_WIDTH*8)+7)) downto (((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+(ACTUAL_BYTE_WIDTH*8)))) <= TEMP_AS(7 downto 0);
          zeros_fs_data_chk((((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+7)) downto (((i*8)*(2*ACTUAL_BYTE_WIDTH))+(j*8)))                                               <= TEMP_ZEROS(7 downto 0);
          zeros_fs_data_chk((((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+(ACTUAL_BYTE_WIDTH*8)+7)) downto (((i*8)*(2*ACTUAL_BYTE_WIDTH))+((j*8)+(ACTUAL_BYTE_WIDTH*8)))) <= TEMP_FS(7 downto 0);
        end loop;
      end loop;
      -- Pseudo Random Data
      -- See Test Data Pattern for further information
      random_data_chk                                                                                                                                             <= prbs_data_chk;
      if data_reset(1) = '1' then
        for i in 0 to (BURST_WIDTH-1) loop
          for j in 0 to (ACTUAL_BYTE_WIDTH-1) loop
            seq_data_chk((((i*8)*ACTUAL_BYTE_WIDTH)+((j*8)+7)) downto (((i*8)*ACTUAL_BYTE_WIDTH)+(j*8)))                                                          <= conv_std_logic_vector(i, 8);
          end loop;
        end loop;
        for i in 0 to (BURST_WIDTH-1) loop
          rolling_one_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                              <= (others => '0');
          rolling_one_data_chk((i*(ACTUAL_BYTE_WIDTH*8))+i)                                                                                                       <= '1';
          rolling_zero_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                             <= (others => '1');
          rolling_zero_data_chk((i*(ACTUAL_BYTE_WIDTH*8))+i)                                                                                                      <= '0';
        end loop;
      else
        if sresp_d1 = VALID_RESP then
          -- Sequential Data
          -- See Test Data Pattern for further information
          for i in 0 to (BURST_WIDTH-1) loop
            for j in 0 to (ACTUAL_BYTE_WIDTH-1) loop
              seq_data_chk((((i*8)*ACTUAL_BYTE_WIDTH)+((j*8)+7)) downto (((i*8)*ACTUAL_BYTE_WIDTH)+(j*8)))                                                        <= seq_data_chk((((i*8)*ACTUAL_BYTE_WIDTH)+((j*8)+7)) downto (((i*8)*ACTUAL_BYTE_WIDTH)+(j*8)))+BURST_WIDTH;
            end loop;
          end loop;
          -- Rolling One Data
          -- See Test Data Pattern for further information
          for i in 0 to (BURST_WIDTH-1) loop
            rolling_one_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto ((i*(ACTUAL_BYTE_WIDTH*8))+BURST_WIDTH))                              <= rolling_one_data_chk((((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-BURST_WIDTH)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)));
            rolling_one_data_chk((((i*(ACTUAL_BYTE_WIDTH*8))+BURST_WIDTH)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                    <= rolling_one_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-BURST_WIDTH));
          end loop;
          -- Rolling Zero Data
          -- See Test Data Pattern for further information
          for i in 0 to (BURST_WIDTH-1) loop
            rolling_zero_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto ((i*(ACTUAL_BYTE_WIDTH*8))+BURST_WIDTH))                             <= rolling_zero_data_chk((((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-BURST_WIDTH)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)));
            rolling_zero_data_chk((((i*(ACTUAL_BYTE_WIDTH*8))+BURST_WIDTH)-1) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                   <= rolling_zero_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-1) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_BYTE_WIDTH*8)-BURST_WIDTH));
          end loop;
        end if;
      end if;
    end if;
  end process;

-- Read and write addresses
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        address_reset     <= '1';
      else
        if bist_reset = '1' then
          address_reset   <= '1';
        else
          address_reset   <= '0';
          if bist_fsm = CHANGE_MODE then
            address_reset <= '1';
          else
            address_reset <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if address_reset = '1' then
        write_addr   <= (others => '0');
        read_addr    <= (others => '0');
        read_count   <= (others => '0');
      else
        if bist_fsm = WRITE_DATA and mcmd_i = WRITE_CMD and scmd_accept = '1' then
          write_addr <= write_addr+MEMORY_BYTE_WIDTH;
        end if;
        if bist_fsm = READ_DATA and mcmd_i = READ_CMD and scmd_accept = '1' then
          read_addr  <= read_addr+MEMORY_BYTE_WIDTH;
        end if;
        if bist_fsm = READ_DATA and sresp_d2 = VALID_RESP then
          read_count <= read_count+MEMORY_BYTE_WIDTH;
        end if;
      end if;
    end if;
  end process;

  maddr <= write_addr when bist_fsm = WRITE_DATA else
           read_addr  when bist_fsm = READ_DATA  else
           (others => '0');

  mcmd_i <= WRITE_CMD when bist_fsm = WRITE_DATA                    else
            READ_CMD  when bist_fsm = READ_DATA and read_done = '0' else
            IDLE_CMD;

  mcmd <= mcmd_i when bist_enable = '1' else IDLE_CMD;

  g_write_data : for i in 0 to BURST_WIDTH-1 generate
    mdata(((i*(ACTUAL_MEMORY_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_MEMORY_BYTE_WIDTH*8)))   <= seq_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                                        when test_mode_d1 = 1 else
                                                                                                                            rolling_one_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                                when test_mode_d1 = 2 else
                                                                                                                            rolling_zero_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                               when test_mode_d1 = 3 else
                                                                                                                            fives_as_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                                   when test_mode_d1 = 4 else
                                                                                                                            zeros_fs_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                                   when test_mode_d1 = 5 else
                                                                                                                            random_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                                     when test_mode_d1 = 6 else
                                                                                                                            (others => '0');
    control(((i*(ACTUAL_PARITY_BYTE_WIDTH*8))+((ACTUAL_PARITY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_PARITY_BYTE_WIDTH*8))) <= seq_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)))          when test_mode_d1 = 1 else
                                                                                                                            rolling_one_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)))  when test_mode_d1 = 2 else
                                                                                                                            rolling_zero_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8))) when test_mode_d1 = 3 else
                                                                                                                            fives_as_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)))     when test_mode_d1 = 4 else
                                                                                                                            zeros_fs_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)))     when test_mode_d1 = 5 else
                                                                                                                            random_data(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)))       when test_mode_d1 = 6 else
                                                                                                                            (others => '0');
  end generate;

  mbyte_en <= (others => '1');

  g_check_data : for i in 0 to BURST_WIDTH-1 generate
    chk_data(((i*(ACTUAL_MEMORY_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_MEMORY_BYTE_WIDTH*8)))   <= seq_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                                        when test_mode_d2 = 1 else
                                                                                                                               rolling_one_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                                when test_mode_d2 = 2 else
                                                                                                                               rolling_zero_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                               when test_mode_d2 = 3 else
                                                                                                                               fives_as_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                                   when test_mode_d2 = 4 else
                                                                                                                               zeros_fs_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                                   when test_mode_d2 = 5 else
                                                                                                                               random_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                                     when test_mode_d2 = 6 else
                                                                                                                               (others => '0');
    chk_status(((i*(ACTUAL_PARITY_BYTE_WIDTH*8))+((ACTUAL_PARITY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_PARITY_BYTE_WIDTH*8))) <= seq_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)))          when test_mode_d2 = 1 else
                                                                                                                               rolling_one_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)))  when test_mode_d2 = 2 else
                                                                                                                               rolling_zero_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8))) when test_mode_d2 = 3 else
                                                                                                                               fives_as_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)))     when test_mode_d2 = 4 else
                                                                                                                               zeros_fs_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)))     when test_mode_d2 = 5 else
                                                                                                                               random_data_chk(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)))       when test_mode_d2 = 6 else
                                                                                                                               (others => '0');
  end generate;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        sresp_d1 <= "00";
        sresp_d2 <= "00";
        sresp_d3 <= "00";
      else
        sresp_d1 <= sresp;
        sresp_d2 <= sresp_d1;
        sresp_d3 <= sresp_d2;
      end if;

      -- Data pipeline without sync reset 
      sdata_d1      <= sdata;
      sdata_d2      <= sdata_d1;
      status_d1     <= status((PARITY_BYTE_WIDTH*8)-1 downto 0);
      status_d2     <= status_d1;
      chk_data_d1   <= chk_data;
      chk_data_d2   <= chk_data_d1;
      chk_status_d1 <= chk_status;
      chk_status_d2 <= chk_status_d1;
    end if;
  end process;

-- State Machine
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        fsm_reset   <= '1';
      else
        if bist_reset = '1' then
          fsm_reset <= '1';
        else
          fsm_reset <= '0';
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if fsm_reset = '1' then
        bist_fsm                  <= IDLE;
        test_mode                 <= 1;
        test_mode_d1              <= 1;
        test_mode_d2              <= 1;
        read_done                 <= '0';
        tests_completed_i         <= (others => '0');
        pattern_written           <= '0';
        wait_count                <= (others => '0');
      else
        test_mode_d1              <= test_mode;
        test_mode_d2              <= test_mode_d1;
        if write_stop = '0' then
          pattern_written         <= '0';
        end if;
        if bist_enable = '1' then
          case bist_fsm is
            when IDLE                        =>
              bist_fsm            <= WAIT_FOR_CALIBRATE;
            when WAIT_FOR_CALIBRATE          =>
              if calibration_complete = '1' then
                bist_fsm          <= CHECK_MODE;
              end if;
            when CHECK_MODE                  =>
              case test_mode is
                when 1                       =>
                  if pattern_select(0) = '1' then
                    if write_stop = '1' and pattern_written = '1' then
                      bist_fsm    <= READ_DATA;
                      read_done   <= '0';
                    else
                      bist_fsm    <= WRITE_DATA;
                    end if;
                  else
                    bist_fsm      <= CHANGE_MODE;
                  end if;
                when 2                       =>
                  if pattern_select(1) = '1' then
                    if write_stop = '1' and pattern_written = '1' then
                      bist_fsm    <= READ_DATA;
                      read_done   <= '0';
                    else
                      bist_fsm    <= WRITE_DATA;
                    end if;
                  else
                    bist_fsm      <= CHANGE_MODE;
                  end if;
                when 3                       =>
                  if pattern_select(2) = '1' then
                    if write_stop = '1' and pattern_written = '1' then
                      bist_fsm    <= READ_DATA;
                      read_done   <= '0';
                    else
                      bist_fsm    <= WRITE_DATA;
                    end if;
                  else
                    bist_fsm      <= CHANGE_MODE;
                  end if;
                when 4                       =>
                  if pattern_select(3) = '1' then
                    if write_stop = '1' and pattern_written = '1' then
                      bist_fsm    <= READ_DATA;
                      read_done   <= '0';
                    else
                      bist_fsm    <= WRITE_DATA;
                    end if;
                  else
                    bist_fsm      <= CHANGE_MODE;
                  end if;
                when 5                       =>
                  if pattern_select(4) = '1' then
                    if write_stop = '1' and pattern_written = '1' then
                      bist_fsm    <= READ_DATA;
                      read_done   <= '0';
                    else
                      bist_fsm    <= WRITE_DATA;
                    end if;
                  else
                    bist_fsm      <= CHANGE_MODE;
                  end if;
                when 6                       =>
                  if pattern_select(5) = '1' then
                    if write_stop = '1' and pattern_written = '1' then
                      bist_fsm    <= READ_DATA;
                      read_done   <= '0';
                    else
                      bist_fsm    <= WRITE_DATA;
                    end if;
                  else
                    bist_fsm      <= CHANGE_MODE;
                  end if;
                when others                  =>
                  null;
              end case;
            when WAIT_WRITE                  =>
              wait_count          <= wait_count+1;
              if wait_count(15) = '1' then
                bist_fsm          <= WRITE_DATA;
              end if;
            when WRITE_DATA                  =>
              if write_addr = end_address and mcmd_i = WRITE_CMD and scmd_accept = '1' then
                bist_fsm          <= READ_DATA;
                wait_count        <= (others => '0');
                read_done         <= '0';
                if write_stop = '1' then
                  pattern_written <= '1';
                end if;
              end if;
            when WAIT_READ                   =>
              wait_count          <= wait_count+1;
              if wait_count(15) = '1' then
                bist_fsm          <= READ_DATA;
              end if;
            when READ_DATA                   =>
              if read_addr = end_address and mcmd_i = READ_CMD and scmd_accept = '1' then
                read_done         <= '1';
              end if;
              if read_done = '1' and read_count > end_address then
                bist_fsm          <= CHANGE_MODE;
              end if;
            when CHANGE_MODE                 =>
              if test_mode = 6 then
                test_mode         <= 1;
                tests_completed_i <= tests_completed_i+1;
              else
                test_mode         <= test_mode+1;
              end if;
              bist_fsm            <= CHECK_MODE;
            when others                      =>
              bist_fsm            <= IDLE;
          end case;
        end if;
      end if;
    end if;
  end process;

-- Validate Data
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        test_reset   <= '1';
      else
        if bist_reset = '1' then
          test_reset <= '1';
        else
          test_reset <= '0';
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if test_reset = '1' then
        test_running_i                 <= '0';
        test_fail_i                    <= '0';
        data_error_i                   <= (others => '0');
        status_error_i                 <= (others => '0');
        error_data_bits_i              <= (others => '0');
        error_parity_bits_i            <= (others => '0');
        error_count_i                  <= (others => '0');
        error_temp                     <= '0';
      else
        if bist_enable = '0' then
          test_running_i               <= '0';
        elsif bist_fsm = check_mode then
          test_running_i               <= '1';
        end if;
        if test_running_i = '1' then
          if (data_error_i /= ZERO_ERRORS) or (status_error_i /= ZERO_ERRORS) then
            test_fail_i                <= '1';
            error_temp                 <= '1';
          else
            error_temp                 <= '0';
          end if;
          if sresp_d2 = VALID_RESP then
            for i in 0 to BURST_WIDTH-1 loop
              if sdata_d2(((i*(ACTUAL_MEMORY_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)-1) downto (i*(ACTUAL_MEMORY_BYTE_WIDTH*8))) /= chk_data_d1(((i*(ACTUAL_MEMORY_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)-1) downto (i*(ACTUAL_MEMORY_BYTE_WIDTH*8))) then
                data_error_i(i)        <= '1';
              else
                data_error_i(i)        <= '0';
              end if;
              if status_d2(((i*(ACTUAL_PARITY_BYTE_WIDTH*8))+(ACTUAL_PARITY_BYTE_WIDTH*8)-1) downto (i*(ACTUAL_PARITY_BYTE_WIDTH*8))) /= chk_status_d1(((i*(ACTUAL_PARITY_BYTE_WIDTH*8))+(ACTUAL_PARITY_BYTE_WIDTH*8)-1) downto (i*(ACTUAL_PARITY_BYTE_WIDTH*8))) then
                status_error_i(i)      <= '1';
              else
                status_error_i(i)      <= '0';
              end if;
            end loop;
            if (data_error_i /= ZERO_ERRORS) or (status_error_i /= ZERO_ERRORS) then
              if error_count_i /= MAX_ERRORS then
                error_count_i          <= error_count_i+1;
              end if;
            end if;
            for i in 0 to (MEMORY_BYTE_WIDTH*8)-1 loop
              if sdata_d2(i) /= chk_data_d1(i) then
                error_data_bits_i(i)   <= '1';
              end if;
            end loop;
            for i in 0 to (PARITY_BYTE_WIDTH*8)-1 loop
              if status_d2(i) /= chk_status_d1(i) then
                error_parity_bits_i(i) <= '1';
              end if;
            end loop;
          end if;
        end if;
      end if;
    end if;
  end process;

  test_running <= test_running_i;
  test_fail    <= test_fail_i;

  process (clk)
    variable tmp_data_error_v   : std_logic_vector((ACTUAL_MEMORY_BYTE_WIDTH*8)-1 downto 0);
    variable tmp_parity_error_v : std_logic_vector((ACTUAL_PARITY_BYTE_WIDTH*8)-1 downto 0);
  begin
    if rising_edge(clk) then
      if reset = '1' then
        error_bits_i       <= (others   => '0');
        error_extra_bits_i <= (others   => '0');
        tmp_data_error_v     := (others => '0');
        tmp_parity_error_v   := (others => '0');
      else
        tmp_data_error_v     := (others => '0');
        tmp_parity_error_v   := (others => '0');
        for i in 0 to BURST_WIDTH-1 loop
          tmp_data_error_v   := tmp_data_error_v or error_data_bits_i(((i*(ACTUAL_MEMORY_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8)-1) downto (i*(ACTUAL_MEMORY_BYTE_WIDTH*8)));
          tmp_parity_error_v := tmp_parity_error_v or error_parity_bits_i(((i*(ACTUAL_PARITY_BYTE_WIDTH*8))+(ACTUAL_PARITY_BYTE_WIDTH*8)-1) downto (i*(ACTUAL_PARITY_BYTE_WIDTH*8)));
        end loop;
        error_bits_i       <= tmp_data_error_v;
        error_extra_bits_i <= tmp_parity_error_v;
      end if;
    end if;
  end process;
  error_bits               <= error_bits_i;
  error_parity_bits        <= error_extra_bits_i;

  error_count     <= error_count_i;
  tests_completed <= tests_completed_i;

-- Keep track of outstanding reads and indicate when pipe is clean.
  process (clk)
    variable read_outstanding_v : integer range 0 to 32768;
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_outstanding_v     := 0;
        pipe_clean   <= '1';
      else
        if mcmd_i = READ_CMD and scmd_accept = '1' then
          if sresp /= VALID_RESP then
            read_outstanding_v := read_outstanding_v+1;
          end if;
        elsif sresp_d1 = VALID_RESP then
          read_outstanding_v   := read_outstanding_v-1;
        end if;
        if read_outstanding_v = 0 then
          pipe_clean <= '1';
        else
          pipe_clean <= '0';
        end if;
      end if;
    end if;
  end process;

-- Memory Data
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        memory_reset   <= "11";
      else
        if bist_reset = '1' then
          memory_reset <= "11";
        elsif bist_fsm = CHANGE_MODE then
          memory_reset <= "01";
        else
          memory_reset <= "00";
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if memory_reset(0) = '1' then
        for i in 0 to BURST_WIDTH-1 loop
          address_mem_data_tmp(((i*32)+31) downto (i*32))                                                                                                                                <= conv_std_logic_vector(i, 32);
        end loop;
      else
        if sresp_d2 = VALID_RESP then
          for i in 0 to BURST_WIDTH-1 loop
            address_mem_data_tmp(((i*32)+31) downto (i*32))                                                                                                                              <= address_mem_data_tmp(((i*32)+31) downto (i*32))+BURST_WIDTH;
          end loop;
        end if;
      end if;
      address_mem_data_i                                                                                                                                                                 <= address_mem_data_tmp;
      --for i in 0 to (BURST_WIDTH-1) loop
      --      for j in 0 to (ACTUAL_MEMORY_BYTE_WIDTH-1) loop   
      --            expected_mem_data_i(((i*(ACTUAL_MEMORY_BYTE_WIDTH*9))+(j*9)+8) downto ((i*(ACTUAL_MEMORY_BYTE_WIDTH*9))+(j*9))) <= (chk_status_d1(j+(i*(ACTUAL_MEMORY_BYTE_WIDTH*8)))) & (chk_data_d1((((j*8)+(i*(ACTUAL_MEMORY_BYTE_WIDTH*8)))+7) downto ((j*8)+(i*(ACTUAL_MEMORY_BYTE_WIDTH*8)))));
      --            received_mem_data_i(((i*(ACTUAL_MEMORY_BYTE_WIDTH*9))+(j*9)+8) downto ((i*(ACTUAL_MEMORY_BYTE_WIDTH*9))+(j*9))) <= status_d2(j+(i*(ACTUAL_MEMORY_BYTE_WIDTH*8))) & sdata_d2((((j*8)+(i*(ACTUAL_MEMORY_BYTE_WIDTH*8)))+7) downto ((j*8)+(i*(ACTUAL_MEMORY_BYTE_WIDTH*8))));
      --      end loop;
      --end loop;
      for i in 0 to BURST_WIDTH-1 loop
        expected_mem_data_i(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                               <= chk_data_d1(((i*(ACTUAL_MEMORY_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_MEMORY_BYTE_WIDTH*8)));
        expected_mem_data_i(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8))) <= chk_status_d1(((i*(ACTUAL_PARITY_BYTE_WIDTH*8))+((ACTUAL_PARITY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_PARITY_BYTE_WIDTH*8)));
        received_mem_data_i(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_BYTE_WIDTH*8)))                                                               <= sdata_d2(((i*(ACTUAL_MEMORY_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_MEMORY_BYTE_WIDTH*8)));
        received_mem_data_i(((i*(ACTUAL_BYTE_WIDTH*8))+((ACTUAL_MEMORY_BYTE_WIDTH*8)+((ACTUAL_PARITY_BYTE_WIDTH*8)-1))) downto ((i*(ACTUAL_BYTE_WIDTH*8))+(ACTUAL_MEMORY_BYTE_WIDTH*8))) <= status_d2(((i*(ACTUAL_PARITY_BYTE_WIDTH*8))+((ACTUAL_PARITY_BYTE_WIDTH*8)-1)) downto (i*(ACTUAL_PARITY_BYTE_WIDTH*8)));
      end loop;
      --expected_mem_data_fixed_i <= chk_status_d1(63 downto 56) & chk_data_d1(511 downto 448) &
      --                             chk_status_d1(55 downto 48) & chk_data_d1(447 downto 384) &
      --                             chk_status_d1(47 downto 40) & chk_data_d1(383 downto 320) &
      --                             chk_status_d1(39 downto 32) & chk_data_d1(319 downto 256) &
      --                             chk_status_d1(31 downto 24) & chk_data_d1(255 downto 192) &
      --                             chk_status_d1(23 downto 16) & chk_data_d1(191 downto 128) &
      --                             chk_status_d1(15 downto 8) & chk_data_d1(127 downto 64) &
      --                             chk_status_d1(7 downto 0) & chk_data_d1(63 downto 0);
      --received_mem_data_fixed_i <= status_d2(63 downto 56) & sdata_d2(511 downto 448) &
      --                             status_d2(55 downto 48) & sdata_d2(447 downto 384) &
      --                             status_d2(47 downto 40) & sdata_d2(383 downto 320) &
      --                             status_d2(39 downto 32) & sdata_d2(319 downto 256) &
      --                             status_d2(31 downto 24) & sdata_d2(255 downto 192) &
      --                             status_d2(23 downto 16) & sdata_d2(191 downto 128) &
      --                             status_d2(15 downto 8) & sdata_d2(127 downto 64) &
      --                             status_d2(7 downto 0) & sdata_d2(63 downto 0);  
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if memory_reset(1) = '1' then
        address_mem_addr_i            <= (others => '0');
        expected_mem_addr_i           <= (others => '0');
        received_mem_addr_i           <= (others => '0');
        words_stored_i                <= (others => '0');
        words_stored                  <= (others => '0');
      else
        case BURST_WIDTH is
          when 1                                 =>
            words_stored(11 downto 1) <= words_stored_i;
          when 2                                 =>
            words_stored(12 downto 2) <= words_stored_i;
          when 4                                 =>
            words_stored(13 downto 3) <= words_stored_i;
          when 8                                 =>
            words_stored(14 downto 4) <= words_stored_i;
          when others                            =>
            words_stored(10 downto 0) <= words_stored_i;
        end case;
        if ((data_error_i /= ZERO_ERRORS) or (status_error_i /= ZERO_ERRORS)) and sresp_d3 = VALID_RESP then
          address_mem_addr_i          <= address_mem_addr_i+1;
          expected_mem_addr_i         <= expected_mem_addr_i+1;
          received_mem_addr_i         <= received_mem_addr_i+1;
          if words_stored_i < MAX_WORDS_STORED then
            words_stored_i            <= words_stored_i+1;
          end if;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        address_mem_data        <= (others => '0');
        expected_mem_data       <= (others => '0');
        expected_mem_data_fixed <= (others => '0');
        received_mem_data       <= (others => '0');
        received_mem_data_fixed <= (others => '0');
        address_mem_addr        <= (others => '0');
        expected_mem_addr       <= (others => '0');
        received_mem_addr       <= (others => '0');
        address_mem_wr          <= '0';
        expected_mem_wr         <= '0';
        received_mem_wr         <= '0';
      else
        address_mem_data        <= address_mem_data_i;
        expected_mem_data       <= expected_mem_data_i;
        expected_mem_data_fixed <= expected_mem_data_i;
        received_mem_data       <= received_mem_data_i;
        received_mem_data_fixed <= received_mem_data_i;
        address_mem_addr        <= address_mem_addr_i;
        expected_mem_addr       <= expected_mem_addr_i;
        received_mem_addr       <= received_mem_addr_i;
        if ((data_error_i /= ZERO_ERRORS) or (status_error_i /= ZERO_ERRORS)) and sresp_d3 = VALID_RESP and words_stored_i /= MAX_WORDS_STORED then
          address_mem_wr        <= '1';
          expected_mem_wr       <= '1';
          received_mem_wr       <= '1';
        else
          address_mem_wr        <= '0';
          expected_mem_wr       <= '0';
          received_mem_wr       <= '0';
        end if;
      end if;
    end if;
  end process;

--process (error_data_bits_i, error_parity_bits_i)
--begin
-- for i in 0 to ACTUAL_MEMORY_BYTE_WIDTH-1 loop
-- error_byte(i) <= (((error_bits_i(i*8) or error_bits_i((i*8)+1)) or (error_bits_i((i*8)+2) or error_bits_i((i*8)+3))) or ((error_bits_i((i*8)+4) or error_bits_i((i*8)+5)) or (error_bits_i((i*8)+6) or error_bits_i((i*8)+7))));
-- end loop;
-- error_byte(8) <= (((error_extra_bits_i(0) or error_extra_bits_i(1)) or (error_extra_bits_i(2) or error_extra_bits_i(3))) or ((error_extra_bits_i(4) or error_extra_bits_i(5)) or (error_extra_bits_i(6) or error_extra_bits_i(7))));
--end process;

end rtl;
