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




module altera_pcie_s10_gen3x16_credit_if #(

parameter 			DEVICE_FAMILY 	= "Stratix 10"
	)
  (
   input logic         clk500, 
   input logic         rst_n,

   input logic         clk250,
   input logic         rst_n_clk250,
   
   input logic [1:0]   tx_cdts_type_i, 
   input logic         tx_data_cdts_consumed_i, 
   input logic         tx_hdr_cdts_consumed_i, 
   input logic         tx_cdts_data_value_i, 
   input logic [11:0]  tx_pd_cdts_i, 
   input logic [7:0]   tx_ph_cdts_i, 
   input logic [7:0]   tx_nph_cdts_i, 
   input logic [7:0]   tx_cplh_cdts_i,
   
   output logic [3:0]  tx_cdts_type_o, 
   output logic [1:0]  tx_data_cdts_consumed_o, 
   output logic [1:0]  tx_hdr_cdts_consumed_o, 
   output logic [1:0]  tx_cdts_data_value_o, 
   output logic [11:0] tx_pd_cdts_o, 
   output logic [7:0]  tx_ph_cdts_o, 
   output logic [7:0]  tx_nph_cdts_o, 
   output logic [7:0]  tx_cplh_cdts_o
   );

  typedef struct packed{
    logic [1:0] cdts_type;
    logic       data_cdts_consumed;
    logic       hdr_cdts_consumed;
    logic       cdts_data_value;
  } cdts_consumed_t;
    
  typedef struct packed{
    logic [3:0] cdts_type;
    logic [1:0] data_cdts_consumed;
    logic [1:0] hdr_cdts_consumed;
    logic [1:0] cdts_data_value;
  } cdts_consumed_double_t;
  cdts_consumed_t  stg0_cdts_consumed;
  cdts_consumed_t  stg1_cdts_consumed;
  cdts_consumed_t  stg2_cdts_consumed;
  cdts_consumed_double_t cdts_consumed_fifo_wr;
  cdts_consumed_double_t cdts_consumed_fifo_rd;    
  logic       toggle;
  logic       fifo_wr;
  logic       fifo_rd;
  logic       fifo_rd_del;  
  logic       fifo_empty;
  logic [2:0] fifo_rusedw;
  

  always_ff @ (posedge clk500) begin
    toggle  <= !toggle;
    fifo_wr <= 1'b0;
    stg0_cdts_consumed.cdts_type          <= tx_cdts_type_i;
    stg0_cdts_consumed.data_cdts_consumed <= tx_data_cdts_consumed_i;
    stg0_cdts_consumed.hdr_cdts_consumed  <= tx_hdr_cdts_consumed_i;
    stg0_cdts_consumed.cdts_data_value    <= tx_cdts_data_value_i;
    stg1_cdts_consumed <= stg0_cdts_consumed;
    stg2_cdts_consumed <= stg1_cdts_consumed;    
    if (toggle) begin
      cdts_consumed_fifo_wr.cdts_type          <= {stg2_cdts_consumed.cdts_type,          stg1_cdts_consumed.cdts_type};
      cdts_consumed_fifo_wr.data_cdts_consumed <= {stg2_cdts_consumed.data_cdts_consumed, stg1_cdts_consumed.data_cdts_consumed};      
      cdts_consumed_fifo_wr.hdr_cdts_consumed  <= {stg2_cdts_consumed.hdr_cdts_consumed,  stg1_cdts_consumed.hdr_cdts_consumed};            
      cdts_consumed_fifo_wr.cdts_data_value    <= {stg2_cdts_consumed.cdts_data_value,    stg1_cdts_consumed.cdts_data_value};            
      fifo_wr <= stg2_cdts_consumed.data_cdts_consumed || stg1_cdts_consumed.data_cdts_consumed ||
                 stg2_cdts_consumed.hdr_cdts_consumed  || stg1_cdts_consumed.hdr_cdts_consumed;
    end
    if (!rst_n) begin
      fifo_wr <= 1'b0;
      toggle  <= 1'b0;
    end
  end

  always_ff @ (posedge clk250 or negedge rst_n_clk250) begin
    if (!rst_n_clk250) 
      fifo_rd <= 1'b0;
    else
      fifo_rd     <= !fifo_empty & ~(fifo_rd && fifo_rusedw <= 2);
  end

  always_ff @ (posedge clk250) begin
    fifo_rd_del <= fifo_rd;

    if (fifo_rd_del) begin
      if (cdts_consumed_fifo_rd.data_cdts_consumed[0] || cdts_consumed_fifo_rd.hdr_cdts_consumed[0]) begin
        tx_cdts_type_o          <= cdts_consumed_fifo_rd.cdts_type;
        tx_data_cdts_consumed_o <= cdts_consumed_fifo_rd.data_cdts_consumed;
        tx_hdr_cdts_consumed_o  <= cdts_consumed_fifo_rd.hdr_cdts_consumed;
        tx_cdts_data_value_o    <= cdts_consumed_fifo_rd.cdts_data_value;
      end else begin
        // No data in low. Must be in high only -> swap high to low
        // to match how TLPs are transferred. For TLPs there can only
        // be data in the high part if there is also data in the low part.
        tx_cdts_type_o          <= {<<2{cdts_consumed_fifo_rd.cdts_type}};
        tx_data_cdts_consumed_o <= {<<1{cdts_consumed_fifo_rd.data_cdts_consumed}};
        tx_hdr_cdts_consumed_o  <= {<<1{cdts_consumed_fifo_rd.hdr_cdts_consumed}};
        tx_cdts_data_value_o    <= {<<1{cdts_consumed_fifo_rd.cdts_data_value}};
      end
    end else begin
      tx_cdts_type_o          <= '0;
      tx_data_cdts_consumed_o <= '0;
      tx_hdr_cdts_consumed_o  <= '0;
      tx_cdts_data_value_o    <= '0;
    end
  end

  dcfifo cdts_fifo
     (
     .aclr      (~rst_n),
     .wrclk     (clk500),
     .wrreq     (fifo_wr),
     .data      (cdts_consumed_fifo_wr),
     .wrusedw   (),
     .wrempty   (),
     .wrfull    (),
     .rdclk     (clk250),
     .rdreq     (fifo_rd),
     .rdfull    (),
     .rdempty   (fifo_empty),
     .rdusedw   (fifo_rusedw),
     .q         (cdts_consumed_fifo_rd),       
     .eccstatus ()
     );
    defparam 
      cdts_fifo.add_ram_output_register  = "ON",
      cdts_fifo.intended_device_family   = DEVICE_FAMILY,
      cdts_fifo.lpm_hint                 = "DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE",
      cdts_fifo.lpm_numwords             = 8,
      cdts_fifo.lpm_widthu               = 3,
      cdts_fifo.lpm_width                = $bits(cdts_consumed_fifo_wr),
      cdts_fifo.overflow_checking        = "OFF",
      cdts_fifo.underflow_checking       = "OFF",
      cdts_fifo.rdsync_delaypipe         = 4,
      cdts_fifo.wrsync_delaypipe         = 4,
      cdts_fifo.use_eab                  = "ON";
   localparam FPATH_1      = {"-name SDC_STATEMENT \"set from_keeper_collection [get_registers -nowarn {*cdts_fifo*delayed_wrptr_g*}]\"; -name SDC_STATEMENT \"set to_keeper_collection [get_registers -nowarn {*cdts_fifo*rs_dgwp*}]\"; -name SDC_STATEMENT \" if {[llength [query_collection -report -all $to_keeper_collection]] > 0} { set_false_path -from [get_registers {*cdts_fifo*delayed_wrptr_g*}] -to [get_registers {*cdts_fifo*rs_dgwp*}] }\" "};
   localparam FPATH_2      = {"-name SDC_STATEMENT \"set from_keeper_collection [get_registers -nowarn {*cdts_fifo*rdptr_g*}]\"; -name SDC_STATEMENT \"set to_keeper_collection [get_registers -nowarn {*cdts_fifo*ws_dgrp*}]\"; -name SDC_STATEMENT \" if {[llength [query_collection -report -all $to_keeper_collection]] > 0} { set_false_path -from [get_registers {*cdts_fifo*rdptr_g*}] -to [get_registers {*cdts_fifo*ws_dgrp*}] }\" "};
   localparam SDC          = {FPATH_1 ,";",FPATH_2};
   (* altera_attribute = SDC *)

    sync_vec #(.DWIDTH(8)) u_tx_nph_cdts_sync (/*AUTOINST*/
                                               // Outputs
                                               .data_out        (tx_nph_cdts_o), // Templated
                                               // Inputs
                                               .wr_clk          (clk500),        // Templated
                                               .rd_clk          (clk250),        // Templated
                                               .wr_rst_n        (rst_n),         // Templated
                                               .rd_rst_n        (rst_n_clk250),  // Templated
                                               .data_in         (tx_nph_cdts_i)); // Templated

    sync_vec #(.DWIDTH(8)) u_tx_ph_cdts_sync (/*AUTOINST*/
                                              // Outputs
                                              .data_out         (tx_ph_cdts_o),  // Templated
                                              // Inputs
                                              .wr_clk           (clk500),        // Templated
                                              .rd_clk           (clk250),        // Templated
                                              .wr_rst_n         (rst_n),         // Templated
                                              .rd_rst_n         (rst_n_clk250),  // Templated
                                              .data_in          (tx_ph_cdts_i));  // Templated
    sync_vec #(.DWIDTH(12)) u_tx_pd_cdts_sync (/*AUTOINST*/
                                               // Outputs
                                               .data_out        (tx_pd_cdts_o),  // Templated
                                               // Inputs
                                               .wr_clk          (clk500),        // Templated
                                               .rd_clk          (clk250),        // Templated
                                               .wr_rst_n        (rst_n),         // Templated
                                               .rd_rst_n        (rst_n_clk250),  // Templated
                                               .data_in         (tx_pd_cdts_i));  // Templated
    sync_vec #(.DWIDTH(8)) u_tx_cplh_cdts_sync (/*AUTOINST*/
                                                // Outputs
                                                .data_out       (tx_cplh_cdts_o), // Templated
                                                // Inputs
                                                .wr_clk         (clk500),        // Templated
                                                .rd_clk         (clk250),        // Templated
                                                .wr_rst_n       (rst_n),         // Templated
                                                .rd_rst_n       (rst_n_clk250),  // Templated
                                                .data_in        (tx_cplh_cdts_i)); // Templated

 





    
    

    

        

    

endmodule // altera_pcie_s10_gen3x16_credit_if

// Local Variables:
// verilog-library-directories:(".""./sync_lib/.")
// verilog-auto-inst-param-value: t
// End:
