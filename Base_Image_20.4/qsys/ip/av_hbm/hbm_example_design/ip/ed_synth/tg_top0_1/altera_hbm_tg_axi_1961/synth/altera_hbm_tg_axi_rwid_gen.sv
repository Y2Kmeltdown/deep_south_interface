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


//////////////////////////////////////////////////////////////////////////////
// This module generates read/write transaction IDs.
//////////////////////////////////////////////////////////////////////////////
module altera_hbm_tg_axi_rwid_gen # (
   parameter PORT_AXI_RID_WIDTH        = "",
   parameter MAX_ID                    = "",
   parameter WRITE_GEN                 = "",
   parameter TG_USE_EFFICIENCY_PATTERN = "",
   parameter ENABLE_DATA_CHECK         = ""
) (
   // Clock and reset
   input                                 clk,
   input                                 rst,

   // Control and status
   input                                 enable,

   input                                 start,
   output logic [PORT_AXI_RID_WIDTH-1:0] id_out,
   input        [PORT_AXI_RID_WIDTH-1:0] rid,
   input                                 rvalid   
);
   timeunit 1ns;
   timeprecision 1ps;

   import tg_axi_defs::*;
  reg arid_cnt_fifo;
  wire arid_fifo_oe;
  reg [PORT_AXI_RID_WIDTH-1:0] arid_cnt;
  wire [PORT_AXI_RID_WIDTH-1:0] arid_fifo_out;
   generate
     if(WRITE_GEN==0 && TG_USE_EFFICIENCY_PATTERN && ENABLE_DATA_CHECK) begin

        assign arid_fifo_oe = (arid_cnt_fifo)? 1'b0: enable;
        assign id_out = (arid_cnt_fifo)? arid_cnt: arid_fifo_out;        

        scfifo #(
          .add_ram_output_register ("OFF"),
          .enable_ecc              ("FALSE"),
          .intended_device_family  ("Stratix 10"),
          .lpm_hint                ("RAM_BLOCK_TYPE=MLAB"),
          .lpm_numwords            (2**PORT_AXI_RID_WIDTH),
          .lpm_showahead           ("ON"),
          .lpm_type                ("scfifo"),
          .lpm_width               (PORT_AXI_RID_WIDTH),
          .lpm_widthu              (PORT_AXI_RID_WIDTH),
          .overflow_checking       ("OFF"),
          .underflow_checking      ("OFF"),
          .use_eab                 ("ON")
        ) rid_semi_fifo (
          .aclr                     (),
          .sclr                     (start),
          .clock                    (clk),
          .wrreq                    (rvalid),
          .rdreq                    (arid_fifo_oe),
          .data                     (rid),
          .q                        (arid_fifo_out),
          .full                     (),
          .usedw                    (),
          .empty                    (),
          .almost_full              (),
          .almost_empty             (),
          .eccstatus                ()
        );
        
        always_ff @ (posedge clk) begin
          if (rst || start) begin
            arid_cnt_fifo <= 1'b1;
            arid_cnt <= {PORT_AXI_RID_WIDTH{1'b0}};
          end
          else begin
            if(&arid_cnt) arid_cnt_fifo <= 1'b0;
            else if(enable) arid_cnt <= arid_cnt + 1'b1;
          end
        end
      end
      else begin
   always_ff @ (posedge clk)
   begin
      if (rst || start) begin
         id_out             <= '0;
      end
      else if (enable) begin
         id_out <= (MAX_ID == 1) ? '0 : (id_out + 1'b1);
      end
   end
      end
    endgenerate
endmodule

