/*******************************************************************
*** ECE526L Experiment #10             Joshua Rothe, Spring 2017 ***
*** Arithmetic-Logic Unit                                        ***
********************************************************************
*** Filename: alu.sv           Created by Joshua Rothe, 9 Apr 17 ***
*** --- Rev: 0.1 - Initial release (JR) 4/9/17                   ***
*** --- 0.2 - Minor fixes per lab report (JR) 4/27/17            ***
*** --- 0.3 - Adjusted for RISC-V processor (JR) 5/8/17          ***
********************************************************************
*** This module creates an arithmetic-logic unit.                ***
********************************************************************/

`timescale 1 ns / 1 ns

module alu(CLK, EN, OE, OPCODE, A, B, ALU_OUT, CF, OF, SF, ZF);

// Parameters
    parameter WIDTH   = 8;          // width to 8 bit
    localparam ALUADD = 4'b0010;
    localparam ALUSUB = 4'b0011;
    localparam ALUAND = 4'b0100;
    localparam ALUOR  = 4'b0101;
    localparam ALUXOR = 4'b0100;
    localparam ALUNOT = 4'b0101;

// Port declarations
    output reg [WIDTH-1:0] ALU_OUT; // scalable output
    output reg CF, OF, SF, ZF;
    input [3:0] OPCODE;
    input [WIDTH-1:0] A, B;         // scalabe input
    input CLK, EN, OE;

// Internal variables
    reg [WIDTH-1:0] S; // output placeholder
    reg [WIDTH-1:0] K; // placeholder for 2s complement

// Flags
    assign OF = ~(A[WIDTH-1] ^ B[WIDTH-1]) ^ S[WIDTH-1];
/* checks if A and B sign bits are the same, since overflow will only occur if the
signs for A and B are the same. XORing the inverse of this result with S checks to see
if the sign changed from the input to the output. If it did, then the overflow flag is set.*/
    assign SF = S[WIDTH-1]; // check for negative flag
    assign ZF = !S; // check for zero flag

// Code
always @(posedge CLK) begin
    if (EN) begin // ALU evaluates if enabled. If not, maintain prev
        case (OPCODE)
            ALUADD  : {CF, S} = A + B;   // Add into S, carry flag will take carry bit
            ALUSUB  : begin // first we must take 2's complement
                for(int i = 0; i < WIDTH; i++) K[i] = ~B[i];
                    // For each bit in the input, invert the bit
                    K = K + 1;          // then add 1. 2s complement complete
                    S = A + K;          // add 2s complement to get difference
                    if (A < B) CF = 1;  // checking for carry flag
                    else CF = 0;
                end
            ALUAND  : S[WIDTH-1:0] = A[WIDTH-1:0] & B[WIDTH-1:0];
            ALUOR   : S[WIDTH-1:0] = A[WIDTH-1:0] | B[WIDTH-1:0];
            ALUXOR  : S[WIDTH-1:0] = A[WIDTH-1:0] ^ B[WIDTH-1:0];
            ALUNOT  : S[WIDTH-1:0] = ~A[WIDTH-1:0];
            default : $display("Unrecognized opcode.");
        endcase
        if (OE) ALU_OUT = S; // If OE is disabled, output is Z, but ALU still runs internally
        else ALU_OUT = 'bz;
    end
end

endmodule
