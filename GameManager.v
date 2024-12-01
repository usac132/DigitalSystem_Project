module GameManager(
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
    input keypad_1,
    input keypad_2,
    input keypad_3,
    input keypad_0,
    output led_1,
    output led_2,
    output led_3,
    output led_4,
    output led_5,
    output led_6,
    output led_7,
    output led_8,
    // output 7-seg 관련 요소들
    // output [3:0] error_code
);
    // 전체 모듈 통합하고 게임의 주축이 되는 모듈.
    // 다른 모듈들을 이용해 이 모듈에서 전체 게임 설계.

    // level_select 모듈로 시작 -> 유효값이 입력 되었을 때 다른 모듈에 enable 신호 넣어줌
    wire [2:0] level;
    wire rst, level_select_end;
    level_select level_select(
        .clk(clk),
        .keypad_1(keypad_1),
        .keypad_2(keypad_2),
        .keypad_3(keypad_3),
        .keypad_0(keypad_0),
        // .error_code(error_code),
        .level(level),
        .rst(rst),
        .end_signal(level_select_end)
    );
    // level 1: 001, level 2: 010, level 3: 100, not_valid: 000,  

    wire lv_sel;
    assign lv_sel = keypad_1 | keypad_2 | keypad_3;
    wire [2:0] pattern_1, pattern_2, pattern_3, pattern_4, pattern_5, pattern_6, pattern_7, pattern_8;
    wire [2:0] pattern_9, pattern_10, pattern_11, pattern_12, pattern_13, pattern_14, pattern_15, pattern_16;
    wire pattern_gen_end;
    pattern_generator pattern_generator(
        .clk_1(clk_1),
        .clk_2(clk_2),
        .rst(rst),
        .enable(level_select_end),
        .keypad_0(keypad_0),
        .lv_sel(lv_sel),
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

    wire print_pattern_end;
    print_pattern print_pattern(
        .clk_1(clk_1),
        .clk_3(clk_3),
        .rst(rst),
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
    wire input_trim_end;
    input_trim input_trim(
        .clk(clk),                  // 빠른 clk 사용
        .rst(rst),
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
        .end_signal(input_trim_end)
    );

    // 모듈 앞에 mux 붙이기 -> 같은 모듈 반복해서 사용. rst대신에 loop끝나는 신호 같이 넣어서 초기화 시켜서 반복
    // loop_num 을 증가시키다가 10이상이 되면 반복 중지하고 score 출력




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