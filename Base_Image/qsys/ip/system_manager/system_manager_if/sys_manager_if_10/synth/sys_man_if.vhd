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
-- Title       : System Manager Interface
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : This component handles the interface to the System Manager.
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

use work.pkg_sys_man.all;


entity sys_man_if is
  port(
    -- clocks and resets
    clk     : in std_logic;
    rst     : in std_logic;
    pll_clk : in std_logic;

    -- configurator interface
    conf_d     : inout std_logic_vector(7 downto 0);
    conf_c_in  : in    std_logic_vector(3 downto 0);
    conf_c_out : out   std_logic_vector(3 downto 0);

    -- reconfiguration interface
    soft_reconfigure_req_n : out std_logic;

    -- avalon slave mode control interface
    c_address   : in  std_logic_vector(7 downto 0);
    c_read      : in  std_logic;
    c_write     : in  std_logic;
    c_readdata  : out std_logic_vector(31 downto 0);
    c_writedata : in  std_logic_vector(31 downto 0);

    -- avalon master mode data interface
    d_address     : out std_logic_vector(8 downto 0);
    d_read        : out std_logic;
    d_write       : out std_logic;
    d_readdata    : in  std_logic_vector(15 downto 0);
    d_writedata   : out std_logic_vector(15 downto 0);
    d_waitrequest : in  std_logic
    );
end sys_man_if;

