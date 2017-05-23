// $Id: $
// File name:   timer.sv
// Created:     9/19/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module timer
  (
   input clk,
   input n_rst,
   input enable_timer,
   output shift_strobe,
   output packet_done
   );

   reg 	  temp;
   
   always_ff @ (posedge clk, negedge n_rst)
     begin
	if (0 == n_rst)
	  temp <= 0;
	else
	  temp <= enable_timer;
     end
   
   flex_counter  x10 (.clk(clk), .n_rst(n_rst), .count_enable(temp), .clear(packet_done), .rollover_val(4'b1010), .rollover_flag(shift_strobe));  // x10
   flex_counter  count9 (.clk(clk), .n_rst(n_rst), .count_enable(shift_strobe), .clear(packet_done), .rollover_val(4'b1001), .rollover_flag(packet_done));  // count 9

endmodule
