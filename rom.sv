/*******************************************************************
*** ECE526L Experiment #10             Joshua Rothe, Spring 2017 ***
*** ROM register                                                 ***
********************************************************************
*** Filename: rom.sv          Created by Joshua Rothe, 28 Mar 17 ***
*** --- Rev: 0.1 - Initial release (JR) 3/28/17                  ***
*** --- 0.2 - Adjusted for RISC-V processor (JR) 5/8/17          ***
********************************************************************
*** This module creates a scalable ROM module as a register.     ***
********************************************************************/

`timescale 1 ns / 1 ns // timescale and precision 1ns

module rom(DATA1, ADR, OE, CS);

// Parameter
    parameter ROM_DATASIZE  = 8;                    // Default size of data io_bus etc, 8 bit
    parameter ROM_ADRSIZE   = 5;                    // default address size, 5 bit
    parameter ROMDEPTH      = 1 << ROM_ADRSIZE;

// Port declarations
    output [ROM_DATASIZE - 1:0] DATA1;              // i/o port to send data through
    input [ROM_ADRSIZE - 1:0] ADR;                  // address bus
    input OE, CS;
    reg [ROM_DATASIZE - 1:0] DATA_OUT;              // internal data values
    reg [ROM_DATASIZE - 1:0] MEM [0:ROMDEPTH - 1];  // internal memory

    assign DATA1 = DATA_OUT;

// Code
always @(OE or ADR) begin
    if (!CS && OE)                                  // CS low, OE high to read
        DATA_OUT = MEM[ADR];                        // adr contents are placed in data bus
end

endmodule
