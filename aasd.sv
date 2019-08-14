/*******************************************************************
*** ECE526L Experiment #10             Joshua Rothe, Spring 2017 ***
*** Asynchronous Assert, Synchronous Deassert Reset              ***
********************************************************************
*** Filename: aasd.sv         Created by Joshua Rothe, 21 Feb 17 ***
*** --- Rev: 0.1 - Initial release (JR) 2/21/17                  ***
*** --- 0.2 - Updated for use in RISC-Y (JR) 5/4/17              ***
********************************************************************
*** This module synchronizes an async reset input with the clk   ***
*** of a synchronous circuit for better performance.             ***
********************************************************************/
`timescale 1 ns / 1 ns // set timescale and precision to 1 ns

module aasd(CLK, RST_IN, RST_OUT);

// Port declarations, aka inputs and outputs
    output reg RST_OUT;
    input RST_IN;
    input CLK;

// Variables
    reg R;

// Code below
// synchronous when clocked, or active low reset is ENABLED
always @(posedge CLK or negedge RST_IN)
    if (!RST_IN) begin  // when rst is toggled,
        R <= 1'b0;      // R and output are 0
        RST_OUT <= 1'b0;
    end else begin
        R <= 1'b1;      // when pos edge of clk occurs,
        RST_OUT <= R;   // prev value of R moves to RST_OUT
    end
endmodule
