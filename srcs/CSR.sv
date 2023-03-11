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
    output logic CSR_MSTATUS,
    output logic [31:0] CSR_MEPC,
    output logic [31:0] CSR_MTVEC,
    output logic [31:0] RD
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
    
    always_comb begin
        case(ADDR)
            // MTVEC
            12'h305:
                RD = csr_ram[0];
            // MSTATUS
            12'h300:
                RD = csr_ram[1];
            12'h341:
                RD = csr_ram[2];
        endcase
        CSR_MSTATUS = csr_ram[1][3];
    end
            
    always_ff @ (posedge CLK) begin
    
        if (RST == 1'b1) begin
            int i;
            for (i = 0; i < 3; i = i + 1) begin
                csr_ram[i] = 0;
            end
        end

        // Setting up ISR
        if (WR_EN == 1'b1) begin
            // Load into MTVEC reg.
            if (ADDR == 12'h305) begin
                csr_ram[0] <= WD;
            end
            // Enable interrupts.
            if (ADDR == 12'h300) begin
                csr_ram[1] <= WD;
            end
            // MEPC
            if (ADDR == 12'h341) begin
                csr_ram[2] <= WD;
            end
        end
        
        // Running an interrupt.
        if (INT_TAKEN == 1'b1) begin
            // Save PC to MEPC.
            csr_ram[2] <= PC;
            // Copy MIE bit to MPIE bit.
            csr_ram[1][7] <= csr_ram[1][3];
            // Clear the MIE bit.
            csr_ram[1][3] <= 1'b0;

            CSR_MTVEC <= csr_ram[0];
        end
        
        // MRET
        if (CSR_MRET == 1'b1) begin
            // Restore MIE bit.
            csr_ram[1][3] <= csr_ram[1][7];
            // Clear MPIE bit.
            csr_ram[1][7] <= 1'b0;
        end
    end
    
endmodule
