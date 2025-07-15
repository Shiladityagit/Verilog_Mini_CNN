// Multiply-Accumulate (MAC) Unit - Behavioral Modeling

`timescale 1ns / 1ps

module mac (
    input  [7:0]  in,    // Input pixel
    input  [7:0]  w,     // Weight
    input  [15:0] b,     // Bias
    output [15:0] out    // Output
);

    assign out = (in * w) + b;

endmodule
