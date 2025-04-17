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
-- Title       : Memory Peek Poke
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : Memory Peek Poke component.
--
--               Includes:
--                 * AvMM Master interface to Memory
--                 * AvMM Slave interface (32-bit) from Host 
--
--               This component interfaces to Memory via an AvMM interface that
--               has a data width of 640 bits (80 bytes). By connecting up the
--               relavant bits to the Memory's writedata, byteenable and
--               readdata ports, different configurations of SDRAM Memory can be
--               easily accommodated (e.g. 80-bits, 72-bits or 40-bits wide with
--               a burst of 8).
--
--               Write (poke)
--               ------------
--               This is performed by:
--               1/  Flush all buffers
--               2/  Select write mode
--               3/  Load data into the Send Buffer in the following order
--                   (repeat for every address to be written up to a maximum of 512):
--
--                     writedata[31:00]
--                     writedata[63:32]
--                     writedata[95:64]
--                     writedata[127:96]
--                     writedata[159:128]
--                     writedata[191:160]
--                     writedata[223:192]
--                     writedata[255:224]
--                     writedata[287:256]
--                     writedata[319:288]
--                     writedata[351:320]
--                     writedata[383:352]
--                     writedata[415:384]
--                     writedata[447:416]
--                     writedata[479:448]
--                     writedata[511:480]
--                     writedata[543:512]
--                     writedata[575:544]
--                     writedata[607:576]
--                     writedata[639:608]
--
--                     byteenable[31:00]
--                     byteenable[63:32]
--                     byteenable[79:64]
--
--                     address[ADDRESS_SIZE-1:00]
--
--                   Once the address is written (the 24th write), the Address
--                   Depth increments by one.
--
--               4/  Start the transfer
--
--               Read (peek)
--               -----------
--               This is performed by:
--               1/  Flush all buffers
--               2/  Select read mode
--               3/  Load the address to be read into the send buffer
--                   (repeat for every address to be read up to a maximum of 512).
--                   Once each address is written the Address Depth increments.
--               4/  Start the transfer
--                   The read data appears in the Read Buffer, the number of
--                   words received is indicated by the Read Data Depth.
--               5/  Read the data out of the read buffer (it appears in the
--                   same order as the writedata).
--
--
--               ============
--               Register Map
--               ============
--
--               Status (offset 0x00)
--               --------------------
--               [00]     SDRAM Calibration Complete
--               [01]     SDRAM Calibration Fail
--               [02]     SDRAM Core Reset Done
--
--               Control (offset 0x04)
--               ---------------------
--               [00]     Start (1 = Start Transfer, no need to write 0)
--               [01]     Flush (1 = Flush All Buffers, no need to write 0)
--               [04]     Mode  (1 = Read, 0 = Write)
--
--               Depth (offset 0x08)
--               -------------------
--               [08:00]  Address Depth   (number of addresses written into send buffer)
--               [24:16]  Read Data Depth (number of words received in read buffer)
--
--               Send Buffer (offset 0x0C)
--               -------------------------
--               [31:00]  Write port for loading data into send buffer
--
--               Read Buffer (offset 0x10)
--               -------------------------
--               [31:00]  Read port for extracting data from the read buffer
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


entity memory_peek_poke is
  generic (
    ADDRESS_OFFSET      : std_logic_vector(11 downto 0) := (others => '0');   -- Host Address offset
    ADDRESS_SIZE        : integer                       := 27                 -- Memory Address Size (Avalon) - must not be greater than 29
    );
  port (
    mem_usr_rst         : in  std_logic;
    mem_usr_clk         : in  std_logic;
    -- Memory AvMM Interface
    mem_waitrequest     : in  std_logic;
    mem_read            : out std_logic;
    mem_write           : out std_logic;
    mem_address         : out std_logic_vector(ADDRESS_SIZE-1 downto 0);
    mem_readdata        : in  std_logic_vector(639 downto 0);
    mem_writedata       : out std_logic_vector(639 downto 0);
    mem_byteenable      : out std_logic_vector(79 downto 0);
    mem_readdatavalid   : in  std_logic;
    mem_cal_success     : in  std_logic;
    mem_cal_fail        : in  std_logic;
    mem_reset_done      : in  std_logic;
    -- Host Interface
    config_clk          : in  std_logic;
    config_rstn         : in  std_logic;
    avmm_writedata      : in  std_logic_vector(31 downto 0);
    avmm_address        : in  std_logic_vector(11 downto 0);
    avmm_write          : in  std_logic;
    avmm_read           : in  std_logic;
    avmm_byteenable     : in  std_logic_vector(3 downto 0);
    dout_mem_stat       : out std_logic_vector(31 downto 0);
    dout_mem_ctrl       : out std_logic_vector(31 downto 0);
    dout_depth          : out std_logic_vector(31 downto 0);
    dout_send_buf       : out std_logic_vector(31 downto 0);
    dout_read_buf       : out std_logic_vector(31 downto 0)
    );
