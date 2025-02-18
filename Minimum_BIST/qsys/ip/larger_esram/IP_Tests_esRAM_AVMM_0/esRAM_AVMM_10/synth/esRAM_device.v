module esRAM_device
(	
	input								refclk,
	input				[19:0]		av_address,
	input								av_write,
	input				[31:0]		av_writedata,
	input								av_read,
	output	reg 	[31:0]		av_readdata,
	output	reg					av_waitrequest,
	
	output							esram_clk_locked,
	output	reg					reset_n,
	output							esram_clk
);

reg	[31:0]	c0_inData;
reg	[16:0]	c0_rdaddress;
reg				c0_rden_n;
reg				c0_sden_n = 1'b1;
reg	[16:0]	c0_wraddress;
reg				c0_wren_n;
wire	[31:0]	c0_outData;

reg	[31:0]	c1_inData;
reg	[16:0]	c1_rdaddress;
reg				c1_rden_n;
reg				c1_sden_n = 1'b1;
reg	[16:0]	c1_wraddress;
reg				c1_wren_n;
wire	[31:0]	c1_outData;

reg	[31:0]	c2_inData;
reg	[16:0]	c2_rdaddress;
reg				c2_rden_n;
reg				c2_sden_n = 1'b1;
reg	[16:0]	c2_wraddress;
reg				c2_wren_n;
wire	[31:0]	c2_outData;

reg	[31:0]	c3_inData;
reg	[16:0]	c3_rdaddress;
reg				c3_rden_n;
reg				c3_sden_n = 1'b1;
reg	[16:0]	c3_wraddress;
reg				c3_wren_n;
wire	[31:0]	c3_outData;

reg	[31:0]	c4_inData;
reg	[16:0]	c4_rdaddress;
reg				c4_rden_n;
reg				c4_sden_n = 1'b1;
reg	[16:0]	c4_wraddress;
reg				c4_wren_n;
wire	[31:0]	c4_outData;

reg	[31:0]	c5_inData;
reg	[16:0]	c5_rdaddress;
reg				c5_rden_n;
reg				c5_sden_n = 1'b1;
reg	[16:0]	c5_wraddress;
reg				c5_wren_n;
wire	[31:0]	c5_outData;

reg	[31:0]	c6_inData;
reg	[16:0]	c6_rdaddress;
reg				c6_rden_n;
reg				c6_sden_n = 1'b1;
reg	[16:0]	c6_wraddress;
reg				c6_wren_n;
wire	[31:0]	c6_outData;

reg	[31:0]	c7_inData;
reg	[16:0]	c7_rdaddress;
reg				c7_rden_n;
reg				c7_sden_n = 1'b1;
reg	[16:0]	c7_wraddress;
reg				c7_wren_n;
wire	[31:0]	c7_outData;

wire channel_select = av_address[19:17];

