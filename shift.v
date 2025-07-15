// Shift Register - Behavioral Modeling

`timescale 1ns / 1ps

module shift (
    input clk,
    input [15:0] in,
    output reg [15:0] out
);

    reg [15:0] buffer;

    always @(posedge clk) begin
        out <= buffer;
        buffer <= in;
    end

endmodule
