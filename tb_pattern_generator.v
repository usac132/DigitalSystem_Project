module tb_pattern_generator;
    // Inputs
    reg clk_1;
    reg clk_2;
    reg enable;
    reg keypad_0;
    reg dip;

    // Outputs
    wire [2:0] pattern_1, pattern_2, pattern_3, pattern_4, pattern_5;
    wire [2:0] pattern_6, pattern_7, pattern_8, pattern_9, pattern_10;
    wire [2:0] pattern_11, pattern_12, pattern_13, pattern_14, pattern_15, pattern_16;

    // Instantiate the pattern generator
    pattern_generator uut (
        .clk_1(clk_1),
        .clk_2(clk_2),
        .enable(enable),
        .keypad_0(keypad_0),
        .dip(dip),
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
        .pattern_16(pattern_16)
    );

    // Clock generation
    initial begin
        clk_1 = 0;
        forever #10 clk_1 = ~clk_1; // clk_1 = 50 MHz
    end

    initial begin
        clk_2 = 0;
        forever #2 clk_2 = ~clk_2; // clk_2 = 250 MHz
    end

    // Test sequence
    initial begin
        // Initialize inputs
        keypad_0 = 0;
        dip = 0;
        enable = 0;

        // Wait for reset period
        #100;

        // Step 1: Activate keypad_0 to reset counter
        keypad_0 = 1;
        #20;
        keypad_0 = 0;

        // Step 2: Activate dip signal
        #97
        dip = 1;
        #20;

        // Step 3: Enable pattern generation
        enable = 1;
        #100;
        enable = 0;

        // Wait for some time and re-enable
        #10;
        dip = 0;
        #10
        dip = 1;
        #10
        enable = 1;

        // Observe patterns for a few cycles
        #146;
        dip = 0;
        #49;
        dip = 1;
        #20
        enable = 0;
        #20;
        enable = 1;
    end
endmodule
