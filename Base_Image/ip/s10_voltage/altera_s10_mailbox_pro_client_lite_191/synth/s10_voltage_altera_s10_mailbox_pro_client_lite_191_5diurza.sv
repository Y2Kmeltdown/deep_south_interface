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
// Generation parameters:
// length_info: 1
// cmd_info: 32'b00000000000000000001000000011000 32'h00000000
// debug: 0
// -------------------------------------------------------

`timescale 1 ns / 1 ns
module s10_voltage_altera_s10_mailbox_pro_client_lite_191_5diurza #(
        parameter HAS_URGENT            = 0,
        parameter HAS_STREAM            = 0,
        parameter STREAM_WIDTH          = 0,
        parameter HAS_OFFLOAD           = 0,
        parameter NUMB_ARG              = 1,
        parameter CMD_WIDTH             = 6
    ) (
        input                   clk,
        input                   reset,
       

        output logic            cmd_ready,
        input                   cmd_valid,
        input [CMD_WIDTH-1:0]   cmd_data,
        input                   cmd_startofpacket,
        input                   cmd_endofpacket,

        input                   rsp_ready,
        output logic            rsp_valid,
        output logic [31:0]     rsp_data,
        output logic [3:0]      rsp_channel,
        output logic            rsp_startofpacket,
        output logic            rsp_endofpacket
    );

    // ------------------------------------------------------------
    // Calculates the ceil(log2()) of the input val.
    // Limited to a positive 32-bit input value.
    // ------------------------------------------------------------
    function integer clog2;
        input[31:0] val;
        reg[31:0] i;

        begin
            i = 1;
            clog2 = 0;

            while (i < val) begin
                clog2 = clog2 + 1;
                i = i[30:0] << 1;
            end
        end
    endfunction


	localparam ARG_LENGTH    = 2;
    localparam ZERO_PAD      = (CMD_WIDTH < 32) ? 32 - CMD_WIDTH : 0;

    logic               start;
    logic               busy;
    logic               valid_bitmask;
    
    logic               command_ready;
    logic               command_valid;
    logic  [31:0]       command_data;
    logic               command_startofpacket;
    logic               command_endofpacket;
    
    logic               response_ready;
    logic               response_valid;
    logic [31:0]        response_data;
    logic               response_startofpacket;
    logic               response_endofpacket;

    assign start          = cmd_valid && cmd_ready && cmd_startofpacket;
    assign valid_bitmask  = |cmd_data;
    // +-------------------------------------------------------------------------------------------
    // | Build the array of predefined data for all commands - header and arguments
    // +-------------------------------------------------------------------------------------------
    logic [31:0] cmd_header;
    assign cmd_header = 32'b00000000000000000001000000011000;

    // +-------------------------------------------------------------------------------------------
    // | Assert Ready (not busy) at IDLE state, flop cmd_data, sop and eop then deassert for ready
    // | to send header, first arg (if command only one word) then only assert again to send the rest
    // +-------------------------------------------------------------------------------------------
    logic [31:0]            first_arg_data;
    logic [31:0]            arg_data;
    logic [CMD_WIDTH-1:0]   cmd_data_reg;
    logic                   cmd_startofpacket_reg;
    logic                   cmd_endofpacket_reg;

    always_ff @(posedge clk) begin
        if (reset) begin 
            cmd_data_reg          <= '0;
            cmd_startofpacket_reg <= '0;
            cmd_endofpacket_reg   <= '0;
        end
        else begin 
            if (start) begin
                cmd_data_reg          <= cmd_data;
                cmd_startofpacket_reg <= cmd_startofpacket;
                cmd_endofpacket_reg   <= cmd_endofpacket;
            end
        end            
    end

    // Appead zero to build 32 bits arugment
    generate
        if (ZERO_PAD == 0) begin
            assign first_arg_data   = cmd_data_reg;
            assign arg_data         = cmd_data;
        end
        else begin
           assign first_arg_data   = {{ZERO_PAD{1'b0}},cmd_data_reg};
           assign arg_data         = {{ZERO_PAD{1'b0}},cmd_data};
        end
    endgenerate

	// State machine
    typedef enum bit [2:0]
    {
        ST_IDLE           = 3'b000,
        ST_SEND_HEADER    = 3'b001,
        ST_SEND_FIRST_ARG = 3'b010,
        ST_SEND_REST_ARG  = 3'b011,
        ST_WAIT_RSP       = 3'b100,
        ST_UNUSED1        = 3'b101,
        ST_UNUSED2        = 3'b110,
        ST_UNUSED3        = 3'b111
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
                if (start) begin
                    if (valid_bitmask)
                        next_state <= ST_SEND_HEADER;
                    else                            
                        next_state <= ST_IDLE;
                end
            end
            ST_SEND_HEADER: begin 
                next_state = ST_SEND_HEADER;
                if (command_ready)
                    next_state = ST_SEND_FIRST_ARG;
            end
            ST_SEND_FIRST_ARG: begin
                next_state  = ST_SEND_FIRST_ARG;
                if (command_valid && command_ready) begin
                    if (cmd_endofpacket_reg)
                        next_state  = ST_WAIT_RSP;
                    else
                        next_state  = ST_SEND_REST_ARG;
                end
            end
            ST_SEND_REST_ARG: begin
                next_state  = ST_SEND_REST_ARG;
                if (command_valid && command_ready && cmd_endofpacket)
                        next_state  = ST_WAIT_RSP;
            end
            ST_WAIT_RSP : begin
                next_state  = ST_WAIT_RSP;
                if (response_valid && response_ready && response_endofpacket)
                    next_state  = ST_IDLE;
            end
            
            ST_UNUSED1: next_state  = ST_UNUSED2;
            ST_UNUSED2: next_state  = ST_UNUSED3;            
            ST_UNUSED3: next_state  = ST_IDLE;
            
        endcase // case (state)
    end // always_comb
    
    // +--------------------------------------------------
    // | State Machine: state outputs
    // +--------------------------------------------------
    always_comb begin
        command_valid  = '0;
        busy           = '0;
        command_data   = '0;
        cmd_ready      = '0;
        case (state)
            ST_IDLE: begin
                command_valid  = '0;
                busy           = '0;
                command_data   = '0;
                cmd_ready      = command_ready;
            end
            ST_SEND_HEADER: begin 
                command_valid  = 1'b1;
                busy           = 1'b1;
                command_data   = cmd_header;
                cmd_ready      = '0;
            end
            ST_SEND_FIRST_ARG: begin 
                command_valid  = 1'b1;
                busy           = 1'b1;
                command_data   = first_arg_data;
                cmd_ready      = '0;
            end
            ST_SEND_REST_ARG: begin 
                command_valid  = cmd_valid;
                busy           = 1'b1;
                command_data   = arg_data;
                cmd_ready      = command_ready;
            end
            ST_WAIT_RSP : begin 
            	command_valid  = '0;
            	busy           = 1'b1;
                cmd_ready      = '0;
            end
        endcase // case (state)
    end
    // | 
    // +--------------------------------------------------

    // +--------------------------------------------------
    // | Command output mapping
    // +--------------------------------------------------
    always_comb begin
    	command_startofpacket 	= (state == ST_SEND_HEADER);
        if ((state == ST_SEND_FIRST_ARG) && cmd_endofpacket_reg)
            command_endofpacket = 1'b1;
        else if (state == ST_SEND_REST_ARG)
            command_endofpacket = cmd_endofpacket;
        else
            command_endofpacket = '0;
    end
    // +--------------------------------------------------
    // | Response output mapping
    // +--------------------------------------------------
    // | Process the response packet to reconstruct the channel 
    // | ex: if user set bitmask: 1011 then the response packet back 
    // | will have 4 words, first header -> drop
    // |           3 words, send to client with accordinly channel: 0, 1, 3
    // +----------------------------------------------------------------------
    s10_voltage_altera_s10_mailbox_pro_client_lite_191_5diurza_response_pck_process #(
        // user 16, as the voltage sensor use 16 channels, 
        .REQ_WIDTH   (16)
    ) s10_voltage_altera_s10_mailbox_pro_client_lite_191_5diurza_response_pck_process_0 (
        .clk                    (clk),
        .reset                  (reset),
        .req_channel            (first_arg_data[15:0]),
        .rsp_ready              (rsp_ready),
        .rsp_valid              (rsp_valid),
        .rsp_data               (rsp_data),
        .rsp_channel            (rsp_channel),
        .rsp_startofpacket      (rsp_startofpacket),
        .rsp_endofpacket        (rsp_endofpacket),
        .response_ready         (response_ready),
        .response_valid         (response_valid),
        .response_data          (response_data),
        .response_startofpacket (response_startofpacket),
        .response_endofpacket   (response_endofpacket)
    );

    // +--------------------------------------------------
    // | If not debug (export signals to top level for simulation)
    // | connect to the config stream endpoint
    // +--------------------------------------------------
    config_stream_ep #(
        .READY_LATENCY  (0),
        .HAS_URGENT     (0),
        .HAS_STREAM     (0)
        //.CLOCK_RATE_CLK (0)
    ) config_stream_endpoint_0 (
        .clk                    (clk),
        .reset                  (reset),
        .command_ready          (command_ready),
        .command_valid          (command_valid),
        .command_data           (command_data),
        .command_startofpacket  (command_startofpacket),
        .command_endofpacket    (command_endofpacket),
        .response_ready         (response_ready),
        .response_valid         (response_valid),
        .response_data          (response_data),
        .response_startofpacket (response_startofpacket),
        .response_endofpacket   (response_endofpacket)
    );
endmodule

// +--------------------------------------------------
// | This component reads bitmask then rebuild the 
// | channel value to send back to client.
// +--------------------------------------------------
module s10_voltage_altera_s10_mailbox_pro_client_lite_191_5diurza_response_pck_process #(
        parameter REQ_WIDTH     = 6
    ) (
        input                   clk,
        input                   reset,
        input [REQ_WIDTH-1:0]   req_channel,
            
        output logic            response_ready,
        input                   response_valid,
        input [31:0]            response_data,
        input                   response_startofpacket,
        input                   response_endofpacket,

        input                   rsp_ready,
        output logic            rsp_valid,
        output logic [31:0]     rsp_data,
        output logic [3:0]      rsp_channel,
        output logic            rsp_startofpacket,
        output logic            rsp_endofpacket

    );

    logic [3:0] counter;
    logic       sop_enable;
    logic       channel_valid;

    assign channel_valid = req_channel[counter];

    // State machine
    typedef enum bit [2:0]
    {
        ST_IDLE           = 3'b000,
        ST_DROP_HEADER    = 3'b001,
        ST_CHECK_CHANNEL  = 3'b010,
        ST_SEND_RSP       = 3'b011,
        ST_BYPASS         = 3'b100,
        ST_UNUSED1        = 3'b101,
        ST_UNUSED2        = 3'b110,
        ST_UNUSED3        = 3'b111
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
                if (response_startofpacket && response_valid)
                    next_state  = ST_DROP_HEADER;
            end
            ST_DROP_HEADER: begin
                next_state  = ST_DROP_HEADER;
                if (response_valid) begin
                    // header always drops, in case error comeback, only header, should take it then back to idle
                    // should not send anything back to user.
                    if (response_endofpacket)
                        next_state  = ST_IDLE; 
                    else
                        next_state  = ST_CHECK_CHANNEL;
                end
            end
            ST_CHECK_CHANNEL: begin 
                next_state = ST_CHECK_CHANNEL;
                if (channel_valid)
                    next_state = ST_SEND_RSP;
                else 
                    next_state = ST_BYPASS;

            end
            ST_SEND_RSP: begin 
                next_state = ST_SEND_RSP;
                if (response_valid && response_ready) begin
                    if (response_endofpacket)
                        next_state = ST_IDLE;
                    else    
                        next_state = ST_CHECK_CHANNEL;
                end
            end
            ST_BYPASS: begin 
                next_state = ST_CHECK_CHANNEL;
            end
            
            ST_UNUSED1: next_state  = ST_UNUSED2;   
            ST_UNUSED2: next_state  = ST_UNUSED3; 
            ST_UNUSED3: next_state  = ST_IDLE; 
             
        endcase // case (state)
    end // always_comb
    
    // +--------------------------------------------------
    // | State Machine: state outputs
    // +--------------------------------------------------
    always_comb begin
        rsp_valid               = '0;
        rsp_data                = '0;
        response_ready           = 0;
         case (state)
            ST_IDLE: begin
                 rsp_valid               = '0;
                 rsp_data                = '0;
                 response_ready           = 0;
            end
             ST_DROP_HEADER: begin 
                 rsp_valid               = '0;
                 rsp_data                = '0;
                 response_ready          = 1'b1;
             end
             ST_CHECK_CHANNEL: begin 
                 rsp_valid               = '0;
                 rsp_data                = '0;
                 response_ready          = '0;
             end
             ST_SEND_RSP: begin 
                 rsp_valid               = response_valid;
                 rsp_data                =  response_data;
                 //rsp_valid               = 1'b1;
                 //response_ready          = 1'b1;
                 response_ready          = rsp_ready;
             end
             ST_BYPASS: begin 
                 rsp_valid               = '0;
                 rsp_data                = '0;
                 response_ready          = '0;
             end
         endcase // case (state)
     end
    // | 
    // +--------------------------------------------------

    assign rsp_startofpacket    = sop_enable;
    assign rsp_endofpacket      = response_endofpacket;
    assign rsp_channel          = counter;

    always_ff @(posedge clk) begin 
        if (reset)
            counter <= '0;
        else begin 
            if (((state == ST_SEND_RSP) && (response_valid && response_ready)) || (state == ST_BYPASS))
                counter <= counter + 4'h1;
            if (state == ST_IDLE)
                counter <= '0;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            sop_enable <= 1'b1;
        end
        else begin
            if (rsp_valid && rsp_ready) begin
                sop_enable <= 1'b0;
                if (rsp_endofpacket)
                    sop_enable <= 1'b1;
            end
        end
    end

endmodule


