/*******************************************************************
*** ECE526L Experiment #10             Joshua Rothe, Spring 2017 ***
*** RISC-V Processor                                             ***
********************************************************************
*** Filename: riscv.sv Created by Joshua Rothe, 4 May 2017       ***
*** --- Rev: 0.1 - Initial release (JR) 5/4/17                   ***
********************************************************************
*** This module creates a RISC-V processor.                      ***
********************************************************************/

`timescale 1 ns / 1 ns

module riscv(IO, CLK, RST);

// Port declarations
    inout [7:0] IO;
    input CLK, RST;

// Parameters
    parameter MUX_SIZE          = 8;
    parameter PORT_DIR          = 1;
    parameter PORT_DAT          = 8;
    parameter AD1               = 8;    // RAM datasize aka width
    parameter AA1               = 5;    // RAM adrsize aka depth
    parameter OD1               = 32;   // ROM datasize
    parameter OA1               = 5;    // ROM adrsize
    parameter ADR_SIZE1         = 5;    // PC size, ADR size
    parameter RAM_DATA1         = 8;    // ram data reg size
    parameter A_SIZE1           = 8;    // A data reg size
    parameter B_SIZE1           = 8;    // B data reg size
    parameter MEM_INST_SIZE1 = 32;      // rom data reg size, changing this requires rewriting riscy_data assigns

// Internal variables
    reg [MUX_SIZE-1:0] RAM_DATA, MUX_DATA, A_DATA, B_DATA, PDR_DATA;
    reg [ADR_SIZE1-1:0] ADR;
    reg [OA1-1:0] ADR_CNT;
    wire [MUX_SIZE-1:0] PORT_RD_DATA;
    wire CF, OF, SF, ZF; // ALU flags
    wire ROM_CS, ROM_OE, RAM_CS, RAM_OE, RST_INT;
    wire IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN;
    wire PC_LOAD, ALU_EN, ALU_OE, RDR_EN;
    reg [MEM_INST_SIZE1-1:0] RISCY_DATA, ROM_DATA_OUT;
    reg [3:0] RISCY_OPCODE;                     // following are internal RISC-Y data regs from RISCY_DATA
    reg RISCY_I, PORTDIRDATA;
    reg [6:0] RISCY_ADR;
    reg [7:0] RISCY_DATA1;
    reg [4:0] RAM_ADR;                          // see assign statement for RAM_ADR

// Code
    assign IO = (PDR_EN) ? PDR_DATA[7:0] :'bz;  // if PDR_EN, then IO <= PDR_DATA
    assign PORT_RD_DATA = (PORT_RD) ? IO : 'bz; // if PORT_RD, then PORT_RD_DATA <= IO
    assign RISCY_OPCODE = RISCY_DATA[31:28];    // following assigns split 32 bit rom data into fields
    assign RISCY_I = RISCY_DATA[27];
    assign RISCY_ADR = RISCY_DATA[26:20];
    assign RISCY_DATA1 = RISCY_DATA[7:0];
    assign RAM_ADR = RISCY_DATA[4:0];           // 5 LSBs of Mem Inst Reg's ROM data used for RAM adr
    assign ROM_OE = 1'b1;                       // per RISC-Y instruction, no power concerns
    assign ROM_CS = 1'b0;                       // see above
    assign PORTDIRDATA = MUX_DATA[0];           // LSB of data goes to portdir (only matters if PDR_EN)

// Instancing modules
    register #(.REG_SIZE1(PORT_DIR)) portdir1(CLK, RST_INT, PDR_EN, PORTDIRDATA, PDR_EN);       // port dir in figure 3
    reg_no_rst #(.REG_SIZE(PORT_DAT)) portdata1(CLK, PORT_EN, MUX_DATA, PDR_DATA);              // port data reg, fig 3
    mux #(.MUX_SIZE(MUX_SIZE)) memmux1(RISCY_DATA1, RAM_DATA, RAM_OE, MUX_DATA);
    rom #(.ROM_ADRSIZE(OA1), .ROM_DATASIZE(OD1)) rom1(ROM_DATA_OUT, ADR_CNT, ROM_OE, ROM_CS);
    ram #(.RAM_ADRSIZE(AA1), .RAM_DATASIZE(AD1)) ram1(PORT_RD_DATA, RAM_ADR, RAM_OE, RAM_CS, CLK);
    alu alu1(CLK, ALU_EN, ALU_OE, RISCY_OPCODE, A_DATA, B_DATA, PORT_RD_DATA, CF, OF, SF, ZF);
    seqcon seqcon1(IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN, PC_LOAD, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS, RISCY_ADR, RISCY_OPCODE, CLK, RST, CF, OF, SF, ZF, RISCY_I);
    count_s #(.CNT_SIZE(ADR_SIZE1)) pc_counter(CLK, RST_INT, PC_EN, PC_LOAD, RAM_ADR, ADR_CNT);
    aasd aasd1(CLK, RST, RST_INT);
    reg_no_rst #(.REG_SIZE(RAM_DATA1)) ramdata1(CLK, RDR_EN, PORT_RD_DATA, RAM_DATA);           // ram data reg, fig 2
    reg_no_rst #(.REG_SIZE(A_SIZE1)) a_reg1(CLK, A_EN, PORT_RD_DATA, A_DATA);                   // A en reg, fig 4
    reg_no_rst #(.REG_SIZE(B_SIZE1)) b_reg1(CLK, B_EN, PORT_RD_DATA, B_DATA);                   // B en reg, fig 4
    reg_no_rst #(.REG_SIZE(MEM_INST_SIZE1)) mem_inst1(CLK, IR_EN, ROM_DATA_OUT, RISCY_DATA);    // mem inst reg from rom

endmodule
