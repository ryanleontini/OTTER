`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Ryan Leontini
// 
// Create Date: 02/13/2023 09:40:40 PM
// Module Name: CU_FSM
// Target Devices: Basys3
// Description: The control unit FSM for the OTTER MCU. This module has inputs RST
//		to reset the OTTER, inputs from bits 6:0 and 14:12 from the 
//		instruction machine code, and a CLK input for the system clock.
//		This module has outputs PCWrite to control whether or not the PC is 
//		incremented, regWrite to control whether or not the register file
//		writes to a register, memWE2 to control memory writing, memRDEN1 and
//		memRDEN2 to control memory reading, and reset to reset the PC. csr_WE,
//		int_taken, and mret_exec have yet to be implemented.
//
//////////////////////////////////////////////////////////////////////////////////

module CU_FSM(
    input RST,
    input [6:0] ir6_0,
    input [2:0] ir14_12,
    input CLK,
    output logic PCWrite,
    output logic regWrite,
    output logic memWE2,
    output logic memRDEN1,
    output logic memRDEN2,
    output logic reset,
    output logic csr_WE,
    output logic int_taken,
    output logic mret_exec
    );
    
    typedef enum {ST_INIT, ST_FETCH, ST_EXEC, ST_WRITEBACK} STATES;
    STATES PS, NS;
    
    // FSM State Register
    always_ff @(posedge CLK) begin
        if (RST == 1'b1)
            PS <= ST_INIT;
        else
            PS <= NS;
    end
    
    always_comb begin
        // Set all outputs to 0.
        
        PCWrite = 0;
        regWrite = 0;
        memWE2 = 0;
        memRDEN1 = 0;
        memRDEN2 = 0;
        reset = 0;
        csr_WE = 0;
        int_taken = 0;
        mret_exec = 0;
        
        case(PS)
            ST_INIT: begin
                NS = ST_FETCH;
                reset = 1'b1;
            end
            ST_FETCH: begin
                NS = ST_EXEC;
                memRDEN1 = 1'b1;
            end
            ST_EXEC: begin
                if (ir6_0 == 7'b0000011) begin
                    NS = ST_WRITEBACK;
                end
                else begin
                    NS = ST_FETCH;
                    PCWrite = 1'b1;
                    case (ir6_0)
                        // R-Type
                        7'b0110011: begin
                            regWrite = 1'b1;
                        end
                        
                        // I-Type
                        7'b0010011: begin
                            regWrite = 1'b1;
                        end
                        
                        // S-Type
                        7'b0100011: begin
                            memWE2 = 1'b1;
                        end
                        
                        // B-Type
                        7'b1100011: begin
                        end
                            
                        // U-Type (lui)
                        7'b0110111: begin
                            regWrite = 1'b1;
                        end
                            
                        // U-Type (auipc);
                        7'b0010111: begin
                            regWrite = 1'b1;
                        end
                        
                        // J-Type 
                        7'b1101111: begin
                            memRDEN1 = 1'b1;
                            
                        end
                        
                        // Default opcode?
                        default: begin
                            PCWrite = 1'b1;
                            memRDEN1 = 1'b1;
                        end
                    endcase
                end
            end
            ST_WRITEBACK: begin
                NS = ST_FETCH;
                PCWrite = 1'b1;
                regWrite = 1'b1;
            end
            default: begin
                NS = ST_INIT;
            end
        endcase                   
    end
endmodule
