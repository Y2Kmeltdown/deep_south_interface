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



module altera_pcie_s10_gen3x16_cfg_if
  (
   input logic       clk500, 
   input logic       rst_n,

   input logic       clk250,
   input logic       rst_n_clk250,

   input logic [1:0] tl_cfg_func_i,
   input logic [3:0] tl_cfg_add_i,
   input logic [31:0] tl_cfg_ctl_i,

   output logic [1:0] tl_cfg_func_o,
   output logic [3:0] tl_cfg_add_o,
   output logic [31:0] tl_cfg_ctl_o
   );

    logic [1:0]        tl_cfg_func_q;
    logic [3:0]        tl_cfg_add_q;
    logic [31:0]       tl_cfg_ctl_q;    
    logic [1:0]        tl_cfg_func_q2;
    logic [3:0]        tl_cfg_add_q2; 
    logic [31:0]       tl_cfg_ctl_q2; 

    logic              fifo_wreq;
	logic [37:0]       fifo_wdata,fifo_wdata0,fifo_wdata1,fifo_wdata2,fifo_wdata3;
    logic [37:0]       fifo_rdata0,fifo_rdata1,fifo_rdata2,fifo_rdata3;
    logic [37:0]       fifo_readdata0_s,fifo_readdata1_s,fifo_readdata2_s,fifo_readdata3_s;
    
    logic [3:0]        val,val_s;
    logic              tl_cfg_add_check0_q;
    logic              tl_cfg_func_check0_q;
    
    logic              send_even;
    logic              start;
    logic [3:0]        free_run_valid,free_run_valid_ss,free_run_valid_ss_q;
    
    
     always @ (posedge clk500)
      begin  
      
          tl_cfg_func_q <= tl_cfg_func_i;
          tl_cfg_add_q  <= tl_cfg_add_i;
          tl_cfg_ctl_q  <= tl_cfg_ctl_i;
          //tl_cfg_add_bit0_dly <= tl_cfg_add_q[0];
          tl_cfg_func_q2 <= tl_cfg_func_q;
          tl_cfg_add_q2  <= tl_cfg_add_q;
          tl_cfg_ctl_q2  <= tl_cfg_ctl_q;
          fifo_wdata<= {tl_cfg_ctl_q2, tl_cfg_add_q2, tl_cfg_func_q2};
      end

    always @ (posedge clk500)
      begin
          if (!rst_n)
            begin
                fifo_wreq <= 1'b0;
                send_even <= 1'b1;
                tl_cfg_func_check0_q <= 1'b0;
                tl_cfg_add_check0_q <= 1'b0;
                start     <= 1'b0;
            end
          else
            begin                
                start     <= (tl_cfg_add_q2 != 4'hf) ? 1'b1 : 1'b0;
                tl_cfg_add_check0_q <= (tl_cfg_add_i == 0) ? 1'b1 : 1'b0;
                tl_cfg_func_check0_q <= (tl_cfg_func_i == 0) ? 1'b1 : 1'b0;
                send_even <= (tl_cfg_func_check0_q & tl_cfg_add_check0_q) ? ~send_even : send_even;
                fifo_wreq <= (start) ? (send_even ? (tl_cfg_add_q2[0]) : (!tl_cfg_add_q2[0])) : 1'b0;
            end
      end // always @ (posedge clk500)
 
                
    always_ff @ (posedge clk500) begin
     if (!rst_n) begin
       free_run_valid <= '0;     
     end
     else begin
       if (fifo_wreq & ((free_run_valid[3] & !free_run_valid[0]) | !(|free_run_valid))) begin
         free_run_valid[0] <= 1'b1;       
       end
       if (free_run_valid[1]) begin
         free_run_valid[0] <= 1'b0;
       end
       if (fifo_wreq & free_run_valid[0]) begin
         free_run_valid[1] <= 1'b1;       
       end
       if (free_run_valid[2]) begin
         free_run_valid[1] <= 1'b0;
       end
       if (fifo_wreq & free_run_valid[1]) begin
         free_run_valid[2] <= 1'b1;       
       end
       if (free_run_valid[3]) begin
         free_run_valid[2] <= 1'b0;
       end
       if (fifo_wreq & free_run_valid[2]) begin
         free_run_valid[3] <= 1'b1;       
       end
       if (free_run_valid[0]) begin
         free_run_valid[3] <= 1'b0;
       end
     end  
   end
   
    always_ff @ (posedge clk500) begin
     if (!rst_n) begin
       fifo_wdata0 <= '0;
       fifo_wdata1 <= '0;
       fifo_wdata2 <= '0; 
       fifo_wdata3 <= '0;         
     end
     else begin
       if (fifo_wreq & ((free_run_valid[3] & !free_run_valid[0]) | !(|free_run_valid))) begin
         fifo_wdata0 <= fifo_wdata;
       end
       if (fifo_wreq & free_run_valid[0] & !free_run_valid[1]) begin
          fifo_wdata1 <= fifo_wdata;    
       end
       if (fifo_wreq & free_run_valid[1] & !free_run_valid[2]) begin
          fifo_wdata2 <= fifo_wdata;   
       end
       if (fifo_wreq & free_run_valid[2] & !free_run_valid[3]) begin
          fifo_wdata3 <= fifo_wdata;   
       end
     end  
   end
   sync_bit #(.DWIDTH (4) ) u_free_valid_sync (.clk(clk250), .rst_n(rst_n_clk250), .din(free_run_valid), .dout(free_run_valid_ss));
    
   always_ff @ (posedge clk250) begin
     if (!rst_n_clk250) begin
        val <= '0;
        fifo_rdata0 <= '0;
        fifo_rdata1 <= '0;
        fifo_rdata2 <= '0;
        fifo_rdata3 <= '0;
     end
     else begin
       free_run_valid_ss_q <= free_run_valid_ss;
       if (!free_run_valid_ss_q[0] & free_run_valid_ss[0]) begin
          fifo_rdata0 <= fifo_wdata0;
          val[0] <= '1;
       end
       else begin
         if (!val[3]) begin
           val[0] <= '0;     
         end
       end
       if (!free_run_valid_ss_q[1] & free_run_valid_ss[1]) begin
         val[1] <= '1;
         fifo_rdata1 <= fifo_wdata1;
       end
       else begin
         if (!val[0]) begin
           val[1] <= '0;     
         end
       end
       if (!free_run_valid_ss_q[2] & free_run_valid_ss[2]) begin
         val[2] <= '1;
         fifo_rdata2 <= fifo_wdata2;         
       end
       else begin
         if (!val[1]) begin
           val[2] <= '0;     
         end
       end
       if (!free_run_valid_ss_q[3] & free_run_valid_ss[3]) begin
         val[3] <= '1;
         fifo_rdata3 <= fifo_wdata3;         
       end
       else begin
         if (!val[2]) begin
           val[3] <= '0;     
         end
       end         
     end
   end
   
   
    always_ff @ (posedge clk250) begin      
      case (val_s)
        4'b0001:begin
          tl_cfg_func_o <= fifo_readdata0_s[1:0]; 
          tl_cfg_add_o  <= fifo_readdata0_s[5:2]; 
          tl_cfg_ctl_o  <= fifo_readdata0_s[37:6];
        end
        4'b0010:begin
          tl_cfg_func_o <= fifo_readdata1_s[1:0]; 
          tl_cfg_add_o  <= fifo_readdata1_s[5:2]; 
          tl_cfg_ctl_o  <= fifo_readdata1_s[37:6];
        end
        4'b0100:begin
          tl_cfg_func_o <= fifo_readdata2_s[1:0]; 
          tl_cfg_add_o  <= fifo_readdata2_s[5:2]; 
          tl_cfg_ctl_o  <= fifo_readdata2_s[37:6];
        end
        4'b1000:begin
          tl_cfg_func_o <= fifo_readdata3_s[1:0]; 
          tl_cfg_add_o  <= fifo_readdata3_s[5:2]; 
          tl_cfg_ctl_o  <= fifo_readdata3_s[37:6];
        end
        4'b1001:begin
          tl_cfg_func_o <= fifo_readdata3_s[1:0]; 
          tl_cfg_add_o  <= fifo_readdata3_s[5:2]; 
          tl_cfg_ctl_o  <= fifo_readdata3_s[37:6];
        end
        4'b0011:begin
          tl_cfg_func_o <= fifo_readdata0_s[1:0]; 
          tl_cfg_add_o  <= fifo_readdata0_s[5:2]; 
          tl_cfg_ctl_o  <= fifo_readdata0_s[37:6];
        end
        4'b0110:begin
          tl_cfg_func_o <= fifo_readdata1_s[1:0]; 
          tl_cfg_add_o  <= fifo_readdata1_s[5:2]; 
          tl_cfg_ctl_o  <= fifo_readdata1_s[37:6];
        end
        4'b1100:begin
          tl_cfg_func_o <= fifo_readdata2_s[1:0]; 
          tl_cfg_add_o  <= fifo_readdata2_s[5:2]; 
          tl_cfg_ctl_o  <= fifo_readdata2_s[37:6];
        end
        default: begin
          tl_cfg_func_o <= '0;
          tl_cfg_add_o  <= 4'hF;
          tl_cfg_ctl_o  <= '0;
        end
      endcase        
      val_s <= val;
      fifo_readdata0_s <= fifo_rdata0;
      fifo_readdata1_s <= fifo_rdata1;
      fifo_readdata2_s <= fifo_rdata2;
      fifo_readdata3_s <= fifo_rdata3;
    end  
endmodule
