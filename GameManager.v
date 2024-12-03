module GameManagerX(
    input clk_1,
    input clk_2,    // 랜덤값 생성용
    input clk_3,    // delay 생성용
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
    // 전체 모듈 통합하고 게임의 주축이 되는 모듈.
    // 다른 모듈들을 이용해 이 모듈에서 전체 게임 설계.
    assign keypad_1 = KEY_COL[0] & KEY_ROW[0];
    assign keypad_2 = KEY_COL[1] & KEY_ROW[0];
    assign keypad_3 = KEY_COL[2] & KEY_ROW[0];
    assign keypad_0 = KEY_COL[1] & KEY_ROW[3];
    // level_select 모듈로 시작 -> 유효값이 입력 되었을 때 다른 모듈에 enable 신호 넣어줌
    wire [2:0] level;
    wire rst, level_select_end;
    level_select level_select(
        .clk(clk_1),
        .keypad_1(keypad_1),
        .keypad_2(keypad_2),
        .keypad_3(keypad_3),
        .keypad_0(keypad_0),
        // .error_code(error_code),
        .level(level),
        .rst(rst),
        .end_signal(level_select_end)   // 1값 유지
    );
    // level 1: 001, level 2: 010, level 3: 100, not_valid: 000,  

    reg [15:0] pattern_lv_enable;
    always @(negedge rst) pattern_lv_enable <=16'b0000000000000000;

    reg [4:0] round_count;
    reg [3:0] answer_count;
    always @(negedge rst) begin // round rst에 영향X only 전체 rst에서만 영향 받음
        round_count <= 5'b00000;
        answer_count <= 4'b0000;
    end

    wire game_end;
    assign game_end = (round_count > 9);
    reg lpge;
    always @(posedge keypad_0) lpge <= 1;
    reg lrst;   // loop를 초기화할 신호
    always @(posedge keypad_0) lrst <= 1'b1;

    wire update_pattern;
    wire input_trim_end;
    assign update_pattern = input_trim_end;
    wire lv_sel;
    assign lv_sel = keypad_1 | keypad_2 | keypad_3;
    wire [2:0] pattern_1, pattern_2, pattern_3, pattern_4, pattern_5, pattern_6, pattern_7, pattern_8;
    wire [2:0] pattern_9, pattern_10, pattern_11, pattern_12, pattern_13, pattern_14, pattern_15, pattern_16;
    wire pattern_gen_end;
    pattern_generator pattern_generator(
        .clk_1(clk_1),
        .clk_2(clk_2),
        .rst(rst & lrst),
        .enable(level_select_end & lpge), 
        .keypad_0(keypad_0),
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

    always @(posedge pattern_gen_end) begin
        case (level)
            3'b001: pattern_lv_enable <= 16'b0000000011111111;
            3'b010: pattern_lv_enable <= 16'b0000111111111111;
            3'b100: pattern_lv_enable <= 16'b1111111111111111;
        endcase
    end

    reg [1:0] delay;
    always @(negedge rst or posedge input_trim_end) begin   // 초기화 + loop 끝났을 때 초기화
        delay <= 2'b00;
    end


    reg [1:0] delay_pge;    // delay for pattern generate enable
    always @(negedge rst or posedge input_trim_end) delay_pge <= 2'b00;
    always @(posedge lrst) begin
        lpge <= 0;
        delay_pge <= 2'b01;
    end
    always @(posedge clk_1) begin
        if ((delay_pge != 2'b00) & (delay_pge != 2'b11) ) delay_pge <= delay_pge + 1;
        else if (delay_pge == 2'b11) lpge <= 1'b1; // 아래거 복사해서 delay 만듦
    end

    //  trimmed_input이 값이 업데이트 되게 하기 위해 딜레이를 줌
    reg [1:0] delay_lrst;
    always @(negedge rst or posedge input_trim_end) delay_lrst <= 2'b00;
    always @(posedge clk_1) begin   // 그냥 lrst를 일정시간 0으로 붙잡기 위한 부분
        if ((delay_lrst != 2'b00) & (delay_lrst != 2'b11) ) delay_lrst <= delay_lrst + 1;
        else if (delay_lrst == 2'b11) lrst <= 1'b1;     // 딜레이 후 lrst 정상화
    end

    reg activate_lrst;
    always @(negedge rst) activate_lrst <= 0;

    always @(posedge clk_1) begin
        if (activate_lrst & (!game_end)) begin
            lrst <= 1'b0;
            activate_lrst <= 1'b0;
        end
        if ((delay == 2'b10) & input_trim_end) begin
            round_count <= round_count + 1;
            answer_count <= answer_count + round_win;
            activate_lrst <= 1'b1;
            delay_lrst <= 2'b01;
            delay <= delay + 1;
        end
        else if ((delay != 2'b11) & input_trim_end) delay <= delay + 1;
    end

    reg [6:0] score;
    always @(posedge game_end or negedge rst) begin
        if (!rst) score <= 0;
        else score <= 10 * answer_count;
    end

    print_score_7seg print_score_7seg(
        .score(score),  
        .clk(clk_1),          
        .nRST(rst),           
        .SEG_COM(SEG_COM),
        .SEG_DATA(SEG_DATA)
);

    // n개의 값을 입력해야 한다고 할 때 n개의 값을 입력 했을 때 한 round가 끝나도록 설계.
    // round와 round 사이에 term을 주는 것도 구현 필요.
    // 혹시나 여유가 된다면 한 라운드에서 시간이 매우 길어지면 round가 끝나도록 설계하는 것도 구현.
    // 한 round가 끝나면 score을 업데이트, 패턴 재생성, round_count++, 
    // round를 count하는 wire를 만들어서 n round가 끝났을 때 score가 뜨고, 게임 종료시키기.
    // 시간 되면 재시작(rst)도 구현. 어차피 rst는 구현해야되서 이거는 구현까지 오래 걸리진 않을듯함.


    // 이건 아직 그냥 아이디어 단계인데 버튼을 눌렀을 때 해당 버튼의 index에 해당하는 led가 켜지게 할까 생각중. 
    // 이렇게 하면 게임성을 높일 뿐더러 LED가 나오는 중에 값을 입력하는 꼼수를 간접적으로 막을 수도 있지 않을까 싶지만? 
    // 어차피 이 꼼수는 따로 막을 체계가 필요하긴 할것같음. 이런 디테일한 부분들은 다 만들고 완성도 높일 대 고민해보는 걸로
    // -> 새로운 모듈 추가함(11/27): 시간 텀을 어떻게 만들어낼건지 아직 고민 필요
    // + Score를 입력 얼마나 빠르게 했는가 등을 이용해서 책정하는 방식도 가능 but 이건 난이도가 많이 높을듯. 확장가능성으로 남겨두는 것에 의의를..
    //

endmodule