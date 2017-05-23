// $Id: $
// File name:   decode.sv
// Created:     10/4/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module decode
(
 input clk,
 input n_rst,
 input d_plus,
 input shift_enable,
 input eop,
 output d_orig
 );

   reg 	stored;
   reg 	next_stored;
   reg 	cur_d_orig;
   reg 	next_d_orig;

   assign d_orig = cur_d_orig;
   
   always_ff @(posedge clk, negedge n_rst)
     begin
	if (0 == n_rst)
	  begin
	     stored <= 1;
	     cur_d_orig <= 1;
	  end
	else
	  begin
	     stored <= next_stored;
	     cur_d_orig <= next_d_orig;
	  end
     end // always_ff @ (posedge clk, negedge n_rst)

   always_comb
     begin
	if (1 == shift_enable && 1 == eop)
	  begin
	     next_d_orig = 1;
	     next_stored = 1;
	  end
	else if (1 == shift_enable)
	  begin
	     next_stored = d_plus;
	     next_d_orig = 1;
	  end
	else
	  begin
	     next_stored = stored;
	     if (next_stored == d_plus)
	       next_d_orig = 1;
	     else
	       next_d_orig = 0;
	  end // else: !if(1 == shift_enable)
     end // always_comb begin
endmodule // decode

   
   
	     
	     