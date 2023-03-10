`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Ryan Leontini
// 
// Create Date: 03/09/2023 03:10:42 PM
// Module Name: CSR
// Target Devices: Basys3
//
// Description: The Control Status Register (CSR) handles interruptions for the
// OTTER_MCU. The OTTER_MCU can handle one interrupt. It contains 3 registers,
// MTVEC, which contains the address of the Interrupt Service Routine (ISR),
// MSTATUS, which controls whether interrupts are enabled or not, and MEPC, which
// holds the address of the program counter while an interrupt is running.
// 
//////////////////////////////////////////////////////////////////////////////////


module CSR(
    input RST,
    input CSR_MRET,
    input INT_TAKEN,
    input [11:0] ADDR,
    input WR_EN,
    input [31:0] PC,
    input [31:0] WD,
    input CLK,
    output CSR_MSTATUS,
    output [31:0] CSR_MEPC,
    output [31:0] CSR_MTVEC,
    output [31:0] RD
    );
    
    // Register setup
    logic [31:0] csr_ram [0:2];
    
    // reg 0 = MTVEC
    // reg 1 = MSTATUS
    // reg 2 = MEPC
    
    initial begin
        int i;
        for (i = 0; i < 3; i = i + 1) begin
            csr_ram[i] = 0;
        end
    end
    
    always_ff @ (posedge CLK) begin
        // Setting up ISR
        if (WR_EN == 1'b1) begin
            // CSRRW x0, MTVEC, t0 (Load t0 into MTVEC reg).
            if (ADDR == 12'h0x305) begin
                csr_ram[0] = WD;
            end
            // CSRRW x0, MSTATUS, t0 (Enable interrupts).
            if (ADDR == 12'h0x300) begin
                csr_ram[1][2] = 1'b1;
            end
        end
        
        // Running an interrupt.
        if (INT_TAKEN == 1'b1) begin
            // Save PC to MEPC.
            csr_ram[2] = PC;
            // Copy MIE bit to MPIE bit.
            csr_ram[1][6] = csr_ram[1][2];
            // Clear the MIE bit.
            csr_ram[1][2] = 1'b0;

            CSR_MTVEC <= csr_ram[0];
            CSR_MSTATUS <= csr_ram[0][2];
        end
        
        // MRET
        if (CSR_MRET == 1'b1) begin
            CSR_MEPC <= csr_ram[2];
            // Restore MIE bit.
            csr_ram[1][2] = csr_ram[1][6];
            // Clear MPIE bit.
            csr_ram[1][6] = 1'b0;
        end
    end
    
endmodule
