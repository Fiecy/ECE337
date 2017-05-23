// $Id: $
// File name:   eop_detect.sv
// Created:     10/4/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module eop_detect
(
 input d_plus,
 input d_minus,
 output eop
 );

   assign eop = (~d_plus) & (~d_minus);

endmodule // eop_detect
