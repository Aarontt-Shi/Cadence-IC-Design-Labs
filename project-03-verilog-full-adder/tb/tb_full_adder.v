`timescale 1ns/1ps
// -----------------------------------------------------------------------------
// Testbench for full_adder
// Applies all 8 input combinations with 10 ns spacing (exhaustive test).
// -----------------------------------------------------------------------------

module tb_full_adder;

    reg  A, B, Cin;
    wire Sum, Cout;

    // Instantiate the design under test
    full_adder uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
        A = 0; B = 0; Cin = 0;
        #10;
        A = 0; B = 1; Cin = 0;
        #10;
        A = 0; B = 0; Cin = 1;
        #10;
        A = 1; B = 1; Cin = 0;
        #10;
        A = 1; B = 1; Cin = 1;
        #10;
        A = 0; B = 1; Cin = 1;
        #10;
        A = 1; B = 0; Cin = 1;
        #10;
        A = 1; B = 0; Cin = 0;
        #10;
        $stop;
    end

endmodule
