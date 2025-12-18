#-------------------------------------------------------------------------------
#--      Nallatech is providing this design, code, or information "as is",
#--      solely for use on Nallatech systems and equipment. By providing
#--      this design, code, or information as one possible implementation
#--      of this feature, application or standard, NALLATECH IS MAKING NO
#--      REPRESENTATION THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS
#--      OF INFRINGEMENT, AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS
#--      YOU MAY REQUIRE FOR YOUR IMPLEMENTATION. NALLATECH EXPRESSLY
#--      DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF
#--      THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES
#--      OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS
#--      OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND
#--      FITNESS FOR A PARTICULAR PURPOSE.
#--
#--      USE OF SOFTWARE. This software contains elements of software code
#--      which are the property of Nallatech Limited (Nallatech Software).
#--      Use of the Nallatech Software by you is permitted only if you
#--      hold a valid license from Nallatech Limited or a valid sub-license
#--      from a licensee of Nallatech Limited. Use of such software shall
#--      be governed by the terms of such license or sub-license agreement.
#--      The Nallatech Software is for use solely on Nallatech hardware
#--      unless you hold a license permitting use on other hardware.
#--
#--      This Nallatech Software is protected by copyright law and
#--      international treaties. Unauthorized reproduction or distribution
#--      of this software, or any portion of it, may result in severe civil
#--      and criminal penalties, and will be prosecuted to the maximum
#--      extent possible under law. Nallatech products are covered by one
#--      or more patents. Other US and international patents pending.
#--
#--      Please see www.nallatech.com for more information.
#--
#--      Nallatech products are not intended for use in life support
#--      appliances, devices, or systems. Use in such applications is
#--      expressly prohibited.
#--
#--      Copyright © 1998-2018 Nallatech Limited. All rights reserved.
#--
#--      UNCLASSIFIED//FOR OFFICIAL USE ONLY
#-------------------------------------------------------------------------------
#-- $Id$
#-------------------------------------------------------------------------------
#--
#--                         N
#--                        NNN
#--                       NNNNN
#--                      NNNNNNN
#--                     NNNN-NNNN          Nallatech
#--                    NNNN---NNNN         (a molex company)
#--                   NNNN-----NNNN
#--                  NNNN-------NNNN
#--                 NNNN---------NNNN
#--                NNNNNNNN---NNNNNNNN
#--               NNNNNNNNN---NNNNNNNNN
#--                -------------------
#--               ---------------------
#--
#-------------------------------------------------------------------------------
#-- Title       : Intel FPGA Build Script
#-- Project     : 520N-MX
#-------------------------------------------------------------------------------
#-- Description : FPGA Build Script
#--
#--
#-------------------------------------------------------------------------------
#-- Known Issues and Omissions:
#--
#--
#--
#-------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Set script parameters...
# (Change these to suit your design).
# ------------------------------------------------------------------------------

set design "bist_top_me1"


# ------------------------------------------------------------------------------
# Initial set up and command line checking 
# ------------------------------------------------------------------------------

# Print the title banner.
puts ""
puts " ------------------------------------------------"
puts "  Building: $design"
puts " ------------------------------------------------"
puts ""

# Procedure to print help information.
proc help {} {
  puts "  Help on FPGA build script that runs the Altera Quartus II design flow:"
  puts ""
  puts "    * IP Generation"
  puts "    * Analysis & Synthesis"
  puts "    * Fitter"
  puts "    * TimeQuest Timing Analysis"
  puts "    * Assembler"
  puts ""
  puts "  Command syntax: quartus_sh -t build_intel_fpga.tcl <options>"
  puts ""
  puts "    -help   : Display this message"
  puts "    -all    : Run everything"
  puts "    -asm    : Run Assembler - Generate Programming Files (ASM) only"
  puts ""
}

# Check for correct number of command line arguments.
if {$argc > 1} {
  puts "  ERROR : Too many command line arguments"
  puts ""
  puts ""
  help
  exit
}

# Check for valid command line argument.
set arg_vld {"-h" "-help" "-all" "-map" "-fit" "-asm" "-sta"}
set vld 0

if {$argc == 1} {
  foreach x $arg_vld {
    if {$x == $argv} {
      set vld 1
    }
  }
  if {$vld == 0 } {
    puts "  ERROR : Problem with command line argument ($argv)"
    puts ""
    puts ""
    help
    exit
  }

  if {$argv == "-h" | $argv == "-help"} {
    help
    exit
  }
}

# ------------------------------------------------------------------------------
# Intel Quartus Prime Pro design flow - IP Generation
# ------------------------------------------------------------------------------
if {$argc == 0 | $argv == "-all"} {
  puts ""
  puts " Quartus IP Generation..."
  puts ""

  # Run the IP Generate command.  
  if [catch {exec quartus_ipgenerate ${design} -c ${design} --run_default_mode_op >@ stdout} status] {
    puts stderr "IP Generate : $status"
    exit
  }
  source scripts/pre_flow_qsys.tcl
}

# ------------------------------------------------------------------------------
# Intel Quartus Prime Pro design flow - Analysis & Synthesis
# ------------------------------------------------------------------------------
if {$argc == 0 | $argv == "-all"} {
  puts ""
  puts " Quartus Analysis & Synthesis..."
  puts ""

  # Run the Analysis & Synthesis command.  
  if [catch {exec quartus_syn --read_settings_files=off --write_settings_files=off ${design} -c ${design} >@ stdout} status] {
    puts stderr "Analysis & Synthesis : $status"
    exit
  }
}

# ------------------------------------------------------------------------------
# Intel Quartus Prime Pro design flow - Fitter
# ------------------------------------------------------------------------------
if {$argc == 0 | $argv == "-all"} {
  puts ""
  puts " Quartus Fitter... "
  puts ""

  # Run the Fitter command.  
  if [catch {eval exec quartus_fit --read_settings_files=off --write_settings_files=off ${design} -c ${design} >@ stdout} status] {
    puts stderr "Error during Fitter : $status"
    exit
  }
}

# ------------------------------------------------------------------------------
# Intel Quartus Prime Pro design flow - TimeQuest Timing Analysis
# ------------------------------------------------------------------------------
if {$argc == 0 | $argv == "-all"} {
  puts ""
  puts " Quartus TimeQuest... "
  puts ""

  # Run the TimeQuest Timing Analysis command.  
  if [catch {eval exec quartus_sta ${design} -c ${design} --mode=finalize >@ stdout} status] {
    puts stderr "Error during TimeQuest Timing Analysis : $status"
    exit
  }
}

# ------------------------------------------------------------------------------
# Intel Quartus Prime Pro design flow - Assembler
# ------------------------------------------------------------------------------
if {$argc == 0 | $argv == "-all" | $argv == "-asm"} {
  puts ""
  puts " Quartus Assembler... "
  puts ""

  # Run the Assembler command.  
  if [catch {eval exec quartus_asm --read_settings_files=off --write_settings_files=off ${design} -c ${design} >@ stdout} status] {
    puts stderr "Error during Assembler : $status"
    exit
  }
}

# Print the end banner.
puts ""
puts " ------------------------------------------------"
puts "  FPGA BUILD COMPLETE"
puts " ------------------------------------------------"
puts ""
