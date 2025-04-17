# (C) 2001-2020 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.




proc apply_cdc {from_keep to_keep} {
if {[llength [query_collection -report -all $from_keep]] > 0 && [llength [query_collection -report -all $to_keep]] > 0} {
set_max_skew -from $from_keep -to $to_keep -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8
if { ![string equal "quartus_syn" $::TimeQuestInfo(nameofexecutable)] } {
set_net_delay -from $from_keep -to $to_keep -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.85
}
set_max_delay -from $from_keep -to $to_keep 50
set_min_delay -from $from_keep -to $to_keep -50}
}

proc apply_cdc_to_bit {to_keep} {
  if {[llength [query_collection -report -all $to_keep]] > 0} {
    set_max_delay -to $to_keep 50
    set_min_delay -to $to_keep -50
    set fanins [get_fanins -no_logic to_keep]
    foreach_in_collection fanins $fanins {
      if {[llength [query_collection -report -all $fanins]] > 0 && [llength [query_collection -report -all $to_keep]] > 0} {
        if { ![string equal "quartus_syn" $::TimeQuestInfo(nameofexecutable)] } {
            set_net_delay -from $fanins -to $to_keep -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
        }
      }
    }
  }
}

proc apply_cdc_from_bit {from_keep} {
  set_max_delay -from $from_keep 50
  set_min_delay -from $from_keep -50
  set fanouts [get_fanouts -no_logic from_keep]
  foreach_in_collection fanouts $fanouts {
    if {[llength [query_collection -report -all $fanouts]] > 0} {
      if { ![string equal "quartus_syn" $::TimeQuestInfo(nameofexecutable)] } {
          set_net_delay -from $from_keep -to $fanouts -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
      }
    }
  }  
}

# Set max skew between the gray code pointers of TX_ST fifos.
set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_tx_st_if|tx_fifo_lo|*gx0|din_gry*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_tx_st_if|tx_fifo_lo|*gx0|u_din_gry_sync|sync_regs_s1*]
apply_cdc $from_keep $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_tx_st_if|tx_fifo_hi|*gx0|din_gry*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_tx_st_if|tx_fifo_hi|*gx0|u_din_gry_sync|sync_regs_s1*]
apply_cdc $from_keep $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_tx_st_if|tx_fifo_lo|*gx1|din_gry*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_tx_st_if|tx_fifo_lo|*gx1|u_din_gry_sync|sync_regs_s1*]
apply_cdc $from_keep $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_tx_st_if|tx_fifo_hi|*gx1|din_gry*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_tx_st_if|tx_fifo_hi|*gx1|u_din_gry_sync|sync_regs_s1*]
apply_cdc $from_keep $to_keep

##########################################################################################################################################

# Set max skew between the gray code pointers of RX_ST fifo.
set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_rx_st_if|rx_fifo|*gx0|din_gry*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_rx_st_if|rx_fifo|*gx0|u_din_gry_sync|sync_regs_s1*]
apply_cdc $from_keep $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_rx_st_if|rx_fifo|*gx1|din_gry*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_rx_st_if|rx_fifo|*gx1|u_din_gry_sync|sync_regs_s1*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers *altera_pcie_s10_gen3x16_adapter_inst|u_rx_st_if|rx_st_ready*]
apply_cdc_to_bit $to_keep

##########################################################################################################################################


# Set CDC constrains between the header sync bits of Error Interface.
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_err_if|u_header_present_sync|sync_regs_s1*]

apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn  *altera_pcie_s10_gen3x16_adapter_inst|u_err_if|u_rx_par_err_sync|u_din_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_err_if|u_rx_par_err_sync|u_dout_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_err_if|u_tx_par_err_sync|u_din_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_err_if|u_tx_par_err_sync|u_dout_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_err_if|u_serr_out_sync|u_din_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_err_if|u_serr_out_sync|u_dout_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_err_if|app_err*_q1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_err_if|app_err*_q2*]
apply_cdc_to_bit $to_keep

##########################################################################################################################################

# Set max delay between the valid sync bits of FLR Interface.
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_flr_if|u_free_valid_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_flr_if|u_pf_done_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_flr_if|u_free_active_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_flr_if|u_pf_active_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_flr_if|fifo_rdata*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_flr_if|done*_q*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_flr_if|done_tdm*_q*]
apply_cdc_to_bit $to_keep

