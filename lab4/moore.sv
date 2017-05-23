// $Id: $
// File name:   moore.sv
// Created:     9/19/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100 ps
module moore
(
	input wire clk,
	input wire n_rst,
	input wire i,	
	output reg o
);
   reg 		   state1;
   reg 		   state11;
   reg 		   state110;
   reg 		   state1101;
   reg 		   state1_n;
   reg 		   state11_n;
   reg 		   state110_n;
   reg 		   state1101_n;

   always_ff @ (posedge clk, negedge n_rst)
     begin
	if (0 == n_rst)
	  begin
	     o <= 0; // output 'o'
	     state1 <= 0;
	     state11 <= 0;
	     state110 <= 0;
	     state1101 <= 0;
	  end
	else
	  begin
	     o <= state1101_n;
	     state1 <= state1_n;
	     state11 <= state11_n;
	     state110 <= state110_n;
	     state1101 <= state1101_n;
	  end
     end // always_ff @

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

	if (i == 1 && state110 == 1)
	  state1101_n = 1;
	else
	  state1101_n = 0;
     end // always_comb
endmodule