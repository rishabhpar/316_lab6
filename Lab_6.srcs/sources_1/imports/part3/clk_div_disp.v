`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2021 09:53:58 PM
// Design Name: 
// Module Name: clk_div_disp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_div_disp(
    input clk,
    input reset,
    output reg clk_out
    );
    
    reg [23:0] COUNT; // 2bit for sim, 24 bit for board
    
    assign slow_clk = COUNT[23];
    
    always @(posedge clk)
    begin
    if (reset)
        COUNT = 0;
    else
        COUNT = COUNT + 1;
    end
    
endmodule
