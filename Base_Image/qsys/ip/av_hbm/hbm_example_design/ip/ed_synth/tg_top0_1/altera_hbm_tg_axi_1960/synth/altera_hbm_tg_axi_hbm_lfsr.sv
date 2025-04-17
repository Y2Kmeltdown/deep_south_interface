// (C) 2001-2020 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


//////////////////////////////////////////////////////////////////////////////
// The Pseudo-Random Shift Registers (LFSR) based on JEDEC HBM Polynomial
//////////////////////////////////////////////////////////////////////////////
module altera_hbm_tg_axi_hbm_lfsr # (
    //Determine whether the LFSR is for Data or Address/Command
    //Different polynomial will be used for different LFSR type
    parameter LFSR_TYPE     = "",
    //JEDEC Style LSB feed MSB while http://inst.eecs.berkeley.edu/~cs150/sp03/handouts/15/LectureA/lec27-6up style MSB feed LSB
    parameter SHIFT_RIGHT   = 1,
    //WIDTH are fixed based on whether the LFSR for DWORD or AWORD
    //    DWORD bits 20 = (1 DBI,8 DQ, 1 DM) x 2 clock edge
    //    AWORD bits 30 = (1 DBI,8 DQ, 1 DM) x 2 clock edge
    parameter WIDTH         = (LFSR_TYPE == "DWORD") ? 20 : 30
) (
    //Clock and reset
    input                      clk,
    input                      prst,

    //Control
    input                      enable,
    input                      tg_start,
    //2'b00 - Preset
    //2'b01 - Linear Feedback Shift Register
    //2'b10 - Register
    //2'b11 - Multi Input Shift register
    input [2-1:0]              mode,

    //MISR input
    input [WIDTH-1:0]          data_in,

    //LFSR output
    output logic [WIDTH-1:0]   data
);

timeunit 1ns;
timeprecision 1ps;

//Preset to produce an alternating 0/1/0/1 pattern
//on all 10 bits associated with a AWORD byte and prevent stuck at-at-zero state
localparam  LFSR_PRST   = (LFSR_TYPE == "DWORD") ? 20'hAAAAA : 30'h2AAAAAAA;

typedef enum logic [1:0] {
    PRESET,
    LFSR,
    REGISTER,
    MISR
} state_t;

generate
if (LFSR_TYPE == "DWORD") begin
    if (SHIFT_RIGHT) begin
        always_ff @(posedge clk)
        begin
            if (prst || tg_start) begin
                data        <= LFSR_PRST;
            end else if (enable) begin
                case(mode)
                    PRESET:
                    begin
                        data        <= LFSR_PRST;
                    end

                    LFSR: //DWORD Polynimial f(x) = X**20 + X**17 + 1. JEDEC Style LSB feed MSB
                    begin
                        data[19]    <= data[0];
                        data[18:17] <= data[19:18];
                        data[16]    <= data[17] ^ data[0];
                        data[15:0]  <= data[16:1];
                    end

                    REGISTER://Registered the input mode without compression
                    begin
                        data        <= data_in;
                    end

                    MISR:
                    begin
                        data[19]    <= data_in[19] ^ data[0];
                        data[18:17] <= data_in[18:17] ^ data[19:18];
                        data[16]    <= data_in[16] ^ (data[17] ^ data[0]);
                        data[15:0]  <= data_in[15:0] ^ data[16:1];
                    end
                endcase
            end
        end
    end else begin
        always_ff @(posedge clk)
        begin
            if (prst || tg_start) begin
                data        <= LFSR_PRST;
            end else if (enable) begin
                case(mode)
                    PRESET:
                    begin
                        data        <= LFSR_PRST;
                    end

                    LFSR: //DWORD Polynimial f(x) = X**20 + X**17 + 1. http://inst.eecs.berkeley.edu/~cs150/sp03/handouts/15/LectureA/lec27-6up style MSB feed LSB
                    begin
                        data[0]     <= data[19];
                        data[16:1]  <= data[15:0];
                        data[17]    <= data[16] ^ data[19];
                        data[19:18] <= data[18:17];
                    end

                    REGISTER://Registered the input mode without compression
                    begin
                        data        <= data_in;
                    end

                    MISR:
                    begin
                        data[0]     <= data_in[0] ^ data[19];
                        data[16:1]  <= data_in[16:1] ^ data[15:0];
                        data[17]    <= data_in[17] ^ (data[16] ^ data[19]);
                        data[19:18] <= data_in[19:18] ^ data[18:17];
                    end
                endcase
            end
        end
    end
end else if (LFSR_TYPE == "AWORD") begin
    if (SHIFT_RIGHT) begin
        always_ff @(posedge clk)
        begin
            if (prst || tg_start) begin
                data        <= LFSR_PRST;
            end else if (enable) begin
                case(mode)
                    PRESET:
                    begin
                        data        <= LFSR_PRST;
                    end

                    LFSR: //AWORD Polynimial f(x) = X**30 + X**6 + X**4 + X + 1  JEDEC Style LSB feed MSB
                    begin
                        data[29]    <= data[0];
                        data[28:6]  <= data[29:7];
                        data[5]     <= data[6] ^ data[0];
                        data[4]     <= data[5];
                        data[3]     <= data[4] ^ data[0];
                        data[2:0]   <= data[3:1];
                    end

                    REGISTER://Registered the input mode without compression
                    begin
                        data        <= data_in;
                    end

                    MISR:
                    begin
                        data[29]    <= data_in[29] ^ data[0];
                        data[28:6]  <= data_in[28:6] ^ data[29:7];
                        data[5]     <= data_in[5] ^ data[6] ^ data[0];
                        data[4]     <= data_in[4] ^ data[5];
                        data[3]     <= data_in[3] ^ data[4] ^ data[0];
                        data[2:0]   <= data_in[2:0] ^ data[3:1];
                    end
                endcase
            end
        end
    end else begin
        always_ff @(posedge clk)
        begin
            if (prst || tg_start) begin
                data        <= LFSR_PRST;
            end else if (enable) begin
                case(mode)
                    PRESET:
                    begin
                        data        <= LFSR_PRST;
                    end

                    LFSR: //AWORD Polynimial f(x) = X**30 + X**6 + X**4 + X + 1 http://inst.eecs.berkeley.edu/~cs150/sp03/handouts/15/LectureA/lec27-6up style MSB feed LSB
                    begin
                        data[0]     <= data[29];
                        data[1]     <= data[0] ^ data[29];
                        data[3:2]   <= data[2:1];
                        data[4]     <= data[3] ^ data[29];
                        data[5]     <= data[4];
                        data[6]     <= data[5] ^ data[29];
                        data[29:7]  <= data[28:6];
                    end

                    REGISTER://Registered the input mode without compression
                    begin
                        data        <= data_in;
                    end

                    MISR:
                    begin
                        data[0]     <= data_in[0] ^ data[29];
                        data[1]     <= data_in[1] ^ data[0] ^ data[29];
                        data[3:2]   <= data_in[3:2] ^ data[2:1];
                        data[4]     <= data_in[4] ^ data[3] ^ data[29];
                        data[5]     <= data_in[5] ^ data[4];
                        data[6]     <= data_in[6] ^ data[5] ^ data[29];
                        data[29:7]  <= data_in[29:7] ^ data[28:6];
                    end
                endcase
            end
        end
    end
end
endgenerate

endmodule

