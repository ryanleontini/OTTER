`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Ryan Leontini
// 
// Create Date: 02/08/2023 07:20:12 PM
// Module Name: BRANCH_ADDR_GEN
// Target Devices: Basys3
// Description: This design generates the jal, branch, and jalr      
// addresses from PC, JType, BType, IType and rs1 inputs. 
/////////////////////////////////////////////////////////////////////



module BRANCH_ADDR_GEN(
    input [31:0] PC,
    input [31:0] JType,
    input [31:0] BType,
    input [31:0] IType,
    input [31:0] rs1,
    output logic [31:0] jal,
    output logic [31:0] branch,
    output logic [31:0] jalr
    );
    
    always_comb begin
        jal = PC + JType;
        branch = PC + BType;
        jalr = rs1 + IType;
    end
endmodule
