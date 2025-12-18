---------------------
; Table of Contents ;
---------------------
  1. About this file
  2. Outputs of IP generation
  3. Instantiating IP in a Quartus Prime project
  4. I/O assignments
  5. User register interface 0
  6. User register interface 1
  7. User register interface 2
  8. User register interface 3
  9. User register interface 4
 10. User register interface 5
 11. User register interface 6
 12. User register interface 7
 13. Calibrated latency
 14. Controller Avalon Memory-Mapped interface 0_0
 15. Controller Avalon Memory-Mapped interface 0_1
 16. Controller Avalon Memory-Mapped interface 1_0
 17. Controller Avalon Memory-Mapped interface 1_1
 18. Controller Avalon Memory-Mapped interface 2_0
 19. Controller Avalon Memory-Mapped interface 2_1
 20. Controller Avalon Memory-Mapped interface 3_0
 21. Controller Avalon Memory-Mapped interface 3_1
 22. Controller Avalon Memory-Mapped interface 4_0
 23. Controller Avalon Memory-Mapped interface 4_1
 24. Controller Avalon Memory-Mapped interface 5_0
 25. Controller Avalon Memory-Mapped interface 5_1
 26. Controller Avalon Memory-Mapped interface 6_0
 27. Controller Avalon Memory-Mapped interface 6_1
 28. Controller Avalon Memory-Mapped interface 7_0
 29. Controller Avalon Memory-Mapped interface 7_1
 30. Controller ECC read data error indication interface 0_0
 31. Controller ECC read data error indication interface 0_1
 32. Controller ECC read data error indication interface 1_0
 33. Controller ECC read data error indication interface 1_1
 34. Controller ECC read data error indication interface 2_0
 35. Controller ECC read data error indication interface 2_1
 36. Controller ECC read data error indication interface 3_0
 37. Controller ECC read data error indication interface 3_1
 38. Controller ECC read data error indication interface 4_0
 39. Controller ECC read data error indication interface 4_1
 40. Controller ECC read data error indication interface 5_0
 41. Controller ECC read data error indication interface 5_1
 42. Controller ECC read data error indication interface 6_0
 43. Controller ECC read data error indication interface 6_1
 44. Controller ECC read data error indication interface 7_0
 45. Controller ECC read data error indication interface 7_1
 46. External core clock
 47. Lock signal for external core clock
 48. HBM-only active high reset input
 49. HBM2 interface for HBM2 Global and IEEE1500 signals
 50. Memory interface 0
 51. Memory interface 1
 52. Memory interface 2
 53. Memory interface 3
 54. Memory interface 4
 55. Memory interface 5
 56. Memory interface 6
 57. Memory interface 7
 58. PHY clock for UIB interface 0
 59. PHY clock for UIB interface 1
 60. PHY clock for UIB interface 2
 61. PHY clock for UIB interface 3
 62. PHY clock for UIB interface 4
 63. PHY clock for UIB interface 5
 64. PHY clock for UIB interface 6
 65. PHY clock for UIB interface 7
 66. PLL reference clock
 67. PHY calibration status interface
 68. Core clock active low reset 0
 69. Core clock active low reset 1
 70. Core clock active low reset 2
 71. Core clock active low reset 3
 72. Core clock active low reset 4
 73. Core clock active low reset 5
 74. Core clock active low reset 6
 75. Core clock active low reset 7
 76. Core clock active low reset input
 77. Core clock 0
 78. Core clock 1
 79. Core clock 2
 80. Core clock 3
 81. Core clock 4
 82. Core clock 5
 83. Core clock 6
 84. Core clock 7
 85. Instantiating IP in a simulation project
 86. IP Settings
 87. Configuring the Traffic Generator


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


