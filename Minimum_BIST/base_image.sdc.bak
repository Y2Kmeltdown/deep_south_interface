# (C) 1992-2016 Altera Corporation. All rights reserved.                         
# Your use of Altera Corporation's design tools, logic functions and other       
# software and tools, and its AMPP partner logic functions, and any output       
# files any of the foregoing (including device programming or simulation         
# files), and any associated documentation or information are expressly subject  
# to the terms and conditions of the Altera Program License Subscription         
# Agreement, Altera MegaCore Function License Agreement, or other applicable     
# license agreement, including, without limitation, that your use is for the     
# sole purpose of programming logic devices manufactured by Altera and sold by   
# Altera or its authorized distributors.  Please refer to the applicable         
# agreement for further details.                                                 

#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3


#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {config_clk}  -period  20.000 [get_ports config_clk]
create_clock -name {usr_refclk0} -period   3.333 [get_ports usr_refclk0]
create_clock -name {usr_refclk1} -period   3.333 [get_ports usr_refclk1]
create_clock -name {pcie_refclk} -period  10.000 [get_ports pcie_refclk]
create_clock -name {spi_sclk}    -period 100.000 [get_ports spi_sclk]
create_clock -name {u1pps}       -period  80.000 [get_ports u1pps]

create_clock -name {mem0_refclk} -period 3.333 [get_ports mem0_refclk]
create_clock -name {mem1_refclk} -period 3.333 [get_ports mem1_refclk]

create_clock -name {xcvr_refclk_0} -period 1.551 [get_ports xcvr_refclk_0]
create_clock -name {xcvr_refclk_1} -period 1.551 [get_ports xcvr_refclk_1]
create_clock -name {xcvr_refclk_2} -period 1.551 [get_ports xcvr_refclk_2]
create_clock -name {xcvr_refclk_3} -period 1.551 [get_ports xcvr_refclk_3]

create_clock -name {xcvr_refclk_4} -period 10.000 [get_ports xcvr_refclk_4]
#create_clock -name {xcvr_refclk_5} -period 10.000 [get_ports xcvr_refclk_5]
create_clock -name {xcvr_refclk_6} -period 10.000 [get_ports xcvr_refclk_6]
#create_clock -name {xcvr_refclk_7} -period 10.000 [get_ports xcvr_refclk_7]

create_clock -name {xcvr_refclk_8} -period 6.400 [get_ports xcvr_refclk_8]
create_clock -name {xcvr_refclk_9} -period 6.400 [get_ports xcvr_refclk_9]
create_clock -name {xcvr_refclk_10} -period 6.400 [get_ports xcvr_refclk_10]
create_clock -name {xcvr_refclk_11} -period 6.400 [get_ports xcvr_refclk_11]

create_clock -name {rcvrd_refclk_0} -period 8.000 [get_ports rcvrd_refclk_0]
create_clock -name {rcvrd_refclk_1} -period 8.000 [get_ports rcvrd_refclk_1]
create_clock -name {rcvrd_refclk_2} -period 8.000 [get_ports rcvrd_refclk_2]
create_clock -name {rcvrd_refclk_3} -period 8.000 [get_ports rcvrd_refclk_3]

create_clock -name {esram_0_refclk} -period 5.000 [get_ports esram_0_refclk]
create_clock -name {esram_1_refclk} -period 5.000 [get_ports esram_1_refclk]

#create_clock -name {hbm_top_ref_clks_pll_ref_clk} -period 5.000 [get_ports hbm_top_ref_clks_pll_ref_clk]
#create_clock -name {hbm_bottom_ref_clks_pll_ref_clk} -period 5.000 [get_ports hbm_bottom_ref_clks_pll_ref_clk]


create_clock -name {altera_reserved_tck} -period 62.500 {altera_reserved_tck}

# Add a virtual clock
create_clock -period 20 -name clock_ext

# To get timing closure the output path (to the pads) uses a phase controlled version of config_clk,
# therefore a multicycle path of 2 must be specified.

