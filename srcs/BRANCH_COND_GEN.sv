`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Ryan Leontini
// 
// Create Date: 02/08/2023 07:00:07 PM
// Module Name: BRANCH_COND_GEN
// Target Devices: Basys3
// Description: A design that tests whether 2 32-bit inputs are equal, less than, or less than unsigned.
/////////////////////////////////////////////////////////////////////

module BRANCH_COND_GEN(
    input [31:0] rs1,
    input [31:0] rs2,
    output logic br_eq,
    output logic br_lt,
    output logic br_ltu
    );
    
    always_comb begin
        
        // br_eq
        if (rs1 == rs2) begin
            br_eq = 1;
        end
        else 
            br_eq = 0;
       
        // br_lt
        if ($signed(rs1) < $signed(rs2)) begin
            br_lt = 1;
        end
        else 
            br_lt = 0;
        
        // br_ltu
        if (rs1 < rs2) begin
            br_ltu = 1;
        end
        else 
            br_ltu = 0;
        
    end
endmodule
