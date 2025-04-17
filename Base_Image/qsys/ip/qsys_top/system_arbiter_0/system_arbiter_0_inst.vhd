	component system_arbiter_0 is
		port (
			clk                : in  std_logic                     := 'X';             -- clk
			reset              : in  std_logic                     := 'X';             -- reset
			avs_s0_address     : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- address
			avs_s0_read        : in  std_logic                     := 'X';             -- read
			avs_s0_readdata    : out std_logic_vector(31 downto 0);                    -- readdata
			avs_s0_write       : in  std_logic                     := 'X';             -- write
			avs_s0_writedata   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			avs_s0_waitrequest : out std_logic;                                        -- waitrequest
			hps_gp_o           : in  std_logic_vector(31 downto 0) := (others => 'X'); -- gp_out
			hps_gp_i           : out std_logic_vector(31 downto 0)                     -- gp_in
		);
	end component system_arbiter_0;

	u0 : component system_arbiter_0
		port map (
			clk                => CONNECTED_TO_clk,                --     clock.clk
			reset              => CONNECTED_TO_reset,              --     reset.reset
			avs_s0_address     => CONNECTED_TO_avs_s0_address,     --        s0.address
			avs_s0_read        => CONNECTED_TO_avs_s0_read,        --          .read
			avs_s0_readdata    => CONNECTED_TO_avs_s0_readdata,    --          .readdata
			avs_s0_write       => CONNECTED_TO_avs_s0_write,       --          .write
			avs_s0_writedata   => CONNECTED_TO_avs_s0_writedata,   --          .writedata
			avs_s0_waitrequest => CONNECTED_TO_avs_s0_waitrequest, --          .waitrequest
			hps_gp_o           => CONNECTED_TO_hps_gp_o,           -- hps_gp_if.gp_out
			hps_gp_i           => CONNECTED_TO_hps_gp_i            --          .gp_in
		);

