/*******************************************************************
*** ECE526L Experiment #10             Joshua Rothe, Spring 2017 ***
*** Scalable 2:1 Multiplexer                                     ***
********************************************************************
*** Filename: mux.sv          Created by Joshua Rothe, 28 Feb 17 ***
*** --- Rev: 0.1 - Initial release (JR) 2/28/17                  ***
*** --- 0.2 - Minor fixes per lab report (JR) 4/27/17            ***
*** --- 0.3 - Adjusted for RISC-V (JR) 5/8/17                    ***
********************************************************************
*** This module creates a scalable 2:1 MUX.                      ***
********************************************************************/

`timescale 1 ns / 1 ns // timescale and precision 1ns

module mux(A, B, SEL, OUT);

// Parameter, line 19
    parameter MUX_SIZE = 1;                 // Default size if not scaled in testbench

// Port declarations
    output reg [MUX_SIZE-1:0] OUT;          // Size - 1 is because n bits go from [n-1:0]
    input [MUX_SIZE-1:0] A, B;
    input SEL;

// Code below, line 27
always @(SEL or A or B) begin
    for(int i = 0; i < MUX_SIZE; i++) begin // For each bit in the input
        if (SEL == 0) OUT[i] <= A[i];       // if Sel = 0 for A
        else begin // then move bit of A to output
            if(SEL == 1) OUT[i] <= B[i];    // or, if Sel = 1 for B...
            else begin                      // for Sel = X, Z etc
                if(A[i] == B[i]) OUT[i] <= A[i]; // for Sel = X or Z,
                // if both A and B for the bit are the same, SEL doesn't matter
                else OUT[i] <= 1'bx;        // but if A =/ B, then that bit = x output
            end
        end
    end
end
endmodule
