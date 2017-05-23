// $Id: $
// File name:   ahb_lite.sv
// Created:     12/7/2016
// Author:      Shenwei Wang
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .

//Haddr from 32'hff00 to 32'hffff

module ahb_lite(
	   //input part
	   input 	 HCLK, HRESETn, 
	   input [31:0]  HADDR, 
	   input [31:0]  HWDATA,
	   input 	 HWRITE,
	   input [31:0]  data_in,//input data ready for hrdata
	   //output part
	   output [31:0] HRDATA, 
	   output 	 HREADYOUT,
	   output [31:0] data_out //output data from bus which is hwdata
	   );
   
   reg 			 addr_valid; //flag for valid haddr
   reg 			 next_addr_valid;
   
   reg 			 ready;
   reg 			 next_ready;
   
   reg [31:0] 		 ins_outdata;//instant data for data_out    
   // 	     
   reg [31:0] 		 next_outdata;
   
   reg [31:0] 		 ins_indata;//instant data for data_in
   reg [31:0] 		 next_indata;
   
   
   always_ff@(posedge HCLK, negedge HRESETn)
     begin
	if(HRESETn == 1'b0)
	  begin
	     ready <= 1'b1;
	     ins_outdata <= 32'h00000000;
	     ins_indata <= 32'h00000000;
	     addr_valid <= 1'b0;
	  end
	else
	  begin
	     ready <= next_ready;
	     ins_outdata <= next_outdata;
	     ins_indata <= next_indata;
	     addr_valid <= next_addr_valid;
	  end
     end // always_ff@ (posedge HCLK, negedge HRESETn)
   
   always_comb
     begin
	if(HADDR[31:16] == 16'hffff)
	  begin
	     next_addr_valid = 1'b1;
	  end
	else
	  begin
	     next_addr_valid = 1'b0;
	  end


	if(addr_valid == 1'b1)
	  begin
	     if(HWRITE == 1'b0)
	       begin
		  next_ready = 1;
		  next_indata = data_in;
		  next_outdata = 32'h00000000;//don't care, because it's read process
	       end//read
	     else
	       begin
		  next_ready = 1;
		  next_outdata = HWDATA;
		  next_indata = 32'h00000000;//don't care, because it's write process
	       end//write
	  end // if (addr_valid == 1'b1)
	else
	  begin
	     next_ready = 1;
	     next_outdata = 32'h00000000;//don't care, wrong address
	     next_indata = 32'h00000000;//don't care, wrong address
	  end//invalid
	
     end//end of always_comb
   
   assign HREADYOUT = ready;
   
   assign HRDATA = ins_indata;
   
   assign data_out = ins_outdata;
   
endmodule
