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


module altera_effmon_tg #(
  parameter EFFICIENCY_FACTOR_NUM         = 1,
  parameter EFFICIENCY_FACTOR_DEN         = 1,
  parameter COUNTER_WIDTH                 = 32,
  parameter BURST_LEN                     = 1,
  parameter SUM_RD                        = "",
  parameter SUM_WR                        = "",
  parameter PORT_AXI_ARID_WIDTH           = "",
  parameter PORT_AXI_RID_WIDTH            = "",
  parameter C2P_CLK_RATIO                 = 1,
  parameter DIAG_EFFICIENCY_MONITOR       = 0
) (
  input                     wmc_clk_in       ,
  input                     wmcrst_n_in      ,

  input                     reset_counters   ,

  input [COUNTER_WIDTH-1:0] read_cnt_effmon  ,
  input [COUNTER_WIDTH-1:0] write_cnt_effmon ,

  input                     awvalid          ,
  input                     awready          ,

  input                     wlast            ,
  input                     wvalid           ,
  input                     wready           ,

  input                     bvalid           ,
  input                     bready           ,

  input                     arvalid          ,
  input                     arready          ,
  input [PORT_AXI_ARID_WIDTH-1:0]  arid             ,
  input [PORT_AXI_RID_WIDTH -1:0]  rid              ,

  input                     rlast            ,
  input                     rvalid           ,
  input                     rready
);

  timeunit 1ns;
  timeprecision 1ps;
 
  logic [COUNTER_WIDTH-1:0] total_count;
  logic [COUNTER_WIDTH-1:0] total_active_count;
  logic [COUNTER_WIDTH-1:0] awvalid_count;
  logic [COUNTER_WIDTH-1:0] awready_count;
  logic [COUNTER_WIDTH-1:0] awvalid_and_ready_count;
  logic [COUNTER_WIDTH-1:0] wvalid_count;
  logic [COUNTER_WIDTH-1:0] wready_count;
  logic [COUNTER_WIDTH-1:0] wvalid_and_ready_count;
  logic [COUNTER_WIDTH-1:0] arvalid_count;
  logic [COUNTER_WIDTH-1:0] arready_count;
  logic [COUNTER_WIDTH-1:0] arvalid_and_ready_count;
  logic [COUNTER_WIDTH-1:0] rvalid_count;
  logic [COUNTER_WIDTH-1:0] rready_count;
  logic [COUNTER_WIDTH-1:0] rvalid_and_ready_count;
  logic [COUNTER_WIDTH-1:0] rvalid_and_ready_and_rlast_count;

  logic interface_is_active;

  logic                     interface_is_done;
  logic                     last_rd, last_rd_cmd;
  logic                     last_wr, last_wr_cmd;
  logic                     last_activity;

  logic [COUNTER_WIDTH-1:0] total_active_count_last;
  always @ (posedge wmc_clk_in) begin
   total_active_count_last <= total_active_count-1;
  end

  assign interface_is_done = (last_activity & interface_is_active)? 1: 0;

  always @ (posedge wmc_clk_in) begin
    if (wmcrst_n_in) begin
      last_rd           <= 1'b0;
      last_rd_cmd       <= 1'b0;
      last_wr           <= 1'b0;
      last_wr_cmd       <= 1'b0;
      last_activity     <= 1'b0;
    end
    else begin
      if(reset_counters) begin
        last_rd           <= 1'b0;
        last_rd_cmd       <= 1'b0;
        last_wr           <= 1'b0;
        last_wr_cmd       <= 1'b0;
        last_activity     <= 1'b0;
      end
      else begin
        if((SUM_RD == 'd0) || ((rvalid_and_ready_count == SUM_RD*BURST_LEN -1)
          & rvalid & rready & rlast)) last_rd <= 1'b1;
        else if(last_activity) last_rd <= 1'b0;
        if((SUM_WR == 'd0) || ((wvalid_and_ready_count == SUM_WR*BURST_LEN-1)
          & wvalid & wready & wlast)) last_wr <= 1'b1;
        else if(last_activity) last_wr <= 1'b0;
        if((SUM_RD == 'd0) || ((arvalid_and_ready_count == SUM_RD -1)
          & arvalid & arready)) last_rd_cmd <= 1'b1;
        else if(last_activity) last_rd_cmd <= 1'b0;
        if((SUM_WR == 'd0) || ((awvalid_and_ready_count == SUM_WR-1)
          & awvalid & awready)) last_wr_cmd <= 1'b1;
        else if(last_activity) last_wr_cmd <= 1'b0;
        if(last_rd & last_rd_cmd & last_wr & last_wr_cmd) last_activity <= 1;
      end
    end
  end


 always @ (posedge wmc_clk_in) begin
  if (wmcrst_n_in) begin
    interface_is_active              <= 1'b0;
    total_count                      <= '0;
    total_active_count               <= '0;
    awvalid_count                    <= '0;
    awready_count                    <= '0;
    awvalid_and_ready_count          <= '0;
    wvalid_count                     <= '0;
    wready_count                     <= '0;
    wvalid_and_ready_count           <= '0;
    arvalid_count                    <= '0;
    arready_count                    <= '0;
    arvalid_and_ready_count          <= '0;
    rvalid_count                     <= '0;
    rready_count                     <= '0;
    rvalid_and_ready_count           <= '0;
    rvalid_and_ready_and_rlast_count <= '0;
  end
  else begin
    if(reset_counters) begin
      interface_is_active              <= 1'b0;
      total_count                      <= '0;
      total_active_count               <= '0;
      awvalid_count                    <= '0;
      awready_count                    <= '0;
      awvalid_and_ready_count          <= '0;
      wvalid_count                     <= '0;
      wready_count                     <= '0;
      wvalid_and_ready_count           <= '0;
      arvalid_count                    <= '0;
      arready_count                    <= '0;
      arvalid_and_ready_count          <= '0;
      rvalid_count                     <= '0;
      rready_count                     <= '0;
      rvalid_and_ready_count           <= '0;
      rvalid_and_ready_and_rlast_count <= '0;
    end
    else begin
      if (~&total_count) begin
        total_count <= total_count + 1'b1;

        if     (awvalid || arvalid) interface_is_active <= 1'b1;
        else if(interface_is_done ) interface_is_active <= 1'b0;

        if (interface_is_active) begin
           total_active_count <= total_active_count + 1'b1;
        end
        if (awvalid) begin
           awvalid_count <= awvalid_count + 1'b1;
        end
        if (awready) begin
           awready_count <= awready_count + 1'b1;
        end
        if (awvalid & awready) begin
           awvalid_and_ready_count <= awvalid_and_ready_count + 1'b1;
        end
        if (wvalid) begin
           wvalid_count <= wvalid_count + 1'b1;
        end
        if (wready) begin
           wready_count <= wready_count + 1'b1;
        end
        if (wvalid & wready) begin
           wvalid_and_ready_count <= wvalid_and_ready_count + 1'b1;
        end
        if (arvalid) begin
           arvalid_count <= arvalid_count + 1'b1;
        end
        if (arready) begin
           arready_count <= arready_count + 1'b1;
        end
        if (arvalid & arready) begin
           arvalid_and_ready_count <= arvalid_and_ready_count + 1'b1;
        end
        if (rvalid) begin
           rvalid_count <= rvalid_count + 1'b1;
        end
        if (rready) begin
           rready_count <= rready_count + 1'b1;
        end
        if (rvalid & rready) begin
           rvalid_and_ready_count <= rvalid_and_ready_count + 1'b1;
           if (rlast) begin
              rvalid_and_ready_and_rlast_count <=
                rvalid_and_ready_and_rlast_count + 1'b1;
           end
        end
      end
    end
  end
