	component mem0 is
		port (
			local_reset_req     : in    std_logic                      := 'X';             -- local_reset_req
			local_reset_done    : out   std_logic;                                         -- local_reset_done
			pll_ref_clk         : in    std_logic                      := 'X';             -- clk
			oct_rzqin           : in    std_logic                      := 'X';             -- oct_rzqin
			mem_ck              : out   std_logic_vector(0 downto 0);                      -- mem_ck
			mem_ck_n            : out   std_logic_vector(0 downto 0);                      -- mem_ck_n
			mem_a               : out   std_logic_vector(16 downto 0);                     -- mem_a
			mem_act_n           : out   std_logic_vector(0 downto 0);                      -- mem_act_n
			mem_ba              : out   std_logic_vector(1 downto 0);                      -- mem_ba
			mem_bg              : out   std_logic_vector(1 downto 0);                      -- mem_bg
			mem_cke             : out   std_logic_vector(0 downto 0);                      -- mem_cke
			mem_cs_n            : out   std_logic_vector(0 downto 0);                      -- mem_cs_n
			mem_odt             : out   std_logic_vector(0 downto 0);                      -- mem_odt
			mem_reset_n         : out   std_logic_vector(0 downto 0);                      -- mem_reset_n
			mem_par             : out   std_logic_vector(0 downto 0);                      -- mem_par
			mem_alert_n         : in    std_logic_vector(0 downto 0)   := (others => 'X'); -- mem_alert_n
			mem_dqs             : inout std_logic_vector(17 downto 0)  := (others => 'X'); -- mem_dqs
			mem_dqs_n           : inout std_logic_vector(17 downto 0)  := (others => 'X'); -- mem_dqs_n
			mem_dq              : inout std_logic_vector(71 downto 0)  := (others => 'X'); -- mem_dq
			local_cal_success   : out   std_logic;                                         -- local_cal_success
			local_cal_fail      : out   std_logic;                                         -- local_cal_fail
			emif_usr_reset_n    : out   std_logic;                                         -- reset_n
			emif_usr_clk        : out   std_logic;                                         -- clk
			amm_ready_0         : out   std_logic;                                         -- waitrequest_n
			amm_read_0          : in    std_logic                      := 'X';             -- read
			amm_write_0         : in    std_logic                      := 'X';             -- write
			amm_address_0       : in    std_logic_vector(27 downto 0)  := (others => 'X'); -- address
			amm_readdata_0      : out   std_logic_vector(575 downto 0);                    -- readdata
			amm_writedata_0     : in    std_logic_vector(575 downto 0) := (others => 'X'); -- writedata
			amm_burstcount_0    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			amm_readdatavalid_0 : out   std_logic                                          -- readdatavalid
		);
	end component mem0;

	u0 : component mem0
		port map (
			local_reset_req     => CONNECTED_TO_local_reset_req,     --    local_reset_req.local_reset_req
			local_reset_done    => CONNECTED_TO_local_reset_done,    -- local_reset_status.local_reset_done
			pll_ref_clk         => CONNECTED_TO_pll_ref_clk,         --        pll_ref_clk.clk
			oct_rzqin           => CONNECTED_TO_oct_rzqin,           --                oct.oct_rzqin
			mem_ck              => CONNECTED_TO_mem_ck,              --                mem.mem_ck
			mem_ck_n            => CONNECTED_TO_mem_ck_n,            --                   .mem_ck_n
			mem_a               => CONNECTED_TO_mem_a,               --                   .mem_a
			mem_act_n           => CONNECTED_TO_mem_act_n,           --                   .mem_act_n
			mem_ba              => CONNECTED_TO_mem_ba,              --                   .mem_ba
			mem_bg              => CONNECTED_TO_mem_bg,              --                   .mem_bg
			mem_cke             => CONNECTED_TO_mem_cke,             --                   .mem_cke
			mem_cs_n            => CONNECTED_TO_mem_cs_n,            --                   .mem_cs_n
			mem_odt             => CONNECTED_TO_mem_odt,             --                   .mem_odt
			mem_reset_n         => CONNECTED_TO_mem_reset_n,         --                   .mem_reset_n
			mem_par             => CONNECTED_TO_mem_par,             --                   .mem_par
			mem_alert_n         => CONNECTED_TO_mem_alert_n,         --                   .mem_alert_n
			mem_dqs             => CONNECTED_TO_mem_dqs,             --                   .mem_dqs
			mem_dqs_n           => CONNECTED_TO_mem_dqs_n,           --                   .mem_dqs_n
			mem_dq              => CONNECTED_TO_mem_dq,              --                   .mem_dq
			local_cal_success   => CONNECTED_TO_local_cal_success,   --             status.local_cal_success
			local_cal_fail      => CONNECTED_TO_local_cal_fail,      --                   .local_cal_fail
			emif_usr_reset_n    => CONNECTED_TO_emif_usr_reset_n,    --   emif_usr_reset_n.reset_n
			emif_usr_clk        => CONNECTED_TO_emif_usr_clk,        --       emif_usr_clk.clk
			amm_ready_0         => CONNECTED_TO_amm_ready_0,         --         ctrl_amm_0.waitrequest_n
			amm_read_0          => CONNECTED_TO_amm_read_0,          --                   .read
			amm_write_0         => CONNECTED_TO_amm_write_0,         --                   .write
			amm_address_0       => CONNECTED_TO_amm_address_0,       --                   .address
			amm_readdata_0      => CONNECTED_TO_amm_readdata_0,      --                   .readdata
			amm_writedata_0     => CONNECTED_TO_amm_writedata_0,     --                   .writedata
			amm_burstcount_0    => CONNECTED_TO_amm_burstcount_0,    --                   .burstcount
			amm_readdatavalid_0 => CONNECTED_TO_amm_readdatavalid_0  --                   .readdatavalid
		);

