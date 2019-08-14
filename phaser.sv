/*******************************************************************
*** ECE526L Experiment #10             Joshua Rothe, Spring 2017 ***
*** Clock Generator                                              ***
********************************************************************
*** Filename: phaser.sv       Created by Joshua Rothe, 27 Apr 17 ***
*** --- Rev: 0.1 - Initial release (JR) 4/27/17                  ***
*** --- 0.2 - Edited for RISC-Y (JR) 5/9/17                      ***
********************************************************************
*** This module creates a phase generator that converts a clock  ***
*** signal into one of 4 cycle codes for the sequence controller ***
********************************************************************/

`timescale 1 ns / 1 ns

module phaser(CLK, RST, EN, PHASE);

// Port declarations
    output reg [1:0] PHASE;
    input EN, CLK, RST;

// Ennumerated Types for cycle states (four cycles)
    enum {FETCH, DECODE, EXECUTE, UPDATE} cycle;

    reg START = 0;      // internal flag that enables phaser upon first reset
    
// Code
always @(posedge CLK or negedge RST) begin
    if (!RST) begin                             // Reset will go through an AASD
        if (!START) START <= 1;                 // makes sure START flag is set
        cycle <= cycle.first;                   // resets to first cycle
    end else begin                              // otherwise cycles through all 4
        if (!EN && START) cycle = cycle.next;   // when enable is low
    end
    PHASE <= cycle;
end
endmodule
