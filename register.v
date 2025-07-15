// 16-bit Register - Behavioral Modeling

`timescale 1ns / 1ps

module register (
    input clk,
    input reset,
    input [15:0] d,
    output reg [15:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 0; // Non-blocking assignment
        else
            q <= d;
    end

endmodule
