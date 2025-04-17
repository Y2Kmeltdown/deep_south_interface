---------------------
; Table of Contents ;
---------------------
  1. About this file
  2. Outputs of IP generation
  3. Instantiating IP in a Quartus Prime project
  4. I/O assignments
  5. User register interface 0
  6. AXI interface 0_1
  7. AXI interface 0_0
  8. AXI extra signals interface 0_1
  9. AXI extra signals interface 0_0
 10. Calibrated latency
 11. External core clock
 12. Lock signal for external core clock
 13. HBM-only active high reset input
 14. HBM2 interface for HBM2 Global and IEEE1500 signals
 15. Memory interface 0
 16. PHY clock for UIB interface 0
 17. PLL reference clock
 18. PHY calibration status interface
 19. Core clock active low reset 0
 20. Core clock active low reset input
 21. Core clock 0
 22. Instantiating IP in a simulation project
 23. IP Settings
 24. Configuring the Traffic Generator


------------------------
;   1. About this file ;
------------------------

   This is the readme file for the High Bandwidth Memory (HBM2) Interface Intel FPGA IP v19.1.
   
   The file provides a high-level overview of the IP. For details, refer to the
   handbook chapter on Stratix 10 High Bandwidth Memory Interface.
   
   This file was auto-generated.


---------------------------------
;   2. Outputs of IP generation ;
---------------------------------

   IP generation supports the following output filesets:
   
      Synthesis            - This is the fileset you should use when instantiating the IP in
                             your Quartus Prime project. RTL files in this fileset can be
                             simulated, but your simulator must support SystemVerilog.
                             Simulating the synthesis files yields identical results as
                             simulating the simulation files.
   
      Simulation           - This fileset contains scripts and source files to help you
                             integrate the IP into your simulation project targeting a
                             3rd-party simulator of your choice. If you select VHDL
                             during IP generation, the fileset contains IEEE-encrypted
                             Verilog files that can be used in VHDL-only simulators, such
                             as ModelSim - Intel FPGA edition. All source files in the simulation
                             filesets are functionally equivalent to the synthesis fileset.
   
      Example Design       - This fileset contains scripts to generate example Quartus Prime project
                             and simulation projects for 3rd-party simulators. An example
                             design contains an instantiation of the IP, a simple traffic
                             generator, and in the case of a simulation example design, a
                             simple memory model.


----------------------------------------------------
;   3. Instantiating IP in a Quartus Prime project ;
----------------------------------------------------

   If you instantiate the IP as part of a Qsys system, follow the Qsys
   documentation on how to instantiate the system in a Quartus Prime project.
   
   If the IP was generated as a standalone component, it is sufficient to add
   the generated .qip file from the synthesis fileset to your Quartus Prime project.
   The .qip file allows the Quartus Prime software to locate all the files of
   the IP, including RTL files, SDC files, hex files, and timing scripts. Once the
   .qip file is added, you can instantiate the memory interface in your RTL.


------------------------
;   4. I/O assignments ;
------------------------

   The generated .qip file in the synthesis fileset contains the I/O standard and input/output
   termination assignments required by the memory interface pins to function correctly.
   The values to the assignments are based on user inputs provided during generation.
   
   Unlike previous EMIF IP, there is no need to manually run a *_pin_assignments.tcl
   script to annotate the assignments into the project's .qsf file.
   Assignments in the .qip file are read and applied during every compilation, regardless
   of how you name the memory interface pins in your design top-level component. No new
   assignment is created in the project's .qsf file during the process.
   
   You should never edit the generated .qip file, because changes made to this file
   are overwritten when you regenerate the IP. To override an I/O assignment made in
   the .qip file, simply add an assignment to the project's .qsf file. Assignments in
   the .qsf file always take precedence over those in the .qip file. Note that I/O
   assignments in the .qsf file must specify the names of your top-level pins as
   target (i.e. -to), and you must not use the -entity and -library options.
   
   Consult the .qip file for the set of I/O assignments that come with the IP.


----------------------------------
;   5. User register interface 0 ;
----------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ur_paddr_0                     16      input       Address
   ur_penable_0                   1       input       Enable for multi-cycle burst (drive to 0)
   ur_prdata_0                    16      output      Read data
   ur_prready_0                   1       output      Ready
   ur_psel_0                      1       input       Select
   ur_pstrb_0                     2       input       Byte enable for write data
   ur_pwdata_0                    16      input       Write data
   ur_pwrite_0                    1       input       Write


