# (C) 2001-2019 Intel Corporation. All rights reserved.
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


#####################################################################
#
# THIS IS AN AUTO-GENERATED FILE!
# -------------------------------
# If you modify this files, all your changes will be lost if you
# regenerate the core!
#
# FILE DESCRIPTION
# ----------------
# This file specifies the timing constraints of the memory device and
# of the memory interface

# ------------------------------------------- #
# -                                         - #
# --- Some useful functions and variables --- #
# -                                         - #
# ------------------------------------------- #

set script_dir [file dirname [info script]]
source "$script_dir/hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_ip_parameters.tcl"
source "$script_dir/hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_parameters.tcl"
source "$script_dir/hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_pin_map.tcl"

#--------------------------------------------#
# -                                        - #
# --- Determine when SDC is being loaded --- #
# -                                        - #
#--------------------------------------------#

set syn_flow 0
set sta_flow 0
set fit_flow 0
set pow_flow 0
if { $::TimeQuestInfo(nameofexecutable) == "quartus_map" || $::TimeQuestInfo(nameofexecutable) == "quartus_syn" } {
   set syn_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_sta" } {
   set sta_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_fit" } {
   set fit_flow 1
} elseif { $::TimeQuestInfo(nameofexecutable) == "quartus_pow" } {
   set pow_flow 1
}

# ------------------------ #
# -                      - #
# --- GENERAL SETTINGS --- #
# -                      - #
# ------------------------ #

# This is a global setting and will apply to the whole design.
# This setting is required for the memory interface to be
# properly constrained.
derive_clock_uncertainty

# Debug switch. Change to 1 to get more run-time debug information
set debug 0

# All timing requirements will be represented in nanoseconds with up to 3 decimal places of precision
set_time_format -unit ns -decimal_places 3

# Determine if entity names are on
set entity_names_on [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_are_entity_names_on ]

# ---------------------- #
# -                    - #
# --- DERIVED TIMING --- #
# -                    - #
# ---------------------- #

# PLL multiplier from ref clk
regexp {([0-9\.]+) ps} $var(PLL_REF_CLK_FREQ_PS_STR) match var(PHY_REF_CLK_FREQ_PS)
regexp {([0-9\.]+) ps} $var(PHY_CAL_CLK_FREQ_PS_STR) match var(PHY_CAL_CLK_FREQ_PS)
regexp {([0-9\.]+) ps} $var(PLL_VCO_FREQ_PS_STR) match var(PHY_VCO_FREQ_PS)
set vco_multiplier [expr int($var(PHY_REF_CLK_FREQ_PS)/$var(PHY_VCO_FREQ_PS))*$var(PLL_NCNTR_SETTING)]

# Half of reference clock
set ref_period      [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_round_3dp [ expr $var(PHY_REF_CLK_FREQ_PS)/1000.0] ]
set ref_half_period [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_round_3dp [ expr $ref_period / 2.0 ] ]
set cal_period      [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_round_3dp [ expr $var(PHY_CAL_CLK_FREQ_PS)/1000.0] ]
set cal_half_period [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_round_3dp [ expr $cal_period / 2.0 ] ]

# ---------------------- #
# -                    - #
# --- INTERFACE RATE --- #
# -                    - #
# ---------------------- #

# -------------------------------------------------------------------- #
# -                                                                  - #
# --- This is the main call to the netlist traversal routines      --- #
# --- that will automatically find all pins and registers required --- #
# --- to apply timing constraints.                                 --- #
# --- During the fitter, the routines will be called only once     --- #
# --- and cached data will be used in all subsequent calls.        --- #
# -                                                                  - #
# -------------------------------------------------------------------- #

#if { ! [ info exists hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_sdc_cache ] } {
   hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_initialize_hbm_db hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_hbm_db var
   set hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_sdc_cache 1
#} else {
#   if { $debug } {
#      post_message -type info "SDC: reusing cached HBM DB"
#   }
#}

# ------------------------------------------------------------- #
# -                                                           - #
# --- If multiple instances of this core are present in the --- #
# --- design they will all be constrained through the       --- #
# --- following loop                                        --- #
# -                                                           - #
# ------------------------------------------------------------- #

