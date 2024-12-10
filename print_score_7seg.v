module print_score_7seg(
	CLK,
	a,
	N_Reset,
	SEG_COM, SEG_DATA
);

input CLK,N_Reset;
input [6:0] a;
output [7:0] SEG_COM, SEG_DATA; // Two 8-bit-outputs

wire [3:0] T_hunds,T_tens,T_ones;
wire [6:0] H, T, O; 

// calling out 'binary_to_BCD' module
binary_to_BCD_7bit u1(a, T_hunds, T_tens, T_ones);

// calling out 'BCD_to_7segment' module
BCD_to_7segment u_100(T_ones[3],T_ones[2],T_ones[1],T_ones[0],H[6],H[5],H[4],H[3],H[2],H[1],H[0]);
BCD_to_7segment u_10(T_tens[3],T_tens[2],T_tens[1],T_tens[0],T[6],T[5],T[4],T[3],T[2],T[1],T[0]);
BCD_to_7segment u_1(T_hunds[3],T_hunds[2],T_hunds[1],T_hunds[0],O[6],O[5],O[4],O[3],O[2],O[1],O[0]);

// calling out 'SevenSeg_CTRL' module
SevenSeg_CTRL u4(CLK, N_Reset,8'b0,8'b0,8'b0,8'b0,8'b0,{H,1'b0},{T,1'b0},{O,1'b0}, SEG_COM, SEG_DATA);

endmodule


module SevenSeg_CTRL(
	iCLK,
	nRST,
	iSEG7,
	iSEG6,
	iSEG5,
	iSEG4,
	iSEG3,
	iSEG2,
	iSEG1,
	iSEG0,
	oS_COM,
	oS_ENS
);
// I/O definition------------------------------------------	
input iCLK, nRST;
input [7:0] iSEG7, iSEG6, iSEG5, iSEG4, iSEG3, iSEG2, iSEG1, iSEG0;
output [7:0] oS_COM;
output [7:0] oS_ENS; /* a,b,c,d, e,f,g,dp */
reg [7:0] oS_COM;
reg [7:0] oS_ENS;
integer CNT_SCAN; 

/*
   [a]
[f]   [b]
   [g]
[e]   [c]
   [d]   [dp]
*/

always @(posedge iCLK)
begin
	if (nRST)
	  begin
		oS_COM <= 8'b00000000;
		oS_ENS <= 0;
	    CNT_SCAN = 0;
	  end
	else
	  begin
	  	if (CNT_SCAN >= 7)
	  	  CNT_SCAN = 0;
	  	else
	  	  CNT_SCAN = CNT_SCAN + 1;
	  	  	  	
	  	case (CNT_SCAN)
	  	  0 : 
	  	    begin
				oS_COM <= 8'b11111110;
				oS_ENS <= iSEG0;
	  	    end
	  	  1 : 
	  	    begin
				oS_COM <= 8'b11111101;
				oS_ENS <= iSEG1;
	  	    end
	  	  2 : 
	  	    begin
				oS_COM <= 8'b11111011;
				oS_ENS <= iSEG2;
	  	    end
	  	  3 : 
	  	    begin
				oS_COM <= 8'b11110111;
				oS_ENS <= iSEG3;
	  	    end
	  	  4 : 
	  	    begin
				oS_COM <= 8'b11101111;
				oS_ENS <= iSEG4;
	  	    end
	  	  5 : 
	  	    begin
				oS_COM <= 8'b11011111;
				oS_ENS <= iSEG5;
	  	    end
	  	  6 : 
	  	    begin
				oS_COM <= 8'b10111111;
				oS_ENS <= iSEG6;
	  	    end
	  	  7 : 
	  	    begin
				oS_COM <= 8'b01111111;
				oS_ENS <= iSEG7;
	  	    end			 
	  	  default : 
	  	    begin
	  	      oS_COM <= 8'b11111111;
				oS_ENS <= iSEG7;
	  	    end
	  	endcase
      end
end

endmodule 


module BCD_to_7segment (T3,T2,T1,T0, A1,B1,C1,D1,E1,F1,G1); 
 
input T3,T2,T1,T0;  // 4 inputs
output A1,B1,C1,D1,E1,F1,G1; // 7 outputs

reg [6:0] out; 

always @(T3,T2,T1,T0) 
begin
case({T3,T2,T1,T0})
4'b0000 : out <= 7'b1111110; //0
4'b0001 : out <= 7'b0110000; //1
4'b0010 : out <= 7'b1101101; //2
4'b0011 : out <= 7'b1111001; //3
4'b0100 : out <= 7'b0110011; //4
4'b0101 : out <= 7'b1011011; //5
4'b0110 : out <= 7'b1011111; //6
4'b0111 : out <= 7'b1110010; //7
4'b1000 : out <= 7'b1111111; //8
4'b1001 : out <= 7'b1111011; //9
default : out <= 7'b0000000; //NULL
endcase 
end

assign {A1,B1,C1,D1,E1,F1,G1} = out;

endmodule 

module linedecoder 
(
	A3,A2,A1,A0,
	S3,S2,S1,S0
);

