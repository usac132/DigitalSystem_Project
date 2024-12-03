`timescale 1ns/1ps

module print_score_7seg (
    input [6:0] score,       // 7-bit 점수 입력 (10, 20, ..., 100)
    input clk,               // 7-segment 갱신용 클럭
    input nRST,              // 리셋 신호 (Active Low)
    output [7:0] SEG_COM,    // 7-segment COM 핀
    output [7:0] SEG_DATA    // 7-segment DATA 핀
);

  
    wire [3:0] hundreds;     // 백의 자리 (1 또는 0)
    wire [3:0] tens;         // 십의 자리 (BCD로 출력)
    wire [3:0] units;        // 일의 자리 (항상 0)


    wire [6:0] seg_hundreds; // 백의 자리 7-segment 데이터
    wire [6:0] seg_tens;     // 십의 자리 7-segment 데이터
    wire [6:0] seg_units;    // 일의 자리 7-segment 데이터

    assign hundreds = (score == 100) ? 4'd1 : 4'd0; // 백의 자리는 100일 때만 1, 나머지는 0
    assign tens = (score / 10) % 10;                       // 십의 자리는 score[6:4] 비트로 표현
    assign units = 4'd0;                             // 일의 자리는 항상 0

  
    BCD_to_7segment hundreds_decoder (
        .T3(hundreds[3]), .T2(hundreds[2]), .T1(hundreds[1]), .T0(hundreds[0]),
        .A1(seg_hundreds[6]), .B1(seg_hundreds[5]), .C1(seg_hundreds[4]),
        .D1(seg_hundreds[3]), .E1(seg_hundreds[2]), .F1(seg_hundreds[1]),
        .G1(seg_hundreds[0])
    );

    BCD_to_7segment tens_decoder (
        .T3(tens[3]), .T2(tens[2]), .T1(tens[1]), .T0(tens[0]),
        .A1(seg_tens[6]), .B1(seg_tens[5]), .C1(seg_tens[4]),
        .D1(seg_tens[3]), .E1(seg_tens[2]), .F1(seg_tens[1]),
        .G1(seg_tens[0])
    );

    // 일의 자리는 항상 0으로 고정된 7-segment 데이터
    assign seg_units = 7'b1111110; // 숫자 "0"의 7-segment 데이터

    assign SEG_COM = 8'00011111; 
    assign SEG_DATA = {}

    // 7-segment 컨트롤러
    SevenSeg_CTRL seven_seg_ctrl (
        .iSEG7(8'b0), .iSEG6(8'b0), .iSEG5(8'b0), .iSEG4(8'b0), // 미사용
        .iSEG3({seg_hundreds, 1'b0}),  // 백의 자리
        .iSEG2({seg_tens, 1'b0}),      // 십의 자리
        .iSEG1({seg_units, 1'b0}),     // 일의 자리
        .iSEG0(8'b0),                  // 미사용
        .oS_COM(SEG_COM),
        .oS_ENS(SEG_DATA)
    );

endmodule
