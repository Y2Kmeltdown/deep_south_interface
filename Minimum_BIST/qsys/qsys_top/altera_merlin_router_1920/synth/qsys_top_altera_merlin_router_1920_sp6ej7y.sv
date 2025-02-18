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



// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/20.3/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2020/07/29 $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// the address.
//
// Also sets the binary-encoded destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

// ------------------------------------------
// Generation parameters:
//    decoder_type            0 (address decoder)
//    default_channel         0
//    default_destid          4
//    default_rd_channel      -1
//    default_wr_channel      -1
//    has_default_slave       0
//    memory_aliasing_decode  0
//    output_name             qsys_top_altera_merlin_router_1920_sp6ej7y
//    pkt_addr_h              67
//    pkt_addr_l              36
//    pkt_dest_id_h           99
//    pkt_dest_id_l           97
//    pkt_protection_h        103
//    pkt_protection_l        101
//    pkt_trans_read          71
//    pkt_trans_write         70
//    slaves_info             4:0001:0x0:0x1000:both:1:0:0:1,3:1000:0x2000:0x2800:both:1:0:0:1,2:0100:0x4000:0x5000:both:1:0:0:1,1:0010:0x5000:0x5100:both:1:0:0:1
//    st_channel_w            5
//    st_data_w               122
// ------------------------------------------

module qsys_top_altera_merlin_router_1920_sp6ej7y_default_decode
  #(
     parameter DEFAULT_CHANNEL = 0,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 4 
   )
  (output [99 - 97 : 0] default_destination_id,
   output [5-1 : 0] default_wr_channel,
   output [5-1 : 0] default_rd_channel,
   output [5-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[99 - 97 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 5'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 5'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 5'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module qsys_top_altera_merlin_router_1920_sp6ej7y
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [122-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [122-1    : 0] src_data,
    output reg [5-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 67;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 99;
    localparam PKT_DEST_ID_L = 97;
    localparam PKT_PROTECTION_H = 103;
    localparam PKT_PROTECTION_L = 101;
    localparam ST_DATA_W = 122;
    localparam ST_CHANNEL_W = 5;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 70;
    localparam PKT_TRANS_READ  = 71;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h5100;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [5-1 : 0] default_src_channel;






    qsys_top_altera_merlin_router_1920_sp6ej7y_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

        // slave 0: [0x0, 0x1000) : sel [14:12]
        if ( {address[14:12],{12 {1'b0}}} == 15'h0   ) begin
            src_channel = 5'b0001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
        end

        // slave 1: [0x2000, 0x2800) : sel [14:11]
        if ( {address[14:11],{11 {1'b0}}} == 15'h2000   ) begin
            src_channel = 5'b1000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
        end

        // slave 2: [0x4000, 0x5000) : sel [14:12]
        if ( {address[14:12],{12 {1'b0}}} == 15'h4000   ) begin
            src_channel = 5'b0100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
        end

        // slave 3: [0x5000, 0x5100) : sel [14:8]
        if ( {address[14:8],{8 {1'b0}}} == 15'h5000   ) begin
            src_channel = 5'b0010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
        end
    end


    // --------------------------------------------------
    // Ceil(log2()) function
    // It's the 21st century. Consider using $clog2().
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


