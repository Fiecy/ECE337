// $Id: $
// File name:   mealy.sv
// Created:     9/19/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100 ps

module mealy
(
	input wire clk,
	input wire n_rst,
	input wire i,	
	output reg o
);
   reg 		   state1;
   reg 		   state11;
   reg 		   state110;
   reg 		   state1_n;
   reg 		   state11_n;
   reg 		   state110_n;
   reg 		   o_next;  

   always_ff @ (posedge clk, negedge n_rst)
     begin
	if (0 == n_rst)
	  begin
	     state1 <= 0;
	     state11 <= 0;
	     state110 <= 0;
	  end
	else
	  begin
	     state1 <= state1_n;
	     state11 <= state11_n;
	     state110 <= state110_n;
	  end
     end // always_ff @

      always_comb
	begin
	   if (0 == n_rst)
	     o = 0;
	   else
	     o = (state110 & i);
	end
   
   always_comb
     begin
	if (i == 1)
	  state1_n = 1;
	else
	  state1_n = 0;

	if (i == 1 && state1 == 1)
	  state11_n = 1;
	else
	  state11_n = 0;

	if (i == 0 && state11 == 1)
	  state110_n = 1;
	else
	  state110_n = 0;

     end // always_comb
endmodule