end

 // synthesis translate_off
 always @ (posedge ed_sim.sim_checker.sim_checker.pass_all) begin
  	if ((DIAG_EFFICIENCY_MONITOR) && (ed_sim.sim_checker.sim_checker.pass_all)) begin
        $display(" ");
        print_efficiency_status();
        print_latency_status();
	    $display(" ");
	end
  end
  // synthesis translate_on
  
  logic [COUNTER_WIDTH-1:0] latency_time_stamp, latency_time_stamp_diff;
  logic [COUNTER_WIDTH-1:0] latency_min, latency_max, latency_sum;

  logic r_rdy_vld_r;
  assign latency_time_stamp_diff = total_count - latency_time_stamp;
  
  logic valid_no_ready;
  logic valid_no_ready_pos_edge;
  assign write_en_timestamp = !(valid_no_ready) & arvalid;
  always @ (posedge wmc_clk_in) begin
    if (wmcrst_n_in) begin
      valid_no_ready <= 1'b0;
    end
    else begin
      if(reset_counters) begin
        valid_no_ready <= 1'b0;
      end
      else begin 
        if(arvalid && !arready) valid_no_ready <= 1'b1;
        else if (arready) valid_no_ready <= 1'b0;
      end
    end
  end  

  simple_dp_ram #(
    .DATA_WIDTH     (COUNTER_WIDTH      ),
    .W_ADDR_WIDTH   (PORT_AXI_ARID_WIDTH),
    .R_ADDR_WIDTH   (PORT_AXI_RID_WIDTH )
  ) arid_rid_time_stamp (
    .clk            (wmc_clk_in        ),
    .we             (write_en_timestamp),
    .write_address  (arid              ),
    .d              (total_count       ),
    .read_address   (rid               ),
    .q              (latency_time_stamp)
  );
   
  always @ (posedge wmc_clk_in) begin
    if (wmcrst_n_in) begin
      r_rdy_vld_r <= 1'b0;
      latency_min <= {(COUNTER_WIDTH){1'b1}};
      latency_max <= {(COUNTER_WIDTH){1'b0}};
      latency_sum <= {(COUNTER_WIDTH){1'b0}};
    end
    else begin
      if(reset_counters) begin
        r_rdy_vld_r <= 1'b0;
        latency_min <= {(COUNTER_WIDTH){1'b1}};
        latency_max <= {(COUNTER_WIDTH){1'b0}};
        latency_sum <= {(COUNTER_WIDTH){1'b0}};
      end
      else begin 
        r_rdy_vld_r <= rvalid & rready & rlast;
        latency_min <= (r_rdy_vld_r && (latency_time_stamp_diff < latency_min))? latency_time_stamp_diff: latency_min;
        latency_max <= (r_rdy_vld_r && (latency_time_stamp_diff > latency_max))? latency_time_stamp_diff: latency_max;
        latency_sum <= (r_rdy_vld_r)? latency_time_stamp_diff + latency_sum: latency_sum;

      end
    end
  end

 task print_efficiency_status;
 begin
    // synthesis translate_off
    $display("[%0t] AXI Command Efficiency Monitor Status: %m", $time);
    $display("Write address valid and ready (awvalid_and_ready_count) = %d / %d",  awvalid_and_ready_count, total_count);
    $display("Write valid and ready         (wvalid_and_ready_count ) = %d / %d",  wvalid_and_ready_count, total_count);
    $display("Read address valid and ready  (arvalid_and_ready_count) = %d / %d",  arvalid_and_ready_count, total_count);
    $display("Read valid and ready          (rvalid_and_ready_count ) = %d / %d",  rvalid_and_ready_count, total_count);
    $display("Total active cycles           (total_active_count     ) = %d / %d",  total_active_count_last, total_count);
    $display("Total cycles                  (total_count            ) = %d / %d",  total_count, total_count);

    $display("####################################################################");
    $display("## Overall AXI command bus efficiency while interface active = %d ##", (wvalid_and_ready_count + rvalid_and_ready_count) * 100 * EFFICIENCY_FACTOR_NUM / EFFICIENCY_FACTOR_DEN / total_active_count);
    $display("####################################################################");
    $display("Efficiency vary depending on various factors.  See documentation for details.");

    // synthesis translate_on
 end
 endtask
 
 task print_latency_status;
 begin
    // synthesis translate_off
    $display("[%0t] AXI Read Command Latency Monitor Status: %m", $time);
    $display("Minimum latency  = %d ns",  latency_min * (EFFICIENCY_FACTOR_DEN*C2P_CLK_RATIO/EFFICIENCY_FACTOR_NUM));
    $display("Maximum latency  = %d ns",  latency_max * (EFFICIENCY_FACTOR_DEN*C2P_CLK_RATIO/EFFICIENCY_FACTOR_NUM));
    $display("Average latency  = %d ns",  latency_sum * (EFFICIENCY_FACTOR_DEN*C2P_CLK_RATIO/EFFICIENCY_FACTOR_NUM) /rvalid_and_ready_and_rlast_count);
    $display("Number of read commands = %d",  rvalid_and_ready_and_rlast_count);
    // synthesis translate_on
 end
 endtask

 logic [2:0] eff_mon_val_slct;
 logic [COUNTER_WIDTH-1:0] eff_mon_val;
 assign eff_mon_val = (eff_mon_val_slct == 3'b000)? wvalid_and_ready_count:
                      (eff_mon_val_slct == 3'b001)? rvalid_and_ready_count:
                      (eff_mon_val_slct == 3'b010)? total_active_count    :
                      (eff_mon_val_slct == 3'b100)? latency_min           :
                      (eff_mon_val_slct == 3'b101)? latency_max           :
                                                    rvalid_and_ready_and_rlast_count;
                                                    
 `ifdef ALTERA_EMIF_ENABLE_ISSP
    altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("EFFR"),
      .probe_width             (COUNTER_WIDTH),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
    ) eff_mon_val_issp (
      .probe  (eff_mon_val)
    );

    altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("EFFW"),
      .probe_width             (0),
      .source_width            (3),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
    ) eff_mon_val_slct_issp (
      .source  (eff_mon_val_slct)
    );

    altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("EFFT"),
      .probe_width             (1),
      .source_width            (0),
      .source_initial_value    ("0"),
      .enable_metastability    ("NO")
    ) last_activity_issp (
      .probe  (last_activity)
    );
  `endif
endmodule