----------------------------------
;   6. User register interface 1 ;
----------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ur_paddr_1                     16      input       Address
   ur_penable_1                   1       input       Enable for multi-cycle burst (drive to 0)
   ur_prdata_1                    16      output      Read data
   ur_prready_1                   1       output      Ready
   ur_psel_1                      1       input       Select
   ur_pstrb_1                     2       input       Byte enable for write data
   ur_pwdata_1                    16      input       Write data
   ur_pwrite_1                    1       input       Write


----------------------------------
;   7. User register interface 2 ;
----------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ur_paddr_2                     16      input       Address
   ur_penable_2                   1       input       Enable for multi-cycle burst (drive to 0)
   ur_prdata_2                    16      output      Read data
   ur_prready_2                   1       output      Ready
   ur_psel_2                      1       input       Select
   ur_pstrb_2                     2       input       Byte enable for write data
   ur_pwdata_2                    16      input       Write data
   ur_pwrite_2                    1       input       Write


----------------------------------
;   8. User register interface 3 ;
----------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ur_paddr_3                     16      input       Address
   ur_penable_3                   1       input       Enable for multi-cycle burst (drive to 0)
   ur_prdata_3                    16      output      Read data
   ur_prready_3                   1       output      Ready
   ur_psel_3                      1       input       Select
   ur_pstrb_3                     2       input       Byte enable for write data
   ur_pwdata_3                    16      input       Write data
   ur_pwrite_3                    1       input       Write


----------------------------------
;   9. User register interface 4 ;
----------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ur_paddr_4                     16      input       Address
   ur_penable_4                   1       input       Enable for multi-cycle burst (drive to 0)
   ur_prdata_4                    16      output      Read data
   ur_prready_4                   1       output      Ready
   ur_psel_4                      1       input       Select
   ur_pstrb_4                     2       input       Byte enable for write data
   ur_pwdata_4                    16      input       Write data
   ur_pwrite_4                    1       input       Write


----------------------------------
;  10. User register interface 5 ;
----------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ur_paddr_5                     16      input       Address
   ur_penable_5                   1       input       Enable for multi-cycle burst (drive to 0)
   ur_prdata_5                    16      output      Read data
   ur_prready_5                   1       output      Ready
   ur_psel_5                      1       input       Select
   ur_pstrb_5                     2       input       Byte enable for write data
   ur_pwdata_5                    16      input       Write data
   ur_pwrite_5                    1       input       Write


----------------------------------
;  11. User register interface 6 ;
----------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ur_paddr_6                     16      input       Address
   ur_penable_6                   1       input       Enable for multi-cycle burst (drive to 0)
   ur_prdata_6                    16      output      Read data
   ur_prready_6                   1       output      Ready
   ur_psel_6                      1       input       Select
   ur_pstrb_6                     2       input       Byte enable for write data
   ur_pwdata_6                    16      input       Write data
   ur_pwrite_6                    1       input       Write


----------------------------------
;  12. User register interface 7 ;
----------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ur_paddr_7                     16      input       Address
   ur_penable_7                   1       input       Enable for multi-cycle burst (drive to 0)
   ur_prdata_7                    16      output      Read data
   ur_prready_7                   1       output      Ready
   ur_psel_7                      1       input       Select
   ur_pstrb_7                     2       input       Byte enable for write data
   ur_pwdata_7                    16      input       Write data
   ur_pwrite_7                    1       input       Write


---------------------------
;  13. Calibrated latency ;
---------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   cal_lat                        3       output      Calibrated latency value


------------------------------------------------------
;  14. Controller Avalon Memory-Mapped interface 0_0 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_0_0                29      input       Address for the read/write request
   amm_burstcount_0_0             7       input       Number of transfers in each read/write burst
   amm_byteenable_0_0             32      input       Byte-enable for write data
   amm_readdata_0_0               256     output      Read data
   amm_readdatavalid_0_0          1       output      Indicates whether read data is valid
   amm_read_0_0                   1       input       Read request signal
   amm_ready_0_0                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_0_0              256     input       Write data
   amm_write_0_0                  1       input       Write request signal


