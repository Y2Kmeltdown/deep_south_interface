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




module  altera_pcie_s10_gen3x16_tx_st_if
  #(
    parameter 			DEVICE_FAMILY 	= "Stratix 10",
    parameter pld_tx_parity_ena = "enable",
    parameter enable_sriov_hwtcl = 0
  )(  
    input logic             clk500, 
    input logic             rst,

    input logic             clk250,
    input logic             rst_clk250,
    input logic             usr_rst_clk250,
    //avst rx interface
    input logic             tx_st_ready_i,
    input logic [1:0]       tx_st_sop_i,
    input logic [1:0]       tx_st_eop_i,
    input logic [1:0]       tx_st_err_i,
    input logic [1:0]       tx_st_vf_active_i,
    input logic [256*2-1:0] tx_st_data_i,
    input logic [ 32*2-1:0] tx_st_parity_i,
    input logic [1:0]       tx_st_valid_i,

    output logic            tx_st_valid_o,
    output logic            tx_st_ready_o,
    output logic            tx_st_sop_o,
    output logic            tx_st_eop_o,
    output logic            tx_st_vf_active_o,
    output logic            tx_st_err_o,
    output logic [255:0]    tx_st_data_o,
    output logic [ 31:0]    tx_st_parity_o   
    );

    localparam   par_sriov  = (pld_tx_parity_ena == "enable" && enable_sriov_hwtcl)? 1 : 0;
    localparam   only_sriov  = (pld_tx_parity_ena != "enable" && enable_sriov_hwtcl)? 1 : 0;
    localparam   only_par  = (pld_tx_parity_ena == "enable" && !enable_sriov_hwtcl)? 1 : 0;
    
    
    logic                   tx_st_ready_q;  
    logic [1:0]             tx_st_vf_active_q;   /*synthesis preserve*/
    logic [1:0]             tx_st_sop_q;         /*synthesis preserve*/
    logic [1:0]             tx_st_eop_q;         /*synthesis preserve*/
    logic [1:0]             tx_st_err_q;         /*synthesis preserve*/
    logic [256*2-1:0]       tx_st_data_q;        /*synthesis preserve*/
    logic [32*2-1:0]        tx_st_parity_q;      /*synthesis preserve*/
    logic [1:0]             tx_st_valid_q;       /*synthesis preserve*/
    logic                   tx_st_ready;
    logic                   tx_fifo_empty_lo,tx_fifo_empty2_lo;
    logic                   pending_hi_read;  

    logic                   tx_fifo_wrreq;
    logic                   tx_fifo_rdreq_lo_q,
                            tx_fifo_rdreq_hi_q; /*synthesis maxfan=16 */
    logic                   tx_fifo_rd_next;
    logic                     tx_fifo_rdreq_lo;
    logic                     tx_fifo_rdreq_hi;
    logic [par_sriov ? 292 : only_par ? 291 : only_sriov? 260 : 259 :0] tx_fifo_wrdata_lo,
                                                                        tx_fifo_wrdata_hi;             
    logic [par_sriov ? 292 : only_par ? 291 : only_sriov? 260 : 259 :0] tx_fifo_rddata_lo,
                                                                        tx_fifo_rddata_hi;

    logic                   fifo_almost_full;
    
    assign tx_st_ready_o = /* tx_st_ready_q &  */!fifo_almost_full;
    //---------------------------------------------
    //input signals flop in first to ease timing
    sync_bit #(.DWIDTH(1)) u_din_gry_sync (.clk(clk250), .rst_n(!rst_clk250), .din(tx_st_ready_i), .dout(tx_st_ready_q));
    always_ff @ (posedge clk250)  begin
      if (usr_rst_clk250) begin
          tx_st_valid_q     <= '0;
      end
      else begin
          tx_st_valid_q     <= tx_st_valid_i;
      end
    end
    always_ff @ (posedge clk250)  begin
      if (rst_clk250) begin
          tx_st_sop_q       <= '0;
          tx_st_eop_q       <= '0;
          tx_st_err_q       <= '0;    
      end
      else begin
          tx_st_sop_q       <= tx_st_sop_i;
          tx_st_eop_q       <= tx_st_eop_i;
          tx_st_err_q       <= tx_st_err_i;
      end
    end
    always_ff @ (posedge clk250)
      begin
          tx_st_data_q      <= tx_st_data_i;
          tx_st_parity_q    <= tx_st_parity_i;
          tx_st_vf_active_q <= tx_st_vf_active_i;

          /* if (rst_clk250)
            begin
                //tx_st_ready   <= 1'b0;
                tx_st_ready_o <= 1'b0;
            end
          else
            begin
                //tx_st_ready   <= tx_st_ready_i;
                tx_st_ready_o <= tx_st_ready_q & !fifo_almost_full;
            end */
      end // always_ff @

    assign tx_fifo_wrreq = |tx_st_valid_q;
    
    generate
      if (par_sriov) begin
         assign tx_fifo_wrdata_lo = {tx_st_vf_active_q[0],
                                     tx_st_eop_q[0],
                                     tx_st_sop_q[0],
                                     1'b1,
                                     tx_st_err_q[0],
                                     tx_st_parity_q[31:0],
                                     tx_st_data_q[255:0]};
         assign tx_fifo_wrdata_hi = {tx_st_vf_active_q[1],
                                     tx_st_eop_q[1],
                                     tx_st_sop_q[1],
                                     tx_st_valid_q[1],
                                     tx_st_err_q[1],
                                     tx_st_parity_q[63:32],
                                     tx_st_data_q[511:256]};
      end
      else if (only_par) begin
        assign tx_fifo_wrdata_lo = {tx_st_eop_q[0],
                                    tx_st_sop_q[0],
                                    1'b1,
                                    tx_st_err_q[0],
                                    tx_st_parity_q[31:0],
                                    tx_st_data_q[255:0]};
        assign tx_fifo_wrdata_hi = {tx_st_eop_q[1],
                                    tx_st_sop_q[1],
                                    tx_st_valid_q[1],
                                    tx_st_err_q[1],
                                    tx_st_parity_q[63:32],
                                    tx_st_data_q[511:256]};
      end
      else if (only_sriov) begin
        assign tx_fifo_wrdata_lo = {tx_st_vf_active_q[0],
                                    tx_st_eop_q[0],
                                    tx_st_sop_q[0],
                                    1'b1,
                                    tx_st_err_q[0],
                                    tx_st_data_q[255:0]};
        assign tx_fifo_wrdata_hi = {tx_st_vf_active_q[1],
                                    tx_st_eop_q[1],
                                    tx_st_sop_q[1],
                                    tx_st_valid_q[1],
                                    tx_st_err_q[1],
                                    tx_st_data_q[511:256]};
      end
      else begin
        assign tx_fifo_wrdata_lo = {tx_st_eop_q[0],
                                    tx_st_sop_q[0],
                                    1'b1,
                                    tx_st_err_q[0],
                                    tx_st_data_q[255:0]};
        assign tx_fifo_wrdata_hi = {tx_st_eop_q[1],
                                    tx_st_sop_q[1],
                                    tx_st_valid_q[1],
                                    tx_st_err_q[1],
                                    tx_st_data_q[511:256]};
      end      
    endgenerate
