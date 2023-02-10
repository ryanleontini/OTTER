`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Company: Cal Poly
// Engineer: Ryan Leontini
// 
// Create Date: 01/19/2023 03:07:46 PM
// Module Name: PC
// Project Name: Program Counter
// Target Devices: Basys3
// Description: A program counter with a synchronous reset and a write enable in.
// 
//////////////////////////////////////////////////////////////////////////////////


module PC(
    input PC_WRITE,
    input PC_RST,
    input [31:0] PC_DIN,
    input clk,
    output logic [31:0] PC_COUNT
    );
    
    always @ (posedge clk) begin
        if (PC_RST == 1'b1) 
            PC_COUNT <= 0;
        else if (PC_WRITE == 1'b1)
            PC_COUNT <= PC_DIN;
    end
  
endmodule
