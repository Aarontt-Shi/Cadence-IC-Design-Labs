`timescale 1us/1ns
// Testbench for pwm_sound_controller
// 5 kHz simulated clock (one clock period = 200 us is modelled as 1 us here
// so that the 6 s envelope can be observed in a short simulation).
// -----------------------------------------------------------------------------

module tb_pwm_sound_controller;

    reg  clk;
    reg  rst_n;
    wire pwm_out;

    pwm_sound_controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .pwm_out(pwm_out)
    );

    // 5 kHz = 200 us period -> simulated clock
    initial begin
        clk = 0;
        forever #100 clk = ~clk;   // 100 us -> 5 kHz
    end

    // Stimulus
    initial begin
        rst_n = 0;
        #500;
        rst_n = 1;

        // Run long enough to observe a complete envelope (e.g. 20 s)
        #200000;

        $stop;
    end

endmodule