------------------------------------------------------
;  15. Controller Avalon Memory-Mapped interface 0_1 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_0_1                29      input       Address for the read/write request
   amm_burstcount_0_1             7       input       Number of transfers in each read/write burst
   amm_byteenable_0_1             32      input       Byte-enable for write data
   amm_readdata_0_1               256     output      Read data
   amm_readdatavalid_0_1          1       output      Indicates whether read data is valid
   amm_read_0_1                   1       input       Read request signal
   amm_ready_0_1                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_0_1              256     input       Write data
   amm_write_0_1                  1       input       Write request signal


------------------------------------------------------
;  16. Controller Avalon Memory-Mapped interface 1_0 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_1_0                29      input       Address for the read/write request
   amm_burstcount_1_0             7       input       Number of transfers in each read/write burst
   amm_byteenable_1_0             32      input       Byte-enable for write data
   amm_readdata_1_0               256     output      Read data
   amm_readdatavalid_1_0          1       output      Indicates whether read data is valid
   amm_read_1_0                   1       input       Read request signal
   amm_ready_1_0                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_1_0              256     input       Write data
   amm_write_1_0                  1       input       Write request signal


------------------------------------------------------
;  17. Controller Avalon Memory-Mapped interface 1_1 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_1_1                29      input       Address for the read/write request
   amm_burstcount_1_1             7       input       Number of transfers in each read/write burst
   amm_byteenable_1_1             32      input       Byte-enable for write data
   amm_readdata_1_1               256     output      Read data
   amm_readdatavalid_1_1          1       output      Indicates whether read data is valid
   amm_read_1_1                   1       input       Read request signal
   amm_ready_1_1                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_1_1              256     input       Write data
   amm_write_1_1                  1       input       Write request signal


------------------------------------------------------
;  18. Controller Avalon Memory-Mapped interface 2_0 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_2_0                29      input       Address for the read/write request
   amm_burstcount_2_0             7       input       Number of transfers in each read/write burst
   amm_byteenable_2_0             32      input       Byte-enable for write data
   amm_readdata_2_0               256     output      Read data
   amm_readdatavalid_2_0          1       output      Indicates whether read data is valid
   amm_read_2_0                   1       input       Read request signal
   amm_ready_2_0                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_2_0              256     input       Write data
   amm_write_2_0                  1       input       Write request signal


------------------------------------------------------
;  19. Controller Avalon Memory-Mapped interface 2_1 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_2_1                29      input       Address for the read/write request
   amm_burstcount_2_1             7       input       Number of transfers in each read/write burst
   amm_byteenable_2_1             32      input       Byte-enable for write data
   amm_readdata_2_1               256     output      Read data
   amm_readdatavalid_2_1          1       output      Indicates whether read data is valid
   amm_read_2_1                   1       input       Read request signal
   amm_ready_2_1                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_2_1              256     input       Write data
   amm_write_2_1                  1       input       Write request signal


------------------------------------------------------
;  20. Controller Avalon Memory-Mapped interface 3_0 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_3_0                29      input       Address for the read/write request
   amm_burstcount_3_0             7       input       Number of transfers in each read/write burst
   amm_byteenable_3_0             32      input       Byte-enable for write data
   amm_readdata_3_0               256     output      Read data
   amm_readdatavalid_3_0          1       output      Indicates whether read data is valid
   amm_read_3_0                   1       input       Read request signal
   amm_ready_3_0                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_3_0              256     input       Write data
   amm_write_3_0                  1       input       Write request signal


------------------------------------------------------
;  21. Controller Avalon Memory-Mapped interface 3_1 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_3_1                29      input       Address for the read/write request
   amm_burstcount_3_1             7       input       Number of transfers in each read/write burst
   amm_byteenable_3_1             32      input       Byte-enable for write data
   amm_readdata_3_1               256     output      Read data
   amm_readdatavalid_3_1          1       output      Indicates whether read data is valid
   amm_read_3_1                   1       input       Read request signal
   amm_ready_3_1                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_3_1              256     input       Write data
   amm_write_3_1                  1       input       Write request signal


