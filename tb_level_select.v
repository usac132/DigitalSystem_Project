`timescale 1ns / 1ps

module level_select_tb;
    // Inputs
    reg clk;
    reg keypad_1;
    reg keypad_2;
    reg keypad_3;
    reg keypad_0;

    // Outputs
    wire [2:0] level;
    wire rst;
    wire end_signal;

    // Instantiate the Unit Under Test (UUT)
    level_select uut (
        .clk(clk),
        .keypad_1(keypad_1),
        .keypad_2(keypad_2),
        .keypad_3(keypad_3),
        .keypad_0(keypad_0),
        .level(level),
        .rst(rst),
        .end_signal(end_signal)
        // error_code는 무시
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns 주기
    end

    // Test sequence
    initial begin
        // 초기화
        keypad_0 = 0;
        keypad_1 = 0;
        keypad_2 = 0;
        keypad_3 = 0;

        // 잠시 대기
        #20;
        keypad_0 = 1;
        #33
        keypad_0 = 0;

        // [포인트 1] 키패드 1을 눌렀을 때 level이 올바르게 출력되는가
        // 키패드 1 누름
        #10;
        keypad_1 = 1;
        #10;
        keypad_1 = 0;

        // 몇 사이클 대기하여 level과 end_signal 확인
        #20;

        // [포인트 4] 이미 level이 설정된 후 다른 키패드를 눌러도 level이 변하지 않는가
        // 키패드 2 누름
        #10;
        keypad_2 = 1;
        #10;
        keypad_2 = 0;

        // 몇 사이클 대기하여 level이 변하지 않는지 확인
        #20;

        // [포인트 3] 두 개의 키패드를 동시에 눌렀을 때 level이 출력되지 않는가
        // 리셋 수행
        #10;
        keypad_0 = 1;
        #10;
        keypad_0 = 0;

        // 몇 사이클 대기하여 리셋 완료
        #20;

        // 동시에 키패드 2와 3 누름
        #10;
        keypad_2 = 1;
        keypad_3 = 1;
        #10;
        keypad_2 = 0;
        keypad_3 = 0;

        // 몇 사이클 대기하여 level이 설정되지 않는지 확인
        #20;

        // [포인트 2] 어느 타이밍에 누르던지 잘 동작하는가
        // 클럭의 상승 에지와 비동기적으로 키패드 3 누름
        #7;
        keypad_3 = 1;
        #10;
        keypad_3 = 0;

        // 몇 사이클 대기하여 level과 end_signal 확인
        #20;

        // [포인트 6,7] keypad_0 눌렀을 때 rst 신호 생성 및 모듈 초기화 확인
        // keypad_0 누름
        #10;
        keypad_0 = 1;
        #10;
        keypad_0 = 0;

        // 몇 사이클 대기하여 rst 신호 및 모듈 초기화 확인
        #20;

        // [포인트 7,8] rst 이후 모듈이 정상 작동하는가
        // 키패드 2 누름
        #10;
        keypad_2 = 1;
        #10;
        keypad_2 = 0;

        // 몇 사이클 대기하여 level과 end_signal 확인
        #20;

        // 시뮬레이션 종료
        #50;
    end

    // 출력 모니터링
    initial begin
        $monitor("Time=%0d ns, clk=%b, rst=%b, keypad_0=%b, keypad_1=%b, keypad_2=%b, keypad_3=%b, level=%b, end_signal=%b",
                 $time, clk, rst, keypad_0, keypad_1, keypad_2, keypad_3, level, end_signal);
    end
endmodule
