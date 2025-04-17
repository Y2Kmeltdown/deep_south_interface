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





module  altera_pcie_s10_gen3x16_misc_if ( 
    input logic         clk500, 
    input logic         rst_n,

    input logic         clk250,
    input logic         rst_n_clk250,
    
    // ceb interface
    input logic         ceb_req_i,
    input logic [11:0]  ceb_addr_i,
    input logic [31:0]  ceb_dout_i,
    input logic [ 3:0]  ceb_wr_i,

    input logic         ceb_ack_i,
    input logic [31:0]  ceb_din_i,
    input logic [31:0]  ceb_cdm_convert_data_i,

    output logic        ceb_req_o,
    output logic [11:0] ceb_addr_o,
    output logic [31:0] ceb_dout_o,
    output logic [31:0] ceb_cdm_convert_data_o,
    output logic [ 3:0] ceb_wr_o,

    output logic        ceb_ack_o,
    output logic [31:0] ceb_din_o,

    //INT,MSI interface
    input logic         app_msi_req_i,
    input logic [2:0]   app_msi_tc_i,
    input logic [4:0]   app_msi_num_i,
    input logic [3:0]   app_int_sts_i,
    input logic [1:0]   app_msi_func_num_i,

    output logic        app_msi_req_o,
    output logic [2:0]  app_msi_tc_o,
    output logic [4:0]  app_msi_num_o,
    output logic [3:0]  app_int_sts_o,
    output logic [1:0]  app_msi_func_num_o,

    input logic         msi_ack_i,
    output logic        msi_ack_o,

    input logic [10:0]  int_status_i,
    output logic [10:0] int_status_o,

    //link status interface
    input logic         link_req_rst_n_i,
    input logic         reset_status_i,
    input logic         pld_warm_rst_rdy_i,
    input logic         pld_core_ready_i,
    input logic         serdes_pll_locked_i,
    input logic         pld_clk_inuse_i,
    input logic         link_up_i,
    input logic [5:0]   ltssmstate_i,
    input logic [1:0]   currentspeed_i,
    input logic [4:0]   lane_act_i, 
    
    output logic        link_req_rst_n_o,
    output logic        pld_warm_rst_rdy_o,
    output logic        pld_core_ready_o,
    output logic        serdes_pll_locked_o,
    output logic        pld_clk_inuse_o,
    output logic        link_up_o,
    output logic [5:0]  ltssmstate_o,
    output logic [1:0]  currentspeed_o,
    output logic [4:0]  lane_act_o,
    
    //PM interface
    input logic         pm_linkst_in_l1_i,
    input logic         pm_linkst_in_l0s_i,
    input logic [2:0]   pm_state_i,
    input logic [2:0]   pm_dstate_i,
    
    output logic        pm_linkst_in_l1_o,
    output logic        pm_linkst_in_l0s_o,
    output logic [2:0]  pm_state_o,
    output logic [2:0]  pm_dstate_o,
    
    input logic         apps_pm_xmt_turnoff_i,
    input logic         app_init_rst_i,
    input logic         app_xfer_pending_i,

    output logic        apps_pm_xmt_turnoff_o,
    output logic        app_init_rst_o,
    output logic        app_xfer_pending_o  
    );
    
    logic               ceb_ack;
    logic               stretch_msi_ack;
    logic [2:0]         store_msi_ack;
    logic               msi_ack_250_q;
    logic               msi_ack_250;
    
    
    

    sync_vec #(.DWIDTH(12)) u_ceb_addr_sync(/*AUTOINST*/
                                            // Outputs
                                            .data_out           (ceb_addr_o[11:0]), 
                                            // Inputs
                                            .wr_clk             (clk250),        
                                            .rd_clk             (clk500),      
                                            .wr_rst_n           (rst_n_clk250),        
                                            .rd_rst_n           (rst_n),  
                                            .data_in            (ceb_addr_i[11:0])); 

        sync_vec #(.DWIDTH(4)) u_ceb_wr_sync(/*AUTOINST*/
                                            // Outputs
                                            .data_out           (ceb_wr_o[3:0]), 
                                            // Inputs
                                            .wr_clk             (clk250),        
                                            .rd_clk             (clk500),      
                                            .wr_rst_n           (rst_n_clk250),        
                                            .rd_rst_n           (rst_n),  
                                            .data_in            (ceb_addr_i[3:0])); 
        
        sync_vec #(.DWIDTH(32)) u_ceb_dout_sync(/*AUTOINST*/
                                            // Outputs
                                            .data_out           (ceb_dout_o[31:0]), 
                                            // Inputs
                                            .wr_clk             (clk250),        
                                            .rd_clk             (clk500),      
                                            .wr_rst_n           (rst_n_clk250),        
                                            .rd_rst_n           (rst_n),  
                                            .data_in            (ceb_dout_i[31:0])); 
        
         sync_vec #(.DWIDTH(3)) u_msi_tc_sync(/*AUTOINST*/
                                            // Outputs
                                            .data_out           (app_msi_tc_o[2:0]), 
                                            // Inputs
                                            .wr_clk             (clk250),        
                                            .rd_clk             (clk500),      
                                            .wr_rst_n           (rst_n_clk250),        
                                            .rd_rst_n           (rst_n),  
                                            .data_in            (app_msi_tc_i[2:0])); 
          
            sync_vec #(.DWIDTH(5)) u_msi_num_sync(/*AUTOINST*/
                                            // Outputs
                                            .data_out           (app_msi_num_o[4:0]), 
                                            // Inputs
                                            .wr_clk             (clk250),        
                                            .rd_clk             (clk500),      
                                            .wr_rst_n           (rst_n_clk250),        
                                            .rd_rst_n           (rst_n),  
                                            .data_in            (app_msi_num_i[4:0])); 

            sync_vec #(.DWIDTH(2)) u_msi_func_num_sync(/*AUTOINST*/
                                            // Outputs
                                            .data_out           (app_msi_func_num_o[1:0]), 
                                            // Inputs
                                            .wr_clk             (clk250),        
                                            .rd_clk             (clk500),      
                                            .wr_rst_n           (rst_n_clk250),        
                                            .rd_rst_n           (rst_n),  
                                            .data_in            (app_msi_func_num_i[1:0])); 

    sync_bit u_ceb_req_sync (/*AUTOINST*/
                             // Outputs
                             .dout              (ceb_req_o),     // Templated
                             // Inputs
                             .clk               (clk250),        // Templated
                             .rst_n             (rst_n_clk250),  // Templated
                             .din               (ceb_req_i));     // Templated

    sync_bit u_link_req_rst_n_sync (/*AUTOINST*/
                                    // Outputs
                                    .dout               (link_req_rst_n_o), // Templated
                                    // Inputs
                                    .clk                (clk250),        // Templated
                                    .rst_n              (rst_n_clk250),  // Templated
                                    .din                (link_req_rst_n_i)); // Templated
    
    sync_bit u_serdes_pll_locked_sync (/*AUTOINST*/
                                       // Outputs
                                       .dout            (serdes_pll_locked_o), // Templated
                                       // Inputs
                                       .clk             (clk250),        // Templated
                                       .rst_n           (rst_n_clk250),  // Templated
                                       .din             (serdes_pll_locked_i)); // Templated
    sync_bit u_pld_clk_inuse_sync (/*AUTOINST*/
                                   // Outputs
                                   .dout                (pld_clk_inuse_o), // Templated
                                   // Inputs
                                   .clk                 (clk250),        // Templated
                                   .rst_n               (rst_n_clk250),  // Templated
                                   .din                 (pld_clk_inuse_i)); // Templated
    sync_bit u_link_up_sync (/*AUTOINST*/
                             // Outputs
                             .dout              (link_up_o),     // Templated
                             // Inputs
                             .clk               (clk250),        // Templated
                             .rst_n             (rst_n_clk250),  // Templated
                             .din               (link_up_i));     // Templated
    sync_bit u_pm_linkst_in_l1_sync (/*AUTOINST*/
                                     // Outputs
                                     .dout              (pm_linkst_in_l1_o), // Templated
                                     // Inputs
                                     .clk               (clk250),        // Templated
                                     .rst_n             (rst_n_clk250),  // Templated
                                     .din               (pm_linkst_in_l1_i)); // Templated
    sync_bit u_pm_linkst_in_l0s_sync(/*AUTOINST*/
                                     // Outputs
                                     .dout              (pm_linkst_in_l0s_o), // Templated
                                     // Inputs
                                     .clk               (clk250),        // Templated
                                     .rst_n             (rst_n_clk250),  // Templated
                                     .din               (pm_linkst_in_l0s_i)); // Templated
            

    sync_vec #(.DWIDTH(8)) u_int_status_sync (/*AUTOINST*/
                                              // Outputs
                                              .data_out         (int_status_o[7:0]), // Templated
                                              // Inputs
                                              .wr_clk           (clk500),        // Templated
                                              .rd_clk           (clk250),        // Templated
                                              .wr_rst_n         (rst_n),         // Templated
                                              .rd_rst_n         (rst_n_clk250),  // Templated
                                              .data_in          (int_status_i[7:0])); // Templated
    
    sync_vec #(.DWIDTH(6)) u_ltssmstate_sync (/*AUTOINST*/
                                              // Outputs
                                              .data_out         (ltssmstate_o[5:0]), // Templated
                                              // Inputs
                                              .wr_clk           (clk500),        // Templated
                                              .rd_clk           (clk250),        // Templated
                                              .wr_rst_n         (rst_n),         // Templated
                                              .rd_rst_n         (rst_n_clk250),  // Templated
                                              .data_in          (ltssmstate_i[5:0])); // Templated
    sync_vec #(.DWIDTH(2)) u_currentspeed_sync (/*AUTOINST*/
                                                // Outputs
                                                .data_out       (currentspeed_o[1:0]), // Templated
                                                // Inputs
                                                .wr_clk         (clk500),        // Templated
                                                .rd_clk         (clk250),        // Templated
                                                .wr_rst_n       (rst_n),         // Templated
                                                .rd_rst_n       (rst_n_clk250),  // Templated
                                                .data_in        (currentspeed_i[1:0])); // Templated
    sync_vec #(.DWIDTH(5)) u_lane_act_sync (/*AUTOINST*/
                                            // Outputs
                                            .data_out           (lane_act_o[4:0]), // Templated
                                            // Inputs
                                            .wr_clk             (clk500),        // Templated
                                            .rd_clk             (clk250),        // Templated
                                            .wr_rst_n           (rst_n),         // Templated
                                            .rd_rst_n           (rst_n_clk250),  // Templated
                                            .data_in            (lane_act_i[4:0])); // Templated
    sync_vec #(.DWIDTH(3)) u_pm_state_sync (/*AUTOINST*/
                                            // Outputs
                                            .data_out           (pm_state_o[2:0]), // Templated
                                            // Inputs
                                            .wr_clk             (clk500),        // Templated
                                            .rd_clk             (clk250),        // Templated
                                            .wr_rst_n           (rst_n),         // Templated
                                            .rd_rst_n           (rst_n_clk250),  // Templated
                                            .data_in            (pm_state_i[2:0])); // Templated
    sync_vec #(.DWIDTH(3)) u_pm_dstate_sync(/*AUTOINST*/
                                            // Outputs
                                            .data_out           (pm_dstate_o[2:0]), // Templated
                                            // Inputs
                                            .wr_clk             (clk500),        // Templated
                                            .rd_clk             (clk250),        // Templated
                                            .wr_rst_n           (rst_n),         // Templated
                                            .rd_rst_n           (rst_n_clk250),  // Templated
                                            .data_in            (pm_dstate_i[2:0])); // Templated

    //Pulse stretch then sync_bit
    always @ (posedge clk500) begin
      if (!rst_n) begin
        store_msi_ack   <= '0;     
        stretch_msi_ack <= '0;
      end
      else begin        
        store_msi_ack[0]   <= msi_ack_i;
        store_msi_ack[2:1] <= store_msi_ack[1:0];
        stretch_msi_ack    <= |store_msi_ack | msi_ack_i;        
      end
    end
    
    sync_bit u_app_msi_ack_sync (/*AUTOINST*/
                                 // Outputs
                                 .dout                  (msi_ack_250), // Templated
                                 // Inputs
                                 .clk                   (clk250),        // Templated
                                 .rst_n                 (rst_n_clk250),         // Templated
                                 .din                   (stretch_msi_ack)); // Templated
    
    always @ (posedge clk250) begin
      if (!rst_n_clk250) begin
        msi_ack_250_q   <= '0;
      end
      else begin
        msi_ack_250_q   <= msi_ack_250;       
      end
    end
    
    assign msi_ack_o = msi_ack_250 & !msi_ack_250_q;
    

    sync_bit u_app_msi_req_sync (/*AUTOINST*/
                                 // Outputs
                                 .dout                  (app_msi_req_o), // Templated
                                 // Inputs
                                 .clk                   (clk500),        // Templated
                                 .rst_n                 (rst_n),         // Templated
                                 .din                   (app_msi_req_i)); // Templated
    
    sync_bit #(.DWIDTH (4)) u_app_int_sts_sync (/*AUTOINST*/
                                 // Outputs
                                 .dout                  (app_int_sts_o), // Templated
                                 // Inputs
                                 .clk                   (clk500),        // Templated
                                 .rst_n                 (rst_n),         // Templated
                                 .din                   (app_int_sts_i)); // Templated

    sync_bit u_pld_warm_rst_rdy_sync (/*AUTOINST*/
                                      // Outputs
                                      .dout             (pld_warm_rst_rdy_o), // Templated
                                      // Inputs
                                      .clk              (clk500),        // Templated
                                      .rst_n            (rst_n),         // Templated
                                      .din              (pld_warm_rst_rdy_i)); // Templated
    
    sync_bit u_pld_core_ready_sync (/*AUTOINST*/
                                    // Outputs
                                    .dout               (pld_core_ready_o), // Templated
                                    // Inputs
                                    .clk                (clk500),        // Templated
                                    .rst_n              (rst_n),         // Templated
                                    .din                (pld_core_ready_i)); // Templated
    sync_bit u_app_xfer_pending_sync (/*AUTOINST*/
                                      // Outputs
                                      .dout             (app_xfer_pending_o), // Templated
                                      // Inputs
                                      .clk              (clk500),        // Templated
                                      .rst_n            (rst_n),         // Templated
                                      .din              (app_xfer_pending_i)); // Templated

     /*sync_pulse AUTO_TEMPLATE "u_\(.*\)_sync"
     (
     .wr_clk   (clk250),
     .rd_clk   (clk500),
     .wr_rst_n (rst_n_clk250),
     .rd_rst_n (rst_n),
     .din  (@_i),
     .dout (@_o),
     );
     */
    sync_pulse u_apps_pm_xmt_turnoff_sync (/*AUTOINST*/
                                           // Outputs
                                           .dout                (apps_pm_xmt_turnoff_o), // Templated
                                           // Inputs
                                           .wr_clk              (clk250),        // Templated
                                           .rd_clk              (clk500),        // Templated
                                           .wr_rst_n            (rst_n_clk250),  // Templated
                                           .rd_rst_n            (rst_n),         // Templated
                                           .din                 (apps_pm_xmt_turnoff_i)); // Templated
    
    sync_pulse u_app_init_rst_sync (/*AUTOINST*/
                                    // Outputs
                                    .dout               (app_init_rst_o), // Templated
                                    // Inputs
                                    .wr_clk             (clk250),        // Templated
                                    .rd_clk             (clk500),        // Templated
                                    .wr_rst_n           (rst_n_clk250),  // Templated
                                    .rd_rst_n           (rst_n),         // Templated
                                    .din                (app_init_rst_i)); // Templated                             
        always @ (posedge clk500)
          begin
              if (!rst_n)
                begin
                    ceb_ack_o              <= 1'b0;
                    ceb_din_o              <= 32'h0;
                    ceb_ack                <= 1'b0;
                    ceb_cdm_convert_data_o <= 32'h0;
                end
              else
                begin
                    ceb_ack   <= ceb_ack_i;
                    ceb_ack_o <= ceb_ack_o ? 1'b0 : ceb_ack? 1'b1 : ceb_ack_o;
                    ceb_din_o <= ceb_din_i;
                    ceb_cdm_convert_data_o <= ceb_cdm_convert_data_i;
                end
          end
endmodule 
// Local Variables:
// verilog-library-directories:(".""./sync_lib/.")
// verilog-auto-inst-param-value: t
// End:
