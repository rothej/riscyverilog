/*******************************************************************
*** ECE526L Experiment #10             Joshua Rothe, Spring 2017 ***
*** 6-Bit Reloadable Up Counter Compile and Test, Sync Reset     ***
********************************************************************
*** Filename: count_s.sv      Created by Joshua Rothe, 21 Feb 17 ***
*** --- Rev: 0.1 - Initial release (JR) 2/21/17                  ***
*** --- 0.2 - Minor fixes per lab report (JR) 4/27/17            ***
*** --- 0.3 - Adjusted for RISC-Y processor (JR) 5/8/17          ***
********************************************************************
*** This module models an n-bit reloadable up counter, with sync ***
*** active low reset, and synch active high load and enable.     ***
********************************************************************/

`timescale 1 ns / 1 ns // set timescale and precision to 1 ns

module count_s(CLK, RST, ENA, LOAD, DATA, COUNT);

    parameter CNT_SIZE = 5;             // PC size

// Port declarations, aka inputs and outputs
    output [CNT_SIZE - 1:0] COUNT;
    input [CNT_SIZE - 1:0] DATA;        // count and data are 6 bit binary
    input CLK, ENA, RST, LOAD;

// Variables
    reg [CNT_SIZE - 1:0] COUNT;

// Code below
always @(posedge CLK, negedge RST) begin
    if (!RST) COUNT <= 'b0;             // Active LOW reset to 0
    else begin
        if (ENA) begin                  // counter holds value unless ENA is high
            if (LOAD) COUNT <= DATA;    // if load is high, and ENA high, then input => count
            else COUNT <= COUNT + 1;    // or if load = 0, ENA = 1, raise count by 1
        end
    end
end
endmodule