end entity memory_peek_poke;


architecture rtl of memory_peek_poke is
  ---------
  -- Types
  ---------
  type T_20x9_bits is array (0 to 19) of std_logic_vector(8 downto 0);

  -----------
  -- Signals
  -----------
  signal start_count          : std_logic_vector(3 downto 0)    := (others => '1');
  signal start_pulse          : std_logic                       := '0';
  signal flush_count          : std_logic_vector(3 downto 0)    := (others => '0');
  signal flush_pulse          : std_logic                       := '1';
  signal reg_mode_read        : std_logic                       := '0';
  signal host_wr_ptr          : std_logic_vector(4 downto 0)    := (others => '0');
  signal read_ctrl            : std_logic                       := '0';
  signal host_rd_ptr          : std_logic_vector(4 downto 0)    := (others => '0');
  signal cal_complete_meta    : std_logic_vector(1 downto 0)    := (others => '0');
  signal cal_fail_meta        : std_logic_vector(1 downto 0)    := (others => '0');
  signal reset_done_meta      : std_logic_vector(1 downto 0)    := (others => '0');
  signal start_pulse_meta     : std_logic_vector(2 downto 0)    := (others => '0');
  signal flush_pulse_meta     : std_logic_vector(1 downto 0)    := (others => '0');
  signal mode_read_meta       : std_logic_vector(1 downto 0)    := (others => '0');
  signal start_xfer           : std_logic                       := '0';
  signal addr_depth           : std_logic_vector(8 downto 0);
  signal addr_empty           : std_logic;
  signal rd_depth             : T_20x9_bits;
  signal read_empty           : std_logic_vector(19 downto 0);
  signal host_wr_en           : std_logic_vector(23 downto 0);
  signal mem_byte_en          : std_logic_vector(95 downto 0);
  signal mem_addr             : std_logic_vector(31 downto 0);
  signal mem_rd_en            : std_logic;
  signal rd_data              : std_logic_vector(639 downto 0);
  signal rd_en                : std_logic;


