// $Id: $
// File name:   counter.sv
// Created:     9/27/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module counter
  (
   input  wire  clk,
   input  wire  n_reset,
   input  wire  cnt_up,
   input  wire  clear,
   output wire  one_k_samples
);

   flex_counter #(10) counter1(.clk(clk),.n_rst(n_reset), .clear(clear), .count_enable(cnt_up), .rollover_val(10'd1000), .rollover_flag(one_k_samples));

endmodule