------------------------------------------------------
;  22. Controller Avalon Memory-Mapped interface 4_0 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_4_0                29      input       Address for the read/write request
   amm_burstcount_4_0             7       input       Number of transfers in each read/write burst
   amm_byteenable_4_0             32      input       Byte-enable for write data
   amm_readdata_4_0               256     output      Read data
   amm_readdatavalid_4_0          1       output      Indicates whether read data is valid
   amm_read_4_0                   1       input       Read request signal
   amm_ready_4_0                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_4_0              256     input       Write data
   amm_write_4_0                  1       input       Write request signal


------------------------------------------------------
;  23. Controller Avalon Memory-Mapped interface 4_1 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_4_1                29      input       Address for the read/write request
   amm_burstcount_4_1             7       input       Number of transfers in each read/write burst
   amm_byteenable_4_1             32      input       Byte-enable for write data
   amm_readdata_4_1               256     output      Read data
   amm_readdatavalid_4_1          1       output      Indicates whether read data is valid
   amm_read_4_1                   1       input       Read request signal
   amm_ready_4_1                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_4_1              256     input       Write data
   amm_write_4_1                  1       input       Write request signal


------------------------------------------------------
;  24. Controller Avalon Memory-Mapped interface 5_0 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_5_0                29      input       Address for the read/write request
   amm_burstcount_5_0             7       input       Number of transfers in each read/write burst
   amm_byteenable_5_0             32      input       Byte-enable for write data
   amm_readdata_5_0               256     output      Read data
   amm_readdatavalid_5_0          1       output      Indicates whether read data is valid
   amm_read_5_0                   1       input       Read request signal
   amm_ready_5_0                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_5_0              256     input       Write data
   amm_write_5_0                  1       input       Write request signal


------------------------------------------------------
;  25. Controller Avalon Memory-Mapped interface 5_1 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_5_1                29      input       Address for the read/write request
   amm_burstcount_5_1             7       input       Number of transfers in each read/write burst
   amm_byteenable_5_1             32      input       Byte-enable for write data
   amm_readdata_5_1               256     output      Read data
   amm_readdatavalid_5_1          1       output      Indicates whether read data is valid
   amm_read_5_1                   1       input       Read request signal
   amm_ready_5_1                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_5_1              256     input       Write data
   amm_write_5_1                  1       input       Write request signal


------------------------------------------------------
;  26. Controller Avalon Memory-Mapped interface 6_0 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_6_0                29      input       Address for the read/write request
   amm_burstcount_6_0             7       input       Number of transfers in each read/write burst
   amm_byteenable_6_0             32      input       Byte-enable for write data
   amm_readdata_6_0               256     output      Read data
   amm_readdatavalid_6_0          1       output      Indicates whether read data is valid
   amm_read_6_0                   1       input       Read request signal
   amm_ready_6_0                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_6_0              256     input       Write data
   amm_write_6_0                  1       input       Write request signal


------------------------------------------------------
;  27. Controller Avalon Memory-Mapped interface 6_1 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_6_1                29      input       Address for the read/write request
   amm_burstcount_6_1             7       input       Number of transfers in each read/write burst
   amm_byteenable_6_1             32      input       Byte-enable for write data
   amm_readdata_6_1               256     output      Read data
   amm_readdatavalid_6_1          1       output      Indicates whether read data is valid
   amm_read_6_1                   1       input       Read request signal
   amm_ready_6_1                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_6_1              256     input       Write data
   amm_write_6_1                  1       input       Write request signal


------------------------------------------------------
;  28. Controller Avalon Memory-Mapped interface 7_0 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_7_0                29      input       Address for the read/write request
   amm_burstcount_7_0             7       input       Number of transfers in each read/write burst
   amm_byteenable_7_0             32      input       Byte-enable for write data
   amm_readdata_7_0               256     output      Read data
   amm_readdatavalid_7_0          1       output      Indicates whether read data is valid
   amm_read_7_0                   1       input       Read request signal
   amm_ready_7_0                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_7_0              256     input       Write data
   amm_write_7_0                  1       input       Write request signal


