module pattern_generator (
    input clk,
    input clk_time, // 랜덤 패턴 만들 경우에 필요할듯. FPGA에 구현가능한지 여부 판단후 유지/삭제 예정
    input rst,
    input enable,
    // output [3:0] pattern [15:0] //최대 16개. 난이도에 따라 GM에서 n개 추출하여 사용. 따라서 여기서 level에 맞춰 생성할 필요는 없음.
);

// 인게임 패턴 생성하는 모듈
// 랜덤 패턴 만드는 것이 목표이기는 하나 난이도에 따라 수정될 수 있음

endmodule