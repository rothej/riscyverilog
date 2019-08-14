/*******************************************************************
*** ECE526L Experiment #10             Joshua Rothe, Spring 2017 ***
*** Sequence Controller Module                                   ***
********************************************************************
*** Filename: scm.sv Created by Joshua Rothe, 27 Apr 17          ***
*** --- Rev: 0.1 - Initial release (JR) 4/27/17                  ***
*** --- 0.2 - Adjusted for RISC-V (JR) 5/9/17                    ***
********************************************************************
*** This module creates a sequence controller module.            ***
********************************************************************/

`timescale 1 ns / 1 ns

module scm(IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN,
            PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS,
            ADDR, OPCODE, PHASE, CF, OF, SF, ZF, I);

// Opcode Parameters
    localparam LOAD     = 4'b0000; // Load a register
    localparam STORE    = 4'b0001; // Store ALU output
    localparam ADD      = 4'b0010; // Add A and B
    localparam SUB      = 4'b0011; // Subtract B from A
    localparam AND      = 4'b0100; // Bitwise AND of A and B
    localparam OR       = 4'b0101; // Bitwise OR of A and B
    localparam XOR      = 4'b0110; // Bitwise XOR of A and B
    localparam NOT      = 4'b0111; // Bitwise inversion of A
    localparam B        = 4'b1000; // Unconditional branch
    localparam BZ       = 4'b1001; // Branch if Z flag is set
    localparam BN       = 4'b1010; // Branch if N flag is set
    localparam BV       = 4'b1011; // Branch if OVF flag is set
    localparam BC       = 4'b1100; // Branch if C flag is set
// Defining Phase Cycles
    localparam FETCH    = 2'b00;
    localparam DECODE   = 2'b01;
    localparam EXECUTE  = 2'b10;
    localparam UPDATE   = 2'b11;
// Port declarations
    output reg IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN;
    output reg PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS;
    input [6:0] ADDR;
    input [3:0] OPCODE;
    input [1:0] PHASE;
    input CF, OF, SF, ZF, I;
// Internal variables
    reg OPCODE_INTERNAL, DATA_INTERNAL, EXECUTE_INT;

// Code
always @(PHASE) begin                           // sensitivity: whenever cycle changes
    case (PHASE)                                // RST, EN etc controlled by phaser module
        FETCH   : begin
                    IR_EN <= 1;                 // enables instruction register
                    OPCODE_INTERNAL <= OPCODE;
                    PC_EN <= 0;
                    PC_LOAD <= 0;
                end
        DECODE  : begin
                    case (OPCODE_INTERNAL)
                        LOAD : begin                                // Load a register
                                    case (ADDR)                     // determine which reg to load to
                                        7'b1000000: A_EN <= 1;      // ADR 64
                                        7'b1000001: B_EN <= 1;      // ADR 65
                                        7'b1000010: PDR_EN <= 1;    // ADR 66
                                        7'b1000011: PORT_EN <= 1;   // ADR 67
                                    endcase
                                    if (!I) begin // If I bit isnt set, will load from RAM
                                        RAM_OE <= 1;
                                        RAM_CS <= 0;                        // ram_cs must be low for any ram access
                                    end else ALU_OE <= 1;                   // default ALU enable to avoid floating
                                end
                        STORE : begin // Store ALU output
                                    if (ADDR == 7'b1000011) PORT_RD <= 1;   // PORT_RD_DATA goes into RAM
                                    else begin
                                        ALU_EN <= 1;        // otherwise, we store ALU contents
                                        ALU_OE <= 1;
                                    end
                                    RAM_CS <= 0;
                                    RDR_EN <= 1;            // enable RAM write
                                end
                        ADD : begin                         // Add A and B
                                    ALU_EN <= 1;
                                    ALU_OE <= 1;
                                end
                        SUB : begin                         // Subtract B from A
                                    ALU_EN <= 1;
                                    ALU_OE <= 1;
                                end
                        AND : begin                         // Bitwise AND of A and B
                                    ALU_EN <= 1;
                                    ALU_OE <= 1;
                                end
                        OR : begin                          // Bitwise OR of A and B
                                    ALU_EN <= 1;
                                    ALU_OE <= 1;
                                end
                        XOR : begin                         // Bitwise XOR of A and B
                                    ALU_EN <= 1;
                                    ALU_OE <= 1;
                                end
                        NOT : begin                         // Bitwise inversion of A
                                    ALU_EN <= 1;
                                    ALU_OE <= 1;
                                end
                        default : ALU_OE <= 1;              // covers all branch cases
                    endcase
                end
    EXECUTE     : EXECUTE_INT <= 1;                         // internal var to not let execute case be blank
    UPDATE      : begin
                    case (OPCODE_INTERNAL)
                        B : begin
                                PC_LOAD <= 1;               // Unconditional branch
                                EXECUTE_INT <= 0;
                            end
                        BZ : begin
                                if (ZF) PC_LOAD <= 1;       // Branch if Z flag is set
                                else EXECUTE_INT <= 0;
                            end
                        BN : begin
                                if (SF) PC_LOAD <= 1;       // Branch if N flag is set
                                else EXECUTE_INT <= 0;
                            end
                        BV : begin
                                if (OF) PC_LOAD <= 1;       // Branch if OVF flag is set
                                else EXECUTE_INT <= 0;
                            end
                        BC : begin
                                if (CF) PC_LOAD <= 1;       // Branch if C flag is set
                                else EXECUTE_INT <= 0;
                            end
                        default : EXECUTE_INT <= 0;
                    endcase
                    PC_EN <= 1;
                    IR_EN <= 0;
                    A_EN <= 0;
                    B_EN <= 0;
                    PDR_EN <= 0;
                    PORT_EN <= 0;
                    PORT_RD <= 0;
                    ALU_EN <= 0;
                    ALU_OE <= 0;
                    RDR_EN <= 0;
                    RAM_OE <= 0;
                    RAM_CS <= 1;
                end
    endcase
end

endmodule