------------------------------------------------------
;  29. Controller Avalon Memory-Mapped interface 7_1 ;
------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   amm_address_7_1                29      input       Address for the read/write request
   amm_burstcount_7_1             7       input       Number of transfers in each read/write burst
   amm_byteenable_7_1             32      input       Byte-enable for write data
   amm_readdata_7_1               256     output      Read data
   amm_readdatavalid_7_1          1       output      Indicates whether read data is valid
   amm_read_7_1                   1       input       Read request signal
   amm_ready_7_1                  1       output      Wait-request is asserted when controller is busy
   amm_writedata_7_1              256     input       Write data
   amm_write_7_1                  1       input       Write request signal


----------------------------------------------------------------
;  30. Controller ECC read data error indication interface 0_0 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_0_0     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  31. Controller ECC read data error indication interface 0_1 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_0_1     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  32. Controller ECC read data error indication interface 1_0 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_1_0     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  33. Controller ECC read data error indication interface 1_1 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_1_1     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  34. Controller ECC read data error indication interface 2_0 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_2_0     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  35. Controller ECC read data error indication interface 2_1 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_2_1     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  36. Controller ECC read data error indication interface 3_0 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_3_0     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  37. Controller ECC read data error indication interface 3_1 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_3_1     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  38. Controller ECC read data error indication interface 4_0 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_4_0     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  39. Controller ECC read data error indication interface 4_1 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_4_1     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  40. Controller ECC read data error indication interface 5_0 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_5_0     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  41. Controller ECC read data error indication interface 5_1 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_5_1     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  42. Controller ECC read data error indication interface 6_0 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_6_0     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  43. Controller ECC read data error indication interface 6_1 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_6_1     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  44. Controller ECC read data error indication interface 7_0 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_7_0     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------------------------------------------
;  45. Controller ECC read data error indication interface 7_1 ;
----------------------------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ctrl_ecc_readdataerror_7_1     1       output      Signal is asserted high by the controller ECC logic to indicate that the read data has an uncorrectable error. The signal has the same timing as the read data valid signal of the Controller Avalon Memory-Mapped interface.


----------------------------
;  46. External core clock ;
----------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ext_core_clk                   1       input       External core clock


--------------------------------------------
;  47. Lock signal for external core clock ;
--------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   ext_core_clk_locked            1       input       Indicates that the core clock is stable


-----------------------------------------
;  48. HBM-only active high reset input ;
-----------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   hbm_only_reset_in              1       input       Reset for HBM controller and memory.  Performs recalibration.


------------------------------------------------------------
;  49. HBM2 interface for HBM2 Global and IEEE1500 signals ;
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
;  50. Memory interface 0 ;
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


---------------------------
;  51. Memory interface 1 ;
---------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   aerr_1                         1       output      Address command parity error
   c_1                            8       input       Column command
   cke_1                          1       input       Memory clock enable
   ck_c_1                         1       input       Memory clock
   ck_t_1                         1       input       Memory clock
   dbi_1                          16      bidir       Data bus inversion
   derr_1                         4       bidir       Data parity error
   dm_1                           16      bidir       Data mask
   dq_1                           128     bidir       Data
   par_1                          4       bidir       Parity
   r_1                            6       input       Row command
   rc_1                           1       input       Redundant column command pin for lane remapping
   rd_1                           8       bidir       Redundant data pins for lane remapping
   rdqs_c_1                       4       output      Read data strobe
   rdqs_t_1                       4       output      Read data strobe
   rr_1                           1       input       Redundant row command pin for lane remapping
   wdqs_c_1                       4       input       Write data strobe
   wdqs_t_1                       4       input       Write data strobe


