module pattern_generator (
    input clk_1,
    input clk_2,
    input rst,
    input enable,
    input keypad_0,
    input lv_sel,
    output reg [2:0] pattern_1,
    output reg [2:0] pattern_2,
    output reg [2:0] pattern_3,
    output reg [2:0] pattern_4,
    output reg [2:0] pattern_5,
    output reg [2:0] pattern_6,
    output reg [2:0] pattern_7,
    output reg [2:0] pattern_8,
    output reg [2:0] pattern_9,
    output reg [2:0] pattern_10,
    output reg [2:0] pattern_11,
    output reg [2:0] pattern_12,
    output reg [2:0] pattern_13,
    output reg [2:0] pattern_14,
    output reg [2:0] pattern_15,
    output reg [2:0] pattern_16,
    output reg pattern_gen_end
    //최대 16개. 난이도에 따라 GM에서 n개 추출하여 사용. 따라서 여기서 level에 맞춰 생성할 필요는 없음.
);
    wire [19:0] random_num;
    random_number random_number(    // clk2로 발생하는 랜덤 숫자를 가져옴
        .clk_2(clk_2),
        .keypad_0(keypad_0),
        .inp(lv_sel),
        .random_num(random_num)
    );

    always @(posedge enable or negedge rst) begin
        if (!rst) pattern_gen_end <= 0;
        else if (enable) begin  // random number에서 1칸씩 옮기며 5비트 값 추출 후 mod 8 시행해서 패턴 생성
            pattern_1 <= random_num[4:0] % 8;
            pattern_2 <= random_num[5:1] % 8;
            pattern_3 <= random_num[6:2] % 8; 
            pattern_4 <= random_num[7:3] % 8;
            pattern_5 <= random_num[8:4] % 8;
            pattern_6 <= random_num[9:5] % 8;
            pattern_7 <= random_num[10:6] % 8; 
            pattern_8 <= random_num[11:7] % 8;
            pattern_9 <= random_num[12:8] % 8;
            pattern_10 <= random_num[13:9] % 8;
            pattern_11 <= random_num[14:10] % 8; 
            pattern_12 <= random_num[15:11] % 8;
            pattern_13 <= random_num[16:12] % 8;
            pattern_14 <= random_num[17:13] % 8;
            pattern_15 <= random_num[18:14] % 8; 
            pattern_16 <= random_num[19:15] % 8;
            pattern_gen_end <= 1;
        end
    end
// 인게임 패턴 생성하는 모듈
// 랜덤 패턴 만드는 것이 목표이기는 하나 난이도에 따라 수정될 수 있음

endmodule