// AVST Interface   
      always @ (posedge clk500) begin
        tx_st_data_o   <= tx_fifo_rdreq_hi_q? tx_fifo_rddata_hi[255: 0] : tx_fifo_rddata_lo[255:0] ;
        tx_st_parity_o <= (par_sriov || only_par)? (tx_fifo_rdreq_hi_q? tx_fifo_rddata_hi[256+31: 256] : tx_fifo_rddata_lo[256+31:256]) : '0;
      end 
      
      
      always @ (posedge clk500) begin
        if (rst) begin               
            tx_st_valid_o     <= 1'b0;
            tx_st_sop_o       <= 1'b0;
            tx_st_eop_o       <= 1'b0;
            tx_st_err_o       <= 1'b0;
            tx_st_vf_active_o <= 1'b0;
        end
        else begin                        
            tx_st_err_o       <= (par_sriov || only_par)? ((tx_fifo_rddata_lo[256+32] & tx_fifo_rdreq_lo_q) | (tx_fifo_rddata_hi[256+32] & tx_fifo_rdreq_hi_q)) : ((tx_fifo_rddata_lo[256] & tx_fifo_rdreq_lo_q) | (tx_fifo_rddata_hi[256] & tx_fifo_rdreq_hi_q));
            tx_st_valid_o     <= (par_sriov || only_par)? (tx_fifo_rdreq_lo_q | (tx_fifo_rdreq_hi_q & tx_fifo_rddata_hi[256+33])) : (tx_fifo_rdreq_lo_q | (tx_fifo_rdreq_hi_q & tx_fifo_rddata_hi[256+1])) ;
            tx_st_sop_o       <= (par_sriov || only_par)? ((tx_fifo_rddata_lo[256+34] & tx_fifo_rdreq_lo_q) | (tx_fifo_rddata_hi[256+34] & tx_fifo_rdreq_hi_q)) : ((tx_fifo_rddata_lo[256+2] & tx_fifo_rdreq_lo_q) | (tx_fifo_rddata_hi[256+2] & tx_fifo_rdreq_hi_q));
            tx_st_eop_o       <= (par_sriov || only_par)? ((tx_fifo_rddata_lo[256+35] & tx_fifo_rdreq_lo_q) | (tx_fifo_rddata_hi[256+35] & tx_fifo_rdreq_hi_q)) : ((tx_fifo_rddata_lo[256+3] & tx_fifo_rdreq_lo_q) | (tx_fifo_rddata_hi[256+3] & tx_fifo_rdreq_hi_q));
            tx_st_vf_active_o <= (par_sriov) ? ((tx_fifo_rddata_lo[256+36] & tx_fifo_rdreq_lo_q) | (tx_fifo_rddata_hi[256+36] & tx_fifo_rdreq_hi_q)) : (only_sriov) ? ((tx_fifo_rddata_lo[256+4] & tx_fifo_rdreq_lo_q) | (tx_fifo_rddata_hi[256+4] & tx_fifo_rdreq_hi_q)) : '0;
        end
      end
    
    
    
    always @ (posedge clk500)
      begin
          tx_fifo_rdreq_lo_q <= tx_fifo_rdreq_lo;
          tx_fifo_rdreq_hi_q <= tx_fifo_rdreq_hi;
          if (rst)
            begin
                tx_fifo_rdreq_lo <= 1'b0;
                tx_fifo_rdreq_hi <= 1'b0;
                pending_hi_read <= 1'b0;
                tx_st_ready   <= 1'b0;
            end
          else
            begin
               tx_st_ready   <= tx_st_ready_i;
               tx_fifo_rdreq_lo <= ~(tx_fifo_empty_lo|tx_fifo_empty2_lo) & tx_st_ready_i & ~pending_hi_read & ~tx_fifo_rdreq_lo;
               tx_fifo_rdreq_hi <=  tx_st_ready_i &  (tx_fifo_rdreq_lo | pending_hi_read);
               pending_hi_read <= ~tx_st_ready_i ? (tx_fifo_rdreq_lo | pending_hi_read) : '0;

            end
      end // always @ (posedge clk500)

