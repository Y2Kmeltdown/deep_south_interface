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


if {[info exists clk_source_freq]} {
  unset clk_source_freq
}

if {[info exists multiply_factor_dict] } {
  unset multiply_factor_dict
}
set multiply_factor_dict [dict create]

if {[info exists divide_factor_dict] } {
  unset divide_factor_dict
}
set divide_factor_dict [dict create]

set clk_source_freq "250.0 MHz"

set datarate_100m  80

# 250M for aibx2 clocks if BW less or equal 32G
if { [expr $datarate_100m * 16] <= 320 }  {
  dict set multiply_factor_dict aib_internal_div 1
  dict set divide_factor_dict   aib_internal_div 1
  dict set multiply_factor_dict clkout 1
  dict set divide_factor_dict   clkout 2

# 500M for  aibx2 clocks if BW less or equal 64G
} elseif { [expr $datarate_100m * 16] <= 640 }  {
  dict set multiply_factor_dict aib_internal_div 2
  dict set divide_factor_dict   aib_internal_div 1
  dict set multiply_factor_dict clkout 1
  dict set divide_factor_dict   clkout 1

# 1000M for  aibx2 clocks if BW is 128G
} else {
  dict set multiply_factor_dict aib_internal_div 4
  dict set divide_factor_dict   aib_internal_div 1
  dict set multiply_factor_dict clkout 2
  dict set divide_factor_dict   clkout 1
}


# Get the current Native PCIe IP instance
set inst [get_current_instance]

# Check the tile type
set native_phy_tile_nodes ""
set pcie_tile_type H-Tile
if {$pcie_tile_type == "L-Tile"} {
  set native_phy_tile_nodes "ct1_xcvr_native_inst|ct1_xcvr_native_inst|inst_ct1_xcvr_channel"
} else {
  set native_phy_tile_nodes "ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst"
}

# Delete the clock names array if it exists 
if [info exists all_clocks_names] {
  unset all_clocks_names
}
set all_clocks_names [dict create]

#--------------------------------------------- #
#---                                       --- #
#--- CREATE PCIe CLOCKS                    --- #
#---                                       --- #
#--------------------------------------------- #
for { set channels 0 } { $channels < 16 } { incr channels } {

  # ----------------------------------------------------------------------------- #
  # --- Create TX mode clocks and clock frequencies                           --- #
  # ----------------------------------------------------------------------------- #
  set aib_tx_clk_source_nodes  [get_nodes     -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx~aib_tx_clk_source]
  set aib_tx_internal_div_regs [get_registers -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx~aib_tx_internal_div.reg]

  if {[get_collection_size $aib_tx_clk_source_nodes] > 0 && [get_collection_size $aib_tx_internal_div_regs] > 0} {

    # -------------------------------------------------------------------------------
    # AIB TX CLK SOURCE - PMA parallel clock
    # -------------------------------------------------------------------------------
    foreach_in_collection tx_clk_source $aib_tx_clk_source_nodes {

      # Remove the instance name from the clock source node due to auto promotion in SDC_ENTITY
      set no_inst_tx_clk_source [string replace [get_node_info -name $tx_clk_source] 0 [string length $inst]]

      # Create the TX PMA parallel clock name
      set tx_clk_source_name $inst|tx_pma_parallel_clk|ch${channels}

      create_clock \
        -name $tx_clk_source_name \
        -period $clk_source_freq \
        $no_inst_tx_clk_source -add

      dict lappend all_clocks_names tx_source_clks $tx_clk_source_name

      # -------------------------------------------------------------------------------
      # AIB TX INTERNAL DIV REG - transfer clock
      # -------------------------------------------------------------------------------
      foreach_in_collection tx_internal_div_reg $aib_tx_internal_div_regs {

        # Remove the instance name from the internal div reg node due to auto promotion in SDC_ENTITY
        set no_inst_tx_internal_div_reg [string replace [get_node_info -name $tx_internal_div_reg] 0 [string length $inst]]

        # Create the TX PCS x2 clock name
        set tx_internal_div_reg_name $inst|tx_pcs_x2_clk|ch${channels}

        create_generated_clock \
          -name $tx_internal_div_reg_name \
          -source $no_inst_tx_clk_source \
          -master_clock $tx_clk_source_name \
          -multiply_by [dict get $multiply_factor_dict aib_internal_div] \
          -divide_by   [dict get $divide_factor_dict   aib_internal_div] \
          $no_inst_tx_internal_div_reg -add

        # -------------------------------------------------------------------------------
        # TX CLKOUT
        # -------------------------------------------------------------------------------
        set pld_pcs_tx_clkout_pins [get_pins -nowarn -compat altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_clk_out1_dcm]

        if {[get_collection_size $pld_pcs_tx_clkout_pins] > 0} {

          foreach_in_collection tx_clkout $pld_pcs_tx_clkout_pins {

            # Remove the instance name from the output clock node due to auto promotion in SDC_ENTITY
            set no_inst_tx_clkout [string replace [get_node_info -name $tx_clkout] 0 [string length $inst]]

            create_generated_clock \
              -name  $inst|xcvr_hip_native|ch${channels} \
              -source $no_inst_tx_clk_source \
              -master_clock $tx_clk_source_name \
              -multiply_by [dict get $multiply_factor_dict clkout] \
              -divide_by   [dict get $divide_factor_dict   clkout] \
              $no_inst_tx_clkout -add
          }
        }
      }; # foreach in collection aib_tx_internal_div_regs
    }; # foreach in collection aib_tx_clk_source_nodes
  }; # if get_collection_size aib_tx_clk_source_nodes && aib_tx_internal_div_regs


  # ----------------------------------------------------------------------------- #
  # --- Create RX mode clocks and clock frequencies                           --- #
  # ----------------------------------------------------------------------------- #
  set aib_rx_clk_source_nodes  [get_nodes -nowarn     altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx~aib_rx_clk_source]
  set aib_rx_internal_div_regs [get_registers -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx~aib_rx_internal_div.reg]

  if {[get_collection_size $aib_rx_clk_source_nodes] > 0 && [get_collection_size $aib_rx_internal_div_regs] > 0} {

    # -------------------------------------------------------------------------------
    # AIB RX CLK SOURCE - PMA parallel clock
    # -------------------------------------------------------------------------------
    foreach_in_collection rx_clk_source $aib_rx_clk_source_nodes {

      # Remove the instance name from the clock source node due to auto promotion in SDC_ENTITY
      set no_inst_rx_clk_source [string replace [get_node_info -name $rx_clk_source] 0 [string length $inst]]

      # Create the RX PMA parallel clock name
      set rx_clk_source_name $inst|rx_pma_parallel_clk|ch${channels}

      create_clock \
        -name $rx_clk_source_name \
        -period $clk_source_freq \
        $no_inst_rx_clk_source -add

      dict lappend all_clocks_names rx_source_clks $rx_clk_source_name

      # -------------------------------------------------------------------------------
      # AIB RX INTERNAL DIV REG - transfer clock
      # -------------------------------------------------------------------------------
      foreach_in_collection rx_internal_div_reg $aib_rx_internal_div_regs {

        # Remove the instance name from the internal div reg node due to auto promotion in SDC_ENTITY
        set no_inst_rx_internal_div_reg [string replace [get_node_info -name $rx_internal_div_reg] 0 [string length $inst]]

        # Create the rX PCS x2 clock name
        set rx_internal_div_reg_name $inst|rx_pcs_x2_clk|ch${channels}

        create_generated_clock \
          -name $rx_internal_div_reg_name \
          -source $no_inst_rx_clk_source \
          -master_clock $rx_clk_source_name \
          -multiply_by [dict get $multiply_factor_dict aib_internal_div] \
          -divide_by   [dict get $divide_factor_dict   aib_internal_div] \
          $no_inst_rx_internal_div_reg -add

        # -------------------------------------------------------------------------------
        # RX CLKOUT
        # -------------------------------------------------------------------------------
        set pld_pcs_rx_clkout_pins [get_pins -nowarn -compat altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|pld_pcs_rx_clk_out1_dcm]

        if {[get_collection_size $pld_pcs_rx_clkout_pins] > 0} {

          foreach_in_collection rx_clkout $pld_pcs_rx_clkout_pins {

            # Remove the instance name from the output clock node due to auto promotion in SDC_ENTITY
            set no_inst_rx_clkout [string replace [get_node_info -name $rx_clkout] 0 [string length $inst]]

            create_generated_clock \
              -name  $inst|xcvr_hip_native|ch${channels} \
              -source $no_inst_rx_clk_source \
              -master_clock $rx_clk_source_name \
              -multiply_by [dict get $multiply_factor_dict clkout] \
              -divide_by   [dict get $divide_factor_dict   clkout] \
              $no_inst_rx_clkout -add
          }
        }
      }; #foreach in collection aib_rx_internal_div_regs
    }; # foreach in collection aib_rx_clk_source_nodes
  }; # if get_collection_size aib_rx_clk_source_nodes && aib_rx_internal_div_regs


  #--------------------------------------------- #
  #---                                       --- #
  #--- MIN & MAX DELAYS FOR RESETS           --- #
  #---                                       --- #
  #--------------------------------------------- #
  set rx_digital_aib_reset_reg   [get_registers -nowarn    altera_xcvr_pcie_hip_native_rx_aib_reset_seq|aib_reset_out_stage*]
  set rx_pld_adapter_reset_atom  [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|pld_adapter_rx_pld_rst_n]
  set rx_pld_adapter_reset_pins  [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|pld_adapter_rx_pld_rst_n*]
  set rx_pld_dll_lock_req_atom   [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|pld_rx_dll_lock_req]
  set rx_pld_dll_lock_req_pins   [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|pld_rx_dll_lock_req*]

  if {[get_collection_size $rx_digital_aib_reset_reg] > 0 && [get_collection_size $rx_pld_adapter_reset_atom] > 0} {
    set_max_delay -from $rx_digital_aib_reset_reg -through $rx_pld_adapter_reset_atom 200
    set_min_delay -from $rx_digital_aib_reset_reg -through $rx_pld_adapter_reset_atom -5
  }

  if {[get_collection_size $rx_digital_aib_reset_reg] > 0 && [get_collection_size $rx_pld_dll_lock_req_atom] > 0 && [get_collection_size $rx_pld_dll_lock_req_pins] > 0} {
    set_max_delay -from $rx_digital_aib_reset_reg -through $rx_pld_dll_lock_req_atom -to $rx_pld_dll_lock_req_pins 200
    set_min_delay -from $rx_digital_aib_reset_reg -through $rx_pld_dll_lock_req_atom -to $rx_pld_dll_lock_req_pins -5
  }

  set tx_digital_aib_reset_reg   [get_registers -nowarn    altera_xcvr_pcie_hip_native_tx_aib_reset_seq|aib_reset_out_stage*]
  set tx_pld_adapter_reset_atom  [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n]
  set tx_pld_adapter_reset_pins  [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n*]
  set tx_pld_dll_lock_req_atom   [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|pld_tx_dll_lock_req]
  set tx_pld_dll_lock_req_pins   [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|pld_tx_dll_lock_req*]

  if {[get_collection_size $tx_digital_aib_reset_reg] > 0 && [get_collection_size $tx_pld_adapter_reset_atom] > 0} {
    set_max_delay -from $tx_digital_aib_reset_reg -through $tx_pld_adapter_reset_atom 200
    set_min_delay -from $tx_digital_aib_reset_reg -through $tx_pld_adapter_reset_atom -5
  }

  if {[get_collection_size $tx_digital_aib_reset_reg] > 0 && [get_collection_size $tx_pld_dll_lock_req_atom] > 0 && [get_collection_size $tx_pld_dll_lock_req_pins] > 0} {
    set_max_delay -from $tx_digital_aib_reset_reg -through $tx_pld_dll_lock_req_atom -to $tx_pld_dll_lock_req_pins 200
    set_min_delay -from $tx_digital_aib_reset_reg -through $tx_pld_dll_lock_req_atom -to $tx_pld_dll_lock_req_pins -5
  }

  #-------------------------------------------------- #
  #---                                            --- #
  #--- Internal loopback path                     --- #
  #---                                            --- #
  #-------------------------------------------------- #
  set pld_tx_clk2_dcm_reg_col        [get_registers    -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx~pld_tx_clk2_dcm.reg]
  set aib_fabric_tx_data_lpbk_col    [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx*aib_fabric_tx_data_lpbk*]
  set aib_fabric_rx_transfer_clk_col [get_registers    -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx~aib_fabric_rx_transfer_clk.reg]
  set aib_fabric_pma_aib_tx_clk_col  [get_registers    -nowarn altera_xcvr_hip_channel_s10_ch${channels}|altera_xcvr_pcie_hip_channel_s10_ch${channels}|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx~aib_fabric_pma_aib_tx_clk.reg]
  set pld_tx_clk1_dcm_reg_col        [get_registers    -nowarn g_xcvr_native_insts[*].ct1_xcvr_native_inst|ct1_xcvr_native_inst|inst_ct1_xcvr_channel|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx~pld_tx_clk1_dcm.reg]


  # Cut paths for internal loopback paths when bonding is enabled
  if {[get_collection_size $pld_tx_clk2_dcm_reg_col] > 0 && [get_collection_size $aib_fabric_tx_data_lpbk_col] > 0 && [get_collection_size $aib_fabric_rx_transfer_clk_col] > 0} {
    set_false_path -from $pld_tx_clk2_dcm_reg_col -through $aib_fabric_tx_data_lpbk_col -to $aib_fabric_rx_transfer_clk_col
  }

  # Cut the paths for the internal loopback paths
  if {[get_collection_size $aib_fabric_pma_aib_tx_clk_col] > 0 && [get_collection_size $aib_fabric_tx_data_lpbk_col] > 0 && [get_collection_size $aib_fabric_rx_transfer_clk_col] > 0} {
    set_false_path -from $aib_fabric_pma_aib_tx_clk_col -through $aib_fabric_tx_data_lpbk_col -to $aib_fabric_rx_transfer_clk_col
  }
  if {[get_collection_size $pld_tx_clk1_dcm_reg_col] > 0 && [get_collection_size $aib_fabric_tx_data_lpbk_col] > 0 && [get_collection_size $aib_fabric_rx_transfer_clk_col] > 0} {
    set_false_path -from $pld_tx_clk1_dcm_reg_col -through $aib_fabric_tx_data_lpbk_col -to $aib_fabric_rx_transfer_clk_col
  }

}; # for channels


