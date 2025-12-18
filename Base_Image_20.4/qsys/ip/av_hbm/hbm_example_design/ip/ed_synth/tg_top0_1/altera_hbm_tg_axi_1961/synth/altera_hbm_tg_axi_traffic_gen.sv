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


module altera_hbm_tg_axi_traffic_gen #(
   parameter NUMBER_OF_DATA_GENERATORS       = "",
   parameter NUMBER_OF_BYTE_EN_GENERATORS    = "",
   parameter AMM_CFG_ADDR_WIDTH              = "", //avalon cfg address width from driver control block
   parameter AMM_CFG_DATA_WIDTH              = "", //avalon cfg data width from driver control block
   //Corresponds to memory data rate, 8 for quarter-rate, 4 for half-rate
   parameter DATA_RATE_WIDTH_RATIO           = "",
   //Sequence length of the pattern to be written to DQ pins
   //Legal values: 8, 16, 32
   parameter DIAG_TG_DATA_PATTERN_LENGTH     = "",
   //Sequence length of the pattern for the byte enables
   parameter DIAG_TG_BYTE_EN_PATTERN_LENGTH  = "",
   // Random seed for data generator
   parameter SEED_OFFSET                     = 0,
   parameter TG_LFSR_SEED                    = 36'b000000111110000011110000111000110010 + SEED_OFFSET,
   //Enable LFSR based on HBM JESD235A polynomial
   parameter HBM_LFSR                       = "",
   //A total count of reads for the driver
   parameter OP_COUNT_WIDTH                  = "",
   //rw generator counter widths - will dictate maxima for configurable values
   parameter RW_RPT_COUNT_WIDTH              = "",
   parameter RW_OPERATION_COUNT_WIDTH        = "",
   parameter RW_LOOP_COUNT_WIDTH             = "",
   parameter RAND_SEQ_CNT_WIDTH              = 8,
   parameter SEQ_ADDR_INCR_WIDTH             = 9,
   //address generator params
   parameter MEM_ADDR_WIDTH                  = "",
   //width of the row address bits
   parameter ROW_ADDR_WIDTH                  = "",
   //bit location of the LSB of the row address within the total address
   parameter ROW_ADDR_LSB                    = "",
   parameter SID_ADDR_WIDTH                 = "",
   parameter SID_ADDR_LSB                   = "",
   parameter BANK_ADDR_WIDTH                 = "",
   parameter BANK_ADDR_LSB                   = "",
   parameter BANK_GROUP_WIDTH                = "",
   parameter BANK_GROUP_LSB                  = "",
   parameter AMM_BURSTCOUNT_WIDTH            = "",
   parameter MEM_DATA_WIDTH                  = "",
   parameter MEM_RDATA_WIDTH                 = "",
   parameter MEM_BE_WIDTH                    = "",
   parameter USE_BYTE_EN                     = "",
   parameter DIAG_TG_OOO_EN                  = "",
   parameter DIAG_TG_GENERATE_RW_IDS         = "",
   parameter DIAG_TEST_RANDOM_AXI_READY      = "",
   parameter DIAG_EFFICIENCY_TEST_MODE       = "",
   parameter DIAG_HBMC_TEST_MODE             = "",
   parameter NUM_OF_CTRL_PORTS               = "",
   parameter BURST_COUNT_DIVISIBLE_BY        = "",
   parameter WORD_ADDRESS_DIVISIBLE_BY       = "",
   parameter BURST_LEN                       = "",

   parameter DIAG_EFFICIENCY_MONITOR       = "",
   parameter PORT_EFFMON_CSR_ADDRESS_WIDTH = "",
   parameter PORT_EFFMON_CSR_RDATA_WIDTH   = "",
   parameter PORT_EFFMON_CSR_WDATA_WIDTH   = "",

   parameter PORT_AXI_AWID_WIDTH           = "",
	parameter PORT_AXI_AWADDR_WIDTH         = "",
	parameter PORT_AXI_AWLEN_WIDTH          = "",
	parameter PORT_AXI_AWSIZE_WIDTH         = "",
	parameter PORT_AXI_AWBURST_WIDTH        = "",
   parameter PORT_AXI_AWPROT_WIDTH         = "",
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
   parameter PORT_AXI_ARPROT_WIDTH         = "",
	parameter PORT_AXI_ARQOS_WIDTH          = "",
	parameter PORT_AXI_ARUSER_AP_WIDTH      = "",
	parameter PORT_AXI_RID_WIDTH            = "",
  parameter PORT_AXI_RDATA_WIDTH          = "",
  parameter EFFICIENCY_FACTOR_NUM         = 1,
  parameter EFFICIENCY_FACTOR_DEN         = 1,
  parameter SUM_RD                        = "",
  parameter SUM_WR                        = "",
  parameter STATIC_RATIO_1                = "",
  parameter CFG_TG_SEQUENCE               = "",
  parameter TG_USE_EFFICIENCY_PATTERN     = "",
  parameter ENABLE_DATA_CHECK             = "",
  parameter C2P_CLK_RATIO                 = "",
  parameter ADDR_MASK_VALUE               = 0,
  parameter DIAG_DEBUG_ISSPS              = 0,
  // Extended burst length related
  parameter BURST_LEN_EXTEND_EN           = 0,
  parameter MAX_BURST_COUNT               = 3,
  parameter BURST_COUNT_MODE              = "RAND"

   )(
   input    clk,
   input    rst,
   output   tg_restart,

   //Driver control block AMM interface signals
   input        [AMM_CFG_ADDR_WIDTH-1:0] amm_cfg_address,
   input        [AMM_CFG_DATA_WIDTH-1:0] amm_cfg_writedata,
   output reg   [AMM_CFG_DATA_WIDTH-1:0] amm_cfg_readdata,
   input                                 amm_cfg_write,
   input                                 amm_cfg_read,
   output                                amm_cfg_waitrequest,
   output reg                            amm_cfg_readdatavalid,

   // Efficiency monitor CSR interface
   input   logic                                      effmon_csr_waitrequest,
   output  logic                                      effmon_csr_read,
   output  logic                                      effmon_csr_write,
   output  logic [PORT_EFFMON_CSR_ADDRESS_WIDTH-1:0]  effmon_csr_address,
   input   logic [PORT_EFFMON_CSR_RDATA_WIDTH-1:0]    effmon_csr_readdata,
   output  logic [PORT_EFFMON_CSR_WDATA_WIDTH-1:0]    effmon_csr_writedata,
   input   logic                                      effmon_csr_readdatavalid,

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
   output [PORT_AXI_ARID_WIDTH-1:0]      arid,
   output [PORT_AXI_ARADDR_WIDTH-1:0]    araddr,
   output [PORT_AXI_ARQOS_WIDTH-1:0]     arqos,
   output [PORT_AXI_ARUSER_AP_WIDTH-1:0] aruser_ap,
   output [PORT_AXI_ARLEN_WIDTH-1:0]     arlen,
   output                                arvalid,
   input                                 arready,

   //  Read Data Channels
   input [PORT_AXI_RID_WIDTH-1:0]   rid,
   input  [PORT_AXI_RDATA_WIDTH-1:0] rdata,
   output [PORT_AXI_RDATA_WIDTH-1:0] ref_data,
   input [1:0]                      rresp,
   input                            rlast,
   input                            rvalid,
   output                           rready,
   input                            initialization_phase,
   input                            init_stage,

   //Expected data for comparison in status checker
   output [MEM_BE_WIDTH-1:0]        ast_exp_data_byteenable,
   output [MEM_DATA_WIDTH-1:0]      ast_exp_data_writedata,
   output [MEM_ADDR_WIDTH-1:0]      ast_exp_data_readaddr,

   //Actual data for comparison in status checker
   output                           ast_act_data_readdatavalid,
   output [MEM_DATA_WIDTH-1:0]      ast_act_data_readdata,
   output [PORT_AXI_RID_WIDTH-1:0]   ast_act_data_rid,
   input [PORT_AXI_RID_WIDTH-1:0]   ast_act_data_rid_pl,

   //Status information from the status checker
   output reg                           clear_first_fail,
   output reg                           byteenable_stage,
   input    [MEM_RDATA_WIDTH-1:0]       pnf_per_bit_persist,
   input                                fail,
   input                                pass,
   input    [63:0]        first_fail_addr,
   input    [63:0]        failure_count,
   input    [MEM_RDATA_WIDTH-1:0]       first_fail_expected_data,
   input    [MEM_RDATA_WIDTH-1:0]       first_fail_read_data,
   input                                first_fail_read,
   input                                first_fail_write,

   output reads_in_prog,
   output logic                         restart_default_traffic
);
   timeunit 1ns;
   timeprecision 1ps;

   import tg_axi_defs::*;
  localparam SEQUENTIAL_RANDOM = (CFG_TG_SEQUENCE=="TG_SEQUENCE_RANDOM")? 0: 1;
  localparam STRESS_LFSR=0;
	localparam DATA_FADDRESS =16;
	wire [DATA_FADDRESS-1:0] w_arid_address;
  reg [DATA_FADDRESS-1:0] w_arid_address_r /* synthesis dont_merge syn_preserve = 1 */ ;
  wire [DATA_FADDRESS-1:0] r_arid_address /* synthesis dont_merge syn_preserve = 1 */ ;
  reg [PORT_AXI_ARID_WIDTH-1:0] arid_r /* synthesis dont_merge syn_preserve = 1 */ ;
  reg arvalid_r /* synthesis dont_merge */ ;
	reg rvalid_r1, rvalid_r2;
	reg [PORT_AXI_RID_WIDTH-1:0] rid_r1, rid_r2;
        localparam ADDR_GEN_WIDTH = (BURST_COUNT_DIVISIBLE_BY == 2'd2)? 6: 5;
	assign w_arid_address = araddr[DATA_FADDRESS+ADDR_GEN_WIDTH-1:ADDR_GEN_WIDTH];
  localparam ZERO_PAD_WIDTH = log2(WORD_ADDRESS_DIVISIBLE_BY);
  localparam RAND_ADDR_WIDTH = DATA_FADDRESS - ZERO_PAD_WIDTH;
  localparam SEED =  (ADDR_MASK_VALUE == 1)? 36'b000000111110000011110000111000110001:
                    ((ADDR_MASK_VALUE == 2)? 36'b000000111110000011110000111000110010:
		    ((ADDR_MASK_VALUE == 3)? 36'b000000111110000011110000111000110100:
		    ((ADDR_MASK_VALUE == 4)? 36'b000000111110000011110000111000111000:
                    36'b000000111110000011110000111000110010))); 

  localparam MIN_BURST_COUNT = 1; 
	   	    
  always @ (posedge clk) begin
    arid_r <= arid;
    w_arid_address_r <= w_arid_address;
    arvalid_r <= arvalid;
  end
  generate
    if(!ENABLE_DATA_CHECK) begin
      assign r_arid_address = '0;
    end
    else begin
   simple_dp_ram #(
      .DATA_WIDTH                       (DATA_FADDRESS),
      .W_ADDR_WIDTH                     (PORT_AXI_ARID_WIDTH),
      .R_ADDR_WIDTH                     (PORT_AXI_RID_WIDTH)
   ) arid_address (
      .q              (r_arid_address),
      .d              (w_arid_address_r),
      .write_address  (arid_r),
      .read_address   (rid_r2),
      .we             (arvalid_r),
      .clk            (clk)
   );
    end
   endgenerate
	always @ (posedge clk) begin
	  if(rst) begin
	    rvalid_r1 <= 1'b0;
	    rvalid_r2 <= 1'b0;
	    rid_r1 <= 'd0;
	    rid_r2 <= 'd0;
	  end
	  else begin
	    rvalid_r1 <= rvalid;
	    rvalid_r2 <= rvalid_r1;
	    rid_r1 <= rid;
	    rid_r2 <= rid_r1;
	  end
	end
   wire [PORT_AXI_RDATA_WIDTH-1:0] ref_data_dash = {(PORT_AXI_RDATA_WIDTH/DATA_FADDRESS){r_arid_address}};
    assign ref_data = ref_data_dash;

   //make localparams since the params could have values of 0, which would break register widths
   localparam SID_ADDR_WIDTH_LOCAL = SID_ADDR_WIDTH > 0 ? SID_ADDR_WIDTH : 1;
   localparam BANK_GROUP_WIDTH_LOCAL  = BANK_GROUP_WIDTH > 0 ? BANK_GROUP_WIDTH : 1;
   localparam ROW_ADDR_WIDTH_LOCAL = ROW_ADDR_WIDTH > 0 ? ROW_ADDR_WIDTH : 1;
   localparam BANK_ADDR_WIDTH_LOCAL  = BANK_ADDR_WIDTH > 0 ? BANK_ADDR_WIDTH : 1;
	localparam NUMBER_OF_BYTE_EN_GENERATORS_LOCAL = NUMBER_OF_BYTE_EN_GENERATORS > 0 ? NUMBER_OF_BYTE_EN_GENERATORS : 1;

   localparam DATA_TO_CFG_WIDTH_RATIO = MEM_RDATA_WIDTH / AMM_CFG_DATA_WIDTH;
   localparam MAX_DATA_TO_CFG_MUX_SIZE = 36;

   localparam FIRST_STAGE_DECODER_KEY_WIDTH     = 5;
   localparam SECOND_STAGE_DECODER_KEY_WIDTH    = 5;

   //Only make sense to have TG's re-order buffer enable when doing out of order (user disable
   //Controller's re-order buffer) and when generating with different id
   localparam DIAG_TG_ROB_EN = (TG_USE_EFFICIENCY_PATTERN == 1)? 0: (((DIAG_TG_OOO_EN == 1) && (DIAG_TG_GENERATE_RW_IDS == 1)) ? 1 : 0);
   localparam MAX_ID = DIAG_TG_GENERATE_RW_IDS ? (1 << PORT_AXI_RID_WIDTH) : 1;
   localparam MAX_GENERATOR_SETS = (TG_USE_EFFICIENCY_PATTERN == 1)? 1: (((DIAG_TG_OOO_EN ==1) && (DIAG_TG_ROB_EN == 0)) ? MAX_ID : 1);

   //In Out-of-order mode, the compare address fifo might fill up to full quickly as compare to
   //when it is in-order mode. This is due to the read data for the first read address might arrive
   //late causing the flushing to happen slowly. Since the read arready is gated by compare_addr_gen_fifo_full
   //it affect the efficiency for this mode. However, increasing the depth might affect the
   //fMAX so as the resource count.
   localparam COMPARE_ADDR_FIFO_DEPTH = (DIAG_TG_ROB_EN == 1) ? 128 : 64;
   //In efficiency test mode, it require bigger queue as read happen back to back. This causing
   //the arid_queue fill up quickly when re-order/flushing rate stay the same. So bigger queue
   //is required in efficiency test mode.

   logic rst1,rst2a,rst2b,rst2c,rst2d; /* synthesis dont_merge */

   always_ff @(posedge clk)
   begin
      rst1   <= rst;
      rst2a   <= rst1;
      rst2b   <= rst1;
      rst2c   <= rst1;
      rst2d   <= rst1;
   end


   wire [MEM_ADDR_WIDTH-1:0]  write_addr;
   wire [MEM_ADDR_WIDTH-1:0]  read_addr;
   wire [PORT_AXI_RID_WIDTH-1:0] read_id;
   wire [PORT_AXI_AWID_WIDTH-1:0] write_addr_id;
   wire [PORT_AXI_AWID_WIDTH-1:0] wdata_id;
   wire [AMM_BURSTCOUNT_WIDTH-1:0] rd_burst_cnt;
   wire [AMM_BURSTCOUNT_WIDTH-1:0] wr_burst_cnt;

   wire status_check_in_prog;
   wire rw_gen_waitrequest;
   wire controller_rready;
   wire controller_wready;
   wire controller_awready;
   wire awrite_req;
   wire write_req;
   wire read_req;

   wire [MEM_DATA_WIDTH-1:0] mem_write_data [0:MAX_GENERATOR_SETS-1];
   wire [MEM_BE_WIDTH-1:0] mem_write_be [0:MAX_GENERATOR_SETS-1];

   //randomly generated write data
   reg [20-1:0]                 hbm_lfsr_write_data [0:MAX_GENERATOR_SETS-1][0:NUMBER_OF_DATA_GENERATORS-1];
   reg [MEM_DATA_WIDTH-1:0]     lfsr_write_data [0:MAX_GENERATOR_SETS-1];
   reg [MEM_BE_WIDTH-1:0]       lfsr_write_be [0:MAX_GENERATOR_SETS-1];
   //expected read data
   reg [20-1:0]                 hbm_lfsr_exp_write_data [0:MAX_GENERATOR_SETS-1][0:NUMBER_OF_DATA_GENERATORS-1];
   reg [MEM_DATA_WIDTH-1:0]     lfsr_exp_write_data [0:MAX_GENERATOR_SETS-1];
   reg [MEM_BE_WIDTH-1:0]       lfsr_exp_write_be [0:MAX_GENERATOR_SETS-1];
   wire [MEM_DATA_WIDTH-1:0]     written_data [0:MAX_GENERATOR_SETS-1];
   wire [MEM_BE_WIDTH-1:0]       written_be [0:MAX_GENERATOR_SETS-1];
   //user-defined write data
   wire [MEM_DATA_WIDTH-1:0]     hbm_lfsr_wdata [0:MAX_GENERATOR_SETS-1];
   wire [MEM_DATA_WIDTH-1:0]     hbm_lfsr_exp_wdata [0:MAX_GENERATOR_SETS-1];
   wire [MEM_BE_WIDTH-1:0]       hbm_lfsr_wbe [0:MAX_GENERATOR_SETS-1];
   wire [MEM_BE_WIDTH-1:0]       hbm_lfsr_exp_wbe [0:MAX_GENERATOR_SETS-1];
   wire [MEM_DATA_WIDTH-1:0]     fixed_wdata [0:MAX_GENERATOR_SETS-1];
   wire [MEM_BE_WIDTH-1:0]       fixed_wbe [0:MAX_GENERATOR_SETS-1];
   wire [MEM_DATA_WIDTH-1:0]     fixed_exp_wdata [0:MAX_GENERATOR_SETS-1];
   wire [MEM_BE_WIDTH-1:0]       fixed_exp_wbe [0:MAX_GENERATOR_SETS-1];
   wire [DATA_RATE_WIDTH_RATIO-1:0] fixed_write_data    [0:MAX_GENERATOR_SETS-1][0:NUMBER_OF_DATA_GENERATORS-1];
   wire [DATA_RATE_WIDTH_RATIO-1:0] fixed_write_be      [0:MAX_GENERATOR_SETS-1][0:NUMBER_OF_BYTE_EN_GENERATORS_LOCAL-1];
   wire [DATA_RATE_WIDTH_RATIO-1:0] fixed_exp_write_data    [0:MAX_GENERATOR_SETS-1][0:NUMBER_OF_DATA_GENERATORS-1];
   wire [DATA_RATE_WIDTH_RATIO-1:0] fixed_exp_write_be      [0:MAX_GENERATOR_SETS-1][0:NUMBER_OF_BYTE_EN_GENERATORS_LOCAL-1];

   reg [1:0] data_gen_mode /* synthesis maxfan = 450 */;
   reg [1:0] byte_en_gen_mode;
   //load for data generators
   reg [NUMBER_OF_DATA_GENERATORS-1:0] data_gen_load;
   //load for byte enable generators
   reg [NUMBER_OF_BYTE_EN_GENERATORS_LOCAL-1:0] byte_en_load;
   //enables from r/w generator to address generators
   wire next_addr_read;
   wire next_addr_write;
   wire next_data_read;
   wire next_data_write;
   wire [MAX_GENERATOR_SETS-1:0] next_read_data_en;
   wire [MAX_GENERATOR_SETS-1:0] next_read_data_en_prev;
   wire next_wlast;

   wire [AMM_CFG_DATA_WIDTH-1:0] pnf_to_cfg_mux_signal [0:MAX_DATA_TO_CFG_MUX_SIZE-1];
   wire [AMM_CFG_DATA_WIDTH-1:0] exp_data_to_cfg_mux_signal [0:MAX_DATA_TO_CFG_MUX_SIZE-1];
   wire [AMM_CFG_DATA_WIDTH-1:0] read_data_to_cfg_mux_signal [0:MAX_DATA_TO_CFG_MUX_SIZE-1];

   //memory mapped registers
   reg [RW_LOOP_COUNT_WIDTH-1:0]      rw_gen_loop_cnt;
   reg [RW_OPERATION_COUNT_WIDTH-1:0] rw_gen_write_cnt;
   reg [RW_OPERATION_COUNT_WIDTH-1:0] rw_gen_read_cnt;
   reg [RW_OPERATION_COUNT_WIDTH-1:0] rw_gen_read_cnt_r;
   reg [RW_RPT_COUNT_WIDTH-1:0]       rw_gen_write_rpt_cnt;
   reg [RW_RPT_COUNT_WIDTH-1:0]       rw_gen_read_rpt_cnt;
   reg rw_gen_start /* synthesis maxfan = 20 */;
   reg [AMM_BURSTCOUNT_WIDTH-1:0]     burstlength = BURST_LEN;

   reg [63:0] addr_gen_write_start_addr;
   reg [1:0]                addr_gen_mode_writes;
   reg [1:0]                addr_gen_mode_writes_r;

   reg [63:0] addr_gen_read_start_addr;
   reg [1:0]                addr_gen_mode_reads;
   reg [1:0]                addr_gen_mode_reads_r;

   //2nd layer decoder enables
   reg                              rw_gen_cfg_write;
   reg                              addr_gen_cfg_write;

   //timing pipeline
   reg                              amm_cfg_waitrequest_r;
   reg                              amm_cfg_write_r;
   reg                              amm_cfg_read_r;
   reg [AMM_CFG_ADDR_WIDTH-1:0]     amm_cfg_address_r;
   reg [AMM_CFG_DATA_WIDTH-1:0]     amm_cfg_writedata_r;
   reg [2:0]                        tg_start_count;
   reg                              tg_start_count_zero;

   reg [1:0]                        addr_gen_sid_mask_en;
   reg [1:0]                        addr_gen_bank_mask_en;
   reg [1:0]                        addr_gen_bankgroup_mask_en;
   reg [1:0]                        addr_gen_row_mask_en;
   reg [1:0]                        addr_gen_row_mask_en_r;
   reg [SID_ADDR_WIDTH_LOCAL-1:0]  addr_gen_sid_mask;
   reg [BANK_ADDR_WIDTH-1:0]        addr_gen_bank_mask;
   reg [ROW_ADDR_WIDTH-1:0]         addr_gen_row_mask;
   reg [BANK_GROUP_WIDTH_LOCAL-1:0] addr_gen_bankgroup_mask;

   //return to start address between write/read blocks for sequential addressing
   reg addr_gen_seq_return_to_start_addr;
   //number of sequential addresses to produce between random addresses for random sequential addressing
   reg [RAND_SEQ_CNT_WIDTH-1:0] addr_gen_rseq_num_seq_addr_write;
   reg [RAND_SEQ_CNT_WIDTH-1:0] addr_gen_rseq_num_seq_addr_read;
   //increment size for sequential or random sequential addressing. This is the increment to the avalon address
   reg [SEQ_ADDR_INCR_WIDTH-1:0] addr_gen_seq_addr_incr;

   reg [31:0]  config_error_report_reg;

   logic  [AMM_CFG_ADDR_WIDTH-1:0]     amm_cfg_address_r2;
   logic                               amm_cfg_read_r2;
   int j;
   generate
  //two-stage decoder for mapped registers
  //XXXX - need to revisit this since it change read functionality
   always @ (posedge clk)
   begin
      if (rst2a) begin
		   	    amm_cfg_readdatavalid    <= 1'b0;
          amm_cfg_read_r2          <= 1'b0;
          amm_cfg_address_r2       <= 'd0;
          amm_cfg_readdata         <= '0;
      end
      else begin
         amm_cfg_read_r2           <= amm_cfg_read_r;
         amm_cfg_address_r2        <= amm_cfg_address_r;
         amm_cfg_readdata          <= '0;
         if (amm_cfg_read_r2) begin
		   	       amm_cfg_readdatavalid <= 1'b1;
             case (amm_cfg_address_r2)
               TG_PASS: //pass status
                  amm_cfg_readdata[0] <= pass;
               TG_FAIL: //fail status
                  amm_cfg_readdata[0] <= fail;
               TG_FAIL_COUNT_L: //failure count 1/2
                  amm_cfg_readdata <= failure_count[31:0];
               TG_FAIL_COUNT_H: //failure count 2/2
                  amm_cfg_readdata <= failure_count[63:32];
               TG_FIRST_FAIL_ADDR_L: //first failure address 1/2
                  amm_cfg_readdata <= first_fail_addr[31:0];
               TG_FIRST_FAIL_ADDR_H: //first failure address 2/2
                  amm_cfg_readdata <= first_fail_addr[63:32];
               TG_FIRST_FAIL_IS_READ: //first failure is read failure
                  amm_cfg_readdata[0] <= first_fail_read;
               TG_FIRST_FAIL_IS_WRITE: //first failure is write failure
                  amm_cfg_readdata[0] <= first_fail_write;
               TG_TEST_COMPLETE: //test completion status
                  amm_cfg_readdata[0] <= ~(rw_gen_waitrequest | reads_in_prog);
               TG_VERSION: //Version number of the driver
                  amm_cfg_readdata <= 32'd160;
               TG_NUM_DATA_GEN: //number of data generators
                  amm_cfg_readdata    <= NUMBER_OF_DATA_GENERATORS;
               TG_NUM_BYTEEN_GEN: //number of byteen generators
                  amm_cfg_readdata    <= NUMBER_OF_BYTE_EN_GENERATORS;
               TG_SID_ADDR_WIDTH: //sid addr width
                  amm_cfg_readdata <= SID_ADDR_WIDTH;
               TG_BANK_ADDR_WIDTH: //BA width
                  amm_cfg_readdata <= BANK_ADDR_WIDTH;
               TG_BANK_GROUP_WIDTH: //BG width
                  amm_cfg_readdata <= BANK_GROUP_WIDTH;
               TG_ROW_ADDR_WIDTH: //Row width
                  amm_cfg_readdata <= ROW_ADDR_WIDTH;
               TG_DATA_PATTERN_LENGTH:
                  amm_cfg_readdata <= DIAG_TG_DATA_PATTERN_LENGTH;
               TG_BYTEEN_PATTERN_LENGTH:
                  amm_cfg_readdata <= DIAG_TG_BYTE_EN_PATTERN_LENGTH;
               TG_RDATA_WIDTH:
                  amm_cfg_readdata <= MEM_RDATA_WIDTH;
               TG_MIN_ADDR_INCR:
                  amm_cfg_readdata <= WORD_ADDRESS_DIVISIBLE_BY;
               TG_ERROR_REPORT:
                  amm_cfg_readdata <= config_error_report_reg;
               default: begin
                  if ( amm_cfg_address_r2[9:6]==4'b0010 ) begin
                     amm_cfg_readdata <= pnf_to_cfg_mux_signal[amm_cfg_address_r2[2:0]];
                  end else begin
                     // synthesis translate_off
                     $display("Error: Invalid read address range in module:traffic_gen.v");
                     // synthesis translate_on
                     amm_cfg_readdata <= 32'h0;
                  end
               end
             endcase
         end
         else begin
		   	       amm_cfg_readdatavalid <= 1'b0;
             amm_cfg_readdata          <= '0;
         end
      end
   end
  //two-stage decoder for mapped registers
  //Moatazbellah (MbSami) 20180721 -- This is to delay the start signal as the counters are being delayed for the sake of Fmax improvements
  reg rw_gen_start_adv; 
   always @ (posedge clk)
   begin

      if (rst2a) begin
         //default initial assignments
         addr_gen_seq_return_to_start_addr <= '0;
         addr_gen_sid_mask_en             <= '0;
         addr_gen_bank_mask_en             <= '0;
         addr_gen_row_mask_en              <= '0;
         addr_gen_bankgroup_mask_en        <= '0;
         addr_gen_bankgroup_mask           <= '0;
         addr_gen_sid_mask                <= '0;
         addr_gen_bank_mask                <= '0;
         addr_gen_row_mask                 <= '0;
         addr_gen_write_start_addr         <= '0;
         addr_gen_read_start_addr          <= '0;
         rw_gen_loop_cnt                   <= 1'b1;
         rw_gen_write_cnt                  <= '0;
         rw_gen_read_cnt                   <= '0;
         rw_gen_write_rpt_cnt              <= 1'b1;
         rw_gen_read_rpt_cnt               <= 1'b1;
         addr_gen_rseq_num_seq_addr_write  <= 1'b1;
         addr_gen_rseq_num_seq_addr_read   <= 1'b1;
         addr_gen_seq_addr_incr            <= BURST_COUNT_DIVISIBLE_BY;
         addr_gen_mode_writes              <= 2'h2;
         addr_gen_mode_reads               <= 2'h2;
         clear_first_fail                  <= '0;
         byteenable_stage                  <= '0;
         rw_gen_start                      <= 1'b0;
         restart_default_traffic           <= 1'b0;
         amm_cfg_address_r                 <= '0;
         amm_cfg_writedata_r               <= '0;
         amm_cfg_write_r                   <= 1'b0;
         amm_cfg_read_r                    <= 1'b0;
         rw_gen_cfg_write                  <= 1'b0;
         addr_gen_cfg_write                <= 1'b0;
         data_gen_mode                       <= 2'b0;
         byte_en_gen_mode                    <= 2'b0;
         data_gen_load                       <= '0;
         byte_en_load                        <= '0;
         amm_cfg_waitrequest_r             <= 1'b1;
         tg_start_count                    <= '0;
         tg_start_count_zero               <= 1'b0;
         rw_gen_start_adv                  <= 1'b0;
      end
      else begin
         rw_gen_start <= rw_gen_start_adv;
         if (amm_cfg_address == TG_START && amm_cfg_write && ~amm_cfg_waitrequest_r) begin
            tg_start_count <= '1;
            tg_start_count_zero               <= 1'b1;
         end else if (|tg_start_count) begin
            tg_start_count_zero               <= |(tg_start_count - 1'b1);
            tg_start_count <= tg_start_count - 1'b1;
         end

         amm_cfg_waitrequest_r               <= rw_gen_waitrequest | status_check_in_prog | tg_start_count_zero;

         //defaults applied each clock cycle
         rw_gen_start_adv  <= 1'b0;
         restart_default_traffic  <= 1'b0;
         clear_first_fail <= 1'b0;

         effmon_csr_write <= 1'b0;
         effmon_csr_address <= '0;
         effmon_csr_writedata <= '0;
         effmon_csr_read <= '0;

         if ((amm_cfg_write && !amm_cfg_waitrequest) || amm_cfg_read) begin
            amm_cfg_address_r    <= amm_cfg_address;
            amm_cfg_writedata_r  <= amm_cfg_writedata;
            amm_cfg_write_r      <= amm_cfg_write;
            amm_cfg_read_r       <= amm_cfg_read;
         end else begin
            amm_cfg_write_r      <= 1'b0;
            amm_cfg_read_r       <= 1'b0;
         end
         if (amm_cfg_write && !amm_cfg_waitrequest) begin
            //Configuration of the data generator (seed)
            //The seed for data generator N can be found at address 100+N
            for (j = 0; j < NUMBER_OF_DATA_GENERATORS; j = j + 1) begin: write_seed
               if(amm_cfg_address == TG_DATA_SEED+j) begin
                  data_gen_load[j]           <= 1'b1;
               end else begin
                  data_gen_load[j]           <= 1'b0;
               end
            end
            //Configuration of the byte enable generator (seed)
            //The seed for byte enable generator N can be found at address 1A0+N
            for (j = 0; j < NUMBER_OF_BYTE_EN_GENERATORS_LOCAL; j = j + 1) begin: byte_en_seed
               if(amm_cfg_address == TG_BYTEEN_SEED+j) begin
                  byte_en_load[j]            <= 1'b1;
               end else begin
                  byte_en_load[j]            <= 1'b0;
               end
            end
         end else begin
                  data_gen_load              <= {(NUMBER_OF_DATA_GENERATORS){1'b0}};
                  byte_en_load               <= {(NUMBER_OF_BYTE_EN_GENERATORS_LOCAL){1'b0}};
         end

         if (amm_cfg_address[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH] < TG_SEQ_START_ADDR_WR_L[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH]) begin
            rw_gen_cfg_write      <= amm_cfg_write;
            addr_gen_cfg_write    <= 1'b0;
         end else if ((amm_cfg_address[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH] >= TG_SEQ_START_ADDR_WR_L[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH]) && (amm_cfg_address[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH] < TG_PASS[FIRST_STAGE_DECODER_KEY_WIDTH + SECOND_STAGE_DECODER_KEY_WIDTH - 1:SECOND_STAGE_DECODER_KEY_WIDTH])) begin
            rw_gen_cfg_write      <= 1'b0;
            addr_gen_cfg_write    <= amm_cfg_write;
         end else begin
            rw_gen_cfg_write      <= 1'b0;
            addr_gen_cfg_write    <= 1'b0;
         end

         if (rw_gen_cfg_write && !amm_cfg_waitrequest_r) begin

            //The following configuration descriptions can be found in the functional description of the traffic driver
            case(amm_cfg_address_r[SECOND_STAGE_DECODER_KEY_WIDTH-1:0])
               //Starts the R/W Generator
               TG_START[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: rw_gen_start_adv         <= 1'b1;
               //Number of write and read blocks
               TG_LOOP_COUNT[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:          rw_gen_loop_cnt      <= amm_cfg_writedata_r [RW_LOOP_COUNT_WIDTH-1:0];
               //Number of block writes
               TG_WRITE_COUNT[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: rw_gen_write_cnt     <= amm_cfg_writedata_r [RW_OPERATION_COUNT_WIDTH-1:0];
               //Number of block reads
               TG_READ_COUNT[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: rw_gen_read_cnt      <= amm_cfg_writedata_r [RW_OPERATION_COUNT_WIDTH-1:0];
               //Number of write repeats
               TG_WRITE_REPEAT_COUNT[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: rw_gen_write_rpt_cnt <= amm_cfg_writedata_r [RW_RPT_COUNT_WIDTH-1:0];
               //Number of read repeats
               TG_READ_REPEAT_COUNT[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:   rw_gen_read_rpt_cnt  <= amm_cfg_writedata_r [RW_RPT_COUNT_WIDTH-1:0];
               //clear first fail
               TG_CLEAR_FIRST_FAIL[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: clear_first_fail                    <= '1;
               TG_TEST_BYTEEN[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:      byteenable_stage                    <= amm_cfg_writedata[0];
               TG_RESTART_DEFAULT_TRAFFIC[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:  restart_default_traffic <= 1'b1;
               TG_DATA_MODE[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                 data_gen_mode              <= amm_cfg_writedata_r [1:0];
               TG_BYTEEN_MODE[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:               byte_en_gen_mode           <= amm_cfg_writedata_r [1:0];
               TG_START_EFFMON[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: begin
                  effmon_csr_write <= 1'b1;
                  effmon_csr_address <= EFFMON_RESET;
               end
               TG_STOP_EFFMON[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: begin
                  effmon_csr_write <= 1'b1;
                  effmon_csr_address <= EFFMON_SNAPSHOT;
               end
               // synthesis translate_off
               default:
                  $display("Error: Invalid write address range in module:traffic_gen.v");
               // synthesis translate_on
            endcase
         end
         else if( addr_gen_cfg_write && !amm_cfg_waitrequest_r) begin
            case(amm_cfg_address_r[SECOND_STAGE_DECODER_KEY_WIDTH-1:0])
               //write address generator
               //Start address for sequential mode
               TG_SEQ_START_ADDR_WR_L[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_write_start_addr [31:0]    <= amm_cfg_writedata_r;
               TG_SEQ_START_ADDR_WR_H[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_write_start_addr [63:32]   <= amm_cfg_writedata_r;
               //Mode of the address
               TG_ADDR_MODE_WR[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                   addr_gen_mode_writes     <= amm_cfg_writedata_r [1:0];
               TG_RAND_SEQ_ADDRS_WR[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_rseq_num_seq_addr_write      <= amm_cfg_writedata_r [RAND_SEQ_CNT_WIDTH-1:0];
               TG_RETURN_TO_START_ADDR[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_seq_return_to_start_addr  <= amm_cfg_writedata_r [0];

               //disable masking when only 1 or 0 sids or bank groups
               //Mask enables allow the user to cycle through certain address sections
               TG_SID_MASK_EN[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                    addr_gen_sid_mask_en      <= amm_cfg_writedata_r [1:0];
               TG_BANK_MASK_EN[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                    addr_gen_bank_mask_en      <= amm_cfg_writedata_r [1:0];
               TG_ROW_MASK_EN[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                     addr_gen_row_mask_en       <= amm_cfg_writedata_r [1:0];
               TG_SID_MASK[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                       addr_gen_sid_mask         <= amm_cfg_writedata_r [SID_ADDR_WIDTH_LOCAL-1:0];
               TG_BANK_MASK[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                       addr_gen_bank_mask         <= amm_cfg_writedata_r [BANK_ADDR_WIDTH_LOCAL-1:0];
               TG_ROW_MASK[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                        addr_gen_row_mask          <= amm_cfg_writedata_r [ROW_ADDR_WIDTH_LOCAL-1:0];
               TG_BG_MASK[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                         addr_gen_bankgroup_mask    <= amm_cfg_writedata_r [BANK_GROUP_WIDTH_LOCAL-1:0];
               TG_BG_MASK_EN[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                      addr_gen_bankgroup_mask_en <= amm_cfg_writedata_r [1:0];
               TG_SEQ_ADDR_INCR[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                   addr_gen_seq_addr_incr     <= amm_cfg_writedata_r [SEQ_ADDR_INCR_WIDTH-1:0];

               //read address generator
               TG_SEQ_START_ADDR_RD_L[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_read_start_addr [31:0]        <= amm_cfg_writedata_r;
               TG_SEQ_START_ADDR_RD_H[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_read_start_addr [63:32]       <= amm_cfg_writedata_r;
               TG_ADDR_MODE_RD[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]:                    addr_gen_mode_reads        <= amm_cfg_writedata_r [1:0];
               TG_RAND_SEQ_ADDRS_RD[SECOND_STAGE_DECODER_KEY_WIDTH-1:0]: addr_gen_rseq_num_seq_addr_read          <= amm_cfg_writedata_r [RAND_SEQ_CNT_WIDTH-1:0];
               // synthesis translate_off
               default:
                  $display("Error: Invalid write address range in module:traffic_gen.v");
               // synthesis translate_on
            endcase
         end
      end
   end
   endgenerate

   always @ (posedge clk)
   begin
      addr_gen_mode_reads_r  <= addr_gen_mode_reads;
      addr_gen_mode_writes_r <= addr_gen_mode_writes;
      addr_gen_row_mask_en_r <= addr_gen_row_mask_en;
      rw_gen_read_cnt_r      <= rw_gen_read_cnt;
   end

   assign reads_in_prog = status_check_in_prog | rw_gen_start;
   assign amm_cfg_waitrequest = amm_cfg_waitrequest_r;
   assign tg_restart = rw_gen_start;

   genvar id;
   genvar k;
   genvar l;
   genvar by;
   genvar pin;
   genvar rf;
   generate
   for ( k = 0; k < MAX_DATA_TO_CFG_MUX_SIZE; k++ ) begin: multiplex_pnf_to_cfg
      if ( k == DATA_TO_CFG_WIDTH_RATIO && MEM_RDATA_WIDTH-1 >= k*AMM_CFG_DATA_WIDTH) begin
         assign pnf_to_cfg_mux_signal[k]           = pnf_per_bit_persist[MEM_RDATA_WIDTH-1 : k*AMM_CFG_DATA_WIDTH];
         assign exp_data_to_cfg_mux_signal[k]      = first_fail_expected_data[MEM_RDATA_WIDTH-1 : k*AMM_CFG_DATA_WIDTH];
         assign read_data_to_cfg_mux_signal[k]     = first_fail_read_data[MEM_RDATA_WIDTH-1 : k*AMM_CFG_DATA_WIDTH];
      end else if (k < DATA_TO_CFG_WIDTH_RATIO) begin
         assign pnf_to_cfg_mux_signal[k]           = pnf_per_bit_persist[(k+1)*AMM_CFG_DATA_WIDTH - 1 : k*AMM_CFG_DATA_WIDTH];
         assign exp_data_to_cfg_mux_signal[k]      = first_fail_expected_data[(k+1)*AMM_CFG_DATA_WIDTH - 1 : k*AMM_CFG_DATA_WIDTH];
         assign read_data_to_cfg_mux_signal[k]     = first_fail_read_data[(k+1)*AMM_CFG_DATA_WIDTH - 1 : k*AMM_CFG_DATA_WIDTH];
      end else begin
         assign pnf_to_cfg_mux_signal[k]           = '0;
         assign exp_data_to_cfg_mux_signal[k]      = '0;
         assign read_data_to_cfg_mux_signal[k]     = '0;
      end
   end

   for (id = 0 ; id < MAX_GENERATOR_SETS; id = id + 1) begin: gen_id
      for (l = 0; l < DATA_RATE_WIDTH_RATIO; l++) begin: fixed_wdata_mux_outer
         for ( k = 0; k < NUMBER_OF_DATA_GENERATORS; k++) begin: fixed_wdata_mux_inner
            assign fixed_wdata[id][l*NUMBER_OF_DATA_GENERATORS+k] = fixed_write_data[id][k][DATA_RATE_WIDTH_RATIO-l-1];
         end
      end
      for (l = 0; l < DATA_RATE_WIDTH_RATIO; l++) begin: fixed_exp_wdata_mux_outer
         for ( k = 0; k < NUMBER_OF_DATA_GENERATORS; k++) begin: fixed_exp_wdata_mux_inner
            assign fixed_exp_wdata[id][l*NUMBER_OF_DATA_GENERATORS+k] = fixed_exp_write_data[id][k][DATA_RATE_WIDTH_RATIO-l-1];
         end
      end
      if (USE_BYTE_EN) begin
         for (l = 0; l < DATA_RATE_WIDTH_RATIO; l++) begin: fixed_wbe_mux_outer
            for ( k = 0; k < NUMBER_OF_BYTE_EN_GENERATORS_LOCAL; k++) begin: fixed_wbe_mux_inner
               assign fixed_wbe[id][l*NUMBER_OF_BYTE_EN_GENERATORS_LOCAL+k] = fixed_write_be[id][k][DATA_RATE_WIDTH_RATIO-l-1];
            end
         end
         for (l = 0; l < DATA_RATE_WIDTH_RATIO; l++) begin: fixed_exp_wbe_mux_outer
            for ( k = 0; k < NUMBER_OF_BYTE_EN_GENERATORS_LOCAL; k++) begin: fixed_exp_wbe_mux_inner
               assign fixed_exp_wbe[id][l*NUMBER_OF_BYTE_EN_GENERATORS_LOCAL+k] = fixed_exp_write_be[id][k][DATA_RATE_WIDTH_RATIO-l-1];
            end
         end
      end else begin
         assign fixed_wbe[id] = {(MEM_BE_WIDTH){1'b1}};
         assign fixed_exp_wbe[id] = {(MEM_BE_WIDTH){1'b1}};
      end
   end

    //Remap to local write data structure
    for (id = 0 ; id < MAX_GENERATOR_SETS; id = id + 1) begin: gen_hbm_lfsr_data_id
        for (rf = 0; rf < DATA_RATE_WIDTH_RATIO; rf++) begin: gen_hbm_lfsr_data_fr
            for ( by = 0; by < NUMBER_OF_DATA_GENERATORS/8; by++) begin: gen_hbm_lfsr_data_byte
                //The generated LFSR data is  comprised of double data rate
                //Rise and Fall bits for DBI, each of the eight DQs plus
                //DM signals at the LSB. Drop DBI since it is beyond TG control
                for ( pin = 1; pin < 9; pin++) begin: gen_hbm_lfsr_data_pin
                    assign hbm_lfsr_wdata[id][(NUMBER_OF_DATA_GENERATORS*rf) + (by*8) + (pin-1)]        = hbm_lfsr_write_data[id][by][pin * 2 + rf];
                    assign hbm_lfsr_exp_wdata[id][(NUMBER_OF_DATA_GENERATORS*rf) + (by*8) + (pin-1)]    = hbm_lfsr_exp_write_data[id][by][pin * 2 + rf];
                end
            end
        end
    end

    //Remap to local byte enable structure
    for (id = 0 ; id < MAX_GENERATOR_SETS; id = id + 1) begin: gen_hbm_lfsr_be_id
        for (rf = 0; rf < DATA_RATE_WIDTH_RATIO; rf++) begin: gen_hbm_lfsr_rf
            for ( by = 0; by < NUMBER_OF_DATA_GENERATORS/8; by++) begin: gen_hbm_lfsr_be_byte
                //First 2 LSB bits from LFSR generated bits are for DM
                assign hbm_lfsr_wbe[id][(NUMBER_OF_BYTE_EN_GENERATORS_LOCAL*rf) + by]                   = (USE_BYTE_EN) ? hbm_lfsr_write_data[id][by][rf]     : 1'b1;
                assign hbm_lfsr_exp_wbe[id][(NUMBER_OF_BYTE_EN_GENERATORS_LOCAL*rf) + by]               = (USE_BYTE_EN) ? hbm_lfsr_exp_write_data[id][by][rf] : 1'b1;
            end
        end
    end
   endgenerate

   //Traffic generation modules

   wire compare_addr_gen_fifo_full;

   reg [31:0]  cmp_read_rpt_cnt;
   reg         rdata_valid_r;

	//read/write generator
   altera_hbm_tg_axi_rw_gen #(
      .SEPARATE_READ_WRITE_IFS   (1),
      .RPT_COUNT_WIDTH           (RW_RPT_COUNT_WIDTH),
      .OPERATION_COUNT_WIDTH     (RW_OPERATION_COUNT_WIDTH),
      .LOOP_COUNT_WIDTH          (RW_LOOP_COUNT_WIDTH),
      .AMM_BURSTCOUNT_WIDTH      (AMM_BURSTCOUNT_WIDTH),
      .DIAG_EFFICIENCY_TEST_MODE (DIAG_EFFICIENCY_TEST_MODE),
      .BURST_LEN_EXTEND_EN       (BURST_LEN_EXTEND_EN),
      .MAX_BURST_COUNT           (MAX_BURST_COUNT),
      .MIN_BURST_COUNT           (MIN_BURST_COUNT),
      .BURST_COUNT_DIVISIBLE_BY  (BURST_COUNT_DIVISIBLE_BY),
      .BURST_COUNT_MODE          (BURST_COUNT_MODE)
      )
      rw_gen_u0 (
      .clk                    (clk),
      .rst                    (rst2b),
      .rcmd_req               (read_req),
      .wcmd_req               (awrite_req),
      .wdata_req              (write_req),
      .next_addr_read         (next_addr_read),
      .next_addr_write        (next_addr_write),
      .next_data_write        (next_data_write),
      .waitrequest            (rw_gen_waitrequest),
      .read_ready             (controller_rready),
      .write_ready            (controller_wready),
      .awrite_ready           (controller_awready),
      .start                  (rw_gen_start),
      .rw_gen_read_cnt        (rw_gen_read_cnt_r),
      //writes are concerned with burst length, as write enable must be held high
      //for entire duration of burst
      .rw_gen_read_rpt_cnt    (rw_gen_read_rpt_cnt),
      .rw_gen_write_rpt_cnt   (rw_gen_write_rpt_cnt),
      .rw_gen_write_cnt       (rw_gen_write_cnt),
      .rw_gen_loop_cnt        (rw_gen_loop_cnt),
      .burstlength            (burstlength),
      .next_wlast             (next_wlast),
      .bvalid                 (bvalid),
      .bready                 (bready)
   );

	//address generators
   altera_hbm_tg_axi_addr_gen #(
      .ADDRESS_WIDTH               (MEM_ADDR_WIDTH),
      .AMM_BURSTCOUNT_WIDTH        (AMM_BURSTCOUNT_WIDTH),
      .ROW_ADDR_WIDTH              (ROW_ADDR_WIDTH),
      .ROW_ADDR_LSB                (ROW_ADDR_LSB),
      .SEQ_CNT_WIDTH               (RW_OPERATION_COUNT_WIDTH),
      .RAND_SEQ_CNT_WIDTH          (RAND_SEQ_CNT_WIDTH),
      .SEQ_ADDR_INCR_WIDTH         (SEQ_ADDR_INCR_WIDTH),
      .PORT_AXI_RID_WIDTH          (PORT_AXI_RID_WIDTH),
      .MAX_ID                      (MAX_ID),
      .SID_ADDR_WIDTH_LOCAL       (SID_ADDR_WIDTH_LOCAL),
      .SID_ADDR_LSB               (SID_ADDR_LSB),
      .BANK_ADDR_WIDTH             (BANK_ADDR_WIDTH),
      .BANK_ADDR_LSB               (BANK_ADDR_LSB),
      .BANK_GROUP_WIDTH_LOCAL      (BANK_GROUP_WIDTH_LOCAL),
      .BANK_GROUP_LSB              (BANK_GROUP_LSB),
      .SID_ADDR_WIDTH             (SID_ADDR_WIDTH),
      .BANK_GROUP_WIDTH            (BANK_GROUP_WIDTH),
      .WORD_ADDRESS_DIVISIBLE_BY   (WORD_ADDRESS_DIVISIBLE_BY),
      .BURST_COUNT_DIVISIBLE_BY    (BURST_COUNT_DIVISIBLE_BY),
      .DIAG_EFFICIENCY_TEST_MODE   (DIAG_EFFICIENCY_TEST_MODE),
      .DIAG_HBMC_TEST_MODE         (DIAG_HBMC_TEST_MODE),
      .WRITE_GEN                   (1),
      .TG_USE_EFFICIENCY_PATTERN   (TG_USE_EFFICIENCY_PATTERN),
      .ENABLE_DATA_CHECK           (ENABLE_DATA_CHECK),
      .SEED                        (SEED),
      .BURST_LEN                   (BURST_LEN),
      .BURST_LEN_EXTEND_EN         (BURST_LEN_EXTEND_EN),
      .MAX_BURST_COUNT             (MAX_BURST_COUNT),
      .MIN_BURST_COUNT             (MIN_BURST_COUNT),
      .BURST_COUNT_MODE            (BURST_COUNT_MODE)
      )
      write_address_gen (
      .clk                       (clk),
      .rst                       (rst2c),
      .enable                    (next_addr_write),
      .addr_out                  (write_addr),
      .id_out                    (write_addr_id),
      .burstcount_out            (wr_burst_cnt),
      .start                     (rw_gen_start),
      .start_addr                (addr_gen_write_start_addr[MEM_ADDR_WIDTH-1:0]),
      .addr_gen_mode             (addr_gen_mode_writes_r),
      .initialization_phase      (initialization_phase),
      //for sequential mode
      .seq_return_to_start_addr  (addr_gen_seq_return_to_start_addr),
      .seq_addr_num              (rw_gen_write_cnt),
      //for random sequential
      .rand_seq_num_seq_addr     (addr_gen_rseq_num_seq_addr_write),
      .seq_addr_increment        (addr_gen_seq_addr_incr),

      .sid_mask_en               (addr_gen_sid_mask_en),
      .bank_mask_en              (addr_gen_bank_mask_en),
      .row_mask_en               (addr_gen_row_mask_en_r),
      .sid_mask                  (addr_gen_sid_mask),
      .bank_mask                 (addr_gen_bank_mask),
      .row_mask                  (addr_gen_row_mask),
      .bankgroup_mask_en         (addr_gen_bankgroup_mask_en),
      .bankgroup_mask            (addr_gen_bankgroup_mask),
      .burstcount                (burstlength)
   );

   // Write ID generator used for selecting the appropriate data.
   // This is separate from the write addr gen ID because the write data generation
   // comes after write address generation.
   altera_hbm_tg_axi_rwid_gen #(
      .PORT_AXI_RID_WIDTH  (PORT_AXI_RID_WIDTH),
      .MAX_ID              (MAX_GENERATOR_SETS),
      .WRITE_GEN(1),
      .TG_USE_EFFICIENCY_PATTERN   (TG_USE_EFFICIENCY_PATTERN)
   ) wdata_id_gen_inst (
      .clk                 (clk),
      .rst                 (rst2d),
      .enable              (controller_wready & write_req),
      .start               (rw_gen_start),
      .id_out              (wdata_id)
   );

   altera_hbm_tg_axi_addr_gen #(
      .ADDRESS_WIDTH               (MEM_ADDR_WIDTH),
      .AMM_BURSTCOUNT_WIDTH        (AMM_BURSTCOUNT_WIDTH),
      .ROW_ADDR_WIDTH              (ROW_ADDR_WIDTH),
      .ROW_ADDR_LSB                (ROW_ADDR_LSB),
      .SEQ_CNT_WIDTH               (RW_OPERATION_COUNT_WIDTH),
      .RAND_SEQ_CNT_WIDTH          (RAND_SEQ_CNT_WIDTH),
      .SEQ_ADDR_INCR_WIDTH         (SEQ_ADDR_INCR_WIDTH),
      .PORT_AXI_RID_WIDTH          (PORT_AXI_RID_WIDTH),
      .MAX_ID                      (MAX_ID),
      .SID_ADDR_WIDTH_LOCAL       (SID_ADDR_WIDTH_LOCAL),
      .SID_ADDR_LSB               (SID_ADDR_LSB),
      .BANK_ADDR_WIDTH             (BANK_ADDR_WIDTH),
      .BANK_ADDR_LSB               (BANK_ADDR_LSB),
      .BANK_GROUP_WIDTH_LOCAL      (BANK_GROUP_WIDTH_LOCAL),
      .BANK_GROUP_LSB              (BANK_GROUP_LSB),
      .SID_ADDR_WIDTH             (SID_ADDR_WIDTH),
      .BANK_GROUP_WIDTH            (BANK_GROUP_WIDTH),
      .WORD_ADDRESS_DIVISIBLE_BY   (WORD_ADDRESS_DIVISIBLE_BY),
      .BURST_COUNT_DIVISIBLE_BY    (BURST_COUNT_DIVISIBLE_BY),
      .DIAG_EFFICIENCY_TEST_MODE   (DIAG_EFFICIENCY_TEST_MODE),
      .DIAG_HBMC_TEST_MODE         (DIAG_HBMC_TEST_MODE),
      .WRITE_GEN                   (0),
      .TG_USE_EFFICIENCY_PATTERN   (TG_USE_EFFICIENCY_PATTERN),
      .ENABLE_DATA_CHECK           (ENABLE_DATA_CHECK),
      .SEED                        (SEED),
      .BURST_LEN                   (BURST_LEN),
      .BURST_LEN_EXTEND_EN         (BURST_LEN_EXTEND_EN),
      .MAX_BURST_COUNT             (MAX_BURST_COUNT),
      .MIN_BURST_COUNT             (MIN_BURST_COUNT),
      .BURST_COUNT_MODE            (BURST_COUNT_MODE)
      )
      read_address_gen (
      .clk                       (clk),
      .rst                       (rst2d),
      .rvalid(rvalid & rlast),
      .rid(rid),
      //enable on start in order to generate the first address
      .enable                    ((next_addr_read)|rw_gen_start),
      .addr_out                  (read_addr),
      .id_out                    (read_id),
      .burstcount_out            (rd_burst_cnt),
      .start                     (rw_gen_start),
      .start_addr                (addr_gen_read_start_addr[MEM_ADDR_WIDTH-1:0]),
      .addr_gen_mode             (addr_gen_mode_reads_r),
      .initialization_phase      (initialization_phase),
      //for sequential mode
      .seq_return_to_start_addr  (addr_gen_seq_return_to_start_addr),
      .seq_addr_num              (rw_gen_read_cnt_r),
      //for random sequential
      .rand_seq_num_seq_addr     (addr_gen_rseq_num_seq_addr_read),
      .seq_addr_increment        (addr_gen_seq_addr_incr),

      .sid_mask_en               (addr_gen_sid_mask_en),
      .bank_mask_en              (addr_gen_bank_mask_en),
      .row_mask_en               (addr_gen_row_mask_en_r),
      .sid_mask                  (addr_gen_sid_mask),
      .bank_mask                 (addr_gen_bank_mask),
      .row_mask                  (addr_gen_row_mask),
      .bankgroup_mask_en         (addr_gen_bankgroup_mask_en),
      .bankgroup_mask            (addr_gen_bankgroup_mask),
      .burstcount                (burstlength)
   );


	//data generators
   //2 sets needed - 1 for writes, 1 for verification of read data
   // A separate data generator is used to re-generate the written data/mask for read comparison.
   // This saves us from the need of instantiating a FIFO to record the write data

   genvar i;
   generate
      for (id = 0; id < MAX_GENERATOR_SETS; id = id + 1) begin: gen_data_id
         for (i = 0; i < NUMBER_OF_DATA_GENERATORS; i = i + 1) begin: data_pppg
            if(!BURST_LEN_EXTEND_EN) begin
	       // Write
	       altera_hbm_tg_axi_per_pin_pattern_gen #(
                  .OUTPUT_WIDTH   (DATA_RATE_WIDTH_RATIO),
                  .PATTERN_LENGTH (DIAG_TG_DATA_PATTERN_LENGTH),
                  .PRBS_SEED_OFFSET(id),
                  .DEFAULT_MODE   (TG_PATTERN_PRBS[0]),
                  .DEFAULT_STATE  ({{(DIAG_TG_DATA_PATTERN_LENGTH-1){1'b0}}, 1'b1})
                  )
                  data_pppg_wr (
                  .clk            (clk),
                  .rst            (rst2a),
                  .load           (data_gen_load[i]),
                  .load_mode      (1'b1),
                  .load_data      (amm_cfg_writedata_r[DIAG_TG_DATA_PATTERN_LENGTH-1:0]),
                  .load_inversion (1'b0),
                  .enable         ((id == wdata_id) ? next_data_write : 1'b0),
                  .dout           (fixed_write_data[id][i]),
                  .state_out      ()
               );
               // Read
               altera_hbm_tg_axi_per_pin_pattern_gen #(
                  .OUTPUT_WIDTH   (DATA_RATE_WIDTH_RATIO),
                  .PATTERN_LENGTH (DIAG_TG_DATA_PATTERN_LENGTH),
                  .PRBS_SEED_OFFSET(id),
                  .DEFAULT_MODE   (TG_PATTERN_PRBS[0]),
                  .DEFAULT_STATE  ({{(DIAG_TG_DATA_PATTERN_LENGTH-1){1'b0}}, 1'b1})
                  )
                  data_pppg_rd (
                  .clk            (clk),
                  .rst            (rst2b),
                  .load           (data_gen_load[i]),
                  .load_mode      (1'b1),
                  .load_data      (amm_cfg_writedata_r[DIAG_TG_DATA_PATTERN_LENGTH-1:0]),
                  .load_inversion (1'b0),
                  .enable         (next_read_data_en_prev[id]),
                  .dout           (fixed_exp_write_data[id][i]),
                  .state_out      ()
               );
            end else begin
	      assign fixed_write_data[id][i] = '0;
	      assign fixed_exp_write_data[id][i] = '0;
	    end
	 end
         //byte enable generators
         //2 sets needed - 1 for writes, 1 for verification of read data

         for (i = 0; i < NUMBER_OF_BYTE_EN_GENERATORS_LOCAL; i = i + 1) begin: byte_en_pppg
	    if(!BURST_LEN_EXTEND_EN) begin
               altera_hbm_tg_axi_per_pin_pattern_gen #(
                  .OUTPUT_WIDTH   (DATA_RATE_WIDTH_RATIO),
                  .PATTERN_LENGTH (DIAG_TG_BYTE_EN_PATTERN_LENGTH),
                  .PRBS_SEED_OFFSET(id),
                  .DEFAULT_MODE   (TG_PATTERN_FIXED[0]),
                  .DEFAULT_STATE  ({DIAG_TG_BYTE_EN_PATTERN_LENGTH{1'b1}})
                  ) be_pppg_wr (
                  .clk            (clk),
                  .rst            (rst2c),
                  .load           (byte_en_load[i]),
                  .load_mode      (1'b1),
                  .load_data      (amm_cfg_writedata_r[DIAG_TG_BYTE_EN_PATTERN_LENGTH-1:0]),
                  .load_inversion (1'b0),
                  .enable         ((id == wdata_id) ? next_data_write : 1'b0),
                  .dout           (fixed_write_be[id][i]),
                  .state_out      ()
                  );
               altera_hbm_tg_axi_per_pin_pattern_gen #(
                  .OUTPUT_WIDTH   (DATA_RATE_WIDTH_RATIO),
                  .PATTERN_LENGTH (DIAG_TG_BYTE_EN_PATTERN_LENGTH),
                  .PRBS_SEED_OFFSET(id),
                  .DEFAULT_MODE   (TG_PATTERN_FIXED[0]),
                  .DEFAULT_STATE  ({DIAG_TG_BYTE_EN_PATTERN_LENGTH{1'b1}})
                  )
                  be_pppg_rd (
                  .clk            (clk),
                  .rst            (rst2d),
                  .load           (byte_en_load[i]),
                  .load_mode      (1'b1),
                  .load_data      (amm_cfg_writedata_r[DIAG_TG_BYTE_EN_PATTERN_LENGTH-1:0]),
                  .load_inversion (1'b0),
                  .enable         (next_read_data_en_prev[id]),
                  .dout           (fixed_exp_write_be[id][i]),
                  .state_out      ()
               );
            end else begin
	      assign fixed_write_data[id][i] = '0;
	      assign fixed_exp_write_data[id][i] = '0;
	    end
         end
         //LFSR data generators
         //2 sets needed - 1 for writes, 1 for verification of read data
         // A separate data generator is used to re-generate the written data/mask for read comparison.
         // This saves us from the need of instantiating a FIFO to record the write data

         //Actual data signal generation

         //Actual write data generator
         if (HBM_LFSR == 1) begin
             for (i = 0; i < NUMBER_OF_DATA_GENERATORS; i = i + 1) begin: data_pppg
                altera_hbm_tg_axi_hbm_lfsr # (
                   .LFSR_TYPE   ("DWORD"),
                   .WIDTH       (20)
                ) act_data_gen_inst (
                   .clk         (clk),
                   .prst        (rst2a),
                   .enable      ((id == wdata_id) & next_data_write & (data_gen_mode[0] == 0)),
                   .data        (hbm_lfsr_write_data[id][i]),
                   .tg_start    (tg_restart)
                );

                altera_hbm_tg_axi_hbm_lfsr # (
                   .LFSR_TYPE   ("DWORD"),
                   .WIDTH       (20)
                ) exp_data_gen_inst (
                   .clk         (clk),
                   .prst        (rst2b),
                   .enable      (next_read_data_en[id] & (data_gen_mode[0] == 0)),
                   .data        (hbm_lfsr_exp_write_data[id][i]),
                   .tg_start    (tg_restart)
                );
            end
         end else begin
            altera_emif_avl_tg_lfsr_wrapper # (
               .DATA_WIDTH (MEM_DATA_WIDTH),
               .SEED       (TG_LFSR_SEED)
            ) act_data_gen_inst (
               .clk        (clk),
               .reset_n    (~rst2a),
               .enable     ((id == wdata_id) & next_data_write & (data_gen_mode[0] == 0)),
               .data       (lfsr_write_data[id])
            );

            //Actual byte enable generator
            if (USE_BYTE_EN)
            begin : act_be_gen

               altera_emif_avl_tg_lfsr_wrapper # (
                  .DATA_WIDTH (MEM_BE_WIDTH)
               ) act_be_gen_inst (
                  .clk        (clk),
                  .reset_n    (~rst2b),
                  .enable     ((id == wdata_id) & next_data_write & (byte_en_gen_mode[0] == 0)),
                  .data       (lfsr_write_be[id])
               );

            end else begin
               assign lfsr_write_be[id] = {(MEM_BE_WIDTH){1'b1}};
            end

            //Expected data signal generation

            // Expected write data generator
            altera_emif_avl_tg_lfsr_wrapper # (
               .DATA_WIDTH (MEM_DATA_WIDTH),
               .SEED       (TG_LFSR_SEED)
            ) exp_data_gen_inst (
               .clk        (clk),
               .reset_n    (~rst2b),
               .enable     (next_read_data_en_prev[id] & (data_gen_mode[0] == 0)),
               .data       (lfsr_exp_write_data[id])
            );

            // Expected byte enable generator
            if (USE_BYTE_EN)
            begin : exp_be_gen
               altera_emif_avl_tg_lfsr_wrapper # (
                  .DATA_WIDTH (MEM_BE_WIDTH)
               ) exp_be_gen_inst (
                  .clk        (clk),
                  .reset_n    (~rst2c),
                  .enable     (next_read_data_en_prev[id] & (byte_en_gen_mode[0] == 0)),
                  .data       (lfsr_exp_write_be[id])
               );
            end else begin
               assign lfsr_exp_write_be[id] = {(MEM_BE_WIDTH){1'b1}};
            end
        end

         assign mem_write_data[id] = data_gen_mode[0] ? fixed_wdata[id] : (HBM_LFSR == 1) ? hbm_lfsr_wdata[id] : lfsr_write_data[id];
         assign mem_write_be[id]    = byte_en_gen_mode[0] ? fixed_wbe[id] : (HBM_LFSR == 1) ? hbm_lfsr_wbe[id] : lfsr_write_be[id];

         assign written_data[id] = data_gen_mode[0] ? fixed_exp_wdata[id] : (HBM_LFSR == 1) ? hbm_lfsr_exp_wdata[id] : lfsr_exp_write_data[id];
         assign written_be[id]   = byte_en_gen_mode[0] ?  fixed_exp_wbe[id] : (HBM_LFSR == 1) ? hbm_lfsr_exp_wbe[id] : lfsr_exp_write_be[id];
      end
   endgenerate

   wire [MEM_BE_WIDTH-1:0] ast_exp_data_byteenable_pre;
   wire ast_act_data_readdatavalid_norob;
   wire [MEM_DATA_WIDTH-1:0]      ast_act_data_readdata_norob;

   //translates the commands issued by the traffic_gen into AXI
   altera_hbm_tg_axi_axi_if # (
      .WORD_ADDRESS_DIVISIBLE_BY(WORD_ADDRESS_DIVISIBLE_BY),
      .BURST_COUNT_DIVISIBLE_BY(BURST_COUNT_DIVISIBLE_BY),
      .BURST_LEN(BURST_LEN),
      .WORD_ADDR_WIDTH              (MEM_ADDR_WIDTH),
      .NUMBER_OF_DATA_GENERATORS    (NUMBER_OF_DATA_GENERATORS),
      .NUMBER_OF_BYTE_EN_GENERATORS (NUMBER_OF_BYTE_EN_GENERATORS_LOCAL),
      .DATA_RATE_WIDTH_RATIO        (DATA_RATE_WIDTH_RATIO),
      .DATA_WIDTH                   (MEM_DATA_WIDTH),
      .BE_WIDTH                     (MEM_BE_WIDTH),
      .AMM_BURSTCOUNT_WIDTH         (AMM_BURSTCOUNT_WIDTH),
      .USE_BYTE_EN                  (USE_BYTE_EN),
      .PORT_AXI_AWID_WIDTH          (PORT_AXI_AWID_WIDTH),
		.PORT_AXI_AWADDR_WIDTH        (PORT_AXI_AWADDR_WIDTH),
		.PORT_AXI_AWLEN_WIDTH         (PORT_AXI_AWLEN_WIDTH),
		.PORT_AXI_AWSIZE_WIDTH        (PORT_AXI_AWSIZE_WIDTH),
		.PORT_AXI_AWBURST_WIDTH       (PORT_AXI_AWBURST_WIDTH),
		.PORT_AXI_AWPROT_WIDTH        (PORT_AXI_AWPROT_WIDTH),
		.PORT_AXI_AWQOS_WIDTH         (PORT_AXI_AWQOS_WIDTH),
		.PORT_AXI_AWUSER_AP_WIDTH     (PORT_AXI_AWUSER_AP_WIDTH),
		.PORT_AXI_WDATA_WIDTH         (PORT_AXI_WDATA_WIDTH),
		.PORT_AXI_WSTRB_WIDTH         (PORT_AXI_WSTRB_WIDTH),
		.PORT_AXI_BID_WIDTH           (PORT_AXI_BID_WIDTH),
		.PORT_AXI_BRESP_WIDTH         (PORT_AXI_BRESP_WIDTH),
		.PORT_AXI_ARID_WIDTH          (PORT_AXI_ARID_WIDTH),
		.PORT_AXI_ARADDR_WIDTH        (PORT_AXI_ARADDR_WIDTH),
		.PORT_AXI_ARLEN_WIDTH         (PORT_AXI_ARLEN_WIDTH),
		.PORT_AXI_ARSIZE_WIDTH        (PORT_AXI_ARSIZE_WIDTH),
		.PORT_AXI_ARBURST_WIDTH       (PORT_AXI_ARBURST_WIDTH),
		.PORT_AXI_ARPROT_WIDTH        (PORT_AXI_ARPROT_WIDTH),
		.PORT_AXI_ARQOS_WIDTH         (PORT_AXI_ARQOS_WIDTH),
		.PORT_AXI_ARUSER_AP_WIDTH     (PORT_AXI_ARUSER_AP_WIDTH),
		.PORT_AXI_RID_WIDTH           (PORT_AXI_RID_WIDTH),
		.PORT_AXI_RDATA_WIDTH         (PORT_AXI_RDATA_WIDTH),
    .DIAG_TG_GENERATE_RW_IDS      (DIAG_TG_GENERATE_RW_IDS),
    .DIAG_TEST_RANDOM_AXI_READY   (DIAG_TEST_RANDOM_AXI_READY),
    .SEQUENTIAL_RANDOM            (SEQUENTIAL_RANDOM),
    .STRESS_LFSR (STRESS_LFSR),
    .STATIC_RATIO_1 (STATIC_RATIO_1),
    .TG_USE_EFFICIENCY_PATTERN(TG_USE_EFFICIENCY_PATTERN),
    .ENABLE_DATA_CHECK(ENABLE_DATA_CHECK),
    .SEED(SEED),
    .ADDR_MASK_VALUE(ADDR_MASK_VALUE),
    .SUM_RD(SUM_RD),
    .SUM_WR(SUM_WR),
    .BURST_LEN_EXTEND_EN(BURST_LEN_EXTEND_EN) 
   ) tg_axi_if_inst (
    .clk                          (clk),
    .rst                          (rst2c),

    // traffic generator side
    .awrite_req                   (awrite_req),
    .write_req                    (write_req),
    .read_req                     (read_req),
    .write_addr                   (write_addr),
    .read_addr                    (read_addr),
    .read_id                      (read_id),
    .write_id                     (write_addr_id),
    .read_burst_cnt               (rd_burst_cnt),
    .write_burst_cnt              (wr_burst_cnt),
    .mem_write_data               (mem_write_data[wdata_id]),
    .mem_write_be                 (mem_write_be[wdata_id]),
    .controller_awready           (controller_awready),
    .controller_wready            (controller_wready),
    .controller_rready            (controller_rready),
    .next_wlast                   (next_wlast),
    .start                        (rw_gen_start),
    .initialization_phase         (initialization_phase),
    .init_stage                   (init_stage),
    .awid                         (awid),                               
    .awaddr                       (awaddr),                             
    .awqos                        (awqos),
    .awuser_ap                    (awuser_ap),
    .awlen                        (awlen),
    .awvalid                      (awvalid),                            
    .awready                      (awready),                            
    .wdata                        (wdata),                              
    .wstrb                        (wstrb),                              
    .wlast                        (wlast),                              
    .wvalid                       (wvalid),                             
    .wready                       (wready),                             
    .bid                          (bid),                                
    .bresp                        (bresp),                              
    .bvalid                       (bvalid),                             
    .bready                       (bready),                             
    .arid                         (arid),                               
    .araddr                       (araddr),                             
    .arqos                        (arqos),
    .aruser_ap                    (aruser_ap),
    .arlen                        (arlen),
    .arvalid                      (arvalid),                            
    .arready                      (arready),                            
    .rid                          (rid),                                
    .rdata                        (rdata),                              
    .rlast                        (rlast),                              
    .rvalid                       (rvalid),                             
    .rready                       (rready),                             

    //data for comparison
    .written_be                   (written_be[MAX_GENERATOR_SETS == 1 ? 0 : ast_act_data_rid_pl]),
    .written_data                 (written_data[MAX_GENERATOR_SETS == 1 ? 0 : ast_act_data_rid_pl]),

    // outputs
    .ast_exp_data_byteenable      (ast_exp_data_byteenable_pre),
    .ast_exp_data_writedata       (ast_exp_data_writedata),

    .ast_act_data_readdatavalid   (ast_act_data_readdatavalid_norob),
    .ast_act_data_readdata        (ast_act_data_readdata_norob),

    .read_addr_fifo_full          (compare_addr_gen_fifo_full),

    .addr_gen_mode_writes         (addr_gen_mode_writes_r),
    .addr_gen_mode_reads          (addr_gen_mode_reads_r)

   );
  
   assign ast_exp_data_byteenable = (USE_BYTE_EN == 0 || NUMBER_OF_BYTE_EN_GENERATORS == 0) ? {MEM_BE_WIDTH{1'b1}} : ast_exp_data_byteenable_pre;

   generate
   if (DIAG_TG_ROB_EN == 1)
   begin
      if (BURST_LEN > 1) begin
         altera_hbm_tg_axi_rob_multi_burst #(
            .ARID_WIDTH          (PORT_AXI_ARID_WIDTH),
            .DATA_WIDTH          (MEM_DATA_WIDTH),
            .BURST_LEN           (BURST_LEN)
         ) rob_inst (
            .clk               (clk),
            .reset_n           (~rst),
            .master_arready    (arready),
            .slave_arvalid     (arvalid),
            .slave_arid        (arid),
            .slave_rready      (rready),
            .master_rvalid     (rvalid),
            .master_rid        (rid),
            .master_rdata      (rdata),
            .master_rresp      (rresp),
            .master_rlast      (rlast),
            .slave_rvalid      (ast_act_data_readdatavalid),
            .slave_rid         (ast_act_data_rid),
            .slave_rdata       (ast_act_data_readdata),
            .slave_rresp       (),
            .slave_rlast       (),
            .master_rready     ()
         );
      end
      else begin 
         altera_hbm_tg_axi_rob_single_burst #(
            .ARID_WIDTH          (PORT_AXI_ARID_WIDTH),
            .DATA_WIDTH          (MEM_DATA_WIDTH)
         ) rob_inst (
            .clk               (clk),
            .reset_n           (~rst),
            .master_arready    (arready),
            .slave_arvalid     (arvalid),
            .slave_arid        (arid),
            .slave_rready      (rready),
            .master_rvalid     (rvalid),
            .master_rid        (rid),
            .master_rdata      (rdata),
            .master_rresp      (rresp),
            .master_rlast      (rlast),
            .slave_rvalid      (ast_act_data_readdatavalid),
            .slave_rid         (ast_act_data_rid),
            .slave_rdata       (ast_act_data_readdata),
            .slave_rresp       (),
            .slave_rlast       (),
            .master_rready     ()
         );
      end
   end else begin
        assign ast_act_data_rid = rid;
        assign ast_act_data_readdatavalid = ast_act_data_readdatavalid_norob;
        assign ast_act_data_readdata = ast_act_data_readdata_norob;
   end
   endgenerate

   altera_hbm_tg_axi_compare_addr_gen # (
      .ADDR_WIDTH                (MEM_ADDR_WIDTH),
      .ADDR_FIFO_DEPTH           (COMPARE_ADDR_FIFO_DEPTH),
      .PORT_AXI_RID_WIDTH        (PORT_AXI_RID_WIDTH),
      .MAX_ID                    (MAX_GENERATOR_SETS),
      .AMM_BURSTCOUNT_WIDTH      (AMM_BURSTCOUNT_WIDTH),
      .READ_RPT_COUNT_WIDTH      (RW_RPT_COUNT_WIDTH),
      .READ_COUNT_WIDTH          (RW_OPERATION_COUNT_WIDTH),
      .READ_LOOP_COUNT_WIDTH     (RW_LOOP_COUNT_WIDTH),
      .BURST_LEN_EXTEND_EN       (BURST_LEN_EXTEND_EN),
      .MAX_BURST_COUNT           (MAX_BURST_COUNT),
      .MIN_BURST_COUNT           (MIN_BURST_COUNT),
      .BURST_COUNT_DIVISIBLE_BY  (BURST_COUNT_DIVISIBLE_BY),
      .BURST_COUNT_MODE          (BURST_COUNT_MODE)
   ) compare_addr_gen_inst(
      .clk                       (clk),
      .rst                       (rst2d),
      .tg_restart                (tg_restart),

      //read counters needed by status checker
      .num_read_bursts           (rw_gen_read_cnt_r),
      .num_read_loops            (rw_gen_loop_cnt),
      .num_read_repeats          (rw_gen_read_rpt_cnt),
      .rdata_valid               (ast_act_data_readdatavalid),

      .read_addr                 (read_addr),
      .read_addr_valid           (arvalid & arready),
      .read_id_fifo_in           (read_id),
      .read_id_fifo_out          (ast_act_data_rid),

      .burst_length              (burstlength),
      .current_written_addr      (ast_exp_data_readaddr),
      .check_in_prog             (status_check_in_prog),
      .fifo_almost_full          (compare_addr_gen_fifo_full),
      .next_read_data_en         (next_read_data_en),
      .next_read_data_en_prev    (next_read_data_en_prev)
   );

   altera_hbm_tg_axi_config_error_module # (
      .WORD_ADDR_WIDTH                 (MEM_ADDR_WIDTH),
      .WORD_ADDRESS_DIVISIBLE_BY       (WORD_ADDRESS_DIVISIBLE_BY),
      .BURST_COUNT_DIVISIBLE_BY        (BURST_COUNT_DIVISIBLE_BY),
      .MEM_DATA_WIDTH                  (MEM_DATA_WIDTH),
      .MEM_BE_WIDTH                    (MEM_BE_WIDTH),
      .USE_BYTE_EN                     (USE_BYTE_EN),
      .NUMBER_OF_DATA_GENERATORS       (NUMBER_OF_DATA_GENERATORS),
      .NUMBER_OF_BYTE_EN_GENERATORS    (NUMBER_OF_BYTE_EN_GENERATORS_LOCAL),
      .DIAG_TG_DATA_PATTERN_LENGTH     (DIAG_TG_DATA_PATTERN_LENGTH),
      .DIAG_TG_BYTE_EN_PATTERN_LENGTH  (DIAG_TG_BYTE_EN_PATTERN_LENGTH),
      .DATA_RATE_WIDTH_RATIO           (DATA_RATE_WIDTH_RATIO),
      .RAND_SEQ_CNT_WIDTH              (RAND_SEQ_CNT_WIDTH),
      .AMM_BURSTCOUNT_WIDTH            (AMM_BURSTCOUNT_WIDTH),
      .RW_OPERATION_COUNT_WIDTH        (RW_OPERATION_COUNT_WIDTH),
      .RW_RPT_COUNT_WIDTH              (RW_RPT_COUNT_WIDTH),
      .SEQ_ADDR_INCR_WIDTH             (SEQ_ADDR_INCR_WIDTH)
   ) config_error_module_inst (
      .clk                             (clk),
      .reset                           (rst2a),
      .tg_restart                      (tg_restart),

      //config registers of interest
      .num_reads                       (rw_gen_read_cnt_r),
      .num_writes                      (rw_gen_write_cnt),
      .seq_addr_incr                   (addr_gen_seq_addr_incr),
      .burstlength                     (BURST_LEN_EXTEND_EN? wr_burst_cnt : burstlength),
      .addr_write                      (addr_gen_write_start_addr[MEM_ADDR_WIDTH-1:0]),
      .addr_read                       (addr_gen_read_start_addr[MEM_ADDR_WIDTH-1:0]),
      .addr_mode_write                 (addr_gen_mode_writes_r),
      .addr_mode_read                  (addr_gen_mode_reads_r),
      .rand_seq_addrs_write            (addr_gen_rseq_num_seq_addr_write),
      .rand_seq_addrs_read             (addr_gen_rseq_num_seq_addr_read),
      .num_read_repeats                (rw_gen_read_rpt_cnt),
      .num_write_repeats               (rw_gen_write_rpt_cnt),

      //error report out
      .config_error_report             (config_error_report_reg)
   );

  localparam COUNTER_WIDTH         = 32;
  wire reset_counters  ;
  wire eff_number_print;
  reg [COUNTER_WIDTH-1:0] write_cnt_effmon;
  reg [COUNTER_WIDTH-1:0] read_cnt_effmon;
  always @ (posedge clk) begin
    if (rst) begin
      read_cnt_effmon  <= 'd0;
      write_cnt_effmon <= 'd0;
    end
    else begin
      read_cnt_effmon  <= rw_gen_read_cnt ;
      write_cnt_effmon <= rw_gen_write_cnt;
    end
  end
  altera_effmon_tg #(
    .EFFICIENCY_FACTOR_NUM    (EFFICIENCY_FACTOR_NUM),
    .EFFICIENCY_FACTOR_DEN    (EFFICIENCY_FACTOR_DEN),
    .COUNTER_WIDTH            (COUNTER_WIDTH        ),
    .BURST_LEN                (BURST_LEN            ),
      .SUM_RD              (SUM_RD               ),
    .SUM_WR                (SUM_WR               ),
    .C2P_CLK_RATIO         (C2P_CLK_RATIO        ),
    .PORT_AXI_ARID_WIDTH   (PORT_AXI_ARID_WIDTH  ),
    .PORT_AXI_RID_WIDTH    (PORT_AXI_RID_WIDTH   ),
    .DIAG_EFFICIENCY_MONITOR (DIAG_EFFICIENCY_MONITOR),
    .DIAG_DEBUG_ISSPS        (DIAG_DEBUG_ISSPS)
  ) effmon_inst (
    .wmc_clk_in      (clk ),
    .wmcrst_n_in     (rst),
    .reset_counters  (!initialization_phase),
    .write_cnt_effmon(write_cnt_effmon     ),
    .read_cnt_effmon (read_cnt_effmon      ),
    .awvalid         (awvalid ),
    .awready         (awready ),
    .wlast           (wlast   ),
    .wvalid          (wvalid  ),
    .wready          (wready  ),
    .bvalid          (bvalid  ),
    .bready          (bready  ),
    .arvalid         (arvalid ),
    .arready         (arready ),
    .arid            (arid    ),
    .rid             (rid     ),
    .rlast           (rlast   ),
    .rvalid          (rvalid  ),
    .rready          (rready  )
  );
endmodule

module simple_dp_ram #(
  parameter DATA_WIDTH       = 8,
  parameter W_ADDR_WIDTH     = 8,
  parameter R_ADDR_WIDTH     = 8
  )(
  output reg [DATA_WIDTH-1:0] q,
  input [DATA_WIDTH-1:0] d,
  input [W_ADDR_WIDTH-1:0] write_address,
  input [R_ADDR_WIDTH-1:0] read_address,
  input we, clk
);
  timeunit 1ns;
  timeprecision 1ps;

  reg [DATA_WIDTH-1:0] mem [0:2**R_ADDR_WIDTH-1];

  always @ (posedge clk) begin
  if (we)
    mem[write_address] <= d;
    q <= mem[read_address];
  end
endmodule
