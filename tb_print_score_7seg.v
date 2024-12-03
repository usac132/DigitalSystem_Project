`timescale 1ns/1ps

module tb_print_score_7seg;

    // 테스트 벤치 신호 선언
    reg [6:0] score;        // 점수 입력
    reg clk;                // 클럭 신호
    reg nRST;               // 리셋 신호 (Active Low)
    wire [7:0] SEG_COM;     // 7-segment COM 출력
    wire [7:0] SEG_DATA;    // 7-segment DATA 출력

    // 모듈 인스턴스
    print_score_7seg uut (
        .score(score),
        .clk(clk),
        .nRST(nRST),
        .SEG_COM(SEG_COM),
        .SEG_DATA(SEG_DATA)
    );

    // 클럭 생성
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns 주기 클럭
    end

    // 테스트 벤치 시뮬레이션
    initial begin
        // 초기화
        score = 7'd0; // 점수 초기화
        nRST = 1;     // 리셋 비활성화

        // 리셋 활성화 후 비활성화
        #50 nRST = 0; // 리셋 활성화
        #50 nRST = 1; // 리셋 비활성화

        // 다양한 점수 테스트
        #100 score = 7'd10;  // 10점
        #100 score = 7'd20;  // 20점
        #100 score = 7'd50;  // 50점
        #100 score = 7'd100; // 100점
        #100 score = 7'd0;   // 0점

        // 시뮬레이션 종료
        #200 $finish;
    end

endmodule
