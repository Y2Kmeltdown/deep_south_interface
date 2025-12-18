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



set script_dir [file dirname [info script]]
source "$script_dir/hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_utils.tcl"

load_package sdc_ext

proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_get_ddr_pins { instname allpins var_array_name} {
   # We need to make a local copy of the allpins associative array
   upvar allpins pins
   upvar 1 $var_array_name var
   set debug 0

   set var(pll_inclock_search_depth) 30
   set var(pll_outclock_search_depth) 20
   set var(pll_vcoclock_search_depth) 5

   # ########################################
   #  1.0 find all of the PLL output clocks

   set c0_periph_clock_name "outclk\[0\]"
   set c1_periph_clock_name "outclk\[1\]"
   set vco_clock_name "vcoph\[0\]"
   set cpa_core_clk0_name "pa_core_clk_out\[0\]"
   set cpa_core_clk1_name "pa_core_clk_out\[1\]"
   set cpa_hr_clock_name "core_clk_u2f\[0\]"
   set cpa_fr_clock_name "core_clk_u2f\[1\]"
   
   #  C0 output in the periphery
   set pins(pll_c0_periph_clock) [list]
   set pins(pll_c0_periph_clock_id) [get_pins -nowarn [list ${instname}|arch_inst|pll_inst|pll_inst|uibpll_inst|stratix10_altera_iopll_i|s10_iopll.fourteennm_pll|${c0_periph_clock_name}]]
   foreach_in_collection c $pins(pll_c0_periph_clock_id) {
      lappend pins(pll_c0_periph_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }

   #  C1 output in the periphery
   set pins(pll_c1_periph_clock) [list]
   set pins(pll_c1_periph_clock_id) [get_pins -nowarn [list ${instname}|arch_inst|pll_inst|pll_inst|uibpll_inst|stratix10_altera_iopll_i|s10_iopll.fourteennm_pll|${c1_periph_clock_name}]]
   foreach_in_collection c $pins(pll_c1_periph_clock_id) {
      lappend pins(pll_c1_periph_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }

   #  VCO clock 
   set pins(vco_clock) [list]
   set pins(vco_clock_id) [get_pins -nowarn [list ${instname}|arch_inst|pll_inst|pll_inst|uibpll_inst|stratix10_altera_iopll_i|s10_iopll.fourteennm_pll|${vco_clock_name} ]]
   foreach_in_collection c $pins(vco_clock_id) {
      lappend pins(vco_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }
   
   #  CPA clock output
   set pins(cpa_core_clk0_clock) [list]  
   set pins(cpa_core_clk0_clock_id) [get_pins -nowarn [list ${instname}|arch_inst|cpa_inst|cpa_inst|${cpa_core_clk0_name} ]]
   foreach_in_collection c $pins(cpa_core_clk0_clock_id) {
      lappend pins(cpa_core_clk0_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }
   set pins(cpa_core_clk1_clock) [list]  
   set pins(cpa_core_clk1_clock_id) [get_pins -nowarn [list ${instname}|arch_inst|cpa_inst|cpa_inst|${cpa_core_clk1_name} ]]
   foreach_in_collection c $pins(cpa_core_clk1_clock_id) {
      lappend pins(cpa_core_clk1_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }

   #  CPA clock (used for the system clock)
   set pins(core_hr_usr_clock) [list]  
   set pins(core_hr_usr_clock_id) [get_pins -nowarn [list ${instname}|arch_inst|hbmc_inst|hbmc_inst|${cpa_hr_clock_name} ]]
   foreach_in_collection c $pins(core_hr_usr_clock_id) {
      lappend pins(core_hr_usr_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }
   set pins(core_fr_usr_clock) [list]  
   set pins(core_fr_usr_clock_id) [get_pins -nowarn [list ${instname}|arch_inst|hbmc_inst|hbmc_inst|${cpa_fr_clock_name} ]]
   foreach_in_collection c $pins(core_fr_usr_clock_id) {
      lappend pins(core_fr_usr_clock) [regsub {\\} [get_node_info -name $c] {\\\\}]
   }

   set pins(pll_vco_clock) $pins(vco_clock)
   set pins(pll_phy_clock) $pins(pll_c0_periph_clock)
   set pins(pll_phy_clock_l) $pins(pll_c1_periph_clock)

   if {$debug == 1} {
     puts "VCO:           $pins(pll_vco_clock)"
     puts "PHY:           $pins(pll_phy_clock)"
     puts "PHY_L:         $pins(pll_phy_clock_l)"
     puts "CPA HR clock:  $pins(core_hr_usr_clock)"
     puts "CPA FR clock:  $pins(core_fr_usr_clock)"
     puts ""
   }

   # ########################################
   #  2.0 Find other clocks pins

   set pins(pll_cascade_in_id) [get_pins -compatibility_mode ${instname}|arch_inst|pll_inst|pll_inst|uibpll_inst|stratix10_altera_iopll_i|s10_iopll.fourteennm_pll|pll_cascade_in]
   set pll_ref_clock_id [hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_get_input_clk_id $pins(pll_cascade_in_id) var]
   if {$pll_ref_clock_id == -1} {
      post_message -type critical_warning "hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_pin_map.tcl: Failed to find PLL reference clock"
   } else {
      set pll_ref_clock [get_node_info -name $pll_ref_clock_id]
   }
   set pins(pll_ref_clock) $pll_ref_clock
 
   set pins(ncntr_id) [get_keepers -nowarn ${instname}|arch_inst|pll_inst|pll_inst|uibpll_inst|stratix10_altera_iopll_i|s10_iopll.fourteennm_pll~ncntr_reg] 
   set pins(ncntr) ""
   if {[get_collection_size $pins(ncntr_id)] == 1} {
      set pins(ncntr) "${instname}|arch_inst|pll_inst|pll_inst|uibpll_inst|stratix10_altera_iopll_i|s10_iopll.fourteennm_pll~ncntr_reg"
   }

   set cal_clk "${instname}|arch_inst|uib_io_phy_inst|inst~*/xuibphy/cal_clk"
   set pins(cal_clk_id) [get_nodes -nowarn $cal_clk]
   set pins(cal_clk) ""
   if {[get_collection_size $pins(cal_clk_id)] == 1} {
      set pins(cal_clk) $cal_clk
   }

   if {$debug == 1} {
     puts "NCTR:    $pins(nctr)"
     puts "REF:     $pins(pll_ref_clock)"
     puts "CALCLK:  $pins(cal_clk)"
     puts ""
   }

}

proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_initialize_hbm_db { hbm_db_par var_array_name} {
   upvar $hbm_db_par local_hbm_db
   upvar 1 $var_array_name var

   global ::GLOBAL_hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_corename

   post_sdc_message info "Initializing HBM database for CORE $::GLOBAL_hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_corename"
   set instance_list [hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_get_core_instance_list $::GLOBAL_hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_corename]

   foreach instname $instance_list {

      post_sdc_message info "Finding port-to-pin mapping for CORE: $::GLOBAL_hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_corename INSTANCE: $instname"
      hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_get_ddr_pins $instname allpins var
      hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_verify_ddr_pins allpins var

      set local_hbm_db($instname) [ array get allpins ]
   }
}

proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_verify_ddr_pins { pins_par var_array_name} {

   upvar 1 $var_array_name var
   upvar $pins_par pins

   if { [ llength $pins(pll_phy_clock) ] != [ llength $pins(pll_vco_clock) ] } {
      post_message -type critical_warning "Found different amounts of the phy_clocks compared to the vco_clocks"
   }
   
   if { [ llength $pins(pll_vco_clock) ] != 1 } {
      post_message -type critical_warning "Didn't find exactly one VCO clock"
   }
   
   if { [ llength $pins(core_fr_usr_clock) ] != 1 } {
      post_message -type critical_warning "Didn't find exactly one user clock"
   }
   
   if { [ llength $pins(core_hr_usr_clock) ] != 1 } {
      post_message -type critical_warning "Didn't find exactly one user clock"
   }
   
   if { [ llength $pins(pll_phy_clock_l) ] != 1 } {
      post_message -type critical_warning "Didn't find exactly one PHY clock"
   }
}

proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_get_input_clk_id { pll_inclk_id var_array_name} {
   upvar 1 $var_array_name var

   array set results_array [list]

   hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_traverse_fanin_up_to_depth $pll_inclk_id hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_is_node_type_pin clock results_array $var(pll_inclock_search_depth)
   if {[array size results_array] == 1} {
      set pin_id [lindex [array names results_array] 0]
      set result $pin_id
   } else {
      post_message -type critical_warning "Could not find PLL clock for [get_node_info -name $pll_inclk_id]"
      set result -1
   }

   return $result
}

proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_is_node_type_pll_clk { node_id } {
   set cell_id [get_node_info -cell $node_id]

   if {$cell_id == ""} {
      set result 0
   } else {
      set atom_type [get_cell_info -atom_type $cell_id]
      if {$atom_type == "IOPLL"} {
         set node_name [get_node_info -name $node_id]

         if  {[regexp {pll_inst~.*OUTCLK[0-9]$} $node_name]} {
            set result 1
         } else {
            set result 0
         }
      } elseif {$atom_type == "TILE_CTRL"} {
         set node_name [get_node_info -name $node_id]

         if {[regexp {tile_ctrl_inst.*\|pa_core_clk_out\[[0-9]\]$} $node_name]} {
            set result 1
         } else {
            set result 0
         }
      } elseif {$atom_type == "CPA"} {
         set node_name [get_node_info -name $node_id]

         if {[regexp {cpa_inst.*\|pa_core_clk_out\[[0-9]\]$} $node_name]} {
            set result 1
         } else {
            set result 0
         }
      } else {
         set result 0
      }
   }
   return $result
}

proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_is_node_type_vco { node_id } {
   set cell_id [get_node_info -cell $node_id]

   if {$cell_id == ""} {
      set result 0
   } else {
      set atom_type [get_cell_info -atom_type $cell_id]
      if {$atom_type == "IOPLL"} {
         set node_name [get_node_info -name $node_id]

         if {[regexp {pll_inst.*\|.*vcoph\[0\]$} $node_name]} {
            set result 1
         } elseif {[regexp {pll_inst.*VCOPH0$} $node_name]} {
            set result 1
         } else {
            set result 0
         }
      } else {
         set result 0
      }
   }
   return $result
}

proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_does_ref_clk_exist { ref_clk_name } {

   set ref_clock_found 0
   foreach_in_collection iclk [get_clocks -nowarn] {
      set clk_targets [get_clock_info -target $iclk]
      foreach_in_collection itgt $clk_targets {
         set node_name [get_node_info -name $itgt]
         if {[string compare $node_name $ref_clk_name] == 0} {
            set ref_clock_found 1
            break
         }
      }
      if {$ref_clock_found == 1} {
         break;
      }
   }

   return $ref_clock_found
}



proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_get_periphery_clock_uncertainty { results_array_name var_array_name } {
   upvar 1 $results_array_name results
   upvar 1 $var_array_name var

   if {$var(DIAG_TIMING_REGTEST_MODE)} {
      set c2p_setup  0.0
      set c2p_hold   0.0
      set p2c_setup  0.0
      set p2c_hold   0.0
   } else {
      set c2p_setup  0.0
      set c2p_hold   0.0
      set p2c_setup  0.0
      set p2c_hold   0.0
   }

   set results [list $c2p_setup $c2p_hold $p2c_setup $p2c_hold]
}


proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_get_core_clock_uncertainty { results_array_name var_array_name } {
   upvar 1 $results_array_name results
   upvar 1 $var_array_name var

   set c2c_same_setup  0
   set c2c_same_hold   0
   set c2c_diff_setup  0
   set c2c_diff_hold   0

   set results [list $c2c_same_setup $c2c_same_hold $c2c_diff_setup $c2c_diff_hold]
}


proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_get_core_overconstraints { results_array_name var_array_name } {
   upvar 1 $results_array_name results
   upvar 1 $var_array_name var

   set results [list $var(C2C_SAME_CLK_SETUP_OC_NS) $var(C2C_SAME_CLK_HOLD_OC_NS) $var(C2C_DIFF_CLK_SETUP_OC_NS) $var(C2C_DIFF_CLK_HOLD_OC_NS)]
}


proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_get_periphery_overconstraints { results_array_name var_array_name } {
   upvar 1 $results_array_name results
   upvar 1 $var_array_name var

   set results [list $var(C2P_SETUP_OC_NS) $var(C2P_HOLD_OC_NS) $var(P2C_SETUP_OC_NS) $var(P2C_HOLD_OC_NS)]
}


proc hbm_bottom_example_design_altera_abstract_uib_191_b3v3bdi_sort_duplicate_names { names_array } {

   set main_name ""
   set duplicate_names [list]

   foreach { name } $names_array {
      if  {[regexp {Duplicate} $name]} {
         lappend duplicate_names $name
      } else {
         if {$main_name == ""} {
            set main_name $name
         } else {
            post_message -type error "More than one main tile name ($main_name and $name).  Please verify the connectivity of these pins."
         }
      }
   }

   set duplicate_names [lsort -decreasing $duplicate_names]

   set result [join [linsert $duplicate_names 0 $main_name]]

   return $result
}