---------------------------
;  52. Memory interface 2 ;
---------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   aerr_2                         1       output      Address command parity error
   c_2                            8       input       Column command
   cke_2                          1       input       Memory clock enable
   ck_c_2                         1       input       Memory clock
   ck_t_2                         1       input       Memory clock
   dbi_2                          16      bidir       Data bus inversion
   derr_2                         4       bidir       Data parity error
   dm_2                           16      bidir       Data mask
   dq_2                           128     bidir       Data
   par_2                          4       bidir       Parity
   r_2                            6       input       Row command
   rc_2                           1       input       Redundant column command pin for lane remapping
   rd_2                           8       bidir       Redundant data pins for lane remapping
   rdqs_c_2                       4       output      Read data strobe
   rdqs_t_2                       4       output      Read data strobe
   rr_2                           1       input       Redundant row command pin for lane remapping
   wdqs_c_2                       4       input       Write data strobe
   wdqs_t_2                       4       input       Write data strobe


---------------------------
;  53. Memory interface 3 ;
---------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   aerr_3                         1       output      Address command parity error
   c_3                            8       input       Column command
   cke_3                          1       input       Memory clock enable
   ck_c_3                         1       input       Memory clock
   ck_t_3                         1       input       Memory clock
   dbi_3                          16      bidir       Data bus inversion
   derr_3                         4       bidir       Data parity error
   dm_3                           16      bidir       Data mask
   dq_3                           128     bidir       Data
   par_3                          4       bidir       Parity
   r_3                            6       input       Row command
   rc_3                           1       input       Redundant column command pin for lane remapping
   rd_3                           8       bidir       Redundant data pins for lane remapping
   rdqs_c_3                       4       output      Read data strobe
   rdqs_t_3                       4       output      Read data strobe
   rr_3                           1       input       Redundant row command pin for lane remapping
   wdqs_c_3                       4       input       Write data strobe
   wdqs_t_3                       4       input       Write data strobe


---------------------------
;  54. Memory interface 4 ;
---------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   aerr_4                         1       output      Address command parity error
   c_4                            8       input       Column command
   cke_4                          1       input       Memory clock enable
   ck_c_4                         1       input       Memory clock
   ck_t_4                         1       input       Memory clock
   dbi_4                          16      bidir       Data bus inversion
   derr_4                         4       bidir       Data parity error
   dm_4                           16      bidir       Data mask
   dq_4                           128     bidir       Data
   par_4                          4       bidir       Parity
   r_4                            6       input       Row command
   rc_4                           1       input       Redundant column command pin for lane remapping
   rd_4                           8       bidir       Redundant data pins for lane remapping
   rdqs_c_4                       4       output      Read data strobe
   rdqs_t_4                       4       output      Read data strobe
   rr_4                           1       input       Redundant row command pin for lane remapping
   wdqs_c_4                       4       input       Write data strobe
   wdqs_t_4                       4       input       Write data strobe


---------------------------
;  55. Memory interface 5 ;
---------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   aerr_5                         1       output      Address command parity error
   c_5                            8       input       Column command
   cke_5                          1       input       Memory clock enable
   ck_c_5                         1       input       Memory clock
   ck_t_5                         1       input       Memory clock
   dbi_5                          16      bidir       Data bus inversion
   derr_5                         4       bidir       Data parity error
   dm_5                           16      bidir       Data mask
   dq_5                           128     bidir       Data
   par_5                          4       bidir       Parity
   r_5                            6       input       Row command
   rc_5                           1       input       Redundant column command pin for lane remapping
   rd_5                           8       bidir       Redundant data pins for lane remapping
   rdqs_c_5                       4       output      Read data strobe
   rdqs_t_5                       4       output      Read data strobe
   rr_5                           1       input       Redundant row command pin for lane remapping
   wdqs_c_5                       4       input       Write data strobe
   wdqs_t_5                       4       input       Write data strobe


