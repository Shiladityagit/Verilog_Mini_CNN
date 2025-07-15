// Convolution - Structural Modeling

`timescale 1ns / 1ps

module conv(
    input clk,
    input reset,
    input [7:0] pxl_in,  // 8-bit input image
    // 3 x 3 convolution window
    output [15:0] reg_00, output [15:0] reg_01, output [15:0] reg_02, output [15:0] sr_0,
    output [15:0] reg_10, output [15:0] reg_11, output [15:0] reg_12, output [15:0] sr_1,
    output [15:0] reg_20, output [15:0] reg_21, output [15:0] reg_22,

    output [15:0] pxl_out,
    output valid
);

    // constants
    parameter N = 5;  // Image width
    parameter M = 5;  // Image height
    parameter K = 3;  // Kernel size

    wire [15:0] w00, w01, w02, w10, w11, w12, w20, w21, w22;

    // 3x3 kernel: Gaussian Blur
    parameter kernel_00 = 1, kernel_01 = 2, kernel_02 = 1;
    parameter kernel_10 = 0, kernel_11 = 0, kernel_12 = 0;
    parameter kernel_20 = 1, kernel_21 = 2, kernel_22 = 1;

    // Row 0
    mac m00(pxl_in, kernel_00, 0, w00);
    register r00(clk, reset, w00, reg_00);

    mac m01(pxl_in, kernel_01, reg_00, w01);
    register r01(clk, reset, w01, reg_01);

    mac m02(pxl_in, kernel_02, reg_01, w02);
    register r02(clk, reset, w02, reg_02);

    shift s0(clk, reg_02, sr_0);

    // Row 1
    mac m10(pxl_in, kernel_10, sr_0, w10);
    register r10(clk, reset, w10, reg_10);

    mac m11(pxl_in, kernel_11, reg_10, w11);
    register r11(clk, reset, w11, reg_11);

    mac m12(pxl_in, kernel_12, reg_11, w12);
    register r12(clk, reset, w12, reg_12);

    shift s1(clk, reg_12, sr_1);

    // Row 2
    mac m20(pxl_in, kernel_20, sr_1, w20);
    register r20(clk, reset, w20, reg_20);

    mac m21(pxl_in, kernel_21, reg_20, w21);
    register r21(clk, reset, w21, reg_21);

    mac m22(pxl_in, kernel_22, reg_21, w22);
    register r22(clk, reset, w22, reg_22);

    assign pxl_out = reg_22;

    reg [8:0] counter = 0;
    reg temp_valid = 0;

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter > ((K - 1) * N + (K - 1)) && counter < (M * N) + (K - 1)) begin
            if ((counter - (K - 1)) % N > 1)
                temp_valid <= 1;
            else
                temp_valid <= 0;
        end else begin
            temp_valid <= 0;
        end
    end

    assign valid = temp_valid;

endmodule
