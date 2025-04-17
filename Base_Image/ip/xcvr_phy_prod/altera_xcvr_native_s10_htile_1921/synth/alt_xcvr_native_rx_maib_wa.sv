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



// File Name: alt_xcvr_native_rx_maib_wa.sv
//
// Description:
//
//    This is the data swap workaround for the known RX MAIB FIFO issue in 10G clock
//    compensation mode.
//    

`timescale 1ps / 1ps


module  alt_xcvr_native_rx_maib_wa
#(
    // General Options
    parameter NUM_CHANNELS           = 1,                // Number of CHANNELS
    parameter WIDTH                  = "odwidth_32",    // Datapath width, from hssi_10g_rx_pcs_gb_rx_odwidth, "odwidth_32" "odwidth_40" "odwidth_50" "odwidth_64" "odwidth_66" or "odwidth_67"
    parameter RX_PCS_PROT_MODE       = "basic",         // RX PCS Protocol Mode, "teng_baser_mode", "teng_baser_krfec_mode" 
    parameter RX_MAIB_FIFO_MODE      = "rxphase_comp",  // RX MAIB FIFO Mode,  "rxclk_comp_10g", "rxphase_comp"
    parameter PRE_REG                = 1,               // pre-register required 
    parameter POST_REG               = 1                // post-register required 

) (
  // inputs and outputs
  input   wire  [NUM_CHANNELS-1:0]    clk  ,     // rx pld clock
  input   wire  [NUM_CHANNELS-1:0]    pld_reset, // reset request for rx_aib
  input   wire  [NUM_CHANNELS-1:0]    rx_fifo_insert, // rx_data_in was inserted by MAIB FIFO        
  input   wire  [NUM_CHANNELS-1:0]    rx_fifo_del,     
  input   wire  [80*NUM_CHANNELS-1:0] rx_data_in,         

  output  wire  [NUM_CHANNELS-1:0]    out_rx_fifo_insert, 
  output  wire  [NUM_CHANNELS-1:0]    out_rx_fifo_del,    
  output  wire  [80*NUM_CHANNELS-1:0] rx_data_out
);

localparam  [35:0]  IDLE_WORD = 36'hF07070707;
localparam  [7:0]   START_B        = 8'hFB;
localparam  [7:0]   OS_SEQ_B       = 8'h9C;
localparam  [7:0]   IDLE_B         = 8'h07;


genvar ig;  
generate

if ( ( (WIDTH=="odwidth_66") || (WIDTH=="odwidth_64") ) && (RX_MAIB_FIFO_MODE=="rxclk_comp_10g") &&
     ( (RX_PCS_PROT_MODE=="teng_baser_mode") || (RX_PCS_PROT_MODE=="teng_baser_krfec_mode") ) ) begin : g_chk_swap


    wire    [NUM_CHANNELS-1:0]   reset_sync;

    for (ig=0; ig<NUM_CHANNELS; ig++) begin : rst_sync
        // Synchronizer
        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH( 3 ),
            .WIDTH( 1 ),
            .INIT_VALUE( 1'b1 )        
        ) reset_synchronizers (
            .clk      ( clk[ig] ),
            .reset    ( pld_reset[ig] ),
            .d        ( 1'b0 ),
            .q        ( reset_sync[ig] )
        );  
    end    // for ig

    wire  [80*NUM_CHANNELS-1:0] pre_data;    
    wire  [NUM_CHANNELS-1:0]    pre_fifo_insert;
    wire  [NUM_CHANNELS-1:0]    pre_fifo_del;

    // pre_data stage   
    if (PRE_REG)  begin  : pre_reg
       reg [80*NUM_CHANNELS-1:0] pre_data_reg;
       reg [NUM_CHANNELS-1:0]    pre_fifo_insert_reg;
       reg [NUM_CHANNELS-1:0]    pre_fifo_del_reg;
       assign pre_data = pre_data_reg;
       assign pre_fifo_insert = pre_fifo_insert_reg;
       assign pre_fifo_del    = pre_fifo_del_reg;
    
         for (ig=0; ig<NUM_CHANNELS; ig++) begin : pre_data_stor
           always @ (posedge clk[ig] or posedge reset_sync[ig] ) begin
               if (reset_sync[ig]) begin
                    pre_data_reg[ig*80 +:80] <= { 4'h0, IDLE_WORD, 4'h0, IDLE_WORD };
                    pre_fifo_insert_reg[ig]  <=  1'b0;
                    pre_fifo_del_reg[ig]     <=  1'b0;
               end 
               else   begin
                    pre_data_reg[ig*80 +:80] <=  rx_data_in[ig*80 +:80];
                    pre_fifo_insert_reg[ig]  <=  rx_fifo_insert[ig];
                    pre_fifo_del_reg[ig]     <=  rx_fifo_del[ig];
               end
           end   // always
         end  // for   
    end else  begin
        assign pre_data        = rx_data_in;
        assign pre_fifo_insert = rx_fifo_insert;
        assign pre_fifo_del    = rx_fifo_del;
    end

    // check and swap stage
    reg  [80*NUM_CHANNELS-1:0] dly_data;
    wire [NUM_CHANNELS-1:0]    data_matching;
    wire [NUM_CHANNELS-1:0]    data_valid, dly_data_valid;
    reg  [NUM_CHANNELS-1:0]    data_matched;
    wire [80*NUM_CHANNELS-1:0] adj_data;
    reg  [NUM_CHANNELS-1:0]    dly_fifo_insert;
    wire [NUM_CHANNELS-1:0]    adj_fifo_insert;
    reg  [NUM_CHANNELS-1:0]    dly_fifo_del;

    
    for (ig=0; ig<NUM_CHANNELS; ig++) begin : data_chk 
        assign data_valid[ig]    = pre_data[80*ig+79];
        assign dly_data_valid[ig]= dly_data[80*ig+79];
        assign data_matching[ig] = dly_data_valid[ig] && data_valid[ig] &&                                                                    // both DWord valid
                                   ( (dly_data[80*ig +:8]==IDLE_B) || (dly_data[80*ig +:8]==OS_SEQ_B) ) && (dly_data[80*ig+32]==1'b1) &&      // L W is IDLE or OS_SEQ on prevous DW
                                   (dly_data[80*ig+40 +:8]==START_B) && (dly_data[80*ig+72 +:4]==4'b0001)    &&                               // U W is START followed by data on previous DW
                                   pre_fifo_insert[ig];                                                                                       // current DW is inserted
        assign adj_data[80*ig +:40]    = dly_data[80*ig +:40];                         // copy lower word 
        assign adj_data[80*ig+40 +:40] = (data_matched[ig] & ~pre_fifo_insert[ig])?  dly_data[ig*80+40 +:40] :
                                         (data_matching[ig])? pre_data[80*ig+40 +:40] : dly_data[80*ig+40 +:40]; 
        assign adj_fifo_insert[ig]     = (data_matching[ig] & ~data_matched[ig] )? 1'b1 :   // upper word of previous dword is IDLE after swap
	                                 dly_fifo_insert[ig];                               // only lower word of last IDLE DWORD is IDLE after swap

                                    
        always @ (posedge clk[ig] or posedge reset_sync[ig] ) begin
            if (reset_sync[ig]) begin
                dly_data[ig*80 +:80]   <=  {4'h0, IDLE_WORD, 4'h0, IDLE_WORD};
                data_matched[ig]       <=  1'b0;
                dly_fifo_insert[ig]    <=  1'b0;
                dly_fifo_del[ig]       <=  1'b0;
            end
            else begin
                dly_data[ig*80 +:40]      <=  pre_data[ig*80 +:40] ;
                dly_data[ig*80+40 +:40]   <=  (data_matching[ig])? dly_data[ig*80+40 +:40] : pre_data[ig*80+40 +:40] ;  // if matching, keep START_Preamble in dly_data
                data_matched[ig]          <=  data_matching[ig];
                dly_fifo_insert[ig]       <=  pre_fifo_insert[ig];
                dly_fifo_del[ig]          <=  pre_fifo_del[ig];
            end
        end   // always
    end    // for
    
    // post_data stage
    if (POST_REG)  begin  : post_reg
        reg [80*NUM_CHANNELS-1:0] post_data_reg;
        reg [NUM_CHANNELS-1:0]    post_fifo_insert_reg;
        reg [NUM_CHANNELS-1:0]    post_fifo_del_reg;
        assign rx_data_out        = post_data_reg;
        assign out_rx_fifo_insert = post_fifo_insert_reg;
        assign out_rx_fifo_del    = post_fifo_del_reg;

        for (ig=0; ig<NUM_CHANNELS; ig++) begin : post_data_stor
   
          always @ (posedge clk[ig] or posedge reset_sync[ig] ) begin
		  if (reset_sync[ig]) begin  
                      post_data_reg[ig*80 +:80] <= {4'h0, IDLE_WORD, 4'h0, IDLE_WORD};
                      post_fifo_insert_reg[ig]  <= 1'b0;
                      post_fifo_del_reg[ig]     <= 1'b0;
                  end
                  else  begin
                      post_data_reg[ig*80 +:80] <=  adj_data[ig*80 +:80];
                      post_fifo_insert_reg[ig]  <=  adj_fifo_insert[ig];
                      post_fifo_del_reg[ig]     <=  dly_fifo_del[ig];
                  end
          end  // always
        end // for
    
     end else  begin
         assign rx_data_out        = adj_data;
         assign out_rx_fifo_insert = adj_fifo_insert;
         assign out_rx_fifo_del    = dly_fifo_del;
     end
    
end    else begin : g_bypass
    assign out_rx_fifo_insert = rx_fifo_insert;
    assign out_rx_fifo_del    = rx_fifo_del;
    assign rx_data_out        = rx_data_in;
end

endgenerate


endmodule

