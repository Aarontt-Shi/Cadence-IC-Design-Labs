// -----------------------------------------------------------------------------
// Module Name : full_adder
// Description : One-bit full adder implemented with dataflow (continuous
//               assignment) modelling.
//               Sum  = A ^ B ^ Cin
//               Cout = (A & B) | (B & Cin) | (A & Cin)
// Tool        : Xilinx Vivado
// -----------------------------------------------------------------------------

module full_adder(
    input  A,
    input  B,
    input  Cin,
    output Sum,
    output Cout
);

    assign Sum  = A ^ B ^ Cin;
    assign Cout = (A & B) | (B & Cin) | (A & Cin);

endmodule
