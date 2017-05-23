// $Id: $
// File name:   rcv_block.sv
// Created:     9/19/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module rcv_block
  (
   input 	clk,
   input 	n_rst,
   input 	serial_in,
   input 	data_read,
   output [7:0] rx_data,
   output 	data_ready, 
   output 	overrun_error,
   output reg	framing_error 	     
   );
   
   reg 		start_bit_detected;
   reg 		packet_done;
   reg 		sbc_clear;
   reg  	sbc_enable;
   reg 		load_buffer;
   reg 		enable_timer;
   reg 		shift_strobe;
   reg [7:0] 	packet_data;
   reg 		stop_bit;
   
		
   start_bit_det startb (.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .start_bit_detected(start_bit_detected));
   rcu rcucase (.clk(clk), .n_rst(n_rst), .start_bit_detected(start_bit_detected), .packet_done(packet_done), .framing_error(framing_error), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .load_buffer(load_buffer), .enable_timer(enable_timer));
   timer timer90 (.clk(clk), .n_rst(n_rst), .enable_timer(enable_timer), .shift_strobe(shift_strobe), .packet_done(packet_done));
   sr_9bit shift9 (.clk(clk), .n_rst(n_rst), .shift_strobe(shift_strobe), .serial_in(serial_in), .packet_data(packet_data), .stop_bit(stop_bit));
   stop_bit_chk chkstop (.clk(clk), .n_rst(n_rst), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .stop_bit(stop_bit), .framing_error(framing_error));
   rx_data_buff rxdatabuffer (.clk(clk), .n_rst(n_rst), .load_buffer(load_buffer), .packet_data(packet_data), .data_read(data_read), .rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error));

endmodule
