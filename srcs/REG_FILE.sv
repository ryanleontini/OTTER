`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Ryan Leontini
// 
// Create Date: 01/25/2023 07:11:04 PM
// Module Name: REG_FILE
// Target Devices: Basys3
// Description: A 32x32 REG_FILE with enable in.
// 
//////////////////////////////////////////////////////////////////////////////////


module REG_FILE(
    input [4:0] RF_ADR1,
    input [4:0] RF_ADR2,
    input RF_EN,
    input [4:0] RF_WA,
    input [31:0] RF_WD,
    input clk,
    output logic [31:0] RF_RS1,
    output logic [31:0] RF_RS2
    );
    
    logic [31:0] ram [0:31];
    
    initial begin
        int i;
        for (i = 0; i < 32; i = i + 1) begin
            ram[i] = 0;
        end
    end
    
    assign  RF_RS1 = ram[RF_ADR1];
    assign  RF_RS2 = ram[RF_ADR2];
    
    always @ (posedge clk) begin
        if (RF_EN) begin
            if (RF_WA != 1'd0) begin
                ram[RF_WA] <= RF_WD;
            end
        end
    end
    
endmodule
