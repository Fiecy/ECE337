// $Id: $
// File name:   timer.sv
// Created:     10/12/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module timer
(
 input clk,
 input n_rst,
 input d_edge,
 input rcving,
 output shift_enable,
 output byte_received
 );
   reg [3:0] count_out;
   

   flex_counter #(4) count1 (.clk(clk), .n_rst(n_rst), .clear(!rcving||d_edge), .count_enable(rcving), .rollover_val(4'b1000), .count_out(count_out));
   flex_counter #(4) count2 (.clk(clk), .n_rst(n_rst), .clear(byte_received||!rcving), .count_enable(shift_enable), .rollover_val(4'b1000), .rollover_flag(byte_received));

   assign shift_enable = (count_out == 4'b0011);
			     
endmodule // timer
			     
