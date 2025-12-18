	component ed_synth is
		port (
			bottom_core_clk_iopll_reset_reset       : in  std_logic                    := 'X';             -- reset
			bottom_core_clk_iopll_refclk_clk        : in  std_logic                    := 'X';             -- clk
			bottom_pll_ref_clk_clk                  : in  std_logic                    := 'X';             -- clk
			bottom_wmcrst_n_in_reset_n              : in  std_logic                    := 'X';             -- reset_n
			bottom_only_reset_in_reset              : in  std_logic                    := 'X';             -- reset
			bottom_m2u_bridge_cattrip               : in  std_logic                    := 'X';             -- cattrip
			bottom_m2u_bridge_temp                  : in  std_logic_vector(2 downto 0) := (others => 'X'); -- temp
			bottom_m2u_bridge_wso                   : in  std_logic_vector(7 downto 0) := (others => 'X'); -- wso
			bottom_m2u_bridge_reset_n               : out std_logic;                                       -- reset_n
			bottom_m2u_bridge_wrst_n                : out std_logic;                                       -- wrst_n
			bottom_m2u_bridge_wrck                  : out std_logic;                                       -- wrck
			bottom_m2u_bridge_shiftwr               : out std_logic;                                       -- shiftwr
			bottom_m2u_bridge_capturewr             : out std_logic;                                       -- capturewr
			bottom_m2u_bridge_updatewr              : out std_logic;                                       -- updatewr
			bottom_m2u_bridge_selectwir             : out std_logic;                                       -- selectwir
			bottom_m2u_bridge_wsi                   : out std_logic;                                       -- wsi
			top_pll_ref_clk_clk                     : in  std_logic                    := 'X';             -- clk
			top_wmcrst_n_in_reset_n                 : in  std_logic                    := 'X';             -- reset_n
			top_only_reset_in_reset                 : in  std_logic                    := 'X';             -- reset
			top_m2u_bridge_cattrip                  : in  std_logic                    := 'X';             -- cattrip
			top_m2u_bridge_temp                     : in  std_logic_vector(2 downto 0) := (others => 'X'); -- temp
			top_m2u_bridge_wso                      : in  std_logic_vector(7 downto 0) := (others => 'X'); -- wso
			top_m2u_bridge_reset_n                  : out std_logic;                                       -- reset_n
			top_m2u_bridge_wrst_n                   : out std_logic;                                       -- wrst_n
			top_m2u_bridge_wrck                     : out std_logic;                                       -- wrck
			top_m2u_bridge_shiftwr                  : out std_logic;                                       -- shiftwr
			top_m2u_bridge_capturewr                : out std_logic;                                       -- capturewr
			top_m2u_bridge_updatewr                 : out std_logic;                                       -- updatewr
			top_m2u_bridge_selectwir                : out std_logic;                                       -- selectwir
			top_m2u_bridge_wsi                      : out std_logic;                                       -- wsi
			tg_bottom0_0_status_traffic_gen_pass    : out std_logic;                                       -- traffic_gen_pass
			tg_bottom0_0_status_traffic_gen_fail    : out std_logic;                                       -- traffic_gen_fail
			tg_bottom0_0_status_traffic_gen_timeout : out std_logic;                                       -- traffic_gen_timeout
			tg_bottom0_1_status_traffic_gen_pass    : out std_logic;                                       -- traffic_gen_pass
			tg_bottom0_1_status_traffic_gen_fail    : out std_logic;                                       -- traffic_gen_fail
			tg_bottom0_1_status_traffic_gen_timeout : out std_logic;                                       -- traffic_gen_timeout
			tg_top0_0_status_traffic_gen_pass       : out std_logic;                                       -- traffic_gen_pass
			tg_top0_0_status_traffic_gen_fail       : out std_logic;                                       -- traffic_gen_fail
			tg_top0_0_status_traffic_gen_timeout    : out std_logic;                                       -- traffic_gen_timeout
			tg_top0_1_status_traffic_gen_pass       : out std_logic;                                       -- traffic_gen_pass
			tg_top0_1_status_traffic_gen_fail       : out std_logic;                                       -- traffic_gen_fail
			tg_top0_1_status_traffic_gen_timeout    : out std_logic;                                       -- traffic_gen_timeout
			top_core_clk_iopll_reset_reset          : in  std_logic                    := 'X';             -- reset
			top_core_clk_iopll_ref_clk_clk          : in  std_logic                    := 'X'              -- clk
		);
	end component ed_synth;

	u0 : component ed_synth
		port map (
			bottom_core_clk_iopll_reset_reset       => CONNECTED_TO_bottom_core_clk_iopll_reset_reset,       --  bottom_core_clk_iopll_reset.reset
			bottom_core_clk_iopll_refclk_clk        => CONNECTED_TO_bottom_core_clk_iopll_refclk_clk,        -- bottom_core_clk_iopll_refclk.clk
			bottom_pll_ref_clk_clk                  => CONNECTED_TO_bottom_pll_ref_clk_clk,                  --           bottom_pll_ref_clk.clk
			bottom_wmcrst_n_in_reset_n              => CONNECTED_TO_bottom_wmcrst_n_in_reset_n,              --           bottom_wmcrst_n_in.reset_n
			bottom_only_reset_in_reset              => CONNECTED_TO_bottom_only_reset_in_reset,              --         bottom_only_reset_in.reset
			bottom_m2u_bridge_cattrip               => CONNECTED_TO_bottom_m2u_bridge_cattrip,               --            bottom_m2u_bridge.cattrip
			bottom_m2u_bridge_temp                  => CONNECTED_TO_bottom_m2u_bridge_temp,                  --                             .temp
			bottom_m2u_bridge_wso                   => CONNECTED_TO_bottom_m2u_bridge_wso,                   --                             .wso
			bottom_m2u_bridge_reset_n               => CONNECTED_TO_bottom_m2u_bridge_reset_n,               --                             .reset_n
			bottom_m2u_bridge_wrst_n                => CONNECTED_TO_bottom_m2u_bridge_wrst_n,                --                             .wrst_n
			bottom_m2u_bridge_wrck                  => CONNECTED_TO_bottom_m2u_bridge_wrck,                  --                             .wrck
			bottom_m2u_bridge_shiftwr               => CONNECTED_TO_bottom_m2u_bridge_shiftwr,               --                             .shiftwr
			bottom_m2u_bridge_capturewr             => CONNECTED_TO_bottom_m2u_bridge_capturewr,             --                             .capturewr
			bottom_m2u_bridge_updatewr              => CONNECTED_TO_bottom_m2u_bridge_updatewr,              --                             .updatewr
			bottom_m2u_bridge_selectwir             => CONNECTED_TO_bottom_m2u_bridge_selectwir,             --                             .selectwir
			bottom_m2u_bridge_wsi                   => CONNECTED_TO_bottom_m2u_bridge_wsi,                   --                             .wsi
			top_pll_ref_clk_clk                     => CONNECTED_TO_top_pll_ref_clk_clk,                     --              top_pll_ref_clk.clk
			top_wmcrst_n_in_reset_n                 => CONNECTED_TO_top_wmcrst_n_in_reset_n,                 --              top_wmcrst_n_in.reset_n
			top_only_reset_in_reset                 => CONNECTED_TO_top_only_reset_in_reset,                 --            top_only_reset_in.reset
			top_m2u_bridge_cattrip                  => CONNECTED_TO_top_m2u_bridge_cattrip,                  --               top_m2u_bridge.cattrip
			top_m2u_bridge_temp                     => CONNECTED_TO_top_m2u_bridge_temp,                     --                             .temp
			top_m2u_bridge_wso                      => CONNECTED_TO_top_m2u_bridge_wso,                      --                             .wso
			top_m2u_bridge_reset_n                  => CONNECTED_TO_top_m2u_bridge_reset_n,                  --                             .reset_n
			top_m2u_bridge_wrst_n                   => CONNECTED_TO_top_m2u_bridge_wrst_n,                   --                             .wrst_n
			top_m2u_bridge_wrck                     => CONNECTED_TO_top_m2u_bridge_wrck,                     --                             .wrck
			top_m2u_bridge_shiftwr                  => CONNECTED_TO_top_m2u_bridge_shiftwr,                  --                             .shiftwr
			top_m2u_bridge_capturewr                => CONNECTED_TO_top_m2u_bridge_capturewr,                --                             .capturewr
			top_m2u_bridge_updatewr                 => CONNECTED_TO_top_m2u_bridge_updatewr,                 --                             .updatewr
			top_m2u_bridge_selectwir                => CONNECTED_TO_top_m2u_bridge_selectwir,                --                             .selectwir
			top_m2u_bridge_wsi                      => CONNECTED_TO_top_m2u_bridge_wsi,                      --                             .wsi
			tg_bottom0_0_status_traffic_gen_pass    => CONNECTED_TO_tg_bottom0_0_status_traffic_gen_pass,    --          tg_bottom0_0_status.traffic_gen_pass
			tg_bottom0_0_status_traffic_gen_fail    => CONNECTED_TO_tg_bottom0_0_status_traffic_gen_fail,    --                             .traffic_gen_fail
			tg_bottom0_0_status_traffic_gen_timeout => CONNECTED_TO_tg_bottom0_0_status_traffic_gen_timeout, --                             .traffic_gen_timeout
			tg_bottom0_1_status_traffic_gen_pass    => CONNECTED_TO_tg_bottom0_1_status_traffic_gen_pass,    --          tg_bottom0_1_status.traffic_gen_pass
			tg_bottom0_1_status_traffic_gen_fail    => CONNECTED_TO_tg_bottom0_1_status_traffic_gen_fail,    --                             .traffic_gen_fail
			tg_bottom0_1_status_traffic_gen_timeout => CONNECTED_TO_tg_bottom0_1_status_traffic_gen_timeout, --                             .traffic_gen_timeout
			tg_top0_0_status_traffic_gen_pass       => CONNECTED_TO_tg_top0_0_status_traffic_gen_pass,       --             tg_top0_0_status.traffic_gen_pass
			tg_top0_0_status_traffic_gen_fail       => CONNECTED_TO_tg_top0_0_status_traffic_gen_fail,       --                             .traffic_gen_fail
			tg_top0_0_status_traffic_gen_timeout    => CONNECTED_TO_tg_top0_0_status_traffic_gen_timeout,    --                             .traffic_gen_timeout
			tg_top0_1_status_traffic_gen_pass       => CONNECTED_TO_tg_top0_1_status_traffic_gen_pass,       --             tg_top0_1_status.traffic_gen_pass
			tg_top0_1_status_traffic_gen_fail       => CONNECTED_TO_tg_top0_1_status_traffic_gen_fail,       --                             .traffic_gen_fail
			tg_top0_1_status_traffic_gen_timeout    => CONNECTED_TO_tg_top0_1_status_traffic_gen_timeout,    --                             .traffic_gen_timeout
			top_core_clk_iopll_reset_reset          => CONNECTED_TO_top_core_clk_iopll_reset_reset,          --     top_core_clk_iopll_reset.reset
			top_core_clk_iopll_ref_clk_clk          => CONNECTED_TO_top_core_clk_iopll_ref_clk_clk           --   top_core_clk_iopll_ref_clk.clk
		);

