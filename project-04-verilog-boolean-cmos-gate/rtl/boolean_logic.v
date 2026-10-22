`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// Module Name : boolean_logic
// Description : Combinational logic implementing the Boolean expression
//
//                   F  =  NOT( A . (B + C) + D )     [bar drawn over the whole
//                                                     right-hand side]
//               i.e.  F = ~( (A & (B | C)) | D )
//
//               Inverted-input CMOS compound gate (NAND of a 2-level complex
//               term), drawn as a P-network pull-up and N-network pull-down.
// Tool        : Xilinx Vivado
// -----------------------------------------------------------------------------

module boolean_logic(
    input      A,
    input      B,
    input      C,
    input      D,
    output reg F
);

    always @(*) begin
        F = ~( A & (B | C) | D );
    end

endmodule
