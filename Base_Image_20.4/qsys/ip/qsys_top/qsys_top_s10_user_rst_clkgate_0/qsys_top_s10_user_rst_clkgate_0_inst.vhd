	component qsys_top_s10_user_rst_clkgate_0 is
		generic (
			DEVICE_FAMILY : string := "Stratix 10"
		);
		port (
			ninit_done : out std_logic   -- ninit_done
		);
	end component qsys_top_s10_user_rst_clkgate_0;

	u0 : component qsys_top_s10_user_rst_clkgate_0
		generic map (
			DEVICE_FAMILY => STRING_VALUE_FOR_DEVICE_FAMILY
		)
		port map (
			ninit_done => CONNECTED_TO_ninit_done  -- ninit_done.ninit_done
		);

