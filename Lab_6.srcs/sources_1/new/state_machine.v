`timescale 1ns / 1ps
module state_machine(
    input clk,
    input reset,
    input [6:0] in0,
    input [6:0] in1,
    input [6:0] in2,
    input [6:0] in3,
    output reg [3:0] an,
    output reg [6:0] sseg,
    output reg decimalpoint
    );
    
    reg [1:0] state;
    reg [1:0] next;
    
    always @ (*) begin
        case(state) //state transition
            2'b00: next = 2'b01;
            2'b01: next = 2'b10;
            2'b10: next = 2'b11;
            2'b11: next = 2'b00;
        endcase
    end
    
    always @ (*) begin
        case(state) // multiplexer
            2'b00: begin 
                sseg = in0;
                decimalpoint = 1;
            end
            2'b01: begin 
                sseg = in1;
                decimalpoint = 1;
            end
            2'b10: begin 
                sseg = in2;
                decimalpoint = 0;
            end
            2'b11: begin 
                sseg = in3;
                decimalpoint = 1;
            end
        endcase
        
        case(state) // decoder (active low)
            2'b00: an = 4'b1110;
            2'b01: an = 4'b1101;
            2'b10: an = 4'b1011;
            2'b11: an = 4'b0111;
        endcase
    end
    
    always @ (posedge clk or posedge reset) begin
        if (reset)
            state <= 2'b00;
        else
            state <= next;
    end
    
        
endmodule

