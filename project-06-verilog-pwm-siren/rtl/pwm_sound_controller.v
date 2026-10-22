`timescale 1us/1ns
// -----------------------------------------------------------------------------
// Module Name : pwm_sound_controller  ("Aria" / siren tone generator)
// Description : Drives a buzzer with a PWM waveform whose duty cycle ramps
//               0% -> 100% -> 0% so that the perceived loudness swells and
//               fades like an aria.
//
//   Timing (clock = 5 kHz, i.e. 0.2 ms period):
//       ramp-up    2 s   (10 steps x 200 ms, duty 0% .. 90%)
//       hold high  1 s   (duty 100%)
//       ramp-down  2 s   (10 steps x 200 ms, duty 90% .. 0%)
//       hold low   1 s   (silent)
//       -> 6 s total, repeating forever
//
//   11 loudness levels: 0, 10, 20, ... 90, 100 %
//
// Tool        : Xilinx Vivado
// -----------------------------------------------------------------------------

module pwm_sound_controller(
    input  wire clk,        // 5 kHz clock
    input  wire rst_n,      // asynchronous reset, active low
    output reg  pwm_out     // PWM output
);

    // Duty-cycle control
    reg [3:0]  duty_step;   // 0..9  -> 0..90 %
    reg [20:0] cnt_200ms;   // generates the 200 ms step interval
    reg [3:0]  state;       // state-machine state
    reg [3:0]  hold_cnt;    // counter used for the HOLD states

    // PWM generation
    reg [3:0]  pwm_cnt;

    // Number of clock cycles per 200 ms  (5 kHz clock -> 200 ms = 1000 cycles)
    parameter STEP_CYCLES = 1000;

    // State encoding
    parameter STATE_RAMP_UP   = 0;
    parameter STATE_HOLD_HIGH = 1;
    parameter STATE_RAMP_DOWN = 2;
    parameter STATE_HOLD_LOW  = 3;

    // -------------------------------------------------------------------------
    // State-machine logic
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_200ms <= 0;
            duty_step <= 0;
            state     <= STATE_RAMP_UP;
            hold_cnt  <= 0;
        end else begin
            if (cnt_200ms >= STEP_CYCLES - 1) begin
                cnt_200ms <= 0;
                case (state)

                    STATE_RAMP_UP: begin
                        if (duty_step < 9) begin
                            duty_step <= duty_step + 1;
                        end else begin
                            state     <= STATE_HOLD_HIGH;
                            duty_step <= 10;          // 100 %
                            hold_cnt  <= 0;
                        end
                    end

                    STATE_HOLD_HIGH: begin
                        if (hold_cnt < 4) begin    // 5 x 200 ms = 1 s
                            hold_cnt <= hold_cnt + 1;
                        end else begin
                            hold_cnt  <= 0;
                            state     <= STATE_RAMP_DOWN;
                            duty_step <= 9;
                        end
                    end

                    STATE_RAMP_DOWN: begin
                        if (duty_step > 0) begin
                            duty_step <= duty_step - 1;
                        end else begin
                            state    <= STATE_HOLD_LOW;
                            hold_cnt <= 0;
                        end
                    end

                    STATE_HOLD_LOW: begin
                        if (hold_cnt < 4) begin    // 1 s
                            hold_cnt <= hold_cnt + 1;
                        end else begin
                            hold_cnt  <= 0;
                            state     <= STATE_RAMP_UP;
                            duty_step <= 0;
                        end
                    end

                endcase
            end else begin
                cnt_200ms <= cnt_200ms + 1;
            end
        end
    end

    // -------------------------------------------------------------------------
    // PWM output logic  (10-step resolution)
    // -------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pwm_cnt <= 0;
            pwm_out <= 0;
        end else begin
            pwm_cnt <= (pwm_cnt == 9) ? 0 : pwm_cnt + 1;
            pwm_out <= (pwm_cnt < duty_step) ? 1'b1 : 1'b0;
        end
    end

endmodule
