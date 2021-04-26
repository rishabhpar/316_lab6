`timescale 1ns / 1ps
module clockdiv_seven_segment( 
    input clk, 
    input reset,
    output reg clk_out
    );

    reg [25:0] COUNT;

    always @(posedge clk) 
    begin
      // want to divide the frequency by a million
      // toggle clk_out every 500,000 so the clk_out rises every 10 ms
      if (COUNT == 499999) begin
        clk_out = ~clk_out; 
        COUNT = 0;
      end
      else begin
        COUNT = COUNT + 1;
      end 
    end
endmodule