#-------------------------------------------------- #
#---                                            --- #
#--- Adjusting the min pulse width for          --- #
#--- coreclkin2 requirement to be               --- #
#--- frequency-dependent                        --- #
#---                                            --- #
#-------------------------------------------------- #
  
# Create dictionary of all the clocks and their nodes
set min_pulse_all_clocks_list [get_clock_list]
set min_pulse_all_clocks_nodes_dict [dict create]

foreach clk_name $min_pulse_all_clocks_list {
  set clk_node_col [get_clock_info -targets $clk_name]
      
  foreach_in_collection clk_node $clk_node_col {
    set clk_node_name [get_node_info -name $clk_node]
    dict set min_pulse_all_clocks_nodes_dict $clk_node_name $clk_name
  }
}

# -------------------------------------------------------------------------------
# TX coreclkin2
# -------------------------------------------------------------------------------
set tx_coreclkin2_col [get_pins -nowarn -compat altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[0].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|pld_tx_clk2_dcm]

# Get fanins for tx_coreclkin2
if {[get_collection_size $tx_coreclkin2_col] > 0} {
  set tx_coreclkin_fanin_col [get_fanins -clock -stop_at_clocks $tx_coreclkin2_col]
      
  # Find clock name on the fanin
  if {[get_collection_size $tx_coreclkin_fanin_col]} {
      
    foreach_in_collection fanin_node $tx_coreclkin_fanin_col {
      set fanin_node_name [get_node_info -name $fanin_node]

      if {[dict exists $min_pulse_all_clocks_nodes_dict $fanin_node_name]} {
   	    set fanin_clock_name [dict get $min_pulse_all_clocks_nodes_dict $fanin_node_name]
        set_active_clocks [remove_from_collection [get_active_clocks] [get_clocks $fanin_clock_name]]

        # Adjust the min pulse width requirement based on frequency
        add_ddr_report_command "native_pcie_check_special_min_pulse_xndluca {$fanin_clock_name}"
      }
    }
  }
}



