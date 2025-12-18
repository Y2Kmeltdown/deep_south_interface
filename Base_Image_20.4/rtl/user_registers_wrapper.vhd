--------------------------------------------------------------------------------
-- User Registers Wrapper
-- This wrapper converts individual signals to/from the T_user_registers record
-- for interfacing between Verilog and VHDL modules
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.pkg_user_registers.all;

entity user_registers_wrapper is
  port (
    -- Clocks & Reset
    config_clk         : in  std_logic;
    config_rstn        : in  std_logic;
    
    -- Host Interface (Avalon MM Slave)
    avmm_waitrequest   : out std_logic;
    avmm_readdata      : out std_logic_vector(31 downto 0);
    avmm_readdatavalid : out std_logic;
    avmm_burstcount    : in  std_logic_vector(0 downto 0);
    avmm_writedata     : in  std_logic_vector(31 downto 0);
    avmm_address       : in  std_logic_vector(11 downto 0);
    avmm_write         : in  std_logic;
    avmm_read          : in  std_logic;
    avmm_byteenable    : in  std_logic_vector(3 downto 0);
    
    -- Control/Status Registers (outputs from user_registers)
    reg_0_out          : out std_logic_vector(31 downto 0);
    reg_1_out          : out std_logic_vector(31 downto 0);
    led_control        : out std_logic_vector(2 downto 0);
    
    -- Additional inputs
    slave_wait         : in  std_logic;
    fpga_gpio_1        : in  std_logic;
    fpga_rst_n         : in  std_logic;
    
    -- Individual register signals (unpacked from T_user_registers record)
    -- Chip ID
    reg_chip_id_l      : in  std_logic_vector(31 downto 0);
    reg_chip_id_h      : in  std_logic_vector(31 downto 0);
    
    -- Clock Counts
    reg_count_stcl     : in  std_logic_vector(31 downto 0);
    reg_count_00       : in  std_logic_vector(31 downto 0);
    reg_count_01       : in  std_logic_vector(31 downto 0);
    reg_count_02       : in  std_logic_vector(31 downto 0);
    reg_count_03       : in  std_logic_vector(31 downto 0);
    reg_count_04       : in  std_logic_vector(31 downto 0);
    reg_count_05       : in  std_logic_vector(31 downto 0);
    reg_count_06       : in  std_logic_vector(31 downto 0);
    reg_count_07       : in  std_logic_vector(31 downto 0);
    reg_count_08       : in  std_logic_vector(31 downto 0);
    reg_count_09       : in  std_logic_vector(31 downto 0);
    reg_count_10       : in  std_logic_vector(31 downto 0);
    reg_count_11       : in  std_logic_vector(31 downto 0);
    reg_count_12       : in  std_logic_vector(31 downto 0);
    reg_count_13       : in  std_logic_vector(31 downto 0);
    reg_count_14       : in  std_logic_vector(31 downto 0);
    reg_count_15       : in  std_logic_vector(31 downto 0);
    reg_count_16       : in  std_logic_vector(31 downto 0);
    reg_count_17       : in  std_logic_vector(31 downto 0);
    reg_count_18       : in  std_logic_vector(31 downto 0);
    reg_count_19       : in  std_logic_vector(31 downto 0);
    reg_count_20       : in  std_logic_vector(31 downto 0);
    reg_count_21       : in  std_logic_vector(31 downto 0);
    reg_count_22       : in  std_logic_vector(31 downto 0);
    
    -- Temperature
    reg_temp_stcl      : in  std_logic_vector(31 downto 0);
    reg_temp_chan_0    : in  std_logic_vector(31 downto 0);
    reg_temp_chan_1    : in  std_logic_vector(31 downto 0);
    reg_temp_chan_2    : in  std_logic_vector(31 downto 0);
    reg_temp_chan_3    : in  std_logic_vector(31 downto 0);
    reg_temp_chan_4    : in  std_logic_vector(31 downto 0);
    reg_temp_chan_5    : in  std_logic_vector(31 downto 0);
    reg_temp_chan_6    : in  std_logic_vector(31 downto 0);
    reg_temp_chan_7    : in  std_logic_vector(31 downto 0);
    reg_temp_chan_8    : in  std_logic_vector(31 downto 0);
    
    -- Voltage
    reg_volt_stcl      : in  std_logic_vector(31 downto 0);
    reg_volt_chan_2    : in  std_logic_vector(31 downto 0);
    reg_volt_chan_3    : in  std_logic_vector(31 downto 0);
    reg_volt_chan_4    : in  std_logic_vector(31 downto 0);
    reg_volt_chan_6    : in  std_logic_vector(31 downto 0);
    reg_volt_chan_9    : in  std_logic_vector(31 downto 0);
    
    -- Memory 0 Ping-Pong
    reg_mem0_pp_stat     : in  std_logic_vector(31 downto 0);
    reg_mem0_pp_ctrl     : in  std_logic_vector(31 downto 0);
    reg_mem0_pp_depth    : in  std_logic_vector(31 downto 0);
    reg_mem0_pp_send_buf : in  std_logic_vector(31 downto 0);
    reg_mem0_pp_read_buf : in  std_logic_vector(31 downto 0);
    
    -- Memory 1 Ping-Pong
    reg_mem1_pp_stat     : in  std_logic_vector(31 downto 0);
    reg_mem1_pp_ctrl     : in  std_logic_vector(31 downto 0);
    reg_mem1_pp_depth    : in  std_logic_vector(31 downto 0);
    reg_mem1_pp_send_buf : in  std_logic_vector(31 downto 0);
    reg_mem1_pp_read_buf : in  std_logic_vector(31 downto 0);
    
    -- Memory 2 Ping-Pong
    reg_mem2_pp_stat     : in  std_logic_vector(31 downto 0);
    reg_mem2_pp_ctrl     : in  std_logic_vector(31 downto 0);
    reg_mem2_pp_depth    : in  std_logic_vector(31 downto 0);
    reg_mem2_pp_send_buf : in  std_logic_vector(31 downto 0);
    reg_mem2_pp_read_buf : in  std_logic_vector(31 downto 0);
    
    -- Memory 3 Ping-Pong
    reg_mem3_pp_stat     : in  std_logic_vector(31 downto 0);
    reg_mem3_pp_ctrl     : in  std_logic_vector(31 downto 0);
    reg_mem3_pp_depth    : in  std_logic_vector(31 downto 0);
    reg_mem3_pp_send_buf : in  std_logic_vector(31 downto 0);
    reg_mem3_pp_read_buf : in  std_logic_vector(31 downto 0);
    
    -- XCVR Group 0
    reg_xcvr0_stat            : in  std_logic_vector(31 downto 0);
    reg_xcvr0_ctrl            : in  std_logic_vector(31 downto 0);
    reg_xcvr0_phy0_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr0_phy1_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr0_phy2_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr0_phy3_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr0_statistics      : in  std_logic_vector(31 downto 0);
    
    -- XCVR Group 1
    reg_xcvr1_stat            : in  std_logic_vector(31 downto 0);
    reg_xcvr1_ctrl            : in  std_logic_vector(31 downto 0);
    reg_xcvr1_phy0_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr1_phy1_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr1_phy2_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr1_phy3_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr1_statistics      : in  std_logic_vector(31 downto 0);
    
    -- XCVR Group 2
    reg_xcvr2_stat            : in  std_logic_vector(31 downto 0);
    reg_xcvr2_ctrl            : in  std_logic_vector(31 downto 0);
    reg_xcvr2_phy0_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr2_phy1_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr2_phy2_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr2_phy3_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr2_statistics      : in  std_logic_vector(31 downto 0);
    
    -- XCVR Group 3
    reg_xcvr3_stat            : in  std_logic_vector(31 downto 0);
    reg_xcvr3_ctrl            : in  std_logic_vector(31 downto 0);
    reg_xcvr3_phy0_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr3_phy1_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr3_phy2_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr3_phy3_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr3_statistics      : in  std_logic_vector(31 downto 0);
    
    -- XCVR Group 4
    reg_xcvr4_stat            : in  std_logic_vector(31 downto 0);
    reg_xcvr4_ctrl            : in  std_logic_vector(31 downto 0);
    reg_xcvr4_phy0_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr4_phy1_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr4_phy2_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr4_phy3_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr4_statistics      : in  std_logic_vector(31 downto 0);
    
    -- XCVR Group 5
    reg_xcvr5_stat            : in  std_logic_vector(31 downto 0);
    reg_xcvr5_ctrl            : in  std_logic_vector(31 downto 0);
    reg_xcvr5_phy0_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr5_phy1_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr5_phy2_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr5_phy3_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr5_statistics      : in  std_logic_vector(31 downto 0);
    
    -- XCVR Group 6
    reg_xcvr6_stat            : in  std_logic_vector(31 downto 0);
    reg_xcvr6_ctrl            : in  std_logic_vector(31 downto 0);
    reg_xcvr6_phy0_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr6_phy1_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr6_phy2_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr6_phy3_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr6_statistics      : in  std_logic_vector(31 downto 0);
    
    -- XCVR Group 7
    reg_xcvr7_stat            : in  std_logic_vector(31 downto 0);
    reg_xcvr7_ctrl            : in  std_logic_vector(31 downto 0);
    reg_xcvr7_phy0_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr7_phy1_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr7_phy2_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr7_phy3_err_counts : in  std_logic_vector(31 downto 0);
    reg_xcvr7_statistics      : in  std_logic_vector(31 downto 0);
    
    -- Cooker Preserve
    reg_cook_preserve : in  std_logic_vector(31 downto 0)
  );
