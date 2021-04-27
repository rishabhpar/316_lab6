`timescale 1ns / 1ps

// inputs: start, clk, reset, switches
// outputs: an, 7seg, decimalpoint
module stopwatch(
    input start,
    input clk,
    input reset,
    input [9:0] switches, // switch 0,1 are for modes; 
                           // 6-9 for tens place; 
                           // 2-5 for ones places
    output [3:0] an,
    output [6:0] sseg,
    output decimalpoint
    );
    
wire [6:0] segment0, segment1, segment2, segment3;

reg [3:0] segment0_buf = 0; // hundredths
reg [3:0] segment1_buf = 0;
reg [3:0] segment2_buf = 0;
reg [3:0] segment3_buf = 0; // tens

reg running = 0;
reg currently_reset = 1; 
reg pressed = 1;

wire logic_clk; 
wire display_clk;

clk_div_disp c0 (.clk(clk), .reset(reset), .clk_out(display_clk)); 
clockdiv_10ms c1 (.clk(clk), .reset(reset), .clk_out(logic_clk));

always @(posedge logic_clk) begin
    // toggle on start/stop presses 
    if (start && pressed) begin
        running = ~running; 
        pressed = 0;
        currently_reset = 0; 
    end
    if (!start) begin 
        pressed = 1;
    end

    // toggle for reset 
    if (reset) begin
        currently_reset = 1;
        running = 0; 
    end
 
    // for mode 1 and 2, stay at 99.99
    if (switches[1] == 0 && segment0_buf == 9 && segment1_buf == 9 && segment2_buf == 9 && segment3_buf == 9) begin 
        segment0_buf <= 9;
        segment1_buf <= 9;
        segment2_buf <= 9;
        segment3_buf <= 9; 
     end


    // for mode 3 and 4, stay at 00.00
    if (switches[1] == 1 && segment0_buf == 0 && segment1_buf == 0 && segment2_buf == 0 && segment3_buf == 0) begin 
        segment0_buf <= 0;
        segment1_buf <= 0;
        segment2_buf <= 0;
        segment3_buf <= 0;  
      end

    // set-up reset button
    if (!running && currently_reset) begin 
        // mode 1
        if (switches[1:0] == 0) begin
            segment0_buf <= 0;
            segment1_buf <= 0;
            segment2_buf <= 0;
            segment3_buf <= 0; 
        end
        
        // mode 3
        else if (switches[1:0] == 2) begin 
            segment0_buf <= 9;
            segment1_buf <= 9;
            segment2_buf <= 9;
            segment3_buf <= 9; 
        end
    
        // modes 2 and 4
        else if (switches[1:0] == 1 || switches[1:0] == 3) begin 
            segment0_buf <= 0;
            segment1_buf <= 0;
            
            // fill in the ones place
            if(switches[5:2] >= 9) segment2_buf = 9;
            else segment2_buf <= switches[5:2];
            
            // fill in the tens place
            if(switches[9:6] >= 9) segment3_buf = 9;
            else segment3_buf <= switches[9:6];
        end
    end

    else if (running && !currently_reset) begin
        // do the increment for modes 1 and 2
        if (switches[1] == 0) begin
            segment0_buf = (segment0_buf + 1) % 10; 
            if (segment0_buf == 0) begin
                 segment1_buf = (segment1_buf + 1) % 10;
                 if (segment1_buf == 0) begin
                    segment2_buf = (segment2_buf + 1) % 10;
                    if (segment2_buf == 0) begin
                        segment3_buf = (segment3_buf + 1) % 10; 
                    end
                end 
            end
        end
    
        // do the decement for modes 3 and 4
        else if (switches[1] == 1) begin 
            if (segment0_buf == 0) begin 
                segment0_buf = 9;
            end
            else begin
                segment0_buf = segment0_buf - 1; 
            end
            
            if (segment0_buf == 9) begin
                if (segment1_buf == 0) begin 
                  segment1_buf = 9;
                end
                else begin
                 segment1_buf = segment1_buf - 1; 
                end
                if (segment1_buf == 9) begin
                    if (segment2_buf == 0) begin 
                      segment2_buf = 9;
                    end
                    else begin
                     segment2_buf = segment2_buf - 1; 
                    end
            
                    if (segment2_buf == 9) begin
                     if (segment3_buf == 0) begin 
                       segment3_buf = 9;
                     end
                     else begin
                      segment3_buf = segment3_buf - 1; 
                     end
                    end 
                 end
              end 
          end
     end 
 end
        
// update display buffers
hexto7segment a1(.x(segment0_buf), .r(segment0)); 
hexto7segment a2(.x(segment1_buf), .r(segment1));
hexto7segment a3(.x(segment2_buf), .r(segment2)); 
hexto7segment a4(.x(segment3_buf), .r(segment3));

// post updates
state_machine c6(
    .clk(display_clk),
    .reset(reset),
    .in0(segment0),
    .in1(segment1),
    .in2(segment2),
    .in3(segment3),
    .an(an),
    .sseg(sseg),
    .decimalpoint(decimalpoint)
);


endmodule
