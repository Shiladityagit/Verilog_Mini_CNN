// Fully Connected layer - Behavioral Modeling

module fc (
    input [15:0] in0, in1, in2, in3,
    input [15:0] w0, w1, w2, w3,
    input [15:0] bias,
    output [15:0] out
);
    assign out = in0 * w0 + in1 * w1 + in2 * w2 + in3 * w3 + bias;
endmodule
