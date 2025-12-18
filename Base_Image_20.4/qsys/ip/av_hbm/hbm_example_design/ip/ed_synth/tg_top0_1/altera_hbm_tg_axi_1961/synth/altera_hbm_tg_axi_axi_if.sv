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
// This module translates the commands issued by the state machines into
// AXI signals.
//////////////////////////////////////////////////////////////////////////////

module altera_hbm_tg_axi_axi_if # (
   parameter WORD_ADDRESS_DIVISIBLE_BY = "",
   parameter BURST_COUNT_DIVISIBLE_BY = "",
   parameter BURST_LEN = "",
   parameter WORD_ADDR_WIDTH              = "",
   parameter NUMBER_OF_DATA_GENERATORS    = "",
   parameter NUMBER_OF_BYTE_EN_GENERATORS = "",
   parameter DATA_RATE_WIDTH_RATIO        = "",
   parameter DATA_WIDTH                   = "",
   parameter BE_WIDTH                     = "",
   parameter AMM_BURSTCOUNT_WIDTH         = "",
   parameter USE_BYTE_EN                  = "",
   parameter PORT_AXI_AWID_WIDTH          = "",
	parameter PORT_AXI_AWADDR_WIDTH         = "",
	parameter PORT_AXI_AWLEN_WIDTH          = "",
	parameter PORT_AXI_AWSIZE_WIDTH         = "",
	parameter PORT_AXI_AWBURST_WIDTH        = "",
   parameter PORT_AXI_AWPROT_WIDTH        = "",
	parameter PORT_AXI_AWQOS_WIDTH          = "",
	parameter PORT_AXI_AWUSER_AP_WIDTH      = "",
	parameter PORT_AXI_WDATA_WIDTH          = "",
	parameter PORT_AXI_WSTRB_WIDTH          = "",
	parameter PORT_AXI_BID_WIDTH            = "",
	parameter PORT_AXI_BRESP_WIDTH          = "",
	parameter PORT_AXI_ARID_WIDTH           = "",
	parameter PORT_AXI_ARADDR_WIDTH         = "",
	parameter PORT_AXI_ARLEN_WIDTH          = "",
	parameter PORT_AXI_ARSIZE_WIDTH         = "",
	parameter PORT_AXI_ARBURST_WIDTH        = "",
   parameter PORT_AXI_ARPROT_WIDTH        = "",
	parameter PORT_AXI_ARQOS_WIDTH          = "",
	parameter PORT_AXI_ARUSER_AP_WIDTH      = "",
	parameter PORT_AXI_RID_WIDTH            = "",
	parameter PORT_AXI_RDATA_WIDTH          = "",
   parameter DIAG_TG_GENERATE_RW_IDS      = "",
   parameter DIAG_TEST_RANDOM_AXI_READY   = "",
   parameter SEQUENTIAL_RANDOM            = 1'b0,
   parameter STRESS_LFSR                  = 1'b0,
   parameter STATIC_RATIO_1               = 1'b0,
   parameter TG_USE_EFFICIENCY_PATTERN    = "",
   parameter ENABLE_DATA_CHECK            = "",
   parameter SEED                         = 36'b000000111110000011110000111000110010,
   parameter ADDR_MASK_VALUE              = 0,
   parameter SUM_RD                       = "",
   parameter SUM_WR                       = "",
   parameter BURST_LEN_EXTEND_EN          = 0
) (
   input clk,
   input rst,

   //from traffic generator
   input awrite_req,
   input write_req,
   input read_req,
   input [WORD_ADDR_WIDTH-1:0] write_addr,
   input [WORD_ADDR_WIDTH-1:0] read_addr,
   input [PORT_AXI_ARID_WIDTH-1:0] read_id,
   input [PORT_AXI_AWID_WIDTH-1:0] write_id,
   input [AMM_BURSTCOUNT_WIDTH-1:0] read_burst_cnt,
   input [AMM_BURSTCOUNT_WIDTH-1:0] write_burst_cnt,
   output controller_wready,
   output controller_awready,
   output controller_rready,
   input [DATA_WIDTH-1:0] mem_write_data,
   input [BE_WIDTH-1:0] mem_write_be,
   input next_wlast,
   input start,

   //  User Interface (AXI4)
   //  Write Address Channels
   output [PORT_AXI_AWID_WIDTH-1:0]      awid,
   output [PORT_AXI_AWADDR_WIDTH-1:0]    awaddr,
   output [PORT_AXI_AWQOS_WIDTH-1:0]     awqos,
   output [PORT_AXI_AWUSER_AP_WIDTH-1:0] awuser_ap,
   output [PORT_AXI_AWLEN_WIDTH-1:0]     awlen,
   output                                awvalid,
   input                                 awready,

   //  Write Data Channels
   output [PORT_AXI_WDATA_WIDTH-1:0]  wdata,
   output [PORT_AXI_WSTRB_WIDTH-1:0]  wstrb,
   output                             wlast,
   output                             wvalid,
   input                              wready,

   //  Write Response Channel
   input [PORT_AXI_BID_WIDTH-1:0]     bid,
   input [PORT_AXI_BRESP_WIDTH-1:0]   bresp,
   input                              bvalid,
   output                             bready,

   //  Read Address Channels
   output logic [PORT_AXI_ARID_WIDTH-1:0]      arid,
   output [PORT_AXI_ARADDR_WIDTH-1:0]    araddr,
   output [PORT_AXI_ARQOS_WIDTH-1:0]     arqos,
   output [PORT_AXI_ARUSER_AP_WIDTH-1:0] aruser_ap,
   output [PORT_AXI_ARLEN_WIDTH-1:0]     arlen,
   output                                arvalid,
   input                                 arready,
   input initialization_phase,
   input init_stage,

   //  Read Data Channels
   input [PORT_AXI_RID_WIDTH-1:0]   rid,
   input [PORT_AXI_RDATA_WIDTH-1:0] rdata,
   input                            rlast,
   input                            rvalid,
   output                           rready,

   input [DATA_WIDTH-1:0] written_data,
   input [BE_WIDTH-1:0] written_be,
   output [BE_WIDTH-1:0] ast_exp_data_byteenable,
   output [DATA_WIDTH-1:0] ast_exp_data_writedata,

   //Actual data for comparison in status checker
   output                       ast_act_data_readdatavalid,
   output [DATA_WIDTH-1:0]      ast_act_data_readdata,

   input        read_addr_fifo_full,
   input [1:0]  addr_gen_mode_writes,
   input [1:0]  addr_gen_mode_reads

);
   timeunit 1ns;
   timeprecision 1ps;

   import tg_axi_defs::*;

   localparam ZERO_PAD_WIDTH = log2(WORD_ADDRESS_DIVISIBLE_BY);
   localparam RAND_ADDR_WIDTH = WORD_ADDR_WIDTH - ZERO_PAD_WIDTH;
   localparam DATA_FADDRESS =16;
   localparam SEQ_LEN_1 = 1'd1;
   localparam NUM_ADDR_SWITCHING = 4;   
   localparam WR_COUNT = (SUM_WR/NUM_ADDR_SWITCHING) - 1; 
   localparam RD_COUNT = (SUM_RD/NUM_ADDR_SWITCHING) - 1; 
   localparam ADDR_MSB =  (ADDR_MASK_VALUE == 1)? 2'b00:
                         ((ADDR_MASK_VALUE == 2)? 2'b01:
		         ((ADDR_MASK_VALUE == 3)? 2'b10:
		         ((ADDR_MASK_VALUE == 4)? 2'b11:
                           2'b00))); 
		      
   wire [WORD_ADDR_WIDTH-1:0] awaddr_seq1rd1wr, araddr_seq1rd1wr;
   reg  [WORD_ADDR_WIDTH-1:0] seq_1rd1wr_cntr;
   wire [WORD_ADDR_WIDTH-1:0] seq_1rd1wr_cntr_p1 = seq_1rd1wr_cntr + 1'b1;
   wire [WORD_ADDR_WIDTH-1:0] seq_1rd1wr_cntr_p2 = seq_1rd1wr_cntr + 2'd2;
   wire [RAND_ADDR_WIDTH-1:0] awaddr_seq_rd_or_wr, araddr_seq_rd_or_wr;
   wire [RAND_ADDR_WIDTH-1:0] virt_addr_seq_rd_or_wr;  
   wire [WORD_ADDR_WIDTH-1:0] write_addr_rand;
   wire [WORD_ADDR_WIDTH-1:0] read_addr_rand;
   assign rd_valid = arvalid && arready;
   assign wr_valid = awvalid && awready;
   	always @ (posedge clk) begin
	   if (rst) begin
			  seq_1rd1wr_cntr <= 'd0;
	   end else begin
		    if (rd_valid && wr_valid) seq_1rd1wr_cntr <= seq_1rd1wr_cntr_p2;
		    else if (rd_valid || wr_valid) seq_1rd1wr_cntr <= seq_1rd1wr_cntr_p1;
	   end
	  end
   assign awaddr_seq1rd1wr = (wr_valid)? seq_1rd1wr_cntr: 'd0;
   assign araddr_seq1rd1wr = (rd_valid && wr_valid)? seq_1rd1wr_cntr_p1:
                             (rd_valid)? seq_1rd1wr_cntr: 'd0;
   assign rd_valid = arvalid && arready;
   assign wr_valid = awvalid && awready;
   generate
     if(ADDR_MASK_VALUE == 0) begin
        reg [RAND_ADDR_WIDTH-1:0] awaddr_seq_rd_or_wr_r, araddr_seq_rd_or_wr_r;
        reg [RAND_ADDR_WIDTH-1:0] virt_addr_seq_rd_or_wr_r;     
   	always @ (posedge clk) begin
	   if (rst) begin
			  awaddr_seq_rd_or_wr_r    <= 0;
			  araddr_seq_rd_or_wr_r    <= 0;
			  virt_addr_seq_rd_or_wr_r <= 0;
	   end else begin
		    if (wr_valid) awaddr_seq_rd_or_wr_r <= awaddr_seq_rd_or_wr_r + SEQ_LEN_1;
		    if (rd_valid) araddr_seq_rd_or_wr_r <= araddr_seq_rd_or_wr_r + SEQ_LEN_1;
		    if (wlast & wready & wvalid)
		                  virt_addr_seq_rd_or_wr_r <= virt_addr_seq_rd_or_wr_r + SEQ_LEN_1;
	   end
	  end
        assign awaddr_seq_rd_or_wr = awaddr_seq_rd_or_wr_r;
        assign araddr_seq_rd_or_wr = araddr_seq_rd_or_wr_r;
        assign virt_addr_seq_rd_or_wr = virt_addr_seq_rd_or_wr_r;
        assign write_addr_rand = write_addr;
        assign read_addr_rand = read_addr;   		  
     end else begin 
        reg [RAND_ADDR_WIDTH-3:0] awaddr_seq, araddr_seq, virt_addr_seq;
        reg [1:0] awaddr_msb, araddr_msb, virt_addr_msb;
        assign awaddr_seq_rd_or_wr = {awaddr_msb, awaddr_seq};
        assign araddr_seq_rd_or_wr = {araddr_msb, araddr_seq};
        assign virt_addr_seq_rd_or_wr = {virt_addr_msb, virt_addr_seq};
        assign write_addr_rand = {awaddr_msb, write_addr[WORD_ADDR_WIDTH-3:0]};
        assign read_addr_rand = {araddr_msb, read_addr[WORD_ADDR_WIDTH-3:0]};  	
   	always @ (posedge clk) begin
	   if (rst) begin
			  awaddr_seq <= '0;
			  araddr_seq <= '0;
			  virt_addr_seq <= '0;
			  awaddr_msb <= ADDR_MSB;
			  araddr_msb <= ADDR_MSB;
			  virt_addr_msb <= ADDR_MSB;			  
	   end else begin
		    if (wr_valid) begin 
		      if(awaddr_seq == WR_COUNT) begin
		        awaddr_seq <= '0;
			awaddr_msb <= awaddr_msb + 1'b1;
		      end else begin
		        awaddr_seq <= awaddr_seq + SEQ_LEN_1;
	              end
		    end
		    if (rd_valid) begin
		      if(araddr_seq == RD_COUNT) begin
		        araddr_seq <= '0;
			araddr_msb <= araddr_msb + 1'b1;
		      end else begin
		        araddr_seq <= araddr_seq + SEQ_LEN_1;
	              end		    
		    end
		    if (wlast & wready & wvalid) begin
		      if(virt_addr_seq == WR_COUNT) begin
		        virt_addr_seq <= '0;
			virt_addr_msb <= virt_addr_msb + 1'b1;
		      end else begin
		        virt_addr_seq <= virt_addr_seq + SEQ_LEN_1;
	              end		    
		    end
	   end
   	end	
     end		  
   endgenerate
  localparam int HBM_BURST_BYTES = 64;
  localparam int UNUSED_AW       = $clog2(HBM_BURST_BYTES);
  localparam int HBM_AXI_AW      = 28;
  localparam int INT_AW          = HBM_AXI_AW-UNUSED_AW;
  `ifdef ALT_SIM
    localparam int ADDR_LFSR = 5;
  `else
    localparam int ADDR_LFSR = INT_AW;
  `endif
  logic [INT_AW-1:0] pat_wr_addr = '0;
  logic [INT_AW-1:0] pat_wr_data = '0;
  logic [INT_AW-1:0] pat_rd_addr = '0;

  /*
    class next_lfsr_wrapper #(parameter int n = "");
    static task next_lfsr(
        input logic  [INT_AW-1:0] cur_lfsr,
        output logic [INT_AW-1:0] next_lfsr
      );
      logic [INT_AW-n-1:0] res_msb;
      logic [n-1:0]        res_lsb;
      res_msb = '0;
      if (hbm_cfg_test_pat == 2'b00) begin
        case (n)
          4:       res_lsb = {cur_lfsr[2:0],  cur_lfsr[3]  ~^ cur_lfsr[2]};
          5:       res_lsb = {cur_lfsr[3:0],  cur_lfsr[4]  ~^ cur_lfsr[2]};
          6:       res_lsb = {cur_lfsr[4:0],  cur_lfsr[5]  ~^ cur_lfsr[4]};
          8:       res_lsb = {cur_lfsr[6:0],  cur_lfsr[7]  ~^ cur_lfsr[5]  ~^ cur_lfsr[4]  ~^ cur_lfsr[3]};
          10:      res_lsb = {cur_lfsr[8:0],  cur_lfsr[9]  ~^ cur_lfsr[6]};
          22:      res_lsb = {cur_lfsr[20:0], cur_lfsr[21] ~^ cur_lfsr[20]};
          23:      res_lsb = {cur_lfsr[21:0], cur_lfsr[22] ~^ cur_lfsr[17]};
          24:      res_lsb = {cur_lfsr[22:0], cur_lfsr[23] ~^ cur_lfsr[22] ~^ cur_lfsr[21] ~^ cur_lfsr[16]};
          default: res_lsb = '0;
        endcase
      end else begin
        res_lsb = cur_lfsr[n-1:0]+1'b1;
      end
      next_lfsr = {res_msb, res_lsb};
    endtask: next_lfsr
  endclass : next_lfsr_wrapper

  next_lfsr_wrapper # (ADDR_LFSR) next_lfsr_wrap = new;

  always @ (posedge clk) begin
    if (rst) begin
      hbm_cfg_test_pat <= 2'b00;
      pat_rd_addr <= 'd0;
      pat_wr_addr <= 'd0;
      pat_wr_data <= 'd0;
      cnt_bvalid <= 'd0;
      cnt_rvalid <= 'd0;
    end
    else begin
        if(bvalid && bready) cnt_bvalid <= cnt_bvalid + 'd1;
        if (rlast & rready & rvalid) cnt_rvalid <= cnt_rvalid + 'd1;
        if (raddr_accpt_v) begin
        next_lfsr_wrap.next_lfsr(pat_rd_addr, rnext_lfsr_res_v);
          pat_rd_addr <= rnext_lfsr_res_v;
        end
        if (waddr_accept_v) begin
        next_lfsr_wrap.next_lfsr(pat_wr_addr, wnext_lfsr_res_v);
          pat_wr_addr <= wnext_lfsr_res_v;
        end
        if (wlast & wready & wvalid) begin
        next_lfsr_wrap.next_lfsr(pat_wr_data, wnext_lfsr_res_v_data);
          pat_wr_data <= wnext_lfsr_res_v_data;
        end
    end
  end

  */

  /* 
  logic [INT_AW-1:0] rnext_lfsr_res_v, wnext_lfsr_res_v, wnext_lfsr_res_v_data;
  logic [1       :0] hbm_cfg_test_pat;
  logic [32-1:0] cnt_bvalid, cnt_rvalid;
  wire raddr_accpt_v  = rd_valid;
  wire waddr_accept_v = wr_valid;

  virtual class next_lfsr_wrapper #(parameter int n = "");
    static task next_lfsr(
        input logic  [INT_AW-1:0] cur_lfsr,
        output logic [INT_AW-1:0] next_lfsr
      );
      logic [INT_AW-n-1:0] res_msb;
      logic [n-1:0]        res_lsb;
      res_msb = '0;
      if (hbm_cfg_test_pat == 2'b00) begin
        case (n)
          4:       res_lsb = {cur_lfsr[2:0],  cur_lfsr[3]  ~^ cur_lfsr[2]};
          5:       res_lsb = {cur_lfsr[3:0],  cur_lfsr[4]  ~^ cur_lfsr[2]};
          6:       res_lsb = {cur_lfsr[4:0],  cur_lfsr[5]  ~^ cur_lfsr[4]};
          8:       res_lsb = {cur_lfsr[6:0],  cur_lfsr[7]  ~^ cur_lfsr[5]  ~^ cur_lfsr[4]  ~^ cur_lfsr[3]};
          10:      res_lsb = {cur_lfsr[8:0],  cur_lfsr[9]  ~^ cur_lfsr[6]};
          22:      res_lsb = {cur_lfsr[20:0], cur_lfsr[21] ~^ cur_lfsr[20]};
          23:      res_lsb = {cur_lfsr[21:0], cur_lfsr[22] ~^ cur_lfsr[17]};
          24:      res_lsb = {cur_lfsr[22:0], cur_lfsr[23] ~^ cur_lfsr[22] ~^ cur_lfsr[21] ~^ cur_lfsr[16]};
          default: res_lsb = '0;
        endcase
      end else begin
        res_lsb = cur_lfsr[n-1:0]+1'b1;
      end
      next_lfsr = {res_msb, res_lsb};
    endtask: next_lfsr
  endclass : next_lfsr_wrapper

  always @ (posedge clk) begin
    if (rst) begin
      hbm_cfg_test_pat <= 2'b00;
      pat_rd_addr <= 'd0;
      pat_wr_addr <= 'd0;
      pat_wr_data <= 'd0;
      cnt_bvalid <= 'd0;
      cnt_rvalid <= 'd0;
    end
    else begin
        if(bvalid && bready) cnt_bvalid <= cnt_bvalid + 'd1;
        if (rlast & rready & rvalid) cnt_rvalid <= cnt_rvalid + 'd1;
        if (raddr_accpt_v) begin
          next_lfsr_wrapper # (ADDR_LFSR)::next_lfsr(pat_rd_addr, rnext_lfsr_res_v);
          pat_rd_addr <= rnext_lfsr_res_v;
        end
        if (waddr_accept_v) begin
          next_lfsr_wrapper # (ADDR_LFSR)::next_lfsr(pat_wr_addr, wnext_lfsr_res_v);
          pat_wr_addr <= wnext_lfsr_res_v;
        end
        if (wlast & wready & wvalid) begin
          next_lfsr_wrapper # (ADDR_LFSR)::next_lfsr(pat_wr_data, wnext_lfsr_res_v_data);
          pat_wr_data <= wnext_lfsr_res_v_data;
        end
    end
  end
  */
   wire [RAND_ADDR_WIDTH-1:0] virt_wadd;
   

   
   assign wdata =  (TG_USE_EFFICIENCY_PATTERN)?
                   ((STRESS_LFSR)?           {(PORT_AXI_WDATA_WIDTH/DATA_FADDRESS){pat_wr_data           [DATA_FADDRESS-1:0]}}:(
                    (SEQUENTIAL_RANDOM)?     {(PORT_AXI_WDATA_WIDTH/DATA_FADDRESS){virt_addr_seq_rd_or_wr[DATA_FADDRESS-1:0]}}:
                                             {(PORT_AXI_WDATA_WIDTH/DATA_FADDRESS){virt_wadd             [DATA_FADDRESS-1:0]}} )):
		   mem_write_data;
   reg wvalid_r;
   wire wr_data_lfsr_start = start;
	always @ (posedge clk) begin
	 if (rst) begin
			wvalid_r <= 1'b0;
	 end else begin
		 wvalid_r <= wvalid;
	 end
	end
	altera_hbm_tg_axi_lfsr # (
			.WIDTH(RAND_ADDR_WIDTH),
                        .TG_USE_EFFICIENCY_PATTERN (TG_USE_EFFICIENCY_PATTERN),
                        .SEED(SEED)
	) wr_data_lfsr (
			.clk       (clk),
			.rst       (rst),
			.enable    (wlast & wready & wvalid),
			.initialization_phase(initialization_phase),
			.data      (virt_wadd),
			.tg_start  (wr_data_lfsr_start)
	);
   localparam NUM_OF_DATA_GENERATORS_PER_TG = NUMBER_OF_DATA_GENERATORS;
   localparam NUM_OF_BE_GENERATORS_PER_TG = NUMBER_OF_BYTE_EN_GENERATORS;
   localparam ADDR_PAD = (TG_USE_EFFICIENCY_PATTERN)? ((WORD_ADDRESS_DIVISIBLE_BY==2'd2)? 6: 5):
   				                      (PORT_AXI_AWADDR_WIDTH - WORD_ADDR_WIDTH);
   localparam ADDR_GEN_LSB = (BURST_COUNT_DIVISIBLE_BY == 2'd2)? 6: 5;						      
   

   assign wstrb = mem_write_be;
   assign ast_exp_data_writedata = written_data;
   assign ast_exp_data_byteenable = written_be;

   // WRITE ADDRESS CHANNEL
   wire [AMM_BURSTCOUNT_WIDTH-1:0] write_len;
   assign awid                       = write_id;
   assign awaddr                     =  (TG_USE_EFFICIENCY_PATTERN)? (
   					                            (STATIC_RATIO_1 && initialization_phase)? {awaddr_seq_rd_or_wr, {ADDR_PAD{1'b0}}}:(
                                        (STRESS_LFSR)?           {pat_wr_addr        , {ADDR_PAD{1'b0}}}:(
                                        (SEQUENTIAL_RANDOM)?     {awaddr_seq_rd_or_wr, {ADDR_PAD{1'b0}}}:
                                                                 {write_addr_rand    , {($size(awaddr)-$size(write_addr)){1'b0}}} ))):
                                        {write_addr, {ADDR_PAD{1'b0}}};
   assign awqos                      = '0;
   assign awuser_ap                  = TG_USE_EFFICIENCY_PATTERN?(SEQUENTIAL_RANDOM?1'b0: 1'b1):(addr_gen_mode_writes == TG_ADDR_RAND);
   assign write_len = write_burst_cnt - 1'b1;
   generate
      if(BURST_LEN_EXTEND_EN) begin
         assign awlen =  write_len[PORT_AXI_AWLEN_WIDTH-1:0]; 
      end else begin
         assign awlen =  {{(PORT_AXI_AWLEN_WIDTH-AMM_BURSTCOUNT_WIDTH){1'b0}}, write_len}; 
      end
   endgenerate
   //when the address fifo is full, the ready signal to the traffic generator is deasserted
   //this potentially leaves the read or write signals to the memory controller asserted for its duration
   //when we actually do not want to be issuing operations, only holding current state
   assign awvalid                    = awrite_req & ~read_addr_fifo_full;

   // WRITE DATA CHANNEL
   //Currently we only support burst of 1, so it's always the last transfer of a burst
   assign wlast                      = next_wlast;
   logic aw_accepted;
   logic wready_r;
   always @ (posedge clk) begin
      if (rst) begin
         aw_accepted <= '0;
         wready_r <= '0;
         wvalid_r <= '0;
      end else begin
         aw_accepted <= awready & ~read_addr_fifo_full & awrite_req;
         wready_r <= wready;
         wvalid_r <= wvalid;
      end
   end

   logic [3:0] rand_ready;
   altera_emif_avl_tg_lfsr #(
      .WIDTH(4)
   ) random_ready_lfsr (
      .clk(clk),
      .reset_n(~rst),
      .enable(1'b1),
      .data(rand_ready)
   );

   assign wvalid                     = write_req;

   assign controller_awready         = awvalid & awready;
   assign controller_wready          = wready;

   // WRITE RESPONSE CHANNEL
   //bid: should be same as awid
   assign bready                     = DIAG_TEST_RANDOM_AXI_READY ? rand_ready[0] : 1'b1;
   // synopsys translate_off
   //Case:531169 Check for correct write response (this isn't really necessary in HW)
   logic [PORT_AXI_BID_WIDTH-1:0] expected_bid;
   always_ff @ (posedge clk) begin
      if (rst) begin
         expected_bid = '0;
      end else begin
         if (DIAG_TEST_RANDOM_AXI_READY && DIAG_TG_GENERATE_RW_IDS && bvalid && bready) begin
            assert (bid == expected_bid) else $finish("Incorrect bid");
            expected_bid = expected_bid + 1'b1;
         end
      end
   end
   // synopsys translate_on

   // READ ADDRESS CHANNEL
   wire [AMM_BURSTCOUNT_WIDTH-1:0] read_len;   
   assign arid                       = read_id;
   assign araddr                     = (TG_USE_EFFICIENCY_PATTERN)? (
   					(STRESS_LFSR)?             {pat_rd_addr        , {ADDR_PAD{1'b0}}}:(
                                       (SEQUENTIAL_RANDOM)?  {araddr_seq_rd_or_wr, {ADDR_PAD{1'b0}}}:
                                                             {read_addr_rand     , {($size(araddr)-$size(read_addr)){1'b0}}} )):
                                        {read_addr, {ADDR_PAD{1'b0}}};
   assign arqos                      = '0;
   assign aruser_ap                  = TG_USE_EFFICIENCY_PATTERN?(SEQUENTIAL_RANDOM?1'b0: 1'b1):(addr_gen_mode_writes == TG_ADDR_RAND);
   assign read_len                   = read_burst_cnt - 1'b1;
   generate
      if(BURST_LEN_EXTEND_EN) begin
         assign arlen =  read_len[PORT_AXI_ARLEN_WIDTH-1:0]; 
      end else begin
         assign arlen =  {{(PORT_AXI_ARLEN_WIDTH-AMM_BURSTCOUNT_WIDTH){1'b0}}, read_len}; 
      end
   endgenerate
   assign arvalid                    = read_req & ~read_addr_fifo_full;

   assign controller_rready          = arready & ~read_addr_fifo_full;

   // synopsys translate_off
   /*logic [WORD_ADDR_WIDTH-1:0] current_write_addr;
   always_ff @ (posedge clk) begin
      if (arvalid & arready) begin
         $display("[%0t] Reading from addr %h with read ID %h", $time, read_addr, read_id);
      end
      if (controller_awready) begin
         current_write_addr <= write_addr;
         $display("[%0t] Writing to addr %h", $time, write_addr);
      end
      if (controller_wready) begin
         $display("[%0t] Writing data %h to addr %h", $time, wdata, current_write_addr);
      end
   end*/
   // synopsys translate_on

   // READ DATA CHANNEL
   //We're always ready for read data
   assign rready                     = DIAG_TEST_RANDOM_AXI_READY ? rand_ready[0] : 1'b1;

   assign ast_act_data_readdata      = rdata;
   assign ast_act_data_readdatavalid = rvalid && rready;

endmodule