/*
    
     dcfifo tx_fifo_lo
      (
       .aclr  (~rst_n),
       .wrclk (clk250),
       .wrreq (tx_fifo_wrreq),
       .data  (tx_fifo_wrdata_lo),
       .wrusedw(),
       .wrempty(),
       .wrfull (),
       .rdclk (clk500),
       .rdreq (tx_fifo_rdreq_lo),
       .rdfull(),
       .rdempty(tx_fifo_empty),
       .rdusedw(tx_fifo_rusedw),
       .q      (tx_fifo_rddata_lo),
       .eccstatus()
       );
    defparam 
      tx_fifo_lo.add_ram_output_register  = "ON",
      tx_fifo_lo.intended_device_family  = "Stratix 10",
      tx_fifo_lo.lpm_numwords  = 8,
      tx_fifo_lo.lpm_width  = 292,
      tx_fifo_lo.lpm_widthu  = 3,
      tx_fifo_lo.overflow_checking  = "OFF",
      tx_fifo_lo.underflow_checking  = "OFF",
      tx_fifo_lo.use_eab  = "ON";
    
    dcfifo tx_fifo_hi
      (
       .aclr  (~rst_n),
       .wrclk (clk250),
       .wrreq (tx_fifo_wrreq),
       .data  (tx_fifo_wrdata_hi),
       .wrusedw(),
       .wrempty(),
       .wrfull (),
       .rdclk (clk500),
       .rdreq (tx_fifo_rdreq_hi),
       .rdfull(),
       .rdempty(),
       .rdusedw(),
       .q      (tx_fifo_rddata_hi),       
       .eccstatus()
       );
    defparam 
      tx_fifo_hi.add_ram_output_register  = "ON",
      tx_fifo_hi.intended_device_family  = "Stratix 10",
      tx_fifo_hi.lpm_numwords  = 8,
      tx_fifo_hi.lpm_width  = 292,
      tx_fifo_hi.lpm_widthu  = 3,
      tx_fifo_hi.overflow_checking  = "OFF",
      tx_fifo_hi.underflow_checking  = "OFF",
      tx_fifo_hi.use_eab  = "ON";
*/

    altera_pcie_s10_gen3x16_dcfifo
      #(.FIFO_WIDTH (par_sriov ? 293 : only_par ? 292 : only_sriov? 261 : 260),