#-------------------------------------------------- #
#---                                            --- #
#--- DISABLE MIN_PULSE_WIDTH CHECK              --- #
#---                                            --- #
#-------------------------------------------------- #
# Disable min_width_pulse for TX source clocks
if {[dict exists $all_clocks_names tx_source_clks]} {
  set tx_source_clks_list [dict get $all_clocks_names tx_source_clks]
  foreach tx_src_clk $tx_source_clks_list {
    disable_min_pulse_width $tx_src_clk
  }
}

# Disable min_width_pulse for RX source clocks
if {[dict exists $all_clocks_names rx_source_clks]} {
  set rx_source_clks_list [dict get $all_clocks_names rx_source_clks]
  foreach rx_src_clk $rx_source_clks_list {
    disable_min_pulse_width $rx_src_clk
  }
}

#-------------------------------------------------- #
#---                                            --- #
#--- SET_FALSE_PATH for TX and RX BONDING       --- #
#---                                            --- #
#-------------------------------------------------- #

# Remove all paths for TX bonding signals


# Remove all paths for RX bonding signals if in PIPE mode (Native PCIe IP covers the case for PCIe)
set aib_fabric_rx_transfer_clk_col [get_registers    -nowarn altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx~aib_fabric_rx_transfer_clk.reg]
set bond_rx_fifo_us_out_wren_col   [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|bond_rx_fifo_us_out_wren]
set bond_rx_fifo_ds_in_wren_col    [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|bond_rx_fifo_ds_in_wren]
set bond_rx_fifo_ds_out_wren_col   [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|bond_rx_fifo_ds_out_wren]
set bond_rx_fifo_us_in_wren_col    [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|bond_rx_fifo_us_in_wren]

set pld_rx_clk_dcm_reg_col       [get_registers    -nowarn altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx~pld_rx_clk*_dcm.reg]
set bond_rx_fifo_us_out_rden_col [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|bond_rx_fifo_us_out_rden]
set bond_rx_fifo_ds_in_rden_col  [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|bond_rx_fifo_ds_in_rden]
set bond_rx_fifo_ds_out_rden_col [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|bond_rx_fifo_ds_out_rden]
set bond_rx_fifo_us_in_rden_col  [get_pins -compat -nowarn altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].${native_phy_tile_nodes}|gen_ct1_hssi_pldadapt_rx.inst_ct1_hssi_pldadapt_rx|bond_rx_fifo_us_in_rden]

if {[get_collection_size $aib_fabric_rx_transfer_clk_col] > 0 &&  [get_collection_size $bond_rx_fifo_us_out_wren_col] > 0 && [get_collection_size $bond_rx_fifo_ds_in_wren_col] > 0} {    
  set_false_path -from $aib_fabric_rx_transfer_clk_col -through $bond_rx_fifo_us_out_wren_col -through $bond_rx_fifo_ds_in_wren_col -to $aib_fabric_rx_transfer_clk_col
}

if {[get_collection_size $aib_fabric_rx_transfer_clk_col] > 0 &&  [get_collection_size $bond_rx_fifo_ds_out_wren_col] > 0 && [get_collection_size $bond_rx_fifo_us_in_wren_col] > 0} {    
  set_false_path -from $aib_fabric_rx_transfer_clk_col -through $bond_rx_fifo_ds_out_wren_col -through $bond_rx_fifo_us_in_wren_col -to $aib_fabric_rx_transfer_clk_col
}

if {[get_collection_size $pld_rx_clk_dcm_reg_col] > 0 &&  [get_collection_size $bond_rx_fifo_us_out_rden_col] > 0 && [get_collection_size $bond_rx_fifo_ds_in_rden_col] > 0} {    
  set_false_path -from $pld_rx_clk_dcm_reg_col  -through $bond_rx_fifo_us_out_rden_col -through $bond_rx_fifo_ds_in_rden_col -to $pld_rx_clk_dcm_reg_col
}

if {[get_collection_size $pld_rx_clk_dcm_reg_col] > 0 &&  [get_collection_size $bond_rx_fifo_ds_out_rden_col] > 0 && [get_collection_size $bond_rx_fifo_us_in_rden_col] > 0} {    
  set_false_path -from  $pld_rx_clk_dcm_reg_col -through $bond_rx_fifo_ds_out_rden_col -through $bond_rx_fifo_us_in_rden_col -to $pld_rx_clk_dcm_reg_col
}

#--------------------------------------------- #
#---                                       --- #
#--- SET_FALSE_PATH to reset synchronizers --- #
#---                                       --- #
#--------------------------------------------- #
set reset_synchronizer_pins {
  altera_xcvr_pcie_hip_native_tx_aib_reset_seq|reset_synchronizers|resync_chains[*].synchronizer_nocut|din_s1
  altera_xcvr_pcie_hip_native_tx_aib_reset_seq|transfer_ready_synchronizers|resync_chains[*].synchronizer_nocut|din_s1
  altera_xcvr_pcie_hip_native_rx_aib_reset_seq|reset_synchronizers|resync_chains[*].synchronizer_nocut|din_s1
  altera_xcvr_pcie_hip_native_rx_aib_reset_seq|transfer_ready_synchronizers|resync_chains[*].synchronizer_nocut|din_s1
}

foreach reset_reg $reset_synchronizer_pins {
  set synch_reg [get_registers -nowarn $reset_reg]
  if { [get_collection_size $synch_reg ] > 0 } {
    set_false_path -to $synch_reg
  }
}

# -------------------------------------------------------------------------------------------------- #
# --- set false path for adjacent channel connections introduced by clock skew control modeling  --- #
# -------------------------------------------------------------------------------------------------- #
set aib_tx_internal_div_reg_nodes   altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx~aib_tx_internal_div.reg
set aib_fabric_transfer_clk_nodes   altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts[*].ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx~*aib_fabric_tx_transfer_clk.reg
set_false_path -from $aib_tx_internal_div_reg_nodes -to $aib_fabric_transfer_clk_nodes


#-------------------------------------------------- #
#---                                            --- #
#--- DISABLE MIN_PULSE_WIDTH CHECK on fPLL      --- #
#---                                            --- #
#-------------------------------------------------- #

# Disable min_width_pulse for fPLL counter nodes
set all_ports_list [get_ports *]
foreach_in_collection port $all_ports_list {

  set fpll_counter_nodes_list [get_nodes -nowarn [get_node_info -name $port]~inputFITTER_INSERTED_FITTER_INSERTED~fpll_c?_div]

  if {[get_collection_size $fpll_counter_nodes_list] > 0} {
    foreach_in_collection fpll_counter_node $fpll_counter_nodes_list {
      disable_min_pulse_width [get_node_info -name $fpll_counter_node]
    }
  }
}

msg_vdebug "IP SDC: End of PCIe Native PHY IP SDC file!"

