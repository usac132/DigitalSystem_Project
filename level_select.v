module level_select(
    input clk,
    input keypad_1,
    input keypad_2,
    input keypad_3,
    input keypad_0,
    // output [3:0] error_code,
    output reg [2:0] level,
    output reg rst,
    output reg end_signal
);
    reg k1, k2, k3;
    always @(posedge keypad_1) k1 <= 1'b1;
    always @(posedge keypad_2) k2 <= 1'b1;
    always @(posedge keypad_3) k3 <= 1'b1;

    reg hold_rst = 1'b0;   // rst 신호가 너무 짧아지는 것을 방지하기 위한 신호 
    // rst 신호 생성 (1.xx * clk주기 길이만큼 rst 신호 출력)
    always @(posedge clk or posedge keypad_0) begin
        if (keypad_0) begin
            rst <= 1'b0;
            hold_rst <= 1'b1;
            end_signal <= 1'b0;
            level <= 3'b000;
        end else if (hold_rst) begin
            rst <= 1'b0;
            hold_rst <= 1'b0;
        end else begin
            rst <= 1'b1;
        end
    end

    wire verify, not_multi_inp, inp_on_signal;
    assign inp_on_signal = (k1 | k2 | k3);
    assign not_multi_inp = (k1 + k2 + k3 < 2);
    assign verify = inp_on_signal & not_multi_inp & (~end_signal);
    // level 변수에 level 정보 저장
    always @(posedge clk) begin
        if (verify) begin
            level <= {k3, k2, k1};
            end_signal <= 1'b1;
        end
        k3 <= 1'b0;
        k2 <= 1'b0;
        k1 <= 1'b0;
    end

endmodule
// level select가 작동하고 나서야 다른 module enable되게 할 예정(Game Manager에 구현)
// => rst 신호를 현 모듈에서 만듦

// 밑의 내용은 GameManager에서 구현 or input_trim에서 구현
// keypad 1: 난이도 하, 2: 중, 3: 상
// 난이도 하: speed x1, 개수 x8 
// 난이도 중: speed x2, 개수 x12
// 난이도 상: speed x4, 개수 x16

// 난이도 하/중/상 각각 만들고 MUX로 값(속도, 개수)
