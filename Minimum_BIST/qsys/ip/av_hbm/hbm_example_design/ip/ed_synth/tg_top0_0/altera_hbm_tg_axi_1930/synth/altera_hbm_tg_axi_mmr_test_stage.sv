// (C) 2001-2019 Intel Corporation. All rights reserved.
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


//This is a special test stage designed to test memory mapped register.
//Implements user refresh all bank control when REFRESH MODE = User Refresh All 


module altera_hbm_tg_axi_mmr_test_stage #(
   parameter USE_HARD_CTRL = 1,
   parameter DIAG_RD_PAR  = 0,
   parameter DIAG_WR_PAR  = 0,
   parameter DIAG_SBE_CORRECT  = 0,
   parameter PORT_APB_PADDR_WIDTH = 10,
   parameter PORT_APB_PWDATA_WIDTH = 32,
   parameter PORT_APB_PSTRB_WIDTH = 4,
   parameter PORT_APB_PRDATA_WIDTH = 32,
   parameter CORE_CLK_FREQ_MHZ = 200,
   parameter USER_RFSH_ALL_EN = 0,
   parameter MMR_LINK         = 0
)(

   input                                           clk,
   input                                           rst,
   input                                           enable,
   output                                          fail,
   output                                          done,

   output logic [PORT_APB_PADDR_WIDTH-1:0]         ur_paddr,
   output logic                                    ur_psel,
   output                                          ur_penable,
   output logic                                    ur_pwrite,
   output logic [PORT_APB_PWDATA_WIDTH-1:0]        ur_pwdata,
   output logic [PORT_APB_PSTRB_WIDTH-1:0]         ur_pstrb,
   input                                           ur_prready,
   input        [PORT_APB_PRDATA_WIDTH-1:0]        ur_prdata

   );

   timeunit 1ns;
   timeprecision 1ps;
   generate
   // Implements user refresh module when User Refresh All mode selected
   if (USER_RFSH_ALL_EN && MMR_LINK) begin
      // Refresh periods based on core clock frequency
      localparam temp011_rfsh_period = 3900*CORE_CLK_FREQ_MHZ/1000;    
      localparam temp000_rfsh_period = 4*temp011_rfsh_period;
      localparam temp001_rfsh_period = 2*temp011_rfsh_period;
      localparam temp010_rfsh_period = temp011_rfsh_period/2;
      localparam temp110_rfsh_period = temp011_rfsh_period/4;
      localparam RFSH_PERIOD_PORT_WIDTH = $clog2(temp000_rfsh_period);
  
      localparam IDLE           = 4'd0;
      localparam WR_INIT_PCH0   = 4'd1;
      localparam WR_WAIT_PCH0   = 4'd2;
      localparam RD_INIT_PCH0   = 4'd3;
      localparam RD_WAIT_PCH0   = 4'd4;
      localparam WR_INIT_PCH1   = 4'd5;
      localparam WR_WAIT_PCH1   = 4'd6;
      localparam RD_INIT_PCH1   = 4'd7;
      localparam RD_WAIT_PCH1   = 4'd8;
      localparam RD_INIT_TEMP   = 4'd9;
      localparam RD_WAIT_TEMP   = 4'd10;
         
      logic [RFSH_PERIOD_PORT_WIDTH-1:0] rfsh_period_counter, rfsh_period;
      wire rfsh_period_counter_limit_reached;
      logic [3:0] state, next_state;
      logic [2:0] temp;
   
      assign fail = 1'b0;
      assign done = 1'b0;
     
      // Refresh period counter
      always @ (posedge clk) 
      begin
        if (rst) begin
          rfsh_period_counter <= temp011_rfsh_period - 1;
        end
        else begin        
          if (rfsh_period_counter_limit_reached) begin
            rfsh_period_counter <= rfsh_period;
          end
          else begin
            rfsh_period_counter <= rfsh_period_counter - 1'b1;
          end
        end
      end

     assign rfsh_period_counter_limit_reached = (rfsh_period_counter == '0);

     // Refresh period assignment based on TEMP value  
     always @(posedge clk)
     begin
       if (rst) begin
         rfsh_period <= temp011_rfsh_period - 1;
       end else begin     
         case (temp)
            3'b000: rfsh_period <= temp000_rfsh_period - 1;
	    3'b001: rfsh_period <= temp001_rfsh_period - 1;
	    3'b011: rfsh_period <= temp011_rfsh_period - 1;
	    3'b010: rfsh_period <= temp010_rfsh_period - 1;
	    3'b110: rfsh_period <= temp110_rfsh_period - 1;
	    default: rfsh_period <= temp011_rfsh_period - 1;
         endcase
       end
     end
 
      assign ur_penable = (state == WR_WAIT_PCH0 | state == WR_WAIT_PCH1 | state == RD_WAIT_PCH0 | state == RD_WAIT_PCH1 | state == RD_WAIT_TEMP) ? 1 : 0;

      // State machine APB bus output
      always @(posedge clk)
      begin
         if (rst) begin
            ur_paddr       <= '0;
            ur_psel        <= '0;
            ur_pwrite      <= '0;
            ur_pwdata      <= '0;
            ur_pstrb       <= '0;
         end else begin
            case (next_state)
            IDLE:
            begin
               ur_paddr       <= '0;
               ur_psel        <= '0;
               ur_pwrite      <= '0;
               ur_pwdata      <= '0;
               ur_pstrb       <= '0;
            end
            WR_INIT_PCH0,WR_WAIT_PCH0: 
	    // Write refresh command to pseudo channel 0
            begin
               ur_paddr       <= '0;
               ur_psel        <= '1;
               ur_pwrite      <= '1;
               ur_pwdata      <= 16'h140;
               ur_pstrb       <= '1;
            end	
            WR_INIT_PCH1,WR_WAIT_PCH1:
	    // Write refresh command to pseudo channel 1
            begin
               ur_paddr       <= '0;
               ur_psel        <= '1;
               ur_pwrite      <= '1;
               ur_pwdata      <= 16'h141;
               ur_pstrb       <= '1;
            end	   	 
            RD_INIT_PCH0,RD_WAIT_PCH0,RD_INIT_PCH1,RD_WAIT_PCH1:
	    // Read refresh request acknowledge
            begin
	       ur_paddr       <= '0;
               ur_psel        <= '1;
               ur_pwrite      <= '0;
               ur_pwdata      <= '0;
               ur_pstrb       <= '0;
            end  
            RD_INIT_TEMP,RD_WAIT_TEMP:
	    // Read TEMP value
            begin
	       ur_paddr       <= 16'hc;
               ur_psel        <= '1;
               ur_pwrite      <= '0;
               ur_pwdata      <= '0;
               ur_pstrb       <= '0;
            end 	         
	    default:
            begin
               ur_paddr       <= '0;
               ur_psel        <= '0;
               ur_pwrite      <= '0;
               ur_pwdata      <= '0;
               ur_pstrb       <= '0;
            end
         endcase
         end
      end

      // State register
      always @(posedge clk)
      begin
         if (rst)
            state <= IDLE;
         else
            state <= next_state;
      end
      
      // TEMP value readout
      always @(posedge clk)
      begin
         if (rst)
            temp <= 3'b011;
         else 
            if (state == RD_WAIT_TEMP && ur_prready)
               temp <= ur_prdata[2:0];
	    else
	       temp <= temp;
         end
   
      // State transition control
      always @*
      begin
           if (rst) begin
               next_state            = IDLE;
           end
           else begin
           case (state)
           IDLE:
           begin
               if (rfsh_period_counter_limit_reached)
                  next_state         = WR_INIT_PCH0;
               else
                  next_state         = IDLE;
           end
           WR_INIT_PCH0:
           begin
               next_state            = WR_WAIT_PCH0;
           end
           WR_WAIT_PCH0:
           begin
               if(ur_prready)
               next_state            = RD_INIT_PCH0;
               else
               next_state            = WR_WAIT_PCH0;
           end
           RD_INIT_PCH0:
           begin
               next_state            = RD_WAIT_PCH0;
           end			
           RD_WAIT_PCH0:
           begin
               if(ur_prready)
	          if(ur_prdata[9])
                     next_state      = WR_INIT_PCH1;
	          else
	             next_state      = RD_INIT_PCH0;
               else
                  next_state         = RD_WAIT_PCH0;
           end
           WR_INIT_PCH1:
           begin
               next_state            = WR_WAIT_PCH1;
           end
           WR_WAIT_PCH1:
           begin
               if(ur_prready)
               next_state            = RD_INIT_PCH1;
               else
               next_state            = WR_WAIT_PCH1;
           end
           RD_INIT_PCH1:
           begin
               next_state            = RD_WAIT_PCH1;
           end			
           RD_WAIT_PCH1:
           begin
               if(ur_prready)
	          if(ur_prdata[9])
                     next_state      = RD_INIT_TEMP;
	          else
	             next_state      = RD_INIT_PCH1;
               else
                  next_state         = RD_WAIT_PCH1;
           end
           RD_INIT_TEMP:
           begin
               next_state            = RD_WAIT_TEMP;
           end			
           RD_WAIT_TEMP:
           begin
               if(ur_prready)
                  next_state         = IDLE;
               else
                  next_state         = RD_WAIT_TEMP;
           end		
           default:
               begin
               next_state            = IDLE;
               end
           endcase
           end
      end   
   end else if (!USER_RFSH_ALL_EN && MMR_LINK) begin   
      // 0x104: User interrupt status registers
      // [0] : ECC SBE
      // [2] : Read data parity error
      // [3] : Write data parity error
      localparam PAR_ADDR = USE_HARD_CTRL ? 10'h104 : 10'h140;
      localparam ECC_ADDR = USE_HARD_CTRL ? 10'h104 : 10'h120;

      logic rst1,rst2; /* synthesis dont_merge */
      always_ff @(posedge clk)
      begin
         rst1   <= rst;
         rst2   <= rst1;
      end


   // Config states definition
      typedef enum logic [2:0]  {
         INIT,
         REQ_MMR_PAR,WAIT_MMR_PAR,MMR_PAR_CHECK,
         REQ_SBE_ECC,WAIT_SBE_ECC,SBE_ECC_CHECK,
         DONE
      } cfg_state_t;

      cfg_state_t state, next_state;

      logic [3:0]mmr_rdpe_cnt;
      logic [3:0]mmr_wdpe_cnt;
      logic [3:0]mmr_sbe_cnt;
      logic rdpe_derr_fail;
      logic wdpe_derr_fail;
      logic sbe_corr_fail;

      assign ur_penable    = (state == WAIT_MMR_PAR | state == WAIT_SBE_ECC) ? 1 : 0;

      always_ff @(posedge clk)
      begin
         if (rst2) begin
            ur_paddr       <= 10'h0;
            ur_psel        <= '0;
            ur_pwrite      <= '0;
            ur_pwdata      <= 32'b0;
            ur_pstrb       <= '0;
            mmr_sbe_cnt    <= '0;
            mmr_rdpe_cnt   <= '0;
            mmr_wdpe_cnt   <= '0;
            rdpe_derr_fail <= '0;
            wdpe_derr_fail <= '0;
            sbe_corr_fail  <= '0;
         end else begin
            case (next_state)
            INIT:
            begin
               ur_paddr       <= 10'h0;
               ur_psel        <= '0;
               ur_pwrite      <= '0;
               ur_pwdata      <= 32'b0;
               ur_pstrb       <= '0;
               mmr_sbe_cnt    <= '0;
               mmr_rdpe_cnt   <= '0;
               mmr_wdpe_cnt   <= '0;
               rdpe_derr_fail <= '0;
               wdpe_derr_fail <= '0;
               sbe_corr_fail  <= '0;
            end
            REQ_MMR_PAR,WAIT_MMR_PAR:
            begin
               ur_paddr       <= PAR_ADDR;
               ur_psel        <= '1;
               ur_pwrite      <= '0;
               ur_pwdata      <= 32'b0;
               ur_pstrb       <= '0;
               mmr_sbe_cnt    <= mmr_sbe_cnt;
               mmr_rdpe_cnt   <= USE_HARD_CTRL ? {3'b0, ur_prdata[2]} : ur_prdata[3:0];
               mmr_wdpe_cnt   <= {3'b0, ur_prdata[3]};
               rdpe_derr_fail <= rdpe_derr_fail;
               wdpe_derr_fail <= wdpe_derr_fail;
               sbe_corr_fail  <= sbe_corr_fail;
            end
            MMR_PAR_CHECK:
            begin
               ur_paddr       <= 10'h0;
               ur_psel        <= '0;
               ur_pwrite      <= '0;
               ur_pwdata      <= 32'b0;
               ur_pstrb       <= '0;
               mmr_sbe_cnt    <= mmr_sbe_cnt;
               mmr_rdpe_cnt   <= mmr_rdpe_cnt;
               mmr_wdpe_cnt   <= mmr_wdpe_cnt;
               rdpe_derr_fail <= (|mmr_rdpe_cnt)^(DIAG_RD_PAR | DIAG_SBE_CORRECT);
               wdpe_derr_fail <= (|mmr_wdpe_cnt)^DIAG_WR_PAR;
               sbe_corr_fail  <= sbe_corr_fail;
            end
            REQ_SBE_ECC,WAIT_SBE_ECC:
            begin
               ur_paddr       <= ECC_ADDR;
               ur_psel        <= '1;
               ur_pwrite      <= '0;
               ur_pwdata      <= 32'b0;
               ur_pstrb       <= '0;
               mmr_sbe_cnt    <= USE_HARD_CTRL ? {3'b0, ur_prdata[0]} : ur_prdata[3:0];
               mmr_rdpe_cnt   <= mmr_rdpe_cnt;
               mmr_wdpe_cnt   <= mmr_wdpe_cnt;
               rdpe_derr_fail <= rdpe_derr_fail;
               wdpe_derr_fail <= wdpe_derr_fail;
               sbe_corr_fail  <= sbe_corr_fail;
            end
            SBE_ECC_CHECK:
            begin
               ur_paddr       <= 10'h0;
               ur_psel        <= '0;
               ur_pwrite      <= '0;
               ur_pwdata      <= 32'b0;
               ur_pstrb       <= '0;
               mmr_sbe_cnt    <= mmr_sbe_cnt;
               mmr_rdpe_cnt   <= mmr_rdpe_cnt;
               mmr_wdpe_cnt   <= mmr_wdpe_cnt;
               rdpe_derr_fail <= rdpe_derr_fail;
               wdpe_derr_fail <= wdpe_derr_fail;
               sbe_corr_fail  <= (|mmr_sbe_cnt)^DIAG_SBE_CORRECT;
            end
            DONE:
            begin
               ur_paddr       <= 10'h0;
               ur_psel        <= '0;
               ur_pwrite      <= '0;
               ur_pwdata      <= 32'b0;
               ur_pstrb       <= '0;
               mmr_sbe_cnt    <= mmr_sbe_cnt;
               mmr_rdpe_cnt   <= mmr_rdpe_cnt;
               mmr_wdpe_cnt   <= mmr_wdpe_cnt;
               rdpe_derr_fail <=  rdpe_derr_fail;
               wdpe_derr_fail <=  wdpe_derr_fail;
               sbe_corr_fail  <= sbe_corr_fail;
            end
            default:
            begin
               ur_paddr       <= 10'h0;
               ur_psel        <= '0;
               ur_pwrite      <= '0;
               ur_pwdata      <= 32'b0;
               ur_pstrb       <= '0;
               mmr_sbe_cnt    <= mmr_sbe_cnt;
               mmr_rdpe_cnt   <= '0;
               mmr_wdpe_cnt   <= '0;
               rdpe_derr_fail <= '0;
               wdpe_derr_fail <= '0;
               sbe_corr_fail  <= '0;
            end
         endcase
         end
      end

      // register state transition
      always_ff @(posedge clk)
      begin
         if (rst2)
            state <= INIT;
         else
            state <= next_state;
      end

      // stage control machine
      always @*
      begin
           if (rst2) begin
               next_state            <= INIT;
           end
           else begin
           case (state)
           INIT:
           begin
               if (enable)
               next_state            <=REQ_MMR_PAR;
               else
               next_state            <=INIT;
           end
           REQ_MMR_PAR:
           begin
               next_state            <=WAIT_MMR_PAR;
           end
           WAIT_MMR_PAR:
           begin
               if(ur_prready)
               next_state            <=MMR_PAR_CHECK;
               else
               next_state            <=WAIT_MMR_PAR;
           end
           MMR_PAR_CHECK:
           begin
               next_state            <=REQ_SBE_ECC;
           end
           REQ_SBE_ECC:
           begin
               next_state            <=WAIT_SBE_ECC;
           end
           WAIT_SBE_ECC:
           begin
               if(ur_prready)
               next_state            <=SBE_ECC_CHECK;
               else
               next_state            <=WAIT_SBE_ECC;
           end
           SBE_ECC_CHECK:
           begin
               next_state            <=DONE;
           end
           DONE:
           begin
               next_state            <=DONE;
           end
           default:
               begin
               next_state            <=INIT;
               end
           endcase
           end
      end

      // failure case handling
      // The following code is for simulation display only
      // synthesis translate_off
      always_ff @(posedge clk)
      begin
           if (fail & done ) begin
               $display("----------     Simulation Failed on MMR/APB Checking     ----------");
               if (wdpe_derr_fail)
               begin
                   if(DIAG_WR_PAR)
                       $display("ERROR : write parity error signal is always 0 which should raise to high when DIAG_WR_PAR enabled");
                   else
                       $display("ERROR : write parity error signal should not raise");
               end
               if (rdpe_derr_fail)
               begin
                   if(DIAG_RD_PAR)
                       $display("ERROR : read parity error signal is always 0 which should raise to high when DIAG_WR_PAR enabled");
                   else
                       $display("ERROR : read parity error signal should not raise");
               end
               if (sbe_corr_fail)
               begin
                   if(DIAG_SBE_CORRECT)
                       $display("ERROR : single bit error flag is always 0 which should raise to high when DIAG_SBE_ECC enabled");
                   else
                       $display("ERROR : single bit error flag should not raise");
               end
          end
      end
      // synthesis translate_on

      assign done = (state==DONE);
      assign fail = wdpe_derr_fail|rdpe_derr_fail|sbe_corr_fail;
   end else begin
      assign ur_paddr = '0;
      assign ur_psel = '0;
      assign ur_penable = '0;
      assign ur_pwrite = '0;
      assign ur_pwdata = '0;
      assign ur_pstrb = '0;
      assign fail = '0;
      assign done = '0;
   end
   endgenerate
      
endmodule
