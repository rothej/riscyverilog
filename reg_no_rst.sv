/*******************************************************************
*** ECE526L Experiment #10 Joshua Rothe, Spring 2017             ***
*** n-Bit Register without reset                                 ***
********************************************************************
*** Filename: reg_no_rst.sv   Created by Joshua Rothe, 14 Feb 17 ***
*** --- Rev: 0.1 - Initial release (JR) 2/14/17                  ***
*** --- 0.2 - Updated for RISC-V (JR) 5/8/17                     ***
********************************************************************
*** This module models an n-bit register without rst.            ***
********************************************************************/

`timescale 1 ns / 1 ns      // set timescale and precision to .1 ns

module reg_no_rst(CLK, ENA, DATA, R);

    parameter REG_SIZE = 1;

// Port declarations, aka inputs and outputs
    output reg [REG_SIZE-1:0] R;
    input [REG_SIZE-1:0] DATA;
    input CLK, ENA;

// Code
always @(posedge CLK)
    if (ENA) R <= DATA;

endmodule
