// Maxpool - Behavioral Modeling

module maxpool_2x2 (
    input  [15:0] d0, d1, d2, d3,
    output [15:0] out
);
    wire [15:0] max0 = (d0 > d1) ? d0 : d1;
    wire [15:0] max1 = (d2 > d3) ? d2 : d3;
    assign out = (max0 > max1) ? max0 : max1;
endmodule
