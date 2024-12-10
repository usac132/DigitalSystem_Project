
module keypad (clk, rst, key_col, key_row, key_inp);
input clk, rst;
input [2:0] key_col;
output [3:0] key_row;

output [3:0] key_inp;

reg [3:0] key_inp;
reg [3:0] key_row;
reg [1:0] cnt_key;
reg [3:0] reg_key;

always @(posedge clk) 
    if (rst) cnt_key = 0;
    else cnt_key = cnt_key + 1;

always @(posedge clk)
    if (rst) key_row = 4'b0000;
    else 
        case (cnt_key)
            2'b00 : key_row = 4'b1000;
            2'b01 : key_row = 4'b0100;
            2'b10 : key_row = 4'b0010;
            2'b11 : key_row = 4'b0001;  
        endcase

always @(posedge clk)
    if (rst) reg_key = 4'hf; // nothing
    else
        case(key_row) 
            4'b1000:
                case(key_col)
                    3'b100 : reg_key = 4'h1;
                    3'b010 : reg_key = 4'h2;
                    3'b001 : reg_key = 4'h3;
                    default : reg_key = 4'hf;
                endcase
            4'b0100:
                case(key_col)
                    3'b100 : reg_key = 4'h4;
                    3'b010 : reg_key = 4'h5;
                    3'b001 : reg_key = 4'h6;
                    default : reg_key = 4'hf;
                endcase
            4'b0010:
                case(key_col)
                    3'b100 : reg_key = 4'h7;
                    3'b010 : reg_key = 4'h8;
                    3'b001 : reg_key = 4'h9;
                    default : reg_key = 4'hf;
                endcase
            4'b0001:
                case(key_col)
                    3'b100 : reg_key = 4'hb;
                    3'b010 : reg_key = 4'h0;
                    3'b001 : reg_key = 4'hd;
                    default : reg_key = 4'hf;
                endcase
        endcase

always @(posedge clk)
    if (rst) key_inp <= 4'd15;
    else  
        case(reg_key) 
            4'h0 : key_inp = 4'd0;
            4'h1 : key_inp = 4'd1;
            4'h2 : key_inp = 4'd2;
            4'h3 : key_inp = 4'd3;
            4'h4 : key_inp = 4'd4;
            4'h5 : key_inp = 4'd5;
            4'h6 : key_inp = 4'd6;
            4'h7 : key_inp = 4'd7;
            4'h8 : key_inp = 4'd8;
            4'h9 : key_inp = 4'd9;
            4'hc : key_inp = 4'd10; // *
            4'hd : key_inp = 4'd11; // #
            4'hf : key_inp = 4'd12;
        endcase
endmodule



module keypad_test(
    input [2:0] KEY_COL,
    output [3:0] KEY_ROW,
    input dip,  //rst
    input clk,
    output [4:0] key_inp,
    output keypad_1_w,
    output keypad_2_w,
    output keypad_3_w,
    output keypad_0_w
);

    keypad keypad (clk_1, dip, KEY_COL, KEY_ROW, key_inp);

    reg keypad_1, keypad_2, keypad_3, keypad_0;
    wire non_zero = keypad_1 | keypad_2 | keypad_3 | keypad_0;
    always @(posedge clk_1 or posedge dip) begin
        if (dip | (non_zero & (key_inp == 4'd12))) begin
            keypad_1 <= 0;
            keypad_2 <= 0;
            keypad_3 <= 0;
            keypad_0 <= 0;
        end else begin
            case(key_inp)
                4'd1:keypad_1<=1;
                4'd2:keypad_2<=1;
                4'd3:keypad_3<=1;
                4'd0:keypad_0<=1;
            endcase
        end
    end

    assign keypad_1_w = keypad_1;
    assign keypad_2_w = keypad_2;
    assign keypad_3_w = keypad_3;
    assign keypad_0_w = keypad_0;
    
endmodule