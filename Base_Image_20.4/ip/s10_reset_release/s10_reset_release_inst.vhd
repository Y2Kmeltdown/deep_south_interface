	component s10_reset_release is
		generic (
			DEVICE_FAMILY : string := "Stratix 10"
		);
		port (
			ninit_done : out std_logic   -- ninit_done
		);
	end component s10_reset_release;

	u0 : component s10_reset_release
		generic map (
			DEVICE_FAMILY => STRING_VALUE_FOR_DEVICE_FAMILY
		)
		port map (
			ninit_done => CONNECTED_TO_ninit_done  -- ninit_done.ninit_done
		);

