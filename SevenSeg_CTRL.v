module SevenSeg_CTRL(
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


	assign oS_COM = 8'b00011111;
	oS_ENS = 0;


endmodule 