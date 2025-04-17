	component xcvr_atxpll_prod is
		port (
			pll_refclk0       : in  std_logic := 'X'; -- clk
			tx_serial_clk_gxt : out std_logic;        -- clk
			pll_locked        : out std_logic;        -- pll_locked
			pll_cal_busy      : out std_logic         -- pll_cal_busy
		);
	end component xcvr_atxpll_prod;

	u0 : component xcvr_atxpll_prod
		port map (
			pll_refclk0       => CONNECTED_TO_pll_refclk0,       --       pll_refclk0.clk
			tx_serial_clk_gxt => CONNECTED_TO_tx_serial_clk_gxt, -- tx_serial_clk_gxt.clk
			pll_locked        => CONNECTED_TO_pll_locked,        --        pll_locked.pll_locked
			pll_cal_busy      => CONNECTED_TO_pll_cal_busy       --      pll_cal_busy.pll_cal_busy
		);

