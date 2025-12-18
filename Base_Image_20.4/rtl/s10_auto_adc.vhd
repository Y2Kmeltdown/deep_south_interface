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
-- Title       : Stratix-10 ADC Interface
-- Project     : 520
--------------------------------------------------------------------------------
-- Description : This component provides the memory mapped interface for the
--               Stratix-10 ADC components (measuring temperature and voltage).
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

use work.pkg_user_registers.all;


entity s10_auto_adc is
  port (
    -- Clocks & Reset
    config_clk      : in  std_logic;
    config_rstn     : in  std_logic;
    -- Host Interface
    avmm_writedata  : in  std_logic_vector(31 downto 0);
    avmm_address    : in  std_logic_vector(11 downto 0);
    avmm_write      : in  std_logic;
    avmm_read       : in  std_logic;
    avmm_byteenable : in  std_logic_vector(3 downto 0);
    slave_wait      : in  std_logic;
    -- Registers
    temp_stcl       : out std_logic_vector(31 downto 0);
    temp_chan_0     : out std_logic_vector(31 downto 0);
    temp_chan_1     : out std_logic_vector(31 downto 0);
    temp_chan_2     : out std_logic_vector(31 downto 0);
    temp_chan_3     : out std_logic_vector(31 downto 0);
    temp_chan_4     : out std_logic_vector(31 downto 0);
    temp_chan_5     : out std_logic_vector(31 downto 0);
    temp_chan_6     : out std_logic_vector(31 downto 0);
    temp_chan_7     : out std_logic_vector(31 downto 0);
    temp_chan_8     : out std_logic_vector(31 downto 0);

    volt_stcl   : out std_logic_vector(31 downto 0);
    volt_chan_2 : out std_logic_vector(31 downto 0);
    volt_chan_3 : out std_logic_vector(31 downto 0);
    volt_chan_4 : out std_logic_vector(31 downto 0);
    volt_chan_6 : out std_logic_vector(31 downto 0);
    volt_chan_9 : out std_logic_vector(31 downto 0)

    );
end entity s10_auto_adc;


architecture rtl of s10_auto_adc is
  --------------------------
  -- Component Declarations
  --------------------------
  component s10_temperature is
                              port (
                                clk               : in  std_logic;
                                cmd_valid         : in  std_logic;
                                cmd_ready         : out std_logic;
                                cmd_data          : in  std_logic_vector(8 downto 0);
                                reset             : in  std_logic;
                                rsp_valid         : out std_logic;
                                rsp_data          : out std_logic_vector(31 downto 0);
                                rsp_channel       : out std_logic_vector(3 downto 0);
                                rsp_startofpacket : out std_logic;
                                rsp_endofpacket   : out std_logic
                                );
  end component;

  component s10_voltage is
                          port (
                            clk               : in  std_logic;
                            cmd_valid         : in  std_logic;
                            cmd_ready         : out std_logic;
                            cmd_data          : in  std_logic_vector(15 downto 0);
                            reset             : in  std_logic;
                            rsp_valid         : out std_logic;
                            rsp_data          : out std_logic_vector(31 downto 0);
                            rsp_channel       : out std_logic_vector(3 downto 0);
                            rsp_startofpacket : out std_logic;
                            rsp_endofpacket   : out std_logic
                            );
  end component;

  constant TEMP_COMMAND : std_logic_vector(8 downto 0)  := (others => '1');
  constant VOLT_COMMAND : std_logic_vector(15 downto 0) := (2      => '1', 3 => '1', 4 => '1', 6 => '1', 9 => '1', others => '0');

  type t_cmd_state is (IDLE, EOP);

  signal temp_cmd_state : t_cmd_state;
  signal volt_cmd_state : t_cmd_state;


  -----------
  -- Signals
  -----------
  signal read_ctrl : std_logic := '0';

  signal temp_poll_enable : std_logic;
  signal volt_poll_enable : std_logic;

  signal temp_rst_count   : std_logic_vector(3 downto 0) := (others => '0');
  signal temp_sync_rst    : std_logic                    := '1';
  signal temp_cmd_valid   : std_logic;
  signal temp_cmd_ready   : std_logic;
  signal temp_cmd_data    : std_logic_vector(8 downto 0);
  signal temp_rsp_valid   : std_logic;
  signal temp_rsp_data    : std_logic_vector(31 downto 0);
  signal temp_rsp_channel : std_logic_vector(3 downto 0);
  signal temp_rsp_eop     : std_logic;
  signal temp_rsp_count   : std_logic_vector(7 downto 0);


  signal volt_rst_count   : std_logic_vector(3 downto 0) := (others => '0');
  signal volt_sync_rst    : std_logic                    := '1';
  signal volt_cmd_valid   : std_logic;
  signal volt_cmd_ready   : std_logic;
  signal volt_cmd_data    : std_logic_vector(15 downto 0);
  signal volt_rsp_valid   : std_logic;
  signal volt_rsp_data    : std_logic_vector(31 downto 0);
  signal volt_rsp_channel : std_logic_vector(3 downto 0);
  signal volt_rsp_eop     : std_logic;
  signal volt_rsp_count   : std_logic_vector(7 downto 0);

  type t_volt_sample_reg is array (0 to NUM_VOLT_SAMP_REGS-1) of std_logic_vector(31 downto 0);
  signal volt_sample_reg : t_volt_sample_reg := (others => (others => '0'));

  type t_temp_sample_reg is array (0 to NUM_TEMP_SAMP_REGS-1) of std_logic_vector(31 downto 0);
  signal temp_sample_reg : t_temp_sample_reg := (others => (others => '0'));


