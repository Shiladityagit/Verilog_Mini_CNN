// ReLU - Behavioral Modeling

module relu (
    input  [15:0] in,
    output [15:0] out
);
    assign out = (in[15] == 1'b1) ? 16'd0 : in;  // Zero if negative
endmodule