input A3,A2,A1,A0; // 4 inputs
output S3,S2,S1,S0; // 4 outputs

reg [3:0] out; 

always @(A3,A2,A1,A0)
begin
case({A3,A2,A1,A0})  
4'b0000 : out <= 4'b0000; 
4'b0001 : out <= 4'b0001; 
4'b0010 : out <= 4'b0010; 
4'b0011 : out <= 4'b0011; 
4'b0100 : out <= 4'b0100; 
4'b0101 : out <= 4'b1000; 
4'b0110 : out <= 4'b1001; 
4'b0111 : out <= 4'b1010; 
4'b1000 : out <= 4'b1011; 
4'b1001 : out <= 4'b1100; 
default : out <= 4'b0000; 
endcase 
end

assign {S3,S2,S1,S0} = out; 

endmodule 

module binary_to_BCD_7bit (
    input  [6:0] score,       // 7비트 이진 입력 (0 ~ 127)
    output [3:0] hundreds,    // BCD 백의 자리 (0 또는 1)
    output [3:0] tens,        // BCD 십의 자리 (0 ~ 2)
    output [3:0] units         // BCD 일의 자리 (0 ~ 9)
);

    // 백의 자리: 100 이상이면 1, 아니면 0
    assign hundreds = (score >= 7'd100) ? 4'd1 : 4'd0;

    // 십의 자리 계산
    assign tens = (score >= 7'd100) ? ((score - 7'd100) / 7'd10) : (score / 7'd10);

    // 일의 자리 계산
    assign units = (score >= 7'd100) ? ((score - 7'd100) % 7'd10) : (score % 7'd10);

endmodule

/*
module binary_to_BCD (I3,I2,I1,I0, T9,T8,T7,T6,T5,T4,T3,T2,T1,T0); 

input I3, I2, I1, I0; // 4 inputs
output T9, T8, T7, T6, T5, T4, T3, T2, T1, T0;  // 10 outputs

wire w[10:0]; 

// calling out 'linedecoder' module
linedecoder c1(1'b0, 1'b0, 1'b0, I3, w[3], w[2], w[1], w[0]); 
linedecoder c2(w[2], w[1], w[0], I2, w[7], w[6], w[5], w[4]);
linedecoder c3(1'b0, 1'b0, 1'b0, w[3], T9, w[10], w[9], w[8]);
linedecoder c4(w[6], w[5], w[4], I1, T4, T3, T2, T1);
linedecoder c5(w[10], w[9], w[8], w[7], T8, T7, T6, T5);

assign T0 = I0; 

endmodule 
*/





























/*

    wire [3:0] hundreds;     // 백의 자리 (1 또는 0)
    wire [3:0] tens;         // 십의 자리 (BCD로 출력)
    wire [3:0] units;        // 일의 자리 (항상 0)


    wire [6:0] seg_hundreds; // 백의 자리 7-segment 데이터
    wire [6:0] seg_tens;     // 십의 자리 7-segment 데이터
    wire [6:0] seg_units;    // 일의 자리 7-segment 데이터

    assign hundreds = (score == 100) ? 4'd1 : 4'd0; // 백의 자리는 100일 때만 1, 나머지는 0
    assign tens = (score / 10) % 10;                       // 십의 자리는 score[6:4] 비트로 표현
    assign units = 4'd0;                             // 일의 자리는 항상 0

  
    BCD_to_7segment hundreds_decoder (
        .T3(hundreds[3]), .T2(hundreds[2]), .T1(hundreds[1]), .T0(hundreds[0]),
        .A1(seg_hundreds[6]), .B1(seg_hundreds[5]), .C1(seg_hundreds[4]),
        .D1(seg_hundreds[3]), .E1(seg_hundreds[2]), .F1(seg_hundreds[1]),
        .G1(seg_hundreds[0])
    );

    BCD_to_7segment tens_decoder (
        .T3(tens[3]), .T2(tens[2]), .T1(tens[1]), .T0(tens[0]),
        .A1(seg_tens[6]), .B1(seg_tens[5]), .C1(seg_tens[4]),
        .D1(seg_tens[3]), .E1(seg_tens[2]), .F1(seg_tens[1]),
        .G1(seg_tens[0])
    );

    // 일의 자리는 항상 0으로 고정된 7-segment 데이터
    assign seg_units = 7'b1111110; // 숫자 "0"의 7-segment 데이터

    // 7-segment 컨트롤러
    SevenSeg_CTRL seven_seg_ctrl (
        .iCLK(clk),
        .nRST(nRST),
        .iSEG7(8'b0), .iSEG6(8'b0), .iSEG5(8'b0), .iSEG4(8'b0), // 미사용
        .iSEG3({seg_hundreds, 1'b0}),  // 백의 자리
        .iSEG2({seg_tens, 1'b0}),      // 십의 자리
        .iSEG1({seg_units, 1'b0}),     // 일의 자리
        .iSEG0(8'b0),                  // 미사용
        .oS_COM(SEG_COM),
        .oS_ENS(SEG_DATA)
    );

endmodule
*/