--------------------------
;   6. AXI interface 0_1 ;
--------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   araddr_0_1                     29      input       Read address
   arburst_0_1                    2       input       Read burst type
   arid_0_1                       9       input       Read address ID
   arlen_0_1                      8       input       Read length
   arprot_0_1                     3       input       Read protection
   arqos_0_1                      4       input       Read QoS (priority)
   arready_0_1                    1       output      Read address ready
   arsize_0_1                     3       input       Read size
   aruser_ap_0_1                  1       input       User auto-precharge
   arvalid_0_1                    1       input       Read address valid
   awaddr_0_1                     29      input       Write address
   awburst_0_1                    2       input       Write burst type
   awid_0_1                       9       input       Write address ID
   awlen_0_1                      8       input       Write length
   awprot_0_1                     3       input       Write protection
   awqos_0_1                      4       input       Write QoS (priority)
   awready_0_1                    1       output      Write address ready
   awsize_0_1                     3       input       Write size
   awuser_ap_0_1                  1       input       User auto-precharge
   awvalid_0_1                    1       input       Write address valid
   bid_0_1                        9       output      Write response ID
   bready_0_1                     1       input       Write data response ready
   bresp_0_1                      2       output      Write data response
   bvalid_0_1                     1       output      Write data response valid
   rdata_0_1                      256     output      Read data
   rid_0_1                        9       output      Read ID
   rlast_0_1                      1       output      Read last transfer in burst
   rready_0_1                     1       input       Read data ready
   rresp_0_1                      2       output      Read response
   rvalid_0_1                     1       output      Read data valid
   wdata_0_1                      256     input       Write data
   wlast_0_1                      1       input       Write last transfer in burst
   wready_0_1                     1       output      Write data ready
   wstrb_0_1                      32      input       Write strobe (byte enable)
   wvalid_0_1                     1       input       Write data valid


--------------------------
;   7. AXI interface 0_0 ;
--------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   araddr_0_0                     29      input       Read address
   arburst_0_0                    2       input       Read burst type
   arid_0_0                       9       input       Read address ID
   arlen_0_0                      8       input       Read length
   arprot_0_0                     3       input       Read protection
   arqos_0_0                      4       input       Read QoS (priority)
   arready_0_0                    1       output      Read address ready
   arsize_0_0                     3       input       Read size
   aruser_ap_0_0                  1       input       User auto-precharge
   arvalid_0_0                    1       input       Read address valid
   awaddr_0_0                     29      input       Write address
   awburst_0_0                    2       input       Write burst type
   awid_0_0                       9       input       Write address ID
   awlen_0_0                      8       input       Write length
   awprot_0_0                     3       input       Write protection
   awqos_0_0                      4       input       Write QoS (priority)
   awready_0_0                    1       output      Write address ready
   awsize_0_0                     3       input       Write size
   awuser_ap_0_0                  1       input       User auto-precharge
   awvalid_0_0                    1       input       Write address valid
   bid_0_0                        9       output      Write response ID
   bready_0_0                     1       input       Write data response ready
   bresp_0_0                      2       output      Write data response
   bvalid_0_0                     1       output      Write data response valid
   rdata_0_0                      256     output      Read data
   rid_0_0                        9       output      Read ID
   rlast_0_0                      1       output      Read last transfer in burst
   rready_0_0                     1       input       Read data ready
   rresp_0_0                      2       output      Read response
   rvalid_0_0                     1       output      Read data valid
   wdata_0_0                      256     input       Write data
   wlast_0_0                      1       input       Write last transfer in burst
   wready_0_0                     1       output      Write data ready
   wstrb_0_0                      32      input       Write strobe (byte enable)
   wvalid_0_0                     1       input       Write data valid


----------------------------------------
;   8. AXI extra signals interface 0_1 ;
----------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ruser_data_0_1                 32      output      Extra read data from HBM CB bits
   ruser_err_dbe_0_1              1       output      Read data error
   wuser_data_0_1                 32      input       Extra write data to HBM CB bits
   wuser_strb_0_1                 4       input       Extra write strobe for wuser_data


----------------------------------------
;   9. AXI extra signals interface 0_0 ;
----------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ruser_data_0_0                 32      output      Extra read data from HBM CB bits
   ruser_err_dbe_0_0              1       output      Read data error
   wuser_data_0_0                 32      input       Extra write data to HBM CB bits
   wuser_strb_0_0                 4       input       Extra write strobe for wuser_data


---------------------------
;  10. Calibrated latency ;
---------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   cal_lat                        3       output      Calibrated latency value


----------------------------
;  11. External core clock ;
----------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ext_core_clk                   1       input       External core clock


--------------------------------------------
;  12. Lock signal for external core clock ;
--------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ext_core_clk_locked            1       input       Indicates that the core clock is stable


-----------------------------------------
;  13. HBM-only active high reset input ;
-----------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   hbm_only_reset_in              1       input       Reset for HBM controller and memory.  Performs recalibration.


