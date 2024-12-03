module clk_divider(
    input clk,          // 입력 클럭
    input rst,        // 리셋 신호
    output Tx2, Tx4, Tx8, Tx16, Tx32      // 4비트 출력으로 각 비트가 다른 주파수를 가짐
);

    reg [4:0] T;
    // 카운터 로직
    always @(posedge clk or negedge rst) begin    // enable을 rst신호로 이용하기 때문에 posedge사용
        if (!rst) begin
            T <= 4'b0000;    // 리셋 시 카운터 초기화
        end else begin
            T <= T + 1;      // 입력 클럭 상승 에지에서 카운터 증가
        end
    end

    // T를 clk 주기마다 1씩 증가시키면
    // T의 각 자리수는 입력 clk 주파수의 1/2, 1/4, 1/8, 1/16, 1/32의 주파수를 가짐
    assign Tx2 = T[0];
    assign Tx4 = T[1];
    assign Tx8 = T[2];
    assign Tx16 = T[3];
    assign Tx32 = T[4];

endmodule
