// $Id: $
// File name:   flex_stp_sr.sv
// Created:     9/13/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module flex_stp_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1
)
(
	input clk,
	input n_rst,
	input shift_enable,
	input serial_in,
	output [NUM_BITS-1:0] parallel_out
);

	reg [NUM_BITS-1:0] p_out;
	reg [NUM_BITS-1:0] p_out_next;


	always_ff @ (posedge clk, negedge n_rst)
	begin
		if (n_rst == 0)
			p_out <= '1;
		else
			p_out <= p_out_next;
	end

	always_comb
	begin
	        if (shift_enable == 0)
		  begin
		     p_out_next[NUM_BITS-1:0] = p_out[NUM_BITS-1:0];
		     end
                else if (SHIFT_MSB == 1)
			p_out_next[NUM_BITS-1:0] = {p_out[NUM_BITS-2:0], serial_in};
		else
			p_out_next[NUM_BITS-1:0] = {serial_in, p_out[NUM_BITS-1:1]};	
	end

	assign parallel_out = p_out;
endmodule