---------------------------
;  56. Memory interface 6 ;
---------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   aerr_6                         1       output      Address command parity error
   c_6                            8       input       Column command
   cke_6                          1       input       Memory clock enable
   ck_c_6                         1       input       Memory clock
   ck_t_6                         1       input       Memory clock
   dbi_6                          16      bidir       Data bus inversion
   derr_6                         4       bidir       Data parity error
   dm_6                           16      bidir       Data mask
   dq_6                           128     bidir       Data
   par_6                          4       bidir       Parity
   r_6                            6       input       Row command
   rc_6                           1       input       Redundant column command pin for lane remapping
   rd_6                           8       bidir       Redundant data pins for lane remapping
   rdqs_c_6                       4       output      Read data strobe
   rdqs_t_6                       4       output      Read data strobe
   rr_6                           1       input       Redundant row command pin for lane remapping
   wdqs_c_6                       4       input       Write data strobe
   wdqs_t_6                       4       input       Write data strobe


---------------------------
;  57. Memory interface 7 ;
---------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   aerr_7                         1       output      Address command parity error
   c_7                            8       input       Column command
   cke_7                          1       input       Memory clock enable
   ck_c_7                         1       input       Memory clock
   ck_t_7                         1       input       Memory clock
   dbi_7                          16      bidir       Data bus inversion
   derr_7                         4       bidir       Data parity error
   dm_7                           16      bidir       Data mask
   dq_7                           128     bidir       Data
   par_7                          4       bidir       Parity
   r_7                            6       input       Row command
   rc_7                           1       input       Redundant column command pin for lane remapping
   rd_7                           8       bidir       Redundant data pins for lane remapping
   rdqs_c_7                       4       output      Read data strobe
   rdqs_t_7                       4       output      Read data strobe
   rr_7                           1       input       Redundant row command pin for lane remapping
   wdqs_c_7                       4       input       Write data strobe
   wdqs_t_7                       4       input       Write data strobe


--------------------------------------
;  58. PHY clock for UIB interface 0 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   phy_clk_0                      1       output      PHY clock


--------------------------------------
;  59. PHY clock for UIB interface 1 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   phy_clk_1                      1       output      PHY clock


--------------------------------------
;  60. PHY clock for UIB interface 2 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   phy_clk_2                      1       output      PHY clock


--------------------------------------
;  61. PHY clock for UIB interface 3 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   phy_clk_3                      1       output      PHY clock


--------------------------------------
;  62. PHY clock for UIB interface 4 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   phy_clk_4                      1       output      PHY clock


--------------------------------------
;  63. PHY clock for UIB interface 5 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   phy_clk_5                      1       output      PHY clock


--------------------------------------
;  64. PHY clock for UIB interface 6 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   phy_clk_6                      1       output      PHY clock


--------------------------------------
;  65. PHY clock for UIB interface 7 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   phy_clk_7                      1       output      PHY clock


----------------------------
;  66. PLL reference clock ;
----------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   pll_ref_clk                    1       input       PLL reference clock


-----------------------------------------
;  67. PHY calibration status interface ;
-----------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   local_cal_fail                 1       output      When high, indicates that PHY calibration failed
   local_cal_success              1       output      When high, indicates that PHY calibration was successful


--------------------------------------
;  68. Core clock active low reset 0 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmcrst_n_0                     1       output      Reset


--------------------------------------
;  69. Core clock active low reset 1 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmcrst_n_1                     1       output      Reset


--------------------------------------
;  70. Core clock active low reset 2 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmcrst_n_2                     1       output      Reset


--------------------------------------
;  71. Core clock active low reset 3 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmcrst_n_3                     1       output      Reset


--------------------------------------
;  72. Core clock active low reset 4 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmcrst_n_4                     1       output      Reset


--------------------------------------
;  73. Core clock active low reset 5 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmcrst_n_5                     1       output      Reset


--------------------------------------
;  74. Core clock active low reset 6 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmcrst_n_6                     1       output      Reset


--------------------------------------
;  75. Core clock active low reset 7 ;
--------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmcrst_n_7                     1       output      Reset


