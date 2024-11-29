module counter(
    input clk,
    input keypad_0,
    output reg [19:0] count
);
    always @(posedge clk or posedge keypad_0) begin
        if (keypad_0) count <= 0;
        else count <= count + 20'b11001001101001001111; // 8과 서로소인 수
    end
endmodule

module random_number(
    input clk_2,
    input keypad_0,
    input inp,  // level select signal
    output reg [19:0] random_num
);
    wire [19:0] count;
    counter counter(
        .clk(clk_2),
        .keypad_0(keypad_0),
        .count(count)
    );
    always @(posedge inp) begin // 레벨을 입력할 때 측정되는 counter 값으로 랜덤한 값 추출
        random_num <= count;
    end
endmodule

