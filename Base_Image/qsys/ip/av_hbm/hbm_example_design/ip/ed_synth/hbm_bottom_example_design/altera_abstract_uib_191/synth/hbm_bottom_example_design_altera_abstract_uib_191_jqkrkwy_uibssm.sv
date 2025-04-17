// (C) 2001-2019 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



module hbm_bottom_example_design_altera_abstract_uib_191_jqkrkwy_uibssm #(
   // Device parameters
   parameter SILICON_REV                             = "",
   parameter IS_HPS                                  = 0,
   parameter UIB_FLIPPED                             = 0,
   parameter UFI_TOP                                 = 0,

   // Synthesis Parameters
   parameter SEQ_SYNTH_CODE_HEX_FILENAME             = "",
   parameter SEQ_SYNTH_CODE_FW_FILENAME              = "",
   parameter SEQ_SYNTH_PARAMS_HEX_FILENAME           = "",

   // Simulation Parameters
   parameter SEQ_SIM_CODE_HEX_FILENAME               = "",
   parameter SEQ_SIM_CODE_FW_FILENAME                = "",
   parameter SEQ_SIM_PARAMS_HEX_FILENAME             = "",
   parameter SEQ_SIM_NIOS_PERIOD_PS                  = 0,

   // Debug Parameters
   parameter DIAG_SYNTH_FOR_SIM                      = 0,
   parameter DIAG_ECLIPSE_DEBUG                      = 0,
   parameter DIAG_EXPORT_VJI                         = 0,
   parameter DIAG_INTERFACE_ID                       = 0,

   // Port widths for core debug access
   parameter PORT_CAL_DEBUG_ADDRESS_WIDTH            = 1,
   parameter PORT_CAL_DEBUG_BYTEEN_WIDTH             = 1,
   parameter PORT_CAL_DEBUG_RDATA_WIDTH              = 1,
   parameter PORT_CAL_DEBUG_WDATA_WIDTH              = 1,
   parameter PORT_CAL_DEBUG_OUT_ADDRESS_WIDTH        = 1,
   parameter PORT_CAL_DEBUG_OUT_BYTEEN_WIDTH         = 1,
   parameter PORT_CAL_DEBUG_OUT_RDATA_WIDTH          = 1,
   parameter PORT_CAL_DEBUG_OUT_WDATA_WIDTH          = 1,
   parameter PORT_CAL_MASTER_ADDRESS_WIDTH           = 1,
   parameter PORT_CAL_MASTER_BYTEEN_WIDTH            = 1,
   parameter PORT_CAL_MASTER_RDATA_WIDTH             = 1,
   parameter PORT_CAL_MASTER_WDATA_WIDTH             = 1
) (

   output	wire		phy_capture,
	output	wire		phy_clr_n,
	output	wire		phy_update,
	output	wire		ub48_capture,
	output	wire		ub48_clr_n,
	output	wire		ub48_update,

   output logic        cal_clk,
   output logic        cal_rd,
   output logic        cal_wr,
   output logic [19:0] cal_addr,
   input  logic [31:0] cal_rddata,
   output logic [31:0] cal_wrdata,
   input  logic        cal_rdval,

   output uib_early_reset_n,
   output uib_reset_n,

   input [3:0] f2c_irq_ssm,

	output	wire		pri0_scan_clk,
	output	wire	 	pri0_scan_out,

	output	wire [8:0]	dprio_pll_addr,
	output	wire		dprio_pll_clk,
	output	wire		dprio_pll_read,
	input	wire [7:0]	dprio_pll_readdata,
	output	wire		dprio_pll_rst_n,
	output	wire		dprio_pll_write,
	output	wire [7:0]	dprio_pll_writedata,

	output	wire [8:0]	dprio_cpa_addr,
	output	wire		dprio_cpa_clk,
	output	wire		dprio_cpa_read,
	input	wire [7:0]	dprio_cpa_readdata,
	output	wire		dprio_cpa_rst_n,
	output	wire		dprio_cpa_write,
	output	wire [7:0]	dprio_cpa_writedata,

   input lock_from_pll,
   output uibssm_iopll_lock2iohmc_ssm,

   input	wire	[26:0]	f2c_slave_address_ssm,
	input	wire	[3:0]	f2c_slave_byteenable_ssm,
	input	wire		f2c_slave_clk_ssm,
	input	wire		f2c_slave_read_ssm,
	output	wire	[31:0]	f2c_slave_readdata_ssm,
	output	wire		f2c_slave_readdatavalid_ssm,
	output	wire		f2c_slave_waitrequest_ssm,
	input	wire		f2c_slave_write_ssm,
	input	wire	[31:0]	f2c_slave_writedata_ssm,
    input   logic           c2f_master_clk_ssm,
    input   logic           c2f_master_waitrequest_ssm,
    output  logic           c2f_master_write_ssm,
    output  logic           c2f_master_read_ssm,
    output  logic   [15:0]  c2f_master_address_ssm,
    output  logic   [3:0]   c2f_master_byteenable_ssm,
    output  logic   [31:0]  c2f_master_writedata_ssm,
    input   logic           c2f_master_readdatavalid_ssm,
    input   logic   [31:0]  c2f_master_readdata_ssm,

  	output	wire		uibssm_hbmc_early_reset_n,
	output	wire		uibssm_hbmc_reset_n,
	output	wire		uibssm_hbmc_rmfifo_reset_n
);
   timeunit 1ns;
   timeprecision 1ps;

   // Derive localparam values
   // The following is evaluated for simulation
   // synthesis translate_off
   localparam SEQ_CODE_HEX_FILENAME   = SEQ_SIM_CODE_HEX_FILENAME;
   localparam SEQ_CODE_FW_FILENAME    = SEQ_SIM_CODE_FW_FILENAME;
   localparam SEQ_PARAMS_HEX_FILENAME = SEQ_SIM_PARAMS_HEX_FILENAME;
   // synthesis translate_on

   // The following is evaluated for synthesis.
   // Typically we synthesize full-calibration behavior for hardware,
   // except when DIAG_SYNTH_FOR_SIM is set, which allows flows such
   // as post-fit simulation to adopt RTL simulation behavior.
   // synthesis read_comments_as_HDL on
   // localparam SEQ_CODE_HEX_FILENAME   = DIAG_SYNTH_FOR_SIM ? SEQ_SIM_CODE_HEX_FILENAME : SEQ_SYNTH_CODE_HEX_FILENAME;
   // localparam SEQ_CODE_FW_FILENAME    = DIAG_SYNTH_FOR_SIM ? SEQ_SIM_CODE_FW_FILENAME    : SEQ_SYNTH_CODE_FW_FILENAME;
   // localparam SEQ_PARAMS_HEX_FILENAME = DIAG_SYNTH_FOR_SIM ? SEQ_SIM_PARAMS_HEX_FILENAME : SEQ_SYNTH_PARAMS_HEX_FILENAME;
   // synthesis read_comments_as_HDL off

   wire    [31: 0]  w_uc_read_data;
   wire             w_vji_cdr_to_the_hard_nios;
   wire    [ 1: 0]  w_vji_ir_in_to_the_hard_nios;
   wire             w_vji_rti_to_the_hard_nios;
   wire             w_vji_sdr_to_the_hard_nios;
   wire             w_vji_tck_to_the_hard_nios;
   wire             w_vji_tdi_to_the_hard_nios;
   wire             w_vji_udr_to_the_hard_nios;
   wire             w_vji_uir_to_the_hard_nios;
   wire    [ 8: 0]  w_soft_nios_ctl_sig_bidir_out;
   wire    [19: 0]  w_uc_address;
   wire             w_uc_av_bus_clk;
   wire             w_uc_read;
   wire             w_uc_write;
   wire    [31: 0]  w_uc_write_data;
   wire    [ 1: 0]  w_sld_vji_ir_out_from_the_hard_nios;
   wire             w_sld_vji_tdo_from_the_hard_nios;
   wire    [ 1: 0]  w_vji_ir_out_from_the_hard_nios;
   wire             w_vji_tdo_from_the_hard_nios;

   assign cal_clk                     = w_uc_av_bus_clk;
   assign cal_rd                = w_uc_read;
   assign cal_wr               = w_uc_write;
   assign cal_wrdata[31: 0]   = w_uc_write_data[31: 0];
   assign cal_addr[19: 0]      = w_uc_address[19: 0];
   assign w_uc_read_data[31: 0]           = cal_rddata[31: 0];

