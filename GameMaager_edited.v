`timescale 1ns / 1ps

module GameManager(
    // input clk_1,
    input clk_2,    // 랜덤값 생성용
    // input clk_3,    // delay 생성용
    input botton_1, // 입력 버튼
    input botton_2,
    input botton_3,
    input botton_4,
    input botton_5,
    input botton_6,
    input botton_7,
    input botton_8,
    input [2:0] KEY_COL,
    input [3:0] KEY_ROW,
    /*
    input keypad_1,
    input keypad_2,
    input keypad_3,
    input keypad_0,
    */
    output led_1,
    output led_2,
    output led_3,
    output led_4,
    output led_5,
    output led_6,
    output led_7,
    output led_8,
    // output 7-seg 관련 요소들
    output [7:0] SEG_COM,
    output [7:0] SEG_DATA
    // output [3:0] error_code
);
ClK_initialize ClK_initialize(
    .clk_in(clk_2),      // 1MHz 입력 클록
    .clk_1kHz(clk_1),    // 1kHz 출력 클록
    .clk_10Hz(clk_3)     // 10Hz 출력 클록
    );
    // 키패드 신호 할당
    wire keypad_1, keypad_2, keypad_3, keypad_0;
    assign keypad_1 = KEY_COL[0] & KEY_ROW[0];
    assign keypad_2 = KEY_COL[1] & KEY_ROW[0];
    assign keypad_3 = KEY_COL[2] & KEY_ROW[0];
    assign keypad_0 = KEY_COL[1] & KEY_ROW[3];
    
    // 레벨 선택 모듈 인스턴스화
    wire [2:0] level;
    wire rst, level_select_end;
    level_select level_select_inst (
        .clk(clk_1),
        .keypad_1(keypad_1),
        .keypad_2(keypad_2),
        .keypad_3(keypad_3),
        .keypad_0(keypad_0),
        .level(level),
        .rst(rst),
        .end_signal(level_select_end)
    );
    
    // 패턴 레벨 활성화
    reg [15:0] pattern_lv_enable;
    always @(posedge clk_1 or negedge rst) begin
        if (!rst)
            pattern_lv_enable <= 16'b0000000000000000;
        else
            // 필요한 조건에 따라 업데이트
            ;
    end
    
    // 라운드 카운트 및 정답 카운트 초기화
    reg [4:0] round_count;
    reg [3:0] answer_count;
    always @(posedge clk_1 or negedge rst) begin
        if (!rst) begin
            round_count <= 5'b00000;
            answer_count <= 4'b0000;
        end
        else
            // 필요한 조건에 따라 업데이트
            ;
    end
    
    // 게임 종료 신호
    wire game_end;
    assign game_end = (round_count > 9);
    
    // lpge 및 lrst 신호
    reg lpge;
    reg lrst;
    always @(posedge clk_1 or negedge rst) begin
        if (!rst) begin
            lpge <= 0;
            lrst <= 1'b0;
        end
        else if (keypad_0) begin
            lpge <= 1;
            lrst <= 1'b1;
        end
        else
            ;
    end
    
    // 패턴 생성 모듈 인스턴스화
    wire [2:0] pattern_1, pattern_2, pattern_3, pattern_4, pattern_5, pattern_6, pattern_7, pattern_8;
    wire [2:0] pattern_9, pattern_10, pattern_11, pattern_12, pattern_13, pattern_14, pattern_15, pattern_16;
    wire pattern_gen_end;
    pattern_generator pattern_gen_inst (
        .clk_1(clk_1),
        .clk_2(clk_2),
        .rst(rst & lrst),
        .enable(level_select_end & lpge), 
        .keypad_0(keypad_0),
        .lv_sel(keypad_1 | keypad_2 | keypad_3),
        .pattern_1(pattern_1),
        .pattern_2(pattern_2),
        .pattern_3(pattern_3),
        .pattern_4(pattern_4),
        .pattern_5(pattern_5),
        .pattern_6(pattern_6),
        .pattern_7(pattern_7),
        .pattern_8(pattern_8),
        .pattern_9(pattern_9),
        .pattern_10(pattern_10),
        .pattern_11(pattern_11),
        .pattern_12(pattern_12),
        .pattern_13(pattern_13),
        .pattern_14(pattern_14),
        .pattern_15(pattern_15),
        .pattern_16(pattern_16),
        .pattern_gen_end(pattern_gen_end)
    );
    
    // 패턴 출력 모듈 인스턴스화
    wire print_pattern_end;
    print_pattern print_pattern_inst (
        .clk_1(clk_1),
        .clk_3(clk_3),
        .rst(rst & lrst),
        .enable(pattern_gen_end),
        .level(level),
        .pattern_1(pattern_1),
        .pattern_2(pattern_2),
        .pattern_3(pattern_3),
        .pattern_4(pattern_4),
        .pattern_5(pattern_5),
        .pattern_6(pattern_6),
        .pattern_7(pattern_7),
        .pattern_8(pattern_8),
        .pattern_9(pattern_9),
        .pattern_10(pattern_10),
        .pattern_11(pattern_11),
        .pattern_12(pattern_12),
        .pattern_13(pattern_13),
        .pattern_14(pattern_14),
        .pattern_15(pattern_15),
        .pattern_16(pattern_16),
        .led_1(led_1),
        .led_2(led_2),
        .led_3(led_3),
        .led_4(led_4),
        .led_5(led_5),
        .led_6(led_6),
        .led_7(led_7),
        .led_8(led_8),
        .print_pattern_end(print_pattern_end)
    );
    
    // 입력 트림 모듈 인스턴스화
    wire [2:0] trimmed_inp_1, trimmed_inp_2, trimmed_inp_3, trimmed_inp_4, trimmed_inp_5;
    wire [2:0] trimmed_inp_6, trimmed_inp_7, trimmed_inp_8, trimmed_inp_9, trimmed_inp_10, trimmed_inp_11; 
    wire [2:0] trimmed_inp_12, trimmed_inp_13, trimmed_inp_14, trimmed_inp_15, trimmed_inp_16;
    wire input_trim_end;
    input_trim input_trim_inst (
        .clk(clk_1),
        .rst(rst & lrst),
        .enable(print_pattern_end),
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
        .end_signal(input_trim_end)
    );
    
    // 라운드 승리 조건
    wire round_win; 
    assign round_win =  ((pattern_1 & {3{pattern_lv_enable[0]}}) == trimmed_inp_1) &
                        ((pattern_2 & {3{pattern_lv_enable[1]}}) == trimmed_inp_2) &
                        ((pattern_3 & {3{pattern_lv_enable[2]}}) == trimmed_inp_3) &
                        ((pattern_4 & {3{pattern_lv_enable[3]}}) == trimmed_inp_4) &
                        ((pattern_5 & {3{pattern_lv_enable[4]}}) == trimmed_inp_5) &
                        ((pattern_6 & {3{pattern_lv_enable[5]}}) == trimmed_inp_6) &
                        ((pattern_7 & {3{pattern_lv_enable[6]}}) == trimmed_inp_7) &
                        ((pattern_8 & {3{pattern_lv_enable[7]}}) == trimmed_inp_8) &
                        ((pattern_9 & {3{pattern_lv_enable[8]}}) == trimmed_inp_9) &
                        ((pattern_10 & {3{pattern_lv_enable[9]}}) == trimmed_inp_10) &
                        ((pattern_11 & {3{pattern_lv_enable[10]}}) == trimmed_inp_11) &
                        ((pattern_12 & {3{pattern_lv_enable[11]}}) == trimmed_inp_12) &
                        ((pattern_13 & {3{pattern_lv_enable[12]}}) == trimmed_inp_13) &
                        ((pattern_14 & {3{pattern_lv_enable[13]}}) == trimmed_inp_14) &
                        ((pattern_15 & {3{pattern_lv_enable[14]}}) == trimmed_inp_15) &
                        ((pattern_16 & {3{pattern_lv_enable[15]}}) == trimmed_inp_16);
    
    // 패턴 레벨 활성화 업데이트
    always @(posedge clk_1 or negedge rst) begin
        if (!rst)
            pattern_lv_enable <= 16'b0000000000000000;
        else if (pattern_gen_end) begin
            case (level)
                3'b001: pattern_lv_enable <= 16'b0000000011111111;
                3'b010: pattern_lv_enable <= 16'b0000111111111111;
                3'b100: pattern_lv_enable <= 16'b1111111111111111;
                default: pattern_lv_enable <= 16'b0000000000000000;
            endcase
        end
    end
    
    // 지연 카운트
    reg [1:0] delay;
    always @(posedge clk_1 or negedge rst) begin
        if (!rst)
            delay <= 2'b00;
        else if (input_trim_end) begin
            if (delay == 2'b10) begin
                round_count <= round_count + 1;
                answer_count <= answer_count + round_win;
                delay <= delay + 1;
            end
            else if (delay != 2'b11)
                delay <= delay + 1;
        end
    end
    
    // 패턴 생성 지연 카운트
    reg [1:0] delay_pge;
    always @(posedge clk_1 or negedge rst) begin
        if (!rst)
            delay_pge <= 2'b00;
        else if (input_trim_end)
            delay_pge <= 2'b00;
        else if (lrst) begin
            lpge <= 0;
            delay_pge <= 2'b01;
        end
        else if (delay_pge != 2'b00 && delay_pge != 2'b11)
            delay_pge <= delay_pge + 1;
        else if (delay_pge == 2'b11)
            lpge <= 1'b1;
    end
    
    // lrst 지연 카운트
    reg [1:0] delay_lrst;
    always @(posedge clk_1 or negedge rst) begin
        if (!rst)
            delay_lrst <= 2'b00;
        else if (input_trim_end) begin
            if (delay_lrst != 2'b11)
                delay_lrst <= delay_lrst + 1;
            else
                lrst <= 1'b1;
        end
    end
    
    // 활성화된 lrst 신호
    reg activate_lrst;
    always @(posedge clk_1 or negedge rst) begin
        if (!rst)
            activate_lrst <= 0;
        else if (activate_lrst & (!game_end)) begin
            lrst <= 1'b0;
            activate_lrst <= 1'b0;
        end
    end
    
    // 점수 레지스터
    reg [6:0] score;
    always @(posedge clk_1 or negedge rst) begin
        if (!rst)
            score <= 0;
        else if (game_end)
            score <= 10 * answer_count;
    end
    
    // 점수 출력 모듈 인스턴스화
    print_score_7seg print_score_inst (
        .score(score),  
        .clk(clk_1),          
        .nRST(rst),           
        .SEG_COM(SEG_COM),
        .SEG_DATA(SEG_DATA)
    );
    
    // 추가 로직 및 주석
    // ... (생략)
    
endmodule