##########################################################################################################################################

# Set max delay between the valid sync bits of CFG Interface.
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_cfg_if|u_free_valid_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_cfg_if|fifo_rdata*]
apply_cdc_to_bit $to_keep

##########################################################################################################################################

#False path between iopll_locked and its registered signal.
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|rst_n_clk250_reg*]
set_false_path -to $to_keep

#False path between iopll_locked and its registered signal.
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|rst_n_reg*]
set_false_path -to $to_keep

set to_keep [get_keepers *altera_pcie_s10_gen3x16_adapter_inst|rst_n_tree_clk250_reg_s*]
set_false_path -to $to_keep


##########################################################################################################################################


# Set max skew between the Credit Interface buses that cross the outclk0 and ch0 clocks.
set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_nph_cdts_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_nph_cdts_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_nph_cdts_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_nph_cdts_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_npd_cdts_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_npd_cdts_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_npd_cdts_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_npd_cdts_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_ph_cdts_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_ph_cdts_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_ph_cdts_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_ph_cdts_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_pd_cdts_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_pd_cdts_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_pd_cdts_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_pd_cdts_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_cplh_cdts_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_cplh_cdts_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_cplh_cdts_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_cplh_cdts_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_cpld_cdts_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_cpld_cdts_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_cpld_cdts_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|u_tx_cpld_cdts_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

##########################################################################################################################################
#Constrain the signals from misc_if

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_ceb_req_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_link_req_rst_n_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_serdes_pll_locked_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pld_clk_inuse_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_link_up_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pm_linkst_in_l1_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pm_linkst_in_l0s_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_app_msi_ack_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_app_msi_req_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_app_int_sts_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pld_warm_rst_rdy_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pld_core_ready_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_app_xfer_pending_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_app_int_sts_pf1_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_apps_pm_xmt_turnoff_sync|u_din_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_apps_pm_xmt_turnoff_sync|u_dout_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_app_init_rst_sync|u_din_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_app_init_rst_sync|u_dout_sync|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_pf1_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_pf1_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_pf1_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_pf1_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pm_dstate_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pm_dstate_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pm_dstate_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pm_dstate_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pm_state_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pm_state_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pm_state_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_pm_state_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_lane_act_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_lane_act_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_lane_act_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_lane_act_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_currentspeed_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_currentspeed_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_currentspeed_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_currentspeed_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_ltssmstate_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_ltssmstate_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_ltssmstate_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_ltssmstate_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_common_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_common_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_common_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_common_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_sync*data_in_d0*]
set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_sync*data_out*]
apply_cdc $from_keep $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_sync|u_req_rd_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

set to_keep [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_misc_if|u_int_status_sync|u_ack_wr_clk|sync_regs_s1*]
apply_cdc_to_bit $to_keep

##########################################################################################################################################
# Apply cdc constraints to reset
set to_keep [get_keepers *reset_status_250sync|din_s1*]
apply_cdc_to_bit $to_keep
set_false_path -from [get_keepers *altera_avst512_iopll|altera_ep_g3x16_avst512_io_pll_s10|*] -to [get_keepers *reset_status_250sync|dreg*]
set from_keeper_collection [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|rst_n_tree_reg*]
set to_keeper_collection [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|cdts_fifo*]
if {[llength [query_collection -report -all $from_keeper_collection]] > 0 && [llength [query_collection -report -all $to_keeper_collection]] > 0} {
  set_false_path -from [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|rst_n_tree_reg*] -to [get_keepers -nowarn *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|cdts_fifo*]
}

