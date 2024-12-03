`timescale 1ns / 1ps

module print_pattern_tb;

    // Inputs
    reg clk_1;
    reg clk_3;
    reg rst;
    reg enable;
    reg [2:0] level;
    reg [2:0] pattern_1;
    reg [2:0] pattern_2;
    reg [2:0] pattern_3;
    reg [2:0] pattern_4;
    reg [2:0] pattern_5;
    reg [2:0] pattern_6;
    reg [2:0] pattern_7;
    reg [2:0] pattern_8;
    reg [2:0] pattern_9;
    reg [2:0] pattern_10;
    reg [2:0] pattern_11;
    reg [2:0] pattern_12;
    reg [2:0] pattern_13;
    reg [2:0] pattern_14;
    reg [2:0] pattern_15;
    reg [2:0] pattern_16;

    // Outputs
    wire led_1;
    wire led_2;
    wire led_3;
    wire led_4;
    wire led_5;
    wire led_6;
    wire led_7;
    wire led_8;
    wire print_pattern_end;

    // Instantiate the Unit Under Test (UUT)
    print_pattern uut (
        .clk_1(clk_1),
        .clk_3(clk_3),
        .rst(rst),
        .enable(enable),
        .level(level),
        .pattern_1(pattern_1),
        .pattern_2(pattern_2),
        .pattern_3(pattern_3),
        .pattern_4(pattern_4),
        .pattern_5(pattern_5),
        .pattern_6(pattern_6),
        .pattern_7(pattern_7),
        .pattern_8(pattern_8),
        .pattern_9(pattern_9),
        .pattern_10(pattern_10),
        .pattern_11(pattern_11),
        .pattern_12(pattern_12),
        .pattern_13(pattern_13),
        .pattern_14(pattern_14),
        .pattern_15(pattern_15),
        .pattern_16(pattern_16),
        .led_1(led_1),
        .led_2(led_2),
        .led_3(led_3),
        .led_4(led_4),
        .led_5(led_5),
        .led_6(led_6),
        .led_7(led_7),
        .led_8(led_8),
        .print_pattern_end(print_pattern_end)
    );

    // Clock generation
    initial begin
        clk_1 = 0;
        forever #50 clk_1 = ~clk_1; // 10 kHz clock (Period = 100 ns)
    end

    initial begin
        clk_3 = 0;
        forever #50000 clk_3 = ~clk_3; // 10 Hz clock (Period = 100,000 ns)
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        enable = 0;
        level = 3'b000;
        pattern_1 = 3'b000;
        pattern_2 = 3'b000;
        pattern_3 = 3'b000;
        pattern_4 = 3'b000;
        pattern_5 = 3'b000;
        pattern_6 = 3'b000;
        pattern_7 = 3'b000;
        pattern_8 = 3'b000;
        pattern_9 = 3'b000;
        pattern_10 = 3'b000;
        pattern_11 = 3'b000;
        pattern_12 = 3'b000;
        pattern_13 = 3'b000;
        pattern_14 = 3'b000;
        pattern_15 = 3'b000;
        pattern_16 = 3'b000;

        // Apply rst signal first
        rst = 1;
        #100000; // Wait for 100,000 ns
        rst = 0;
        #100
        rst = 1;
        // Provide level signal after rst
        #100000; // Wait for 100,000 ns
        level = 3'b010; // Example level

        // Simultaneously provide enable and pattern signals
        #100000; // Wait for 100,000 ns
        enable = 1;
        pattern_1 = 3'b000;
        pattern_2 = 3'b001;
        pattern_3 = 3'b010;
        pattern_4 = 3'b011;
        pattern_5 = 3'b100;
        pattern_6 = 3'b101;
        pattern_7 = 3'b110;
        pattern_8 = 3'b111;
        pattern_9 = 3'b000;
        pattern_10 = 3'b001;
        pattern_11 = 3'b010;
        pattern_12 = 3'b011;
        pattern_13 = 3'b100;
        pattern_14 = 3'b101;
        pattern_15 = 3'b110;
        pattern_16 = 3'b111;

        // Wait for the pattern execution to complete
        wait(print_pattern_end == 1);

        // End of simulation
        #100000;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0dns, led_1=%b, led_2=%b, led_3=%b, led_4=%b, led_5=%b, led_6=%b, led_7=%b, led_8=%b, print_pattern_end=%b",
                 $time, led_1, led_2, led_3, led_4, led_5, led_6, led_7, led_8, print_pattern_end);
    end

endmodule
