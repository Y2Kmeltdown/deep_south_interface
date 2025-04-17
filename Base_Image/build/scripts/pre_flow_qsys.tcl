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
#-- Title       : Pre-Flow Script
#-- Project     : 520N-MX
#-------------------------------------------------------------------------------
#-- Description : Pre-Flow Script for edited Qsys files
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
puts ""
puts "Running Pre-Flow Script"
puts ""

cd ../qsys/rtl

file copy -force "tg_bottom0_0.v" "../ip/av_hbm/hbm_example_design/ip/ed_synth/tg_bottom0_0/synth/tg_bottom0_0.v"
file copy -force "tg_bottom0_1.v" "../ip/av_hbm/hbm_example_design/ip/ed_synth/tg_bottom0_1/synth/tg_bottom0_1.v"
file copy -force "tg_top0_0.v"    "../ip/av_hbm/hbm_example_design/ip/ed_synth/tg_top0_0/synth/tg_top0_0.v"
file copy -force "tg_top0_1.v"    "../ip/av_hbm/hbm_example_design/ip/ed_synth/tg_top0_1/synth/tg_top0_1.v"

file copy -force "altera_hbm_tg_axi_bringup_dcb.sv" "../ip/av_hbm/hbm_example_design/ip/ed_synth/tg_bottom0_0/altera_hbm_tg_axi_1930/synth/altera_hbm_tg_axi_bringup_dcb.sv"
file copy -force "altera_hbm_tg_axi_bringup_dcb.sv" "../ip/av_hbm/hbm_example_design/ip/ed_synth/tg_bottom0_1/altera_hbm_tg_axi_1930/synth/altera_hbm_tg_axi_bringup_dcb.sv"
file copy -force "altera_hbm_tg_axi_bringup_dcb.sv" "../ip/av_hbm/hbm_example_design/ip/ed_synth/tg_top0_0/altera_hbm_tg_axi_1930/synth/altera_hbm_tg_axi_bringup_dcb.sv"
file copy -force "altera_hbm_tg_axi_bringup_dcb.sv" "../ip/av_hbm/hbm_example_design/ip/ed_synth/tg_top0_1/altera_hbm_tg_axi_1930/synth/altera_hbm_tg_axi_bringup_dcb.sv"

cd ../../build
