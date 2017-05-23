// $Id: $
// File name:   fir_filter.sv
// Created:     9/28/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module fir_filter
(
input wire clk,
input wire n_reset,
input wire [15:0] sample_data,
input wire [15:0] fir_coefficient,
input wire data_ready,
input wire load_coeff,
output wire one_k_samples,
output wire modwait,
output wire [15:0] fir_out,
output wire err
);

reg dr;
reg lc;
reg cnt_up;
reg clear;
reg [2:0] op;
reg [3:0] src1;
reg [3:0] src2;
reg [3:0] dest;
reg overflow;
reg [16:0] outreg_data; 

controller control (.clk(clk), .n_reset(n_reset), .dr(dr), .lc(lc), .overflow(overflow), .cnt_up(cnt_up), .clear(clear), .modwait(modwait), .op(op), .src1(src1), .src2(src2), .dest(dest), .err(err));
counter count (.clk(clk), .n_reset(n_reset), .cnt_up(cnt_up), .clear(clear), .one_k_samples(one_k_samples));
sync_low sync1 (.clk(clk), .n_rst(n_reset), .async_in(data_ready), .sync_out(dr));
sync_low sync2 (.clk(clk), .n_rst(n_reset), .async_in(load_coeff), .sync_out(lc));
magnitude magn (.in(outreg_data), .out(fir_out));
datapath data (.clk(clk), .n_reset(n_reset), .op(op), .src1(src1), .src2(src2), .dest(dest), .ext_data1(sample_data), .ext_data2(fir_coefficient), .outreg_data(outreg_data), .overflow(overflow));

endmodule 