set instances [ array names hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_hbm_db ]
foreach { inst } $instances {
   if { [ info exists pins ] } {
      unset pins
   }
   array set pins $hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_hbm_db($inst)
   
   # ----------------------- #
   # -                     - #
   # --- REFERENCE CLOCK --- #
   # -                     - #
   # ----------------------- #

   # First determine if a reference clock has already been created (i.e. Reference clock sharing)
   set ref_clock_exists [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_does_ref_clk_exist $pins(pll_ref_clock) ]
   if { $ref_clock_exists == 0 }  {
      create_clock -period $ref_period -waveform [ list 0 $ref_half_period ] $pins(pll_ref_clock) -add -name ${inst}_ref_clock
   }
   set pins(ref_clock_name) [hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_clock_name_from_pin_name $pins(pll_ref_clock)]
   
   if {[get_collection_size $pins(ncntr_id)] == 1} {
      set local_ncntr_clk [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_or_add_generated_clock \
         -target $pins(ncntr) \
         -name "${inst}_ncntr" \
         -source $pins(pll_ref_clock) \
         -multiply_by 1 \
         -divide_by $var(PLL_NCNTR_SETTING) \
         -phase 0 ]
      set vco_base_clk $pins(ncntr)
      if {$var(PLL_NCNTR_SETTING) == 1} {
         post_message -type warning "hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy.sdc: Inconsistent N-counter setting, expecting larger than 1 setting"
      }
   } else {
      set vco_base_clk $pins(pll_ref_clock)
      if {$var(PLL_NCNTR_SETTING) != 1} {
         post_message -type warning "hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy.sdc: Inconsistent N-counter setting, expecting setting to be 1"
      }
   }

   # ------------------------- #
   # -                       - #
   # --- CALIBRATION CLOCK --- #
   # -                       - #
   # ------------------------- #

   if { $pins(cal_clk) != "" }  {
      create_clock -period $cal_period -waveform [ list 0 $cal_half_period ] $pins(cal_clk) -add -name ${inst}_cal_clock
   }

   # ------------------ #
   # -                - #
   # --- PLL CLOCKS --- #
   # -                - #
   # ------------------ #

   # VCO clock
   set local_pll_vco_clk [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_or_add_generated_clock \
      -target $pins(vco_clock) \
      -name "${inst}_vco_clk" \
      -source $vco_base_clk \
      -multiply_by [expr $vco_multiplier ]  \
      -divide_by 1 \
      -phase 0 ]

   # Core clocks
   set core_clocks [list]
   set core_clocks_local [list]
   
   set local_core_clk1_clock ""
   if {$pins(cpa_core_clk1_clock) != ""} {
      set divide_by $var(PLL_VCO_TO_FR_USER_CLK_RATIO)
      set phase [expr {$var(PLL_PHY_CLK_VCO_PHASE) * 45.0 / $divide_by}]

      set local_core_clk1_clock [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_or_add_generated_clock \
         -target $pins(cpa_core_clk1_clock) \
         -name "${inst}_cpa_core_clk1" \
         -source $pins(vco_clock) \
         -multiply_by 1 \
         -divide_by $divide_by\
         -phase $phase ]
   }
   
   set local_core_clk0_clock ""
   if {$pins(cpa_core_clk0_clock) != ""} {
      set divide_by $var(PLL_VCO_TO_HR_USER_CLK_RATIO)
      set phase_divider [expr {$divide_by == 128 ? 0 : (45.0 / $divide_by)}]
      set phase [expr {$var(PLL_PHY_CLK_VCO_PHASE) * $phase_divider}]

      set local_core_clk0_clock [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_or_add_generated_clock \
         -target $pins(cpa_core_clk0_clock) \
         -name "${inst}_cpa_core_clk0" \
         -source $pins(vco_clock) \
         -multiply_by 1 \
         -divide_by $divide_by\
         -phase $phase ]
   }

   set local_core_fr_usr_clock ""
   if {$pins(core_fr_usr_clock) != ""} {
      set local_core_fr_usr_clock [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_or_add_generated_clock \
         -target $pins(core_fr_usr_clock) \
         -name "${inst}_fr_core_clk" \
         -source $pins(cpa_core_clk1_clock) \
         -multiply_by 1 \
         -divide_by 1 \
         -phase 0 ]

      lappend core_clocks $pins(core_fr_usr_clock)
      lappend core_clocks_local $local_core_fr_usr_clock 
   }
   
   set local_core_hr_usr_clock ""
   if {$pins(core_hr_usr_clock) != ""} {
      set local_core_hr_usr_clock [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_or_add_generated_clock \
         -target $pins(core_hr_usr_clock) \
         -name "${inst}_hr_core_clk" \
         -source $pins(cpa_core_clk0_clock) \
         -multiply_by 1 \
         -divide_by 1 \
         -phase 0 ]

      lappend core_clocks $pins(core_hr_usr_clock)
      lappend core_clocks_local $local_core_hr_usr_clock 
   }   
   
   # Periphery clocks
   set periphery_clocks [list]

   set divide_by $var(PLL_VCO_TO_HR_PHY_CLK_RATIO)     
   set phase [expr {$var(PLL_PHY_CLK_VCO_PHASE) * 45.0 / $divide_by}]
   set local_phy_clk [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_or_add_generated_clock \
      -target $pins(pll_phy_clock) \
      -name "${inst}_hr_phy_clk" \
      -source $pins(pll_vco_clock) \
      -multiply_by 1 \
      -divide_by $divide_by \
      -phase $phase ]
   lappend periphery_clocks $local_phy_clk
   
   set divide_by $var(PLL_VCO_TO_FR_PHY_CLK_RATIO)     
   set phase [expr {$var(PLL_PHY_CLK_VCO_PHASE) * 45.0 / $divide_by}]
   set local_phy_clk_l [ hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_or_add_generated_clock \
      -target $pins(pll_phy_clock_l) \
      -name "${inst}_fr_phy_clk" \
      -source $pins(pll_vco_clock) \
      -multiply_by 1 \
      -divide_by $divide_by \
      -phase $phase ]
   lappend periphery_clocks $local_phy_clk_l
   

   # ------------------------------ #
   # -                            - #
   # --- MULTICYCLE CONSTRAINTS --- #
   # -                            - #
   # ------------------------------ #
   
   # ------------------------------ #
   # -                            - #
   # --- FALSE PATH CONSTRAINTS --- #
   # -                            - #
   # ------------------------------ #

  set regs [get_registers *]
  foreach_in_collection reg $regs {
    set reg_name [get_object_info -name $reg]
    
    set result [regexp {real_axifencereq_r\[0} $reg_name match]
    if {$result==1} {
      set_multicycle_path -to [get_object_info -name $reg] -setup -end 5
      set_multicycle_path -to [get_object_info -name $reg] -hold -end 10
    }
    
    set result [regexp {sync_ext_core_clk_locked} $reg_name match]
    if {$result==1} {
      set regs_from [get_registers *fourteennm_pll*]
      set regs_to [get_registers *sync_ext_core_clk_locked*]
      foreach_in_collection reg_from $regs_from {
        foreach_in_collection reg_to $regs_to {
          set_multicycle_path -from [get_object_info -name $reg_from] -to [get_object_info -name $reg_to] -setup -end 5
          set_multicycle_path -from [get_object_info -name $reg_from] -to [get_object_info -name $reg_to] -hold -end 10
        }
      }
    }
    
    set result [regexp {flop_hbm_only_reset} $reg_name match]
    if {$result==1} {
      set regs_from [get_registers *flop_hbm_only_reset*]
      set regs_to [get_registers *uibssm_f2c_reg*]
      foreach_in_collection reg_from $regs_from {
        foreach_in_collection reg_to $regs_to {
          set_multicycle_path -from [get_object_info -name $reg_from] -to [get_object_info -name $reg_to] -setup -end 5
          set_multicycle_path -from [get_object_info -name $reg_from] -to [get_object_info -name $reg_to] -hold -end 10
        }
      }
    }
    
    set result [regexp {unused_irq} $reg_name match]
    if {$result==1} {
      set regs_from [get_registers *unused_irq*]
      set regs_to [get_registers *uibssm_f2c_reg*]
      foreach_in_collection reg_from $regs_from {
        foreach_in_collection reg_to $regs_to {
          set_multicycle_path -from [get_object_info -name $reg_from] -to [get_object_info -name $reg_to] -setup -end 5
          set_multicycle_path -from [get_object_info -name $reg_from] -to [get_object_info -name $reg_to] -hold -end 10
        }
      }
    }
  }
  

   if {$fit_flow == 1} {
      set all_but_cal_clock [remove_from_collection [all_clocks] [get_clocks ${inst}_cal_clock]]
      set_multicycle_path -from [get_clocks ${inst}_cal_clock] -to $all_but_cal_clock -setup 5 -start
      set_multicycle_path -from [get_clocks ${inst}_cal_clock] -to $all_but_cal_clock -hold 10 -start
   } else {
      set_clock_groups -asynchronous -group "${inst}_cal_clock"
   }

   # ------------------------- #
   # -                       - #
   # --- CLOCK UNCERTAINTY --- #
   # -                       - #
   # ------------------------- #

   if {($fit_flow == 1 || $sta_flow == 1)} {

      #################################
      # C2P/P2C transfers
      #################################

      # Get extra periphery clock uncertainty
      set periphery_clock_uncertainty [list]
      hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_periphery_clock_uncertainty periphery_clock_uncertainty var

      # Get Fitter overconstraints
      if {$fit_flow == 1} {
         hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_periphery_overconstraints periphery_overconstraints  var
      } else {
         set periphery_overconstraints [list 0.0 0.0 0.0 0.0]
      }

      # Now loop over core/periphery clocks and set clock uncertainty
      set i_core_clock 0
      foreach core_clock $core_clocks {
         if {$core_clock != ""} {

            set local_core_clock [lindex $core_clocks_local $i_core_clock]
            
            set i_phy_clock 0
            foreach { phy_clock } $pins(pll_phy_clock_l) {
               
               set add_to_derived "-add"
               set c2p_su         [expr [lindex $periphery_overconstraints 0] + [lindex $periphery_clock_uncertainty 0]]
               set c2p_h          [expr [lindex $periphery_overconstraints 1] + [lindex $periphery_clock_uncertainty 1]]
               set p2c_su         [expr [lindex $periphery_overconstraints 2] + [lindex $periphery_clock_uncertainty 2]]
               set p2c_h          [expr [lindex $periphery_overconstraints 3] + [lindex $periphery_clock_uncertainty 3]]


               set_clock_uncertainty -from [get_clocks $local_core_clock] -to   [get_clocks $local_phy_clk_l] -suppress_warnings -setup $add_to_derived $c2p_su
               set_clock_uncertainty -from [get_clocks $local_core_clock] -to   [get_clocks $local_phy_clk_l] -suppress_warnings -hold  $add_to_derived $c2p_h
               set_clock_uncertainty -to   [get_clocks $local_core_clock] -from [get_clocks $local_phy_clk_l] -suppress_warnings -setup $add_to_derived $p2c_su
               set_clock_uncertainty -to   [get_clocks $local_core_clock] -from [get_clocks $local_phy_clk_l] -suppress_warnings -hold  $add_to_derived $p2c_h
                  
               if {$sta_flow == 1 && $var(CUT_C2P_P2C_PATHS)} {
                  set_false_path -to [get_clocks $local_phy_clk_l] 
                  set_false_path -from [get_clocks $local_phy_clk_l] 
               }

               set_clock_uncertainty -from [get_clocks $local_core_clock] -to   [get_clocks $local_phy_clk] -suppress_warnings -setup $add_to_derived $c2p_su
               set_clock_uncertainty -from [get_clocks $local_core_clock] -to   [get_clocks $local_phy_clk] -suppress_warnings -hold  $add_to_derived $c2p_h
               set_clock_uncertainty -to   [get_clocks $local_core_clock] -from [get_clocks $local_phy_clk] -suppress_warnings -setup $add_to_derived $p2c_su
               set_clock_uncertainty -to   [get_clocks $local_core_clock] -from [get_clocks $local_phy_clk] -suppress_warnings -hold  $add_to_derived $p2c_h
               
               if {$sta_flow == 1 && $var(CUT_C2P_P2C_PATHS) } {
                  set_false_path -to [get_clocks $local_phy_clk] 
                  set_false_path -from [get_clocks $local_phy_clk] 
               }
               incr i_phy_clock
            }
         }
         incr i_core_clock
      }
      
      #################################
      # Within-core transfers
      #################################

      # Get extra core clock uncertainty
      set core_clock_uncertainty [list]
      hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_core_clock_uncertainty core_clock_uncertainty var

      # Get Fitter overconstraints
      if {$fit_flow == 1} {
         hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_get_core_overconstraints core_overconstraints var
      } else {
         set core_overconstraints [list 0.0 0.0 0.0 0.0]
      }

      set c2c_same_su         [expr [lindex $core_overconstraints 0] + [lindex $core_clock_uncertainty 0]]
      set c2c_same_h          [expr [lindex $core_overconstraints 1] + [lindex $core_clock_uncertainty 1]]
      set c2c_diff_su         [expr [lindex $core_overconstraints 2] + [lindex $core_clock_uncertainty 2]]
      set c2c_diff_h          [expr [lindex $core_overconstraints 3] + [lindex $core_clock_uncertainty 3]]

      # For these transfers it is safe to use the -add option of set_clock_uncertainty since
      # we rely on derive_clock_uncertainty for the base value.
      foreach src_core_clock_local $core_clocks_local {
         if {$src_core_clock_local != ""} {
            foreach dst_core_clock_local $core_clocks_local {
               if {$dst_core_clock_local != ""} {
                  if {$src_core_clock_local == $dst_core_clock_local} {
                     set_clock_uncertainty -from $src_core_clock_local -to $dst_core_clock_local -setup -add $c2c_same_su
                     set_clock_uncertainty -from $src_core_clock_local -to $dst_core_clock_local -hold -enable_same_physical_edge -add $c2c_same_h
                  } else {
                     set_clock_uncertainty -from $src_core_clock_local -to $dst_core_clock_local -setup -add $c2c_diff_su
                     set_clock_uncertainty -from $src_core_clock_local -to $dst_core_clock_local -hold -add $c2c_diff_h
                  }
               }
            }
         }
      }
   }



}

# -------------------------- #
# -                        - #
# --- REPORT DDR COMMAND --- #
# -                        - #
# -------------------------- #

add_ddr_report_command "source [list [file join [file dirname [info script]] ${::GLOBAL_hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_corename}_report_timing.tcl]]"

