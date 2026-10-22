`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// Module Name : traffic_light
// Description : Traffic-light controller for a crossroads.
//
//   The crossroads is described by two conflicting directions:
//       light_ew[2:0] -> East-West   {Red, Yellow, Green}
//       light_ns[2:0] -> North-South {Red, Yellow, Green}
//
//   A free-running 4-bit counter (0..15) drives a 6-state sequence:
//
//     counter      state   East-West   North-South
//     -------------------------------------------------
//     0000 - 0101    1        Red         Green
//     0110 - 0111    2        Red         Yellow
//     1000 - 1100    3       Green         Red
//     1101 - 1111    4      Yellow         Red
//     (then the sequence repeats: states 5 and 6 are the repeats of 1 and 2)
//
// Tool        : Xilinx Vivado
// -----------------------------------------------------------------------------

module traffic_light(
    input             clk,
    input             rst_n,
    output reg [2:0]  light_ew,   // East-West   {Red, Yellow, Green}
    output reg [2:0]  light_ns    // North-South {Red, Yellow, Green}
);

    reg [3:0] counter;            // 16-state free-running counter

    // -------------------------------------------------------------------------
    // Counter control logic
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 4'b0;
        end else begin
            counter <= (counter == 4'b1111) ? 4'b0 : counter + 1;
        end
    end

    // -------------------------------------------------------------------------
    // Traffic-light state control (combinational decoding of the counter)
    // -------------------------------------------------------------------------
    always @(*) begin
        // default value: all lamps off
        light_ew = 3'b000;
        light_ns = 3'b000;

        case (1'b1)
            // Phase 1: 0-5 (6 cycles) - EW red, NS green
            (counter <= 4'b0101): begin
                light_ew[0] = 1'b1;   // East-West red
                light_ns[2] = 1'b1;   // North-South green
            end
            // Phase 2: 6-7 (2 cycles) - EW red, NS yellow
            (counter <= 4'b0111): begin
                light_ew[0] = 1'b1;   // East-West red
                light_ns[1] = 1'b1;   // North-South yellow
            end
            // Phase 3: 8-12 (5 cycles) - EW green, NS red
            (counter <= 4'b1100): begin
                light_ew[2] = 1'b1;   // East-West green
                light_ns[0] = 1'b1;   // North-South red
            end
            // Phase 4: 13-15 (3 cycles) - EW yellow, NS red
            default: begin
                light_ew[1] = 1'b1;   // East-West yellow
                light_ns[0] = 1'b1;   // North-South red
            end
        endcase
    end

endmodule
