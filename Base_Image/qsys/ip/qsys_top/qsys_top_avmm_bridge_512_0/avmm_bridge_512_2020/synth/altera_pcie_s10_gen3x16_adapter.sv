// (C) 2001-2020 Intel Corporation. All rights reserved.
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



module altera_pcie_s10_gen3x16_adapter
  #(
    parameter 			DEVICE_FAMILY 	= "Stratix 10",
    parameter pld_tx_parity_ena = "enable",
    parameter pld_rx_parity_ena = "enable",
    parameter enable_sriov_hwtcl = 0
  )
  (
   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input [31:0]         app_err_hdr_i,          // To u_err_if of altera_pcie_s10_gen3x16_err_if.v
   input [10:0]         app_err_info_i,         // To u_err_if of altera_pcie_s10_gen3x16_err_if.v
   input                app_err_valid_i,        // To u_err_if of altera_pcie_s10_gen3x16_err_if.v
   input [1:0]          app_err_func_num_i,    
   input                app_init_rst_i,         // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [3:0]          app_int_sts_i,          // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [4:0]          app_msi_num_i,          // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                app_msi_req_i,          // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [2:0]          app_msi_tc_i,           // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [1:0]          app_msi_func_num_i,
   input                app_xfer_pending_i,     // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                apps_pm_xmt_turnoff_i,  // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                ceb_ack_i,              // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [11:0]         ceb_addr_i,             // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [31:0]         ceb_din_i,              // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [31:0]         ceb_cdm_convert_data_i, // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [31:0]         ceb_dout_i,             // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                ceb_req_i,              // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [3:0]          ceb_wr_i,               // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [6:0]          ceb_vf_num_i,
   input                ceb_vf_active_i,
   input                ceb_func_num_i,
   input                clk250,                 // To u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v, ...
   input                clk500,                 // To u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v, ...
   input [1:0]          currentspeed_i,         // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [10:0]         int_status_i,           // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [4:0]          lane_act_i,             // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                link_req_rst_n_i,       // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                link_up_i,              // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [5:0]          ltssmstate_i,           // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                msi_ack_i,              // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                pld_clk_inuse_i,        // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                pld_core_ready_i,       // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                pld_warm_rst_rdy_i,     // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [2:0]          pm_dstate_i,            // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                pm_linkst_in_l0s_i,     // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                pm_linkst_in_l1_i,      // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [2:0]          pm_state_i,             // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input [1:0]          reset_status_i,         // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                reset_status_i_250,  
   input                usr_rst_clk250,   
   input                rst_n,                  // To u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v, ...
   input                rst_n_clk250,           // To u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v, ...
   input                rx_par_err_i,           // To u_err_if of altera_pcie_s10_gen3x16_err_if.v
   input [2:0]          rx_st_bar_range_i,      // To u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   input [255:0]        rx_st_data_i,           // To u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   input [2:0]          rx_st_empty_i,          // To u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   input                rx_st_eop_i,            // To u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   input [31:0]         rx_st_parity_i,         // To u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   input                rx_st_ready_i,          // To u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   input                rx_st_sop_i,            // To u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   input                rx_st_valid_i,          // To u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   input                rx_st_vf_active_i,
   input [1:0]          rx_st_func_num_i,
   input [10:0]         rx_st_vf_num_i,
   input                serdes_pll_locked_i,    // To u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   input                serr_out_i,             // To u_err_if of altera_pcie_s10_gen3x16_err_if.v
   input [3:0]          tl_cfg_add_i,           // To u_cfg_if of altera_pcie_s10_gen3x16_cfg_if.v
   input [31:0]         tl_cfg_ctl_i,           // To u_cfg_if of altera_pcie_s10_gen3x16_cfg_if.v
   input [1:0]          tl_cfg_func_i,          // To u_cfg_if of altera_pcie_s10_gen3x16_cfg_if.v
   input                tx_cdts_data_value_i,   // To u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   input [1:0]          tx_cdts_type_i,         // To u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   input [7:0]          tx_cplh_cdts_i,         // To u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   input                tx_data_cdts_consumed_i,// To u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   input                tx_hdr_cdts_consumed_i, // To u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   input [7:0]          tx_nph_cdts_i,          // To u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   input                tx_par_err_i,           // To u_err_if of altera_pcie_s10_gen3x16_err_if.v
   input [11:0]         tx_pd_cdts_i,           // To u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   input [7:0]          tx_ph_cdts_i,           // To u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   input [511:0]        tx_st_data_i,           // To u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
   input [1:0]          tx_st_eop_i,            // To u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
   input [63:0]         tx_st_parity_i,         // To u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
   input                tx_st_ready_i,          // To u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
   input [1:0]          tx_st_sop_i,            // To u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
   input [1:0]          tx_st_vf_active_i,
   input [1:0]          tx_st_err_i,            // To u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
   input [1:0]          tx_st_valid_i,          // To u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
  
   
  
   // End of automatics
   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output [31:0]        app_err_hdr_o,          // From u_err_if of altera_pcie_s10_gen3x16_err_if.v
   output [10:0]        app_err_info_o,         // From u_err_if of altera_pcie_s10_gen3x16_err_if.v
   output               app_err_valid_o,        // From u_err_if of altera_pcie_s10_gen3x16_err_if.v
   output [1:0]         app_err_func_num_o,
   output               app_init_rst_o,         // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [3:0]         app_int_sts_o,          // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [4:0]         app_msi_num_o,          // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               app_msi_req_o,          // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [2:0]         app_msi_tc_o,           // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [1:0]         app_msi_func_num_o, 
   output               app_xfer_pending_o,     // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               apps_pm_xmt_turnoff_o,  // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               ceb_ack_o,              // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [11:0]        ceb_addr_o,             // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [31:0]        ceb_din_o,              // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [31:0]        ceb_dout_o,             // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [31:0]        ceb_cdm_convert_data_o, // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               ceb_req_o,              // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [3:0]         ceb_wr_o,               // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [6:0]         ceb_vf_num_o,
   output               ceb_vf_active_o,
   output               ceb_func_num_o,
   output [1:0]         currentspeed_o,         // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [10:0]        int_status_o,           // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [4:0]         lane_act_o,             // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               link_req_rst_n_o,       // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               link_up_o,              // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [5:0]         ltssmstate_o,           // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               msi_ack_o,              // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               pld_clk_inuse_o,        // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               pld_core_ready_o,       // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               pld_warm_rst_rdy_o,     // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [2:0]         pm_dstate_o,            // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               pm_linkst_in_l0s_o,     // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               pm_linkst_in_l1_o,      // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output [2:0]         pm_state_o,             // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               rx_par_err_o,           // From u_err_if of altera_pcie_s10_gen3x16_err_if.v
   output [5:0]         rx_st_bar_range_o,      // From u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   output [511:0]       rx_st_data_o,           // From u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   output [5:0]         rx_st_empty_o,          // From u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   output [1:0]         rx_st_eop_o,            // From u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   output [63:0]        rx_st_parity_o,         // From u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   output               rx_st_ready_o,          // From u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   output [1:0]         rx_st_sop_o,            // From u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   output [1:0]         rx_st_valid_o,          // From u_rx_st_if of altera_pcie_s10_gen3x16_rx_st_if.v
   output [1:0]         rx_st_vf_active_o,
   output [3:0]         rx_st_func_num_o,
   output [21:0]        rx_st_vf_num_o,
   output               serdes_pll_locked_o,    // From u_misc_if of altera_pcie_s10_gen3x16_misc_if.v
   output               serr_out_o,             // From u_err_if of altera_pcie_s10_gen3x16_err_if.v
   output [3:0]         tl_cfg_add_o,           // From u_cfg_if of altera_pcie_s10_gen3x16_cfg_if.v
   output [31:0]        tl_cfg_ctl_o,           // From u_cfg_if of altera_pcie_s10_gen3x16_cfg_if.v
   output [1:0]         tl_cfg_func_o,          // From u_cfg_if of altera_pcie_s10_gen3x16_cfg_if.v
   output [1:0]         tx_cdts_data_value_o,   // From u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   output [3:0]         tx_cdts_type_o,         // From u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   output [7:0]         tx_cplh_cdts_o,         // From u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   output [1:0]         tx_data_cdts_consumed_o,// From u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   output [1:0]         tx_hdr_cdts_consumed_o, // From u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   output [7:0]         tx_nph_cdts_o,          // From u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   output               tx_par_err_o,           // From u_err_if of altera_pcie_s10_gen3x16_err_if.v
   output [11:0]        tx_pd_cdts_o,           // From u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   output [7:0]         tx_ph_cdts_o,           // From u_credit_if of altera_pcie_s10_gen3x16_credit_if.v
   output [255:0]       tx_st_data_o,           // From u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
   output               tx_st_eop_o,            // From u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
   output               tx_st_vf_active_o,
   output               tx_st_err_o,
   output [31:0]        tx_st_parity_o,         // From u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
   output               tx_st_ready_o,          // From u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
   output               tx_st_sop_o,            // From u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v
   output               tx_st_valid_o          // From u_tx_st_if of altera_pcie_s10_gen3x16_tx_st_if.v

);
    
    reg                                                      rst_n_clk250_reg;
    reg    [3:0]                                             rst_n_tree_clk250_reg_s1,rst_n_tree_clk250_reg_s2;
    
