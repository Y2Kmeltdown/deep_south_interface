	component qsys_top_hbm_0 is
		port (
			pll_ref_clk                : in    std_logic                      := 'X';             -- clk
			ext_core_clk               : in    std_logic                      := 'X';             -- clk
			ext_core_clk_locked        : in    std_logic                      := 'X';             -- export
			wmcrst_n_in                : in    std_logic                      := 'X';             -- reset_n
			hbm_only_reset_in          : in    std_logic                      := 'X';             -- reset
			local_cal_success          : out   std_logic;                                         -- local_cal_success
			local_cal_fail             : out   std_logic;                                         -- local_cal_fail
			cal_lat                    : out   std_logic_vector(2 downto 0);                      -- cal_lat
			ck_t_0                     : out   std_logic;                                         -- ck_t
			ck_c_0                     : out   std_logic;                                         -- ck_c
			cke_0                      : out   std_logic;                                         -- cke
			c_0                        : out   std_logic_vector(7 downto 0);                      -- c
			r_0                        : out   std_logic_vector(5 downto 0);                      -- r
			dq_0                       : inout std_logic_vector(127 downto 0) := (others => 'X'); -- dq
			dm_0                       : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dm
			dbi_0                      : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dbi
			par_0                      : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- par
			derr_0                     : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- derr
			rdqs_t_0                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_t
			rdqs_c_0                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_c
			wdqs_t_0                   : out   std_logic_vector(3 downto 0);                      -- wdqs_t
			wdqs_c_0                   : out   std_logic_vector(3 downto 0);                      -- wdqs_c
			rd_0                       : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- rd
			rr_0                       : out   std_logic;                                         -- rr
			rc_0                       : out   std_logic;                                         -- rc
			aerr_0                     : in    std_logic                      := 'X';             -- aerr
			ck_t_1                     : out   std_logic;                                         -- ck_t
			ck_c_1                     : out   std_logic;                                         -- ck_c
			cke_1                      : out   std_logic;                                         -- cke
			c_1                        : out   std_logic_vector(7 downto 0);                      -- c
			r_1                        : out   std_logic_vector(5 downto 0);                      -- r
			dq_1                       : inout std_logic_vector(127 downto 0) := (others => 'X'); -- dq
			dm_1                       : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dm
			dbi_1                      : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dbi
			par_1                      : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- par
			derr_1                     : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- derr
			rdqs_t_1                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_t
			rdqs_c_1                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_c
			wdqs_t_1                   : out   std_logic_vector(3 downto 0);                      -- wdqs_t
			wdqs_c_1                   : out   std_logic_vector(3 downto 0);                      -- wdqs_c
			rd_1                       : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- rd
			rr_1                       : out   std_logic;                                         -- rr
			rc_1                       : out   std_logic;                                         -- rc
			aerr_1                     : in    std_logic                      := 'X';             -- aerr
			ck_t_2                     : out   std_logic;                                         -- ck_t
			ck_c_2                     : out   std_logic;                                         -- ck_c
			cke_2                      : out   std_logic;                                         -- cke
			c_2                        : out   std_logic_vector(7 downto 0);                      -- c
			r_2                        : out   std_logic_vector(5 downto 0);                      -- r
			dq_2                       : inout std_logic_vector(127 downto 0) := (others => 'X'); -- dq
			dm_2                       : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dm
			dbi_2                      : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dbi
			par_2                      : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- par
			derr_2                     : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- derr
			rdqs_t_2                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_t
			rdqs_c_2                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_c
			wdqs_t_2                   : out   std_logic_vector(3 downto 0);                      -- wdqs_t
			wdqs_c_2                   : out   std_logic_vector(3 downto 0);                      -- wdqs_c
			rd_2                       : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- rd
			rr_2                       : out   std_logic;                                         -- rr
			rc_2                       : out   std_logic;                                         -- rc
			aerr_2                     : in    std_logic                      := 'X';             -- aerr
			ck_t_3                     : out   std_logic;                                         -- ck_t
			ck_c_3                     : out   std_logic;                                         -- ck_c
			cke_3                      : out   std_logic;                                         -- cke
			c_3                        : out   std_logic_vector(7 downto 0);                      -- c
			r_3                        : out   std_logic_vector(5 downto 0);                      -- r
			dq_3                       : inout std_logic_vector(127 downto 0) := (others => 'X'); -- dq
			dm_3                       : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dm
			dbi_3                      : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dbi
			par_3                      : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- par
			derr_3                     : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- derr
			rdqs_t_3                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_t
			rdqs_c_3                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_c
			wdqs_t_3                   : out   std_logic_vector(3 downto 0);                      -- wdqs_t
			wdqs_c_3                   : out   std_logic_vector(3 downto 0);                      -- wdqs_c
			rd_3                       : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- rd
			rr_3                       : out   std_logic;                                         -- rr
			rc_3                       : out   std_logic;                                         -- rc
			aerr_3                     : in    std_logic                      := 'X';             -- aerr
			ck_t_4                     : out   std_logic;                                         -- ck_t
			ck_c_4                     : out   std_logic;                                         -- ck_c
			cke_4                      : out   std_logic;                                         -- cke
			c_4                        : out   std_logic_vector(7 downto 0);                      -- c
			r_4                        : out   std_logic_vector(5 downto 0);                      -- r
			dq_4                       : inout std_logic_vector(127 downto 0) := (others => 'X'); -- dq
			dm_4                       : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dm
			dbi_4                      : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dbi
			par_4                      : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- par
			derr_4                     : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- derr
			rdqs_t_4                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_t
			rdqs_c_4                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_c
			wdqs_t_4                   : out   std_logic_vector(3 downto 0);                      -- wdqs_t
			wdqs_c_4                   : out   std_logic_vector(3 downto 0);                      -- wdqs_c
			rd_4                       : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- rd
			rr_4                       : out   std_logic;                                         -- rr
			rc_4                       : out   std_logic;                                         -- rc
			aerr_4                     : in    std_logic                      := 'X';             -- aerr
			ck_t_5                     : out   std_logic;                                         -- ck_t
			ck_c_5                     : out   std_logic;                                         -- ck_c
			cke_5                      : out   std_logic;                                         -- cke
			c_5                        : out   std_logic_vector(7 downto 0);                      -- c
			r_5                        : out   std_logic_vector(5 downto 0);                      -- r
			dq_5                       : inout std_logic_vector(127 downto 0) := (others => 'X'); -- dq
			dm_5                       : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dm
			dbi_5                      : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dbi
			par_5                      : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- par
			derr_5                     : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- derr
			rdqs_t_5                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_t
			rdqs_c_5                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_c
			wdqs_t_5                   : out   std_logic_vector(3 downto 0);                      -- wdqs_t
			wdqs_c_5                   : out   std_logic_vector(3 downto 0);                      -- wdqs_c
			rd_5                       : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- rd
			rr_5                       : out   std_logic;                                         -- rr
			rc_5                       : out   std_logic;                                         -- rc
			aerr_5                     : in    std_logic                      := 'X';             -- aerr
			ck_t_6                     : out   std_logic;                                         -- ck_t
			ck_c_6                     : out   std_logic;                                         -- ck_c
			cke_6                      : out   std_logic;                                         -- cke
			c_6                        : out   std_logic_vector(7 downto 0);                      -- c
			r_6                        : out   std_logic_vector(5 downto 0);                      -- r
			dq_6                       : inout std_logic_vector(127 downto 0) := (others => 'X'); -- dq
			dm_6                       : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dm
			dbi_6                      : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dbi
			par_6                      : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- par
			derr_6                     : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- derr
			rdqs_t_6                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_t
			rdqs_c_6                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_c
			wdqs_t_6                   : out   std_logic_vector(3 downto 0);                      -- wdqs_t
			wdqs_c_6                   : out   std_logic_vector(3 downto 0);                      -- wdqs_c
			rd_6                       : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- rd
			rr_6                       : out   std_logic;                                         -- rr
			rc_6                       : out   std_logic;                                         -- rc
			aerr_6                     : in    std_logic                      := 'X';             -- aerr
			ck_t_7                     : out   std_logic;                                         -- ck_t
			ck_c_7                     : out   std_logic;                                         -- ck_c
			cke_7                      : out   std_logic;                                         -- cke
			c_7                        : out   std_logic_vector(7 downto 0);                      -- c
			r_7                        : out   std_logic_vector(5 downto 0);                      -- r
			dq_7                       : inout std_logic_vector(127 downto 0) := (others => 'X'); -- dq
			dm_7                       : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dm
			dbi_7                      : inout std_logic_vector(15 downto 0)  := (others => 'X'); -- dbi
			par_7                      : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- par
			derr_7                     : inout std_logic_vector(3 downto 0)   := (others => 'X'); -- derr
			rdqs_t_7                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_t
			rdqs_c_7                   : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- rdqs_c
			wdqs_t_7                   : out   std_logic_vector(3 downto 0);                      -- wdqs_t
			wdqs_c_7                   : out   std_logic_vector(3 downto 0);                      -- wdqs_c
			rd_7                       : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- rd
			rr_7                       : out   std_logic;                                         -- rr
			rc_7                       : out   std_logic;                                         -- rc
			aerr_7                     : in    std_logic                      := 'X';             -- aerr
			cattrip                    : in    std_logic                      := 'X';             -- cattrip
			temp                       : in    std_logic_vector(2 downto 0)   := (others => 'X'); -- temp
			wso                        : in    std_logic_vector(7 downto 0)   := (others => 'X'); -- wso
			reset_n                    : out   std_logic;                                         -- reset_n
			wrst_n                     : out   std_logic;                                         -- wrst_n
			wrck                       : out   std_logic;                                         -- wrck
			shiftwr                    : out   std_logic;                                         -- shiftwr
			capturewr                  : out   std_logic;                                         -- capturewr
			updatewr                   : out   std_logic;                                         -- updatewr
			selectwir                  : out   std_logic;                                         -- selectwir
			wsi                        : out   std_logic;                                         -- wsi
			wmc_clk_0_clk              : out   std_logic;                                         -- clk
			wmc_clk_1_clk              : out   std_logic;                                         -- clk
			phy_clk_0_clk              : out   std_logic;                                         -- clk
			phy_clk_1_clk              : out   std_logic;                                         -- clk
			wmcrst_n_0_reset_n         : out   std_logic;                                         -- reset_n
			wmcrst_n_1_reset_n         : out   std_logic;                                         -- reset_n
			ctrl_amm_0_0_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_0_0_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_0_0_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_0_0_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_0_0_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_0_0_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_0_0_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_0_0_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_0_0_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_0_1_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_0_1_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_0_1_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_0_1_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_0_1_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_0_1_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_0_1_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_0_1_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_0_1_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_1_0_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_1_0_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_1_0_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_1_0_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_1_0_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_1_0_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_1_0_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_1_0_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_1_0_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_1_1_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_1_1_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_1_1_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_1_1_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_1_1_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_1_1_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_1_1_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_1_1_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_1_1_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_ecc_readdataerror_0_0 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_0_1 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_1_0 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_1_1 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			apb_0_ur_paddr             : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_paddr
			apb_0_ur_psel              : in    std_logic                      := 'X';             -- ur_psel
			apb_0_ur_penable           : in    std_logic                      := 'X';             -- ur_penable
			apb_0_ur_pwrite            : in    std_logic                      := 'X';             -- ur_pwrite
			apb_0_ur_pwdata            : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_pwdata
			apb_0_ur_pstrb             : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- ur_pstrb
			apb_0_ur_prready           : out   std_logic;                                         -- ur_prready
			apb_0_ur_prdata            : out   std_logic_vector(15 downto 0);                     -- ur_prdata
			apb_1_ur_paddr             : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_paddr
			apb_1_ur_psel              : in    std_logic                      := 'X';             -- ur_psel
			apb_1_ur_penable           : in    std_logic                      := 'X';             -- ur_penable
			apb_1_ur_pwrite            : in    std_logic                      := 'X';             -- ur_pwrite
			apb_1_ur_pwdata            : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_pwdata
			apb_1_ur_pstrb             : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- ur_pstrb
			apb_1_ur_prready           : out   std_logic;                                         -- ur_prready
			apb_1_ur_prdata            : out   std_logic_vector(15 downto 0);                     -- ur_prdata
			wmc_clk_2_clk              : out   std_logic;                                         -- clk
			wmc_clk_3_clk              : out   std_logic;                                         -- clk
			phy_clk_2_clk              : out   std_logic;                                         -- clk
			phy_clk_3_clk              : out   std_logic;                                         -- clk
			wmcrst_n_2_reset_n         : out   std_logic;                                         -- reset_n
			wmcrst_n_3_reset_n         : out   std_logic;                                         -- reset_n
			ctrl_amm_2_0_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_2_0_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_2_0_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_2_0_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_2_0_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_2_0_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_2_0_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_2_0_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_2_0_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_2_1_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_2_1_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_2_1_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_2_1_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_2_1_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_2_1_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_2_1_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_2_1_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_2_1_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_3_0_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_3_0_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_3_0_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_3_0_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_3_0_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_3_0_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_3_0_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_3_0_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_3_0_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_3_1_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_3_1_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_3_1_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_3_1_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_3_1_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_3_1_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_3_1_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_3_1_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_3_1_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_ecc_readdataerror_2_0 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_2_1 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_3_0 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_3_1 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			apb_2_ur_paddr             : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_paddr
			apb_2_ur_psel              : in    std_logic                      := 'X';             -- ur_psel
			apb_2_ur_penable           : in    std_logic                      := 'X';             -- ur_penable
			apb_2_ur_pwrite            : in    std_logic                      := 'X';             -- ur_pwrite
			apb_2_ur_pwdata            : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_pwdata
			apb_2_ur_pstrb             : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- ur_pstrb
			apb_2_ur_prready           : out   std_logic;                                         -- ur_prready
			apb_2_ur_prdata            : out   std_logic_vector(15 downto 0);                     -- ur_prdata
			apb_3_ur_paddr             : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_paddr
			apb_3_ur_psel              : in    std_logic                      := 'X';             -- ur_psel
			apb_3_ur_penable           : in    std_logic                      := 'X';             -- ur_penable
			apb_3_ur_pwrite            : in    std_logic                      := 'X';             -- ur_pwrite
			apb_3_ur_pwdata            : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_pwdata
			apb_3_ur_pstrb             : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- ur_pstrb
			apb_3_ur_prready           : out   std_logic;                                         -- ur_prready
			apb_3_ur_prdata            : out   std_logic_vector(15 downto 0);                     -- ur_prdata
			wmc_clk_4_clk              : out   std_logic;                                         -- clk
			wmc_clk_5_clk              : out   std_logic;                                         -- clk
			phy_clk_4_clk              : out   std_logic;                                         -- clk
			phy_clk_5_clk              : out   std_logic;                                         -- clk
			wmcrst_n_4_reset_n         : out   std_logic;                                         -- reset_n
			wmcrst_n_5_reset_n         : out   std_logic;                                         -- reset_n
			ctrl_amm_4_0_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_4_0_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_4_0_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_4_0_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_4_0_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_4_0_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_4_0_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_4_0_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_4_0_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_4_1_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_4_1_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_4_1_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_4_1_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_4_1_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_4_1_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_4_1_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_4_1_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_4_1_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_5_0_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_5_0_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_5_0_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_5_0_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_5_0_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_5_0_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_5_0_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_5_0_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_5_0_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_5_1_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_5_1_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_5_1_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_5_1_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_5_1_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_5_1_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_5_1_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_5_1_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_5_1_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_ecc_readdataerror_4_0 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_4_1 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_5_0 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_5_1 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			apb_4_ur_paddr             : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_paddr
			apb_4_ur_psel              : in    std_logic                      := 'X';             -- ur_psel
			apb_4_ur_penable           : in    std_logic                      := 'X';             -- ur_penable
			apb_4_ur_pwrite            : in    std_logic                      := 'X';             -- ur_pwrite
			apb_4_ur_pwdata            : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_pwdata
			apb_4_ur_pstrb             : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- ur_pstrb
			apb_4_ur_prready           : out   std_logic;                                         -- ur_prready
			apb_4_ur_prdata            : out   std_logic_vector(15 downto 0);                     -- ur_prdata
			apb_5_ur_paddr             : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_paddr
			apb_5_ur_psel              : in    std_logic                      := 'X';             -- ur_psel
			apb_5_ur_penable           : in    std_logic                      := 'X';             -- ur_penable
			apb_5_ur_pwrite            : in    std_logic                      := 'X';             -- ur_pwrite
			apb_5_ur_pwdata            : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_pwdata
			apb_5_ur_pstrb             : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- ur_pstrb
			apb_5_ur_prready           : out   std_logic;                                         -- ur_prready
			apb_5_ur_prdata            : out   std_logic_vector(15 downto 0);                     -- ur_prdata
			wmc_clk_6_clk              : out   std_logic;                                         -- clk
			wmc_clk_7_clk              : out   std_logic;                                         -- clk
			phy_clk_6_clk              : out   std_logic;                                         -- clk
			phy_clk_7_clk              : out   std_logic;                                         -- clk
			wmcrst_n_6_reset_n         : out   std_logic;                                         -- reset_n
			wmcrst_n_7_reset_n         : out   std_logic;                                         -- reset_n
			ctrl_amm_6_0_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_6_0_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_6_0_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_6_0_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_6_0_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_6_0_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_6_0_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_6_0_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_6_0_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_6_1_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_6_1_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_6_1_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_6_1_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_6_1_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_6_1_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_6_1_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_6_1_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_6_1_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_7_0_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_7_0_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_7_0_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_7_0_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_7_0_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_7_0_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_7_0_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_7_0_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_7_0_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_amm_7_1_waitrequest_n : out   std_logic;                                         -- waitrequest_n
			ctrl_amm_7_1_read          : in    std_logic                      := 'X';             -- read
			ctrl_amm_7_1_write         : in    std_logic                      := 'X';             -- write
			ctrl_amm_7_1_address       : in    std_logic_vector(28 downto 0)  := (others => 'X'); -- address
			ctrl_amm_7_1_readdata      : out   std_logic_vector(255 downto 0);                    -- readdata
			ctrl_amm_7_1_writedata     : in    std_logic_vector(255 downto 0) := (others => 'X'); -- writedata
			ctrl_amm_7_1_burstcount    : in    std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			ctrl_amm_7_1_byteenable    : in    std_logic_vector(31 downto 0)  := (others => 'X'); -- byteenable
			ctrl_amm_7_1_readdatavalid : out   std_logic;                                         -- readdatavalid
			ctrl_ecc_readdataerror_6_0 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_6_1 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_7_0 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_7_1 : out   std_logic;                                         -- ctrl_ecc_readdataerror
			apb_6_ur_paddr             : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_paddr
			apb_6_ur_psel              : in    std_logic                      := 'X';             -- ur_psel
			apb_6_ur_penable           : in    std_logic                      := 'X';             -- ur_penable
			apb_6_ur_pwrite            : in    std_logic                      := 'X';             -- ur_pwrite
			apb_6_ur_pwdata            : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_pwdata
			apb_6_ur_pstrb             : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- ur_pstrb
			apb_6_ur_prready           : out   std_logic;                                         -- ur_prready
			apb_6_ur_prdata            : out   std_logic_vector(15 downto 0);                     -- ur_prdata
			apb_7_ur_paddr             : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_paddr
			apb_7_ur_psel              : in    std_logic                      := 'X';             -- ur_psel
			apb_7_ur_penable           : in    std_logic                      := 'X';             -- ur_penable
			apb_7_ur_pwrite            : in    std_logic                      := 'X';             -- ur_pwrite
			apb_7_ur_pwdata            : in    std_logic_vector(15 downto 0)  := (others => 'X'); -- ur_pwdata
			apb_7_ur_pstrb             : in    std_logic_vector(1 downto 0)   := (others => 'X'); -- ur_pstrb
			apb_7_ur_prready           : out   std_logic;                                         -- ur_prready
			apb_7_ur_prdata            : out   std_logic_vector(15 downto 0)                      -- ur_prdata
		);
	end component qsys_top_hbm_0;

	u0 : component qsys_top_hbm_0
		port map (
			pll_ref_clk                => CONNECTED_TO_pll_ref_clk,                --                pll_ref_clk.clk
			ext_core_clk               => CONNECTED_TO_ext_core_clk,               --               ext_core_clk.clk
			ext_core_clk_locked        => CONNECTED_TO_ext_core_clk_locked,        --        ext_core_clk_locked.export
			wmcrst_n_in                => CONNECTED_TO_wmcrst_n_in,                --                wmcrst_n_in.reset_n
			hbm_only_reset_in          => CONNECTED_TO_hbm_only_reset_in,          --          hbm_only_reset_in.reset
			local_cal_success          => CONNECTED_TO_local_cal_success,          --                     status.local_cal_success
			local_cal_fail             => CONNECTED_TO_local_cal_fail,             --                           .local_cal_fail
			cal_lat                    => CONNECTED_TO_cal_lat,                    --                    cal_lat.cal_lat
			ck_t_0                     => CONNECTED_TO_ck_t_0,                     --                      mem_0.ck_t
			ck_c_0                     => CONNECTED_TO_ck_c_0,                     --                           .ck_c
			cke_0                      => CONNECTED_TO_cke_0,                      --                           .cke
			c_0                        => CONNECTED_TO_c_0,                        --                           .c
			r_0                        => CONNECTED_TO_r_0,                        --                           .r
			dq_0                       => CONNECTED_TO_dq_0,                       --                           .dq
			dm_0                       => CONNECTED_TO_dm_0,                       --                           .dm
			dbi_0                      => CONNECTED_TO_dbi_0,                      --                           .dbi
			par_0                      => CONNECTED_TO_par_0,                      --                           .par
			derr_0                     => CONNECTED_TO_derr_0,                     --                           .derr
			rdqs_t_0                   => CONNECTED_TO_rdqs_t_0,                   --                           .rdqs_t
			rdqs_c_0                   => CONNECTED_TO_rdqs_c_0,                   --                           .rdqs_c
			wdqs_t_0                   => CONNECTED_TO_wdqs_t_0,                   --                           .wdqs_t
			wdqs_c_0                   => CONNECTED_TO_wdqs_c_0,                   --                           .wdqs_c
			rd_0                       => CONNECTED_TO_rd_0,                       --                           .rd
			rr_0                       => CONNECTED_TO_rr_0,                       --                           .rr
			rc_0                       => CONNECTED_TO_rc_0,                       --                           .rc
			aerr_0                     => CONNECTED_TO_aerr_0,                     --                           .aerr
			ck_t_1                     => CONNECTED_TO_ck_t_1,                     --                      mem_1.ck_t
			ck_c_1                     => CONNECTED_TO_ck_c_1,                     --                           .ck_c
			cke_1                      => CONNECTED_TO_cke_1,                      --                           .cke
			c_1                        => CONNECTED_TO_c_1,                        --                           .c
			r_1                        => CONNECTED_TO_r_1,                        --                           .r
			dq_1                       => CONNECTED_TO_dq_1,                       --                           .dq
			dm_1                       => CONNECTED_TO_dm_1,                       --                           .dm
			dbi_1                      => CONNECTED_TO_dbi_1,                      --                           .dbi
			par_1                      => CONNECTED_TO_par_1,                      --                           .par
			derr_1                     => CONNECTED_TO_derr_1,                     --                           .derr
			rdqs_t_1                   => CONNECTED_TO_rdqs_t_1,                   --                           .rdqs_t
			rdqs_c_1                   => CONNECTED_TO_rdqs_c_1,                   --                           .rdqs_c
			wdqs_t_1                   => CONNECTED_TO_wdqs_t_1,                   --                           .wdqs_t
			wdqs_c_1                   => CONNECTED_TO_wdqs_c_1,                   --                           .wdqs_c
			rd_1                       => CONNECTED_TO_rd_1,                       --                           .rd
			rr_1                       => CONNECTED_TO_rr_1,                       --                           .rr
			rc_1                       => CONNECTED_TO_rc_1,                       --                           .rc
			aerr_1                     => CONNECTED_TO_aerr_1,                     --                           .aerr
			ck_t_2                     => CONNECTED_TO_ck_t_2,                     --                      mem_2.ck_t
			ck_c_2                     => CONNECTED_TO_ck_c_2,                     --                           .ck_c
			cke_2                      => CONNECTED_TO_cke_2,                      --                           .cke
			c_2                        => CONNECTED_TO_c_2,                        --                           .c
			r_2                        => CONNECTED_TO_r_2,                        --                           .r
			dq_2                       => CONNECTED_TO_dq_2,                       --                           .dq
			dm_2                       => CONNECTED_TO_dm_2,                       --                           .dm
			dbi_2                      => CONNECTED_TO_dbi_2,                      --                           .dbi
			par_2                      => CONNECTED_TO_par_2,                      --                           .par
			derr_2                     => CONNECTED_TO_derr_2,                     --                           .derr
			rdqs_t_2                   => CONNECTED_TO_rdqs_t_2,                   --                           .rdqs_t
			rdqs_c_2                   => CONNECTED_TO_rdqs_c_2,                   --                           .rdqs_c
			wdqs_t_2                   => CONNECTED_TO_wdqs_t_2,                   --                           .wdqs_t
			wdqs_c_2                   => CONNECTED_TO_wdqs_c_2,                   --                           .wdqs_c
			rd_2                       => CONNECTED_TO_rd_2,                       --                           .rd
			rr_2                       => CONNECTED_TO_rr_2,                       --                           .rr
			rc_2                       => CONNECTED_TO_rc_2,                       --                           .rc
			aerr_2                     => CONNECTED_TO_aerr_2,                     --                           .aerr
			ck_t_3                     => CONNECTED_TO_ck_t_3,                     --                      mem_3.ck_t
			ck_c_3                     => CONNECTED_TO_ck_c_3,                     --                           .ck_c
			cke_3                      => CONNECTED_TO_cke_3,                      --                           .cke
			c_3                        => CONNECTED_TO_c_3,                        --                           .c
			r_3                        => CONNECTED_TO_r_3,                        --                           .r
			dq_3                       => CONNECTED_TO_dq_3,                       --                           .dq
			dm_3                       => CONNECTED_TO_dm_3,                       --                           .dm
			dbi_3                      => CONNECTED_TO_dbi_3,                      --                           .dbi
			par_3                      => CONNECTED_TO_par_3,                      --                           .par
			derr_3                     => CONNECTED_TO_derr_3,                     --                           .derr
			rdqs_t_3                   => CONNECTED_TO_rdqs_t_3,                   --                           .rdqs_t
			rdqs_c_3                   => CONNECTED_TO_rdqs_c_3,                   --                           .rdqs_c
			wdqs_t_3                   => CONNECTED_TO_wdqs_t_3,                   --                           .wdqs_t
			wdqs_c_3                   => CONNECTED_TO_wdqs_c_3,                   --                           .wdqs_c
			rd_3                       => CONNECTED_TO_rd_3,                       --                           .rd
			rr_3                       => CONNECTED_TO_rr_3,                       --                           .rr
			rc_3                       => CONNECTED_TO_rc_3,                       --                           .rc
			aerr_3                     => CONNECTED_TO_aerr_3,                     --                           .aerr
			ck_t_4                     => CONNECTED_TO_ck_t_4,                     --                      mem_4.ck_t
			ck_c_4                     => CONNECTED_TO_ck_c_4,                     --                           .ck_c
			cke_4                      => CONNECTED_TO_cke_4,                      --                           .cke
			c_4                        => CONNECTED_TO_c_4,                        --                           .c
			r_4                        => CONNECTED_TO_r_4,                        --                           .r
			dq_4                       => CONNECTED_TO_dq_4,                       --                           .dq
			dm_4                       => CONNECTED_TO_dm_4,                       --                           .dm
			dbi_4                      => CONNECTED_TO_dbi_4,                      --                           .dbi
			par_4                      => CONNECTED_TO_par_4,                      --                           .par
			derr_4                     => CONNECTED_TO_derr_4,                     --                           .derr
			rdqs_t_4                   => CONNECTED_TO_rdqs_t_4,                   --                           .rdqs_t
			rdqs_c_4                   => CONNECTED_TO_rdqs_c_4,                   --                           .rdqs_c
			wdqs_t_4                   => CONNECTED_TO_wdqs_t_4,                   --                           .wdqs_t
			wdqs_c_4                   => CONNECTED_TO_wdqs_c_4,                   --                           .wdqs_c
			rd_4                       => CONNECTED_TO_rd_4,                       --                           .rd
			rr_4                       => CONNECTED_TO_rr_4,                       --                           .rr
			rc_4                       => CONNECTED_TO_rc_4,                       --                           .rc
			aerr_4                     => CONNECTED_TO_aerr_4,                     --                           .aerr
			ck_t_5                     => CONNECTED_TO_ck_t_5,                     --                      mem_5.ck_t
			ck_c_5                     => CONNECTED_TO_ck_c_5,                     --                           .ck_c
			cke_5                      => CONNECTED_TO_cke_5,                      --                           .cke
			c_5                        => CONNECTED_TO_c_5,                        --                           .c
			r_5                        => CONNECTED_TO_r_5,                        --                           .r
			dq_5                       => CONNECTED_TO_dq_5,                       --                           .dq
			dm_5                       => CONNECTED_TO_dm_5,                       --                           .dm
			dbi_5                      => CONNECTED_TO_dbi_5,                      --                           .dbi
			par_5                      => CONNECTED_TO_par_5,                      --                           .par
			derr_5                     => CONNECTED_TO_derr_5,                     --                           .derr
			rdqs_t_5                   => CONNECTED_TO_rdqs_t_5,                   --                           .rdqs_t
			rdqs_c_5                   => CONNECTED_TO_rdqs_c_5,                   --                           .rdqs_c
			wdqs_t_5                   => CONNECTED_TO_wdqs_t_5,                   --                           .wdqs_t
			wdqs_c_5                   => CONNECTED_TO_wdqs_c_5,                   --                           .wdqs_c
			rd_5                       => CONNECTED_TO_rd_5,                       --                           .rd
			rr_5                       => CONNECTED_TO_rr_5,                       --                           .rr
			rc_5                       => CONNECTED_TO_rc_5,                       --                           .rc
			aerr_5                     => CONNECTED_TO_aerr_5,                     --                           .aerr
			ck_t_6                     => CONNECTED_TO_ck_t_6,                     --                      mem_6.ck_t
			ck_c_6                     => CONNECTED_TO_ck_c_6,                     --                           .ck_c
			cke_6                      => CONNECTED_TO_cke_6,                      --                           .cke
			c_6                        => CONNECTED_TO_c_6,                        --                           .c
			r_6                        => CONNECTED_TO_r_6,                        --                           .r
			dq_6                       => CONNECTED_TO_dq_6,                       --                           .dq
			dm_6                       => CONNECTED_TO_dm_6,                       --                           .dm
			dbi_6                      => CONNECTED_TO_dbi_6,                      --                           .dbi
			par_6                      => CONNECTED_TO_par_6,                      --                           .par
			derr_6                     => CONNECTED_TO_derr_6,                     --                           .derr
			rdqs_t_6                   => CONNECTED_TO_rdqs_t_6,                   --                           .rdqs_t
			rdqs_c_6                   => CONNECTED_TO_rdqs_c_6,                   --                           .rdqs_c
			wdqs_t_6                   => CONNECTED_TO_wdqs_t_6,                   --                           .wdqs_t
			wdqs_c_6                   => CONNECTED_TO_wdqs_c_6,                   --                           .wdqs_c
			rd_6                       => CONNECTED_TO_rd_6,                       --                           .rd
			rr_6                       => CONNECTED_TO_rr_6,                       --                           .rr
			rc_6                       => CONNECTED_TO_rc_6,                       --                           .rc
			aerr_6                     => CONNECTED_TO_aerr_6,                     --                           .aerr
			ck_t_7                     => CONNECTED_TO_ck_t_7,                     --                      mem_7.ck_t
			ck_c_7                     => CONNECTED_TO_ck_c_7,                     --                           .ck_c
			cke_7                      => CONNECTED_TO_cke_7,                      --                           .cke
			c_7                        => CONNECTED_TO_c_7,                        --                           .c
			r_7                        => CONNECTED_TO_r_7,                        --                           .r
			dq_7                       => CONNECTED_TO_dq_7,                       --                           .dq
			dm_7                       => CONNECTED_TO_dm_7,                       --                           .dm
			dbi_7                      => CONNECTED_TO_dbi_7,                      --                           .dbi
			par_7                      => CONNECTED_TO_par_7,                      --                           .par
			derr_7                     => CONNECTED_TO_derr_7,                     --                           .derr
			rdqs_t_7                   => CONNECTED_TO_rdqs_t_7,                   --                           .rdqs_t
			rdqs_c_7                   => CONNECTED_TO_rdqs_c_7,                   --                           .rdqs_c
			wdqs_t_7                   => CONNECTED_TO_wdqs_t_7,                   --                           .wdqs_t
			wdqs_c_7                   => CONNECTED_TO_wdqs_c_7,                   --                           .wdqs_c
			rd_7                       => CONNECTED_TO_rd_7,                       --                           .rd
			rr_7                       => CONNECTED_TO_rr_7,                       --                           .rr
			rc_7                       => CONNECTED_TO_rc_7,                       --                           .rc
			aerr_7                     => CONNECTED_TO_aerr_7,                     --                           .aerr
			cattrip                    => CONNECTED_TO_cattrip,                    --                 m2u_bridge.cattrip
			temp                       => CONNECTED_TO_temp,                       --                           .temp
			wso                        => CONNECTED_TO_wso,                        --                           .wso
			reset_n                    => CONNECTED_TO_reset_n,                    --                           .reset_n
			wrst_n                     => CONNECTED_TO_wrst_n,                     --                           .wrst_n
			wrck                       => CONNECTED_TO_wrck,                       --                           .wrck
			shiftwr                    => CONNECTED_TO_shiftwr,                    --                           .shiftwr
			capturewr                  => CONNECTED_TO_capturewr,                  --                           .capturewr
			updatewr                   => CONNECTED_TO_updatewr,                   --                           .updatewr
			selectwir                  => CONNECTED_TO_selectwir,                  --                           .selectwir
			wsi                        => CONNECTED_TO_wsi,                        --                           .wsi
			wmc_clk_0_clk              => CONNECTED_TO_wmc_clk_0_clk,              --                  wmc_clk_0.clk
			wmc_clk_1_clk              => CONNECTED_TO_wmc_clk_1_clk,              --                  wmc_clk_1.clk
			phy_clk_0_clk              => CONNECTED_TO_phy_clk_0_clk,              --                  phy_clk_0.clk
			phy_clk_1_clk              => CONNECTED_TO_phy_clk_1_clk,              --                  phy_clk_1.clk
			wmcrst_n_0_reset_n         => CONNECTED_TO_wmcrst_n_0_reset_n,         --                 wmcrst_n_0.reset_n
			wmcrst_n_1_reset_n         => CONNECTED_TO_wmcrst_n_1_reset_n,         --                 wmcrst_n_1.reset_n
			ctrl_amm_0_0_waitrequest_n => CONNECTED_TO_ctrl_amm_0_0_waitrequest_n, --               ctrl_amm_0_0.waitrequest_n
			ctrl_amm_0_0_read          => CONNECTED_TO_ctrl_amm_0_0_read,          --                           .read
			ctrl_amm_0_0_write         => CONNECTED_TO_ctrl_amm_0_0_write,         --                           .write
			ctrl_amm_0_0_address       => CONNECTED_TO_ctrl_amm_0_0_address,       --                           .address
			ctrl_amm_0_0_readdata      => CONNECTED_TO_ctrl_amm_0_0_readdata,      --                           .readdata
			ctrl_amm_0_0_writedata     => CONNECTED_TO_ctrl_amm_0_0_writedata,     --                           .writedata
			ctrl_amm_0_0_burstcount    => CONNECTED_TO_ctrl_amm_0_0_burstcount,    --                           .burstcount
			ctrl_amm_0_0_byteenable    => CONNECTED_TO_ctrl_amm_0_0_byteenable,    --                           .byteenable
			ctrl_amm_0_0_readdatavalid => CONNECTED_TO_ctrl_amm_0_0_readdatavalid, --                           .readdatavalid
			ctrl_amm_0_1_waitrequest_n => CONNECTED_TO_ctrl_amm_0_1_waitrequest_n, --               ctrl_amm_0_1.waitrequest_n
			ctrl_amm_0_1_read          => CONNECTED_TO_ctrl_amm_0_1_read,          --                           .read
			ctrl_amm_0_1_write         => CONNECTED_TO_ctrl_amm_0_1_write,         --                           .write
			ctrl_amm_0_1_address       => CONNECTED_TO_ctrl_amm_0_1_address,       --                           .address
			ctrl_amm_0_1_readdata      => CONNECTED_TO_ctrl_amm_0_1_readdata,      --                           .readdata
			ctrl_amm_0_1_writedata     => CONNECTED_TO_ctrl_amm_0_1_writedata,     --                           .writedata
			ctrl_amm_0_1_burstcount    => CONNECTED_TO_ctrl_amm_0_1_burstcount,    --                           .burstcount
			ctrl_amm_0_1_byteenable    => CONNECTED_TO_ctrl_amm_0_1_byteenable,    --                           .byteenable
			ctrl_amm_0_1_readdatavalid => CONNECTED_TO_ctrl_amm_0_1_readdatavalid, --                           .readdatavalid
			ctrl_amm_1_0_waitrequest_n => CONNECTED_TO_ctrl_amm_1_0_waitrequest_n, --               ctrl_amm_1_0.waitrequest_n
			ctrl_amm_1_0_read          => CONNECTED_TO_ctrl_amm_1_0_read,          --                           .read
			ctrl_amm_1_0_write         => CONNECTED_TO_ctrl_amm_1_0_write,         --                           .write
			ctrl_amm_1_0_address       => CONNECTED_TO_ctrl_amm_1_0_address,       --                           .address
			ctrl_amm_1_0_readdata      => CONNECTED_TO_ctrl_amm_1_0_readdata,      --                           .readdata
			ctrl_amm_1_0_writedata     => CONNECTED_TO_ctrl_amm_1_0_writedata,     --                           .writedata
			ctrl_amm_1_0_burstcount    => CONNECTED_TO_ctrl_amm_1_0_burstcount,    --                           .burstcount
			ctrl_amm_1_0_byteenable    => CONNECTED_TO_ctrl_amm_1_0_byteenable,    --                           .byteenable
			ctrl_amm_1_0_readdatavalid => CONNECTED_TO_ctrl_amm_1_0_readdatavalid, --                           .readdatavalid
			ctrl_amm_1_1_waitrequest_n => CONNECTED_TO_ctrl_amm_1_1_waitrequest_n, --               ctrl_amm_1_1.waitrequest_n
			ctrl_amm_1_1_read          => CONNECTED_TO_ctrl_amm_1_1_read,          --                           .read
			ctrl_amm_1_1_write         => CONNECTED_TO_ctrl_amm_1_1_write,         --                           .write
			ctrl_amm_1_1_address       => CONNECTED_TO_ctrl_amm_1_1_address,       --                           .address
			ctrl_amm_1_1_readdata      => CONNECTED_TO_ctrl_amm_1_1_readdata,      --                           .readdata
			ctrl_amm_1_1_writedata     => CONNECTED_TO_ctrl_amm_1_1_writedata,     --                           .writedata
			ctrl_amm_1_1_burstcount    => CONNECTED_TO_ctrl_amm_1_1_burstcount,    --                           .burstcount
			ctrl_amm_1_1_byteenable    => CONNECTED_TO_ctrl_amm_1_1_byteenable,    --                           .byteenable
			ctrl_amm_1_1_readdatavalid => CONNECTED_TO_ctrl_amm_1_1_readdatavalid, --                           .readdatavalid
			ctrl_ecc_readdataerror_0_0 => CONNECTED_TO_ctrl_ecc_readdataerror_0_0, -- ctrl_ecc_readdataerror_0_0.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_0_1 => CONNECTED_TO_ctrl_ecc_readdataerror_0_1, -- ctrl_ecc_readdataerror_0_1.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_1_0 => CONNECTED_TO_ctrl_ecc_readdataerror_1_0, -- ctrl_ecc_readdataerror_1_0.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_1_1 => CONNECTED_TO_ctrl_ecc_readdataerror_1_1, -- ctrl_ecc_readdataerror_1_1.ctrl_ecc_readdataerror
			apb_0_ur_paddr             => CONNECTED_TO_apb_0_ur_paddr,             --                      apb_0.ur_paddr
			apb_0_ur_psel              => CONNECTED_TO_apb_0_ur_psel,              --                           .ur_psel
			apb_0_ur_penable           => CONNECTED_TO_apb_0_ur_penable,           --                           .ur_penable
			apb_0_ur_pwrite            => CONNECTED_TO_apb_0_ur_pwrite,            --                           .ur_pwrite
			apb_0_ur_pwdata            => CONNECTED_TO_apb_0_ur_pwdata,            --                           .ur_pwdata
			apb_0_ur_pstrb             => CONNECTED_TO_apb_0_ur_pstrb,             --                           .ur_pstrb
			apb_0_ur_prready           => CONNECTED_TO_apb_0_ur_prready,           --                           .ur_prready
			apb_0_ur_prdata            => CONNECTED_TO_apb_0_ur_prdata,            --                           .ur_prdata
			apb_1_ur_paddr             => CONNECTED_TO_apb_1_ur_paddr,             --                      apb_1.ur_paddr
			apb_1_ur_psel              => CONNECTED_TO_apb_1_ur_psel,              --                           .ur_psel
			apb_1_ur_penable           => CONNECTED_TO_apb_1_ur_penable,           --                           .ur_penable
			apb_1_ur_pwrite            => CONNECTED_TO_apb_1_ur_pwrite,            --                           .ur_pwrite
			apb_1_ur_pwdata            => CONNECTED_TO_apb_1_ur_pwdata,            --                           .ur_pwdata
			apb_1_ur_pstrb             => CONNECTED_TO_apb_1_ur_pstrb,             --                           .ur_pstrb
			apb_1_ur_prready           => CONNECTED_TO_apb_1_ur_prready,           --                           .ur_prready
			apb_1_ur_prdata            => CONNECTED_TO_apb_1_ur_prdata,            --                           .ur_prdata
			wmc_clk_2_clk              => CONNECTED_TO_wmc_clk_2_clk,              --                  wmc_clk_2.clk
			wmc_clk_3_clk              => CONNECTED_TO_wmc_clk_3_clk,              --                  wmc_clk_3.clk
			phy_clk_2_clk              => CONNECTED_TO_phy_clk_2_clk,              --                  phy_clk_2.clk
			phy_clk_3_clk              => CONNECTED_TO_phy_clk_3_clk,              --                  phy_clk_3.clk
			wmcrst_n_2_reset_n         => CONNECTED_TO_wmcrst_n_2_reset_n,         --                 wmcrst_n_2.reset_n
			wmcrst_n_3_reset_n         => CONNECTED_TO_wmcrst_n_3_reset_n,         --                 wmcrst_n_3.reset_n
			ctrl_amm_2_0_waitrequest_n => CONNECTED_TO_ctrl_amm_2_0_waitrequest_n, --               ctrl_amm_2_0.waitrequest_n
			ctrl_amm_2_0_read          => CONNECTED_TO_ctrl_amm_2_0_read,          --                           .read
			ctrl_amm_2_0_write         => CONNECTED_TO_ctrl_amm_2_0_write,         --                           .write
			ctrl_amm_2_0_address       => CONNECTED_TO_ctrl_amm_2_0_address,       --                           .address
			ctrl_amm_2_0_readdata      => CONNECTED_TO_ctrl_amm_2_0_readdata,      --                           .readdata
			ctrl_amm_2_0_writedata     => CONNECTED_TO_ctrl_amm_2_0_writedata,     --                           .writedata
			ctrl_amm_2_0_burstcount    => CONNECTED_TO_ctrl_amm_2_0_burstcount,    --                           .burstcount
			ctrl_amm_2_0_byteenable    => CONNECTED_TO_ctrl_amm_2_0_byteenable,    --                           .byteenable
			ctrl_amm_2_0_readdatavalid => CONNECTED_TO_ctrl_amm_2_0_readdatavalid, --                           .readdatavalid
			ctrl_amm_2_1_waitrequest_n => CONNECTED_TO_ctrl_amm_2_1_waitrequest_n, --               ctrl_amm_2_1.waitrequest_n
			ctrl_amm_2_1_read          => CONNECTED_TO_ctrl_amm_2_1_read,          --                           .read
			ctrl_amm_2_1_write         => CONNECTED_TO_ctrl_amm_2_1_write,         --                           .write
			ctrl_amm_2_1_address       => CONNECTED_TO_ctrl_amm_2_1_address,       --                           .address
			ctrl_amm_2_1_readdata      => CONNECTED_TO_ctrl_amm_2_1_readdata,      --                           .readdata
			ctrl_amm_2_1_writedata     => CONNECTED_TO_ctrl_amm_2_1_writedata,     --                           .writedata
			ctrl_amm_2_1_burstcount    => CONNECTED_TO_ctrl_amm_2_1_burstcount,    --                           .burstcount
			ctrl_amm_2_1_byteenable    => CONNECTED_TO_ctrl_amm_2_1_byteenable,    --                           .byteenable
			ctrl_amm_2_1_readdatavalid => CONNECTED_TO_ctrl_amm_2_1_readdatavalid, --                           .readdatavalid
			ctrl_amm_3_0_waitrequest_n => CONNECTED_TO_ctrl_amm_3_0_waitrequest_n, --               ctrl_amm_3_0.waitrequest_n
			ctrl_amm_3_0_read          => CONNECTED_TO_ctrl_amm_3_0_read,          --                           .read
			ctrl_amm_3_0_write         => CONNECTED_TO_ctrl_amm_3_0_write,         --                           .write
			ctrl_amm_3_0_address       => CONNECTED_TO_ctrl_amm_3_0_address,       --                           .address
			ctrl_amm_3_0_readdata      => CONNECTED_TO_ctrl_amm_3_0_readdata,      --                           .readdata
			ctrl_amm_3_0_writedata     => CONNECTED_TO_ctrl_amm_3_0_writedata,     --                           .writedata
			ctrl_amm_3_0_burstcount    => CONNECTED_TO_ctrl_amm_3_0_burstcount,    --                           .burstcount
			ctrl_amm_3_0_byteenable    => CONNECTED_TO_ctrl_amm_3_0_byteenable,    --                           .byteenable
			ctrl_amm_3_0_readdatavalid => CONNECTED_TO_ctrl_amm_3_0_readdatavalid, --                           .readdatavalid
			ctrl_amm_3_1_waitrequest_n => CONNECTED_TO_ctrl_amm_3_1_waitrequest_n, --               ctrl_amm_3_1.waitrequest_n
			ctrl_amm_3_1_read          => CONNECTED_TO_ctrl_amm_3_1_read,          --                           .read
			ctrl_amm_3_1_write         => CONNECTED_TO_ctrl_amm_3_1_write,         --                           .write
			ctrl_amm_3_1_address       => CONNECTED_TO_ctrl_amm_3_1_address,       --                           .address
			ctrl_amm_3_1_readdata      => CONNECTED_TO_ctrl_amm_3_1_readdata,      --                           .readdata
			ctrl_amm_3_1_writedata     => CONNECTED_TO_ctrl_amm_3_1_writedata,     --                           .writedata
			ctrl_amm_3_1_burstcount    => CONNECTED_TO_ctrl_amm_3_1_burstcount,    --                           .burstcount
			ctrl_amm_3_1_byteenable    => CONNECTED_TO_ctrl_amm_3_1_byteenable,    --                           .byteenable
			ctrl_amm_3_1_readdatavalid => CONNECTED_TO_ctrl_amm_3_1_readdatavalid, --                           .readdatavalid
			ctrl_ecc_readdataerror_2_0 => CONNECTED_TO_ctrl_ecc_readdataerror_2_0, -- ctrl_ecc_readdataerror_2_0.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_2_1 => CONNECTED_TO_ctrl_ecc_readdataerror_2_1, -- ctrl_ecc_readdataerror_2_1.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_3_0 => CONNECTED_TO_ctrl_ecc_readdataerror_3_0, -- ctrl_ecc_readdataerror_3_0.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_3_1 => CONNECTED_TO_ctrl_ecc_readdataerror_3_1, -- ctrl_ecc_readdataerror_3_1.ctrl_ecc_readdataerror
			apb_2_ur_paddr             => CONNECTED_TO_apb_2_ur_paddr,             --                      apb_2.ur_paddr
			apb_2_ur_psel              => CONNECTED_TO_apb_2_ur_psel,              --                           .ur_psel
			apb_2_ur_penable           => CONNECTED_TO_apb_2_ur_penable,           --                           .ur_penable
			apb_2_ur_pwrite            => CONNECTED_TO_apb_2_ur_pwrite,            --                           .ur_pwrite
			apb_2_ur_pwdata            => CONNECTED_TO_apb_2_ur_pwdata,            --                           .ur_pwdata
			apb_2_ur_pstrb             => CONNECTED_TO_apb_2_ur_pstrb,             --                           .ur_pstrb
			apb_2_ur_prready           => CONNECTED_TO_apb_2_ur_prready,           --                           .ur_prready
			apb_2_ur_prdata            => CONNECTED_TO_apb_2_ur_prdata,            --                           .ur_prdata
			apb_3_ur_paddr             => CONNECTED_TO_apb_3_ur_paddr,             --                      apb_3.ur_paddr
			apb_3_ur_psel              => CONNECTED_TO_apb_3_ur_psel,              --                           .ur_psel
			apb_3_ur_penable           => CONNECTED_TO_apb_3_ur_penable,           --                           .ur_penable
			apb_3_ur_pwrite            => CONNECTED_TO_apb_3_ur_pwrite,            --                           .ur_pwrite
			apb_3_ur_pwdata            => CONNECTED_TO_apb_3_ur_pwdata,            --                           .ur_pwdata
			apb_3_ur_pstrb             => CONNECTED_TO_apb_3_ur_pstrb,             --                           .ur_pstrb
			apb_3_ur_prready           => CONNECTED_TO_apb_3_ur_prready,           --                           .ur_prready
			apb_3_ur_prdata            => CONNECTED_TO_apb_3_ur_prdata,            --                           .ur_prdata
			wmc_clk_4_clk              => CONNECTED_TO_wmc_clk_4_clk,              --                  wmc_clk_4.clk
			wmc_clk_5_clk              => CONNECTED_TO_wmc_clk_5_clk,              --                  wmc_clk_5.clk
			phy_clk_4_clk              => CONNECTED_TO_phy_clk_4_clk,              --                  phy_clk_4.clk
			phy_clk_5_clk              => CONNECTED_TO_phy_clk_5_clk,              --                  phy_clk_5.clk
			wmcrst_n_4_reset_n         => CONNECTED_TO_wmcrst_n_4_reset_n,         --                 wmcrst_n_4.reset_n
			wmcrst_n_5_reset_n         => CONNECTED_TO_wmcrst_n_5_reset_n,         --                 wmcrst_n_5.reset_n
			ctrl_amm_4_0_waitrequest_n => CONNECTED_TO_ctrl_amm_4_0_waitrequest_n, --               ctrl_amm_4_0.waitrequest_n
			ctrl_amm_4_0_read          => CONNECTED_TO_ctrl_amm_4_0_read,          --                           .read
			ctrl_amm_4_0_write         => CONNECTED_TO_ctrl_amm_4_0_write,         --                           .write
			ctrl_amm_4_0_address       => CONNECTED_TO_ctrl_amm_4_0_address,       --                           .address
			ctrl_amm_4_0_readdata      => CONNECTED_TO_ctrl_amm_4_0_readdata,      --                           .readdata
			ctrl_amm_4_0_writedata     => CONNECTED_TO_ctrl_amm_4_0_writedata,     --                           .writedata
			ctrl_amm_4_0_burstcount    => CONNECTED_TO_ctrl_amm_4_0_burstcount,    --                           .burstcount
			ctrl_amm_4_0_byteenable    => CONNECTED_TO_ctrl_amm_4_0_byteenable,    --                           .byteenable
			ctrl_amm_4_0_readdatavalid => CONNECTED_TO_ctrl_amm_4_0_readdatavalid, --                           .readdatavalid
			ctrl_amm_4_1_waitrequest_n => CONNECTED_TO_ctrl_amm_4_1_waitrequest_n, --               ctrl_amm_4_1.waitrequest_n
			ctrl_amm_4_1_read          => CONNECTED_TO_ctrl_amm_4_1_read,          --                           .read
			ctrl_amm_4_1_write         => CONNECTED_TO_ctrl_amm_4_1_write,         --                           .write
			ctrl_amm_4_1_address       => CONNECTED_TO_ctrl_amm_4_1_address,       --                           .address
			ctrl_amm_4_1_readdata      => CONNECTED_TO_ctrl_amm_4_1_readdata,      --                           .readdata
			ctrl_amm_4_1_writedata     => CONNECTED_TO_ctrl_amm_4_1_writedata,     --                           .writedata
			ctrl_amm_4_1_burstcount    => CONNECTED_TO_ctrl_amm_4_1_burstcount,    --                           .burstcount
			ctrl_amm_4_1_byteenable    => CONNECTED_TO_ctrl_amm_4_1_byteenable,    --                           .byteenable
			ctrl_amm_4_1_readdatavalid => CONNECTED_TO_ctrl_amm_4_1_readdatavalid, --                           .readdatavalid
			ctrl_amm_5_0_waitrequest_n => CONNECTED_TO_ctrl_amm_5_0_waitrequest_n, --               ctrl_amm_5_0.waitrequest_n
			ctrl_amm_5_0_read          => CONNECTED_TO_ctrl_amm_5_0_read,          --                           .read
			ctrl_amm_5_0_write         => CONNECTED_TO_ctrl_amm_5_0_write,         --                           .write
			ctrl_amm_5_0_address       => CONNECTED_TO_ctrl_amm_5_0_address,       --                           .address
			ctrl_amm_5_0_readdata      => CONNECTED_TO_ctrl_amm_5_0_readdata,      --                           .readdata
			ctrl_amm_5_0_writedata     => CONNECTED_TO_ctrl_amm_5_0_writedata,     --                           .writedata
			ctrl_amm_5_0_burstcount    => CONNECTED_TO_ctrl_amm_5_0_burstcount,    --                           .burstcount
			ctrl_amm_5_0_byteenable    => CONNECTED_TO_ctrl_amm_5_0_byteenable,    --                           .byteenable
			ctrl_amm_5_0_readdatavalid => CONNECTED_TO_ctrl_amm_5_0_readdatavalid, --                           .readdatavalid
			ctrl_amm_5_1_waitrequest_n => CONNECTED_TO_ctrl_amm_5_1_waitrequest_n, --               ctrl_amm_5_1.waitrequest_n
			ctrl_amm_5_1_read          => CONNECTED_TO_ctrl_amm_5_1_read,          --                           .read
			ctrl_amm_5_1_write         => CONNECTED_TO_ctrl_amm_5_1_write,         --                           .write
			ctrl_amm_5_1_address       => CONNECTED_TO_ctrl_amm_5_1_address,       --                           .address
			ctrl_amm_5_1_readdata      => CONNECTED_TO_ctrl_amm_5_1_readdata,      --                           .readdata
			ctrl_amm_5_1_writedata     => CONNECTED_TO_ctrl_amm_5_1_writedata,     --                           .writedata
			ctrl_amm_5_1_burstcount    => CONNECTED_TO_ctrl_amm_5_1_burstcount,    --                           .burstcount
			ctrl_amm_5_1_byteenable    => CONNECTED_TO_ctrl_amm_5_1_byteenable,    --                           .byteenable
			ctrl_amm_5_1_readdatavalid => CONNECTED_TO_ctrl_amm_5_1_readdatavalid, --                           .readdatavalid
			ctrl_ecc_readdataerror_4_0 => CONNECTED_TO_ctrl_ecc_readdataerror_4_0, -- ctrl_ecc_readdataerror_4_0.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_4_1 => CONNECTED_TO_ctrl_ecc_readdataerror_4_1, -- ctrl_ecc_readdataerror_4_1.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_5_0 => CONNECTED_TO_ctrl_ecc_readdataerror_5_0, -- ctrl_ecc_readdataerror_5_0.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_5_1 => CONNECTED_TO_ctrl_ecc_readdataerror_5_1, -- ctrl_ecc_readdataerror_5_1.ctrl_ecc_readdataerror
			apb_4_ur_paddr             => CONNECTED_TO_apb_4_ur_paddr,             --                      apb_4.ur_paddr
			apb_4_ur_psel              => CONNECTED_TO_apb_4_ur_psel,              --                           .ur_psel
			apb_4_ur_penable           => CONNECTED_TO_apb_4_ur_penable,           --                           .ur_penable
			apb_4_ur_pwrite            => CONNECTED_TO_apb_4_ur_pwrite,            --                           .ur_pwrite
			apb_4_ur_pwdata            => CONNECTED_TO_apb_4_ur_pwdata,            --                           .ur_pwdata
			apb_4_ur_pstrb             => CONNECTED_TO_apb_4_ur_pstrb,             --                           .ur_pstrb
			apb_4_ur_prready           => CONNECTED_TO_apb_4_ur_prready,           --                           .ur_prready
			apb_4_ur_prdata            => CONNECTED_TO_apb_4_ur_prdata,            --                           .ur_prdata
			apb_5_ur_paddr             => CONNECTED_TO_apb_5_ur_paddr,             --                      apb_5.ur_paddr
			apb_5_ur_psel              => CONNECTED_TO_apb_5_ur_psel,              --                           .ur_psel
			apb_5_ur_penable           => CONNECTED_TO_apb_5_ur_penable,           --                           .ur_penable
			apb_5_ur_pwrite            => CONNECTED_TO_apb_5_ur_pwrite,            --                           .ur_pwrite
			apb_5_ur_pwdata            => CONNECTED_TO_apb_5_ur_pwdata,            --                           .ur_pwdata
			apb_5_ur_pstrb             => CONNECTED_TO_apb_5_ur_pstrb,             --                           .ur_pstrb
			apb_5_ur_prready           => CONNECTED_TO_apb_5_ur_prready,           --                           .ur_prready
			apb_5_ur_prdata            => CONNECTED_TO_apb_5_ur_prdata,            --                           .ur_prdata
			wmc_clk_6_clk              => CONNECTED_TO_wmc_clk_6_clk,              --                  wmc_clk_6.clk
			wmc_clk_7_clk              => CONNECTED_TO_wmc_clk_7_clk,              --                  wmc_clk_7.clk
			phy_clk_6_clk              => CONNECTED_TO_phy_clk_6_clk,              --                  phy_clk_6.clk
			phy_clk_7_clk              => CONNECTED_TO_phy_clk_7_clk,              --                  phy_clk_7.clk
			wmcrst_n_6_reset_n         => CONNECTED_TO_wmcrst_n_6_reset_n,         --                 wmcrst_n_6.reset_n
			wmcrst_n_7_reset_n         => CONNECTED_TO_wmcrst_n_7_reset_n,         --                 wmcrst_n_7.reset_n
			ctrl_amm_6_0_waitrequest_n => CONNECTED_TO_ctrl_amm_6_0_waitrequest_n, --               ctrl_amm_6_0.waitrequest_n
			ctrl_amm_6_0_read          => CONNECTED_TO_ctrl_amm_6_0_read,          --                           .read
			ctrl_amm_6_0_write         => CONNECTED_TO_ctrl_amm_6_0_write,         --                           .write
			ctrl_amm_6_0_address       => CONNECTED_TO_ctrl_amm_6_0_address,       --                           .address
			ctrl_amm_6_0_readdata      => CONNECTED_TO_ctrl_amm_6_0_readdata,      --                           .readdata
			ctrl_amm_6_0_writedata     => CONNECTED_TO_ctrl_amm_6_0_writedata,     --                           .writedata
			ctrl_amm_6_0_burstcount    => CONNECTED_TO_ctrl_amm_6_0_burstcount,    --                           .burstcount
			ctrl_amm_6_0_byteenable    => CONNECTED_TO_ctrl_amm_6_0_byteenable,    --                           .byteenable
			ctrl_amm_6_0_readdatavalid => CONNECTED_TO_ctrl_amm_6_0_readdatavalid, --                           .readdatavalid
			ctrl_amm_6_1_waitrequest_n => CONNECTED_TO_ctrl_amm_6_1_waitrequest_n, --               ctrl_amm_6_1.waitrequest_n
			ctrl_amm_6_1_read          => CONNECTED_TO_ctrl_amm_6_1_read,          --                           .read
			ctrl_amm_6_1_write         => CONNECTED_TO_ctrl_amm_6_1_write,         --                           .write
			ctrl_amm_6_1_address       => CONNECTED_TO_ctrl_amm_6_1_address,       --                           .address
			ctrl_amm_6_1_readdata      => CONNECTED_TO_ctrl_amm_6_1_readdata,      --                           .readdata
			ctrl_amm_6_1_writedata     => CONNECTED_TO_ctrl_amm_6_1_writedata,     --                           .writedata
			ctrl_amm_6_1_burstcount    => CONNECTED_TO_ctrl_amm_6_1_burstcount,    --                           .burstcount
			ctrl_amm_6_1_byteenable    => CONNECTED_TO_ctrl_amm_6_1_byteenable,    --                           .byteenable
			ctrl_amm_6_1_readdatavalid => CONNECTED_TO_ctrl_amm_6_1_readdatavalid, --                           .readdatavalid
			ctrl_amm_7_0_waitrequest_n => CONNECTED_TO_ctrl_amm_7_0_waitrequest_n, --               ctrl_amm_7_0.waitrequest_n
			ctrl_amm_7_0_read          => CONNECTED_TO_ctrl_amm_7_0_read,          --                           .read
			ctrl_amm_7_0_write         => CONNECTED_TO_ctrl_amm_7_0_write,         --                           .write
			ctrl_amm_7_0_address       => CONNECTED_TO_ctrl_amm_7_0_address,       --                           .address
			ctrl_amm_7_0_readdata      => CONNECTED_TO_ctrl_amm_7_0_readdata,      --                           .readdata
			ctrl_amm_7_0_writedata     => CONNECTED_TO_ctrl_amm_7_0_writedata,     --                           .writedata
			ctrl_amm_7_0_burstcount    => CONNECTED_TO_ctrl_amm_7_0_burstcount,    --                           .burstcount
			ctrl_amm_7_0_byteenable    => CONNECTED_TO_ctrl_amm_7_0_byteenable,    --                           .byteenable
			ctrl_amm_7_0_readdatavalid => CONNECTED_TO_ctrl_amm_7_0_readdatavalid, --                           .readdatavalid
			ctrl_amm_7_1_waitrequest_n => CONNECTED_TO_ctrl_amm_7_1_waitrequest_n, --               ctrl_amm_7_1.waitrequest_n
			ctrl_amm_7_1_read          => CONNECTED_TO_ctrl_amm_7_1_read,          --                           .read
			ctrl_amm_7_1_write         => CONNECTED_TO_ctrl_amm_7_1_write,         --                           .write
			ctrl_amm_7_1_address       => CONNECTED_TO_ctrl_amm_7_1_address,       --                           .address
			ctrl_amm_7_1_readdata      => CONNECTED_TO_ctrl_amm_7_1_readdata,      --                           .readdata
			ctrl_amm_7_1_writedata     => CONNECTED_TO_ctrl_amm_7_1_writedata,     --                           .writedata
			ctrl_amm_7_1_burstcount    => CONNECTED_TO_ctrl_amm_7_1_burstcount,    --                           .burstcount
			ctrl_amm_7_1_byteenable    => CONNECTED_TO_ctrl_amm_7_1_byteenable,    --                           .byteenable
			ctrl_amm_7_1_readdatavalid => CONNECTED_TO_ctrl_amm_7_1_readdatavalid, --                           .readdatavalid
			ctrl_ecc_readdataerror_6_0 => CONNECTED_TO_ctrl_ecc_readdataerror_6_0, -- ctrl_ecc_readdataerror_6_0.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_6_1 => CONNECTED_TO_ctrl_ecc_readdataerror_6_1, -- ctrl_ecc_readdataerror_6_1.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_7_0 => CONNECTED_TO_ctrl_ecc_readdataerror_7_0, -- ctrl_ecc_readdataerror_7_0.ctrl_ecc_readdataerror
			ctrl_ecc_readdataerror_7_1 => CONNECTED_TO_ctrl_ecc_readdataerror_7_1, -- ctrl_ecc_readdataerror_7_1.ctrl_ecc_readdataerror
			apb_6_ur_paddr             => CONNECTED_TO_apb_6_ur_paddr,             --                      apb_6.ur_paddr
			apb_6_ur_psel              => CONNECTED_TO_apb_6_ur_psel,              --                           .ur_psel
			apb_6_ur_penable           => CONNECTED_TO_apb_6_ur_penable,           --                           .ur_penable
			apb_6_ur_pwrite            => CONNECTED_TO_apb_6_ur_pwrite,            --                           .ur_pwrite
			apb_6_ur_pwdata            => CONNECTED_TO_apb_6_ur_pwdata,            --                           .ur_pwdata
			apb_6_ur_pstrb             => CONNECTED_TO_apb_6_ur_pstrb,             --                           .ur_pstrb
			apb_6_ur_prready           => CONNECTED_TO_apb_6_ur_prready,           --                           .ur_prready
			apb_6_ur_prdata            => CONNECTED_TO_apb_6_ur_prdata,            --                           .ur_prdata
			apb_7_ur_paddr             => CONNECTED_TO_apb_7_ur_paddr,             --                      apb_7.ur_paddr
			apb_7_ur_psel              => CONNECTED_TO_apb_7_ur_psel,              --                           .ur_psel
			apb_7_ur_penable           => CONNECTED_TO_apb_7_ur_penable,           --                           .ur_penable
			apb_7_ur_pwrite            => CONNECTED_TO_apb_7_ur_pwrite,            --                           .ur_pwrite
			apb_7_ur_pwdata            => CONNECTED_TO_apb_7_ur_pwdata,            --                           .ur_pwdata
			apb_7_ur_pstrb             => CONNECTED_TO_apb_7_ur_pstrb,             --                           .ur_pstrb
			apb_7_ur_prready           => CONNECTED_TO_apb_7_ur_prready,           --                           .ur_prready
			apb_7_ur_prdata            => CONNECTED_TO_apb_7_ur_prdata             --                           .ur_prdata
		);

