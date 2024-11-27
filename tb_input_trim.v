`timescale 1ns / 1ps

module input_trim_tb;
    // Inputs
    reg clk;
    reg rst;
    reg [1:0] level;
    reg botton_1;
    reg botton_2;
    reg botton_3;
    reg botton_4;
    reg botton_5;
    reg botton_6;
    reg botton_7;
    reg botton_8;

    // Outputs
    wire [2:0] trimmed_inp_1;
    wire [2:0] trimmed_inp_2;
    wire [2:0] trimmed_inp_3;
    wire [2:0] trimmed_inp_4;
    wire [2:0] trimmed_inp_5;
    wire [2:0] trimmed_inp_6;
    wire [2:0] trimmed_inp_7;
    wire [2:0] trimmed_inp_8;
    wire [2:0] trimmed_inp_9;
    wire [2:0] trimmed_inp_10;
    wire [2:0] trimmed_inp_11;
    wire [2:0] trimmed_inp_12;
    wire [2:0] trimmed_inp_13;
    wire [2:0] trimmed_inp_14;
    wire [2:0] trimmed_inp_15;
    wire [2:0] trimmed_inp_16;
    wire end_signal;
    wire [3:0] error_code;

    // Instantiate the Unit Under Test (UUT)
    input_trim uut (
        .clk(clk),
        .rst(rst),
        .level(level),
        .botton_1(botton_1),
        .botton_2(botton_2),
        .botton_3(botton_3),
        .botton_4(botton_4),
        .botton_5(botton_5),
        .botton_6(botton_6),
        .botton_7(botton_7),
        .botton_8(botton_8),
        .trimmed_inp_1(trimmed_inp_1),
        .trimmed_inp_2(trimmed_inp_2),
        .trimmed_inp_3(trimmed_inp_3),
        .trimmed_inp_4(trimmed_inp_4),
        .trimmed_inp_5(trimmed_inp_5),
        .trimmed_inp_6(trimmed_inp_6),
        .trimmed_inp_7(trimmed_inp_7),
        .trimmed_inp_8(trimmed_inp_8),
        .trimmed_inp_9(trimmed_inp_9),
        .trimmed_inp_10(trimmed_inp_10),
        .trimmed_inp_11(trimmed_inp_11),
        .trimmed_inp_12(trimmed_inp_12),
        .trimmed_inp_13(trimmed_inp_13),
        .trimmed_inp_14(trimmed_inp_14),
        .trimmed_inp_15(trimmed_inp_15),
        .trimmed_inp_16(trimmed_inp_16),
        .end_signal(end_signal),
        .error_code(error_code)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns 주기
    end

    // Initial block
    initial begin
        // 초기화
        rst = 1;
        level = 2;
        botton_1 = 0;
        botton_2 = 0;
        botton_3 = 0;
        botton_4 = 0;
        botton_5 = 0;
        botton_6 = 0;
        botton_7 = 0;
        botton_8 = 0;

        // 리셋 활성화
        #20;
        rst = 0;
        #20;
        rst = 1;

        // 몇 사이클 대기
        #20;

        // 유효한 버튼 입력 (botton_1)
        #10;
        botton_1 = 1;
        #10;
        botton_1 = 0;

        // 유효한 버튼 입력 (botton_2)
        #20;
        botton_2 = 1;
        #10;
        botton_2 = 0;

        // 무효한 버튼 입력 (botton_3과 botton_4 동시에 눌림)
        #20;
        botton_3 = 1;
        botton_4 = 1;
        #10;
        botton_3 = 0;
        botton_4 = 0;

        // 유효한 버튼 입력 (botton_5)
        #17;
        botton_5 = 1;
        #23;
        botton_5 = 0;

        // 유효한 버튼 입력 (botton_6)
        #20;
        botton_6 = 1;
        #60;
        botton_6 = 0;

        // 유효한 버튼 입력 (botton_7)
        #20;
        botton_7 = 1;
        #10;
        botton_7 = 0;

        // 유효한 버튼 입력 (botton_8)
        #20;
        botton_8 = 1;
        #10;
        botton_8 = 0;

        // 유효한 버튼 입력 (botton_1)
        #20;
        botton_1 = 1;
        #10;
        botton_1 = 0;

        // 유효한 버튼 입력 (botton_2)
        #20;
        botton_2 = 1;
        #10;
        botton_2 = 0;

        // 유효한 버튼 입력 (botton_3)
        #20;
        botton_3 = 1;
        #10;
        botton_3 = 0;

        // 유효한 버튼 입력 (botton_4)
        #20;
        botton_4 = 1;
        #10;
        botton_4 = 0;

        // 유효한 버튼 입력 (botton_5)
        #20;
        botton_5 = 1;
        #10;
        botton_5 = 0;

        // 유효한 버튼 입력 (botton_5)
        #20;
        botton_5 = 1;
        #10;
        botton_5 = 0;
        // 총 12개의 유효한 입력이 주어졌으며, 이는 level=2에 해당하는 MAX 값입니다.

        #20;
        botton_8 = 1;
        #10;
        botton_8 = 0;

        // 몇 사이클 대기
        #50;

        // 리셋 활성화 (전체 과정 종료)
        rst = 1;

        // 시뮬레이션 종료
        #20;
    end

    // 출력 모니터링
    initial begin
        $monitor("Time=%0d, rst=%b, level=%d, end_signal=%b, error_code=%b, i=%d, trimmed_inp_1=%d, trimmed_inp_2=%d, trimmed_inp_3=%d, trimmed_inp_4=%d, trimmed_inp_5=%d",
            $time, rst, level, end_signal, error_code, uut.i, trimmed_inp_1, trimmed_inp_2, trimmed_inp_3, trimmed_inp_4, trimmed_inp_5);
    end

endmodule
