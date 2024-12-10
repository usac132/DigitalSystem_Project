
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