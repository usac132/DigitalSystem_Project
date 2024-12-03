module print_pattern(
    input clk_1,    // 10 kHz 이상의 클럭 사용
    input clk_3,    // 10 Hz 클럭 사용
    input rst,
    input enable,
    input [2:0] level,
    input [2:0] pattern_1,
    input [2:0] pattern_2,
    input [2:0] pattern_3,
    input [2:0] pattern_4,
    input [2:0] pattern_5,
    input [2:0] pattern_6,
    input [2:0] pattern_7,
    input [2:0] pattern_8,
    input [2:0] pattern_9,
    input [2:0] pattern_10,
    input [2:0] pattern_11,
    input [2:0] pattern_12,
    input [2:0] pattern_13,
    input [2:0] pattern_14,
    input [2:0] pattern_15,
    input [2:0] pattern_16,
    output reg led_1,
    output reg led_2,
    output reg led_3,
    output reg led_4,
    output reg led_5,
    output reg led_6,
    output reg led_7,
    output reg led_8,
    output reg print_pattern_end
);
    wire clk_x2, clk_x4, clk_x8, clk_x16, clk_x32;   // 반 주기: 0.1초, 0.2초, 0.4초, 0.8초, 1.6초
    clk_divider clk_divider(
        .clk(clk_3),
        .rst(enable),
        .Tx2(clk_x2),
        .Tx4(clk_x4),
        .Tx8(clk_x8),
        .Tx16(clk_x16),
        .Tx32(clk_x32)
    );
    
    wire [3:0] max;
    assign max = 3 + 12 * level[2] + 8 * level[1]  + 4 * level[0];

    wire clk;
    assign clk = ((clk_x8 & level[2]) | (clk_x16 & level[1]) | (clk_x32 & level[0])) & enable;
    reg [2:0] pattern [15:0];
    always @(posedge clk_1) begin
        if (enable) begin
            pattern[0] <= pattern_1;
            pattern[1] <= pattern_2;
            pattern[2] <= pattern_3;
            pattern[3] <= pattern_4;
            pattern[4] <= pattern_5;
            pattern[5] <= pattern_6;
            pattern[6] <= pattern_7;
            pattern[7] <= pattern_8;
            pattern[8] <= pattern_9;
            pattern[9] <= pattern_10;
            pattern[10] <= pattern_11;
            pattern[11] <= pattern_12;
            pattern[12] <= pattern_13;
            pattern[13] <= pattern_14;
            pattern[14] <= pattern_15;
            pattern[15] <= pattern_16;
        end
    end
    reg pulse;
    reg [4:0] i;
    reg [1:0] delay_enable;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin // 초기화
            pulse <= 0;
            i <= 4'b0000;
            pattern[0] <= 3'b000;
            pattern[1] <= 3'b000;
            pattern[2] <= 3'b000;
            pattern[3] <= 3'b000;
            pattern[4] <= 3'b000;
            pattern[5] <= 3'b000;
            pattern[6] <= 3'b000;
            pattern[7] <= 3'b000;
            pattern[8] <= 3'b000;
            pattern[9] <= 3'b000;
            pattern[10] <= 3'b000;
            pattern[11] <= 3'b000;
            pattern[12] <= 3'b000;
            pattern[13] <= 3'b000;
            pattern[14] <= 3'b000;
            pattern[15] <= 3'b000;
            led_1 <= 0;
            led_2 <= 0;
            led_3 <= 0;
            led_4 <= 0;
            led_5 <= 0;
            led_6 <= 0;
            led_7 <= 0;
            led_8 <= 0;
            delay_enable <= 2'b00;
            print_pattern_end <= 0;
        end else if ((delay_enable == 2'b11) & pulse & (i <= max)) begin    // led 신호가 출력
            case (pattern[i])
                3'b000: led_1 <= 1;
                3'b001: led_2 <= 1;
                3'b010: led_3 <= 1;
                3'b011: led_4 <= 1;
                3'b100: led_5 <= 1;
                3'b101: led_6 <= 1;
                3'b110: led_7 <= 1;
                3'b111: led_8 <= 1;
                // default: // error_code
            endcase
            pulse <= 0;
            i <= i + 1;
        end else if ((delay_enable == 2'b11) & (~pulse) & (i <= max)) begin     // led 신호 사이의 간격
            led_1 <= 0;
            led_2 <= 0;
            led_3 <= 0;
            led_4 <= 0;
            led_5 <= 0;
            led_6 <= 0;
            led_7 <= 0;
            led_8 <= 0;
            pulse <= 1;
        end else if ((delay_enable == 2'b11))begin  // 모든 패턴 출력 끝났을 때
            led_1 <= 0;
            led_2 <= 0;
            led_3 <= 0;
            led_4 <= 0;
            led_5 <= 0;
            led_6 <= 0;
            led_7 <= 0;
            led_8 <= 0;
            print_pattern_end <= 1;
        end else if ((delay_enable != 2'b11) & enable) delay_enable <= delay_enable + 1;
    end
endmodule