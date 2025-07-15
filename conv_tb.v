`timescale 1ns / 1ps

module conv_tb;

    reg clk;
    reg reset;
    reg [7:0] pxl_in;

    wire [15:0] pxl_out;
    wire valid;

    wire [15:0] reg_00, reg_01, reg_02, sr_0;
    wire [15:0] reg_10, reg_11, reg_12, sr_1;
    wire [15:0] reg_20, reg_21, reg_22;

    // Instantiation of module
    conv uut (
        .clk(clk),
        .reset(reset),
        .pxl_in(pxl_in),
        .reg_00(reg_00), .reg_01(reg_01), .reg_02(reg_02), .sr_0(sr_0),
        .reg_10(reg_10), .reg_11(reg_11), .reg_12(reg_12), .sr_1(sr_1),
        .reg_20(reg_20), .reg_21(reg_21), .reg_22(reg_22),
        .pxl_out(pxl_out),
        .valid(valid)
    );

    always #5 clk = ~clk;  // 10ns clock period

    reg [7:0] image [0:24]; // 5x5 image = 25 pixels
    integer i;

    integer outfile;

    initial begin

        $dumpfile("conv_tb.vcd");
        $dumpvars(0, conv_tb);

        $readmemh("input_image.txt", image);  // Decimal or hex format

        outfile = $fopen("output_pixels.txt", "w");

        clk = 0;
        reset = 1;
        pxl_in = 0;
        #20;
        reset = 0;

        for (i = 0; i < 25; i = i + 1) begin
            pxl_in = image[i];
            #10;  // wait one clock cycle
        end

        #100;

        $fclose(outfile);
        $display("Simulation completed.");
        $finish;
    end

    always @(posedge clk) begin
        if (valid) begin
            $display("Valid Output: %d", pxl_out);
            $fwrite(outfile, "%d\n", pxl_out);
        end
    end

endmodule
