/*******************************************************************
*** ECE526L Experiment #10             Joshua Rothe, Spring 2017 ***
*** RAM Register                                                 ***
********************************************************************
*** Filename: ram.sv Created by Joshua Rothe, 28 Mar 17          ***
*** --- Rev: 0.1 - Initial release (JR) 3/28/17                  ***
*** --- 0.2 - Edited for RISC-Y processor (JR) 5/8/17            ***
********************************************************************
*** This module creates a scalable RAM module as a register.     ***
********************************************************************/

`timescale 1 ns / 1 ns // timescale and precision 1ns

module ram(IO_PORT, ADR, OE, CS, WS);

// Parameter
    parameter RAM_DATASIZE = 8;                     // Default size of data io_bus etc, 8 bit
    parameter RAM_ADRSIZE = 5;                      // default address size, 5 bit
    parameter RAMDEPTH = 1 << RAM_ADRSIZE;

// Port declarations
    inout wire [RAM_DATASIZE - 1:0] IO_PORT;        // i/o port to send data through
    input [RAM_ADRSIZE - 1:0] ADR;                  // address bus
    input WS, OE, CS;
    reg [RAM_DATASIZE - 1:0] DATA_OUT;              // internal data values
    reg [RAM_DATASIZE - 1:0] MEM [0:RAMDEPTH - 1];  // internal memory
    
// output data when OE high, CS low
    assign IO_PORT = (OE && !CS) ? DATA_OUT : 'bz;

// Code
always @(posedge WS) begin      // write strobe acts as CLK for write
    if (!CS && !OE)             // cs is active low to read or write, output enable low
        MEM[ADR] = IO_PORT;     // write data to address
end

always @(OE or ADR) begin
    if (!CS && OE)              // CS low, OE high to read
        DATA_OUT = MEM[ADR];    // adr contents are placed in data bus
end
endmodule