# ----------------------------------------------------------------------------- #
# ---                                                                       --- #
# --- Procedure to adjust min pulse requirement for coreclkin2 to be        --- #
# --- frequency-dependency                                                  --- #
# ---                                                                       --- #
# ----------------------------------------------------------------------------- #
proc native_pcie_check_special_min_pulse_xndluca { clock_name } {
  set pass 1  

  # Find old active clocks, and then set all clocks active
  set old_active_clocks [get_active_clocks]
  set_active_clocks [all_clocks]
  
  set clock_spec_collection [get_clocks $clock_name]
  foreach_in_collection clock_spec $clock_spec_collection { }

  # Get clock period
  set period [get_clock_info -period $clock_spec]
  set frequency [expr 1 / $period * 1000]
  
  # Determine min pulse adjustment
  set frequency_list [list 0.0         501.0              600.0                 700.0                 800.0                 900.0                1000.0]
  set min_pulse_list [list 0.0 [expr 400.0-400.0] [expr 400.0 - 366.7]  [expr 400.0 - 342.9] [expr 400.0 - 325.0]  [expr 400.0 - 311.1] [expr 400.0 - 300.0] ]
  
  # Determine min pulse spec adjustment
  set i 0
  set min_pulse_adjustment 0.0 
  foreach xfreq $frequency_list {
     if { $frequency <= $xfreq } {
        set min_pulse_adjustment [lindex $min_pulse_list [expr $i - 1]]
        break
     }
     incr i
  }
  
  # Get min pulse information
  set min_pulse_info [get_min_pulse_width $clock_name]
  set min_pulse_slack [lindex [lindex $min_pulse_info 0] 0]

  # If after the adjusment we are still negative, then output the min pulse report, and indicate the failure
  if {[expr $min_pulse_slack + $min_pulse_adjustment] < 0 } {
     report_min_pulse_width -nworst 100 -detail full_path -panel_name "Minimum Pulse Width: $clock_name" [get_clocks $clock_name]
     post_message -type critical_warning "Min Pulse Requirements on Tile Transfer not met; see DDR report for more details"
     set pass 0
  }

  # Also make sure, nothing else is connected on this clock domain
  set setup_from_paths_col    [get_timing_paths -from $clock_spec -setup]
  set setup_to_paths_col      [get_timing_paths -to   $clock_spec -setup]
  set hold_from_paths_col     [get_timing_paths -from $clock_spec -hold]
  set hold_to_paths_col       [get_timing_paths -to   $clock_spec -hold]
  set recovery_from_paths_col [get_timing_paths -from $clock_spec -recovery]
  set recovery_to_paths_col   [get_timing_paths -to   $clock_spec -recovery]
  set removal_from_paths_col  [get_timing_paths -from $clock_spec -removal]
  set removal_to_paths_col    [get_timing_paths -to   $clock_spec -removal]

  set num_setup_from_paths    [get_collection_size $setup_from_paths_col]
  set num_setup_to_paths      [get_collection_size $setup_to_paths_col]
  set num_hold_from_paths     [get_collection_size $hold_from_paths_col]
  set num_hold_to_paths       [get_collection_size $hold_to_paths_col]
  set num_recovery_from_paths [get_collection_size $recovery_from_paths_col]
  set num_recovery_to_paths   [get_collection_size $recovery_to_paths_col]
  set num_removal_from_paths  [get_collection_size $removal_from_paths_col]
  set num_removal_to_paths    [get_collection_size $removal_to_paths_col]


  if {($num_setup_from_paths > 0) || ($num_setup_to_paths > 0) || ($num_hold_from_paths > 0) || ($num_hold_to_paths > 0) || ($num_recovery_from_paths > 0) || ($num_recovery_to_paths > 0) || ($num_removal_from_paths > 0) || ($num_removal_to_paths > 0)} {
     set pass 1

     # ----------------------------------------------------
     # Print out path information for SETUP FROM paths
     # ----------------------------------------------------
     if { $num_setup_from_paths > 0 } {

       # Initialize the number of found bond fifo paths from zero
       set num_bond_fifo_setup_paths 0

       foreach_in_collection path $setup_from_paths_col {

         # Check the arrival path points to see if one of them is the one of the bond_fifo pins (we should ignore this transfer)
         set arrival_pts_col [get_path_info -arrival_points $path]
         set found_bond_fifo_setup_path 0

         foreach_in_collection point $arrival_pts_col {

           # Only check the node points
           set pt_node_id [get_point_info -node $point]

           if { $pt_node_id != "" } {
             set pt_node_name [get_node_info -name $pt_node_id]
             set ds_out_rden_pin_regex "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_ds_out_rden"
             set us_out_rden_pin_regex "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_us_out_rden"
             set ds_out_dv_pin_regex   "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_ds_out_dv"
             set us_out_dv_pin_regex   "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_us_out_dv"


             if { [string match $ds_out_rden_pin_regex $pt_node_name] || [string match $us_out_rden_pin_regex $pt_node_name] || [string match $ds_out_dv_pin_regex $pt_node_name] || [string match $us_out_dv_pin_regex $pt_node_name] } {
               # Increment the number of found bond_fifo setup paths
               incr found_bond_fifo_setup_path
               incr num_bond_fifo_setup_paths
               break
             }

           }
         }; #foreach point in arrival_pts_col

         # Print out the path info if no bond_fifo path was found
         if { $found_bond_fifo_setup_path == 0 } {
           set source_node [get_node_info  -name [get_path_info -from $path]]
           set dest_node   [get_node_info  -name [get_path_info -to $path]]
           set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
           set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
           post_message -type critical_warning "Unexpected timed setup path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
         }
       }; #foreach path in setup_from_paths_col

       # If the number of bond_fifo paths found matches the number of setup paths, then we can ignore the transfers
       if { $num_bond_fifo_setup_paths != $num_setup_from_paths } {
         set pass 0
       }
     }

     # ----------------------------------------------------
     # Print out path information for SETUP TO paths
     # ----------------------------------------------------
     if { $num_setup_to_paths > 0 } {

       # Initialize the number of found bond fifo paths to zero
       set num_bond_fifo_setup_paths 0

       foreach_in_collection path $setup_to_paths_col {

         # Check the arrival path points to see if one of them is one of the bond_fifo pins (we should ignore this transfer)
         set arrival_pts_col [get_path_info -arrival_points $path]
         set found_bond_fifo_setup_path 0

         foreach_in_collection point $arrival_pts_col {

           # Only check the node points
           set pt_node_id [get_point_info -node $point]

           if { $pt_node_id != "" } {
             set pt_node_name [get_node_info -name $pt_node_id]
             set ds_out_rden_pin_regex "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_ds_out_rden"
             set us_out_rden_pin_regex "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_us_out_rden"
             set ds_out_dv_pin_regex   "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_ds_out_dv"
             set us_out_dv_pin_regex   "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_us_out_dv"


             if { [string match $ds_out_rden_pin_regex $pt_node_name] || [string match $us_out_rden_pin_regex $pt_node_name] || [string match $ds_out_dv_pin_regex $pt_node_name] || [string match $us_out_dv_pin_regex $pt_node_name] } {
               # Increment the number of found bond_fifo setup paths
               incr found_bond_fifo_setup_path
               incr num_bond_fifo_setup_paths
               break
             }

           }
         }; #foreach point in arrival_pts_col

         # Print out the path info if no bond_fifo path was found
         if { $found_bond_fifo_setup_path == 0 } {
           set source_node [get_node_info  -name [get_path_info -from $path]]
           set dest_node   [get_node_info  -name [get_path_info -to $path]]
           set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
           set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
           post_message -type critical_warning "Unexpected timed setup path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
         }
       }; #foreach path in setup_to_paths_col

       # If the number of bond_fifo paths found matches the number of setup paths, then we can ignore the transfers
       if { $num_bond_fifo_setup_paths != $num_setup_to_paths } {
         set pass 0
       }
     }

     # ----------------------------------------------------
     # Print out path information for HOLD FROM paths
     # ----------------------------------------------------
     if { $num_hold_from_paths > 0 } {

       # Initialize the number of found bond fifo paths from zero
       set num_bond_fifo_hold_paths 0

       foreach_in_collection path $hold_from_paths_col {

         # Check the arrival path points to see if one of them is the one of the bond_fifo pins (we should ignore this transfer)
         set arrival_pts_col [get_path_info -arrival_points $path]
         set found_bond_fifo_hold_path 0

         foreach_in_collection point $arrival_pts_col {

           # Only check the node points
           set pt_node_id [get_point_info -node $point]

           if { $pt_node_id != "" } {
             set pt_node_name [get_node_info -name $pt_node_id]
             set ds_out_rden_pin_regex "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_ds_out_rden"
             set us_out_rden_pin_regex "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_us_out_rden"
             set ds_out_dv_pin_regex   "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_ds_out_dv"
             set us_out_dv_pin_regex   "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_us_out_dv"


             if { [string match $ds_out_rden_pin_regex $pt_node_name] || [string match $us_out_rden_pin_regex $pt_node_name] || [string match $ds_out_dv_pin_regex $pt_node_name] || [string match $us_out_dv_pin_regex $pt_node_name] } {
               # Increment the number of found bond_fifo hold paths
               incr found_bond_fifo_hold_path
               incr num_bond_fifo_hold_paths
               break
             }

           }
         }; #foreach point in arrival_pts_col

         # Print out the path info if no bond_fifo path was found
         if { $found_bond_fifo_hold_path == 0 } {
           set source_node [get_node_info  -name [get_path_info -from $path]]
           set dest_node   [get_node_info  -name [get_path_info -to $path]]
           set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
           set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
           post_message -type critical_warning "Unexpected timed hold path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
         }
       }; #foreach path in hold_from_paths_col

       # If the number of bond_fifo paths found matches the number of hold paths, then we can ignore the transfers
       if { $num_bond_fifo_hold_paths != $num_hold_from_paths } {
         set pass 0
       }
     }

     # ----------------------------------------------------
     # Print out path information for HOLD TO paths
     # ----------------------------------------------------
     if { $num_hold_to_paths > 0 } {

       # Initialize the number of found bond fifo paths to zero
       set num_bond_fifo_hold_paths 0

       foreach_in_collection path $hold_to_paths_col {

         # Check the arrival path points to see if one of them is one of the bond_fifo pins (we should ignore this transfer)
         set arrival_pts_col [get_path_info -arrival_points $path]
         set found_bond_fifo_hold_path 0

         foreach_in_collection point $arrival_pts_col {

           # Only check the node points
           set pt_node_id [get_point_info -node $point]

           if { $pt_node_id != "" } {
             set pt_node_name [get_node_info -name $pt_node_id]
             set ds_out_rden_pin_regex "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_ds_out_rden"
             set us_out_rden_pin_regex "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_us_out_rden"
             set ds_out_dv_pin_regex   "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_ds_out_dv"
             set us_out_dv_pin_regex   "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|bond_tx_fifo_us_out_dv"


             if { [string match $ds_out_rden_pin_regex $pt_node_name] || [string match $us_out_rden_pin_regex $pt_node_name] || [string match $ds_out_dv_pin_regex $pt_node_name] || [string match $us_out_dv_pin_regex $pt_node_name] } {
               # Increment the number of found bond_fifo hold paths
               incr found_bond_fifo_hold_path
               incr num_bond_fifo_hold_paths
               break
             }

           }
         }; #foreach point in arrival_pts_col

         # Print out the path info if no bond_fifo path was found
         if { $found_bond_fifo_hold_path == 0 } {
           set source_node [get_node_info  -name [get_path_info -from $path]]
           set dest_node   [get_node_info  -name [get_path_info -to $path]]
           set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
           set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
           post_message -type critical_warning "Unexpected timed hold path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
         }
       }; #foreach path in hold_to_paths_col

       # If the number of bond_fifo paths found matches the number of hold paths, then we can ignore the transfers
       if { $num_bond_fifo_hold_paths != $num_hold_to_paths } {
         set pass 0
       }
     }

     # ----------------------------------------------------
     # Print out path information for RECOVERY FROM paths
     # ----------------------------------------------------
     if { $num_recovery_from_paths > 0 } {
       foreach_in_collection path $recovery_from_paths_col {
         set source_node [get_node_info  -name [get_path_info -from $path]]
         set dest_node   [get_node_info  -name [get_path_info -to $path]]
         set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
         set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
         post_message -type critical_warning "Unexpected timed recovery path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
       }

       # Set pass to zero
			 set pass 0

     }

     # ----------------------------------------------------
     # Print out path information for REMOVAL FROM paths
     # ----------------------------------------------------
     if { $num_removal_from_paths > 0 } {
       foreach_in_collection path $removal_from_paths_col {
         set source_node [get_node_info -name [get_path_info -from $path]]
         set dest_node   [get_node_info -name [get_path_info -to $path]]
         set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
         set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
         post_message -type critical_warning "Unexpected timed removal path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
       }

       # Set pass to zero
			 set pass 0

     }

     # ----------------------------------------------------
     # Print out path information for RECOVERY TO paths
     # ----------------------------------------------------
     if { $num_recovery_to_paths > 0 } {

       # Initialize the number of found reset paths to zero
       set num_reset_recovery_paths 0

       foreach_in_collection path $recovery_to_paths_col {

         # Check the arrival path points to see if one of them is the reset pin (we should ignore this transfer)
         set arrival_pts_col [get_path_info -arrival_points $path]
         set found_reset_recovery_path 0

         foreach_in_collection point $arrival_pts_col {

           # Only check the node points
           set pt_node_id [get_point_info -node $point]

           if { $pt_node_id != "" } {
             set pt_node_name [get_node_info -name $pt_node_id]
             set reset_pin_regex "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n"

             if {[string match $reset_pin_regex $pt_node_name]} {
               # Increment the number of found reset recovery paths
               incr found_reset_recovery_path
               incr num_reset_recovery_paths
               break
             }

           }
         }; #foreach point in arrival_pts_col

         # Print out the path info if no reset path was found
         if { $found_reset_recovery_path == 0 } {
           set source_node [get_node_info  -name [get_path_info -from $path]]
           set dest_node   [get_node_info  -name [get_path_info -to $path]]
           set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
           set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
           post_message -type critical_warning "Unexpected timed recovery path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
         }
       }; #foreach path in recovery_to_paths_col

       # If the number of reset paths found matches the number of recovery paths, then we can ignore the transfers
       if { $num_reset_recovery_paths != $num_recovery_to_paths } {
         set pass 0
       }
     }

     # ----------------------------------------------------
     # Print out path information for REMOVAL TO paths
     # ----------------------------------------------------
     if { $num_removal_to_paths > 0 } {

       # Initialize the number of found reset paths to zero
       set num_reset_removal_paths 0

       foreach_in_collection path $removal_to_paths_col {

         # Check the arrival path points to see if one of them is the reset pin (we should ignore this transfer)
         set arrival_pts_col [get_path_info -arrival_points $path]
         set found_reset_removal_path 0

         foreach_in_collection point $arrival_pts_col {

           # Only check the node points
           set pt_node_id [get_point_info -node $point]

           if { $pt_node_id != "" } {
             set pt_node_name [get_node_info -name $pt_node_id]
             set reset_pin_regex "*altera_xcvr_hip_channel_s10_ch*|altera_xcvr_pcie_hip_channel_s10_ch*|g_xcvr_native_insts*.ct2_xcvr_native_inst|inst_ct2_xcvr_channel_multi|gen_rev.ct2_xcvr_channel_inst|gen_ct1_hssi_pldadapt_tx.inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n"


             if {[string match $reset_pin_regex $pt_node_name]} {
               # Increment the number of found reset recovery paths
               incr found_reset_removal_path
               incr num_reset_removal_paths
               break
             }

           }
         }; #foreach point in arrival_pts_col

         # Print out the path info if no reset path was found
         if { $found_reset_removal_path == 0 } {
           set source_node [get_node_info  -name [get_path_info -from $path]]
           set dest_node   [get_node_info  -name [get_path_info -to $path]]
           set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
           set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
           post_message -type critical_warning "Unexpected timed removal path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
         }
       }; #foreach path in removal_to_paths_col

       # If the number of reset paths found matches the number of removal paths, then we can ignore the transfers
       if { $num_reset_removal_paths != $num_removal_to_paths } {
         set pass 0
       }
    }

  }; #if { num_setup_from_paths > 0 || ... || ... }
  
  # Check if min pulse width passed
  if { $pass == 0 } {
     post_message -type critical_warning "Timing requirements not met"
  }
  
  # Before returning set the active clocks to the ones that were active before entering this function 
  set_active_clocks $old_active_clocks 
}