set_multicycle_path -from [get_registers {u30|qsys_sys_mgr|system_manager_if|system_manager_if|fce_data_pll[*]}]    -to [get_ports {conf_d[*]}]     -setup -end 2
set_multicycle_path -from [get_registers {u30|qsys_sys_mgr|system_manager_if|system_manager_if|fce_data_oe_pll[*]}] -to [get_ports {conf_d[*]}]     -setup -end 2
set_multicycle_path -from [get_registers {u30|qsys_sys_mgr|system_manager_if|system_manager_if|*_pll}]              -to [get_ports {conf_c_out[*]}] -setup -end 2


#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {config_clk}] -rise_to [get_clocks {config_clk}]  0.200  
set_clock_uncertainty -rise_from [get_clocks {config_clk}] -fall_to [get_clocks {config_clk}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {config_clk}] -rise_to [get_clocks {config_clk}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {config_clk}] -fall_to [get_clocks {config_clk}]  0.200  

set_clock_uncertainty -rise_from [get_clocks {usr_refclk0}] -rise_to [get_clocks {usr_refclk0}]  0.200  
set_clock_uncertainty -rise_from [get_clocks {usr_refclk0}] -fall_to [get_clocks {usr_refclk0}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {usr_refclk0}] -rise_to [get_clocks {usr_refclk0}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {usr_refclk0}] -fall_to [get_clocks {usr_refclk0}]  0.200  

set_clock_uncertainty -rise_from [get_clocks {usr_refclk1}] -rise_to [get_clocks {usr_refclk1}]  0.200  
set_clock_uncertainty -rise_from [get_clocks {usr_refclk1}] -fall_to [get_clocks {usr_refclk1}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {usr_refclk1}] -rise_to [get_clocks {usr_refclk1}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {usr_refclk1}] -fall_to [get_clocks {usr_refclk1}]  0.200  

set_clock_uncertainty -rise_from [get_clocks {pcie_refclk}] -rise_to [get_clocks {pcie_refclk}]  0.200  
set_clock_uncertainty -rise_from [get_clocks {pcie_refclk}] -fall_to [get_clocks {pcie_refclk}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {pcie_refclk}] -rise_to [get_clocks {pcie_refclk}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {pcie_refclk}] -fall_to [get_clocks {pcie_refclk}]  0.200  

derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#**************************************************************
# The clock and data transmitted from the System Manager are aligned at source and
# trace length matched, so the relationship between the virtual clock and the data
# at the System Manager output pins is maintained at the Stratix-10 input pins.

set_input_delay -clock clock_ext  -max 7.0 [get_ports {conf_d[*]}]
set_input_delay -clock clock_ext  -min 1.0 [get_ports {conf_d[*]}]

set_input_delay -clock clock_ext  -max 7.0 [get_ports {conf_c_in[*]}]
set_input_delay -clock clock_ext  -min 1.0 [get_ports {conf_c_in[*]}]

#******************
# bmc spi interface
#
set_input_delay -clock spi_sclk   -max 10.0 [get_ports {spi_mosi}]
set_input_delay -clock spi_sclk   -min  0.0 [get_ports {spi_mosi}]

set_input_delay -clock spi_sclk   -max 10.0 [get_ports {spi_nss}]
set_input_delay -clock spi_sclk   -min  0.0 [get_ports {spi_nss}]


#**************************************************************
# Set Output Delay
#**************************************************************
# At the System Manager's data input pins, setup (3.5ns) and hold (1.0ns) times
# are constrained relative to the System Manager's virtual clock. As this clock
# is the reference used by the Stratix-10 to time data transmitted to the System
# Manager, the Stratix-10 constraints must include an offset to account for the
# board trace delay of 2x 1.25ns = 2.5ns.

set_output_delay -clock clock_ext -max 6.0 [get_ports {conf_d[*]}]
set_output_delay -clock clock_ext -min 1.5 [get_ports {conf_d[*]}]

set_output_delay -clock clock_ext -max 6.0 [get_ports {conf_c_out[*]}]
set_output_delay -clock clock_ext -min 1.5 [get_ports {conf_c_out[*]}]

