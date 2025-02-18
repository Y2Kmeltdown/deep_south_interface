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


module altera_hbm_tg_axi_rob_single_burst #
    (
        parameter ARID_WIDTH = 7,
        parameter DATA_WIDTH = 256
    )
    (
        input                       clk,
        input                       reset_n,

        input                       master_arready,
        input                       slave_arvalid,
        input  [ARID_WIDTH - 1 : 0] slave_arid,
        input                       slave_rready,
        input                       master_rvalid,
        input  [ARID_WIDTH - 1 : 0] master_rid,
        input  [DATA_WIDTH - 1 : 0] master_rdata,
        input  [1              : 0] master_rresp,
        input                       master_rlast,

        output                      slave_rvalid,
        output [ARID_WIDTH - 1 : 0] slave_rid,
        output [DATA_WIDTH - 1 : 0] slave_rdata,
        output [1              : 0] slave_rresp,
        output                      slave_rlast,
        output                      master_rready
    );
timeunit 1ns;
timeprecision 1ps;

localparam INT_DATA_WIDTH = DATA_WIDTH + 2 + 6; 
localparam ARID_DEPTH     = 2 ** ARID_WIDTH;

wire                          slave_arready;
   
wire [ARID_WIDTH     - 1 : 0] rid_fifo_wr_data;
wire                          rid_fifo_wr;
wire [ARID_WIDTH     - 1 : 0] rid_fifo_rd_data;
wire                          rid_fifo_rd;
wire                          rid_fifo_full;
wire                          rid_fifo_empty;

wire [INT_DATA_WIDTH - 1 : 0] rdata_ram_wr_data;
wire [ARID_WIDTH     - 1 : 0] rdata_ram_wr_addr;
wire                          rdata_ram_wr;
wire [INT_DATA_WIDTH - 1 : 0] rdata_ram_rd_data;
wire [ARID_WIDTH     - 1 : 0] rdata_ram_rd_addr;
wire [ARID_WIDTH     - 1 : 0] rdata_ram_rd_addr_delay;
wire                          rdata_ram_rd;
wire                          rdata_ram_rd_delay;

reg  [ARID_WIDTH     - 1 : 0] rdata_ram_rd_addr_r1;
reg  [ARID_WIDTH     - 1 : 0] rdata_ram_rd_addr_r2;

reg                           rdata_ram_rd_r1;
reg                           rdata_ram_rd_r2;

reg  [ARID_DEPTH     - 1 : 0] arid_valid;
reg  [ARID_DEPTH     - 1 : 0] rid_valid;
reg                           arid_hit;
reg                           rid_ready;

genvar i;

assign slave_arready    = master_arready & ~rid_fifo_full & ~arid_hit;
assign master_rready    = slave_rready;

assign slave_rid        = rdata_ram_rd_addr_delay;

assign slave_rresp      = rdata_ram_rd_data[DATA_WIDTH + 2 - 1 : DATA_WIDTH];

assign slave_rlast      = rdata_ram_rd_delay;
assign slave_rvalid     = rdata_ram_rd_delay;

assign rid_fifo_wr_data = slave_arid;
assign rid_fifo_wr      = slave_arready & slave_arvalid;
assign rid_fifo_rd      = rid_ready;

assign rob_ready        = ~rid_fifo_full;

