	component s10_clock_mux is
		port (
			inclk0x   : in  std_logic := 'X'; -- clk
			inclk1x   : in  std_logic := 'X'; -- clk
			clkselect : in  std_logic := 'X'; -- export
			outclk    : out std_logic         -- clk
		);
	end component s10_clock_mux;

	u0 : component s10_clock_mux
		port map (
			inclk0x   => CONNECTED_TO_inclk0x,   --   inclk0x.clk
			inclk1x   => CONNECTED_TO_inclk1x,   --   inclk1x.clk
			clkselect => CONNECTED_TO_clkselect, -- clkselect.export
			outclk    => CONNECTED_TO_outclk     --    outclk.clk
		);

