module av_esram #(
	parameter
	c_ADDR_BITS = 16,
	c_WORD_SIZE = 32
)
(
	input 										refclk,
	output										esram_clk,
	output										esram_rst,
	output										iopll_lock,
	
	input				[c_ADDR_BITS-1:0]		av_address,
	input											av_read,
	output	reg								av_waitrequest,
	input											av_write,
	output	reg	[c_WORD_SIZE-1:0]		av_readdata,
	input				[c_WORD_SIZE-1:0]		av_writedata,
	
	// Esram Attachment
	input				[c_WORD_SIZE-1:0]		q,
	input											esram_clk_i,
	input											iopll_lock2core,
	output	reg	[c_WORD_SIZE-1:0]		data,
	output	reg	[c_ADDR_BITS-1:0]		rdaddress,
	output										rden_n,
	output										sd_n,
	output	reg	[c_ADDR_BITS-1:0]		wraddress,
	output										wren_n,
	output										refclk_out
	
);

bretime #(
	.DEPTH			(13)
) u1 (
	.reset			(rst_i),
	.clock			(esram_clk_i),
	.d					(av_read),
	.q					(read_waitrequest_n)
);

reg rden = 1'b0;
reg wren = 1'b0;
reg sd = 1'b0;
reg rst_i;

assign rden_n = !rden;
assign wren_n = !wren;
assign sd_n = !sd;

assign refclk_out = refclk;

assign esram_clk = esram_clk_i;
assign esram_rst = rst_i;
assign iopll_lock = iopll_lock2core;

always @(posedge esram_clk) begin
	if (!iopll_lock2core) begin
		rden <= 1'b0;
		wren <= 1'b0;
		av_waitrequest <= 1'b1;
		rst_i <= 1'b1;
	end
	else begin
		rst_i <= 1'b0;
		wraddress <= av_address;
		rdaddress <= av_address;
		wren <= av_write;
		rden <= av_read;
		data <= av_writedata;
		av_readdata <= q;
		if (av_write) begin
			av_waitrequest <= 1'b0;
		end
		else if (av_read) begin
			av_waitrequest <= !read_waitrequest_n;
		end
		else begin
			av_waitrequest <= 1'b1;
		end
	end
end


endmodule