(* altera_attribute = "-name FORCE_HYPER_REGISTER_FOR_UIB_ESRAM_CORE_REGISTER ON"*)
   fourteennm_uibssm # (
      .NIOS_CALIBRATION_CODE_HEX_FILE(SEQ_CODE_HEX_FILENAME),
      .PARAMETER_TABLE_HEX_FILE (SEQ_PARAMS_HEX_FILENAME),
      .UIBSSM_SIM_CLK_PERIOD_PS(SEQ_SIM_NIOS_PERIOD_PS)
   ) uibssm (

      .strap_primary_if(3'b001), 
      .strap_secondary_if(3'b000), 
      .strap_uib_flipped(UIB_FLIPPED[0]),
      .strap_sip_location(UFI_TOP),

      .pri0_capture(phy_capture),
      .pri0_clr_n(phy_clr_n),
      .pri0_update(phy_update),
      .pri1_capture(ub48_capture),
      .pri1_clr_n(ub48_clr_n),
      .pri1_update(ub48_update),

	   .pri0_scan_clk(pri0_scan_clk),
	   .pri0_scan_out(pri0_scan_out),

      .pri_cal_addr(w_uc_address),
      .pri_cal_clk(w_uc_av_bus_clk),
      .pri_cal_rd(w_uc_read),
      .pri_cal_wr(w_uc_write),
      .pri_cal_wrdata(w_uc_write_data),
      .pri_cal_rddata(w_uc_read_data),
      .pri_cal_rd_val(cal_rdval),

      .pri_early_reset_n(uib_early_reset_n),
      .pri_reset_n(uib_reset_n),

      .sec_cal_addr(),
      .sec_cal_clk(),
      .sec_cal_rd(),
      .sec_cal_wr(),
      .sec_cal_wrdata(),
      .sec_cal_rddata(32'h0),
      .sec_cal_rd_val(1'b0),

      .f2c_irq_irq(f2c_irq_ssm),

      .f2c_slave_address(f2c_slave_address_ssm),
      .f2c_slave_byteenable(f2c_slave_byteenable_ssm),
      .f2c_slave_clk_clk(f2c_slave_clk_ssm),
      .f2c_slave_read(f2c_slave_read_ssm),
      .f2c_slave_readdata(f2c_slave_readdata_ssm),
      .f2c_slave_readdatavalid(f2c_slave_readdatavalid_ssm),
      .f2c_slave_waitrequest(f2c_slave_waitrequest_ssm),
      .f2c_slave_write(f2c_slave_write_ssm),
      .f2c_slave_writedata(f2c_slave_writedata_ssm),

      .dprio_pll_addr(dprio_pll_addr),
      .dprio_pll_clk(dprio_pll_clk),
      .dprio_pll_read(dprio_pll_read),
      .dprio_pll_readdata(dprio_pll_readdata),
      .dprio_pll_rst_n(dprio_pll_rst_n),
      .dprio_pll_write(dprio_pll_write),
      .dprio_pll_writedata(dprio_pll_writedata),

      .dprio_cpa_addr(dprio_cpa_addr),
      .dprio_cpa_clk(dprio_cpa_clk),
      .dprio_cpa_read(dprio_cpa_read),
      .dprio_cpa_readdata(dprio_cpa_readdata),
      .dprio_cpa_rst_n(dprio_cpa_rst_n),
      .dprio_cpa_write(dprio_cpa_write),
      .dprio_cpa_writedata(dprio_cpa_writedata),

      .ufi_atpg_mode_n(1'b1),
      .ufi_iopll_atpg_en_n(1'b1),
      .ufi_beadbus_testclk(1'b1),
      .ufi_calbus_testclk(1'b0),
      .ufi_control_observe_reg_scan_in(1'b0),
      .ufi_cpa_testclk(1'b0),
      .ufi_iocpa_pa_reset_n(1'b1),
      .ufi_iocpa_testin_coreclk(1'b1),
      .ufi_nreset(1'b1),
      .ufi_pfden(1'b1),
      .ufi_pipeline_enable_n(1'b1),
      .ufi_scan_enable0_n(1'b1),
      .ufi_scan_enable1_n(1'b1),
      .ufi_test_pll_si(1'b1),
      .ufi_test_reset_n(1'b1),
      .ufi_ub48_beadbus_testclk(1'b0),
      .uibphy_iocpa_test_csr_in(1'b0),
      .uibphy_iocpa_test_si_pa(2'b0),
      .uibphy_iopll_cnt_sel0(1'b0),
      .uibphy_iopll_in_sig1(1'b0),
        .c2f_master_clk_clk         (c2f_master_clk_ssm             ),
        .c2f_master_waitrequest     (c2f_master_waitrequest_ssm     ),
        .c2f_master_write           (c2f_master_write_ssm    	    ),
        .c2f_master_read            (c2f_master_read_ssm            ),
        .c2f_master_address         (c2f_master_address_ssm         ),
        .c2f_master_byteenable      (c2f_master_byteenable_ssm      ),
        .c2f_master_writedata       (c2f_master_writedata_ssm       ),
        .c2f_master_readdatavalid   (c2f_master_readdatavalid_ssm   ),
        .c2f_master_readdata        (c2f_master_readdata_ssm        ),
      .iopll_lock2iohmc(uibssm_iopll_lock2iohmc_ssm),
      .ufi_lock2iohmc(lock_from_pll),

      .cpa_slave_locked(2'b11), 

      .hbmc_early_reset_n(uibssm_hbmc_early_reset_n),
      .hbmc_reset_n(uibssm_hbmc_reset_n),
      .hbmc_rmfifo_reset_n(uibssm_hbmc_rmfifo_reset_n)

   );

   // Debug print
   // synthesis translate_off
   // synopsys translate_off
   string debug_str = "";
   logic [31:0] chars;
   always @ (posedge w_uc_av_bus_clk) begin
      if (w_uc_address == 20'h1_0000 && w_uc_write) begin
         chars = w_uc_write_data;

         while (chars[7:0] != 8'b0) begin
            debug_str = {debug_str, string'(chars[7:0])};
            chars = chars >> 8;
         end

         if ((w_uc_write_data & 32'hff) == 32'b0 ||
             (w_uc_write_data & 32'hff00) == 32'b0 ||
             (w_uc_write_data & 32'hff0000) == 32'b0 ||
             (w_uc_write_data & 32'hff000000) == 32'b0 ) begin
               $display("%s", debug_str);
               debug_str = "";
         end
      end
   end
   // synopsys translate_on
   // synthesis translate_on

endmodule


