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
// This package contains common typedefs and function definitions for the
// example driver.
//////////////////////////////////////////////////////////////////////////////

package tg_axi_defs;

   // Address generators definition
   typedef enum logic [1:0]  {
      SEQ,
      RAND,
      RAND_SEQ,
      TEMPLATE_ADDR_GEN
   } addr_gen_select_t;


   // Returns the maximum of two numbers
   function automatic integer max;
      input integer a;
      input integer b;
      begin
         max = (a > b) ? a : b;
      end
   endfunction


   // Calculate the log_2 of the input value
   function automatic integer log2;
      input integer value;
      begin
         value = value >> 1;
         for (log2 = 0; value > 0; log2 = log2 + 1)
            value = value >> 1;
      end
   endfunction


   // Calculate the ceiling of log_2 of the input value
   function automatic integer ceil_log2;
      input integer value;
      begin
         value = value - 1;
         for (ceil_log2 = 0; value > 0; ceil_log2 = ceil_log2 + 1)
            value = value >> 1;
      end
   endfunction

   // Generate a pattern generator seed based on the pin index.
   //The reason for this is to make all the generators different.  Also, a larger pattern length (32)
   function automatic integer gen_seed;
      input integer pin_index;
      begin
         gen_seed = ((pin_index+1) << 24) | ((pin_index+1) << 16) | ((pin_index+1) << 8) | (pin_index+1);
      end
   endfunction

   localparam TG_PATTERN_PRBS = 2'b00;
   localparam TG_PATTERN_FIXED = 2'b01;
   localparam TG_PATTERN_PRBS_INVERTED = 2'b10;
   localparam TG_PATTERN_FIXED_INVERTED = 2'b11;

   localparam TG_ADDR_RAND = 0;
   localparam TG_ADDR_SEQ = 1;
   localparam TG_ADDR_RAND_SEQ = 2;
   localparam TG_ADDR_ONE_HOT = 3;

   localparam TG_MASK_DISABLED = 2'b00;
   localparam TG_MASK_FIXED = 2'b01;
   localparam TG_MASK_FULL_CYCLING = 2'b10;
   localparam TG_MASK_PARTIAL_CYCLING = 2'b11;

   // Start
   localparam TG_START = 10'h0;
   // Loop count
   localparam TG_LOOP_COUNT = 10'h1;
   // Write count
   localparam TG_WRITE_COUNT = 10'h2;
   // Read count
   localparam TG_READ_COUNT = 10'h3;
   // Write repeat count
   localparam TG_WRITE_REPEAT_COUNT = 10'h4;
   // Read repeat count
   localparam TG_READ_REPEAT_COUNT = 10'h5;
   // Clear first fail
   localparam TG_CLEAR_FIRST_FAIL = 10'h7;
   // Test byte enable
   localparam TG_TEST_BYTEEN = 10'h8;
   // Restart default traffic
   localparam TG_RESTART_DEFAULT_TRAFFIC = 10'h9;
   // Data generator mode
   localparam TG_DATA_MODE = 10'hA;
   // Byte enable generator mode
   localparam TG_BYTEEN_MODE = 10'hB;
   // Start efficiency monitor
   localparam TG_START_EFFMON = 10'hC;
   // Stop efficiency monitor
   localparam TG_STOP_EFFMON = 10'hD;
   // Sequential start address (Write) (Lower 32 bits)
   localparam TG_SEQ_START_ADDR_WR_L = 10'h30;
   // Sequential start address (Write) (Upper 32 bits)
   localparam TG_SEQ_START_ADDR_WR_H = 10'h31;
   // Address mode
   localparam TG_ADDR_MODE_WR = 10'h32;
   // Random sequential number of addresses (Write)
   localparam TG_RAND_SEQ_ADDRS_WR = 10'h33;
   // Return to start address
   localparam TG_RETURN_TO_START_ADDR = 10'h34;
   // Rank mask enable
   localparam TG_SID_MASK_EN = 10'h35;
   // Bank mask enable
   localparam TG_BANK_MASK_EN = 10'h36;
   // Row mask enable
   localparam TG_ROW_MASK_EN = 10'h37;
   // Bank group mask enable
   localparam TG_BG_MASK_EN = 10'h38;
   // Rank mask
   localparam TG_SID_MASK = 10'h39;
   // Bank mask
   localparam TG_BANK_MASK = 10'h3A;
   // Row mask
   localparam TG_ROW_MASK = 10'h3B;
   // Bank group mask
   localparam TG_BG_MASK = 10'h3C;
   // Sequential address increment
   localparam TG_SEQ_ADDR_INCR = 10'h3D;
   // Sequential start address (Read) (Lower 32 bits)
   localparam TG_SEQ_START_ADDR_RD_L = 10'h3E;
   // Sequential start address (Read) (Upper 32 bits)
   localparam TG_SEQ_START_ADDR_RD_H = 10'h3F;
   // Address mode (Read)
   localparam TG_ADDR_MODE_RD = 10'h40;
   // Random sequential number of addresses (Read)
   localparam TG_RAND_SEQ_ADDRS_RD = 10'h41;
   // Pass
   localparam TG_PASS = 10'h70;
   // Fail
   localparam TG_FAIL = 10'h71;
   // Failure count (lower 32 bits)
   localparam TG_FAIL_COUNT_L = 10'h72;
   // Failure count (upper 32 bits)
   localparam TG_FAIL_COUNT_H = 10'h73;
   // First failure address (lower 32 bits)
   localparam TG_FIRST_FAIL_ADDR_L = 10'h74;
   // First failure address (upper 32 bits)
   localparam TG_FIRST_FAIL_ADDR_H = 10'h75;
   // First failure is read failure
   localparam TG_FIRST_FAIL_IS_READ = 10'h76;
   // First failure is write failure
   localparam TG_FIRST_FAIL_IS_WRITE = 10'h77;
   // Test complete status register
   localparam TG_TEST_COMPLETE = 10'h78;
   // Traffic generator version
   localparam TG_VERSION = 10'h80;
   // Number of data generators
   localparam TG_NUM_DATA_GEN = 10'h81;
   // Number of byte enable generators
   localparam TG_NUM_BYTEEN_GEN = 10'h82;
   // Rank address width
   localparam TG_SID_ADDR_WIDTH = 10'h83;
   // Bank address width
   localparam TG_BANK_ADDR_WIDTH = 10'h84;
   // Row address width
   localparam TG_ROW_ADDR_WIDTH = 10'h85;
   // Bank group width
   localparam TG_BANK_GROUP_WIDTH = 10'h86;
   // Width of read data and PNF signals
   localparam TG_RDATA_WIDTH = 10'h87;
   // Length of data pattern
   localparam TG_DATA_PATTERN_LENGTH = 10'h88;
   // Length of byte enable pattern
   localparam TG_BYTEEN_PATTERN_LENGTH = 10'h89;
   // Minimum address incremement (address divisibility requirement)
   localparam TG_MIN_ADDR_INCR = 10'h8A;
   // Error reporting register for illegal configurations of the traffic generator
   localparam TG_ERROR_REPORT = 10'h8B;
   // Persistent PNF per bit (144*8 / 32 addresses needed)
   localparam TG_PNF = 10'h90;
   // First failure expected data
   localparam TG_FAIL_EXPECTED_DATA = 10'hB5;
   // First failure read data
   localparam TG_FAIL_READ_DATA = 10'hDA;
   // Data generator seed
   localparam TG_DATA_SEED = 10'h100;
   // Byte enable generator seed
   localparam TG_BYTEEN_SEED = 10'h1A0;
   // More read operations will be scheduled than write operations. Data mismatches may occur.
   localparam ERR_MORE_READS_THAN_WRITES = 32'h0;
   // The Avalon burst length exceeds the sequential address increment.  Data mismatches may occur.
   localparam ERR_BURSTLENGTH_GT_SEQ_ADDR_INCR = 32'h1;
   // The sequential address increment is smaller than the minimum required.  Data mismatches may occur.
   localparam ERR_ADDR_DIVISIBLE_BY_GT_SEQ_ADDR_INCR = 32'h2;
   // The sequential address increment is not divisible by the necessary step.  Data mismatches may occur.
   localparam ERR_SEQ_ADDR_INCR_NOT_DIVISIBLE = 32'h3;
   // The read and write start address during sequential address generation are different.  Data mismatches may occur.
   localparam ERR_READ_AND_WRITE_START_ADDRS_DIFFER = 32'h4;
   // Read and write settings for address generation mode are different.  Data mismatches may occur.
   localparam ERR_ADDR_MODES_DIFFERENT = 32'h5;
   // Read and write settings for number of random sequential address operations are unequal.  Data mismatches may occur.
   localparam ERR_NUMBER_OF_RAND_SEQ_ADDRS_DIFFERENT = 32'h6;
   // The number of read or write repeats is set to 0.
   localparam ERR_REPEATS_SET_TO_ZERO = 32'h7;

   // Reset
   localparam EFFMON_RESET = 10'h0;
   // Snapshot
   localparam EFFMON_SNAPSHOT = 10'h1;
   // Version
   localparam EFFMON_VERSION = 10'h2;
   // Channel and pseudochannel IDs
   localparam EFFMON_CHANNEL_AND_PC = 10'h3;
   // Total count
   localparam EFFMON_TOTAL_COUNT = 10'h6;
   // Total active count
   localparam EFFMON_TOTAL_ACTIVE_COUNT = 10'h7;
   // AWVALID count
   localparam EFFMON_AWVALID_COUNT = 10'h8;
   // AWREADY count
   localparam EFFMON_AWREADY_COUNT = 10'h9;
   // AWVALID and AWREADY count
   localparam EFFMON_AWVALID_AND_READY_COUNT = 10'hA;
   // WVALID count
   localparam EFFMON_WVALID_COUNT = 10'hB;
   // WREADY count
   localparam EFFMON_WREADY_COUNT = 10'hC;
   // WVALID and WREADY count
   localparam EFFMON_WVALID_AND_READY_COUNT = 10'hD;
   // ARVALID count
   localparam EFFMON_ARVALID_COUNT = 10'hE;
   // ARREADY count
   localparam EFFMON_ARREADY_COUNT = 10'hF;
   // ARVALID and ARREADY count
   localparam EFFMON_ARVALID_AND_READY_COUNT = 10'h10;
   // RVALID count
   localparam EFFMON_RVALID_COUNT = 10'h11;
   // RREADY count
   localparam EFFMON_RREADY_COUNT = 10'h12;
   // RVALID and RREADY count
   localparam EFFMON_RVALID_AND_READY_COUNT = 10'h13;
   // Minimum Latency
   localparam EFFMON_MIN_LATENCY = 10'h14;
   // Maximum Latency
   localparam EFFMON_MAX_LATENCY = 10'h15;
   // Total Latency (lower 32 bits)
   localparam EFFMON_TOTAL_LATENCY_L = 10'h16;
   // Total Latency (upper 32 bits)
   localparam EFFMON_TOTAL_LATENCY_H = 10'h17;

endpackage

