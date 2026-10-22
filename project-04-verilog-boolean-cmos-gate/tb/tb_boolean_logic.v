`timescale 1ns/1ps
// -----------------------------------------------------------------------------
// Testbench for boolean_logic
// Applies a selected set of input vectors (including the extreme cases
// 0000 / 0100 / 1111) with 10 ns spacing.
// -----------------------------------------------------------------------------

module tb_boolean_logic;

    reg  A, B, C, D;
    wire F;

    boolean_logic uut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .F(F)
    );

    initial begin
        A = 0; B = 0; C = 0; D = 0; #10;
        A = 0; B = 0; C = 0; D = 1; #10;
        A = 0; B = 0; C = 1; D = 0; #10;
        A = 0; B = 0; C = 1; D = 1; #10;

        A = 1; B = 1; C = 0; D = 0; #10;
        A = 1; B = 1; C = 0; D = 1; #10;
        A = 1; B = 1; C = 1; D = 0; #10;
        A = 1; B = 1; C = 1; D = 1; #10;

        A = 1; B = 0; C = 1; D = 0; #10;
        A = 1; B = 0; C = 1; D = 1; #10;
        A = 1; B = 1; C = 1; D = 0; #10;
        A = 1; B = 1; C = 1; D = 1; #10;

        A = 1; B = 0; C = 0; D = 1; #10;
        A = 1; B = 0; C = 1; D = 1; #10;
        A = 1; B = 1; C = 0; D = 1; #10;
        A = 1; B = 1; C = 1; D = 1; #10;

        $finish;
    end

endmodule