// synthesis translate_off        
        .SIM_EMULATE(1),
// synthesis translate_on 
        .ADDR_WIDTH (5),
		.DEVICE_FAMILY	(DEVICE_FAMILY	)
        )
      tx_fifo_lo
        (
         .din_clk  (clk250),
         .din_sclr (rst_clk250),
         .din_wreq (tx_fifo_wrreq),
         .din      (tx_fifo_wrdata_lo),
         .din_wusedw(),
         .dout_clk  (clk500),
         .dout_sclr (rst),
         .dout_rreq (tx_fifo_rdreq_lo),
         .dout      (tx_fifo_rddata_lo),
         .dout_rusedw(),
         .fifo_empty (tx_fifo_empty_lo),
         .fifo_empty2 (tx_fifo_empty2_lo),
         .fifo_almost_empty(),
         .fifo_almost_full (fifo_almost_full)
         );

     altera_pcie_s10_gen3x16_dcfifo
       #(.FIFO_WIDTH (par_sriov ? 293 : only_par ? 292 : only_sriov? 261 : 260),
// synthesis translate_off        
        .SIM_EMULATE(1),
// synthesis translate_on 
        .ADDR_WIDTH (5),
		.DEVICE_FAMILY	(DEVICE_FAMILY	)
        )
      tx_fifo_hi 
        (
         .din_clk  (clk250),
         .din_sclr (rst_clk250),
         .din_wreq (tx_fifo_wrreq),
         .din      (tx_fifo_wrdata_hi),
         .din_wusedw(),
         .dout_clk  (clk500),
         .dout_sclr (rst),
         .dout_rreq (tx_fifo_rdreq_hi),
         .dout      (tx_fifo_rddata_hi),
         .dout_rusedw(),
         .fifo_empty (),
         .fifo_almost_empty(),
         .fifo_almost_full ()
         );

    
endmodule 