end user_registers_wrapper;

architecture rtl of user_registers_wrapper is

  -- Internal record signal
  signal user_regs : T_user_registers;

begin

  -- Pack individual signals into the record
  user_regs.reg_chip_id_l <= reg_chip_id_l;
  user_regs.reg_chip_id_h <= reg_chip_id_h;
  
  user_regs.reg_count_stcl <= reg_count_stcl;
  user_regs.reg_count_00   <= reg_count_00;
  user_regs.reg_count_01   <= reg_count_01;
  user_regs.reg_count_02   <= reg_count_02;
  user_regs.reg_count_03   <= reg_count_03;
  user_regs.reg_count_04   <= reg_count_04;
  user_regs.reg_count_05   <= reg_count_05;
  user_regs.reg_count_06   <= reg_count_06;
  user_regs.reg_count_07   <= reg_count_07;
  user_regs.reg_count_08   <= reg_count_08;
  user_regs.reg_count_09   <= reg_count_09;
  user_regs.reg_count_10   <= reg_count_10;
  user_regs.reg_count_11   <= reg_count_11;
  user_regs.reg_count_12   <= reg_count_12;
  user_regs.reg_count_13   <= reg_count_13;
  user_regs.reg_count_14   <= reg_count_14;
  user_regs.reg_count_15   <= reg_count_15;
  user_regs.reg_count_16   <= reg_count_16;
  user_regs.reg_count_17   <= reg_count_17;
  user_regs.reg_count_18   <= reg_count_18;
  user_regs.reg_count_19   <= reg_count_19;
  user_regs.reg_count_20   <= reg_count_20;
  user_regs.reg_count_21   <= reg_count_21;
  user_regs.reg_count_22   <= reg_count_22;
  
  user_regs.reg_temp_stcl   <= reg_temp_stcl;
  user_regs.reg_temp_chan_0 <= reg_temp_chan_0;
  user_regs.reg_temp_chan_1 <= reg_temp_chan_1;
  user_regs.reg_temp_chan_2 <= reg_temp_chan_2;
  user_regs.reg_temp_chan_3 <= reg_temp_chan_3;
  user_regs.reg_temp_chan_4 <= reg_temp_chan_4;
  user_regs.reg_temp_chan_5 <= reg_temp_chan_5;
  user_regs.reg_temp_chan_6 <= reg_temp_chan_6;
  user_regs.reg_temp_chan_7 <= reg_temp_chan_7;
  user_regs.reg_temp_chan_8 <= reg_temp_chan_8;
  
  user_regs.reg_volt_stcl   <= reg_volt_stcl;
  user_regs.reg_volt_chan_2 <= reg_volt_chan_2;
  user_regs.reg_volt_chan_3 <= reg_volt_chan_3;
  user_regs.reg_volt_chan_4 <= reg_volt_chan_4;
  user_regs.reg_volt_chan_6 <= reg_volt_chan_6;
  user_regs.reg_volt_chan_9 <= reg_volt_chan_9;
  
  user_regs.reg_mem0_pp_stat     <= reg_mem0_pp_stat;
  user_regs.reg_mem0_pp_ctrl     <= reg_mem0_pp_ctrl;
  user_regs.reg_mem0_pp_depth    <= reg_mem0_pp_depth;
  user_regs.reg_mem0_pp_send_buf <= reg_mem0_pp_send_buf;
  user_regs.reg_mem0_pp_read_buf <= reg_mem0_pp_read_buf;
  
  user_regs.reg_mem1_pp_stat     <= reg_mem1_pp_stat;
  user_regs.reg_mem1_pp_ctrl     <= reg_mem1_pp_ctrl;
  user_regs.reg_mem1_pp_depth    <= reg_mem1_pp_depth;
  user_regs.reg_mem1_pp_send_buf <= reg_mem1_pp_send_buf;
  user_regs.reg_mem1_pp_read_buf <= reg_mem1_pp_read_buf;
  
  user_regs.reg_mem2_pp_stat     <= reg_mem2_pp_stat;
  user_regs.reg_mem2_pp_ctrl     <= reg_mem2_pp_ctrl;
  user_regs.reg_mem2_pp_depth    <= reg_mem2_pp_depth;
  user_regs.reg_mem2_pp_send_buf <= reg_mem2_pp_send_buf;
  user_regs.reg_mem2_pp_read_buf <= reg_mem2_pp_read_buf;
  
  user_regs.reg_mem3_pp_stat     <= reg_mem3_pp_stat;
  user_regs.reg_mem3_pp_ctrl     <= reg_mem3_pp_ctrl;
  user_regs.reg_mem3_pp_depth    <= reg_mem3_pp_depth;
  user_regs.reg_mem3_pp_send_buf <= reg_mem3_pp_send_buf;
  user_regs.reg_mem3_pp_read_buf <= reg_mem3_pp_read_buf;
  
  user_regs.reg_xcvr0_stat            <= reg_xcvr0_stat;
  user_regs.reg_xcvr0_ctrl            <= reg_xcvr0_ctrl;
  user_regs.reg_xcvr0_phy0_err_counts <= reg_xcvr0_phy0_err_counts;
  user_regs.reg_xcvr0_phy1_err_counts <= reg_xcvr0_phy1_err_counts;
  user_regs.reg_xcvr0_phy2_err_counts <= reg_xcvr0_phy2_err_counts;
  user_regs.reg_xcvr0_phy3_err_counts <= reg_xcvr0_phy3_err_counts;
  user_regs.reg_xcvr0_statistics      <= reg_xcvr0_statistics;
  
  user_regs.reg_xcvr1_stat            <= reg_xcvr1_stat;
  user_regs.reg_xcvr1_ctrl            <= reg_xcvr1_ctrl;
  user_regs.reg_xcvr1_phy0_err_counts <= reg_xcvr1_phy0_err_counts;
  user_regs.reg_xcvr1_phy1_err_counts <= reg_xcvr1_phy1_err_counts;
  user_regs.reg_xcvr1_phy2_err_counts <= reg_xcvr1_phy2_err_counts;
  user_regs.reg_xcvr1_phy3_err_counts <= reg_xcvr1_phy3_err_counts;
  user_regs.reg_xcvr1_statistics      <= reg_xcvr1_statistics;
  
  user_regs.reg_xcvr2_stat            <= reg_xcvr2_stat;
  user_regs.reg_xcvr2_ctrl            <= reg_xcvr2_ctrl;
  user_regs.reg_xcvr2_phy0_err_counts <= reg_xcvr2_phy0_err_counts;
  user_regs.reg_xcvr2_phy1_err_counts <= reg_xcvr2_phy1_err_counts;
  user_regs.reg_xcvr2_phy2_err_counts <= reg_xcvr2_phy2_err_counts;
  user_regs.reg_xcvr2_phy3_err_counts <= reg_xcvr2_phy3_err_counts;
  user_regs.reg_xcvr2_statistics      <= reg_xcvr2_statistics;
  
  user_regs.reg_xcvr3_stat            <= reg_xcvr3_stat;
  user_regs.reg_xcvr3_ctrl            <= reg_xcvr3_ctrl;
  user_regs.reg_xcvr3_phy0_err_counts <= reg_xcvr3_phy0_err_counts;
  user_regs.reg_xcvr3_phy1_err_counts <= reg_xcvr3_phy1_err_counts;
  user_regs.reg_xcvr3_phy2_err_counts <= reg_xcvr3_phy2_err_counts;
  user_regs.reg_xcvr3_phy3_err_counts <= reg_xcvr3_phy3_err_counts;
  user_regs.reg_xcvr3_statistics      <= reg_xcvr3_statistics;
  
  user_regs.reg_xcvr4_stat            <= reg_xcvr4_stat;
  user_regs.reg_xcvr4_ctrl            <= reg_xcvr4_ctrl;
  user_regs.reg_xcvr4_phy0_err_counts <= reg_xcvr4_phy0_err_counts;
  user_regs.reg_xcvr4_phy1_err_counts <= reg_xcvr4_phy1_err_counts;
  user_regs.reg_xcvr4_phy2_err_counts <= reg_xcvr4_phy2_err_counts;
  user_regs.reg_xcvr4_phy3_err_counts <= reg_xcvr4_phy3_err_counts;
  user_regs.reg_xcvr4_statistics      <= reg_xcvr4_statistics;
  
  user_regs.reg_xcvr5_stat            <= reg_xcvr5_stat;
  user_regs.reg_xcvr5_ctrl            <= reg_xcvr5_ctrl;
  user_regs.reg_xcvr5_phy0_err_counts <= reg_xcvr5_phy0_err_counts;
  user_regs.reg_xcvr5_phy1_err_counts <= reg_xcvr5_phy1_err_counts;
  user_regs.reg_xcvr5_phy2_err_counts <= reg_xcvr5_phy2_err_counts;
  user_regs.reg_xcvr5_phy3_err_counts <= reg_xcvr5_phy3_err_counts;
  user_regs.reg_xcvr5_statistics      <= reg_xcvr5_statistics;
  
  user_regs.reg_xcvr6_stat            <= reg_xcvr6_stat;
  user_regs.reg_xcvr6_ctrl            <= reg_xcvr6_ctrl;
  user_regs.reg_xcvr6_phy0_err_counts <= reg_xcvr6_phy0_err_counts;
  user_regs.reg_xcvr6_phy1_err_counts <= reg_xcvr6_phy1_err_counts;
  user_regs.reg_xcvr6_phy2_err_counts <= reg_xcvr6_phy2_err_counts;
  user_regs.reg_xcvr6_phy3_err_counts <= reg_xcvr6_phy3_err_counts;
  user_regs.reg_xcvr6_statistics      <= reg_xcvr6_statistics;
  
  user_regs.reg_xcvr7_stat            <= reg_xcvr7_stat;
  user_regs.reg_xcvr7_ctrl            <= reg_xcvr7_ctrl;
  user_regs.reg_xcvr7_phy0_err_counts <= reg_xcvr7_phy0_err_counts;
  user_regs.reg_xcvr7_phy1_err_counts <= reg_xcvr7_phy1_err_counts;
  user_regs.reg_xcvr7_phy2_err_counts <= reg_xcvr7_phy2_err_counts;
  user_regs.reg_xcvr7_phy3_err_counts <= reg_xcvr7_phy3_err_counts;
  user_regs.reg_xcvr7_statistics      <= reg_xcvr7_statistics;
  
  user_regs.reg_cook_preserve <= reg_cook_preserve;

  -- Instantiate the actual user_registers module
  u_user_registers : entity work.user_registers
    port map (
      -- Clocks & Reset
      config_clk         => config_clk,
      config_rstn        => config_rstn,
      -- Host Interface
      avmm_waitrequest   => avmm_waitrequest,
      avmm_readdata      => avmm_readdata,
      avmm_readdatavalid => avmm_readdatavalid,
      avmm_burstcount    => avmm_burstcount,
      avmm_writedata     => avmm_writedata,
      avmm_address       => avmm_address,
      avmm_write         => avmm_write,
      avmm_read          => avmm_read,
      avmm_byteenable    => avmm_byteenable,
      -- Registers
      reg_0_out          => reg_0_out,
      reg_1_out          => reg_1_out,
      led_control        => led_control,
      slave_wait         => slave_wait,
      fpga_gpio_1        => fpga_gpio_1,
      fpga_rst_n         => fpga_rst_n,
      user_regs          => user_regs
    );

end rtl;