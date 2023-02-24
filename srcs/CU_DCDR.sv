`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Ryan Leontini
// 
// Create Date: 02/17/2023 07:22:29 PM
// Module Name: CU_DCDR
// Target Devices: 
// Description: This design decodes machine code into controls for the OTTER. 
//		This module has inputs from bits 14:12, 30, and 6:0
// 		from the instruction machine code (ir) and inputs from the branch condition
//		generator, br_eq, br_lt, and br_ltu. This module has outputs alu_fun, alu_srcA,
//		and alu_srcB to control the alu, pcSource to control the program counter, 
//		and rf_wr_sel to control the register file.
//
//////////////////////////////////////////////////////////////////////////////////


module CU_DCDR(
    input [2:0] ir14_12,
    input ir30,
    input [6:0] ir6_0,
    input int_taken,
    input br_eq,
    input br_lt,
    input br_ltu,
    output logic [3:0] alu_fun,
    output logic [1:0] alu_srcA,
    output logic [2:0] alu_srcB,
    output logic [2:0] pcSource,
    output logic [1:0] rf_wr_sel
    );
    
    always_comb begin
        // init all values to 0
        alu_fun = 0;
        alu_srcA = 0;
        alu_srcB = 0;
        pcSource = 0;
        rf_wr_sel = 0;
        
        case(ir6_0)
            // R-Type
            7'b0110011: begin
                rf_wr_sel = 2'b11;
                case(ir14_12)
                    // add and sub
                    3'b000: begin
                        // add
                        if (ir30 == 1'b0) begin
                            alu_fun = 4'b0000;
                        end
                        // sub
                        else begin
                            alu_fun = 4'b1000;
                        end
                    end
                    // or
                    3'b110: begin
                        alu_fun = 4'b0110;
                    end
                    // and
                    3'b111: begin
                        alu_fun = 4'b0111;
                    end
                    // xor
                    3'b100: begin
                        alu_fun = 4'b0100;
                    end
                    // sll
                    3'b001: begin
                        alu_fun = 4'b0001;
                    end
                    // sra
                    3'b101: begin
                        alu_fun = 4'b1101;
                    end
                    // slt
                    3'b010: begin
                        alu_fun = 4'b0010;
                    end
                    // sltu
                    3'b011: begin
                        alu_fun = 4'b0011;
                    end
                    default: begin
                        alu_fun = 4'b1010;
                    end
                endcase
            end
            // I-Type (load)
            7'b0000011:begin
                
            end
            // I-Type (jump)
            7'b1100111: begin
                case(ir14_12)
                    // jalr
                    3'b000: begin
                        pcSource = 1;
                    end
                endcase
            end
            // I-Type (alu)
            7'b0010011: begin
                rf_wr_sel = 2'b11;
                alu_srcB = 3'b001;
                case(ir14_12)
                    // addi
                    3'b000: begin
                        alu_fun = 4'b0000;
                    end
                    // andi
                    3'b111: begin 
                        alu_fun = 4'b0111;
                    end
                    // ori
                    3'b110: begin
                        alu_fun = 4'b0110;
                    end
                    // slli
                    3'b001: begin
                        alu_fun = 4'b0001;
                    end
                    // slti
                    3'b010: begin
                        alu_fun = 4'b0010;
                    end
                    // sltiu
                    3'b011: begin
                        alu_fun = 4'b0011;
                    end
                    // srai & srli
                    3'b101: begin
                        if(ir30 == 1'b1)
                            // srai
                            alu_fun = 4'b1101;
                        else if (ir30 == 1'b0)
                            // srli
                            alu_fun = 4'b0101;
                    end
                    // xori
                    3'b100: begin
                        alu_fun = 4'b0100;
                    end
                endcase
            end
            // S-Type
            7'b0100011: begin
            end
            // B-Type
            7'b1100011: begin
                case(ir14_12)
                    // beq
                    3'b000: begin
                        // branch is equal
                        if (br_eq == 1'b1) begin
                            pcSource = 3'd2;
                        end
                        // branch not equal, ignore
                    end
                    
                    // bge
                    3'b101: begin
                        // branch if greater than or eq
                        if (br_lt == 1'b0 || br_eq == 1'b1)
                            pcSource = 3'd2;
                        // branch less than u, ignore
                    end

                    // bgeu
                    3'b111: begin
                        // branch if greater than or eq, unsigned
                        if (br_ltu == 1'b0 || br_eq == 1'b1)
                            pcSource = 3'd2;
                        // branch less than u, ignore
                    end

                    // blt
                    3'b100: begin
                        // branch is less than
                        if (br_lt == 1'b1) begin
                            pcSource = 3'd2;
                        end
                        // branch not less than, ignore
                    end

                    // bltu 
                    3'b110: begin
                        // branch is less than
                        if (br_ltu == 1'b1) begin
                            pcSource = 3'd2;
                        end
                        // branch not less than, ignore
                    end

                    // bne
                    3'b001: begin
                        // branch if not equal
                        if (br_eq == 1'b0)
                            pcSource = 3'd2;
                        // branch if equal, ignore
                    end
                endcase
            end
            // U-Type (lui)
            7'b0110111: begin
                rf_wr_sel = 2'b11;
                alu_fun = 4'b1001;
                alu_srcA = 2'b01;
            end
            // U-Type (auipc)
            7'b0010111: begin
            end
            // J-Type
            7'b1101111: begin
                // pcSource = 
            end
            default: begin
            end
        endcase
    end
            
endmodule
