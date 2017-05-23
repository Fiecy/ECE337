// $Id: $
// File name:   sync_high.sv
// Created:     9/6/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module sync_high
(
	input wire clk,
	input wire n_rst,
 	input wire async_in,
	output wire sync_out
);

	reg out1;
	reg out2;
	
	always_ff @ (posedge clk, negedge n_rst)
	begin : sync_high
	  if(1'b0 == n_rst)
	  begin
	    out1 <= 1;
	    out2 <= 1;
	  end

	  else
	  begin
	    out1 <= async_in;
	    out2 <= out1;
	  end
	end
	assign sync_out = out2;

endmodule