##########################################################################################################################################
# SRIOV bridge sdc
set keeper_collection [get_keepers -nowarn *ceb_req_sync*first_stage_reg]
if {[llength [query_collection -report -all $keeper_collection]] > 0} {
  set_false_path -to [get_keepers -nowarn *ceb_req_sync*first_stage_reg]
}
set keeper_collection [get_keepers -nowarn *status_update_sync*first_stage_reg]
if {[llength [query_collection -report -all $keeper_collection]] > 0} {
  set_false_path -to [get_keepers -nowarn *status_update_sync*first_stage_reg]
}
set keeper_collection [get_keepers -nowarn *update_ack_sync*first_stage_reg]
if {[llength [query_collection -report -all $keeper_collection]] > 0} {
  set_false_path -to [get_keepers -nowarn *update_ack_sync*first_stage_reg]
}
set keeper_collection [get_keepers -nowarn *flr_cdc*flr_pf_done_500mhz_firstreg[*]]
if {[llength [query_collection -report -all $keeper_collection]] > 0} {
  set_false_path -to [get_keepers -nowarn *flr_cdc*flr_pf_done_500mhz_firstreg[*]]
}
set to_keep [get_keepers -nowarn *ceb_cdc*ceb_*_500mhz_reg*]
apply_cdc_to_bit $to_keep
set to_keep [get_keepers -nowarn *ceb_ack_sync*first_stage_reg]
apply_cdc_to_bit $to_keep
set to_keep [get_keepers -nowarn *status_update_sync*first_stage_reg]
apply_cdc_to_bit $to_keep
set to_keep [get_keepers -nowarn *cpl_pending_status_cdc*vf_trans_pending_status_250mhz_reg]
apply_cdc_to_bit $to_keep
set to_keep [get_keepers -nowarn *cpl_pending_status_cdc*vf_trans_pending_status_vfi_250mhz_reg[*]]
apply_cdc_to_bit $to_keep
set to_keep [get_keepers -nowarn *update_ack_sync*first_stage_reg]
apply_cdc_to_bit $to_keep
set to_keep [get_keepers -nowarn *flr_set_sync*first_stage_reg]
apply_cdc_to_bit $to_keep
set to_keep [get_keepers -nowarn *flr_cdc*flr_vf_set_num_500mhz_reg[*]]
apply_cdc_to_bit $to_keep
set to_keep [get_keepers -nowarn *flr_cdc*flr_pf_done_500mhz_firstreg[*]]
apply_cdc_to_bit $to_keep
set to_keep [get_keepers -nowarn *flr_cdc*flr_vf_set_vf_num_500mhz_reg[*]]
apply_cdc_to_bit $to_keep
set to_keep [get_keepers -nowarn *flr_cdc*flr_vf_set_pf_num_500mhz_reg[*]]
apply_cdc_to_bit $to_keep

set from_keep [get_keepers -nowarn *ceb_cdc*heldconstantin250mhz_reg[*]]
if {[llength [query_collection -report -all $from_keep]] > 0} {
  foreach_in_collection from_keep $from_keep {
    #set node_name [get_node_info -name $from_keep]
    #set from_keep [get_keepers $node_name]
    apply_cdc_from_bit $from_keep
  }
}
##########################################################################################################################################
#CDC for the DMA IP

set from_keep [get_keepers *cdt_converter|*buf_lim*]
if {[llength [query_collection -report -all $from_keep]] > 0} {
  foreach_in_collection from_keep $from_keep {
    #set node_name [get_node_info -name $from_keep]
    #set from_keep [get_keepers $node_name]
    apply_cdc_from_bit $from_keep
  }
}

set from_keep [get_keepers *altera_pcie_s10_hip_ast_pipen1b_inst|*mps*]
if {[llength [query_collection -report -all $from_keep]] > 0} {
  foreach_in_collection from_keep $from_keep {
    #set node_name [get_node_info -name $from_keep]
    #set from_keep [get_keepers $node_name]
    apply_cdc_from_bit $from_keep
  }
}

set from_keep [get_keepers *altera_pcie_s10_hip_ast_pipen1b_inst|*mrs*]
if {[llength [query_collection -report -all $from_keep]] > 0} {
  foreach_in_collection from_keep $from_keep {
    #set node_name [get_node_info -name $from_keep]
    #set from_keep [get_keepers $node_name]
    apply_cdc_from_bit $from_keep
  }
}

