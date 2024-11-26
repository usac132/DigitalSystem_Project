module input_filter(
    input inp,
    input enable,
    output out
);
// GM에서 맨처음 input을 받았을 때 모든 input이 거쳐감.
// led 신호를 출력중일 때 등 특정 상황에서 input 신호를 아예 차단하는 역할을 함.
assign out = inp & enable;
endmodule