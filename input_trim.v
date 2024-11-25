module input_trim(
    input clk,
    input rst,
    input enable,
    input botton_1, // 입력 버튼
    input botton_2,
    input botton_3,
    input botton_4,
    input botton_5,
    input botton_6,
    input botton_7,
    input botton_8,
    output [2:0] trimed_inp [15:0] // (누른 버튼 index) X (개수) ---- 현재 최대 개수: 16개
    // 난이도 선택 모듈에서 정해진 개수만큼만 뽑아가고 나머지는 초기화 하는 방식으로 모듈 설계 예정 
)
    // 버튼이 '눌렸을 때' 값을 저장. 눌려있거나 안눌려 있을 때에는 무시
    reg b1, b2, b3, b4, b5, b6, b7, b8;
    integer i;
    always @(posedge botton_1)


    // botton 1 ~ 8의 신호가 아무것도 없다면 작동X. OR(1 ~ 8)일 때 값 저장 load 신호 출력


    // load 신호(load & enable)가 들어왔을 때 최종 output에 데이터 저장 후 i++


endmodule