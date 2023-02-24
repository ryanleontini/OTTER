`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Ryan Leontini
// 
// Create Date: 02/18/2023 05:08:58 PM
// Module Name: OTTER_MCU_tb
// Project Name: OTTER_MCU
// Target Devices: Basys3
// Description: A testbench for the OTTER_MCU. This testbench currently runs 3
// instruction types, R-Type, I-Type, and B-Type. The memory module
//  is loaded with 6 instructions, each pertaining to one of the previous types.
// 
//////////////////////////////////////////////////////////////////////////////////


module OTTER_MCU_tb();

    logic RST, INTR, CLK, IOBUS_WR;
    logic [31:0] IOBUS_IN, IOBUS_OUT, IOBUS_ADDR;
    
    OTTER_MCU UUT(.RST(RST), .INTR(INTR), .IOBUS_IN(IOBUS_IN), .CLK(CLK), .IOBUS_OUT(IOBUS_OUT), 
        .IOBUS_ADDR(IOBUS_ADDR), .IOBUS_WR(IOBUS_WR));
        
    initial begin 
        CLK = 0;
        #10;
    end
    
    always begin
        #5 CLK <= ~CLK;
    end
    
    initial begin
        RST = 0;
        INTR = 0;
        IOBUS_IN = 0;
        #150;
    end
    
endmodule