wire isCHANNEL0 = (channel_select==3'b000);
wire isCHANNEL1 = (channel_select==3'b001);
wire isCHANNEL2 = (channel_select==3'b010);
wire isCHANNEL3 = (channel_select==3'b011);
wire isCHANNEL4 = (channel_select==3'b100);
wire isCHANNEL5 = (channel_select==3'b101);
wire isCHANNEL6 = (channel_select==3'b110);
wire isCHANNEL7 = (channel_select==3'b111);


esRAM_0 u0 (
	  .esram2f_clk     (esram_clk),     						//  output,   width = 1,           .esram2f_clk
	  .refclk          (refclk),           					//   input,   width = 1,           .clock
	  .iopll_lock2core (esram_clk_locked), 					//  output,   width = 1,           .iopll_lock2core
	  
	  .c0_data_0       (c0_inData),       						//   input,  width = 32,  ram_input.s2c0_da_0
	  .c0_rdaddress_0  (c0_rdaddress),  						//   input,  width = 17,           .s2c0_adrb_0
	  .c0_rden_n_0     (c0_rden_n),     						//   input,   width = 1,           .s2c0_meb_n_0
	  .c0_sd_n_0       (c0_sden_n),       						//   input,   width = 1,           .s2c0_sd_n_0
	  .c0_wraddress_0  (c0_wraddress),  						//   input,  width = 17,           .s2c0_adra_0
	  .c0_wren_n_0     (c0_wren_n),     						//   input,   width = 1,           .s2c0_mea_n_0
	  .c0_q_0          (c0_outData),          				//  output,  width = 32, ram_output.s2c0_qb_0
	  
	  .c1_data_0       (c1_inData),       						//   input,  width = 32,           .s2c1_da_0
	  .c1_rdaddress_0  (c1_rdaddress),  						//   input,  width = 17,           .s2c1_adrb_0
	  .c1_rden_n_0     (c1_rden_n),     						//   input,   width = 1,           .s2c1_meb_n_0
	  .c1_sd_n_0       (c1_sden_n),       						//   input,   width = 1,           .s2c1_sd_n_0
	  .c1_wraddress_0  (c1_wraddress),  						//   input,  width = 17,           .s2c1_adra_0
	  .c1_wren_n_0     (c1_wren_n),     						//   input,   width = 1,           .s2c1_mea_n_0
	  .c1_q_0          (c1_outData),          				//  output,  width = 32,           .s2c1_qb_0
	  
	  .c2_data_0       (c2_inData),       						//   input,  width = 32,           .s2c2_da_0
	  .c2_rdaddress_0  (c2_rdaddress),  						//   input,  width = 17,           .s2c2_adrb_0
	  .c2_rden_n_0     (c2_rden_n),     						//   input,   width = 1,           .s2c2_meb_n_0
	  .c2_sd_n_0       (c2_sden_n),       						//   input,   width = 1,           .s2c2_sd_n_0
	  .c2_wraddress_0  (c2_wraddress),  						//   input,  width = 17,           .s2c2_adra_0
	  .c2_wren_n_0     (c2_wren_n),     						//   input,   width = 1,           .s2c2_mea_n_0
	  .c2_q_0          (c2_outData),          				//  output,  width = 32,           .s2c2_qb_0
	  
	  .c3_data_0       (c3_inData),       						//   input,  width = 32,           .s2c3_da_0
	  .c3_rdaddress_0  (c3_rdaddress),  						//   input,  width = 17,           .s2c3_adrb_0
	  .c3_rden_n_0     (c3_rden_n),     						//   input,   width = 1,           .s2c3_meb_n_0
	  .c3_sd_n_0       (c3_sden_n),       						//   input,   width = 1,           .s2c3_sd_n_0
	  .c3_wraddress_0  (c3_wraddress),  						//   input,  width = 17,           .s2c3_adra_0
	  .c3_wren_n_0     (c3_wren_n),     						//   input,   width = 1,           .s2c3_mea_n_0
	  .c3_q_0          (c3_outData),          				//  output,  width = 32,           .s2c3_qb_0
	  
	  .c4_data_0       (c4_inData),       						//   input,  width = 32,           .s2c4_da_0
	  .c4_rdaddress_0  (c4_rdaddress),  						//   input,  width = 17,           .s2c4_adrb_0
	  .c4_rden_n_0     (c4_rden_n),     						//   input,   width = 1,           .s2c4_meb_n_0
	  .c4_sd_n_0       (c4_sden_n),       						//   input,   width = 1,           .s2c4_sd_n_0
	  .c4_wraddress_0  (c4_wraddress),  						//   input,  width = 17,           .s2c4_adra_0
	  .c4_wren_n_0     (c4_wren_n),     						//   input,   width = 1,           .s2c4_mea_n_0
	  .c4_q_0          (c4_outData),          				//  output,  width = 32,           .s2c4_qb_0
	  
	  .c5_data_0       (c5_inData),       						//   input,  width = 32,           .s2c5_da_0
	  .c5_rdaddress_0  (c5_rdaddress),  						//   input,  width = 17,           .s2c5_adrb_0
	  .c5_rden_n_0     (c5_rden_n),     						//   input,   width = 1,           .s2c5_meb_n_0
	  .c5_sd_n_0       (c5_sden_n),       						//   input,   width = 1,           .s2c5_sd_n_0
	  .c5_wraddress_0  (c5_wraddress),  						//   input,  width = 17,           .s2c5_adra_0
	  .c5_wren_n_0     (c5_wren_n),     						//   input,   width = 1,           .s2c5_mea_n_0
	  .c5_q_0          (c5_outData),          				//  output,  width = 32,           .s2c5_qb_0
	  
	  .c6_data_0       (c6_inData),       						//   input,  width = 32,           .s2c6_da_0
	  .c6_rdaddress_0  (c6_rdaddress),  						//   input,  width = 17,           .s2c6_adrb_0
	  .c6_rden_n_0     (c6_rden_n),     						//   input,   width = 1,           .s2c6_meb_n_0
	  .c6_sd_n_0       (c6_sden_n),       						//   input,   width = 1,           .s2c6_sd_n_0
	  .c6_wraddress_0  (c6_wraddress),  						//   input,  width = 17,           .s2c6_adra_0
	  .c6_wren_n_0     (c6_wren_n),     						//   input,   width = 1,           .s2c6_mea_n_0
	  .c6_q_0          (c6_outData),          				//  output,  width = 32,           .s2c6_qb_0
	  
	  .c7_data_0       (c7_inData),       						//   input,  width = 32,           .s2c7_da_0
	  .c7_rdaddress_0  (c7_rdaddress),  						//   input,  width = 17,           .s2c7_adrb_0
	  .c7_rden_n_0     (c7_rden_n),     						//   input,   width = 1,           .s2c7_meb_n_0
	  .c7_sd_n_0       (c7_sden_n),       						//   input,   width = 1,           .s2c7_sd_n_0
	  .c7_wraddress_0  (c7_wraddress),  						//   input,  width = 17,           .s2c7_adra_0
	  .c7_wren_n_0     (c7_wren_n),     						//   input,   width = 1,           .s2c7_mea_n_0
	  .c7_q_0          (c7_outData)          					//  output,  width = 32,           .s2c7_qb_0
 );
 /*
   i_bretime : bretime
    generic map (
      DEPTH => 13)
    port map (
      reset => rst_i,                   -- in  
      clock => esram_clk_i,             -- in  
      d     => av_read,                 -- in  
      q     => read_waitrequest_n);     -- out
*/

bretime #(
	.DEPTH(13)
)
bretime_0 (
	.reset(),	//in
	.clock(esram_clk),	//in
	.d(av_read),			//in
	.q(read_waitrequest_n)			//out		
);

always @(posedge esram_clk) begin
	if (!esram_clk_locked) begin
		c0_wren_n			<= 1'b1;
		c0_rden_n			<= 1'b1;
		c1_wren_n			<= 1'b1;
		c1_rden_n			<= 1'b1;
		c2_wren_n			<= 1'b1;
		c2_rden_n			<= 1'b1;
		c3_wren_n			<= 1'b1;
		c3_rden_n			<= 1'b1;
		c4_wren_n			<= 1'b1;
		c4_rden_n			<= 1'b1;
		c5_wren_n			<= 1'b1;
		c5_rden_n			<= 1'b1;
		c6_wren_n			<= 1'b1;
		c6_rden_n			<= 1'b1;
		c7_wren_n			<= 1'b1;
		c7_rden_n			<= 1'b1;
		av_waitrequest 	<= 1'b1;
		reset_n          	<= 1'b1;
	end
	else begin
		reset_n          <= 1'b0;
		
		if (isCHANNEL0) begin
			c0_wraddress      <= av_address[16:0];
			c0_rdaddress      <= av_address[16:0];
			c0_wren_n         <= !av_write;
			c0_rden_n         <= !av_read;
			c0_inData         <= av_writedata;
			av_readdata    	<= c0_outData;
		end
		else if (isCHANNEL1) begin
			c1_wraddress      <= av_address[16:0];
			c1_rdaddress      <= av_address[16:0];
			c1_wren_n         <= !av_write;
			c1_rden_n         <= !av_read;
			c1_inData         <= av_writedata;
			av_readdata    	<= c1_outData;
		end
		else if (isCHANNEL2) begin
			c2_wraddress      <= av_address[16:0];
			c2_rdaddress      <= av_address[16:0];
			c2_wren_n         <= !av_write;
			c2_rden_n         <= !av_read;
			c2_inData         <= av_writedata;
			av_readdata    	<= c2_outData;
		end
		else if (isCHANNEL3) begin
			c3_wraddress      <= av_address[16:0];
			c3_rdaddress      <= av_address[16:0];
			c3_wren_n         <= !av_write;
			c3_rden_n         <= !av_read;
			c3_inData         <= av_writedata;
			av_readdata    	<= c3_outData;
		end
		else if (isCHANNEL4) begin
			c4_wraddress      <= av_address[16:0];
			c4_rdaddress      <= av_address[16:0];
			c4_wren_n         <= !av_write;
			c4_rden_n         <= !av_read;
			c4_inData         <= av_writedata;
			av_readdata    	<= c4_outData;
		end
		else if (isCHANNEL5) begin
			c5_wraddress      <= av_address[16:0];
			c5_rdaddress      <= av_address[16:0];
			c5_wren_n         <= !av_write;
			c5_rden_n         <= !av_read;
			c5_inData         <= av_writedata;
			av_readdata    	<= c5_outData;
		end
		else if (isCHANNEL6) begin
			c6_wraddress      <= av_address[16:0];
			c6_rdaddress      <= av_address[16:0];
			c6_wren_n         <= !av_write;
			c6_rden_n         <= !av_read;
			c6_inData         <= av_writedata;
			av_readdata    	<= c6_outData;
		end
		else if (isCHANNEL7) begin
			c7_wraddress      <= av_address[16:0];
			c7_rdaddress      <= av_address[16:0];
			c7_wren_n         <= !av_write;
			c7_rden_n         <= !av_read;
			c7_inData         <= av_writedata;
			av_readdata    	<= c7_outData;
		end
		
		if (av_write == 1'b1)
			av_waitrequest <= 1'b0;
		else if (av_read == 1'b1)
			av_waitrequest <= !read_waitrequest_n;
		else
			av_waitrequest <= 1'b1;
	
	end

end

endmodule