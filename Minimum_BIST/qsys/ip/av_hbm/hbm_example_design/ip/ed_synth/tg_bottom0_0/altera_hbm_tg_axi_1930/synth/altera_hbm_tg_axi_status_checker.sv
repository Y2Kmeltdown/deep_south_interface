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


//////////////////////////////////////////////////////////////////////////////
// The status checker module uses another copy of the data generators to compare
// written data with the returned read data.  If the write and read data do not
// match, the corresponding bits of pnf_per_bit are deasserted.
//////////////////////////////////////////////////////////////////////////////

module altera_hbm_tg_axi_status_checker # (

   parameter DATA_WIDTH              = "",
   parameter ID_WIDTH                = "",
   parameter BE_WIDTH                = "",
   parameter ADDR_WIDTH              = "",
   parameter OP_COUNT_WIDTH          = "",
   parameter TEST_DURATION           = "",
   parameter INFI_TG_ERR_TEST        = 0,
   parameter TG_USE_EFFICIENCY_PATTERN = "",
   parameter ENABLE_DATA_CHECK       = ""
) (
   // Clock and reset
   input                          clk,
   input                          rst,
   // Control signals
   input                          enable,
   // Signals the traffic gen is starting a new run
   input                          tg_restart,

   // Actual data for comparison
   input                          ast_act_data_readdatavalid,
   input [DATA_WIDTH-1:0]         ast_act_data_readdata,
   input [ID_WIDTH-1:0]           ast_act_data_rid,
   output [ID_WIDTH-1:0]          ast_act_data_rid_pl,

   //Expected data for comparison
   input [BE_WIDTH-1:0]           ast_exp_data_byteenable,
   input [DATA_WIDTH-1:0]         ast_exp_data_writedata,
   input [ADDR_WIDTH-1:0]         ast_exp_data_readaddr,
   input [DATA_WIDTH-1:0]         ref_data,

   // Read compare status
   input                                clear_first_fail,
   output logic [DATA_WIDTH-1:0]        pnf_per_bit_persist,
   output                               fail,
   output logic                         pass,
   output logic [ADDR_WIDTH-1:0]        first_fail_addr,
   output logic [OP_COUNT_WIDTH-1:0]    failure_count,
   output logic [DATA_WIDTH-1:0]        first_fail_expected_data,
   output logic [DATA_WIDTH-1:0]        first_fail_read_data,
   output logic                         first_fail_read,        /* synthesis dont_merge */
   output logic                         first_fail_write,       /* synthesis dont_merge */

   input                          all_tests_issued,
   input                          byteenable_stage,
   input                          reads_in_prog,
   output                         timeout
);
   timeunit 1ns;
   timeprecision 1ps;

   import tg_axi_defs::*;

   // Byte size derived from dividing data width by byte enable width
   // Round up so that compile fails if DATA_WIDTH is not a multiple of BE_WIDTH
   localparam BYTE_SIZE = (DATA_WIDTH + BE_WIDTH - 1) / BE_WIDTH;

   // the width of the local data counter
   localparam DATACOUNTER_WIDTH = 8;

   logic rst1,rst2; /* synthesis dont_merge */
   always_ff @(posedge clk)
   begin
      rst1   <= rst;
      rst2   <= rst1;
   end

   // Write data for comparison
   logic [DATA_WIDTH-1:0]        written_data;
   logic [DATA_WIDTH-1:0]        written_data_lfsr_out;
   logic [BE_WIDTH-1:0]          written_be_lfsr_out;
   logic [DATA_WIDTH-1:0]        written_data_r;

   generate
   	if(TG_USE_EFFICIENCY_PATTERN) begin
  		assign written_data_r = ref_data;
   	end
   endgenerate

   logic [DATA_WIDTH-1:0]        written_data_r2;
   logic [DATA_WIDTH-1:0]        written_data_r3;
   logic [DATA_WIDTH-1:0]        written_data_r4;
   logic [DATA_WIDTH-1:0]        written_be_full;
   logic [DATA_WIDTH-1:0]        written_be_full_r;
   logic [DATA_WIDTH-1:0]        written_be_full_r2;
   logic [DATA_WIDTH-1:0]        written_be_full_r3;
   logic [DATA_WIDTH-1:0]        written_be_full_r4;

   // Read/write data registers
   logic                         rdata_valid_r;
   logic                         rdata_valid_r2;
   logic                         rdata_valid_r3;
   logic                         rdata_valid_r4;
   logic                         rdata_valid_r5;
   logic                         rdata_valid_r6;
   logic [DATA_WIDTH-1:0]        rdata_r;
   logic [DATA_WIDTH-1:0]        rdata_r2;
   logic [DATA_WIDTH-1:0]        rdata_r3;
   logic [DATA_WIDTH-1:0]        rdata_r4;
   logic [DATA_WIDTH-1:0]        rdata_r5;
   logic [DATA_WIDTH-1:0]        rdata_r6;
   logic [ID_WIDTH-1:0]          rid_r;
   logic [ID_WIDTH-1:0]          rid_r2;
   logic [ID_WIDTH-1:0]          rid_r3;
   logic [ID_WIDTH-1:0]          rid_r4;
   logic [ID_WIDTH-1:0]          rid_r5;

   logic [ADDR_WIDTH-1:0] read_addr_r;
   logic [ADDR_WIDTH-1:0] read_addr_r2;
   logic [ADDR_WIDTH-1:0] read_addr_r3;

   logic [DATA_WIDTH-1:0] pnf_per_bit; /* synthesis dont_merge syn_preserve = 1 */
   logic [DATA_WIDTH-1:0] pnf_per_bit_persist_r;
   logic                  pnf_per_bit_persist_status;
   logic                  pnf_bit_failure_det;
   logic [BE_WIDTH-1:0]   pnf_bit_failure_be_mismatch;
   logic                  failure_count_inc_en;

   // Errors related
   logic [DATA_WIDTH-1:0]        pnf_per_bit_r;
   logic [DATA_WIDTH-1:0]        pnf_per_bit_r2;
   logic                         pnf_r2_has_failure;
   logic                         pnf_is_active;
   logic                         pnf_is_active_r;
   logic                         pnf_is_active_r2;
   logic [31:0]                  ttl_fail_pnf;
   logic [31:0]                  ttl_pnf;

   logic                         first_failure;
   logic                         captured_first_fail;

   logic [DATA_WIDTH-1:0]        first_fail_expected_data_prev;
   logic [DATA_WIDTH-1:0]        first_fail_expected_data_next;
   logic [DATA_WIDTH-1:0]        first_fail_written_be;
   logic [ID_WIDTH-1:0]          first_fail_actual_rid;
   logic [DATA_WIDTH-1:0]        first_fail_actual_data;
   logic [DATA_WIDTH-1:0]        first_fail_actual_data_prev;
   logic [DATA_WIDTH-1:0]        first_fail_actual_data_next;
   logic                         first_fail_actual_data_valid_prev;
   logic                         first_fail_actual_data_valid_next;
   logic [DATA_WIDTH-1:0]        first_fail_pnf;
   logic [DATA_WIDTH-1:0]        last_rdata;

   logic [31:0]           timeout_count;

   logic                         first_fail_read_p1;    /* synthesis dont_merge */
   logic                         first_fail_write_p1;   /* synthesis dont_merge */

   // Should errors be forced?
   logic                         force_error;
   assign force_error = 1'b0;

   logic [DATACOUNTER_WIDTH-1:0] data_counter;
   logic                       rdata_valid;
   logic [DATA_WIDTH-1:0]      rdata;
   logic [ID_WIDTH-1:0]        rid;
   logic [BE_WIDTH-1:0]        written_be;
   logic [BE_WIDTH-1:0]        written_be_r;
   logic [BE_WIDTH-1:0]        written_be_adv;
   logic [ADDR_WIDTH-1:0]      read_addr;
   generate
   	if(!TG_USE_EFFICIENCY_PATTERN) begin
		assign written_data         = (force_error && (data_counter > 10)) ? {ast_exp_data_writedata[DATA_WIDTH-1:1], ~ast_exp_data_writedata[0]} : ast_exp_data_writedata;
   	end
   endgenerate
   assign written_be_adv       = ast_exp_data_byteenable;
   assign read_addr            = ast_exp_data_readaddr;
   assign rdata_valid          = ast_act_data_readdatavalid;
   assign rdata                = ast_act_data_readdata;
   assign rid                  = ast_act_data_rid;
   assign ast_act_data_rid_pl  = rid_r;

    always_ff @(posedge clk) begin
      if (rst2) begin
        written_be   <= {(BE_WIDTH){1'b0}};
        written_be_r <= {(BE_WIDTH){1'b0}};
      end
      else begin
        written_be   <= written_be_adv;
        written_be_r <= written_be;
      end
    end

   // The data is used as a small counter to count data coming back. It is
   // used by the force_error mode to introduce errors.
   always_ff @(posedge clk)
   begin
      if (rst2)
         data_counter <= '0;
      else
         if (rdata_valid_r2)
            data_counter <= data_counter + 1'b1;
   end

   reg [31:0]             infinite_timeout_cnt;
   localparam             INFINITE_LOOP_DIAG_NUM = 32'h0000FFFF;

   always @(posedge clk)
   begin
     if (rst2) begin
       infinite_timeout_cnt <= 32'b0;
     end else begin
       if (enable && rdata_valid && INFI_TG_ERR_TEST)
         infinite_timeout_cnt <=  infinite_timeout_cnt + 1'b1;
       end
   end

   // Per bit comparison
   always_ff @(posedge clk)
   begin
      if (rst2) begin
         pnf_per_bit         <= {DATA_WIDTH{1'b1}};
         pnf_per_bit_r       <= {DATA_WIDTH{1'b1}};
         pnf_per_bit_r2      <= {DATA_WIDTH{1'b1}};
         pnf_is_active       <= 1'b0;
         pnf_is_active_r     <= 1'b0;
         pnf_is_active_r2    <= 1'b0;
         pnf_r2_has_failure  <= 1'b0;

      end else begin
         if (tg_restart) begin
            pnf_per_bit         <= {DATA_WIDTH{1'b1}};
            pnf_per_bit_r       <= {DATA_WIDTH{1'b1}};
            pnf_per_bit_r2      <= {DATA_WIDTH{1'b1}};
            pnf_is_active       <= 1'b0;
            pnf_is_active_r     <= 1'b0;
            pnf_is_active_r2    <= 1'b0;
            pnf_r2_has_failure  <= 1'b0;

         end else begin
            for (int byte_num = 0; byte_num < BE_WIDTH; byte_num++) begin
               for (int bit_num = byte_num * BYTE_SIZE; bit_num < (byte_num + 1) * BYTE_SIZE; bit_num++) begin
                  if (enable && ((TG_USE_EFFICIENCY_PATTERN)? rdata_valid_r3: rdata_valid_r2)) begin
                     if (infinite_timeout_cnt == INFINITE_LOOP_DIAG_NUM) begin
                        pnf_per_bit[bit_num]     <= 1'b0;
                     end
                     else if (((TG_USE_EFFICIENCY_PATTERN)? written_be_r[byte_num]: written_be[byte_num])) begin
                        pnf_per_bit[bit_num]     <= (((TG_USE_EFFICIENCY_PATTERN)? rdata_r3[bit_num]: rdata_r2[bit_num]) === written_data_r[bit_num]);
                     end
                     //if byte-enable not set, only check correctness in byte-enable test stage
                     //check the non enabled bits against the seed data from the be stage test
                     else if (byteenable_stage) begin
                        pnf_per_bit[bit_num] <= (rdata_r2[bit_num] === 1'b1);
                     end else
                        pnf_per_bit[bit_num] <= 1'b1;
                  end else
                     pnf_per_bit[bit_num] <= 1'b1;
               end
            end

            pnf_per_bit_r      <= pnf_per_bit;
            pnf_per_bit_r2     <= pnf_per_bit_r;

            pnf_is_active      <= (enable && rdata_valid_r2);
            pnf_is_active_r    <= pnf_is_active;
            pnf_is_active_r2   <= pnf_is_active_r;

            pnf_r2_has_failure <= !(&pnf_per_bit_r);

         end
      end
   end

   always_comb begin
     for (int byte_num = 0; byte_num < BE_WIDTH; byte_num++) begin
       if ( ((TG_USE_EFFICIENCY_PATTERN)? written_be_r[byte_num] :written_be[byte_num]) ) begin
         pnf_bit_failure_be_mismatch[byte_num]             =
                (((TG_USE_EFFICIENCY_PATTERN)? rdata_r3[(byte_num * BYTE_SIZE)+:BYTE_SIZE]: rdata_r2[(byte_num * BYTE_SIZE)+:BYTE_SIZE]) !== written_data_r[(byte_num * BYTE_SIZE)+:BYTE_SIZE]);
       end
       //if byte-enable not set, only check correctness in byte-enable test stage
       //check the non enabled bits against the seed data from the be stage test
       else if (byteenable_stage) begin
         pnf_bit_failure_be_mismatch[byte_num]             = ~(&rdata_r2[(byte_num * BYTE_SIZE)+:BYTE_SIZE]);
       end
       else begin
         pnf_bit_failure_be_mismatch[byte_num]             = 1'b0;
       end
     end
   end

   always_ff @(posedge clk)
   begin
      if (rst2) begin
         pnf_bit_failure_det                     <= 1'b0;
      end else begin
         if (tg_restart) begin
            pnf_bit_failure_det                  <= 1'b0;
         end else begin
            if (enable && ((TG_USE_EFFICIENCY_PATTERN)? rdata_valid_r3 :rdata_valid_r2)) begin
               if (infinite_timeout_cnt == INFINITE_LOOP_DIAG_NUM) begin
                  pnf_bit_failure_det           <= 1'b1;
               end
               else begin
                  pnf_bit_failure_det           <= |pnf_bit_failure_be_mismatch;
               end
            end
            else begin
               pnf_bit_failure_det              <= 1'b0;
            end
         end
      end
   end

   // Timing closure pipe stages
   always_ff @(posedge clk)
   begin
      if (rst2) begin
         rdata_valid_r             <= 1'b0;
         rdata_valid_r2            <= 1'b0;
         rdata_valid_r3            <= 1'b0;
         rdata_valid_r4            <= 1'b0;
         rdata_valid_r5            <= 1'b0;
         rdata_valid_r6            <= 1'b0;
      end
      else
      begin
         rdata_valid_r             <= rdata_valid;
         rdata_valid_r2            <= rdata_valid_r;
         rdata_valid_r3            <= rdata_valid_r2;
         rdata_valid_r4            <= rdata_valid_r3;
         rdata_valid_r5            <= rdata_valid_r4;
         rdata_valid_r6            <= rdata_valid_r5;
      end
   end

   generate
	   if(!TG_USE_EFFICIENCY_PATTERN) begin
		   always_ff @(posedge clk)
		   begin
		   	written_data_r     <= written_data;
		   end
	   end
   endgenerate

   // Timing closure pipe stages
   always_ff @(posedge clk)
   begin
      rdata_r            <= rdata;
      rdata_r2           <= rdata_r;
      rdata_r3           <= rdata_r2;
      rdata_r4           <= rdata_r3;
      rdata_r5           <= rdata_r4;
      rdata_r6           <= rdata_r5;
      rid_r              <= rid;
      rid_r2             <= rid_r;
      rid_r3             <= rid_r2;
      rid_r4             <= rid_r3;
      rid_r5             <= rid_r4;
      written_data_r2    <= written_data_r;
      written_data_r3    <= written_data_r2;
      written_data_r4    <= written_data_r3;
      written_be_full_r  <= written_be_full;
      written_be_full_r2 <= written_be_full_r;
      written_be_full_r3 <= written_be_full_r2;
      written_be_full_r4 <= written_be_full_r3;
      read_addr_r        <= read_addr;
      read_addr_r2       <= read_addr_r;
      read_addr_r3       <= read_addr_r2;
   end

   // Error information
   always_ff @(posedge clk)
   begin
      if (rst2 || clear_first_fail) begin
         captured_first_fail               <= 1'b0;
         ttl_fail_pnf                      <= '0;
         ttl_pnf                           <= '0;
         first_fail_addr                   <= '0;
         first_fail_pnf                    <= '1;
         first_fail_expected_data          <= '0;
         first_fail_expected_data_prev     <= '0;
         first_fail_expected_data_next     <= '0;
         first_fail_written_be             <= '0;
         first_fail_actual_data            <= '0;
         first_fail_actual_data_prev       <= '0;
         first_fail_actual_data_next       <= '0;
         first_fail_actual_data_valid_prev <= '0;
         first_fail_actual_data_valid_next <= '0;
         last_rdata                        <= '0;
      end else begin
         // Collect statistics about total failures and comparisons
         if (pnf_r2_has_failure) begin
       	   ttl_fail_pnf <= ttl_fail_pnf + 1'b1;
         end
         if (pnf_is_active_r2) begin
            ttl_pnf <= ttl_pnf + 1'b1;
         end

         // Collect information about the first data mismatch
         if (pnf_r2_has_failure && !captured_first_fail) begin
            captured_first_fail <= 1'b1;
         end

         if (pnf_r2_has_failure && !captured_first_fail) begin
            first_fail_pnf                    <= pnf_per_bit_r2;
            first_fail_expected_data_prev     <= written_data_r4 & written_be_full_r4;
            first_fail_expected_data          <= written_data_r3 & written_be_full_r3;
            first_fail_expected_data_next     <= written_data_r2 & written_be_full_r2;
            first_fail_actual_data_valid_prev <= rdata_valid_r6;
            first_fail_actual_data_valid_next <= rdata_valid_r4;
            first_fail_actual_data_prev       <= rdata_r6 & written_be_full_r4;
            first_fail_actual_data            <= rdata_r5 & written_be_full_r3;
            first_fail_actual_data_next       <= rdata_r4 & written_be_full_r2;
            first_fail_written_be             <= written_be_full_r3;
            first_fail_actual_rid             <= rid_r5;
            first_fail_addr                   <= read_addr_r3;
         end

         // Collect the last read data, which in WORM mode is
         // the data of the repeated read
         if (rdata_valid_r3) begin
            last_rdata <= rdata_r3 & first_fail_written_be;
         end
      end
   end

   always_ff @ (posedge clk)
   begin
      if (rst2) begin
         pnf_per_bit_persist_r <= '1;
      end
      else begin
         if (clear_first_fail) begin
            pnf_per_bit_persist_r <= '1;
         end else begin
            pnf_per_bit_persist_r <= pnf_per_bit_persist_r & pnf_per_bit;
         end
      end
   end

   always_ff @ (posedge clk)
   begin
      if (clear_first_fail) begin
         pnf_per_bit_persist <= '1;
      end else begin
         pnf_per_bit_persist <= pnf_per_bit_persist_r;
      end
   end

   always_ff @ (posedge clk)
   begin
      pnf_per_bit_persist_status <= &pnf_per_bit_persist | clear_first_fail;
   end

   // Generate status signals
   //dont assign pass until all test stages complete or it will end sim
   always_ff @(posedge clk )
   if (rst2) begin
      pass <= '0;
      timeout_count <= '0;
   end else
   begin
      if (tg_restart) begin
         pass <= '0;
         timeout_count <= '0;
      end else begin
         pass <=  (pnf_per_bit_persist_status) & all_tests_issued & ~(reads_in_prog);
         if (!(all_tests_issued & ~(reads_in_prog))) begin
            timeout_count <= timeout_count + 1;
         end
      end
   end
   // If TEST_DURATION == "INFINITE" then the fail signal
   // will be asserted immediately upon any bit failure.  Otherwise,
   // the fail signal will only be asserted after all traffic has completed.
   assign fail = ~(pnf_per_bit_persist_status) & (TEST_DURATION == "INFINITE" ? 1'b1 : all_tests_issued);
   assign timeout = &timeout_count;

   // Generate bit-wise byte-enable signal which is easier to read
   generate
   genvar byte_num;
      for (byte_num = 0; byte_num < BE_WIDTH; ++byte_num)
      begin : gen_written_be_full
         if(TG_USE_EFFICIENCY_PATTERN) begin
         	assign written_be_full [byte_num * BYTE_SIZE +: BYTE_SIZE] = {BYTE_SIZE{written_be_r[byte_num]}};
	 end
	 else begin
         	assign written_be_full [byte_num * BYTE_SIZE +: BYTE_SIZE] = {BYTE_SIZE{written_be[byte_num]}};
	 end
      end
   endgenerate

   // Display a message to the user if there is an error
   always_ff @(posedge clk)
   begin

      // synthesis translate_off
      if (pnf_bit_failure_det)
      begin
        if (INFI_TG_ERR_TEST)
        begin
         if (infinite_timeout_cnt - 1'b1 == INFINITE_LOOP_DIAG_NUM)
         begin
           $display("SUCCESS: Expected SIMULATION FAILED ON R/W with INFI_TG_ERR_TEST enabled");
           $display("Done %d times READS/WRITES", INFINITE_LOOP_DIAG_NUM);
         end
         else
         begin
           $display("ERROR: Expected simulation failed at R/W cycle %d but failed at R/W cycle %d", INFINITE_LOOP_DIAG_NUM , infinite_timeout_cnt - 1'b1);
           $display("[%0t] ERROR: Expected %h/%h but read %h", $time, written_data_r, written_be_full_r, rdata_r3);
           $display("            wrote bits: %h", written_data_r & written_be_full_r);
           $display("             read bits: %h", rdata_r3 & written_be_full_r);
           $display("            At address: %h", read_addr_r3);
         end
        end
        else
        begin
         $display("[%0t] ERROR: Expected %h/%h but read %h", $time, written_data_r, written_be_full_r, rdata_r3);
         $display("            wrote bits: %h", written_data_r & written_be_full_r);
         $display("             read bits: %h", rdata_r3 & written_be_full_r);
         $display("            At address: %h", read_addr_r3);
        end
       end

      if (INFI_TG_ERR_TEST)
      begin
        if (infinite_timeout_cnt > INFINITE_LOOP_DIAG_NUM + 1'b1)
        begin
          $display("ERROR: Expected SIMULATION FAILED ON R/W after %d times READ/WRITE with INFI_TG_ERR_TEST enabled", INFINITE_LOOP_DIAG_NUM);
          $display("          --- SIMULATION FAILED --- ");
          $finish;
        end
      end
      // synthesis translate_on
   end

   always_ff @ (posedge clk)
   begin
      if (rst2) begin
         failure_count_inc_en        <= 1'b1;
      end else begin
         if (tg_restart) begin
            failure_count_inc_en     <= 1'b1;
         end else if (pnf_bit_failure_det) begin
            failure_count_inc_en     <= ~(&failure_count[OP_COUNT_WIDTH-1:1]);
         end
      end
   end

   logic [31:0] total_count;
   always_ff @ (posedge clk)
   begin
      if (rst2) begin
         first_failure <= '1;
         failure_count <= '0;
         total_count <= '0;
      end else begin
         if (tg_restart) begin
            first_failure <= '1;
            failure_count <= '0;
         end else if (pnf_bit_failure_det & failure_count_inc_en) begin
            first_failure <= '0; //deassert after first failure occurs
            failure_count <= failure_count + 1'b1;
         end else if (clear_first_fail) begin //if clear is written to the status avmm i/f
            first_failure <= '1;
         end

         if (tg_restart) begin
            total_count <= '0;
         end else if (rdata_valid) begin
            total_count <= total_count + 1'b1;
         end
      end
   end

`ifdef ALTERA_EMIF_ENABLE_ISSP
   /*Avoid having too many probes
   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("RCNT"),
      .probe_width             (32),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) issp_pnf_count (
      .probe  (total_count)
   );*/

   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("FCNT"),
      .probe_width             (OP_COUNT_WIDTH),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) issp_ttl_fail_pnf (
      .probe  (failure_count)
   );

   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("FADR"),
      .probe_width             (ADDR_WIDTH),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) issp_first_fail_exact_addr (
      .probe  (first_fail_addr)
   );

   /*altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("RAVP"),
      .probe_width             (1),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) tg_rd_valid_prev (
      .probe  (first_fail_actual_data_valid_prev)
   );

   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("RAVN"),
      .probe_width             (1),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) tg_rd_valid_next (
      .probe  (first_fail_actual_data_valid_next)
   );

   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("FEX0"),
      .probe_width             (DATA_WIDTH),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) tg_wd (
      .probe  (first_fail_expected_data)
   );
   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("FEP0"),
      .probe_width             (DATA_WIDTH),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) tg_wd_prev (
      .probe  (first_fail_expected_data_prev)
   );
   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("FEN0"),
      .probe_width             (DATA_WIDTH),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) tg_wd_next (
      .probe  (first_fail_expected_data_next)
   );

   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("ACT0"),
      .probe_width             (DATA_WIDTH),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) tg_rd (
      .probe  (first_fail_actual_data)
   );
   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("ACP0"),
      .probe_width             (DATA_WIDTH),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) tg_rd_prev (
      .probe  (first_fail_actual_data_prev)
   );
   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("ACN0"),
      .probe_width             (DATA_WIDTH),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) tg_rd_next (
      .probe  (first_fail_actual_data_next)
   );
   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("ACI0"),
      .probe_width             (ID_WIDTH),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
   ) tg_rid (
      .probe  (first_fail_actual_rid)
   );*/
`endif

logic [DATA_WIDTH/4-1:0] rdata_part[4-1:0];
logic [DATA_WIDTH/4-1:0] rdata_r_part[4-1:0];
logic [4-1:0] rdata_comp;
logic rdata_comp_or;
logic [4-1:0] read_addr_comp;

integer k;
logic first_failure_r, pnf_bit_failure_det_r;

assign {rdata_part  [3], rdata_part  [2], rdata_part  [1], rdata_part  [0]} = rdata;
assign {rdata_r_part[3], rdata_r_part[2], rdata_r_part[1], rdata_r_part[0]} = rdata_r;
assign rdata_comp_or = |rdata_comp;
   always_ff @ (posedge clk)
   begin
       first_fail_read       <= first_fail_read_p1;
       first_fail_write      <= first_fail_write_p1;
   end

   always_ff @ (posedge clk)
   begin
      if (rst2) begin
         for (k=0; k<4; k=k+1) begin
          rdata_comp[k] <= 1'b0;
         end
         read_addr_comp <= 1'b0;
         first_failure_r <= 1'b0;
         pnf_bit_failure_det_r <= 1'b0;
         first_fail_read_p1   <= 1'b0;
         first_fail_write_p1  <= 1'b0;
      end
      else begin
         for (k=0; k<4; k=k+1) begin
          rdata_comp[k] <= (rdata_part[k] != rdata_r_part[k])? 1'b1: 1'b0;
         end
         read_addr_comp <= (read_addr == read_addr_r)? 1'b1: 1'b0;
         first_failure_r <= first_failure;
         pnf_bit_failure_det_r <= pnf_bit_failure_det;
         if (tg_restart) begin
            first_fail_read_p1   <= 1'b0;
            first_fail_write_p1  <= 1'b0;
         end else if (first_failure_r) begin
            //to verify read or write failure, must be doing multiple reads from same address
            if ((pnf_bit_failure_det_r==1'b1) && read_addr_comp) begin
               //when read data from same address doesn't match, assume read failure
               if (rdata_comp_or) begin
                  first_fail_read_p1 <= 1'b1;
               end
               else begin
                  first_fail_write_p1 <= 1'b1;
               end
            end
         end
      end
   end

endmodule

