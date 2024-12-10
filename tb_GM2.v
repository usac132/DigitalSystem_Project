`timescale 1ns / 1ps

module GameManager_tb;

    // ====== 입력 신호 (Inputs) ======
    reg clk_2;          // 1MHz 입력 클록
    reg botton_1;       // 버튼 입력
    reg botton_2;
    reg botton_3;
    reg botton_4;
    reg botton_5;
    reg botton_6;
    reg botton_7;
    reg botton_8;
    reg [2:0] KEY_COL;   // 키패드 열 입력
    reg dip;            // DIP 스위치
    reg dip_clk;        // DIP 클록

    // ====== 출력 신호 (Outputs) ======
    wire [3:0] KEY_ROW;      // 키패드 행 출력
    wire [3:0] key_inp;      // 감지된 키 입력
    wire led_1;
    wire led_2;
    wire led_3;
    wire led_4;
    wire led_5;
    wire led_6;
    wire led_7;
    wire led_8;
    wire [7:0] SEG_COM;
    wire [7:0] SEG_DATA;

    // ====== GameManager 인스턴스화 ======
    GameManager uut (
        .clk_2(clk_2),
        .botton_1(botton_1),
        .botton_2(botton_2),
        .botton_3(botton_3),
        .botton_4(botton_4),
        .botton_5(botton_5),
        .botton_6(botton_6),
        .botton_7(botton_7),
        .botton_8(botton_8),
        .KEY_COL(KEY_COL),
        .KEY_ROW(KEY_ROW),
        .dip(dip),
        .dip_clk(dip_clk),
        .led_1(led_1),
        .led_2(led_2),
        .led_3(led_3),
        .led_4(led_4),
        .led_5(led_5),
        .led_6(led_6),
        .led_7(led_7),
        .led_8(led_8),
        .SEG_COM(SEG_COM),
        .SEG_DATA(SEG_DATA)
    );

    // ====== 초기화 ======
    initial begin
        // 모든 입력을 0으로 초기화
        clk_2 = 0;
        botton_1 = 0;
        botton_2 = 0;
        botton_3 = 0;
        botton_4 = 0;
        botton_5 = 0;
        botton_6 = 0;
        botton_7 = 0;
        botton_8 = 0;
        KEY_COL = 3'b000;
        dip = 0;
        dip_clk = 0;

        // 글로벌 리셋 대기
        #100000

        // dip_clk를 1로 설정 후 즉시 0으로 설정
        dip_clk = 1;
        #500000;
        dip_clk = 0;

        // dip 신호를 켜고 끄며 리셋 수행 및 게임 시작
        dip = 1;
        #100000;
        dip = 0;

        // 패턴 출력 대기 (적절한 시간 설정, 여기서는 예시로 100000ns 대기)
        #100000;

        // 키패드에 '2' 입력 시뮬레이션
        // '2'는 key_row=4'b1000일 때 key_col=3'b010
        // key_row는 GameManager에 의해 순차적으로 활성화되므로, 이를 감지하여 KEY_COL을 설정

        // 키패드 스캔 주기가 clk_2 클록에 의해 결정되므로, 적절한 시간 후 KEY_COL 설정
        // 예시로 20000ns 후에 '2' 입력
        #200000;
        KEY_COL = 3'b010;    // '2' 입력
        #300000;
        #300000;
        KEY_COL = 3'b000;    // 입력 해제

        // LED 패턴 출력이 완료된 후 버튼 입력 시뮬레이션
        // 예시로 50000ns 후에 버튼_1 누름
        #500000;
        botton_1 = 1;
        #100000;
        botton_1 = 0;

        // 추가적인 시뮬레이션을 원할 경우 여기에 작성

        // 시뮬레이션 종료
        #1000000;

    end

    // ====== clk_2 생성 (1MHz 클록, 주기 1µs) ======
    always #500 clk_2 = ~clk_2; // 1MHz 클록: 주기 1µs (500ns High, 500ns Low)
    
endmodule
