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



module altera_pcie_s10_gen3x16_err_if (

   input logic         clk500, 
   input logic         rst_n,

   input logic         clk250,
   input logic         rst_n_clk250,

   input logic         serr_out_i,
   input logic         app_err_valid_i,
   input logic [31:0]  app_err_hdr_i,
   input logic [10:0]  app_err_info_i,
   input logic [1:0]   app_err_func_num_i,

   output logic        serr_out_o,
   output logic        app_err_valid_o,
   output logic [31:0] app_err_hdr_o,
   output logic [10:0] app_err_info_o,
   output logic [1:0]  app_err_func_num_o,

   input logic         rx_par_err_i,
   input logic         tx_par_err_i,

   output logic        rx_par_err_o,
   output logic        tx_par_err_o
      
   );

    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    wire                app_err_valid_sync;     // From u_app_err_valid_sync of sync_bit.v
    wire                err_hdr_avail_sync;     // From u_err_hdr_avail_sync of sync_bit.v
    // End of automatics
    
    sync_pulse u_rx_par_err_sync (/*AUTOINST*/
                                  // Outputs
                                  .dout                 (rx_par_err_o),  // Templated
                                  // Inputs
                                  .wr_clk               (clk500),        // Templated
                                  .rd_clk               (clk250),        // Templated
                                  .wr_rst_n             (rst_n),         // Templated
                                  .rd_rst_n             (rst_n_clk250),  // Templated
                                  .din                  (rx_par_err_i));  // Templated
    sync_pulse u_tx_par_err_sync (/*AUTOINST*/
                                  // Outputs
                                  .dout                 (tx_par_err_o),  // Templated
                                  // Inputs
                                  .wr_clk               (clk500),        // Templated
                                  .rd_clk               (clk250),        // Templated
                                  .wr_rst_n             (rst_n),         // Templated
                                  .rd_rst_n             (rst_n_clk250),  // Templated
                                  .din                  (tx_par_err_i));  // Templated
    sync_pulse u_serr_out_sync (/*AUTOINST*/
                                // Outputs
                                .dout           (serr_out_o),    // Templated
                                // Inputs
                                .wr_clk         (clk500),        // Templated
                                .rd_clk         (clk250),        // Templated
                                .wr_rst_n       (rst_n),         // Templated
                                .rd_rst_n       (rst_n_clk250),  // Templated
                                .din            (serr_out_i));    // Templated
   logic [3:0]          header_present;
   logic [3:0]          header_present_ss;
   logic [3:0]          header_present_ss_q;
   logic [31:0]         header0,header1,header2,header3;
   logic [1:0]          err_func0,err_func1,err_func2,err_func3;
   
   logic [31:0]         app_err_hdr_q2,app_err_hdr_q1;
   logic [10:0]         info0,info1,info2,info3;
   logic [1:0]          app_err_func_num_q2,app_err_func_num_q1;
   logic [10:0]         app_err_info_q1,app_err_info_q2;
   logic                app_err_valid_q2,app_err_valid_q1;
   
   always @ (posedge clk250) begin
     if (!rst_n_clk250) begin
       header_present <= '0;     
     end
     else begin
       if (app_err_valid_i & (header_present[3] | !(|header_present))) begin
         header_present[0] <= 1'b1;       
       end
       if (header_present[1]) begin
         header_present[0] <= 1'b0;
       end
       if (app_err_valid_i & header_present[0]) begin
         header_present[1] <= 1'b1;       
       end
       if (header_present[2]) begin
         header_present[1] <= 1'b0;
       end
       if (app_err_valid_i & header_present[1]) begin
         header_present[2] <= 1'b1;       
       end
       if (header_present[3]) begin
         header_present[2] <= 1'b0;
       end
       if (app_err_valid_i & header_present[2]) begin
         header_present[3] <= 1'b1;       
       end
       if (header_present[0]) begin
         header_present[3] <= 1'b0;
       end      
     end  
   end
   

    always @ (posedge clk250) begin
      if (!rst_n_clk250) begin
        header0 <= '0;
        header1 <= '0;
        header2 <= '0;
        header3 <= '0;
        info0   <= '0;
        info1   <= '0;
        info2   <= '0;
        info3   <= '0;       
      end
      else begin
        if (app_err_valid_i & ((header_present[3] & !header_present[0]) | !(|header_present))) begin
           header0 <= app_err_hdr_i;
           info0   <= app_err_info_i;          
        end
        if (app_err_valid_i & header_present[0] & !header_present[1]) begin
           header1 <= app_err_hdr_i;
           info1   <= app_err_info_i;  
        end
        if (app_err_valid_i & header_present[1] & !header_present[2]) begin
           header2 <= app_err_hdr_i;
           info2   <= app_err_info_i;  
        end
        if (app_err_valid_i & header_present[2] & !header_present[3]) begin
           header3 <= app_err_hdr_i;
           info3   <= app_err_info_i;  
        end      
      end
    end
      
    always @ (posedge clk250) begin
      if (!rst_n_clk250) begin
        {err_func0,err_func1,err_func2,err_func3}                     <= '0; 
      end
      else begin
        if (app_err_valid_i & ((header_present[3] & !header_present[0]) | !(|header_present))) begin
          err_func0      <= app_err_func_num_i;
        end
        if (app_err_valid_i & header_present[0] & !header_present[1]) begin
          err_func1      <= app_err_func_num_i;
        end
        if (app_err_valid_i & header_present[1] & !header_present[2]) begin
          err_func2      <= app_err_func_num_i;
        end
        if (app_err_valid_i & header_present[2] & !header_present[3]) begin
          err_func3      <= app_err_func_num_i;
        end            
      end
    end  
    
    sync_bit #(.DWIDTH (4) ) u_header_present_sync (.clk(clk500), .rst_n(rst_n), .din(header_present), .dout(header_present_ss));
    

   always @ (posedge clk500) begin
     
     app_err_hdr_o       <= app_err_hdr_q1   | app_err_hdr_q2;
     app_err_info_o      <= app_err_info_q1  | app_err_info_q2;
     app_err_hdr_q1      <= '0;
     app_err_hdr_q2      <= '0;
     app_err_info_q1     <= '0;       
     app_err_info_q2     <= '0;
     if (!header_present_ss_q[0] & header_present_ss[0]) begin
       app_err_hdr_q1   <= header0;
       app_err_info_q1  <= info0;
     end
     if (!header_present_ss_q[1] & header_present_ss[1]) begin
       app_err_hdr_q1   <= header1;
       app_err_info_q1  <= info1;
     end
     if (!header_present_ss_q[2] & header_present_ss[2]) begin
       app_err_hdr_q2   <= header2;
       app_err_info_q2  <= info2;
     end
     if (!header_present_ss_q[3] & header_present_ss[3]) begin
       app_err_hdr_q2   <= header3;
       app_err_info_q2  <= info3;
     end     
     
     app_err_func_num_o      <= app_err_func_num_q1     | app_err_func_num_q2;
     app_err_func_num_q1     <= '0;
     app_err_func_num_q2     <= '0;
     if (!header_present_ss_q[0] & header_present_ss[0]) begin
       app_err_func_num_q1      <= err_func0;
     end
     if (!header_present_ss_q[1] & header_present_ss[1]) begin
       app_err_func_num_q1      <= err_func1;
     end
     if (!header_present_ss_q[2] & header_present_ss[2]) begin
       app_err_func_num_q2      <= err_func2;
     end
     if (!header_present_ss_q[3] & header_present_ss[3]) begin
       app_err_func_num_q2      <= err_func3;
     end 
   end 
   
   
   always @ (posedge clk500) begin
     if (!rst_n) begin
       app_err_valid_q1     <= '0;
       app_err_valid_q2     <= '0;
       app_err_valid_o      <= '0;
       header_present_ss_q  <= '0;
     end
     else begin
       app_err_valid_q1    <= 1'b0;
       app_err_valid_q2    <= 1'b0;
       app_err_valid_o     <= app_err_valid_q1 | app_err_valid_q2;
       header_present_ss_q <= header_present_ss;
       if (!header_present_ss_q[0] & header_present_ss[0]) begin
         app_err_valid_q1 <= 1'b1;
       end
       if (!header_present_ss_q[1] & header_present_ss[1]) begin
         app_err_valid_q1 <= 1'b1;
       end
       if (!header_present_ss_q[2] & header_present_ss[2]) begin
         app_err_valid_q2 <= 1'b1;
       end
       if (!header_present_ss_q[3] & header_present_ss[3]) begin
         app_err_valid_q2 <= 1'b1;
       end
     end
   end
    
      
endmodule // altera_pcie_s10_gen3x16_err_if


// Local Variables:
// verilog-library-directories:(".""./sync_lib/.")
// verilog-auto-inst-param-value: t
// End:
