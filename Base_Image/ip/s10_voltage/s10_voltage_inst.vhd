	component s10_voltage is
		port (
			clk               : in  std_logic                     := 'X';             -- clk
			reset             : in  std_logic                     := 'X';             -- reset
			rsp_valid         : out std_logic;                                        -- valid
			rsp_data          : out std_logic_vector(31 downto 0);                    -- data
			rsp_channel       : out std_logic_vector(3 downto 0);                     -- channel
			rsp_startofpacket : out std_logic;                                        -- startofpacket
			rsp_endofpacket   : out std_logic;                                        -- endofpacket
			cmd_valid         : in  std_logic                     := 'X';             -- valid
			cmd_ready         : out std_logic;                                        -- ready
			cmd_data          : in  std_logic_vector(15 downto 0) := (others => 'X')  -- data
		);
	end component s10_voltage;

	u0 : component s10_voltage
		port map (
			clk               => CONNECTED_TO_clk,               --   clk.clk
			reset             => CONNECTED_TO_reset,             -- reset.reset
			rsp_valid         => CONNECTED_TO_rsp_valid,         --   rsp.valid
			rsp_data          => CONNECTED_TO_rsp_data,          --      .data
			rsp_channel       => CONNECTED_TO_rsp_channel,       --      .channel
			rsp_startofpacket => CONNECTED_TO_rsp_startofpacket, --      .startofpacket
			rsp_endofpacket   => CONNECTED_TO_rsp_endofpacket,   --      .endofpacket
			cmd_valid         => CONNECTED_TO_cmd_valid,         --   cmd.valid
			cmd_ready         => CONNECTED_TO_cmd_ready,         --      .ready
			cmd_data          => CONNECTED_TO_cmd_data           --      .data
		);