// rst_n_clk250 is iopll locked. This needs to be registered on ref clock then synchronized on 250MHz.
  always @ (posedge clk500 or negedge rst_n_clk250) begin
     if (!rst_n_clk250) begin
        rst_n_clk250_reg <='0;
     end
     else begin         
        rst_n_clk250_reg <= rst_n_clk250; /*synthesis preserve*/
     end
  end
  
  always @ (posedge clk250 or negedge rst_n_clk250_reg) begin
     if (!rst_n_clk250_reg) begin
        rst_n_tree_clk250_reg_s1 <='0;
        rst_n_tree_clk250_reg_s2 <='0;
     end
     else begin         
        rst_n_tree_clk250_reg_s1 <= {4{rst_n_clk250_reg}}; /*synthesis preserve*/
        rst_n_tree_clk250_reg_s2 <= rst_n_tree_clk250_reg_s1; /*synthesis preserve*/
     end
  end
  
  
  reg                                                      rst_n_reg;
  reg    [3:0]                                             rst_n_tree_reg_s1,rst_n_tree_reg_s2;
    
// registering pin_perst.
  always @ (posedge clk500 or negedge rst_n) begin
     if (!rst_n) begin
        rst_n_reg <='0;
     end
     else begin         
        rst_n_reg <= rst_n; /*synthesis preserve*/
     end
  end
  
  always @ (posedge clk500 or negedge rst_n) begin
     if (!rst_n) begin
        rst_n_tree_reg_s1 <='0;
        rst_n_tree_reg_s2 <='0;
     end
     else begin         
        rst_n_tree_reg_s1 <= {4{rst_n_reg}}; /*synthesis preserve*/
        rst_n_tree_reg_s2 <= rst_n_tree_reg_s1; /*synthesis preserve*/
     end
  end
 
    altera_pcie_s10_gen3x16_tx_st_if #(
	   .DEVICE_FAMILY								(DEVICE_FAMILY	),
       .pld_tx_parity_ena               (pld_tx_parity_ena),
       .enable_sriov_hwtcl              (enable_sriov_hwtcl)
    ) u_tx_st_if 
      (/*AUTOINST*/
       // Outputs
       .tx_st_valid_o                   (tx_st_valid_o),
       .tx_st_ready_o                   (tx_st_ready_o),
       .tx_st_sop_o                     (tx_st_sop_o),
       .tx_st_err_o                     (tx_st_err_o),
       .tx_st_eop_o                     (tx_st_eop_o),
       .tx_st_vf_active_o               (tx_st_vf_active_o),
       .tx_st_data_o                    (tx_st_data_o),
       .tx_st_parity_o                  (tx_st_parity_o),
       // Inputs
       .clk500                          (clk500),
       .rst                             (reset_status_i[0]),
       .clk250                          (clk250),
       .rst_clk250                      (reset_status_i_250),
       .usr_rst_clk250                  (usr_rst_clk250),
       .tx_st_ready_i                   (tx_st_ready_i),
       .tx_st_sop_i                     (tx_st_sop_i),
       .tx_st_err_i                     (tx_st_err_i),
       .tx_st_eop_i                     (tx_st_eop_i),
       .tx_st_vf_active_i               (tx_st_vf_active_i),
       .tx_st_data_i                    (tx_st_data_i),
       .tx_st_parity_i                  (tx_st_parity_i),
       .tx_st_valid_i                   (tx_st_valid_i));
    
    altera_pcie_s10_gen3x16_rx_st_if #(
	   .DEVICE_FAMILY								(DEVICE_FAMILY	),
       .pld_rx_parity_ena                (pld_rx_parity_ena),
       .enable_sriov_hwtcl              (enable_sriov_hwtcl)
    )  u_rx_st_if 
      (/*AUTOINST*/
       // Outputs
       .rx_st_valid_o                   (rx_st_valid_o),
       .rx_st_ready_o                   (rx_st_ready_o),
       .rx_st_sop_o                     (rx_st_sop_o),
       .rx_st_eop_o                     (rx_st_eop_o),
       .rx_st_data_o                    (rx_st_data_o),
       .rx_st_parity_o                  (rx_st_parity_o),
       .rx_st_bar_range_o               (rx_st_bar_range_o),
       .rx_st_empty_o                   (rx_st_empty_o),
       .rx_st_vf_active_o               (rx_st_vf_active_o),
       .rx_st_func_num_o                (rx_st_func_num_o),
       .rx_st_vf_num_o                  (rx_st_vf_num_o),
       // Inputs
       .clk500                          (clk500),
       .rst                             (reset_status_i[1]),
       .clk250                          (clk250),
       .rst_clk250                      (reset_status_i_250),
       .usr_rst_clk250                  (usr_rst_clk250),
       .rx_st_ready_i                   (rx_st_ready_i),
       .rx_st_sop_i                     (rx_st_sop_i),
       .rx_st_eop_i                     (rx_st_eop_i),
       .rx_st_data_i                    (rx_st_data_i),
       .rx_st_parity_i                  (rx_st_parity_i),
       .rx_st_valid_i                   (rx_st_valid_i),
       .rx_st_bar_range_i               (rx_st_bar_range_i),
       .rx_st_vf_active_i               (rx_st_vf_active_i),
       .rx_st_func_num_i                (rx_st_func_num_i),
       .rx_st_vf_num_i                  (rx_st_vf_num_i),
       .rx_st_empty_i                   (rx_st_empty_i));

    altera_pcie_s10_gen3x16_misc_if u_misc_if (/*AUTOINST*/
       // Outputs
       .ceb_req_o                       (ceb_req_o),
       .ceb_addr_o                      (ceb_addr_o),
       .ceb_dout_o                      (ceb_dout_o),
       .ceb_cdm_convert_data_o          (ceb_cdm_convert_data_o),
       .ceb_wr_o                        (ceb_wr_o),
       .ceb_ack_o                       (ceb_ack_o),
       .ceb_din_o                       (ceb_din_o),
       
       .app_msi_req_o                   (app_msi_req_o),
       .app_msi_tc_o                    (app_msi_tc_o),
       .app_msi_num_o                   (app_msi_num_o),
       .app_msi_func_num_o              (app_msi_func_num_o),
       .app_int_sts_o                   (app_int_sts_o),
       .msi_ack_o                       (msi_ack_o),
       .int_status_o                    (int_status_o),
       .link_req_rst_n_o                (link_req_rst_n_o),
       .pld_warm_rst_rdy_o              (pld_warm_rst_rdy_o),
       .pld_core_ready_o                (pld_core_ready_o),
       .serdes_pll_locked_o             (serdes_pll_locked_o),
       .pld_clk_inuse_o                 (pld_clk_inuse_o),
       .link_up_o                       (link_up_o),
       .ltssmstate_o                    (ltssmstate_o),
       .currentspeed_o                  (currentspeed_o),
       .lane_act_o                      (lane_act_o),
       .pm_linkst_in_l1_o               (pm_linkst_in_l1_o),
       .pm_linkst_in_l0s_o              (pm_linkst_in_l0s_o),
       .pm_state_o                      (pm_state_o),
       .pm_dstate_o                     (pm_dstate_o),
       .apps_pm_xmt_turnoff_o           (apps_pm_xmt_turnoff_o),
       .app_init_rst_o                  (app_init_rst_o),
       .app_xfer_pending_o              (app_xfer_pending_o),
       // Inputs
       .clk500                          (clk500),
       .rst_n                           (rst_n_tree_reg_s2[0]),
       .clk250                          (clk250),
       .rst_n_clk250                    (rst_n_tree_clk250_reg_s2[0]),
       .ceb_req_i                       (ceb_req_i),
       .ceb_addr_i                      (ceb_addr_i),
       .ceb_dout_i                      (ceb_dout_i),
       .ceb_cdm_convert_data_i          (ceb_cdm_convert_data_i),
       .ceb_wr_i                        (ceb_wr_i),
       .ceb_ack_i                       (ceb_ack_i),
       .ceb_din_i                       (ceb_din_i),
       .app_msi_req_i                   (app_msi_req_i),
       .app_msi_tc_i                    (app_msi_tc_i),
       .app_msi_num_i                   (app_msi_num_i),
       .app_msi_func_num_i              (app_msi_func_num_i),
       .app_int_sts_i                   (app_int_sts_i),
       .msi_ack_i                       (msi_ack_i),
       .int_status_i                    (int_status_i),
       .link_req_rst_n_i                (link_req_rst_n_i),
       .reset_status_i                  (reset_status_i[1]),
       .pld_warm_rst_rdy_i              (pld_warm_rst_rdy_i),
       .pld_core_ready_i                (pld_core_ready_i),
       .serdes_pll_locked_i             (serdes_pll_locked_i),
       .pld_clk_inuse_i                 (pld_clk_inuse_i),
       .link_up_i                       (link_up_i),
       .ltssmstate_i                    (ltssmstate_i),
       .currentspeed_i                  (currentspeed_i),
       .lane_act_i                      (lane_act_i),
       .pm_linkst_in_l1_i               (pm_linkst_in_l1_i),
       .pm_linkst_in_l0s_i              (pm_linkst_in_l0s_i),
       .pm_state_i                      (pm_state_i),
       .pm_dstate_i                     (pm_dstate_i),
       .apps_pm_xmt_turnoff_i           (apps_pm_xmt_turnoff_i),
       .app_init_rst_i                  (app_init_rst_i),
       .app_xfer_pending_i              (app_xfer_pending_i));

    altera_pcie_s10_gen3x16_err_if u_err_if (/*AUTOINST*/
       // Outputs
       .serr_out_o                      (serr_out_o),
       .app_err_valid_o                 (app_err_valid_o),
       .app_err_hdr_o                   (app_err_hdr_o),
       .app_err_info_o                  (app_err_info_o),
       .rx_par_err_o                    (rx_par_err_o),
       .tx_par_err_o                    (tx_par_err_o),
       .app_err_func_num_o              (app_err_func_num_o),
       // Inputs
       .clk500                          (clk500),
       .rst_n                           (rst_n_tree_reg_s2[1]),
       .clk250                          (clk250),
       .rst_n_clk250                    (rst_n_tree_clk250_reg_s2[1]),
       .serr_out_i                      (serr_out_i),
       .app_err_valid_i                 (app_err_valid_i),
       .app_err_hdr_i                   (app_err_hdr_i),
       .app_err_info_i                  (app_err_info_i),
       .rx_par_err_i                    (rx_par_err_i),
       .tx_par_err_i                    (tx_par_err_i),
       .app_err_func_num_i              (app_err_func_num_i));

    altera_pcie_s10_gen3x16_credit_if # (
		.DEVICE_FAMILY								(DEVICE_FAMILY	)							 
		)	u_credit_if
      (/*AUTOINST*/
       // Outputs
       .tx_cdts_type_o                  (tx_cdts_type_o),
       .tx_data_cdts_consumed_o         (tx_data_cdts_consumed_o),
       .tx_hdr_cdts_consumed_o          (tx_hdr_cdts_consumed_o),
       .tx_cdts_data_value_o            (tx_cdts_data_value_o),
       .tx_pd_cdts_o                    (tx_pd_cdts_o),
       .tx_ph_cdts_o                    (tx_ph_cdts_o),
       .tx_nph_cdts_o                   (tx_nph_cdts_o),
       .tx_cplh_cdts_o                  (tx_cplh_cdts_o),
       
       // Inputs
       .clk500                          (clk500),
       .rst_n                           (rst_n_tree_reg_s2[2]),
       .clk250                          (clk250),
       .rst_n_clk250                    (rst_n_tree_clk250_reg_s2[2]),
       .tx_cdts_type_i                  (tx_cdts_type_i),
       .tx_data_cdts_consumed_i         (tx_data_cdts_consumed_i),
       .tx_hdr_cdts_consumed_i          (tx_hdr_cdts_consumed_i),
       .tx_cdts_data_value_i            (tx_cdts_data_value_i),
       .tx_pd_cdts_i                    (tx_pd_cdts_i),
       .tx_ph_cdts_i                    (tx_ph_cdts_i),
       .tx_nph_cdts_i                   (tx_nph_cdts_i),
       .tx_cplh_cdts_i                  (tx_cplh_cdts_i));
   
    altera_pcie_s10_gen3x16_cfg_if u_cfg_if
      (/*AUTOINST*/
       // Outputs
       .tl_cfg_func_o                   (tl_cfg_func_o),
       .tl_cfg_add_o                    (tl_cfg_add_o),
       .tl_cfg_ctl_o                    (tl_cfg_ctl_o),
       // Inputs
       .clk500                          (clk500),
       .rst_n                           (rst_n_tree_reg_s2[3]),
       .clk250                          (clk250),
       .rst_n_clk250                    (rst_n_tree_clk250_reg_s2[3]),
       .tl_cfg_func_i                   (tl_cfg_func_i),
       .tl_cfg_add_i                    (tl_cfg_add_i),
       .tl_cfg_ctl_i                    (tl_cfg_ctl_i));
    

endmodule // altera_pcie_s10_gen3x16_adaptor