begin

  -------------------------
  -- Temperature Interface
  -------------------------
  t1 : s10_temperature
    port map (
      clk               => config_clk,  -- in  std_logic
      cmd_valid         => temp_cmd_valid,  -- in  std_logic
      cmd_ready         => temp_cmd_ready,  -- out std_logic
      cmd_data          => temp_cmd_data,  -- in  std_logic_vector(5 downto 0)
      reset             => temp_sync_rst,  -- in  std_logic
      rsp_valid         => temp_rsp_valid,  -- out std_logic
      rsp_data          => temp_rsp_data,  -- out std_logic_vector(31 downto 0)
      rsp_channel       => temp_rsp_channel,  -- out std_logic_vector(3 downto 0)
      rsp_startofpacket => open,        -- out std_logic
      rsp_endofpacket   => temp_rsp_eop  -- out std_logic
      );

  ---------------------
  -- Voltage Interface
  ---------------------
  v1 : s10_voltage
    port map (
      clk               => config_clk,  -- in  std_logic
      cmd_valid         => volt_cmd_valid,  -- in  std_logic
      cmd_ready         => volt_cmd_ready,  -- out std_logic
      cmd_data          => volt_cmd_data,  -- in  std_logic_vector(15 downto 0)
      reset             => volt_sync_rst,  -- in  std_logic
      rsp_valid         => volt_rsp_valid,  -- out std_logic
      rsp_data          => volt_rsp_data,  -- out std_logic_vector(31 downto 0)
      rsp_channel       => volt_rsp_channel,  -- out std_logic_vector(3 downto 0)
      rsp_startofpacket => open,        -- out std_logic
      rsp_endofpacket   => volt_rsp_eop  -- out std_logic
      );


  ------------------
  -- Register Logic
  ------------------
  process(config_clk)
  begin
    if rising_edge(config_clk) then
      if config_rstn = '0' then
        read_ctrl        <= '0';
        temp_rst_count   <= (others => '0');
        temp_sync_rst    <= '1';
        volt_rst_count   <= (others => '0');
        volt_sync_rst    <= '1';
        temp_poll_enable <= '0';
        volt_poll_enable <= '0';
        temp_rsp_count   <= (others => '0');
        volt_rsp_count   <= (others => '0');
        temp_cmd_state   <= IDLE;
        volt_cmd_state   <= IDLE;
      else

        -- defaults
        temp_cmd_valid <= '0';
        volt_cmd_valid <= '0';

        case temp_cmd_state is

          when IDLE =>
            if (temp_poll_enable = '1') and (temp_cmd_ready = '1') then
              temp_cmd_data  <= TEMP_COMMAND;
              temp_cmd_valid <= '1';
              temp_cmd_state <= EOP;
            end if;

          when EOP =>
            if (temp_rsp_valid = '1') and (temp_rsp_eop = '1') then
              temp_cmd_state <= IDLE;
            end if;

        end case;

        case volt_cmd_state is

          when IDLE =>
            if (volt_poll_enable = '1') and (volt_cmd_ready = '1') then
              volt_cmd_data  <= VOLT_COMMAND;
              volt_cmd_valid <= '1';
              volt_cmd_state <= EOP;
            end if;

          when EOP =>
            if (volt_rsp_valid = '1') and (volt_rsp_eop = '1') then
              volt_cmd_state <= IDLE;
            end if;

        end case;


        -- Register Read
        if avmm_read = '0' then
          read_ctrl <= '0';
        else
          read_ctrl <= read_ctrl nor slave_wait;
        end if;

        -- Stretch the temperature reset pulse
        if (avmm_write = '1') and (avmm_address = TEMP_ADC_STCL) and
          (avmm_byteenable(0) = '1') and (avmm_writedata(0) = '1') then
          temp_rst_count <= (others => '0');
          temp_sync_rst  <= '1';
        elsif temp_rst_count /= "1111" then
          temp_rst_count <= temp_rst_count + 1;
        else
          temp_sync_rst  <= '0';
        end if;

        if (avmm_write = '1') and (avmm_address = TEMP_ADC_STCL) and (avmm_byteenable(0) = '1') then
          temp_poll_enable <= avmm_writedata(4);
        end if;

        if (avmm_write = '1') and (avmm_address = VOLT_ADC_STCL) and (avmm_byteenable(0) = '1') then
          volt_poll_enable <= avmm_writedata(4);
        end if;


        -- Stretch the voltage reset pulse
        if (avmm_write = '1') and (avmm_address = VOLT_ADC_STCL) and
          (avmm_byteenable(0) = '1') and (avmm_writedata(0) = '1') then
          volt_rst_count <= (others => '0');
          volt_sync_rst  <= '1';
        elsif volt_rst_count /= "1111" then
          volt_rst_count <= volt_rst_count + 1;
        else
          volt_sync_rst  <= '0';
        end if;

        if (temp_rsp_valid = '1') then
          temp_sample_reg(conv_integer(temp_rsp_channel)) <= temp_rsp_data;
        end if;

        -- indicates interface is alive
        if (temp_rsp_valid = '1' and temp_rsp_eop = '1') then
          temp_rsp_count <= temp_rsp_count + '1';
        end if;

        if (volt_rsp_valid = '1') then
          volt_sample_reg(conv_integer(volt_rsp_channel)) <= volt_rsp_data;
        end if;

        if (volt_rsp_valid = '1' and volt_rsp_eop = '1') then
          volt_rsp_count <= volt_rsp_count + '1';
        end if;

      end if;
    end if;
  end process;

  -------------------
  -- Connect Outputs
  -------------------
  temp_stcl <= (unused_gnd(31 downto 16) & temp_rsp_count & unused_gnd(7) & temp_cmd_ready & unused_gnd(5) & temp_poll_enable & unused_gnd(3 downto 0));

  volt_stcl <= (unused_gnd(31 downto 16) & volt_rsp_count & unused_gnd(7) & volt_cmd_ready & unused_gnd(5) & volt_poll_enable & unused_gnd(3 downto 0));

  temp_chan_0 <= temp_sample_reg(0);
  temp_chan_1 <= temp_sample_reg(1);
  temp_chan_2 <= temp_sample_reg(2);
  temp_chan_3 <= temp_sample_reg(3);
  temp_chan_4 <= temp_sample_reg(4);
  temp_chan_5 <= temp_sample_reg(5);
  temp_chan_6 <= temp_sample_reg(6);
  temp_chan_7 <= temp_sample_reg(7);
  temp_chan_8 <= temp_sample_reg(8);

  volt_chan_2 <= volt_sample_reg(2);
  volt_chan_3 <= volt_sample_reg(3);
  volt_chan_4 <= volt_sample_reg(4);
  volt_chan_6 <= volt_sample_reg(6);
  volt_chan_9 <= volt_sample_reg(9);

end rtl;
