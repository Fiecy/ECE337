// $Id: $
// File name:   shift_register.sv
// Created:     10/12/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module shift_register
(
 input clk,
 input n_rst,
 input shift_enable,
 input d_orig,
 output [7:0] rcv_data
 );

   flex_stp_sr #(8,0) shift_reg (.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable), .serial_in(d_orig), .parallel_out(rcv_data));
endmodule // shift_register
