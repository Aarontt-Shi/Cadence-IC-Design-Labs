`timescale 1ns/1ps
// -----------------------------------------------------------------------------
// Testbench for traffic_light
// Generates a 100 MHz clock and observes two complete 16-count cycles.
// -----------------------------------------------------------------------------

module tb_traffic_light;

    reg        clk;
    reg        rst_n;
    wire [2:0] light_ew, light_ns;

    traffic_light dut (
        .clk(clk),
        .rst_n(rst_n),
        .light_ew(light_ew),
        .light_ns(light_ns)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        // Initialisation
        rst_n = 0;
        #20 rst_n = 1;

        // Run for two complete cycles (32 clock periods)
        #320 $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_traffic_light);
    end

endmodule
