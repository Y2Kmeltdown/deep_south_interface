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


// $Id: //acds/main/ip/pgm/altera_s10_mailbox_programmable_client/altera_s10_mailbox_programmable_client.sv.terp#2 $
// $Revision: #2 $
// $Date: 2016/05/01 $
// $Author: tgngo $

// -------------------------------------------------------
// S10 Chip ID IP
// -------------------------------------------------------

`timescale 1 ns / 1 ns
module altera_s10_chip_id_controller
  (
   // Clock and reset
   input               clk,
   input               reset,
   // Input signals
   input               readid,
   // Output signals
   output logic        data_valid,
   output logic [63:0] chip_id,
   // Signals to the config debug endpoint
   input               command_ready,
   output logic        command_valid,
   output logic [31:0] command_data,
   output logic        command_startofpacket,
   output logic        command_endofpacket,
        
   output logic        response_ready,
   input               response_valid,
   input [31:0]        response_data,
   input               response_startofpacket,
   input               response_endofpacket
  );
    // Predefined command packet header, for read chip ID, only the header
    // no arg, the command code is 18 (dec)
    localparam HEADER = 32'b 00000000000000000000000000010010;
    logic              readid_sync;
    logic              reset_trigger;
    logic              rff;
    logic              readid_sync_reg;
    logic              readid_trigger_pulse;
    logic              enable_sync;       
    // +-------------------------------------------------------
    // | readid trigger: synchornize readid signal to read ID
    // +-------------------------------------------------------
    altera_chipid_reset_synchronizer i_reset_sync (
        .reset_in_b (readid),
        .clk (clk),
        .reset_out_b (readid_sync)
    );
   
    always_ff @(posedge clk) begin
        if (reset)
            readid_sync_reg <= 1'b0;
        else
            readid_sync_reg <= readid_sync;
    end
    
    assign readid_trigger_pulse = !readid_sync && readid_sync_reg;
    assign enable = readid_trigger_pulse;
    
    // sync input signals, this enable_sync is the one to start sending the command to the config debug endpoint
    always @ (posedge clk) begin
        if (reset)
            enable_sync     <= 1'b0;
        else begin
            enable_sync     <= enable;
        end
    end
    /*
    logic valid;
    always @ (posedge clk) begin
        if (reset_sync) begin
            valid <= 1'b0;
        end 
        else begin
            if (enable_sync)
                valid <= 1'b1;
            else if (command_ready)
                valid <= 1'b0;
        end
    end
     */   
    // State machine
    typedef enum bit [2:0]
    {
     ST_IDLE              = 3'b000,
     ST_SEND_CMD          = 3'b001,
     ST_WAIT_RSP          = 3'b010,
     ST_CHECK_RSP_HEADER  = 3'b011,
     ST_FIRST_RSP_DATA    = 3'b100,
     ST_SECOND_RSP_DATA   = 3'b101,
     ST_DISCARD_RSP       = 3'b110,
     ST_UNUSED            = 3'b111 
     } t_state;
    t_state state, next_state /* synthesis preserve dont_replicate dont_retime */;

	// +--------------------------------------------------
    // | State Machine: update state
    // +--------------------------------------------------
    // |
    always_ff @(posedge clk) begin
        if (reset)
            state <= ST_IDLE;
        else
            state <= next_state;
    end
    // +--------------------------------------------------
    // | State Machine: next state condition
    // +--------------------------------------------------
    always_comb begin
        next_state  = ST_IDLE;
        case (state)
            ST_IDLE: begin
                next_state  = ST_IDLE;
                if (enable_sync)
                    next_state <= ST_SEND_CMD;
            end

            ST_SEND_CMD: begin
                next_state  = ST_SEND_CMD;
                if (command_ready) begin 
                    next_state  = ST_WAIT_RSP;
                end
            end
                        
            ST_WAIT_RSP: begin
                next_state  = ST_WAIT_RSP;
                if (response_valid && response_startofpacket) begin // the header, check the error code
                    if ((response_data[10:0] == 11'd0) & (response_data[22:12] == 11'd2 )) // the response is OKAY and only two response packets then continue else back to IDLE, since this is not correct
                        next_state  = ST_FIRST_RSP_DATA;
                    else
                        next_state  = ST_DISCARD_RSP;
                end
            end

            ST_FIRST_RSP_DATA: begin
                next_state  = ST_FIRST_RSP_DATA;
                if (response_valid) begin 
                    next_state  = ST_SECOND_RSP_DATA;
                end
            end
            
            ST_SECOND_RSP_DATA: begin
                next_state  = ST_SECOND_RSP_DATA;
                if (response_valid && response_endofpacket) begin // it should be endofpacket
                    next_state  = ST_IDLE;
                end
            end

            ST_DISCARD_RSP: begin
                next_state  = ST_DISCARD_RSP;
                if (response_valid && response_endofpacket) begin // assert response ready until endofpacket and back to idle
                    next_state  = ST_IDLE;
                end
            end
            
            ST_UNUSED: next_state  = ST_IDLE;     
        endcase // case (state)
    end // always_comb
    
    // +--------------------------------------------------
    // | State Machine: state outputs
    // +--------------------------------------------------
    assign command_valid  = (state == ST_SEND_CMD) ? 1'b1 : 1'b0;
    assign command_data   = (state == ST_SEND_CMD) ? HEADER : 32'd0;
    assign response_ready  = ((state == ST_IDLE) || (state == ST_SEND_CMD)) ? 1'b0 : 1'b1;
    
    // | 
    // +--------------------------------------------------
    // +--------------------------------------------------
    // | Output mapping
    // +--------------------------------------------------
    always_ff @(posedge clk) begin
        if (reset)
            chip_id <= '0;
        else begin
            if (state == ST_FIRST_RSP_DATA)
                chip_id[31:0] <= response_data;
            if (state == ST_SECOND_RSP_DATA)
                chip_id[63:32] <= response_data;
        end
    end // always_ff @
    
    always_ff @(posedge clk) begin
        if (reset)
            data_valid <= '0;
        else begin
            if (enable_sync)
                data_valid <= 1'b0;
            if ((state == ST_SECOND_RSP_DATA) && response_endofpacket)
                data_valid <= 1'b1;
        end
    end // always_ff @
    
    assign command_startofpacket  = 1'b1;
    assign command_endofpacket  = 1'b1;

endmodule


module altera_chipid_reset_synchronizer
#(
    parameter DEPTH       = 2
)
(
    input   reset_in_b,

    input   clk,
    output  reset_out_b
);

    // -----------------------------------------------
    // Synchronizer register chain. We cannot reuse the
    // standard synchronizer in this implementation 
    // because our timing constraints are different.
    //
    // Instead of cutting the timing path to the d-input 
    // on the first flop we need to cut the aclr input.
    // 
    // We omit the "preserve" attribute on the final
    // output register, so that the synthesis tool can
    // duplicate it where needed.
    // -----------------------------------------------
    // Please check the false paths setting in altera_smartvid SDC
    
    (*preserve*) reg [DEPTH-1:0] altera_chipid_reset_synchronizer_chain;
    reg altera_chipid_reset_synchronizer_chain_out;

    // -----------------------------------------------
    // Assert asynchronously, deassert synchronously.
    // -----------------------------------------------
    always @(posedge clk or posedge reset_in_b) begin
        if (reset_in_b) begin
            altera_chipid_reset_synchronizer_chain <= {DEPTH{1'b1}};
            altera_chipid_reset_synchronizer_chain_out <= 1'b1;
        end
        else begin
            altera_chipid_reset_synchronizer_chain[DEPTH-2:0] <= altera_chipid_reset_synchronizer_chain[DEPTH-1:1];
            altera_chipid_reset_synchronizer_chain[DEPTH-1]   <= 1'b0;
            altera_chipid_reset_synchronizer_chain_out        <= altera_chipid_reset_synchronizer_chain[0];
        end
    end

    assign reset_out_b = altera_chipid_reset_synchronizer_chain_out;

endmodule