#******************
# bmc spi interface
#
set_output_delay -clock spi_sclk -max 12.0 [get_ports {spi_miso}]
set_output_delay -clock spi_sclk -min 1.0  [get_ports {spi_miso}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group {altera_reserved_tck}

set_clock_groups -asynchronous -group {usr_refclk0}
set_clock_groups -asynchronous -group {usr_refclk1}

set_clock_groups -asynchronous -group {pcie_refclk}

set_clock_groups -asynchronous -group [get_clocks {rcvrd_refclk_0}]
set_clock_groups -asynchronous -group [get_clocks {rcvrd_refclk_1}]
set_clock_groups -asynchronous -group [get_clocks {rcvrd_refclk_2}]
set_clock_groups -asynchronous -group [get_clocks {rcvrd_refclk_3}]

set_clock_groups -asynchronous -group {mem0_refclk}
set_clock_groups -asynchronous -group {mem1_refclk}

set_clock_groups -asynchronous -group {xcvr_refclk_0}
set_clock_groups -asynchronous -group {xcvr_refclk_1}
set_clock_groups -asynchronous -group {xcvr_refclk_2}
set_clock_groups -asynchronous -group {xcvr_refclk_3}
set_clock_groups -asynchronous -group {xcvr_refclk_4}
#set_clock_groups -asynchronous -group {xcvr_refclk_5}
set_clock_groups -asynchronous -group {xcvr_refclk_6}
#set_clock_groups -asynchronous -group {xcvr_refclk_7}
set_clock_groups -asynchronous -group {xcvr_refclk_8}
set_clock_groups -asynchronous -group {xcvr_refclk_9}
set_clock_groups -asynchronous -group {xcvr_refclk_10}
set_clock_groups -asynchronous -group {xcvr_refclk_11}

set_clock_groups -asynchronous -group {esram_0_refclk}
set_clock_groups -asynchronous -group {esram_1_refclk}

#set_clock_groups -asynchronous -group {hbm_top_ref_clks_pll_ref_clk}
#set_clock_groups -asynchronous -group {hbm_bottom_ref_clks_pll_ref_clk}


#**************************************************************
# Set False Paths
#**************************************************************

set_false_path -to led_user_red[*]
set_false_path -to led_user_grn[*]
set_false_path -to led_qsfp[*]
set_false_path -to soft_recfg_req_n
set_false_path -to oc0_gpio[*]
set_false_path -to oc1_gpio[*]
set_false_path -to oc0_gpio_dir[*]
set_false_path -to oc1_gpio_dir[*]
set_false_path -to oc_buff_en_n[*]
set_false_path -to opci_buff_in_sel[*]

set_false_path -from pcie_perstn
set_false_path -from oc0_gpio[*]
set_false_path -from oc1_gpio[*]
set_false_path -from oc_perst_n[*]
set_false_path -from fpga_gpio_1
set_false_path -from fpga_rst_n
set_false_path -from qsfp_irq_n[*]

# Asynchronous reset release
set_false_path -to [get_registers {u12|init_done_meta[0]}]
set_false_path -to [get_registers {u16|shift_reg[0]}]
set_false_path -to [get_registers {u17|shift_reg[0]}]

# All clock crossing paths from Clock Test counters through the memory mapped read multiplex
set_false_path -from [get_registers {u40|gen_counters[*].clk_counter|*}] -to [get_registers {u31|read_reg[*]}]

# All paths from Clock Test control register Reset and Enable bits are asynchronous
set_false_path -from [get_registers {u40|count_ctrl[*]}]

# All paths associated with the cooker
set_false_path -from [get_registers {u31|reg_cook_cken}]
set_false_path -from [get_registers {u31|reg_cook_size[*]}] -to [get_registers {u23|*}]
set_false_path -from [get_registers {u31|reg_cook_sreg[*]}] -to [get_registers {u23|*}]
set_false_path -from [get_registers {u31|reg_cook_bram[*]}] -to [get_registers {u23|*}]
set_false_path -from [get_registers {u31|reg_cook_dsp[*]}]  -to [get_registers {u23|*}]
set_false_path -from [get_registers {u23|u22|dsp_out}]  -to [get_registers {u31|*}]
set_false_path -from [get_registers {u31|reg_cook_size[*]}] -to [get_registers {u24|*}]
set_false_path -from [get_registers {u31|reg_cook_sreg[*]}] -to [get_registers {u24|*}]
set_false_path -from [get_registers {u31|reg_cook_bram[*]}] -to [get_registers {u24|*}]
set_false_path -from [get_registers {u31|reg_cook_dsp[*]}]  -to [get_registers {u24|*}]
set_false_path -from [get_registers {u24|u22|dsp_out}]  -to [get_registers {u31|*}]
set_false_path -from [get_registers {u23|*|reg_out}]  -to [get_registers {u31|*}]
set_false_path -from [get_registers {u23|*|bram_out}]  -to [get_registers {u31|*}]
set_false_path -from [get_registers {u24|*|reg_out}]  -to [get_registers {u31|*}]
set_false_path -from [get_registers {u24|*|bram_out}]  -to [get_registers {u31|*}]

# All async paths within DDR4 SDRAM BIST
set_false_path -from [get_registers {u50|gen0[*].u1|recal_pulse}]        -to [get_registers {u50|u*}]
set_false_path -from [get_registers {u50|gen0[*].u1|reg_pattern_sel[*]}] -to [get_registers {u50|gen0[*].u1|u00|*}]

set_false_path -to [get_registers {u50|gen0[*].u1|bist_reset_meta[0]}]
set_false_path -to [get_registers {u50|gen0[*].u1|bist_enable_meta[0]}]
set_false_path -to [get_registers {u50|gen0[*].u1|write_stop_meta[0]}]

set_false_path -to [get_registers {u50|gen0[*].u1|test_running_meta[0]}]
set_false_path -to [get_registers {u50|gen0[*].u1|test_fail_meta[0]}]
set_false_path -to [get_registers {u50|gen0[*].u1|cal_complete_meta[0]}]
set_false_path -to [get_registers {u50|gen0[*].u1|cal_fail_meta[0]}]
set_false_path -to [get_registers {u50|gen0[*].u1|reset_done_meta[0]}]

set_false_path -from [get_registers {u50|gen0[*].u1|u00|*}] -to [get_registers {u31|read_reg[*]}]

set_false_path -from [get_registers {u50|gen0[*].u1|mem_usr_stat_i}] -to [get_registers {u31|read_reg[*]}]

set_false_path -to [get_registers {u50|gen0[*].u3|cal_complete_meta[0]}]
set_false_path -to [get_registers {u50|gen0[*].u3|cal_fail_meta[0]}]
set_false_path -to [get_registers {u50|gen0[*].u3|reset_done_meta[0]}]

set_false_path -to [get_registers {u50|gen0[*].u3|start_pulse_meta[0]}]
set_false_path -to [get_registers {u50|gen0[*].u3|flush_pulse_meta[0]}]
set_false_path -to [get_registers {u50|gen0[*].u3|mode_read_meta[0]}]

set_false_path -from [get_registers {u50|gen0[*].u3|g1[*].wr_data_buf|write_addr_gray[*]}] -to [get_registers {u50|gen0[*].u3|g1[*].wr_data_buf|write_addr_gray_r1[*]}]
set_false_path -from [get_registers {u50|gen0[*].u3|g2[*].byte_en_buf|write_addr_gray[*]}] -to [get_registers {u50|gen0[*].u3|g2[*].byte_en_buf|write_addr_gray_r1[*]}]
set_false_path -from [get_registers {u50|gen0[*].u3|g3[*].rd_data_buf|write_addr_gray[*]}] -to [get_registers {u50|gen0[*].u3|g3[*].rd_data_buf|write_addr_gray_r1[*]}]
set_false_path -from [get_registers {u50|gen0[*].u3|addr_buf|write_addr_gray[*]}]          -to [get_registers {u50|gen0[*].u3|addr_buf|write_addr_gray_r1[*]}]

set_false_path -from [get_registers {u50|gen0[*].u3|*}] -to [get_registers {u31|read_reg[*]}]

# All async paths within System Manager Interface
set_false_path -from [get_registers {u30|qsys_sys_mgr|system_manager_if|system_manager_if|fce_data_pll[*]}]    -to [get_registers {u30|qsys_sys_mgr|system_manager_if|system_manager_if|retime_confd_0|q_i[0][*]}]
set_false_path -from [get_registers {u30|qsys_sys_mgr|system_manager_if|system_manager_if|fce_data_oe_pll[*]}] -to [get_registers {u30|qsys_sys_mgr|system_manager_if|system_manager_if|retime_confd_0|q_i[0][*]}]

# All async paths within XCVR BIST
set_false_path -to [get_registers {u6?|rx_ready_meta[0][*]}]
set_false_path -to [get_registers {u6?|chkr_rst_fbk_meta[0]}]
set_false_path -to [get_registers {u6?|tx_data_rst_meta[0]}]
set_false_path -to [get_registers {u6?|err_inj_pls_meta[0]}]
set_false_path -to [get_registers {u6?|prbs_enab_meta[0]}]
set_false_path -to [get_registers {u6?|rst_rx_req_meta[0][*]}]
set_false_path -to [get_registers {u6?|resync_pls_meta[0]}]
set_false_path -to [get_registers {u6?|sample_tgl_meta[0]}]
set_false_path -to [get_registers {u6?|capt_pls_meta[0]}]
set_false_path -to [get_registers {u6?|pll_locked_meta[0]}]
set_false_path -to [get_registers {u6?|rx_blk_lock_meta[0][*]}]

set_false_path -from [get_registers {u6?|prbs_lock[*]}]              -to [get_registers {u31|read_reg[*]}]
set_false_path -from [get_registers {u6?|capt_prbs_err_count[*][*]}] -to [get_registers {u31|read_reg[*]}]
set_false_path -from [get_registers {u6?|capt_ctrl_err_count[*][*]}] -to [get_registers {u31|read_reg[*]}]
set_false_path -from [get_registers {u6?|capt_rx_skew_store[*]}]     -to [get_registers {u31|read_reg[*]}]
set_false_path -from [get_registers {u6?|capt_rx_word_store[*]}]     -to [get_registers {u31|read_reg[*]}]

set_false_path -from [get_registers {u6?|error_inj[*]}] -to [get_registers {u6?|prbs_err_acc[*]}]

set_false_path -to [get_registers {u8?|rx_ready_meta[0][*]}]
set_false_path -to [get_registers {u8?|chkr_rst_fbk_meta[0]}]
set_false_path -to [get_registers {u8?|tx_data_rst_meta[0]}]
set_false_path -to [get_registers {u8?|err_inj_pls_meta[0]}]
set_false_path -to [get_registers {u8?|prbs_enab_meta[0]}]
set_false_path -to [get_registers {u8?|rst_rx_req_meta[0][*]}]
set_false_path -to [get_registers {u8?|resync_pls_meta[0]}]
set_false_path -to [get_registers {u8?|sample_tgl_meta[0]}]
set_false_path -to [get_registers {u8?|capt_pls_meta[0]}]
set_false_path -to [get_registers {u8?|pll_locked_meta[0]}]
set_false_path -to [get_registers {u8?|rx_blk_lock_meta[0][*]}]

set_false_path -from [get_registers {u8?|prbs_lock[*]}]              -to [get_registers {u31|read_reg[*]}]
set_false_path -from [get_registers {u8?|capt_prbs_err_count[*][*]}] -to [get_registers {u31|read_reg[*]}]
set_false_path -from [get_registers {u8?|capt_ctrl_err_count[*][*]}] -to [get_registers {u31|read_reg[*]}]
set_false_path -from [get_registers {u8?|capt_rx_skew_store[*]}]     -to [get_registers {u31|read_reg[*]}]
set_false_path -from [get_registers {u8?|capt_rx_word_store[*]}]     -to [get_registers {u31|read_reg[*]}]

set_false_path -from [get_registers {u8?|error_inj[*]}] -to [get_registers {u8?|prbs_err_acc[*]}]

set_false_path -from [get_registers {u30|av_hbm*|tg_*}] -to [get_registers {u30|av_hbm*|readdata_d1[*]}]

set_false_path -from [get_registers {u30|av_hbm*|*wmcrst**reset_*}] -to  [get_registers {u30|av_hbm*|reset_reg*[*]}]