##########################################################################################################################################
#CDC for cdts_fifo
proc apply_sdc_dcfifo {hier_path} {
# gray_rdptr
apply_sdc_dcfifo_rdptr $hier_path
# gray_wrptr
apply_sdc_dcfifo_wrptr $hier_path
}
#
# common constraint setting proc
#
proc apply_sdc_dcfifo_for_ptrs {from_node_list to_node_list} {
# control skew for bits
set_max_skew -from $from_node_list -to $to_node_list -get_skew_value_from_clock_period src_clock_period -skew_value_multiplier 0.8
# path delay (exception for net delay)
if { ![string equal "quartus_syn" $::TimeQuestInfo(nameofexecutable)] } {
set_net_delay -from $from_node_list -to $to_node_list -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
}
#relax setup and hold calculation
set_max_delay -from $from_node_list -to $to_node_list 100
set_min_delay -from $from_node_list -to $to_node_list -100
}
#
# mstable propgation delay
#
proc apply_sdc_dcfifo_mstable_delay {from_node_list to_node_list} {
# mstable delay
if { ![string equal "quartus_syn" $::TimeQuestInfo(nameofexecutable)] } {
set_net_delay -from $from_node_list -to $to_node_list -max -get_value_from_clock_period dst_clock_period -value_multiplier 0.8
}
}
#
# rdptr constraints
#
proc apply_sdc_dcfifo_rdptr {hier_path} {
# get from and to list
set from_node_list [get_keepers -nowarn $hier_path|auto_generated|*rdptr_g*]
set to_node_list [get_keepers -nowarn $hier_path|auto_generated|ws_dgrp|dffpipe*|dffe*]
if {[llength [query_collection -report -all $from_node_list]] > 0 && [llength [query_collection -report -all $to_node_list]] > 0} {
  apply_sdc_dcfifo_for_ptrs $from_node_list $to_node_list
}
# mstable
set from_node_mstable_list [get_keepers -nowarn $hier_path|auto_generated|ws_dgrp|dffpipe*|dffe*]
set to_node_mstable_list [get_keepers -nowarn $hier_path|auto_generated|ws_dgrp|dffpipe*|dffe*]
if {[llength [query_collection -report -all $from_node_mstable_list]] > 0 && [llength [query_collection -report -all $to_node_mstable_list]] > 0} {
  apply_sdc_dcfifo_mstable_delay $from_node_mstable_list $to_node_mstable_list
}
}
#
# wrptr constraints
#
proc apply_sdc_dcfifo_wrptr {hier_path} {
# control skew for bits
set from_node_list [get_keepers -nowarn $hier_path|auto_generated|delayed_wrptr_g*]
set to_node_list [get_keepers -nowarn $hier_path|auto_generated|rs_dgwp|dffpipe*|dffe*]
if {[llength [query_collection -report -all $from_node_list]] > 0 && [llength [query_collection -report -all $to_node_list]] > 0} {
  apply_sdc_dcfifo_for_ptrs $from_node_list $to_node_list
}
# mstable
set from_node_mstable_list [get_keepers -nowarn $hier_path|auto_generated|rs_dgwp|dffpipe*|dffe*]
set to_node_mstable_list [get_keepers -nowarn $hier_path|auto_generated|rs_dgwp|dffpipe*|dffe*]
if {[llength [query_collection -report -all $from_node_mstable_list]] > 0 && [llength [query_collection -report -all $to_node_mstable_list]] > 0} {
  apply_sdc_dcfifo_mstable_delay $from_node_mstable_list $to_node_mstable_list
}
}

# proc apply_sdc_pre_dcfifo {entity_name} {

# set inst_list [get_entity_instances $entity_name]

# foreach each_inst $inst_list {

        # apply_sdc_dcfifo ${each_inst} 

    # }
# }
set fifo_loc *altera_pcie_s10_gen3x16_adapter_inst|u_credit_if|cdts_fifo*
apply_sdc_dcfifo $fifo_loc

set fifo_loc *altera_pcie_s10_hip_ast_pipen1b_inst|pf_flr_snoop|dcfifo_component*
apply_sdc_dcfifo $fifo_loc
#apply_sdc_pre_dcfifo dcfifo
##########################################################################################################################################
set_max_delay -to [get_keepers -nowarn {*|flr_rcvd_sync|first_stage_reg*}] 6ns
set_max_delay -to [get_keepers -nowarn {*|pf_flr_active_reg[*]*}] 6ns
set_max_delay -to [get_keepers -nowarn {*|pf*_flr_array|pf_flr_frame_sreg*}] 6ns
set_max_delay -to [get_keepers -nowarn {*|pf*_flr_array|init_counter[*]*}] 6ns

