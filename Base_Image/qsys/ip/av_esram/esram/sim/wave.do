onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /av_esram_tb/av_address
add wave -noupdate /av_esram_tb/av_read
add wave -noupdate /av_esram_tb/av_readdata
add wave -noupdate /av_esram_tb/av_waitrequest
add wave -noupdate /av_esram_tb/av_write
add wave -noupdate /av_esram_tb/av_writedata
add wave -noupdate /av_esram_tb/c_ADDR_BITS
add wave -noupdate /av_esram_tb/esram_clk
add wave -noupdate /av_esram_tb/iopll_lock
add wave -noupdate /av_esram_tb/PERIOD
add wave -noupdate /av_esram_tb/refclk
add wave -noupdate /av_esram_tb/rst
add wave -noupdate /av_esram_tb/stop_sim
add wave -noupdate -divider dut
add wave -noupdate /av_esram_tb/DUT/av_address
add wave -noupdate /av_esram_tb/DUT/av_read
add wave -noupdate /av_esram_tb/DUT/av_readdata
add wave -noupdate /av_esram_tb/DUT/av_waitrequest
add wave -noupdate /av_esram_tb/DUT/av_write
add wave -noupdate /av_esram_tb/DUT/av_writedata
add wave -noupdate /av_esram_tb/DUT/c_ADDR_BITS
add wave -noupdate /av_esram_tb/DUT/data
add wave -noupdate /av_esram_tb/DUT/esram2f_clk
add wave -noupdate /av_esram_tb/DUT/esram_clk
add wave -noupdate /av_esram_tb/DUT/esram_clk_i
add wave -noupdate /av_esram_tb/DUT/iopll_lock
add wave -noupdate /av_esram_tb/DUT/iopll_lock2core
add wave -noupdate /av_esram_tb/DUT/q
add wave -noupdate /av_esram_tb/DUT/rdaddress
add wave -noupdate /av_esram_tb/DUT/rden
add wave -noupdate /av_esram_tb/DUT/rden_n
add wave -noupdate /av_esram_tb/DUT/read_waitrequest_n
add wave -noupdate /av_esram_tb/DUT/refclk
add wave -noupdate /av_esram_tb/DUT/rst
add wave -noupdate /av_esram_tb/DUT/sd
add wave -noupdate /av_esram_tb/DUT/sd_n
add wave -noupdate /av_esram_tb/DUT/wraddress
add wave -noupdate /av_esram_tb/DUT/wren
add wave -noupdate /av_esram_tb/DUT/wren_n
add wave -noupdate -divider iopll
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/adjpllin
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/extclk_out
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/extclk_out_2bit
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/loaden
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/locked
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/lvds_clk
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/outclk_0
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/outclk_1
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/outclk_2
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/outclk_3
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/outclk_4
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/permit_cal
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/phout
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/rst
add wave -noupdate /av_esram_tb/DUT/i_esram/esram_0/mega_iopll/iopll/unused_wires
add wave -noupdate -divider esram
add wave -noupdate /av_esram_tb/DUT/i_esram/c0_data_0
add wave -noupdate /av_esram_tb/DUT/i_esram/c0_q_0
add wave -noupdate /av_esram_tb/DUT/i_esram/c0_rdaddress_0
add wave -noupdate /av_esram_tb/DUT/i_esram/c0_rden_n_0
add wave -noupdate /av_esram_tb/DUT/i_esram/c0_sd_n_0
add wave -noupdate /av_esram_tb/DUT/i_esram/c0_wraddress_0
add wave -noupdate /av_esram_tb/DUT/i_esram/c0_wren_n_0
add wave -noupdate /av_esram_tb/DUT/i_esram/esram2f_clk
add wave -noupdate /av_esram_tb/DUT/i_esram/iopll_lock2core
add wave -noupdate /av_esram_tb/DUT/i_esram/refclk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1361642312 fs} 0} {{Cursor 2} {5153783436 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 266
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits fs
update
WaveRestoreZoom {0 fs} {2375376016 fs}
