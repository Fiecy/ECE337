// $Id: $
// File name:   rcu_inner.sv
// Created:     12/01/2016
// Author:      Shenwei Wang
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module rcu_inner(
		 //input signal
		 input 		  clk, n_rst, 
		 input [31:0] 	  data_out, 
		 input [7:0] 	  data_in,
		 input 		  HWRITE,
		 //output
		 output reg 	  eot, //end of transmision 
		 output reg [7:0] data_outto_c, // data out to controller
		 output reg [31:0] data_into_rcu //data go into rcu
		 );
   
   //declaration
   reg 				   next_eot;
   reg [7:0] 			   next_data_outto_c;
   reg [31:0] 			   next_data_into_rcu;
   
   //code
   

   always_ff@(posedge clk, negedge n_rst)
     begin
	if(n_rst == 1'b0)
	  begin
	     eot <= 0;
	     data_outto_c <= 8'b00000000;
	     data_into_rcu <= 32'h00000000;
	  end
	else
	  begin
	     eot <= next_eot;
	     data_outto_c <= next_data_outto_c;
	     data_into_rcu <= next_data_into_rcu;
	  end
     end


   always_comb
     //output logic
     begin
	next_eot = 1'b0;
	next_data_outto_c = 8'b00000000;
	next_data_into_rcu = 32'h00000000;

	if(HWRITE == 1'b0)
	  begin
	     next_eot = 1'b0;
	     next_data_outto_c = 8'b00000000;
	     next_data_into_rcu = {24'h000000,data_in};
	  end
	
	else if(eot == 1'b0)
	  begin
	     if(data_out[7:0] == 8'b11111111)
	       begin
		  next_eot = 1'b1;
		  next_data_outto_c = 8'b11111111;
		  next_data_into_rcu = 32'h00000000;
	       end
	     else
	       begin
		  next_eot = 1'b0;
		  next_data_outto_c = {data_out[7:0]};
		  next_data_into_rcu = 32'h00000000;
	       end // else: !if(data_out[7:0] == 8'b11111111)
	     
	  end // if (eot == 1'b0)
	else
	  begin
	     next_eot = 1'b1;
	     next_data_outto_c = data_outto_c;
	     next_data_into_rcu = data_into_rcu;
	  end
	
     end // always_comb begin
   
endmodule
