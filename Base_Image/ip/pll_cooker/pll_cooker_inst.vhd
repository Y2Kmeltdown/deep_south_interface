	component pll_cooker is
		port (
			rst      : in  std_logic := 'X'; -- reset
			refclk   : in  std_logic := 'X'; -- clk
			locked   : out std_logic;        -- export
			outclk_0 : out std_logic         -- clk
		);
	end component pll_cooker;

	u0 : component pll_cooker
		port map (
			rst      => CONNECTED_TO_rst,      --   reset.reset
			refclk   => CONNECTED_TO_refclk,   --  refclk.clk
			locked   => CONNECTED_TO_locked,   --  locked.export
			outclk_0 => CONNECTED_TO_outclk_0  -- outclk0.clk
		);

