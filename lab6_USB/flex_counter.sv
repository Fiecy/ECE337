// $Id: $
// File name:   flex_counter.sv
// Created:     9/14/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100 ps
  
module flex_counter
#(
	parameter NUM_CNT_BITS = 4
)
(
	input 			      clk,
	input 			      n_rst,
	input 			      clear, 
	input 			      count_enable,
	input [NUM_CNT_BITS-1:0]      rollover_val,
	output reg [NUM_CNT_BITS-1:0] count_out,
	output 			      rollover_flag
);

        reg 			  r_flag;
        reg        [NUM_CNT_BITS-1:0] c_out;
        reg        [NUM_CNT_BITS-1:0] c_out_next;
  	reg			  r_flag_next;
   always_ff @ (posedge clk, negedge n_rst)
     begin
	if (n_rst == 0)
	  begin
	     c_out <= '0;
	     r_flag <= '0;
	  end
	else
 	  begin
	     c_out <= c_out_next;
	     r_flag <= r_flag_next;
          end
     end

   always_comb
     begin
	if (clear == 1)
	  begin
	     c_out_next = '0;
	  end
	else if (count_enable == 0)
	  c_out_next = count_out;
        else if (count_out < rollover_val)
	  c_out_next = count_out + 1;
	else 
	  c_out_next = 1;


	if (clear == 1)
	  r_flag_next = 0;
	else if (c_out_next == rollover_val)
	  r_flag_next = 1;
	else
	  r_flag_next = 0;
		
     end 
   assign rollover_flag = r_flag;
   assign count_out = c_out;
   
  endmodule
