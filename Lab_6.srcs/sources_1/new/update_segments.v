`timescale 1ns / 1ps
module update_segments( 
    input [3:0] res0,
    input [3:0] res1,
    input [3:0] res2,
    input [3:0] res3,
    input [6:0] in0,
    input [6:0] in1,
    input [6:0] in2,
    input [6:0] in3
);

    hexto7segment a1(res0, in0); 
    hexto7segment a2(res1, in1);
    hexto7segment a3(res2, in2); 
    hexto7segment a4(res3, in3);
endmodule