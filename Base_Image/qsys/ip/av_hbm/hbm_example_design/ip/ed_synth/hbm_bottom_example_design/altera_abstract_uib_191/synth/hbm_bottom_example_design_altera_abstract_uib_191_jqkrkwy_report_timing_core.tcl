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





################################################################
# Helper function to add a report_timing-based analysis section
################################################################
proc hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_add_report_timing_analysis {opcname inst var_array_name summary_name title from_clks to_clks from_nodes to_nodes } {

   #######################################
   # Need access to global variables
   upvar 1 $summary_name global_summary
   upvar 1 $var_array_name var
   
   set num_failing_path 10
   
   set setup_margin    999.9
   set hold_margin     999.9
   set recovery_margin 999.9
   set removal_margin  999.9

   set show_routing_flag ""   
   if {$var(DIAG_TIMING_REGTEST_MODE)} {
      set show_routing_flag "-show_routing"
   }
      
   if {[get_collection_size [get_timing_paths -from_clock $from_clks -to_clock $to_clks -from $from_nodes -to $to_nodes -npaths 1 -setup]] > 0} {
      set res_0        [report_timing -detail full_path -from_clock $from_clks -to_clock $to_clks -from $from_nodes -to $to_nodes -npaths $num_failing_path -panel_name "$inst $title (setup)" -setup $show_routing_flag]
      set res_1        [report_timing -detail full_path -from_clock $from_clks -to_clock $to_clks -from $from_nodes -to $to_nodes -npaths $num_failing_path -panel_name "$inst $title (hold)" -hold $show_routing_flag]
      set setup_margin [lindex $res_0 1]
      set hold_margin  [lindex $res_1 1]
      
      if {$var(DIAG_TIMING_REGTEST_MODE)} {
         lappend global_summary [list $opcname 0 "$title ($opcname)" $setup_margin $hold_margin]
      }
   }
   
   if {[get_collection_size [get_timing_paths -from_clock $from_clks -to_clock $to_clks -from $from_nodes -to $to_nodes -npaths 1 -recovery]] > 0} {
      set res_0           [report_timing -detail full_path -from_clock $from_clks -to_clock $to_clks -from $from_nodes -to $to_nodes -npaths $num_failing_path -panel_name "$inst $title (recovery)" -recovery $show_routing_flag]
      set res_1           [report_timing -detail full_path -from_clock $from_clks -to_clock $to_clks -from $from_nodes -to $to_nodes -npaths $num_failing_path -panel_name "$inst $title (removal)" -removal $show_routing_flag]
      set recovery_margin [lindex $res_0 1]
      set removal_margin  [lindex $res_1 1]
      
      if {$var(DIAG_TIMING_REGTEST_MODE)} {
         lappend global_summary [list $opcname 0 "$title Recovery/Removal ($opcname)" $recovery_margin $removal_margin]
      }
   }
   
   return [list $setup_margin $hold_margin $recovery_margin $removal_margin]
}

proc hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_add_report_timing_analysis_min_pulse {opcname inst var_array_name summary_name title to_nodes } {

   upvar 1 $summary_name global_summary
   upvar 1 $var_array_name var
   
   set num_failing_path 10
   set min_pulse_margin    999.9
   
   set res_0 [report_min_pulse_width -detail full_path -nworst $num_failing_path -panel_name "$inst $title (Min Pulse)" $to_nodes ]
   if {[lindex $res_0 0] > 0 } {
      set min_pulse_margin [lindex $res_0 1]
      
      if {$var(DIAG_TIMING_REGTEST_MODE)} {
        lappend global_summary [list $opcname 0 "$title Min Pulse ($opcname)" $min_pulse_margin ]
      }
   }
   
   return [list $min_pulse_margin ]
}

#############################################################
# Other Core-Logic related Timing Analysis
#############################################################