------------------------------------------
;  76. Core clock active low reset input ;
------------------------------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmcrst_n_in                    1       input       Reset


---------------------
;  77. Core clock 0 ;
---------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmc_clk_0                      1       output      Wide memory controller clock


---------------------
;  78. Core clock 1 ;
---------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmc_clk_1                      1       output      Wide memory controller clock


---------------------
;  79. Core clock 2 ;
---------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmc_clk_2                      1       output      Wide memory controller clock


---------------------
;  80. Core clock 3 ;
---------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmc_clk_3                      1       output      Wide memory controller clock


---------------------
;  81. Core clock 4 ;
---------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmc_clk_4                      1       output      Wide memory controller clock


---------------------
;  82. Core clock 5 ;
---------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmc_clk_5                      1       output      Wide memory controller clock


---------------------
;  83. Core clock 6 ;
---------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmc_clk_6                      1       output      Wide memory controller clock


---------------------
;  84. Core clock 7 ;
---------------------

   Port                           Width   Direction   Description                                        
   ------------------------------------------------------------------------------------------------------
   wmc_clk_7                      1       output      Wide memory controller clock


-------------------------------------------------
;  85. Instantiating IP in a simulation project ;
-------------------------------------------------

   The simulation fileset as well as the simulation example design contain scripts
   that illustrate what files are required when including the HBM IP for simulation.
   The scripts are customized for all the 3rd-party simulators supported. It is highly
   recommended that you use these scripts as reference when setting up your simulation
   environment.


--------------------
;  86. IP Settings ;
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
   PHY_HBM_LOCATION                                  : BOT
   PHY_HBM_DEVICE_USER                               : HBM_DEVICE_EMPTY
   PHY_HBM_VENDOR_USER                               : VENDOR_EMPTY
   PHY_USER_REF_CLK_FREQ_MHZ                         : 200.0
   PHY_DEFAULT_CORE_REF_CLK_FREQ                     : true
   PHY_USER_CORE_REF_CLK_FREQ_MHZ                    : 100.0
   PHY_THROTTLE_RDATA_BRESP                          : true
   PHY_BACKPRESSURE_LATENCY                          : CYCLE_0
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
   PHY_CH1_EN                                        : true
   PHY_CH2_EN                                        : true
   PHY_CH3_EN                                        : true
   PHY_CH4_EN                                        : true
   PHY_CH5_EN                                        : true
   PHY_CH6_EN                                        : true
   PHY_CH7_EN                                        : true
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
   PHY_HBM_AXI_INTERFACE_0                           : false
   PHY_HBM_AXI_INTERFACE_1                           : false
   PHY_HBM_AXI_INTERFACE_2                           : false
   PHY_HBM_AXI_INTERFACE_3                           : false
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
   HARD_CTRL_CH0_CFG_THROTTLE_EN                     : true
   CTRL_CH1_CLONE_OF_ID_STR                          : Controller 0
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
   CTRL_CH2_CLONE_OF_ID_STR                          : Controller 0
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
   CTRL_CH3_CLONE_OF_ID_STR                          : Controller 0
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
   CTRL_CH4_CLONE_OF_ID_STR                          : Controller 0
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
   CTRL_CH5_CLONE_OF_ID_STR                          : Controller 0
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
   CTRL_CH6_CLONE_OF_ID_STR                          : Controller 0
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
   CTRL_CH7_CLONE_OF_ID_STR                          : Controller 0
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
   DIAG_EX_DESIGN_ISSP_EN                            : false
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
   EX_DESIGN_GUI_HDL_FORMAT                          : HDL_FORMAT_VERILOG


------------------------------------------
;  87. Configuring the Traffic Generator ;
------------------------------------------

   The AXI traffic generator is a built-in verification solution for the HBM IP.
   It has many configuration options. These include options in read/write command,
   address, data and data-mask generation. The AXI traffic generator
   can be used in simulation and hardware verification.
   
   For full details concerning the traffic generator, consult the HBM Handbook.


