module GameManager(
    input clk_2,    // 랜덤값 생성용
    input botton_1, // 입력 버튼
    input botton_2,
    input botton_3,
    input botton_4,
    input botton_5,
    input botton_6,
    input botton_7,
    input botton_8,

    input dip1,
    input dip2,
    input dip3,
    input dip_rst,
    input dip_clk,

    output led_1,
    output led_2,
    output led_3,
    output led_4,
    output led_5,
    output led_6,
    output led_7,
    output led_8,
    output [7:0] SEG_COM,
    output [7:0] SEG_DATA
    // output [3:0] error_code
);
    // 전체 모듈 통합하고 게임의 주축이 되는 모듈.
    // 다른 모듈들을 이용해 이 모듈에서 전체 게임 설계.
    

    wire clk_1, clk_3;
    ClK_initialize ClK_initialize(
        .clk_in(clk_2),      // 1MHz 입력 클록
        .rst(dip_clk),
        .clk_1kHz(clk_1),    // 1kHz 출력 클록
        .clk_10Hz(clk_3)     // 10Hz 출력 클록
        );

    
    wire keypad_1, keypad_2, keypad_3;
    assign keypad_1 = dip1;
    assign keypad_2 = dip2;
    assign keypad_3 = dip3;
    
    // level_select 모듈로 시작 -> 유효값이 입력 되었을 때 다른 모듈에 enable 신호 넣어줌
    wire [2:0] level;
    wire rst, level_select_end;
    level_select level_select(
        .clk(clk_1),
        .keypad_1(keypad_1),
        .keypad_2(keypad_2),
        .keypad_3(keypad_3),
        .keypad_0(dip_rst),
        // .error_code(error_code),
        .level(level),
        .rst(rst),
        .end_signal(level_select_end)   // 1값 유지
    );
    // level 1: 001, level 2: 010, level 3: 100, not_valid: 000,  

    reg [15:0] pattern_lv_enable;

    wire pattern_gen_end;
    always @(posedge clk_1 or negedge rst) begin
        if (!rst) pattern_lv_enable <=16'b0000000000000000;
        else if (pattern_gen_end)
            case (level)
                3'b001: pattern_lv_enable <= 16'b0000000011111111;
                3'b010: pattern_lv_enable <= 16'b0000111111111111;
                3'b100: pattern_lv_enable <= 16'b1111111111111111;
            endcase
    end

    reg [4:0] round_count;
    reg [3:0] answer_count;

    wire game_end;
    assign game_end = (round_count > 9);


    reg lpge;
    reg lrst;   // loop를 초기화할 신호


    wire update_pattern;
    wire input_trim_end;
    assign update_pattern = input_trim_end;
    wire lv_sel;
    assign lv_sel = keypad_1 | keypad_2 | keypad_3;
    wire [2:0] pattern_1, pattern_2, pattern_3, pattern_4, pattern_5, pattern_6, pattern_7, pattern_8;
    wire [2:0] pattern_9, pattern_10, pattern_11, pattern_12, pattern_13, pattern_14, pattern_15, pattern_16;

    pattern_generator pattern_generator(
        .clk_1(clk_1),
        .clk_2(clk_2),
        .rst(rst & lrst),
        .enable(level_select_end & lpge), 
        .keypad_0(dip_rst),
        .lv_sel(lv_sel | update_pattern),
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
        .pattern_gen_end(pattern_gen_end)   // rst신호때 0됐다가 데이터 업데이트 될 때 1
    );

    wire print_pattern_end;
    print_pattern print_pattern(
        .clk_1(clk_1),
        .clk_3(clk_3),
        .rst(rst & lrst),
        .enable(pattern_gen_end & (!game_end)),
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

    wire [2:0] trimmed_inp_1, trimmed_inp_2, trimmed_inp_3, trimmed_inp_4, trimmed_inp_5;
    wire [2:0] trimmed_inp_6, trimmed_inp_7, trimmed_inp_8, trimmed_inp_9, trimmed_inp_10, trimmed_inp_11; 
    wire [2:0] trimmed_inp_12, trimmed_inp_13, trimmed_inp_14, trimmed_inp_15, trimmed_inp_16;
    input_trim input_trim(
        .clk(clk_1),                  // 빠른 clk 사용
        .rst(rst & lrst),
        .enable(print_pattern_end),
        .level(level),
        .botton_1(botton_1),        // 입력 버튼
        .botton_2(botton_2),
        .botton_3(botton_3),
        .botton_4(botton_4),
        .botton_5(botton_5),
        .botton_6(botton_6),
        .botton_7(botton_7),
        .botton_8(botton_8),
        .trimmed_inp_1(trimmed_inp_1),  // (누른 버튼 index) X (개수)
        .trimmed_inp_2(trimmed_inp_2),  // 내부 값은 0~7이지만 실제 인덱스는 이 값에 1을 더한 값임
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
        .end_signal(input_trim_end) //끝나면 계속 유지
    );
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

// 여기서부터 수정 시작, hotfix_1에서 lrst부분 수정 후 다시 돌려보기 
    

    reg [1:0] delay;
    always @(posedge clk_1 or negedge rst or negedge lrst) begin    // trim끝났을 때 round 세기, delay:2
        if (!rst) begin
            round_count <= 5'b00000;
            answer_count <= 4'b0000;
            delay <= 2'b00;
        end else if (!lrst) delay <= 2'b00;
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


    reg [1:0] delay_pge;            // lrst 이후 작동, 계속 1이다가 lrst 신호 들어오고 잠시뒤에 잠깐 0됨.
    reg inp_trim_end_enable;
    reg [2:0] pre_delay;
    ///////////////////////////////////////////////
    ////////////////////////////////////////////////
    
    always @(posedge clk_1 or negedge rst or negedge lrst or posedge dip_rst) begin
    if (dip_rst) begin
        // dip_rst가 활성화되면, lrst와 lpge를 초기화
        lrst <= 1'b1;
        lpge <= 1'b1;
        
        // 기타 신호들도 필요하다면 초기화
        delay_pge <= 2'b00;
        inp_trim_end_enable <= 1'b1;
        pre_delay <= 3'b000;
    end
    else if (!rst) begin
        // rst가 비활성화되면, delay_pge를 설정하고 다른 신호 초기화
        delay_pge <= 2'b11;
        inp_trim_end_enable <= 1'b1;
        pre_delay <= 3'b000;
    end
    else if (!lrst) begin
        // lrst가 비활성화되면, delay_pge를 초기화하고 다른 신호도 초기화
        delay_pge <= 2'b00;
        lrst <= 1'b1;
        inp_trim_end_enable <= 1'b1;
        pre_delay <= 3'b000;
    end
    else begin
        // delay_pge 및 lpge 제어 로직
        if (delay_pge == 2'b10) begin
            lpge <= 1'b0;
            delay_pge <= delay_pge + 1;
        end
        else if (delay_pge != 2'b11) begin
            delay_pge <= delay_pge + 1;
        end
        else if (delay_pge == 2'b11) begin
            lpge <= 1'b1;
        end

        // inp_trim_end_enable 및 pre_delay 제어 로직
        if (input_trim_end & inp_trim_end_enable) begin
            if (pre_delay[2]) begin
                lrst <= 1'b0;
                inp_trim_end_enable <= 1'b0;
            end
            else begin
                pre_delay <= pre_delay + 1;
            end
        end
    end
end



    reg [6:0] score;
    always @(posedge clk_1 or posedge dip_rst) begin
        if (dip_rst) score <= 0;
        else score <= 10 * answer_count;
    end

    print_score_7seg print_score_7seg(
        .CLK(clk_1),
	    .a(score),
	    .N_Reset(dip_rst),
	    .SEG_COM(SEG_COM), 
        .SEG_DATA(SEG_DATA)
    );

endmodule