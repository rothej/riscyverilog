/*******************************************************************
*** ECE526L Experiment #10             Joshua Rothe, Spring 2017 ***
*** n-Bit Register with reset                                    ***
********************************************************************
*** Filename: register.sv     Created by Joshua Rothe, 14 Feb 17 ***
*** --- Rev: 0.1 - Initial release (JR) 2/14/17                  ***
*** --- 0.2 - Updated for RISC-V (JR) 5/8/17                     ***
********************************************************************
*** This module models an n-bit register.                        ***
********************************************************************/

`timescale 1 ns / 1 ns // set timescale and precision to 1 ns

module register(CLK, RST, ENA, DATA, R);

// Parameter declaration
    parameter REG_SIZE1 = 1;

// Port declarations
    output reg [REG_SIZE1-1:0] R;
    input [REG_SIZE1-1:0] DATA;
    input CLK, ENA, RST;

// Code
always @(posedge CLK or negedge RST)
    if (!RST) R <= 0;
    else if (ENA) R <= DATA;

endmodule
