`timescale 1ns / 1ps

module tb_GameManager_3;

    // 입력 신호 선언
    reg clk_2;
    reg botton_1;
    reg botton_2;
    reg botton_3;
    reg botton_4;
    reg botton_5;
    reg botton_6;
    reg botton_7;
    reg botton_8;
    reg dip1;
    reg dip2;
    reg dip3;
    reg dip_clk;
    reg dip_rst;
    // 출력 신호 선언
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

    // GameManager 인스턴스화
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
        .dip1(dip1),
        .dip2(dip2),
        .dip3(dip3),
        .dip_rst(dip_rst),
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
/*
    // clk_1: 적당히 빠른 속도 (예: 10ns 주기)
    initial clk_1 = 0;
    always #5 clk_1 = ~clk_1; // 10ns 주기
*/
    // clk_2: clk_1보다 매우 빠른 속도 (예: 1ns 주기)
    initial clk_2 = 0;
    always #0.5 clk_2 = ~clk_2; // 1ns 주기
/*
    // clk_3: 주기가 0.2초
    initial clk_3 = 0;
    always #100 clk_3 = ~clk_3; // 100,000,000 -> 100 0.2초 주기 (200,000,000ns)
*/
    // 버튼 누름을 위한 태스크 정의
    task press_button;
        input integer button_num;
        begin
            case(button_num)
                1: botton_1 = 1;
                2: botton_2 = 1;
                3: botton_3 = 1;
                4: botton_4 = 1;
                5: botton_5 = 1;
                6: botton_6 = 1;
                7: botton_7 = 1;
                8: botton_8 = 1;
                default: ;
            endcase
            #20000; // 버튼 누름 유지 시간
            case(button_num)
                1: botton_1 = 0;
                2: botton_2 = 0;
                3: botton_3 = 0;
                4: botton_4 = 0;
                5: botton_5 = 0;
                6: botton_6 = 0;
                7: botton_7 = 0;
                8: botton_8 = 0;
                default: ;
            endcase
            #200000; // 다음 버튼 누름 전 대기 시간
            #200000;
            #200000;
            #200000;
            #200000;
        end
    endtask

    // 초기 블록
    integer i;
    initial begin
        // 모든 버튼 초기화
        botton_1 = 0;
        botton_2 = 0;
        botton_3 = 0;
        botton_4 = 0;
        botton_5 = 0;
        botton_6 = 0;
        botton_7 = 0;
        botton_8 = 0;
        dip_clk = 0;
        dip_rst = 0;
        dip1 = 0;
        dip2 = 0;
        dip3 = 0;
        // 시뮬레이션 초기 대기
        #1000;

        // 시뮬레이션 초기 대기
        #10000;
        dip_clk = 1;
        #50000;
        dip_clk = 0;

        #500000;
        // 게임 시작: keypad_0 누름
        dip_rst = 1;
        #50000;
        dip_rst = 0;

        #500000;
        
        // 난이도 선택: keypad_2 누름
        dip2 = 1;
        #50000;
        dip2 = 0;
        #500000;

        // 10번 반복
        for (i = 0; i < 11; i = i + 1) begin
            // 충분한 시간 대기 (패턴 출력 완료 예상)
            // 실제 시뮬레이션 시간에 따라 조정 필요
            #1500000; // 0.2초 대기 였던 것
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;
            #1500000;



            // 12개의 버튼을 순차적으로 누름
            press_button(1);
            press_button(1);
            press_button(1);
            press_button(5);
            press_button(7);
            press_button(8);
            press_button(4);
            press_button(2);
            press_button(1);
            press_button(5);
            press_button(7);
            press_button(8);
        end

        // 시뮬레이션 종료
        #100000;
    end

endmodule