------------------------------------------------------------
;  14. HBM2 interface for HBM2 Global and IEEE1500 signals ;
------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   capturewr                      1       input       capturewr
   cattrip                        1       output      cattrip
   reset_n                        1       input       reset_n
   selectwir                      1       input       selectwir
   shiftwr                        1       input       shiftwr
   temp                           3       output      temp
   updatewr                       1       input       updatewr
   wrck                           1       input       wrck
   wrst_n                         1       input       wrst_n
   wsi                            1       input       wsi
   wso                            8       output      wso


---------------------------
;  15. Memory interface 0 ;
---------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   aerr_0                         1       output      Address command parity error
   c_0                            8       input       Column command
   cke_0                          1       input       Memory clock enable
   ck_c_0                         1       input       Memory clock
   ck_t_0                         1       input       Memory clock
   dbi_0                          16      bidir       Data bus inversion
   derr_0                         4       bidir       Data parity error
   dm_0                           16      bidir       Data mask
   dq_0                           128     bidir       Data
   par_0                          4       bidir       Parity
   r_0                            6       input       Row command
   rc_0                           1       input       Redundant column command pin for lane remapping
   rd_0                           8       bidir       Redundant data pins for lane remapping
   rdqs_c_0                       4       output      Read data strobe
   rdqs_t_0                       4       output      Read data strobe
   rr_0                           1       input       Redundant row command pin for lane remapping
   wdqs_c_0                       4       input       Write data strobe
   wdqs_t_0                       4       input       Write data strobe


--------------------------------------
;  16. PHY clock for UIB interface 0 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   phy_clk_0                      1       output      PHY clock


----------------------------
;  17. PLL reference clock ;
----------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   pll_ref_clk                    1       input       PLL reference clock


-----------------------------------------
;  18. PHY calibration status interface ;
-----------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   local_cal_fail                 1       output      When high, indicates that PHY calibration failed
   local_cal_success              1       output      When high, indicates that PHY calibration was successful


--------------------------------------
;  19. Core clock active low reset 0 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmcrst_n_0                     1       output      Reset


------------------------------------------
;  20. Core clock active low reset input ;
------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmcrst_n_in                    1       input       Reset


---------------------
;  21. Core clock 0 ;
---------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmc_clk_0                      1       output      Wide memory controller clock


-------------------------------------------------
;  22. Instantiating IP in a simulation project ;
-------------------------------------------------

   The simulation fileset as well as the simulation example design contain scripts
   that illustrate what files are required when including the HBM IP for simulation.
   The scripts are customized for all the 3rd-party simulators supported. It is highly
   recommended that you use these scripts as reference when setting up your simulation
   environment.


