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


///////////////////////////////////////////////////////////////////////////////
// This module is used for simulation memory preloading to translate
// EMIF top-level addresses to Memory-specific addresses
//
///////////////////////////////////////////////////////////////////////////////

module altera_emif_arch_nd_emif2mem #(
   parameter PROTOCOL_ENUM                           = "",
   parameter PHY_CONFIG_ENUM                         = "",
   parameter DIAG_USE_ABSTRACT_PHY                   = 0,
   parameter DIAG_SIM_MEMORY_PRELOAD_EMIF_FILE       = "",
   parameter DIAG_SIM_MEMORY_PRELOAD_ECC_FILE        = "",
   parameter DIAG_SIM_MEMORY_PRELOAD_MEM_FILE        = "",
   parameter DIAG_SIM_MEMORY_PRELOAD_ABPHY_FILE      = "",

   parameter HMC_CFG_ADDR_ORDER                      = "",
   parameter HMC_CFG_CS_ADDR_WIDTH                   = "",
   parameter HMC_CFG_ROW_ADDR_WIDTH                  = "",
   parameter HMC_CFG_CTRL_ENABLE_ECC                 = "",

   parameter CTRL_AMM_ADDRESS_WIDTH                  = 0,
   parameter CTRL_AMM_DATA_WIDTH                     = 0,
   parameter CTRL_AMM_BYTEEN_WIDTH                   = 0,

   parameter MEM_BURST_LENGTH                        = 0,
   parameter MEM_DATA_MASK_EN                        = 0,
   parameter MEM_CS_N_WIDTH                          = 0,
   parameter MEM_ROW_ADDR_WIDTH                      = 0,
   parameter MEM_COL_ADDR_WIDTH                      = 0,
   parameter MEM_DQ_WIDTH                            = 0,
   parameter PORT_MEM_C_WIDTH                        = 0,
   parameter PORT_MEM_BG_WIDTH                       = 0,
   parameter PORT_MEM_BA_WIDTH                       = 0
) (
   input  logic                                               emif_usr_clk,
   input  logic                                               local_cal_success,
   input  logic                                               local_cal_fail
);
   timeunit 1ns;
   timeprecision 1ps;

   function automatic integer ceil_log2;
      input integer value;
      begin
         value = value - 1;
         for (ceil_log2 = 0; value > 0; ceil_log2 = ceil_log2 + 1)
            value = value >> 1;
      end
   endfunction

   localparam NUM_ECC_BITS                           = 8;
   localparam OUTPUT_FILE                            = (HMC_CFG_CTRL_ENABLE_ECC == "enable") ? DIAG_SIM_MEMORY_PRELOAD_ECC_FILE : (
                                                       (DIAG_USE_ABSTRACT_PHY)               ? DIAG_SIM_MEMORY_PRELOAD_ABPHY_FILE : (
                                                                                               DIAG_SIM_MEMORY_PRELOAD_MEM_FILE ));
   localparam INT_MEM_DQ_WIDTH                       = (HMC_CFG_CTRL_ENABLE_ECC == "enable") ? MEM_DQ_WIDTH - NUM_ECC_BITS : MEM_DQ_WIDTH;
   localparam INT_MEM_CS_N_WIDTH                     = ceil_log2(MEM_CS_N_WIDTH);
   localparam NUM_DQ_BURSTS                          = CTRL_AMM_DATA_WIDTH / INT_MEM_DQ_WIDTH;
   localparam ADDRESS_WIDTH                          = CTRL_AMM_ADDRESS_WIDTH + ceil_log2(NUM_DQ_BURSTS);
   localparam BYTEEN_WIDTH                           = INT_MEM_DQ_WIDTH / 8;
   localparam MEM_COL_ADDR_NUM_BURST_BITS            = ceil_log2(MEM_BURST_LENGTH);

   // synthesis translate_off

   logic                                                      cs_exists;
   logic                                                      c_exists;
   logic                                                      local_cal_complete;
   logic                                                      emif2mem_complete;

   assign local_cal_complete     = local_cal_success | local_cal_fail;

   // Get DDR4 memory address when Hard Controller is used
   task automatic get_hmc_ddr4_addr (
         input  [ADDRESS_WIDTH-1:0]          mem_address,
         output [INT_MEM_CS_N_WIDTH-1:0]     cs,
         output [PORT_MEM_C_WIDTH-1:0]       c,
         output [PORT_MEM_BG_WIDTH-1:0]      bg,
         output [PORT_MEM_BA_WIDTH-1:0]      ba,
         output [MEM_ROW_ADDR_WIDTH-1:0]     row,
         output [MEM_COL_ADDR_WIDTH-1:0]     col
      );
      logic   [MEM_COL_ADDR_WIDTH - MEM_COL_ADDR_NUM_BURST_BITS -1:0]   col_upper;
      logic   [MEM_COL_ADDR_NUM_BURST_BITS -1:0]                        col_burst;

      cs = '0;
      c = '0;
      case (HMC_CFG_ADDR_ORDER)
         "addr_order_cs_ba_row_col" : begin
            if (cs_exists && c_exists) begin
               {cs, bg, ba, c, row, col_upper, col_burst} = mem_address;
            end else if (cs_exists) begin
               {cs, bg, ba, row, col_upper, col_burst} = mem_address;
            end else if (c_exists) begin
               {bg, ba, c, row, col_upper, col_burst} = mem_address;
            end else begin
               {bg, ba, row, col_upper, col_burst} = mem_address;
            end
         end
         "addr_order_cs_row_ba_col" : begin
            if (cs_exists && c_exists) begin
               {cs, c, row, ba, col_upper, bg, col_burst} = mem_address;
            end else if (cs_exists) begin
               {cs, row, ba, col_upper, bg, col_burst} = mem_address;
            end else if (c_exists) begin
               {c, row, ba, col_upper, bg, col_burst} = mem_address;
            end else begin
               {row, ba, col_upper, bg, col_burst} = mem_address;
            end
         end
         "addr_order_row_cs_ba_col" : begin
            if (cs_exists && c_exists) begin
               {c, row, cs, ba, col_upper, bg, col_burst} = mem_address;
            end else if (cs_exists) begin
               {row, cs, ba, col_upper, bg, col_burst} = mem_address;
            end else if (c_exists) begin
               {c, row, ba, col_upper, bg, col_burst} = mem_address;
            end else begin
               {row, ba, col_upper, bg, col_burst} = mem_address;
            end
         end
         default : begin
            $fatal(1, "HMC_CFG_ADDR_ORDER - Incorrect parameter value!");
         end
      endcase
      col = {col_upper, col_burst};
   endtask

   // Translate EMIF top-level address to Memory address
   task automatic emif_to_mem ();

      integer                                               fd_in;
      integer                                               fd_out;
      string                                                line;
      integer                                               burst;

      logic   [CTRL_AMM_ADDRESS_WIDTH-1:0]                  usr_address;
      logic   [CTRL_AMM_DATA_WIDTH-1:0]                     usr_data;
      logic   [CTRL_AMM_BYTEEN_WIDTH-1:0]                   usr_byteen;
      
      logic   [ADDRESS_WIDTH - 1:0]                         mem_address;
      logic   [INT_MEM_CS_N_WIDTH-1:0]                      cs;
      logic   [PORT_MEM_C_WIDTH-1:0]                        c;
      logic   [PORT_MEM_BG_WIDTH-1:0]                       bg;
      logic   [PORT_MEM_BA_WIDTH-1:0]                       ba;
      logic   [MEM_ROW_ADDR_WIDTH-1:0]                      row;
      logic   [MEM_COL_ADDR_WIDTH-1:0]                      col;
      logic   [INT_MEM_DQ_WIDTH-1:0]                        data;
      logic   [BYTEEN_WIDTH-1:0]                            byteen;

      fd_in = $fopen(DIAG_SIM_MEMORY_PRELOAD_EMIF_FILE, "r");
      fd_out = $fopen(OUTPUT_FILE, "w");
      if (fd_in != 0 && fd_out != 0) begin
         while ($fgets(line, fd_in)) begin
            // Address & Data are as seen at top-level of EMIF IP
            if ($sscanf(line, "EMIF: ADDRESS=%h DATA=%h BYTEENABLE=%h", usr_address, usr_data, usr_byteen) == 3) begin

               if (PHY_CONFIG_ENUM == "CONFIG_PHY_AND_HARD_CTRL") begin

                  mem_address = {usr_address, {(ADDRESS_WIDTH - CTRL_AMM_ADDRESS_WIDTH){1'b0}}};

                  for (burst = 0; burst < NUM_DQ_BURSTS; burst = burst + 1) begin
                     data = usr_data[burst*INT_MEM_DQ_WIDTH +: INT_MEM_DQ_WIDTH];
                     byteen = (MEM_DATA_MASK_EN) ? usr_byteen[burst*BYTEEN_WIDTH +: BYTEEN_WIDTH] : '1;

                     if (PROTOCOL_ENUM == "PROTOCOL_DDR4") begin
                        get_hmc_ddr4_addr(.mem_address(mem_address + burst), .cs(cs), .c(c), .bg(bg), .ba(ba), .row(row), .col(col));
                     end

                     if (HMC_CFG_CTRL_ENABLE_ECC == "enable") begin
                        $fwrite(fd_out, "ECC: CS=%h C=%h BG=%h BA=%h ROW=%h COL=%h ADDRESS=%h DATA=%h BYTEENABLE=%h\n", cs, c, bg, ba, row, col, mem_address + burst, data, byteen);
                     end else if (DIAG_USE_ABSTRACT_PHY) begin
                        $fwrite(fd_out, "ABPHY: CS=%h C=%h BG=%h BA=%h ROW=%h COL=%h DATA=%h BYTEENABLE=%h\n", cs, c, bg, ba, row, col, data, byteen);
                     end else begin
                        $fwrite(fd_out, "DDRX: CS=%h C=%h BG=%h BA=%h ROW=%h COL=%h DATA=%h BYTEENABLE=%h\n", cs, c, bg, ba, row, col, data, byteen);
                     end
                  end

               end 

            end else begin
               $error(1, "Error: Missing information in file %s at line: %s", DIAG_SIM_MEMORY_PRELOAD_EMIF_FILE, line);
            end
         end
      end else begin
         if (fd_in == 0) begin
            $error(1, "Error: Unable to open file %s for reading", DIAG_SIM_MEMORY_PRELOAD_EMIF_FILE);
         end
         if (fd_out == 0) begin
            $error(1, "Error: Unable to open file %s for writing", OUTPUT_FILE);
         end
      end
      $fflush(fd_out);
      $fclose(fd_in);
      $fclose(fd_out);

   endtask

   initial begin

      integer fd_out;
      integer cs_addr_width;
      integer c_plus_row_addr_width;
      integer c_addr_width;

      cs_exists = '0;
      c_exists = '0;
      emif2mem_complete = '0;

      fd_out = $fopen(OUTPUT_FILE, "w");
      $fclose(fd_out);

      if (PROTOCOL_ENUM == "PROTOCOL_DDR4") begin
         // Check if cs_n is used
         if ($sscanf(HMC_CFG_CS_ADDR_WIDTH, "cs_width_%d", cs_addr_width) != 1)
            $fatal(1, "HMC_CFG_CS_ADDR_WIDTH - Incorrect parameter value!");
         if (cs_addr_width != 0)
            cs_exists = '1;

         // Check if chip_id is used
         if ($sscanf(HMC_CFG_ROW_ADDR_WIDTH, "row_width_%d", c_plus_row_addr_width) != 1)
            $fatal(1, "HMC_CFG_ROW_ADDR_WIDTH - Incorrect parameter value!");
         c_addr_width = c_plus_row_addr_width - MEM_ROW_ADDR_WIDTH;
         if (c_addr_width != 0)
            c_exists = '1;
      end

   end

   always @ (posedge emif_usr_clk) begin
      // Preload memory after calibration completes
      if (local_cal_complete && !emif2mem_complete) begin
         emif_to_mem();
         emif2mem_complete = '1;
      end
   end

   // synthesis translate_on
endmodule
