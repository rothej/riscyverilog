/*******************************************************************
*** ECE526L Experiment #10             Joshua Rothe, Spring 2017 ***
*** Sequence Controller                                          ***
********************************************************************
*** Filename: seqcon.sv        Created by Joshua Rothe, 4 May 17 ***
*** --- Rev: 0.1 - Initial release (JR) 5/4/17                   ***
*** ---      0.2 - Adjusted for RISC-V processor (JR) 5/8/17     ***
********************************************************************
*** This module creates a sequence controller for the RISC-V     ***
*** processor.                                                   ***
********************************************************************/

`timescale 1 ns / 1 ns

module seqcon(IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN,
            PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS,
            ADDR, OPCODE, CLK, RST, CF, OF, SF, ZF, I);

// Port declarations, aka inputs and outputs
    output reg IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN;
    output reg PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS;
    input [6:0] ADDR;
    input [3:0] OPCODE;
    input CLK, RST, CF, OF, SF, ZF, I;

// Internal variable declarations, signal type
    reg RST1, EN;
    reg [1:0] PHASE1;

    assign EN = 1'b0;       // tied low per lab 10 instruction

// Instancing modules
    aasd    aasd1a(CLK, RST, RST1);
    phaser  phaser1a(CLK, RST1, EN, PHASE1);
    scm     scm1a(IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN,
                PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS,
                ADDR, OPCODE, PHASE1, CF, OF, SF, ZF, I);

endmodule
