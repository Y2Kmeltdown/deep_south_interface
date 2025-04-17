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


//////////////////////////////////////////////////////////////////////////////////
// This module implements a simple AXI traffic generator intending
// to answer the basic question of: "is the memory subsystem functionally capable
// of performing the simplest reads and writes after a successful calibration?"
// This simple traffic generator can be a useful tool during initial bring-up
// for basic sanity checking.
//
// Performance and efficiency are not important consideration for this simple
// traffic generator.  In fact, highly efficient traffic patterns (e.g. long bursts
// of data on the DRAM data bus with aggressive data pattern) are not desired as
// they may expose timing marginality and/or signal and power integrity issues on
// hardware, clouding the answer to the basic question we pose above.
//
//////////////////////////////////////////////////////////////////////////////
module altera_hbm_tg_axi_driver_simple # (
    parameter TG_TEST_DURATION              = "",
    parameter AMM_BURSTCOUNT_WIDTH          = "",
    parameter MEM_ADDR_WIDTH                = "",
    parameter WORD_ADDRESS_DIVISIBLE_BY     = "",
    parameter BURST_LEN                     = "",
    parameter PORT_AXI_AWID_WIDTH           = "",
    parameter PORT_AXI_AWADDR_WIDTH         = "",
    parameter PORT_AXI_AWQOS_WIDTH          = "",
    parameter PORT_AXI_AWUSER_AP_WIDTH      = "",
    parameter PORT_AXI_AWLEN_WIDTH          = "",
    parameter PORT_AXI_WDATA_WIDTH          = "",
    parameter PORT_AXI_WSTRB_WIDTH          = "",
    parameter PORT_AXI_BID_WIDTH            = "",
    parameter PORT_AXI_BRESP_WIDTH          = "",
    parameter PORT_AXI_ARID_WIDTH           = "",
    parameter PORT_AXI_ARADDR_WIDTH         = "",
    parameter PORT_AXI_ARQOS_WIDTH          = "",
    parameter PORT_AXI_ARUSER_AP_WIDTH      = "",
    parameter PORT_AXI_ARLEN_WIDTH          = "",
    parameter PORT_AXI_RID_WIDTH            = "",
    parameter PORT_AXI_RDATA_WIDTH          = "",
    parameter PORT_AXI_RRESP_WIDTH          = "",
    parameter BURST_LEN_EXTEND_EN           = "",
    parameter MAX_BURST_COUNT               = ""    
)(
    input   logic                                   clk,
    input   logic                                   reset_n,

    //  User Interface (AXI4)
    //  Write Address Channels
    output  logic   [PORT_AXI_AWID_WIDTH-1:0]       awid,
    output  logic   [PORT_AXI_AWADDR_WIDTH-1:0]     awaddr,
    output  logic   [PORT_AXI_AWQOS_WIDTH-1:0]      awqos,
    output  logic   [PORT_AXI_AWUSER_AP_WIDTH-1:0]  awuser_ap,
    output  logic   [PORT_AXI_AWLEN_WIDTH-1:0]      awlen,    
    output  logic                                   awvalid,
    input   logic                                   awready,

    //  Write Data Channels
    output  logic   [PORT_AXI_WDATA_WIDTH-1:0]      wdata,
    output  logic   [PORT_AXI_WSTRB_WIDTH-1:0]      wstrb,
    output  logic                                   wlast,
    output  logic                                   wvalid,
    input   logic                                   wready,

    //  Write Response Channel
    input   logic   [PORT_AXI_BID_WIDTH-1:0]        bid,
    input   logic   [PORT_AXI_BRESP_WIDTH-1:0]      bresp,
    input   logic                                   bvalid,
    output  logic                                   bready,

    //  Read Address Channels
    output  logic   [PORT_AXI_ARID_WIDTH-1:0]       arid,
    output  logic   [PORT_AXI_ARADDR_WIDTH-1:0]     araddr,
    output  logic   [PORT_AXI_ARQOS_WIDTH-1:0]      arqos,
    output  logic   [PORT_AXI_ARUSER_AP_WIDTH-1:0]  aruser_ap,
    output  logic   [PORT_AXI_ARLEN_WIDTH-1:0]      arlen,    
    output  logic                                   arvalid,
    input   logic                                   arready,

    //  Read Data Channels
    input   logic   [PORT_AXI_RID_WIDTH-1:0]        rid,
    input   logic   [PORT_AXI_RDATA_WIDTH-1:0]      rdata,
    input   logic   [PORT_AXI_RRESP_WIDTH-1:0]      rresp,
    input   logic                                   rlast,
    input   logic                                   rvalid,
    output  logic                                   rready,

    //Status information from the status checker
    output  logic                                   pass,
    output  logic                                   fail,
    output  logic   [PORT_AXI_RDATA_WIDTH-1:0]      pnf_per_bit,
    output  logic   [PORT_AXI_RDATA_WIDTH-1:0]      pnf_per_bit_persist,
    output  logic                                   mmr_check_en

) /* synthesis dont_merge syn_preserve = 1 */;

    // Options available through TG_TEST_DURATION:
    //     1) SHORT : will just issue single Write and Read with address and data set to constant 0 and all 1 respectively
    //     2) MEDIUM_SIM : will issue 1024 Writes and Reads with data and address increment every burst - more suitable for RTL simulation
    //     3) MEDIUM : will issue significant number of Writes and Reads with data and address increment every burst - for hardware debugging
    //     4) INFINITE - will issue non-stop Writes and Reads with data and address increment every burst - for more thorough hardware verification
    // Coution: Changing TG_TEST_DURATION / USE_CONSTANT_ADDR / USE_CONSTANT_DATA / LOOP_COUNT_WIDTH value will affect timing.

    // Indicates whether to use a constant address. If 0, word address is incremented for every burst.
    localparam USE_CONSTANT_ADDR = (TG_TEST_DURATION == "SHORT" ? 1 : 0);

    // Indicates whether to use constant data. If 0, data is incremented for every burst.
    localparam USE_CONSTANT_DATA = (TG_TEST_DURATION == "SHORT" ? 1 : 0);

    // Determines how many loops to perform. Number of loops = 2^LOOP_COUNTER_WIDTH - 1.
    localparam LOOP_COUNT_WIDTH = (TG_TEST_DURATION == "MEDIUM")        ? 100  :
                                  (TG_TEST_DURATION == "MEDIUM_SIM")    ? 3    : 
                                  (TG_TEST_DURATION == "SHORT")         ? 1    : 1;

    // Append '0' padding which eventually will be drop by controller
    localparam ADDR_PAD = PORT_AXI_AWADDR_WIDTH - MEM_ADDR_WIDTH + WORD_ADDRESS_DIVISIBLE_BY + $clog2(BURST_LEN);
    localparam MAX_LEN = MAX_BURST_COUNT - 1;

    logic [PORT_AXI_AWID_WIDTH-1:0]                 nxt_awid;
    logic [PORT_AXI_AWADDR_WIDTH-1:0]               nxt_awaddr;
    logic [PORT_AXI_AWUSER_AP_WIDTH-1:0]            nxt_awuser_ap;
    logic                                           nxt_awvalid;
    logic [PORT_AXI_WDATA_WIDTH-1:0]                nxt_wdata;
    logic [PORT_AXI_WSTRB_WIDTH-1:0]                nxt_wstrb;
    logic                                           nxt_wlast;
    logic                                           nxt_wvalid;
    logic                                           nxt_bready;
    logic [PORT_AXI_ARID_WIDTH-1:0]                 nxt_arid;
    logic [PORT_AXI_ARADDR_WIDTH-1:0]               nxt_araddr;
    logic [PORT_AXI_ARUSER_AP_WIDTH-1:0]            nxt_aruser_ap;
    logic                                           nxt_arvalid;
    logic                                           nxt_rready;
    logic                                           nxt_pass;
    logic                                           nxt_fail;
    logic [PORT_AXI_RDATA_WIDTH-1:0]                nxt_pnf_per_bit;
    logic [PORT_AXI_RDATA_WIDTH-1:0]                nxt_pnf_per_bit_persist;

    logic [LOOP_COUNT_WIDTH-1:0]                    aw_loop_count;
    logic [LOOP_COUNT_WIDTH-1:0]                    nxt_aw_loop_count;
    logic [AMM_BURSTCOUNT_WIDTH-1:0]                wd_burst_count;
    logic [AMM_BURSTCOUNT_WIDTH-1:0]                nxt_wd_burst_count;
    logic [LOOP_COUNT_WIDTH-1:0]                    wd_loop_count;
    logic [LOOP_COUNT_WIDTH-1:0]                    nxt_wd_loop_count;
    logic [LOOP_COUNT_WIDTH-1:0]                    ar_loop_count;
    logic [LOOP_COUNT_WIDTH-1:0]                    nxt_ar_loop_count;
    logic [PORT_AXI_RDATA_WIDTH-1:0]                exp_rdata;
    logic [PORT_AXI_RDATA_WIDTH-1:0]                nxt_exp_rdata;
    logic [AMM_BURSTCOUNT_WIDTH-1:0]                rd_burst_count;
    logic [AMM_BURSTCOUNT_WIDTH-1:0]                nxt_rd_burst_count;
    logic [LOOP_COUNT_WIDTH-1:0]                    rd_loop_count;
    logic [LOOP_COUNT_WIDTH-1:0]                    nxt_rd_loop_count;

    logic [4-1:0]                                   issp_control;
    logic                                           do_const_addr;
    logic                                           do_const_data;
    logic                                           do_infinite;
    logic [3:0] pnf_per_bit_persist_and;
    localparam MAX_DIV=4;
    genvar i;
    generate
	    for (i=1; i<=MAX_DIV; i=i+1) begin : pnf_bit_port_width
	    	always_ff @(posedge clk)
			pnf_per_bit_persist_and [i-1] <= & pnf_per_bit_persist[(i*PORT_AXI_RDATA_WIDTH/MAX_DIV)-1:(i-1)*PORT_AXI_RDATA_WIDTH/MAX_DIV];
	    end
    endgenerate
    
    logic wd_burst_count_eq_1, wd_burst_count_eq_0;
    enum int unsigned {
        INIT,
        WRITE,
        WRITE_DATA,
        READ,
        COMPARE_DATA,
        WAIT_FOR_READY,
        WAIT_FOR_BVALID,
        WAIT_FOR_WRITE,
        DONE
    } aw_state, nxt_aw_state, wd_state, nxt_wd_state, ar_state, nxt_ar_state, rd_state, nxt_rd_state;
    // When ALTERA_EMIF_ENABLE_ISSP is defined, user has the option to control
    // the simple driver bahaviour at the runtime without need to recompile.
    // Options available through TGIC instance:
    //     1) XXX1 - Take over the simple driver control for generating addr, data and loop
    //     2) XX11 - Do constant addr
    //     3) X1X1 - Do constant data
    //     4) 1XX1 - Do infinite loop
    assign do_const_addr    = (issp_control[0] == 1'b1) ? issp_control[1] : USE_CONSTANT_ADDR;
    assign do_const_data    = (issp_control[0] == 1'b1) ? issp_control[2] : USE_CONSTANT_DATA;
    assign do_infinite      = (issp_control[0] == 1'b1) ? issp_control[3] : TG_TEST_DURATION == "INFINITE";

    // Registered all output for better timing.
    always_ff @(posedge clk)
    begin
        if (!reset_n) begin
            awid                <= '0;
            awaddr              <= '0;
            awqos               <= '0;
            awuser_ap           <= '0;
            awvalid             <= '0;
            wdata               <= '0;
            wstrb               <= '0;
            wlast               <= '0;
            wvalid              <= '0;
            bready              <= '0;
            arid                <= '0;
            araddr              <= '0;
            arqos               <= '0;
            aruser_ap           <= '0;
            arvalid             <= '0;
            rready              <= '0;
            pass                <= '0;
            fail                <= '0;
            pnf_per_bit         <= '1;
            pnf_per_bit_persist <= '1;

            aw_loop_count       <= '0;
            wd_burst_count      <= '0;
            wd_loop_count       <= '0;
            ar_loop_count       <= '0;
            exp_rdata           <= '0;
            rd_burst_count      <= '0;
            rd_loop_count       <= '0;
            aw_state            <= INIT;
            wd_state            <= INIT;
            ar_state            <= INIT;
            rd_state            <= INIT;
            wd_burst_count_eq_1 <= '0;
            wd_burst_count_eq_0 <= '0;
        end else begin
            awid                <= nxt_awid;
            awaddr              <= nxt_awaddr;
            awqos               <= '0;
            awuser_ap           <= nxt_awuser_ap;
            awvalid             <= nxt_awvalid;
            wdata               <= nxt_wdata;
            wstrb               <= nxt_wstrb;
            wlast               <= nxt_wlast;
            wvalid              <= nxt_wvalid;
            bready              <= '1;
            arid                <= nxt_arid;
            araddr              <= nxt_araddr;
            arqos               <= '0;
            aruser_ap           <= nxt_aruser_ap;
            arvalid             <= nxt_arvalid;
            rready              <= '1;
            pass                <= nxt_pass;
	    fail                <= nxt_fail;
            pnf_per_bit         <= nxt_pnf_per_bit;
            pnf_per_bit_persist <= nxt_pnf_per_bit_persist;

            aw_loop_count       <= nxt_aw_loop_count;
            wd_burst_count      <= nxt_wd_burst_count;
            wd_burst_count_eq_1 <= (nxt_wd_burst_count=='b1);
            wd_burst_count_eq_0 <= (nxt_wd_burst_count=='b0);
            wd_loop_count       <= nxt_wd_loop_count;
            ar_loop_count       <= nxt_ar_loop_count;
            exp_rdata           <= nxt_exp_rdata;
            rd_burst_count      <= nxt_rd_burst_count;
            rd_loop_count       <= nxt_rd_loop_count;
            aw_state            <= nxt_aw_state;
            wd_state            <= nxt_wd_state;
            ar_state            <= nxt_ar_state;
            rd_state            <= nxt_rd_state;
        end
    end

    // AXI has 5 separate interfaces that independent from each other.
    // However for simplification and to avoid overwrite issue or reading
    // from uninitialize location, this simple driver will ensure that
    // Read only occur after a complate Write being accepted by controller
    // which indicated by 'bvalid' signal. Though, the code still being
    // writen in such way that it separate each interface's state machine
    // and the loop counter so that user can easily modify the code to break
    // the dependency if needed. For example User can do Write back to back
    // by modifying the 'aw_state' to loop within WAIT_FOR_READY without
    // without need to worry it affect other interfaces' code or behaviour.

    always_comb
    begin

        case(aw_state)
            INIT: begin
                nxt_awid            <= '0;
                nxt_awaddr          <= (do_const_addr ? '0 : awaddr);
                nxt_awuser_ap       <= '0;
                nxt_awvalid         <= '0;

                nxt_aw_loop_count   <= '0;
                nxt_aw_state        <= WRITE;
            end

            WRITE: begin
                nxt_awid            <= '0;
                nxt_awaddr          <= (do_const_addr ? '0 : awaddr);
                nxt_awuser_ap       <= '0;
                nxt_awvalid         <= '1;

                nxt_aw_loop_count   <= aw_loop_count;
                nxt_aw_state        <= WAIT_FOR_READY;
            end

            WAIT_FOR_READY: begin
                if (awready) begin
                    nxt_awid            <= '0;
                    nxt_awaddr          <= (do_const_addr ? '0 : awaddr + {1'b1,{ADDR_PAD{1'b0}}});
                    nxt_awuser_ap       <= '0;
                    nxt_awvalid         <= '0;

                    nxt_aw_loop_count   <= (do_infinite ? '0 : aw_loop_count + 1'b1);
                    nxt_aw_state        <= WAIT_FOR_BVALID;
                end else begin
                    nxt_awid            <= '0;
                    nxt_awaddr          <= (do_const_addr ? '0 : awaddr);
                    nxt_awuser_ap       <= '0;
                    nxt_awvalid         <= '1;

                    nxt_aw_loop_count   <= aw_loop_count;
                    nxt_aw_state        <= WAIT_FOR_READY;
                end
            end

            WAIT_FOR_BVALID: begin
                if (bvalid) begin
                    if (&aw_loop_count) begin
                        nxt_awid            <= '0;
                        nxt_awaddr          <= (do_const_addr ? '0 : awaddr);
                        nxt_awuser_ap       <= '0;
                        nxt_awvalid         <= '0;

                        nxt_aw_loop_count   <= aw_loop_count;
                        nxt_aw_state        <= DONE;
                    end else begin
                        nxt_awid            <= '0;
                        nxt_awaddr          <= (do_const_addr ? '0 : awaddr);
                        nxt_awuser_ap       <= '0;
                        nxt_awvalid         <= '0;

                        nxt_aw_loop_count   <= aw_loop_count;
                        nxt_aw_state        <= WRITE;
                    end
                end else begin
                    nxt_awid            <= '0;
                    nxt_awaddr          <= (do_const_addr ? '0 : awaddr);
                    nxt_awuser_ap       <= '0;
                    nxt_awvalid         <= '0;

                    nxt_aw_loop_count   <= aw_loop_count;
                    nxt_aw_state        <= WAIT_FOR_BVALID;
                end
            end

            DONE: begin
                nxt_awid            <= '0;
                nxt_awaddr          <= (do_const_addr ? '0 : awaddr);
                nxt_awuser_ap       <= '0;
                nxt_awvalid         <= '0;

                nxt_aw_loop_count   <= aw_loop_count;
                nxt_aw_state        <= DONE;
            end
        endcase
    end

    always_comb
    begin

        case(wd_state)
            INIT: begin
                nxt_wdata           <= (do_const_data ? '1 : wdata);
                nxt_wstrb           <= '0;
                nxt_wlast           <= '0;
                nxt_wvalid          <= '0;

                nxt_wd_burst_count  <= BURST_LEN;
                nxt_wd_loop_count   <= '0;
                nxt_wd_state        <= aw_state == WAIT_FOR_BVALID ? WRITE_DATA : INIT;
            end

            WRITE_DATA: begin
                nxt_wdata           <= (do_const_data ? '1 : wdata);
                nxt_wstrb           <= '1;
                nxt_wlast           <= BURST_LEN == 1 ? '1 : '0;
                nxt_wvalid          <= '1;

                nxt_wd_burst_count  <= wd_burst_count - 1'b1;
                nxt_wd_loop_count   <= wd_loop_count;
                nxt_wd_state        <= WAIT_FOR_READY;
            end

            WAIT_FOR_READY: begin
                if (wready) begin
                    if (wd_burst_count_eq_0) begin
                        // Break the long path adder to improve timing on higher frequency.
                        // As the consequent, data will appear the same for 2 memory burst
                        nxt_wdata           <= (do_const_data ? '1 : {wdata[PORT_AXI_WDATA_WIDTH-1:PORT_AXI_WDATA_WIDTH/2] + 1'b1 , wdata[PORT_AXI_WDATA_WIDTH/2-1:0] + 1'b1});
                        nxt_wstrb           <= '0;
                        nxt_wlast           <= '0;
                        nxt_wvalid          <= '0;

                        nxt_wd_burst_count  <= BURST_LEN;
                        nxt_wd_loop_count   <= (do_infinite ? '0 : wd_loop_count + 1'b1);
                        nxt_wd_state        <= WAIT_FOR_BVALID;
                    end else if (wd_burst_count_eq_1) begin
                        nxt_wdata           <= (do_const_data ? '1 : {wdata[PORT_AXI_WDATA_WIDTH-1:PORT_AXI_WDATA_WIDTH/2] + 1'b1 , wdata[PORT_AXI_WDATA_WIDTH/2-1:0] + 1'b1});
                        nxt_wstrb           <= '1;
                        nxt_wlast           <= '1;
                        nxt_wvalid          <= '1;

                        nxt_wd_burst_count  <= wd_burst_count - 1'b1;
                        nxt_wd_loop_count   <= wd_loop_count;
                        nxt_wd_state        <= WAIT_FOR_READY;
                    end else begin
                        nxt_wdata           <= (do_const_data ? '1 : {wdata[PORT_AXI_WDATA_WIDTH-1:PORT_AXI_WDATA_WIDTH/2] + 1'b1 , wdata[PORT_AXI_WDATA_WIDTH/2-1:0] + 1'b1});
                        nxt_wstrb           <= '1;
                        nxt_wlast           <= '0;
                        nxt_wvalid          <= '1;

                        nxt_wd_burst_count  <= wd_burst_count - 1'b1;
                        nxt_wd_loop_count   <= wd_loop_count;
                        nxt_wd_state        <= WAIT_FOR_READY;
                    end
                end else begin
                    if (wd_burst_count_eq_1) begin
                        nxt_wdata           <= (do_const_data ? '1 : wdata);
                        nxt_wstrb           <= '1;
                        nxt_wlast           <= '1;
                        nxt_wvalid          <= '1;

                        nxt_wd_burst_count  <= wd_burst_count;
                        nxt_wd_loop_count   <= wd_loop_count;
                        nxt_wd_state        <= WAIT_FOR_READY;
                    end else begin
                        nxt_wdata               <= (do_const_data ? '1 : wdata);
                        nxt_wstrb               <= '1;
                        nxt_wlast               <= '0;
                        nxt_wvalid              <= '1;

                        nxt_wd_burst_count      <= wd_burst_count;
                        nxt_wd_loop_count       <= wd_loop_count;
                        nxt_wd_state            <= WAIT_FOR_READY;
                    end
                end
            end

            WAIT_FOR_BVALID: begin
                if (bvalid) begin
                    if (&wd_loop_count) begin
                        nxt_wdata           <= (do_const_data ? '1 : wdata);
                        nxt_wstrb           <= '0;
                        nxt_wlast           <= '0;
                        nxt_wvalid          <= '0;

                        nxt_wd_burst_count  <= BURST_LEN;
                        nxt_wd_loop_count   <= wd_loop_count;
                        nxt_wd_state        <= DONE;
                    end else begin
                        nxt_wdata           <= (do_const_data ? '1 : wdata);
                        nxt_wstrb           <= '0;
                        nxt_wlast           <= '0;
                        nxt_wvalid          <= '0;

                        nxt_wd_burst_count  <= BURST_LEN;
                        nxt_wd_loop_count   <= wd_loop_count;
                        nxt_wd_state        <= WRITE_DATA;
                    end
                end else begin
                    nxt_wdata           <= (do_const_data ? '1 : wdata);
                    nxt_wstrb           <= '0;
                    nxt_wlast           <= '0;
                    nxt_wvalid          <= '0;

                    nxt_wd_burst_count  <= BURST_LEN;
                    nxt_wd_loop_count   <= wd_loop_count;
                    nxt_wd_state        <= WAIT_FOR_BVALID;
                end
            end

            DONE: begin
                nxt_wdata           <= (do_const_data ? '1 : wdata);
                nxt_wstrb           <= '0;
                nxt_wlast           <= '0;
                nxt_wvalid          <= '0;

                nxt_wd_burst_count  <= BURST_LEN;
                nxt_wd_loop_count   <= wd_loop_count;
                nxt_wd_state        <= DONE;
            end
        endcase
    end

    always_comb
    begin

        case(ar_state)
            INIT: begin
                nxt_arid            <= '0;
                nxt_araddr          <= (do_const_addr ? '0 : araddr);
                nxt_aruser_ap       <= '0;
                nxt_arvalid         <= '0;

                nxt_ar_loop_count   <= '0;
                nxt_ar_state        <= WAIT_FOR_WRITE;
            end

            WAIT_FOR_WRITE: begin
                if (bvalid) begin
                    nxt_arid            <= '0;
                    nxt_araddr          <= (do_const_addr ? '0 : araddr);
                    nxt_aruser_ap       <= '0;
                    nxt_arvalid         <= '1;

                    nxt_ar_loop_count   <= ar_loop_count;
                    nxt_ar_state        <= READ;
                end else begin
                    nxt_arid            <= '0;
                    nxt_araddr          <= (do_const_addr ? '0 : araddr);
                    nxt_aruser_ap       <= '0;
                    nxt_arvalid         <= '0;

                    nxt_ar_loop_count   <= ar_loop_count;
                    nxt_ar_state        <= WAIT_FOR_WRITE;
                end
            end

            READ: begin
                if (arready) begin
                    nxt_arid            <= '0;
                    nxt_araddr          <= (do_const_addr ? '0 : araddr + {1'b1,{ADDR_PAD{1'b0}}});
                    nxt_aruser_ap       <= '0;
                    nxt_arvalid         <= '0;

                    nxt_ar_loop_count   <= (do_infinite ? '0 : ar_loop_count + 1'b1);
                    nxt_ar_state        <= WAIT_FOR_BVALID;
                end else begin
                    nxt_arid            <= '0;
                    nxt_araddr          <= (do_const_addr ? '0 : araddr);
                    nxt_aruser_ap       <= '0;
                    nxt_arvalid         <= '1;

                    nxt_ar_loop_count   <= ar_loop_count;
                    nxt_ar_state        <= READ;
                end
            end

            WAIT_FOR_BVALID: begin
                if (&ar_loop_count) begin
                    nxt_arid            <= '0;
                    nxt_araddr          <= (do_const_addr ? '0 : araddr);
                    nxt_aruser_ap       <= '0;
                    nxt_arvalid         <= '0;

                    nxt_ar_loop_count   <= ar_loop_count;
                    nxt_ar_state        <= DONE;
                end else begin
                    if (bvalid) begin
                        nxt_arid            <= '0;
                        nxt_araddr          <= (do_const_addr ? '0 : araddr);
                        nxt_aruser_ap       <= '0;
                        nxt_arvalid         <= '1;

                        nxt_ar_loop_count   <= ar_loop_count;
                        nxt_ar_state        <= READ;
                    end else begin
                        nxt_arid            <= '0;
                        nxt_araddr          <= (do_const_addr ? '0 : araddr);
                        nxt_aruser_ap       <= '0;
                        nxt_arvalid         <= '0;

                        nxt_ar_loop_count   <= ar_loop_count;
                        nxt_ar_state        <= WAIT_FOR_BVALID;
                    end
                end
            end

            DONE: begin
                nxt_arid            <= '0;
                nxt_araddr          <= (do_const_addr ? '0 : araddr);
                nxt_aruser_ap       <= '0;
                nxt_arvalid         <= '0;

                nxt_ar_loop_count   <= ar_loop_count;
                nxt_ar_state        <= DONE;
            end
        endcase
    end

    always_comb
    begin

        case(rd_state)
            INIT: begin
                nxt_pass                <= '0;
                nxt_fail                <= '0;
                nxt_pnf_per_bit         <= '1;
                nxt_exp_rdata           <= (do_const_data ? '1 : exp_rdata);
                nxt_pnf_per_bit_persist <= pnf_per_bit_persist;

                nxt_rd_burst_count      <= BURST_LEN;
                nxt_rd_loop_count       <= rd_loop_count;
                nxt_rd_state            <= COMPARE_DATA;
            end

            COMPARE_DATA: begin
                if (&fail) begin
                    nxt_pass                <= '0;
                    nxt_fail                <= ~&pnf_per_bit_persist_and;
                    nxt_pnf_per_bit         <= '1;
                    nxt_exp_rdata           <= (do_const_data ? '1 : exp_rdata);
                    nxt_pnf_per_bit_persist <= pnf_per_bit_persist;

                    nxt_rd_burst_count      <= rd_burst_count;
                    nxt_rd_loop_count       <= rd_loop_count;
                    nxt_rd_state            <= DONE;
                end else if (&rd_loop_count) begin
                    nxt_pass                <= &pnf_per_bit_persist_and;
                    nxt_fail                <= ~&pnf_per_bit_persist_and;
                    nxt_pnf_per_bit         <= '1;
                    nxt_exp_rdata           <= (do_const_data ? '1 : exp_rdata);
                    nxt_pnf_per_bit_persist <= pnf_per_bit_persist;

                    nxt_rd_burst_count      <= rd_burst_count;
                    nxt_rd_loop_count       <= rd_loop_count;
                    nxt_rd_state            <= DONE;
                end else begin
                    if (rvalid) begin
                        if (rd_burst_count == 1) begin
                            nxt_pass                <= '0;
                            nxt_fail                <= ~&pnf_per_bit_persist_and;
                            nxt_pnf_per_bit         <= rdata ~^ (do_const_data ? '1 : exp_rdata);
                            nxt_exp_rdata           <= (do_const_data ? '1 : {exp_rdata[PORT_AXI_RDATA_WIDTH-1:PORT_AXI_RDATA_WIDTH/2] + 1'b1 , exp_rdata[PORT_AXI_RDATA_WIDTH/2-1:0] + 1'b1});
                            nxt_pnf_per_bit_persist <= pnf_per_bit_persist & (rdata ~^ (do_const_data ? '1 : exp_rdata));

                            nxt_rd_burst_count      <= BURST_LEN;
                            nxt_rd_loop_count       <= (do_infinite ? '0 : rd_loop_count + 1'b1);
                            nxt_rd_state            <= COMPARE_DATA;
                        end else begin
                            nxt_pass                <= '0;
                            nxt_fail                <= ~&pnf_per_bit_persist_and;
                            nxt_pnf_per_bit         <= rdata ~^ (do_const_data ? '1 : exp_rdata);
                            nxt_exp_rdata           <= (do_const_data ? '1 : {exp_rdata[PORT_AXI_RDATA_WIDTH-1:PORT_AXI_RDATA_WIDTH/2] + 1'b1 , exp_rdata[PORT_AXI_RDATA_WIDTH/2-1:0] + 1'b1});
                            nxt_pnf_per_bit_persist <= pnf_per_bit_persist & (rdata ~^ (do_const_data ? '1 : exp_rdata));

                            nxt_rd_burst_count      <= rd_burst_count - 1'b1;
                            nxt_rd_loop_count       <= rd_loop_count;
                            nxt_rd_state            <= COMPARE_DATA;
                        end
                    end else begin
                        nxt_pass                <= '0;
                        nxt_fail                <= ~&pnf_per_bit_persist_and;
                        nxt_pnf_per_bit         <= '1;
                        nxt_exp_rdata           <= (do_const_data ? '1 : exp_rdata);
                        nxt_pnf_per_bit_persist <= pnf_per_bit_persist & '1;

                        nxt_rd_burst_count      <= rd_burst_count;
                        nxt_rd_loop_count       <= rd_loop_count;
                        nxt_rd_state            <= COMPARE_DATA;
                    end
                end
            end

            DONE: begin
                    nxt_pass                <= pass;
                    nxt_fail                <= fail;
                    nxt_pnf_per_bit         <= pnf_per_bit;
                    nxt_exp_rdata           <= (do_const_data ? '1 : exp_rdata);
                    nxt_pnf_per_bit_persist <= pnf_per_bit_persist;

                    nxt_rd_burst_count      <= rd_burst_count;
                    nxt_rd_loop_count       <= rd_loop_count;
                    nxt_rd_state            <= DONE;
            end
        endcase
    end

assign awlen = BURST_LEN_EXTEND_EN? MAX_LEN[PORT_AXI_AWLEN_WIDTH-1:0] : (BURST_LEN == 2) ? {{(PORT_AXI_AWLEN_WIDTH-1){1'b0}},1'b1} : '0; 
assign arlen = BURST_LEN_EXTEND_EN? MAX_LEN[PORT_AXI_ARLEN_WIDTH-1:0] : (BURST_LEN == 2) ? {{(PORT_AXI_ARLEN_WIDTH-1){1'b0}},1'b1} : '0; 

`ifdef ALTERA_EMIF_ENABLE_ISSP
    altsource_probe #(
        .sld_auto_instance_index ("YES"),
        .sld_instance_index      (0),
        .instance_id             ("TGIC"),
        .probe_width             (0),
        .source_width            (4),
        .source_initial_value    ("0000"),
        .enable_metastability    ("NO")
    ) tg_issp_control (
        .source  (issp_control)
    );

    // Probe if HBM is alive based on rvalid count
    altsource_probe #(
        .sld_auto_instance_index ("YES"),
        .sld_instance_index      (0),
        .instance_id             ("TGBC"),
        .probe_width             (AMM_BURSTCOUNT_WIDTH),
        .source_width            (0),
        .source_initial_value    ("0"),
        .enable_metastability    ("NO")
    ) tg_rd_burst_count (
        .probe  (rd_burst_count)
    );
`else
    assign issp_control = '0;
`endif

   assign mmr_check_en = 1'b0;

endmodule
