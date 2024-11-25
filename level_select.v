module level_select(
    input clk,
    input enable,
    input dip_switch_1,
    input dip_switch_2,
    input dip_switch_3,
    output 
)
// dip_switch 입력 유효성 검사

// level select가 작동하고 나서야 다른 module enable되게 할 예정(Game Manager에 구현)
// level select가 일종의 게임 시작화면 or 초기화 역할

// 해당 내용은 GameManager에서 구현
// dip 1: 난이도 하, 2: 중, 3: 상
// 난이도 하: speed x1, 개수 x8 
// 난이도 중: speed x2, 개수 x12
// 난이도 상: speed x4, 개수 x16

// 난이도 하/중/상 각각 만들고 MUX로 값(속도, 개수)

endmodule