proc hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_perform_core_analysis {opcname inst pin_array_name var_array_name summary_name} {

   #######################################
   # Need access to global variables
   upvar 1 $summary_name global_summary
   upvar 1 $var_array_name var
   upvar 1 $pin_array_name pins

   # Debug switch. Change to 1 to get more run-time debug information
   set debug 0   
   set result 1

   ###############################
   # PHY analysis
   ###############################
   
   set analysis_name "HBM/UIB"
   set instname $inst
   set allclocks [all_clocks]
   
   set hbm_all_regs [get_registers $inst|*] 
   set rest_regs [remove_from_collection [all_registers] $hbm_all_regs]
   
   set ufi_periphery_regs [get_registers $inst|*ufi_inst|ufi_inst*]
   set hbm_periphery_regs [get_registers $inst|*hbmc_inst|hbmc_inst*]
   set cpa_periphery_regs [get_registers $inst|*cpa_inst|cpa_inst*]
   set pll_periphery_regs [get_registers $inst|*pll_inst|pll_inst*]
   set phy_periphery_regs [get_registers $inst|*uib_io_phy_inst|inst*]
   set periphery_regs [add_to_collection $hbm_periphery_regs $ufi_periphery_regs]
   set periphery_regs [add_to_collection $periphery_regs $cpa_periphery_regs]
   set periphery_regs [add_to_collection $periphery_regs $pll_periphery_regs]
   set periphery_regs [add_to_collection $periphery_regs $phy_periphery_regs]
   set hbm_core_regs [remove_from_collection $hbm_all_regs $periphery_regs]
   
   set setup_margin    999.9
   set hold_margin     999.9
   set recovery_margin 999.9
   set removal_margin  999.9

   # Core/periphery transfers
   
   # Core-to-periphery
   set res [hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_add_report_timing_analysis $opcname $inst var global_summary "Core To Periphery" $allclocks $allclocks "*" $periphery_regs]
   set setup_margin    [min $setup_margin    [lindex $res 0]]
   set hold_margin     [min $hold_margin     [lindex $res 1]]
   set recovery_margin [min $recovery_margin [lindex $res 2]]
   set removal_margin  [min $removal_margin  [lindex $res 3]]
   
   # Periphery-to-core
   set res [hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_add_report_timing_analysis $opcname $inst var global_summary "Periphery To Core" $allclocks $allclocks $periphery_regs "*"]
   set setup_margin    [min $setup_margin    [lindex $res 0]]
   set hold_margin     [min $hold_margin     [lindex $res 1]]
   set recovery_margin [min $recovery_margin [lindex $res 2]]
   set removal_margin  [min $removal_margin  [lindex $res 3]]
   
   # Pure Core transfers

   # HBM logic within FPGA core
   set res [hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_add_report_timing_analysis $opcname $inst var global_summary "Within Core" $allclocks $allclocks $hbm_core_regs $hbm_core_regs]
   set setup_margin    [min $setup_margin    [lindex $res 0]]
   set hold_margin     [min $hold_margin     [lindex $res 1]]
   set recovery_margin [min $recovery_margin [lindex $res 2]]
   set removal_margin  [min $removal_margin  [lindex $res 3]]
   
   # Transfers between HBM and user logic
   set res [hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_add_report_timing_analysis $opcname $inst var global_summary "IP to User Logic" $allclocks $allclocks $hbm_core_regs $rest_regs]
   set setup_margin    [min $setup_margin    [lindex $res 0]]
   set hold_margin     [min $hold_margin     [lindex $res 1]]
   set recovery_margin [min $recovery_margin [lindex $res 2]]
   set removal_margin  [min $removal_margin  [lindex $res 3]]
   
   # Transfers between user and HBM logic
   set res [hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_add_report_timing_analysis $opcname $inst var global_summary "User Logic to IP" $allclocks $allclocks $rest_regs $hbm_core_regs]
   set setup_margin    [min $setup_margin    [lindex $res 0]]
   set hold_margin     [min $hold_margin     [lindex $res 1]]
   set recovery_margin [min $recovery_margin [lindex $res 2]]
   set removal_margin  [min $removal_margin  [lindex $res 3]]
   
   # Transfers within non-HBM logic (not reported by default since they are irrelevant to HBM IP)
   if {$var(DIAG_TIMING_REGTEST_MODE)} {
      set res [hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_add_report_timing_analysis $opcname $inst var global_summary "Within User Logic" $allclocks $allclocks $rest_regs $rest_regs]
      set setup_margin    [min $setup_margin    [lindex $res 0]]
      set hold_margin     [min $hold_margin     [lindex $res 1]]
      set recovery_margin [min $recovery_margin [lindex $res 2]]
      set removal_margin  [min $removal_margin  [lindex $res 3]]
   }
   
   set res [hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_add_report_timing_analysis_min_pulse $opcname $inst var global_summary "Periphery" $periphery_regs]
   set min_pulse_periphery_margin [lindex $res 0]

   lappend global_summary [list $opcname 0 "$analysis_name ($opcname)" $setup_margin $hold_margin]
   lappend global_summary [list $opcname 0 "$analysis_name Recovery/Removal ($opcname)" $recovery_margin $removal_margin]
   lappend global_summary [list $opcname 0 "$analysis_name Min Pulse ($opcname)" $min_pulse_periphery_margin]

}


