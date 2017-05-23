// $Id: $
// File name:   usb_receiver.sv
// Created:     10/12/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module usb_receiver
(
 input clk,
 input n_rst,
 input d_plus,
 input d_minus,
 input r_enable,
 output [7:0] r_data,
 output empty,
 output full,
 output rcving,
 output r_error
 );
   reg 	d_plus_sync;
   reg 	d_minus_sync;
   reg 	d_edge;
   reg 	d_orig;
   reg 	eop;
   reg 	shift_enable;
   reg 	byte_received;
   reg [7:0] rcv_data;
   reg 	     w_enable;

   sync_high   sync_h (.clk(clk), .n_rst(n_rst), .async_in(d_plus), .sync_out(d_plus_sync));
   sync_low    sync_l (.clk(clk), .n_rst(n_rst), .async_in(d_minus), .sync_out(d_minus_sync));
   edge_detect edge_d (.clk(clk), .n_rst(n_rst), .d_plus(d_plus_sync), .d_edge(d_edge));
   decode      deco   (.clk(clk), .n_rst(n_rst), .d_plus(d_plus_sync), .shift_enable(shift_enable), .eop(eop), .d_orig(d_orig));
   eop_detect  eop_d  (.d_plus(d_plus_sync), .d_minus(d_minus_sync), .eop(eop));
   timer       tmr    (.clk(clk), .n_rst(n_rst), .d_edge(d_edge), .rcving(rcving), .shift_enable(shift_enable), .byte_received(byte_received));
   shift_register sft (.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable), .d_orig(d_orig), .rcv_data(rcv_data));
   rcu         rcu_t  (.clk(clk), .n_rst(n_rst), .d_edge(d_edge), .eop(eop), .shift_enable(shift_enable), .rcv_data(rcv_data), .byte_received(byte_received), .rcving(rcving), .w_enable(w_enable), .r_error(r_error));
   rx_fifo     fifo   (.clk(clk), .n_rst(n_rst), .r_enable(r_enable), .w_enable(w_enable), .w_data(rcv_data), .r_data(r_data), .empty(empty), .full(full));
endmodule // usb_receiver

     
   
