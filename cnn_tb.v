`timescale 1ns / 1ps

module cnn_tb;

    reg clk;
    reg reset;
    reg [7:0] pxl_in;

    wire [15:0] conv_out;
    wire conv_valid;

    wire [15:0] relu_out;
    reg  [15:0] pool_in [0:3];
    wire [15:0] pool_out;
    wire [15:0] fc_out;

    integer i, outfile;
    reg [7:0] image [0:24]; // 5x5 image

    // Dummy weights for FC
    wire [15:0] w0 = 16'd1, w1 = 16'd1, w2 = 16'd1, w3 = 16'd1;
    wire [15:0] bias = 16'd0;

    // Clock generation
    always #5 clk = ~clk;

    // CONV
    wire [15:0] reg_00, reg_01, reg_02, sr_0;
    wire [15:0] reg_10, reg_11, reg_12, sr_1;
    wire [15:0] reg_20, reg_21, reg_22;

    conv conv_inst (
        .clk(clk),
        .reset(reset),
        .pxl_in(pxl_in),
        .reg_00(reg_00), .reg_01(reg_01), .reg_02(reg_02), .sr_0(sr_0),
        .reg_10(reg_10), .reg_11(reg_11), .reg_12(reg_12), .sr_1(sr_1),
        .reg_20(reg_20), .reg_21(reg_21), .reg_22(reg_22),
        .pxl_out(conv_out),
        .valid(conv_valid)
    );

    // RELU
    relu relu_inst (
        .in(conv_out),
        .out(relu_out)
    );

    // MAXPOOL (2x2 pooling on sequential ReLU outputs)
    maxpool_2x2 maxpool_inst (
        .d0(pool_in[0]),
        .d1(pool_in[1]),
        .d2(pool_in[2]),
        .d3(pool_in[3]),
        .out(pool_out)
    );

    // FC Layer (1 neuron)
    fc fc_inst (
        .in0(pool_in[0]),
        .in1(pool_in[1]),
        .in2(pool_in[2]),
        .in3(pool_in[3]),
        .w0(w0), .w1(w1), .w2(w2), .w3(w3),
        .bias(bias),
        .out(fc_out)
    );

    // Simulation
    initial begin
        $dumpfile("cnn_tb.vcd");
        $dumpvars(0, cnn_tb);

        $readmemh("input_image.txt", image);

        clk = 0;
        reset = 1;
        pxl_in = 0;
        #20;
        reset = 0;

        outfile = $fopen("cnn_output.txt", "w");

        for (i = 0; i < 25; i = i + 1) begin
            pxl_in = image[i];
            #10;
        end

        #100;

        $fclose(outfile);
        $display("Simulation finished.");
        $finish;
    end

    integer p = 0;

    // Collect ReLU outputs and apply maxpool every 4 valid values
    always @(posedge clk) begin
        if (conv_valid) begin
            pool_in[p] <= relu_out;
            p <= p + 1;
            if (p == 3) begin
                #1; // let maxpool compute
                $display("Maxpool: %d, FC Out: %d", pool_out, fc_out);
                $fwrite(outfile, "%d\n", fc_out);
                p <= 0;
            end
        end
    end

endmodule
