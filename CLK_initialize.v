module ClK_initialize(
    input wire clk_in,      // 1MHz 입력 클록
    input wire rst,    // keypad_0 신호 (posedge에서 리셋)
    output reg clk_1kHz,    // 1kHz 출력 클록
    output reg clk_10Hz     // 10Hz 출력 클록
    );

    // 1kHz 클록을 위한 카운터 (0 ~ 499)
    reg [8:0] count1; // 9비트 카운터

    // 10Hz 클록을 위한 카운터 (0 ~ 49999)
    reg [15:0] count2; // 16비트 카운터

    // 1kHz 클록 생성
    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count1 <= 0;
            clk_1kHz <= 0;
        end
        else if (count1 < 499) begin
            count1 <= count1 + 1;
        end 
        else begin
            count1 <= 0;
            clk_1kHz <= ~clk_1kHz;
        end
    end

    // 10Hz 클록 생성
    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count2 <= 0;
            clk_10Hz <= 0;
        end
        else if (count2 < 49999) begin
            count2 <= count2 + 1;
        end 
        else begin
            count2 <= 0;
            clk_10Hz <= ~clk_10Hz;
        end
    end

endmodule