--------------------
;  23. IP Settings ;
--------------------

   SYS_INFO_DEVICE_FAMILY                            : Stratix 10
   SYS_INFO_DEVICE                                   : 1SM21CHU2F53E2VG
   SYS_INFO_DEVICE_SPEEDGRADE                        : 2
   SYS_INFO_DEVICE_DIE_REVISIONS                     : HSSI_CRETE2E_REVB MAIN_ND4H_REVB UIB_HBM_REVB
   TRAIT_SUPPORTS_VID                                : 1
   TRAIT_DEVICE_TEMPERATURE_GRADE                    : EXTENDED
   PROTOCOL_ENUM                                     : PROTOCOL_HBM
   INTERNAL_TESTING_MODE                             : false
   PHY_CONFIG_ENUM                                   : CONFIG_PHY_AND_HARD_CTRL
   PHY_RATE_ENUM                                     : RATE_HALF
   PHY_DEFAULT_REF_CLK_FREQ                          : false
   PHY_C2P_RATE_ENUM                                 : RATE_HALF
   PHY_MEM_CLK_FREQ_MHZ                              : 600.0
   PHY_CORE_CLK_FREQ_MHZ                             : 300.0
   PHY_HBM_LOCATION                                  : TOP
   PHY_HBM_DEVICE_USER                               : HBM_DEVICE_EMPTY
   PHY_HBM_VENDOR_USER                               : VENDOR_EMPTY
   PHY_USER_REF_CLK_FREQ_MHZ                         : 200.0
   PHY_DEFAULT_CORE_REF_CLK_FREQ                     : false
   PHY_USER_CORE_REF_CLK_FREQ_MHZ                    : 300.0
   PHY_THROTTLE_RDATA_BRESP                          : true
   PHY_BACKPRESSURE_LATENCY                          : CYCLE_2
   PHY_PLACE_BACKPRESSURE_REGS                       : true
   PHY_PIPELINE_RRESP                                : 0
   PHY_PIPELINE_BRESP                                : 0
   PHY_RX_PIPELINE_EN                                : 1
   PHY_TX_PIPELINE_EN                                : 0
   PHY_TEMP_THROTTLE_THRESHOLD                       : 85
   PHY_TEMP_THROTTLE_RATIO                           : 50
   PHY_DEBOUNCE_PERIOD_MS                            : 20
   PHY_ADVANCED_PARAM_EN                             : false
   PHY_RESET_DEBOUNCE_EN                             : false
   PHY_AXI_SWITCH_0_EN                               : false
   PHY_AXI_SWITCH_1_EN                               : false
   PHY_AXI_SWITCH_2_EN                               : false
   PHY_AXI_SWITCH_3_EN                               : false
   PHY_AXI_SWITCH_LOGICLOCK                          : false
   PHY_CH0_EN                                        : true
   PHY_CH1_EN                                        : false
   PHY_CH2_EN                                        : false
   PHY_CH3_EN                                        : false
   PHY_CH4_EN                                        : false
   PHY_CH5_EN                                        : false
   PHY_CH6_EN                                        : false
   PHY_CH7_EN                                        : false
   PHY_SW_0_MASTER_0_SHARE_COUNT                     : 0
   PHY_SW_0_MASTER_1_SHARE_COUNT                     : 0
   PHY_SW_0_MASTER_2_SHARE_COUNT                     : 0
   PHY_SW_0_MASTER_3_SHARE_COUNT                     : 0
   PHY_SW_0_SLAVE_0_SHARE_COUNT                      : 0
   PHY_SW_0_SLAVE_1_SHARE_COUNT                      : 0
   PHY_SW_0_SLAVE_2_SHARE_COUNT                      : 0
   PHY_SW_0_SLAVE_3_SHARE_COUNT                      : 0
   PHY_SW_0_MASTER_HONOR_REQ                         : 0
   PHY_SW_0_SLAVE_HONOR_REQ                          : 0
   PHY_SW_1_MASTER_0_SHARE_COUNT                     : 0
   PHY_SW_1_MASTER_1_SHARE_COUNT                     : 0
   PHY_SW_1_MASTER_2_SHARE_COUNT                     : 0
   PHY_SW_1_MASTER_3_SHARE_COUNT                     : 0
   PHY_SW_1_SLAVE_0_SHARE_COUNT                      : 0
   PHY_SW_1_SLAVE_1_SHARE_COUNT                      : 0
   PHY_SW_1_SLAVE_2_SHARE_COUNT                      : 0
   PHY_SW_1_SLAVE_3_SHARE_COUNT                      : 0
   PHY_SW_1_MASTER_HONOR_REQ                         : 0
   PHY_SW_1_SLAVE_HONOR_REQ                          : 0
   PHY_SW_2_MASTER_0_SHARE_COUNT                     : 0
   PHY_SW_2_MASTER_1_SHARE_COUNT                     : 0
   PHY_SW_2_MASTER_2_SHARE_COUNT                     : 0
   PHY_SW_2_MASTER_3_SHARE_COUNT                     : 0
   PHY_SW_2_SLAVE_0_SHARE_COUNT                      : 0
   PHY_SW_2_SLAVE_1_SHARE_COUNT                      : 0
   PHY_SW_2_SLAVE_2_SHARE_COUNT                      : 0
   PHY_SW_2_SLAVE_3_SHARE_COUNT                      : 0
   PHY_SW_2_MASTER_HONOR_REQ                         : 0
   PHY_SW_2_SLAVE_HONOR_REQ                          : 0
   PHY_SW_3_MASTER_0_SHARE_COUNT                     : 0
   PHY_SW_3_MASTER_1_SHARE_COUNT                     : 0
   PHY_SW_3_MASTER_2_SHARE_COUNT                     : 0
   PHY_SW_3_MASTER_3_SHARE_COUNT                     : 0
   PHY_SW_3_SLAVE_0_SHARE_COUNT                      : 0
   PHY_SW_3_SLAVE_1_SHARE_COUNT                      : 0
   PHY_SW_3_SLAVE_2_SHARE_COUNT                      : 0
   PHY_SW_3_SLAVE_3_SHARE_COUNT                      : 0
   PHY_SW_3_MASTER_HONOR_REQ                         : 0
   PHY_SW_3_SLAVE_HONOR_REQ                          : 0
   freshIP                                           : true
   PHY_HBM_AXI_INTERFACE_0                           : true
   PHY_HBM_AXI_INTERFACE_1                           : true
   PHY_HBM_AXI_INTERFACE_2                           : true
   PHY_HBM_AXI_INTERFACE_3                           : true
   PLL_ADD_EXTRA_CLKS                                : 0
   PLL_USER_NUM_OF_EXTRA_CLKS                        : 0
   PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_0              : 0
   PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_1              : 0
   PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_2              : 0
   PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_3              : 0
   PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_4              : 0
   PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_5              : 100.0
   PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_5               : 100.0
   PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_5              : 0
   PLL_EXTRA_CLK_DESIRED_PHASE_GUI_5                 : 0.0
   PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_5               : 0.0
   PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_5              : 0.0
   PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_5            : 50.0
   PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_5             : 50.0
   PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_6              : 100.0
   PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_6               : 100.0
   PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_6              : 0
   PLL_EXTRA_CLK_DESIRED_PHASE_GUI_6                 : 0.0
   PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_6               : 0.0
   PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_6              : 0.0
   PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_6            : 50.0
   PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_6             : 50.0
   PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_7              : 100.0
   PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_7               : 100.0
   PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_7              : 0
   PLL_EXTRA_CLK_DESIRED_PHASE_GUI_7                 : 0.0
   PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_7               : 0.0
   PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_7              : 0.0
   PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_7            : 50.0
   PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_7             : 50.0
   PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_8              : 100.0
   PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_8               : 100.0
   PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_8              : 0
   PLL_EXTRA_CLK_DESIRED_PHASE_GUI_8                 : 0.0
   PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_8               : 0.0
   PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_8              : 0.0
   PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_8            : 50.0
   PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_8             : 50.0
   CTRL_CH0_CLONE_OF_ID_STR                          : None
   CTRL_CH0_AVMM_PRECHARGE_EN                        : false
   CTRL_CH0_AVMM_CMD_PRIOR_CTRL_EN                   : false
   CTRL_CH0_BL_ADVC_EN                               : false
   CTRL_CH0_BL_ADVC_VAL                              : 3
   HARD_CTRL_CH0_RFSH_POLICY_OVERRIDE                : RFSH_POLICY_FLEXIBLE
   HARD_CTRL_CH0_CFG_HBMC_MODES_OVERRIDE             : PROD
   HARD_CTRL_CH0_CFG_TR_ORDER                        : true
   HARD_CTRL_CH0_CFG_ADDR_ORDER                      : BGRBC
   HARD_CTRL_CH0_CFG_USER_RD_AP_POL                  : RDAP_HINT
   HARD_CTRL_CH0_CFG_USER_WR_AP_POL                  : WRAP_HINT
   HARD_CTRL_CH0_RFSH_MODE                           : RFSH_MODE_CTRL_RFSH_ALL
   HARD_CTRL_CH0_CFG_HBMC_PC0_WL_OVERRIDE            : 7
   HARD_CTRL_CH0_CFG_HBMC_PC0_RL_OVERRIDE            : 20
   HARD_CTRL_CH0_CFG_HBMC_PC0_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH0_CFG_HBMC_PC1_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH0_CFG_USER_DATA_WIDTH                 : B256
   HARD_CTRL_CH0_CFG_MECC_EN                         : false
   HARD_CTRL_CH0_CFG_WR_DM_EN                        : false
   HARD_CTRL_CH0_CFG_POWER_DOWN_EN                   : true
   HARD_CTRL_CH0_CFG_PSEUDO_BL8_EN                   : true
   HARD_CTRL_CH0_CFG_THROTTLE_EN                     : false
   CTRL_CH1_CLONE_OF_ID_STR                          : None
   CTRL_CH1_AVMM_PRECHARGE_EN                        : false
   CTRL_CH1_AVMM_CMD_PRIOR_CTRL_EN                   : false
   CTRL_CH1_BL_ADVC_EN                               : false
   CTRL_CH1_BL_ADVC_VAL                              : 3
   HARD_CTRL_CH1_RFSH_POLICY_OVERRIDE                : RFSH_POLICY_FLEXIBLE
   HARD_CTRL_CH1_CFG_HBMC_MODES_OVERRIDE             : PROD
   HARD_CTRL_CH1_CFG_TR_ORDER                        : true
   HARD_CTRL_CH1_CFG_ADDR_ORDER                      : BGRBC
   HARD_CTRL_CH1_CFG_USER_RD_AP_POL                  : RDAP_HINT
   HARD_CTRL_CH1_CFG_USER_WR_AP_POL                  : WRAP_HINT
   HARD_CTRL_CH1_RFSH_MODE                           : RFSH_MODE_CTRL_RFSH_ALL
   HARD_CTRL_CH1_CFG_HBMC_PC0_WL_OVERRIDE            : 7
   HARD_CTRL_CH1_CFG_HBMC_PC0_RL_OVERRIDE            : 20
   HARD_CTRL_CH1_CFG_HBMC_PC0_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH1_CFG_HBMC_PC1_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH1_CFG_USER_DATA_WIDTH                 : B256
   HARD_CTRL_CH1_CFG_MECC_EN                         : false
   HARD_CTRL_CH1_CFG_WR_DM_EN                        : false
   HARD_CTRL_CH1_CFG_POWER_DOWN_EN                   : true
   HARD_CTRL_CH1_CFG_PSEUDO_BL8_EN                   : true
   HARD_CTRL_CH1_CFG_THROTTLE_EN                     : false
   CTRL_CH2_CLONE_OF_ID_STR                          : None
   CTRL_CH2_AVMM_PRECHARGE_EN                        : false
   CTRL_CH2_AVMM_CMD_PRIOR_CTRL_EN                   : false
   CTRL_CH2_BL_ADVC_EN                               : false
   CTRL_CH2_BL_ADVC_VAL                              : 3
   HARD_CTRL_CH2_RFSH_POLICY_OVERRIDE                : RFSH_POLICY_FLEXIBLE
   HARD_CTRL_CH2_CFG_HBMC_MODES_OVERRIDE             : PROD
   HARD_CTRL_CH2_CFG_TR_ORDER                        : true
   HARD_CTRL_CH2_CFG_ADDR_ORDER                      : BGRBC
   HARD_CTRL_CH2_CFG_USER_RD_AP_POL                  : RDAP_HINT
   HARD_CTRL_CH2_CFG_USER_WR_AP_POL                  : WRAP_HINT
   HARD_CTRL_CH2_RFSH_MODE                           : RFSH_MODE_CTRL_RFSH_ALL
   HARD_CTRL_CH2_CFG_HBMC_PC0_WL_OVERRIDE            : 7
   HARD_CTRL_CH2_CFG_HBMC_PC0_RL_OVERRIDE            : 20
   HARD_CTRL_CH2_CFG_HBMC_PC0_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH2_CFG_HBMC_PC1_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH2_CFG_USER_DATA_WIDTH                 : B256
   HARD_CTRL_CH2_CFG_MECC_EN                         : false
   HARD_CTRL_CH2_CFG_WR_DM_EN                        : false
   HARD_CTRL_CH2_CFG_POWER_DOWN_EN                   : true
   HARD_CTRL_CH2_CFG_PSEUDO_BL8_EN                   : true
   HARD_CTRL_CH2_CFG_THROTTLE_EN                     : false
   CTRL_CH3_CLONE_OF_ID_STR                          : None
   CTRL_CH3_AVMM_PRECHARGE_EN                        : false
   CTRL_CH3_AVMM_CMD_PRIOR_CTRL_EN                   : false
   CTRL_CH3_BL_ADVC_EN                               : false
   CTRL_CH3_BL_ADVC_VAL                              : 3
   HARD_CTRL_CH3_RFSH_POLICY_OVERRIDE                : RFSH_POLICY_FLEXIBLE
   HARD_CTRL_CH3_CFG_HBMC_MODES_OVERRIDE             : PROD
   HARD_CTRL_CH3_CFG_TR_ORDER                        : true
   HARD_CTRL_CH3_CFG_ADDR_ORDER                      : BGRBC
   HARD_CTRL_CH3_CFG_USER_RD_AP_POL                  : RDAP_HINT
   HARD_CTRL_CH3_CFG_USER_WR_AP_POL                  : WRAP_HINT
   HARD_CTRL_CH3_RFSH_MODE                           : RFSH_MODE_CTRL_RFSH_ALL
   HARD_CTRL_CH3_CFG_HBMC_PC0_WL_OVERRIDE            : 7
   HARD_CTRL_CH3_CFG_HBMC_PC0_RL_OVERRIDE            : 20
   HARD_CTRL_CH3_CFG_HBMC_PC0_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH3_CFG_HBMC_PC1_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH3_CFG_USER_DATA_WIDTH                 : B256
   HARD_CTRL_CH3_CFG_MECC_EN                         : false
   HARD_CTRL_CH3_CFG_WR_DM_EN                        : false
   HARD_CTRL_CH3_CFG_POWER_DOWN_EN                   : true
   HARD_CTRL_CH3_CFG_PSEUDO_BL8_EN                   : true
   HARD_CTRL_CH3_CFG_THROTTLE_EN                     : false
   CTRL_CH4_CLONE_OF_ID_STR                          : None
   CTRL_CH4_AVMM_PRECHARGE_EN                        : false
   CTRL_CH4_AVMM_CMD_PRIOR_CTRL_EN                   : false
   CTRL_CH4_BL_ADVC_EN                               : false
   CTRL_CH4_BL_ADVC_VAL                              : 3
   HARD_CTRL_CH4_RFSH_POLICY_OVERRIDE                : RFSH_POLICY_FLEXIBLE
   HARD_CTRL_CH4_CFG_HBMC_MODES_OVERRIDE             : PROD
   HARD_CTRL_CH4_CFG_TR_ORDER                        : true
   HARD_CTRL_CH4_CFG_ADDR_ORDER                      : BGRBC
   HARD_CTRL_CH4_CFG_USER_RD_AP_POL                  : RDAP_HINT
   HARD_CTRL_CH4_CFG_USER_WR_AP_POL                  : WRAP_HINT
   HARD_CTRL_CH4_RFSH_MODE                           : RFSH_MODE_CTRL_RFSH_ALL
   HARD_CTRL_CH4_CFG_HBMC_PC0_WL_OVERRIDE            : 7
   HARD_CTRL_CH4_CFG_HBMC_PC0_RL_OVERRIDE            : 20
   HARD_CTRL_CH4_CFG_HBMC_PC0_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH4_CFG_HBMC_PC1_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH4_CFG_USER_DATA_WIDTH                 : B256
   HARD_CTRL_CH4_CFG_MECC_EN                         : false
   HARD_CTRL_CH4_CFG_WR_DM_EN                        : false
   HARD_CTRL_CH4_CFG_POWER_DOWN_EN                   : true
   HARD_CTRL_CH4_CFG_PSEUDO_BL8_EN                   : true
   HARD_CTRL_CH4_CFG_THROTTLE_EN                     : false
   CTRL_CH5_CLONE_OF_ID_STR                          : None
   CTRL_CH5_AVMM_PRECHARGE_EN                        : false
   CTRL_CH5_AVMM_CMD_PRIOR_CTRL_EN                   : false
   CTRL_CH5_BL_ADVC_EN                               : false
   CTRL_CH5_BL_ADVC_VAL                              : 3
   HARD_CTRL_CH5_RFSH_POLICY_OVERRIDE                : RFSH_POLICY_FLEXIBLE
   HARD_CTRL_CH5_CFG_HBMC_MODES_OVERRIDE             : PROD
   HARD_CTRL_CH5_CFG_TR_ORDER                        : true
   HARD_CTRL_CH5_CFG_ADDR_ORDER                      : BGRBC
   HARD_CTRL_CH5_CFG_USER_RD_AP_POL                  : RDAP_HINT
   HARD_CTRL_CH5_CFG_USER_WR_AP_POL                  : WRAP_HINT
   HARD_CTRL_CH5_RFSH_MODE                           : RFSH_MODE_CTRL_RFSH_ALL
   HARD_CTRL_CH5_CFG_HBMC_PC0_WL_OVERRIDE            : 7
   HARD_CTRL_CH5_CFG_HBMC_PC0_RL_OVERRIDE            : 20
   HARD_CTRL_CH5_CFG_HBMC_PC0_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH5_CFG_HBMC_PC1_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH5_CFG_USER_DATA_WIDTH                 : B256
   HARD_CTRL_CH5_CFG_MECC_EN                         : false
   HARD_CTRL_CH5_CFG_WR_DM_EN                        : false
   HARD_CTRL_CH5_CFG_POWER_DOWN_EN                   : true
   HARD_CTRL_CH5_CFG_PSEUDO_BL8_EN                   : true
   HARD_CTRL_CH5_CFG_THROTTLE_EN                     : false
   CTRL_CH6_CLONE_OF_ID_STR                          : None
   CTRL_CH6_AVMM_PRECHARGE_EN                        : false
   CTRL_CH6_AVMM_CMD_PRIOR_CTRL_EN                   : false
   CTRL_CH6_BL_ADVC_EN                               : false
   CTRL_CH6_BL_ADVC_VAL                              : 3
   HARD_CTRL_CH6_RFSH_POLICY_OVERRIDE                : RFSH_POLICY_FLEXIBLE
   HARD_CTRL_CH6_CFG_HBMC_MODES_OVERRIDE             : PROD
   HARD_CTRL_CH6_CFG_TR_ORDER                        : true
   HARD_CTRL_CH6_CFG_ADDR_ORDER                      : BGRBC
   HARD_CTRL_CH6_CFG_USER_RD_AP_POL                  : RDAP_HINT
   HARD_CTRL_CH6_CFG_USER_WR_AP_POL                  : WRAP_HINT
   HARD_CTRL_CH6_RFSH_MODE                           : RFSH_MODE_CTRL_RFSH_ALL
   HARD_CTRL_CH6_CFG_HBMC_PC0_WL_OVERRIDE            : 7
   HARD_CTRL_CH6_CFG_HBMC_PC0_RL_OVERRIDE            : 20
   HARD_CTRL_CH6_CFG_HBMC_PC0_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH6_CFG_HBMC_PC1_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH6_CFG_USER_DATA_WIDTH                 : B256
   HARD_CTRL_CH6_CFG_MECC_EN                         : false
   HARD_CTRL_CH6_CFG_WR_DM_EN                        : false
   HARD_CTRL_CH6_CFG_POWER_DOWN_EN                   : true
   HARD_CTRL_CH6_CFG_PSEUDO_BL8_EN                   : true
   HARD_CTRL_CH6_CFG_THROTTLE_EN                     : false
   CTRL_CH7_CLONE_OF_ID_STR                          : None
   CTRL_CH7_AVMM_PRECHARGE_EN                        : false
   CTRL_CH7_AVMM_CMD_PRIOR_CTRL_EN                   : false
   CTRL_CH7_BL_ADVC_EN                               : false
   CTRL_CH7_BL_ADVC_VAL                              : 3
   HARD_CTRL_CH7_RFSH_POLICY_OVERRIDE                : RFSH_POLICY_FLEXIBLE
   HARD_CTRL_CH7_CFG_HBMC_MODES_OVERRIDE             : PROD
   HARD_CTRL_CH7_CFG_TR_ORDER                        : true
   HARD_CTRL_CH7_CFG_ADDR_ORDER                      : BGRBC
   HARD_CTRL_CH7_CFG_USER_RD_AP_POL                  : RDAP_HINT
   HARD_CTRL_CH7_CFG_USER_WR_AP_POL                  : WRAP_HINT
   HARD_CTRL_CH7_RFSH_MODE                           : RFSH_MODE_CTRL_RFSH_ALL
   HARD_CTRL_CH7_CFG_HBMC_PC0_WL_OVERRIDE            : 7
   HARD_CTRL_CH7_CFG_HBMC_PC0_RL_OVERRIDE            : 20
   HARD_CTRL_CH7_CFG_HBMC_PC0_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH7_CFG_HBMC_PC1_SCR_EN_OVERRIDE        : true
   HARD_CTRL_CH7_CFG_USER_DATA_WIDTH                 : B256
   HARD_CTRL_CH7_CFG_MECC_EN                         : false
   HARD_CTRL_CH7_CFG_WR_DM_EN                        : false
   HARD_CTRL_CH7_CFG_POWER_DOWN_EN                   : true
   HARD_CTRL_CH7_CFG_PSEUDO_BL8_EN                   : true
   HARD_CTRL_CH7_CFG_THROTTLE_EN                     : false
   DIAG_ABSTRACT_PHY                                 : true
   DIAG_ENABLE_PHY                                   : true
   DIAG_ENABLE_JTAG_UART                             : false
   DIAG_ENABLE_JTAG_UART_HEX                         : false
   DIAG_RUN_DEFAULT_PATTERN                          : true
   DIAG_RUN_USER_STAGE                               : false
   DIAG_TIMING_REGTEST_MODE                          : false
   DIAG_RUN_REPEAT_STAGE                             : false
   DIAG_RUN_STRESS_STAGE                             : false
   DIAG_FORCE_GENERATE_RW_IDS                        : false
   DIAG_EFFICIENCY_MONITOR                           : false
   DIAG_HBMC_TEST_MODE                               : false
   DIAG_HBMC_TEST_PATTERN                            : 0
   DIAG_MIXED_TRAFFIC                                : false
   DIAG_FAST_SIM_PLL                                 : true
   DIAG_WR_PAR_DERR                                  : false
   DIAG_RD_PAR_DERR                                  : false
   DIAG_SBE_ECC                                      : false
   DIAG_INFI_TG_ERR                                  : false
   DIAG_EXTRA_CONFIGS                                : 
   DIAG_EX_DESIGN_ISSP_EN                            : true
   DIAG_SKIP_CAL                                     : true
   DIAG_HBM_LFSR                                     : false
   DIAG_TG_EXPORT_CFG_INTERFACE                      : false
   DIAG_TEST_RANDOM_AXI_READY                        : false
   DIAG_EXPORT_F2C_SLAVE                             : false
   DIAG_EXPORT_UIBPLL_LOCKED                         : false
   TG_CFG_EN                                         : false
   DIAG_TG_READ_COUNT                                : 5000
   DIAG_TG_WRITE_COUNT                               : 2500
   DIAG_TG_SEQUENCE                                  : TG_SEQUENCE_RANDOM
   TG_USE_EFFICIENCY_PATTERN                         : false
   DIAG_TG_EFF_DATA_CHECK_EN                         : true
   DIAG_MEM_VERBOSE_DIS                              : false
   DIAG_RW_DATA_MONITOR                              : false
   PHY_HBM_USER_PLL_REF_CLK_IO_STD_ENUM              : LVDS_NO_ONCHIP_TERMINATION
   EX_DESIGN_GUI_GEN_SIM                             : true
   EX_DESIGN_GUI_GEN_SYNTH                           : true
   EX_DESIGN_GUI_HDL_FORMAT                          : HDL_FORMAT_VHDL


------------------------------------------
;  24. Configuring the Traffic Generator ;
------------------------------------------

   The AXI traffic generator is a built-in verification solution for the HBM IP.
   It has many configuration options. These include options in read/write command,
   address, data and data-mask generation. The AXI traffic generator
   can be used in simulation and hardware verification.
   
   For full details concerning the traffic generator, consult the HBM Handbook.


