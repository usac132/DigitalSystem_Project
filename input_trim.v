module input_trim(
    input clk,  //빠른 clk사용
    input rst,
    input enable,
    input [2:0] level,
    input botton_1, // 입력 버튼
    input botton_2,
    input botton_3,
    input botton_4,
    input botton_5,
    input botton_6,
    input botton_7,
    input botton_8,
    output reg [2:0] trimmed_inp_1, // (누른 버튼 index) X (개수) ---- 현재 최대 개수: 16개
    output reg [2:0] trimmed_inp_2, // 내부 값은 0~7이지만 실제 인덱스는 이 값에 1을 더한 값임
    output reg [2:0] trimmed_inp_3,
    output reg [2:0] trimmed_inp_4,
    output reg [2:0] trimmed_inp_5,
    output reg [2:0] trimmed_inp_6,
    output reg [2:0] trimmed_inp_7,
    output reg [2:0] trimmed_inp_8,
    output reg [2:0] trimmed_inp_9,
    output reg [2:0] trimmed_inp_10,
    output reg [2:0] trimmed_inp_11,
    output reg [2:0] trimmed_inp_12,
    output reg [2:0] trimmed_inp_13,
    output reg [2:0] trimmed_inp_14,
    output reg [2:0] trimmed_inp_15,
    output reg [2:0] trimmed_inp_16,
    output reg end_signal
    // output reg [3:0] error_code
    // 난이도 선택 모듈에서 정해진 개수만큼만 뽑아가고 나머지는 초기화 하는 방식으로 모듈 설계 예정 
);
    // 버튼이 '눌렸을 때' 값을 저장. 눌려있거나 안눌려 있을 때에는 무시
    reg b1, b2, b3, b4, b5, b6, b7, b8;
    reg [4:0] i; // 입력 개수
    wire [3:0] max; // level에 따른 최대 입력 개수
    assign max = 3 + 12 * level[2] + 8 * level[1]  + 4 * level[0]; // level은 1,2,3만 있음.


    always @(posedge botton_1) b1 <= 1'b1;
    always @(posedge botton_2) b2 <= 1'b1;
    always @(posedge botton_3) b3 <= 1'b1;
    always @(posedge botton_4) b4 <= 1'b1;
    always @(posedge botton_5) b5 <= 1'b1;
    always @(posedge botton_6) b6 <= 1'b1;
    always @(posedge botton_7) b7 <= 1'b1;
    always @(posedge botton_8) b8 <= 1'b1;

    // 유효성 검사
    // 2개 이상의 값에 대해서는 입력되지 않음.
    // botton 1 ~ 8의 신호가 아무것도 없다면 작동X. OR(1 ~ 8)일 때 값 저장 load 신호(verify) 출력
    wire verify, inp_on_signal, not_multi_inp;
    assign inp_on_signal = b1|b2|b3|b4|b5|b6|b7|b8;
    assign not_multi_inp = (b1+b2+b3+b4+b5+b6+b7+b8 < 2);
    assign verify = enable & inp_on_signal & not_multi_inp & (~end_signal);

    // encoder
    reg [2:0] tmp_trim;
    reg load;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin //initialize
            tmp_trim <= 3'b000;
            load <= 1'b0;
            trimmed_inp_1  <= 3'b000;
            trimmed_inp_2  <= 3'b000;
            trimmed_inp_3  <= 3'b000;
            trimmed_inp_4  <= 3'b000;
            trimmed_inp_5  <= 3'b000;
            trimmed_inp_6  <= 3'b000;
            trimmed_inp_7  <= 3'b000;
            trimmed_inp_8  <= 3'b000;
            trimmed_inp_9  <= 3'b000;
            trimmed_inp_10 <= 3'b000;
            trimmed_inp_11 <= 3'b000;
            trimmed_inp_12 <= 3'b000;
            trimmed_inp_13 <= 3'b000;
            trimmed_inp_14 <= 3'b000;
            trimmed_inp_15 <= 3'b000;
            trimmed_inp_16 <= 3'b000;
            b1 <= 1'b0;
            b2 <= 1'b0;
            b3 <= 1'b0;
            b4 <= 1'b0;
            b5 <= 1'b0;
            b6 <= 1'b0;
            b7 <= 1'b0;
            b8 <= 1'b0;
            i <= 5'b00000;
            end_signal <= 1'b0;
            // error_code <= 4'b0000;
        end else begin
            if (verify) begin   //encoder
                case({b1, b2, b3, b4, b5, b6, b7, b8})
                    8'b00000001: begin 
                        tmp_trim <= 7; 
                        b8 <= 0; 
                    end
                    8'b00000010: begin 
                        tmp_trim <= 6; 
                        b7 <= 0; 
                    end
                    8'b00000100: begin 
                        tmp_trim <= 5; 
                        b6 <= 0; 
                    end
                    8'b00001000: begin 
                        tmp_trim <= 4; 
                        b5 <= 0; 
                    end
                    8'b00010000: begin 
                        tmp_trim <= 3; 
                        b4 <= 0; 
                    end
                    8'b00100000: begin 
                        tmp_trim <= 2; 
                        b3 <= 0; 
                    end
                    8'b01000000: begin 
                        tmp_trim <= 1; 
                        b2 <= 0; 
                    end
                    8'b10000000: begin 
                        tmp_trim <= 0; 
                        b1 <= 0; 
                    end
                    // default: error_code <= 4'b0001;     // error_code 0001
                endcase
                if (i <= max) begin
                    i <= i + 1;
                    load <= 1;
                end
            end else begin
                {b1, b2, b3, b4, b5, b6, b7, b8} <= 8'b00000000;
                load <= 0;
            end

            if (i > max) begin
                end_signal <= 1;
            end

            if (load) begin
                case (i-1)  //i값 업데이트 이전값 인덱스로 넣어야함
                    4'b0000: trimmed_inp_1  <= tmp_trim;
                    4'b0001: trimmed_inp_2  <= tmp_trim;
                    4'b0010: trimmed_inp_3  <= tmp_trim;
                    4'b0011: trimmed_inp_4  <= tmp_trim;
                    4'b0100: trimmed_inp_5  <= tmp_trim;
                    4'b0101: trimmed_inp_6  <= tmp_trim;
                    4'b0110: trimmed_inp_7  <= tmp_trim;
                    4'b0111: trimmed_inp_8  <= tmp_trim;
                    4'b1000: trimmed_inp_9  <= tmp_trim;
                    4'b1001: trimmed_inp_10 <= tmp_trim;
                    4'b1010: trimmed_inp_11 <= tmp_trim;
                    4'b1011: trimmed_inp_12 <= tmp_trim;
                    4'b1100: trimmed_inp_13 <= tmp_trim;
                    4'b1101: trimmed_inp_14 <= tmp_trim;
                    4'b1110: trimmed_inp_15 <= tmp_trim;
                    4'b1111: trimmed_inp_16 <= tmp_trim;
                    // default: error_code <= 4'b0010;
                endcase
            end
        end
    end

    // load 신호(load & enable)가 들어왔을 때 최종 output에 데이터 저장 후 i++


endmodule