	component system_manager is
		port (
			config_clk_clk                          : in    std_logic                     := 'X';             -- clk
			config_rstn_reset_n                     : in    std_logic                     := 'X';             -- reset_n
			system_mm_waitrequest                   : out   std_logic;                                        -- waitrequest
			system_mm_readdata                      : out   std_logic_vector(31 downto 0);                    -- readdata
			system_mm_readdatavalid                 : out   std_logic;                                        -- readdatavalid
			system_mm_burstcount                    : in    std_logic_vector(0 downto 0)  := (others => 'X'); -- burstcount
			system_mm_writedata                     : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			system_mm_address                       : in    std_logic_vector(12 downto 0) := (others => 'X'); -- address
			system_mm_write                         : in    std_logic                     := 'X';             -- write
			system_mm_read                          : in    std_logic                     := 'X';             -- read
			system_mm_byteenable                    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			system_mm_debugaccess                   : in    std_logic                     := 'X';             -- debugaccess
			conf_d_conf_d                           : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- conf_d
			soft_recfg_req_n_soft_reconfigure_req_n : out   std_logic;                                        -- soft_reconfigure_req_n
			conf_c_out_conf_c_out                   : out   std_logic_vector(3 downto 0);                     -- conf_c_out
			conf_c_in_conf_c_in                     : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- conf_c_in
			user_clk_clk                            : in    std_logic                     := 'X';             -- clk
			user_rstn_reset_n                       : in    std_logic                     := 'X'              -- reset_n
		);
	end component system_manager;

	u0 : component system_manager
		port map (
			config_clk_clk                          => CONNECTED_TO_config_clk_clk,                          --       config_clk.clk
			config_rstn_reset_n                     => CONNECTED_TO_config_rstn_reset_n,                     --      config_rstn.reset_n
			system_mm_waitrequest                   => CONNECTED_TO_system_mm_waitrequest,                   --        system_mm.waitrequest
			system_mm_readdata                      => CONNECTED_TO_system_mm_readdata,                      --                 .readdata
			system_mm_readdatavalid                 => CONNECTED_TO_system_mm_readdatavalid,                 --                 .readdatavalid
			system_mm_burstcount                    => CONNECTED_TO_system_mm_burstcount,                    --                 .burstcount
			system_mm_writedata                     => CONNECTED_TO_system_mm_writedata,                     --                 .writedata
			system_mm_address                       => CONNECTED_TO_system_mm_address,                       --                 .address
			system_mm_write                         => CONNECTED_TO_system_mm_write,                         --                 .write
			system_mm_read                          => CONNECTED_TO_system_mm_read,                          --                 .read
			system_mm_byteenable                    => CONNECTED_TO_system_mm_byteenable,                    --                 .byteenable
			system_mm_debugaccess                   => CONNECTED_TO_system_mm_debugaccess,                   --                 .debugaccess
			conf_d_conf_d                           => CONNECTED_TO_conf_d_conf_d,                           --           conf_d.conf_d
			soft_recfg_req_n_soft_reconfigure_req_n => CONNECTED_TO_soft_recfg_req_n_soft_reconfigure_req_n, -- soft_recfg_req_n.soft_reconfigure_req_n
			conf_c_out_conf_c_out                   => CONNECTED_TO_conf_c_out_conf_c_out,                   --       conf_c_out.conf_c_out
			conf_c_in_conf_c_in                     => CONNECTED_TO_conf_c_in_conf_c_in,                     --        conf_c_in.conf_c_in
			user_clk_clk                            => CONNECTED_TO_user_clk_clk,                            --         user_clk.clk
			user_rstn_reset_n                       => CONNECTED_TO_user_rstn_reset_n                        --        user_rstn.reset_n
		);

