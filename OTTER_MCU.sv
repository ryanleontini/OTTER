`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Ryan Leontini
// 
// Create Date: 02/10/2023 05:38:42 PM
// Module Name: OTTER_MCU
// Target Devices: Basys3
// Description: The top level module for the 32-bit RISC-V OTTER Microcontroller.
//////////////////////////////////////////////////////////////////////////////////


module OTTER_MCU(
    input RST,
    input INTR,
    input [31:0] IOBUS_IN,
    input CLK,
    output [31:0] IOBUS_OUT,
    output [31:0] IOBUS_ADDR,
    output IOBUS_WR
    );
    
    // PC
    logic [31:0] PC_4;
    
    // 6:1 Mux entering the PC.
    logic [31:0] PC_DIN;
    always_comb begin
        case (pcSOURCE)
            3'b000: PC_DIN <= PC4;
            3'b001: PC_DIN <= JALR;
            3'b010: PC_DIN <= BRANCH;
            3'b011: PC_DIN <= JAL;
            3'b100: PC_DIN <= MTVEC;
            3'b101: PC_DIN <= MEPC;
            default: PC_DIN <= 32'h42424242;
        endcase   
    end
    
    // pc module.
    PC pc(.PC_WRITE(PCWrite), .PC_RST(reset), .PC_DIN(PC_DIN), .clk(CLK), .PC_COUNT(PC_OUT)); 
    
    assign PC_4 = PC_OUT + 4;
    
    // END OF PC.
    
    // MEMORY
    logic [31:0] ir;
    logic [13:0] PC_15_2;
    
    assign PC_15_2 = PC[15:2];
    
    // memory module.
    MEMORY memory(.MEM_CLK(CLK), .MEM_RDEN1(memRDEN1), .MEM_RDEN2(memRDEN2), .MEM_WE2(memWE2), 
        .MEM_ADDR1(PC_15_2), .MEM_ADDR2(result), .MEM_DIN2(rs2), 
        .MEM_SIZE(MEM_SIZE), .MEM_SIGN(MEM_SIGN), .IO_IN(IOBUS_IN), 
        .IO_WR(IOBUS_WR), .MEM_DOUT1(ir), .MEM_DOUT2(DOUT2));
    
    // END OF MEMORY.
    
    // REG_FILE
    // 4:1 Mux entering the REG_FILE.
    logic [31:0] wd;
    always_comb begin
        case (rf_wr_sel)
            2'b00: wd = PC_4;
            2'b01: wd = csr_RD;
            2'b10: wd = DOUT2;
            2'b11: wd = result;
        endcase       
    end
    
    // REG_FILE input logic.
    logic [4:0] adr1, adr2, wa;
    assign adr1 = ir[19:15];
    assign adr2 = ir[24:20];
    assign wa = ir[11:7];
    
    // reg_file module.
    REG_FILE reg_file(.RF_ADDR1(adr1), .RF_ADR2(adr2), .RF_EN(regWrite), .RF_WA(wa), .RF_WD(wd), 
        .clk(CLK), .RF_RS1(rs1), .RF_RS2(rs2));
        
    // END OF REG_FILE.
    
    // IMMED GEN
    logic [24:0] INSTRUCT;
    assign INSTRUCT = ir[31:7];
    
    // immed_gen module.
    IMMED_GEN immed_gen(.INSTRUCT(INSTRUCT), .U_TYPE(U_TYPE), .I_TYPE(I_TYPE), 
    .S_TYPE(S_TYPE), .J_TYPE(J_TYPE), .B_TYPE(B_TYPE));
    
    // END OF IMMED GEN
    
    // BRANCH ADDR GEN
    // branch_addr_gen module.
    BRANCH_ADDR_GEN branch_addr_gen(.PC(PC), .JType(J_TYPE), .BType(B_TYPE), .IType(I_TYPE), 
    .rs1(rs1), .jal(jal), .branch(branch), .jalr(jalr));
    
    // END OF BRANCH ADDR GEN.
    
    // BRANCH COND GEN
    // branch_cond_gen module.
    BRANCH_COND_GEN branch_cond_gen(.rs1(rs1), .rs2(rs2), .br_eq(br_eq), .br_lt(br_lt), .br_ltu(br_ltu));
    
    // END OF BRANCH COND GEN.
    
    // ALU
    // 3:1 Mux going into srcA.
    logic [31:0] srcA;
    always_comb begin
        case (alu_srcA)
            2'b00: srcA = rs1;
            2'b01: srcA = U_TYPE;
            2'b10: srcA = ~rs1;
            default: srcA = 32'h000ADEAD;
        endcase
    end
    
    // 5:1 Mux going into srcB.
    logic [31:0] srcB;
    always_comb begin
        case (alu_srcB)
            3'b000: srcB = rs2;
            3'b001: srcB = I_TYPE;
            3'b010: srcB = S_TYPE;
            3'b011: srcB = PC;
            3'b100: srcB = csr_RD;
            default: srcB = 32'h000BDEAD;
        endcase
    end
    
    // alu module.
    ALU alu(.srcA(srcA), .srcB(srcB), .alu_fun(alu_fun), .result(result));
    
    // END OF ALU.
