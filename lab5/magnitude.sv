// $Id: $
// File name:   magnitude.sv
// Created:     9/27/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module magnitude
  (
   input  wire [16:0]  in,
   output wire [15:0] out
   );
   
   reg [15:0] 	      out_reg;

   assign out = out_reg;
	      
   always_comb
     begin
	if (in[16] == 1)
	  begin
	     out_reg = ~in[15:0] + 1;
	  end
	else
	  begin
	     out_reg = in[15:0];
	  end
     end // always_comb
   
endmodule // magnitude