begin
  ----------------------
  -- Register Interface
  ----------------------
  process(config_clk)
  begin
    if rising_edge(config_clk) then
      if config_rstn = '0' then
        start_count    <= (others => '1');
        start_pulse    <= '0';
        flush_count    <= (others => '0');
        flush_pulse    <= '1';
        reg_mode_read  <= '0';
        host_wr_ptr    <= (others => '0');
        read_ctrl      <= '0';
        host_rd_ptr    <= (others => '0');

      else
        -- Start pulse for data transfer
        if (avmm_write = '1') and (avmm_address = ADDRESS_OFFSET + 4) and
           (avmm_byteenable(0) = '1') and (avmm_writedata(0) = '1') then
          start_count <= (others => '0');
          start_pulse <= '1';
        elsif start_count /= "1111" then
          start_count <= start_count + 1;
        else
          start_pulse <= '0';
        end if;

        -- Flush pulse for buffers
        if (avmm_write = '1') and (avmm_address = ADDRESS_OFFSET + 4) and
           (avmm_byteenable(0) = '1') and (avmm_writedata(1) = '1') then
          flush_count <= (others => '0');
          flush_pulse <= '1';
        elsif flush_count /= "1111" then
          flush_count <= flush_count + 1;
        else
          flush_pulse <= '0';
        end if;

        -- Mode (read/write) control bit
        if avmm_write = '1' then
          if (avmm_address = ADDRESS_OFFSET + 4) then
            if (avmm_byteenable(0) = '1') then
              reg_mode_read <= avmm_writedata(4);
            end if;
          end if;
        end if;

        -- Host write pointer to select write buffer
        if flush_count = 0 then
          host_wr_ptr <= (others => '0');
        elsif avmm_write = '1' then
          if (avmm_address = ADDRESS_OFFSET + 12) then
            if (avmm_byteenable = "1111") then
              if host_wr_ptr >= 23 then
                host_wr_ptr <= (others => '0');
              else
                host_wr_ptr <= host_wr_ptr + 1;
              end if;
            end if;
          end if;
        end if;

        -- Host Read
        if avmm_read = '0' then
          read_ctrl <= '0';
        else
          read_ctrl <= not read_ctrl;
        end if;

        -- Host read pointer to select read buffer
        if flush_count = 0 then
          host_rd_ptr <= (others => '0');
        elsif read_ctrl = '1' then
          if (avmm_address = ADDRESS_OFFSET + 16) then
            if host_rd_ptr >= 19 then
              host_rd_ptr <= (others => '0');
            else
              host_rd_ptr <= host_rd_ptr + 1;
            end if;
          end if;
        end if;
      end if;

      -- No sync reset applied
      cal_complete_meta <= (cal_complete_meta(0) & mem_cal_success);
      cal_fail_meta     <= (cal_fail_meta(0)     & mem_cal_fail);
      reset_done_meta   <= (reset_done_meta(0)   & mem_reset_done);

    end if;
  end process;

  ------------------
  -- Buffer Control
  ------------------
  process(mem_usr_clk)
  begin
    if rising_edge(mem_usr_clk) then
      -- Transfer to mem_usr_clk domain
      start_pulse_meta <= (start_pulse_meta(1 downto 0) & start_pulse);
      flush_pulse_meta <= (flush_pulse_meta(0) & flush_pulse);
      mode_read_meta   <= (mode_read_meta(0)   & reg_mode_read);

      -- Transfer control (initiated by start pulse)
      if (addr_empty = '1') or (flush_pulse_meta(1) = '1') then
        start_xfer <= '0';
      elsif start_pulse_meta(2 downto 1) = "01" then
        start_xfer <= '1';
      end if;

    end if;
  end process;


  -- Decode host wr_data and byte_en buffer write enables
  g0 : for i in 0 to 22 generate
    host_wr_en(i) <= avmm_write when ((avmm_address = ADDRESS_OFFSET + 12) and (host_wr_ptr = i) and (reg_mode_read = '0')) else '0';
  end generate;

  -- Decode host address buffer write enable
  host_wr_en(23) <= avmm_write when ((avmm_address = ADDRESS_OFFSET + 12) and (host_wr_ptr = 23) and (reg_mode_read = '0')) else
                    avmm_write when ((avmm_address = ADDRESS_OFFSET + 12) and (reg_mode_read = '1')) else '0';


  -- Write data buffer
  g1 : for i in 0 to 19 generate
  begin
    wr_data_buf : entity work.general_fifo
    generic map (
      DWIDTH                  => 32,
      AWIDTH                  => 9,
      ALMOST_FULL_THOLD       => 500,
      RAMTYPE                 => "block",
      FIRST_WORD_FALL_THRU    => TRUE
      )
    port map (
      write_clock             => config_clk,                              -- in  std_logic
      read_clock              => mem_usr_clk,                             -- in  std_logic
      fifo_flush              => flush_pulse_meta(1),                     -- in  std_logic
      write_enable            => host_wr_en(i),                           -- in  std_logic
      write_data              => avmm_writedata,                          -- in  std_logic_vector(DWIDTH-1 downto 0)
      read_enable             => mem_rd_en,                               -- in  std_logic
      read_data               => mem_writedata((i*32)+31 downto (i*32)),  -- out std_logic_vector(DWIDTH-1 downto 0)
      almost_full             => open,                                    -- out std_logic
      depth                   => open,                                    -- out std_logic_vector(AWIDTH-1 downto 0)
      empty                   => open                                     -- out std_logic
      );
  end generate;


  -- Write byte enable buffer
  g2 : for i in 0 to 2 generate
  begin
    byte_en_buf : entity work.general_fifo
    generic map (
      DWIDTH                  => 32,
      AWIDTH                  => 9,
      ALMOST_FULL_THOLD       => 500,
      RAMTYPE                 => "block",
      FIRST_WORD_FALL_THRU    => TRUE
      )
    port map (
      write_clock             => config_clk,                              -- in  std_logic
      read_clock              => mem_usr_clk,                             -- in  std_logic
      fifo_flush              => flush_pulse_meta(1),                     -- in  std_logic
      write_enable            => host_wr_en(i+20),                        -- in  std_logic
      write_data              => avmm_writedata,                          -- in  std_logic_vector(DWIDTH-1 downto 0)
      read_enable             => mem_rd_en,                               -- in  std_logic
      read_data               => mem_byte_en((i*32)+31 downto (i*32)),    -- out std_logic_vector(DWIDTH-1 downto 0)
      almost_full             => open,                                    -- out std_logic
      depth                   => open,                                    -- out std_logic_vector(AWIDTH-1 downto 0)
      empty                   => open                                     -- out std_logic
      );
  end generate;


  -- Address buffer
  addr_buf : entity work.general_fifo
  generic map (
    DWIDTH                    => 32,
    AWIDTH                    => 9,
    ALMOST_FULL_THOLD         => 500,
    RAMTYPE                   => "block",
    FIRST_WORD_FALL_THRU      => TRUE
    )
  port map (
    write_clock               => config_clk,                              -- in  std_logic
    read_clock                => mem_usr_clk,                             -- in  std_logic
    fifo_flush                => flush_pulse_meta(1),                     -- in  std_logic
    write_enable              => host_wr_en(23),                          -- in  std_logic
    write_data                => avmm_writedata,                          -- in  std_logic_vector(DWIDTH-1 downto 0)
    read_enable               => mem_rd_en,                               -- in  std_logic
    read_data                 => mem_addr,                                -- out std_logic_vector(DWIDTH-1 downto 0)
    almost_full               => open,                                    -- out std_logic
    depth                     => addr_depth,                              -- out std_logic_vector(AWIDTH-1 downto 0)
    empty                     => addr_empty                               -- out std_logic
    );

  mem_rd_en <= (not addr_empty) and (not mem_waitrequest) and start_xfer;


  -- Read data buffer
  g3 : for i in 0 to 19 generate
  begin
    rd_data_buf : entity work.general_fifo
    generic map (
      DWIDTH                  => 32,
      AWIDTH                  => 9,
      ALMOST_FULL_THOLD       => 500,
      RAMTYPE                 => "block",
      FIRST_WORD_FALL_THRU    => TRUE
      )
    port map (
      write_clock             => mem_usr_clk,                             -- in  std_logic
      read_clock              => config_clk,                              -- in  std_logic
      fifo_flush              => flush_pulse,                             -- in  std_logic
      write_enable            => mem_readdatavalid,                       -- in  std_logic
      write_data              => mem_readdata((i*32)+31 downto (i*32)),   -- in  std_logic_vector(DWIDTH-1 downto 0)
      read_enable             => rd_en,                                   -- in  std_logic
      read_data               => rd_data((i*32)+31 downto (i*32)),        -- out std_logic_vector(DWIDTH-1 downto 0)
      almost_full             => open,                                    -- out std_logic
      depth                   => rd_depth(i),                             -- out std_logic_vector(AWIDTH-1 downto 0)
      empty                   => open                                     -- out std_logic
      );
  end generate;

  rd_en <= '1' when (read_ctrl = '1') and (avmm_address = ADDRESS_OFFSET + 16) and (host_rd_ptr = 19) else '0';

  -------------------
  -- Connect Outputs
  -------------------
  dout_mem_stat  <= (x"0000000" & '0' & reset_done_meta(1) & cal_fail_meta(1) & cal_complete_meta(1));
  dout_mem_ctrl  <= (x"000000" & "000" & reg_mode_read & "0000");
  dout_depth     <= ("0000000" & rd_depth(19) & "0000000" & addr_depth);
  dout_send_buf  <= (others => '0');
  dout_read_buf  <= rd_data(639 downto 608) when (host_rd_ptr = 19) else
                    rd_data(607 downto 576) when (host_rd_ptr = 18) else
                    rd_data(575 downto 544) when (host_rd_ptr = 17) else
                    rd_data(543 downto 512) when (host_rd_ptr = 16) else
                    rd_data(511 downto 480) when (host_rd_ptr = 15) else
                    rd_data(479 downto 448) when (host_rd_ptr = 14) else
                    rd_data(447 downto 416) when (host_rd_ptr = 13) else
                    rd_data(415 downto 384) when (host_rd_ptr = 12) else
                    rd_data(383 downto 352) when (host_rd_ptr = 11) else
                    rd_data(351 downto 320) when (host_rd_ptr = 10) else
                    rd_data(319 downto 288) when (host_rd_ptr = 9)  else
                    rd_data(287 downto 256) when (host_rd_ptr = 8)  else
                    rd_data(255 downto 224) when (host_rd_ptr = 7)  else
                    rd_data(223 downto 192) when (host_rd_ptr = 6)  else
                    rd_data(191 downto 160) when (host_rd_ptr = 5)  else
                    rd_data(159 downto 128) when (host_rd_ptr = 4)  else
                    rd_data(127 downto 96)  when (host_rd_ptr = 3)  else
                    rd_data(95  downto 64)  when (host_rd_ptr = 2)  else
                    rd_data(63  downto 32)  when (host_rd_ptr = 1)  else
                    rd_data(31  downto 0);

  mem_read       <= start_xfer and (not addr_empty) and mode_read_meta(1);
  mem_write      <= start_xfer and (not addr_empty) and (not mode_read_meta(1));
  mem_address    <= mem_addr(ADDRESS_SIZE-1 downto 0);
  mem_byteenable <= mem_byte_en(79 downto 0);


end rtl;