architecture rtl of sys_man_if is

  constant NUM_STAT_REGS  : integer := 7;
  constant STAT_REG_WIDTH : integer := 32;

  signal unused_gnd : std_logic_vector(63 downto 0) := (others => '0');

  component retime
    generic (
      DEPTH :     integer;
      WIDTH :     integer);
    port (
      reset : in  std_logic;
      clock : in  std_logic;
      d     : in  std_logic_vector(WIDTH-1 downto 0);
      q     : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  component cmux
    generic (
      WIDTH :     integer;
      SELSZ :     integer);
    port (
      data  : in  std_logic_vector((WIDTH*SELSZ)-1 downto 0);
      sel   : in  std_logic_vector(SELSZ-1 downto 0);
      z     : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  -- individual write enables
  type t_control_record is
    record
      qstatus         : std_logic;
      qcontrol        : std_logic;
      qspi_start_addr : std_logic;
      ocr_start_addr  : std_logic;
      rcfg_addr       : std_logic;
      pstatus         : std_logic;
      pcontrol        : std_logic;
    end record;

  signal control_reg_en : t_control_record;

  -- individual read enables
  type t_status_record is
    record
      qstatus         : std_logic;
      qcontrol        : std_logic;
      qspi_start_addr : std_logic;
      ocr_start_addr  : std_logic;
      rcfg_addr       : std_logic;
      pstatus         : std_logic;
      pcontrol        : std_logic;
    end record;

  signal status_reg_en : t_status_record;

  type t_state is (IDLE, HDR, FRAME, WDATA, WAIT_FOR_RDATA, WAIT_RDY, POLL_BUSY, WAIT_BUSY);
  signal state : t_state;

  signal fce_data_oe : std_logic;

  -- user interface ingress
  signal fci_data  : std_logic_vector(UDATA_WIDTH-1 downto 0);
  signal fci_valid : std_logic;
  signal fci_sop   : std_logic;
  signal fci_rdy   : std_logic := '1';

  signal fci_payload : std_logic;

  -- user interface egress
  signal fce_data  : std_logic_vector(UDATA_WIDTH-1 downto 0);
  signal fce_valid : std_logic;
  signal fce_sop   : std_logic;
  signal fce_rdy   : std_logic;

  signal unsupported    : std_logic;
  signal lite_write     : std_logic;
  signal lite_read      : std_logic;
  signal count          : natural range 0 to 47;
  signal array_write    : std_logic;
  signal array_read     : std_logic;
  -- these accesses have a command and data phase only
  signal reg_write      : std_logic;
  -- this is different in that it has an command, address and data phase
  signal lock_reg_write : std_logic;

  signal addr       : std_logic_vector(26 downto 0);
  signal command    : std_logic_vector(7 downto 0);
  signal first_read : std_logic;
  signal read       : std_logic;
  signal write      : std_logic;

  signal conf_d_i  : std_logic_vector(15 downto 0);
  signal conf_d_a1 : std_logic_vector(15 downto 0);
  signal conf_d_in : std_logic_vector(15 downto 0);
  signal clk_n     : std_logic;

  signal dma_busy : std_logic;
  signal dma_done : std_logic;

  signal cmd_code    : std_logic_vector(7 downto 0);
  signal len         : std_logic_vector(8 downto 0);
  signal length      : std_logic_vector(10 downto 0);
  signal dma_start   : std_logic;
  signal clear_start : std_logic;

  -- peripheral control (i.e. for DMA to a peripheral)
  signal pread_write_n : std_logic;
  signal plen          : std_logic_vector(7 downto 0);
  signal pdma_start    : std_logic;
  signal paddress      : std_logic_vector(15 downto 0);
  signal lrequest      : std_logic;

  signal pdma_busy : std_logic;
  signal pdma_done : std_logic;

  signal qspi_start_address : std_logic_vector(27 downto 0) := (others => '0');
  signal ocr_start_address  : std_logic_vector(11 downto 0) := (others => '0');
  signal next_c_readdata    : std_logic_vector(31 downto 0);
  signal csr_read_data      : std_logic_vector(NUM_STAT_REGS*STAT_REG_WIDTH-1 downto 0);
  signal csr_read_sel       : std_logic_vector(NUM_STAT_REGS-1 downto 0);
  signal d_address_i        : std_logic_vector(8 downto 0);
  signal d_readdata_i       : std_logic_vector(15 downto 0);
  signal d_writedata_i      : std_logic_vector(15 downto 0);
  signal d_write_i          : std_logic;
  signal d_write_int        : std_logic;
  signal d_read_i           : std_logic;

  signal c_writedata_d1    : std_logic_vector(31 downto 0);
  signal soft_reconfig_req : std_logic;
  signal lgrant            : std_logic;
  signal rgrant            : std_logic_vector(1 downto 0);

  -- This signal can be driven by a simulator to tristate the conf_d bus when
  -- simulating configuration.
  signal conf_sim_tristate : std_logic := '0';
  signal dummy_tri_en      : std_logic_vector(15 downto 0);

  signal fce_data_pll_a1    : std_logic_vector(UDATA_WIDTH-1 downto 0);
  signal fce_data_oe_pll_a1 : std_logic_vector(UDATA_WIDTH-1 downto 0);
  signal fce_valid_pll_a1   : std_logic;
  signal fce_sop_pll_a1     : std_logic;
  signal fci_rdy_pll_a1     : std_logic := '1';
  signal lrequest_pll_a1    : std_logic;

  signal fce_data_pll    : std_logic_vector(UDATA_WIDTH-1 downto 0);
  signal fce_data_oe_pll : std_logic_vector(UDATA_WIDTH-1 downto 0);
  signal fce_valid_pll   : std_logic;
  signal fce_sop_pll     : std_logic;
  signal fci_rdy_pll     : std_logic := '1';
  signal lrequest_pll    : std_logic;


begin

  csr_data_cmux : cmux
    generic map (
      WIDTH => STAT_REG_WIDTH,
      SELSZ => NUM_STAT_REGS)
    port map (
      data  => csr_read_data,           -- in  
      sel   => csr_read_sel,            -- in  
      z     => next_c_readdata);        -- out

  process(clk)
    variable type_v   : std_logic_vector(3 downto 0);
    variable length_v : std_logic_vector(10 downto 0);
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        state             <= IDLE;
        control_reg_en    <= (others => '0');
        status_reg_en     <= (others => '0');
        c_writedata_d1    <= (others => '0');
        count             <= 0;
        unsupported       <= '0';
        lite_write        <= '0';
        lite_read         <= '0';
        array_write       <= '0';
        array_read        <= '0';
        reg_write         <= '0';
        lock_reg_write    <= '0';
        length            <= (others => '0');
        fce_valid         <= '0';
        fce_sop           <= '0';
        fce_data_oe       <= '0';
        first_read        <= '1';
        cmd_code          <= (others => '0');
        clear_start       <= '0';
        d_address_i       <= (others => '0');
        d_writedata_i     <= (others => '0');
        d_write           <= '0';
        d_write_i         <= '0';
        d_write_int       <= '0';
        d_read_i          <= '0';
        write             <= '0';
        read              <= '0';
        dma_busy          <= '0';
        dma_done          <= '0';
        dma_start         <= '0';
        len               <= (others => '0');
        soft_reconfig_req <= '0';
        pread_write_n     <= '1';
        plen              <= (others => '0');
        pdma_start        <= '0';
        pdma_busy         <= '0';
        pdma_done         <= '0';
        lrequest          <= '0';
        dummy_tri_en      <= (others => '0');

      else

        -- defaults
        unsupported <= '0';
        d_write_i   <= '0';
        fce_sop     <= '0';
        clear_start <= '0';

        if (c_write = '1') then
          control_reg_en                                                                                   <= (others => '0');  -- default assignment
          case c_address is
            when ADDR_QSTATUS                                            => control_reg_en.qstatus         <= '1';
            when ADDR_QCONTROL                                           => control_reg_en.qcontrol        <= '1';
            when QSPI_SADDR                                              => control_reg_en.qspi_start_addr <= '1';
            when OCR_SADDR                                               => control_reg_en.ocr_start_addr  <= '1';
            when RCFG_ADDR                                               => control_reg_en.rcfg_addr       <= '1';
            when ADDR_PSTATUS                                            => control_reg_en.pstatus         <= '1';
            when ADDR_PCONTROL                                           => control_reg_en.pcontrol        <= '1';
            when others                                                  => control_reg_en                 <= (others => '0');
          end case;
        else
          control_reg_en                                                                                   <= (others => '0');
        end if;

        if (control_reg_en.qstatus = '1') then
          if (c_writedata_d1(0) = '1') then
            dma_done <= '0';
          end if;
        end if;

        if (control_reg_en.qcontrol = '1') then
          cmd_code  <= c_writedata_d1(31 downto 24);
          len       <= c_writedata_d1(16 downto 08);
          dma_start <= c_writedata_d1(0);
        end if;

        if (clear_start = '1') then
          dma_start  <= '0';
          pdma_start <= '0';
        end if;

        if (control_reg_en.qspi_start_addr = '1') then
          qspi_start_address <= c_writedata_d1(27 downto 0);
        end if;

        if (control_reg_en.ocr_start_addr = '1') then
          ocr_start_address <= c_writedata_d1(11 downto 0);
        end if;

        if (control_reg_en.rcfg_addr = '1') then
          soft_reconfig_req <= c_writedata_d1(0);
          -- Put a "magic key" in to ensure that it is highly unlikely to be
          -- accidentally asserted
          if (c_writedata_d1(23 downto 08) = x"cafe") then
            dummy_tri_en    <= (others => c_writedata_d1(31));
          end if;
        end if;

        if (control_reg_en.pcontrol = '1') then
          paddress      <= c_writedata_d1(31 downto 16);
          plen          <= c_writedata_d1(15 downto 08);
          pread_write_n <= c_writedata_d1(1);
          pdma_start    <= c_writedata_d1(0);
        end if;

        if (control_reg_en.pstatus = '1') then
          if (c_writedata_d1(0) = '1') then
            pdma_done <= '0';
          end if;
          lrequest    <= c_writedata_d1(8);
        end if;


        status_reg_en <= (others => '0');  -- default assignment

        case c_address is
          when ADDR_QSTATUS  => status_reg_en.qstatus         <= '1';
          when ADDR_QCONTROL => status_reg_en.qcontrol        <= '1';
          when QSPI_SADDR    => status_reg_en.qspi_start_addr <= '1';
          when OCR_SADDR     => status_reg_en.ocr_start_addr  <= '1';
          when RCFG_ADDR     => status_reg_en.rcfg_addr       <= '1';
          when ADDR_PSTATUS  => status_reg_en.pstatus         <= '1';
          when ADDR_PCONTROL => status_reg_en.pcontrol        <= '1';
          when others        => status_reg_en                 <= (others => '0');
        end case;


        case state is

          when IDLE =>
            command       <= cmd_code;
            -- convert from byte address to word (16 bit) address
            addr          <= qspi_start_address(27 downto 1);
            length        <= ext( len, length'length);
            d_address_i   <= ocr_start_address(11 downto 3);
            dma_busy      <= '0';
            pdma_busy     <= '0';
            if (dma_start = '1') and (fce_rdy = '1') then
              state       <= HDR;
              clear_start <= '1';
              dma_busy    <= '1';
            end if;
            if (pdma_start = '1') and (fce_rdy = '1') then
              state       <= HDR;
              clear_start <= '1';
              pdma_busy   <= '1';
            end if;

          when HDR                                                                                                                                     =>
            array_write                        <= '0';
            array_read                         <= '0';
            reg_write                          <= '0';
            lock_reg_write                     <= '0';
            lite_write                         <= '0';
            lite_read                          <= '0';
            read                               <= '0';
            if (pdma_busy = '1') then
              if (pread_write_n = '0') then
                type_v       := MEM_WR_CR;
                length_v     := conv_std_logic_vector(1, length_v'length);
                reg_write                      <= '1';
              else
                type_v       := MEM_RD_CR;
                length_v     := conv_std_logic_vector(1, length_v'length);
                read                           <= '1';
              end if;
            else
              case command is
                when EXT_DUAL_INPUT_FAST_PROGRAM                                                                                                       =>
                  type_v     := MEM_WR_FA;
                  length_v   := length;
                  array_write                  <= '1';
                  write                        <= '1';
                when DUAL_IO_FAST_READ                                                                                                                 =>
                  type_v     := MEM_RD_FA;
                  length_v   := length;
                  array_read                   <= '1';
                  read                         <= '1';
                when WRITE_STATUS_REG | WRITE_NONV_CREG | WRITE_VOL_CREG | WRITE_EVOL_CREG | WRITE_EADDR_REG                                           =>
                  type_v     := MEM_WR_FR;
                  length_v   := length;
                  reg_write                    <= '1';
                  write                        <= '1';
                when WRITE_ENABLE | WRITE_DISABLE | CLEAR_FLAG_SREG | BULK_ERASE | RESET_ENABLE | RESET_MEMORY                                         =>
                  type_v     := MEM_WR_FR;
                  length_v   := (others                                                                                                                => '0');
                  write                        <= '1';
                when READ_ID_REG1 | READ_ID_REG2 | READ_STATUS_REG | READ_FLAG_SREG | READ_NONV_CREG | READ_VOL_CREG | READ_EVOL_CREG | READ_EADDR_REG =>
                  type_v     := MEM_RD_FR;
                  length_v   := length;
                  read                         <= '1';
                  -- these erase commands need an address hence distinct from bulk
                  -- erase
                when SUBSECTOR_ERASE | SUBSECTOR_ERASE_32KB | SECTOR_ERASE | DIE_ERASE                                                                 =>
                  type_v     := MEM_ERAS_FA;
                  length_v   := (others                                                                                                                => '0');
                when WRITE_LOCK_REG                                                                                                                    =>
                  type_v     := MEM_WR_LR;
                  length_v   := length;
                  lock_reg_write               <= '1';
                  write                        <= '1';
                when READ_LOCK_REG                                                                                                                     =>
                  type_v     := MEM_RD_LR;
                  length_v   := length;
                  read                         <= '1';
                when LITE                                                                                                                              =>
                  -- to be completed
                  if (write = '1') then
                    command                    <= WRITE_ENABLE;
                    type_v   := MEM_WR_FR;
                    length_v := length;
                    lite_write                 <= '1';
                  else
                    type_v   := MEM_RD_FA;
                    length_v := length;
                    command                    <= DUAL_IO_FAST_READ;
                    read                       <= '1';
                  end if;
                when others                                                                                                                            =>
                  unsupported                  <= '1';
                  null;
              end case;
            end if;
            state                              <= FRAME;
            fce_data_oe                        <= '1';
            fce_sop                            <= '1';
            fce_valid                          <= '1';
            count                              <= 1;
            length                             <= length_v;
            fce_data                           <= (others                                                                                              => '0');
            fce_data(7 downto 4)               <= length_v(8 downto 5);
            fce_data(TYPE_MSB downto TYPE_LSB) <= type_v;


          when FRAME =>
            count                    <= count + 1;
            case count is
              when 1 =>
                fce_data(7 downto 5) <= addr(26 downto 24);
                fce_data(4 downto 0) <= length(4 downto 0);

              when 2 =>
                fce_data <= command;

              when 3 =>
                fce_data <= addr(23 downto 16);

-- fce_data(HI_ADDR_MSB downto HI_ADDR_LSB) <= addr(23 downto 16);
-- fce_data(CMD_MSB downto CMD_LSB) <= command;

              when 4 =>
                if (pdma_busy = '1') then
                  fce_data <= paddress(15 downto 08);
                else
                  fce_data <= addr(15 downto 08);
                end if;

              when 5 =>
                if (pdma_busy = '1') then
                  fce_data   <= paddress(07 downto 00);
                else
                  fce_data   <= addr(07 downto 00);
                end if;
                if (write = '1') then
                  d_read_i   <= '1';
                end if;
                if (read = '1') then
                  state      <= WAIT_FOR_RDATA;
                  count      <= 0;
                  first_read <= '1';
                elsif (reg_write = '1') then
                  state      <= WDATA;
                  count      <= 0;
                elsif (array_write = '0') and (lite_write = '0') and (lock_reg_write = '0') then
                  -- no data associated with this as it is not a read or a reg or
                  -- array write
                  state      <= WAIT_RDY;
                end if;

              when 30 =>
                if (lock_reg_write = '0') then
                  -- dummy cycles required for array writes
                  state <= WDATA;
                  count <= 0;
                end if;

              when 34 =>
                -- dummy cycles required for lock register writes
                state <= WDATA;
                count <= 0;

              when others =>
                null;

            end case;


          when WDATA                            =>
            fce_data                 <= (others => '0');
            fce_valid                <= '1';
            count                    <= count + 1;
            case count is
              -- When sending payload data we only use the least sig 4 bits to
              -- match the two bits per QSPI in dual mode.
              when 0                            =>
                fce_data(3 downto 0) <= d_readdata_i(15 downto 12);
              when 1                            =>
                fce_data(3 downto 0) <= d_readdata_i(11 downto 08);
                if (length = 1) and (lite_write = '1') then
                  -- If lite write need to perform polling step before releasing bus
                else
                  -- pipeline address increment
                  d_address_i        <= d_address_i + '1';
                end if;
              when 2                            =>
                fce_data(3 downto 0) <= d_readdata_i(07 downto 04);
              when 3                            =>
                fce_data(3 downto 0) <= d_readdata_i(03 downto 00);
                count                <= 0;
                length               <= length - 1;
                if (length = 1) then
                  d_read_i           <= '0';
                  state              <= WAIT_RDY;
                end if;
              when others                       =>
                null;
            end case;


          when WAIT_RDY                                       =>
            fce_valid                              <= '0';
            fce_data_oe                            <= '0';
            if (fce_rdy = '1') then
              if (lite_write = '1') then
                state                              <= POLL_BUSY;
                type_v := MEM_POLL_FR;
                command                            <= READ_STATUS_REG;
                count                              <= 1;
                fce_data_oe                        <= '1';
                fce_sop                            <= '1';
                fce_valid                          <= '1';
                fce_data                           <= (others => '0');
                fce_data(TYPE_MSB downto TYPE_LSB) <= type_v;
              else
                state                              <= IDLE;
                if (pdma_busy = '1') then
                  pdma_done                        <= '1';
                else
                  dma_done                         <= '1';
                end if;
              end if;
            end if;

          when POLL_BUSY                                    =>
            fce_valid                            <= '1';
            count                                <= count + 1;
            case count is
              when 1                                        =>
                fce_data                         <= (others => '0');
                fce_data(CMD_MSB downto CMD_LSB) <= command;
              when 2                                        =>
                state                            <= WAIT_BUSY;
                fce_data                         <= (others => '0');
              when others                                   =>
                null;
            end case;


          when WAIT_BUSY =>
            fce_data_oe  <= '0';
            fce_valid    <= '0';
            -- when receive a response busy has changed state
            if (fci_sop = '1' and fci_valid = '1') then
              state      <= WAIT_RDY;
              lite_write <= '0';
            end if;

          when WAIT_FOR_RDATA =>
            fce_valid                         <= '0';
            fce_data_oe                       <= '0';
            if (d_write_int = '1') then
              d_address_i                     <= d_address_i + '1';
            end if;
            if (fci_payload = '1') then
              count                           <= count + 1;
              case count is
                when 0        =>
                  d_writedata_i(15 downto 12) <= fci_data(3 downto 0);
                when 1        =>
                  d_writedata_i(11 downto 08) <= fci_data(3 downto 0);
                when 2        =>
                  d_writedata_i(07 downto 04) <= fci_data(3 downto 0);
                when 3        =>
                  first_read                  <= '0';
                  d_write_i                   <= '1';
                  d_writedata_i(03 downto 00) <= fci_data(3 downto 0);
                  count                       <= 0;
                  length                      <= length - 1;
                  if (length = 1) then
                    state                     <= WAIT_RDY;
                  end if;
                when others   =>
                  null;
              end case;
            end if;


          when others =>
            null;

        end case;

        c_readdata <= next_c_readdata;

        -- This logic swaps bits so that data that has been represented in QSPI
        -- array in quad fashion or that suitable for reading as quad is
        -- converted to dual format. This conversion does not apply for QSPI
        -- register reads as these are serial.

        if (array_read = '1') then
          d_writedata(15 downto 08) <= conv_quad_to_dual(d_writedata_i(15 downto 08));
          d_writedata(07 downto 00) <= conv_quad_to_dual(d_writedata_i(07 downto 00));
        else
          d_writedata(15 downto 08) <= d_writedata_i(15 downto 08);
          d_writedata(07 downto 00) <= d_writedata_i(07 downto 00);
        end if;

        -- Write strobe is delayed to match pipeline delay.
        d_write     <= d_write_i;
        -- internal copy 
        d_write_int <= d_write_i;

        -- delay write data to match control reg strobe timing
        c_writedata_d1 <= c_writedata;

        -- This logic performs the inverse for dual to quad conversion where
        -- required (for writes to the array).
        if (array_write = '1') then
          d_readdata_i(15 downto 08) <= conv_dual_to_quad(d_readdata(15 downto 08));
          d_readdata_i(07 downto 00) <= conv_dual_to_quad(d_readdata(07 downto 00));
        else
          d_readdata_i               <= d_readdata;
        end if;

      end if;

    end if;

  end process;

  conf_d_i(07 downto 00) <= conf_d(07 downto 00);
  conf_d_i(08)          <= '0';
  conf_d_i(09)          <= '0';
  conf_d_i(10)          <= conf_c_in(0); -- fce_rdy
  conf_d_i(11)          <= conf_c_in(1); -- fci_valid
  conf_d_i(12)          <= conf_c_in(2); -- fci_sop
  conf_d_i(13)          <= '0';
  conf_d_i(14)          <= '0';
  conf_d_i(15)          <= '0';


  -- Data and clock from the System Manager are transmitted on the same edge.
  -- Capture on falling edge of clk to meet setup and hold requirements at S10 FPGA.
  retime_confd_0 : retime
    generic map (
      DEPTH => 1,
      WIDTH => 16
      )
    port map (
      reset => '0',
      clock => clk_n,
      d     => conf_d_i,
      q     => conf_d_a1
      );

  clk_n <= not clk;

  retime_confd_1 : retime
    generic map (
      DEPTH => 1,
      WIDTH => 16
      )
    port map (
      reset => '0',
      clock => clk,
      d     => conf_d_a1,
      q     => conf_d_in
      );

  process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        fce_rdy     <= '0';
        fci_valid   <= '0';
        fci_sop     <= '0';
        fci_payload <= '0';
        lgrant      <= '0';
        rgrant      <= (others => '0');
      else
        -- pick and register inputs
        fce_rdy     <= conf_d_in(10);
        fci_data    <= conf_d_in(07 downto 00);
        fci_valid   <= conf_d_in(11);
        fci_sop     <= conf_d_in(12);
        fci_payload <= conf_d_in(11) and not conf_d_in(12);
        lgrant      <= conf_d_in(10);
        rgrant      <= ('0' & not conf_d_in(10));
      end if;
    end if;
  end process;

  -------------------------------------------------------------------------------
  -- Form vectors as required for cmux
  -------------------------------------------------------------------------------

  csr_read_data <= (paddress & plen & unused_gnd(7 downto 2) & pread_write_n & pdma_start &
                    unused_gnd(31 downto 19) & rgrant & lgrant & unused_gnd(15 downto 9) & lrequest & unused_gnd(7 downto 2) & pdma_busy & pdma_done &
                    unused_gnd(31 downto 1) & soft_reconfig_req &
                    unused_gnd(31 downto 12) & ocr_start_address &
                    unused_gnd(31 downto 28) & qspi_start_address &
                    cmd_code & unused_gnd(23 downto 17) & length(8 downto 0) & unused_gnd(7 downto 1) & dma_start &
                    unused_gnd(31 downto 02) & dma_busy & dma_done
                    );


  csr_read_sel <= (status_reg_en.pcontrol &
                   status_reg_en.pstatus &
                   status_reg_en.rcfg_addr &
                   status_reg_en.ocr_start_addr &
                   status_reg_en.qspi_start_addr &
                   status_reg_en.qcontrol &
                   status_reg_en.qstatus
                   );

  d_address <= d_address_i;
  d_read    <= d_read_i;

  soft_reconfigure_req_n <= not soft_reconfig_req;

  -- Pipeline the output path.
  process(clk)
  begin
    if rising_edge(clk) then
      fce_data_pll_a1    <= fce_data;
      fce_data_oe_pll_a1 <= (others => fce_data_oe);
      fce_valid_pll_a1   <= fce_valid;
      fce_sop_pll_a1     <= fce_sop;
      fci_rdy_pll_a1     <= fci_rdy;
      lrequest_pll_a1    <= lrequest;
    end if;
  end process;

  -- Clock the output path with pll_clk to control timing at the pins.
  process(pll_clk)
  begin
    if rising_edge(pll_clk) then
      fce_data_pll    <= fce_data_pll_a1;
      fce_data_oe_pll <= fce_data_oe_pll_a1;
      fce_valid_pll   <= fce_valid_pll_a1;
      fce_sop_pll     <= fce_sop_pll_a1;
      fci_rdy_pll     <= fci_rdy_pll_a1;
      lrequest_pll    <= lrequest_pll_a1;
    end if;
  end process;


  -- For simulation purposes we have the ability to tristate conf_d bus during configuration.
  conf_d(00) <= fce_data_pll(00) when (fce_data_oe_pll(00) = '1') else 'Z';
  conf_d(01) <= fce_data_pll(01) when (fce_data_oe_pll(01) = '1') else 'Z';
  conf_d(02) <= fce_data_pll(02) when (fce_data_oe_pll(02) = '1') else 'Z';
  conf_d(03) <= fce_data_pll(03) when (fce_data_oe_pll(03) = '1') else 'Z';
  conf_d(04) <= fce_data_pll(04) when (fce_data_oe_pll(04) = '1') else 'Z';
  conf_d(05) <= fce_data_pll(05) when (fce_data_oe_pll(05) = '1') else 'Z';
  conf_d(06) <= fce_data_pll(06) when (fce_data_oe_pll(06) = '1') else 'Z';
  conf_d(07) <= fce_data_pll(07) when (fce_data_oe_pll(07) = '1') else 'Z';
  
  conf_c_out(0) <= fce_valid_pll;       -- conf_d(08)
  conf_c_out(1) <= fce_sop_pll;         -- conf_d(09)
  conf_c_out(2) <= fci_rdy_pll;         -- conf_d(13)
  conf_c_out(3) <= lrequest_pll;        -- conf_d(25)


end rtl;

