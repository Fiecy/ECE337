// $Id: $
// File name:   edge_detect.sv
// Created:     10/4/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module edge_detect
(
 input clk,
 input n_rst,
 input d_plus,
 output d_edge
 );
   reg  d_plus_hold;
   reg 	next_d_edge;

   always_ff @(posedge clk, negedge n_rst)
     begin
	if(0 == n_rst)
	  begin
	     d_plus_hold <= 1;
	     next_d_edge <= 0;
	  end
	else
	  begin
	     next_d_edge <= (d_plus ^ d_plus_hold);
	     d_plus_hold <= d_plus;
	  end
     end // always_ff @ (posedge clk, negedge n_rst)
   assign d_edge = next_d_edge;
   
endmodule // edge_detect

	     
	
	
		   