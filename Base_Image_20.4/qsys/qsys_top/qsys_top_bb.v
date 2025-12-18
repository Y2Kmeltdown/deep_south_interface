module qsys_top (
		output wire        pcie_irq_irq,                                        //           pcie_irq.irq
		output wire        bmc_irq_irq,                                         //            bmc_irq.irq
		output wire        esram_0_iopll_lock_iopll_lock,                       // esram_0_iopll_lock.iopll_lock
		input  wire        esram_0_refclk_clk,                                  //     esram_0_refclk.clk
		output wire        pcie_user_clk_clk,                                   //      pcie_user_clk.clk
		input  wire        config_clk_clk,                                      //         config_clk.clk
		input  wire        config_rstn_reset_n,                                 //        config_rstn.reset_n
		input  wire        avmm_master_waitrequest,                             //        avmm_master.waitrequest
		input  wire [31:0] avmm_master_readdata,                                //                   .readdata
		input  wire        avmm_master_readdatavalid,                           //                   .readdatavalid
		output wire [0:0]  avmm_master_burstcount,                              //                   .burstcount
		output wire [31:0] avmm_master_writedata,                               //                   .writedata
		output wire [11:0] avmm_master_address,                                 //                   .address
		output wire        avmm_master_write,                                   //                   .write
		output wire        avmm_master_read,                                    //                   .read
		output wire [3:0]  avmm_master_byteenable,                              //                   .byteenable
		output wire        avmm_master_debugaccess,                             //                   .debugaccess
		input  wire        pcie_refclk_clk,                                     //        pcie_refclk.clk
		input  wire        pcie_npor_npor,                                      //          pcie_npor.npor
		input  wire        pcie_npor_pin_perst,                                 //                   .pin_perst
		input  wire        pcie_hip_ctrl_simu_mode_pipe,                        //      pcie_hip_ctrl.simu_mode_pipe
		input  wire [66:0] pcie_hip_ctrl_test_in,                               //                   .test_in
		input  wire        pcie_serial_rx_in0,                                  //        pcie_serial.rx_in0
		input  wire        pcie_serial_rx_in1,                                  //                   .rx_in1
		input  wire        pcie_serial_rx_in2,                                  //                   .rx_in2
		input  wire        pcie_serial_rx_in3,                                  //                   .rx_in3
		input  wire        pcie_serial_rx_in4,                                  //                   .rx_in4
		input  wire        pcie_serial_rx_in5,                                  //                   .rx_in5
		input  wire        pcie_serial_rx_in6,                                  //                   .rx_in6
		input  wire        pcie_serial_rx_in7,                                  //                   .rx_in7
		input  wire        pcie_serial_rx_in8,                                  //                   .rx_in8
		input  wire        pcie_serial_rx_in9,                                  //                   .rx_in9
		input  wire        pcie_serial_rx_in10,                                 //                   .rx_in10
		input  wire        pcie_serial_rx_in11,                                 //                   .rx_in11
		input  wire        pcie_serial_rx_in12,                                 //                   .rx_in12
		input  wire        pcie_serial_rx_in13,                                 //                   .rx_in13
		input  wire        pcie_serial_rx_in14,                                 //                   .rx_in14
		input  wire        pcie_serial_rx_in15,                                 //                   .rx_in15
		output wire        pcie_serial_tx_out0,                                 //                   .tx_out0
		output wire        pcie_serial_tx_out1,                                 //                   .tx_out1
		output wire        pcie_serial_tx_out2,                                 //                   .tx_out2
		output wire        pcie_serial_tx_out3,                                 //                   .tx_out3
		output wire        pcie_serial_tx_out4,                                 //                   .tx_out4
		output wire        pcie_serial_tx_out5,                                 //                   .tx_out5
		output wire        pcie_serial_tx_out6,                                 //                   .tx_out6
		output wire        pcie_serial_tx_out7,                                 //                   .tx_out7
		output wire        pcie_serial_tx_out8,                                 //                   .tx_out8
		output wire        pcie_serial_tx_out9,                                 //                   .tx_out9
		output wire        pcie_serial_tx_out10,                                //                   .tx_out10
		output wire        pcie_serial_tx_out11,                                //                   .tx_out11
		output wire        pcie_serial_tx_out12,                                //                   .tx_out12
		output wire        pcie_serial_tx_out13,                                //                   .tx_out13
		output wire        pcie_serial_tx_out14,                                //                   .tx_out14
		output wire        pcie_serial_tx_out15,                                //                   .tx_out15
		input  wire        spi_mosi_to_the_spislave_inst_for_spichain,          //                spi.mosi_to_the_spislave_inst_for_spichain
		input  wire        spi_nss_to_the_spislave_inst_for_spichain,           //                   .nss_to_the_spislave_inst_for_spichain
		input  wire        spi_sclk_to_the_spislave_inst_for_spichain,          //                   .sclk_to_the_spislave_inst_for_spichain
		inout  wire        spi_miso_to_and_from_the_spislave_inst_for_spichain, //                   .miso_to_and_from_the_spislave_inst_for_spichain
		output wire        pcie_user_rst_reset,                                 //      pcie_user_rst.reset
		inout  wire [7:0]  conf_d_conf_d,                                       //             conf_d.conf_d
		output wire        soft_recfg_req_n_soft_reconfigure_req_n,             //   soft_recfg_req_n.soft_reconfigure_req_n
		output wire [3:0]  conf_c_out_conf_c_out,                               //         conf_c_out.conf_c_out
		input  wire [3:0]  conf_c_in_conf_c_in                                  //          conf_c_in.conf_c_in
	);
endmodule

