	component s10_chip_id is
		port (
			clk        : in  std_logic                     := 'X'; -- clk
			reset      : in  std_logic                     := 'X'; -- reset
			data_valid : out std_logic;                            -- valid
			chip_id    : out std_logic_vector(63 downto 0);        -- data
			readid     : in  std_logic                     := 'X'  -- readid
		);
	end component s10_chip_id;

	u0 : component s10_chip_id
		port map (
			clk        => CONNECTED_TO_clk,        --    clk.clk
			reset      => CONNECTED_TO_reset,      --  reset.reset
			data_valid => CONNECTED_TO_data_valid, -- output.valid
			chip_id    => CONNECTED_TO_chip_id,    --       .data
			readid     => CONNECTED_TO_readid      -- readid.readid
		);