scfifo rid_fifo (
    .aclr         (~reset_n        ),
    .clock        (clk             ),
    .data         (rid_fifo_wr_data),
    .rdreq        (rid_fifo_rd     ),
    .wrreq        (rid_fifo_wr     ),
    .empty        (rid_fifo_empty  ),
    .full         (rid_fifo_full   ),
    .q            (rid_fifo_rd_data),
    .almost_empty (                ),
    .almost_full  (                ),
    .sclr         (1'b0            ),
    .usedw        (                ),
    .eccstatus    (                )
);
defparam
    rid_fifo.add_ram_output_register = "ON",
    rid_fifo.intended_device_family = "Stratix",
    rid_fifo.lpm_numwords = ARID_DEPTH,
    rid_fifo.lpm_showahead = "ON",
    rid_fifo.lpm_type = "scfifo",
    rid_fifo.lpm_width = ARID_WIDTH,
    rid_fifo.lpm_widthu = ARID_WIDTH,
    rid_fifo.overflow_checking = "OFF",
    rid_fifo.underflow_checking = "OFF",
    rid_fifo.use_eab = "ON";


assign rdata_ram_wr_data  = {6'd0,master_rresp, master_rdata};
assign rdata_ram_wr_addr  = master_rid;
assign rdata_ram_wr       = master_rready & master_rvalid;
assign rdata_ram_rd_addr  = rid_fifo_rd_data;
assign rdata_ram_rd       = rid_fifo_rd;

assign rdata_ram_rd_addr_delay = rdata_ram_rd_addr_r2;
assign rdata_ram_rd_delay      = rdata_ram_rd_r2;

assign slave_rdata = rdata_ram_rd_data[DATA_WIDTH - 1 : 0];


localparam BYTE_SIZE = 8;
localparam MEM_DATAWIDTH = INT_DATA_WIDTH;
localparam MEM_BEWIDTH = MEM_DATAWIDTH / BYTE_SIZE;
localparam MEM_ADDRWIDTH = ARID_WIDTH;
   
altera_syncram rdata_ram
(
   .wren_a         (rdata_ram_wr             ),
   .clock0         (clk                      ),
   .address_a      (rdata_ram_wr_addr        ),
   .address_b      (rdata_ram_rd_addr        ),
   .data_a         (rdata_ram_wr_data        ),
   .q_b            (rdata_ram_rd_data        ),
   .aclr0          (1'b0                     ),
   .aclr1          (1'b0                     ),
   .addressstall_a (1'b0                     ),
   .addressstall_b (1'b0                     ),
   .byteena_a      ({MEM_BEWIDTH{1'b1}}      ),
   .byteena_b      (                         ),
   .clock1         (1'b1                     ),
   .clocken0       (1'b1                     ),
   .clocken1       (1'b1                     ),
   .clocken2       (1'b1                     ),
   .clocken3       (1'b1                     ),
   .data_b         (                         ),
   .eccstatus      (                         ),
   .q_a            (                         ),
   .rden_a         (1'b1                     ),
   .rden_b         (1'b1                     ),
   .wren_b         (1'b0                     )
);
defparam
   rdata_ram.address_aclr_a = "NONE",
   rdata_ram.address_aclr_b = "NONE",
   rdata_ram.address_reg_b = "CLOCK0",
   rdata_ram.intended_device_family = "Stratix 10",
   rdata_ram.lpm_type = "altera_syncram",
   rdata_ram.numwords_a = (2**MEM_ADDRWIDTH),
   rdata_ram.numwords_b = (2**MEM_ADDRWIDTH),
   rdata_ram.operation_mode = "DUAL_PORT",
   rdata_ram.outdata_aclr_b = "NONE",
   rdata_ram.outdata_reg_b = "CLOCK0",
   rdata_ram.power_up_uninitialized = "FALSE",
   rdata_ram.ram_block_type  = "M20K",
   rdata_ram.rdcontrol_reg_b  = "CLOCK0", 
   rdata_ram.read_during_write_mode_mixed_ports = "DONT_CARE",
   rdata_ram.widthad_a = MEM_ADDRWIDTH,
   rdata_ram.widthad_b = MEM_ADDRWIDTH,
   rdata_ram.width_a = MEM_DATAWIDTH,
   rdata_ram.width_b = MEM_DATAWIDTH,
   rdata_ram.width_byteena_a = MEM_BEWIDTH,
   rdata_ram.width_byteena_b = MEM_BEWIDTH,
   rdata_ram.byte_size = BYTE_SIZE;

   
generate
for (i = 0; i < ARID_DEPTH; i = i + 1)
begin : arid_valid_loop
    always @ (posedge clk)
    begin
        if (!reset_n)
        begin
            arid_valid[i] <= 1'b0;
        end
        else
        begin
            if (rdata_ram_rd && rdata_ram_rd_addr == i)
            begin
                arid_valid[i] <= 1'b0;
            end
            else if (rid_fifo_wr && rid_fifo_wr_data == i)
            begin
                arid_valid[i] <= 1'b1;
            end
        end
    end
end
endgenerate

generate
for (i = 0; i < ARID_DEPTH; i = i + 1)
begin : rid_valid_loop
    always @ (posedge clk)
    begin
        if (!reset_n)
        begin
            rid_valid[i] <= 1'b0;
        end
        else
        begin
            if (rdata_ram_rd && rdata_ram_rd_addr == i)
            begin
                rid_valid[i] <= 1'b0;
            end
            else if (rdata_ram_wr && rdata_ram_wr_addr == i)
            begin
                rid_valid[i] <= 1'b1;
            end
        end
    end
end
endgenerate

always @ (*)
begin
    if (arid_valid[slave_arid] == 1'b1 && slave_arvalid)
    begin
        arid_hit = 1'b1;
    end
    else
    begin
        arid_hit = 1'b0;
    end
end

always @ (*)
begin
    if (rid_fifo_empty)
    begin
        rid_ready = 1'b0;
    end
    else
    begin
        rid_ready = rid_valid[rid_fifo_rd_data];
    end
end

always @ (posedge clk)
begin
    if (!reset_n)
    begin
        rdata_ram_rd_addr_r1 <= {ARID_WIDTH{1'b0}};
        rdata_ram_rd_addr_r2 <= {ARID_WIDTH{1'b0}};
        rdata_ram_rd_r1      <= 1'b0;
        rdata_ram_rd_r2      <= 1'b0;
    end
    else
    begin
        rdata_ram_rd_addr_r1 <= rdata_ram_rd_addr;
        rdata_ram_rd_addr_r2 <= rdata_ram_rd_addr_r1;
        rdata_ram_rd_r1      <= rdata_ram_rd;
        rdata_ram_rd_r2      <= rdata_ram_rd_r1;
    end
end

endmodule
