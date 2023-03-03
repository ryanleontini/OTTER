`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Cal Poly
// Engineer: Ryan Leontini
// 
// Create Date: 01/30/2023 09:44:48 PM
// Module Name: ALU
// Target Devices: Basys3
// Description: An aritmetic logic unit used in the 32bit OTTER MCU.
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [31:0] srcA,
    input [31:0] srcB,
    input [3:0] alu_fun,
    output logic [31:0] result
    );
    
    always_comb begin
        case (alu_fun)
            // add
            4'b0000: result = srcA + srcB;
            // sub 
            4'b1000: result = srcA - srcB;
            // or
            4'b0110: result = srcA | srcB;
            // and
            4'b0111: result = srcA & srcB;
            // xor
            4'b0100: result = srcA ^ srcB;
            // shift right logical (srl)
            4'b0101: result = srcA >> srcB[4:0];
            // shift left logical (sll)
            4'b0001: result = srcA << srcB[4:0];
            // shift right arithmetic (sra)
            4'b1101: result = $signed(srcA) >>> srcB[4:0];
            // set if less than (slt)
            4'b0010: begin
                if ( $signed(srcA) < $signed(srcB) )
                    result = 32'd1;
                else 
                    result = 32'd0;
            end
            // set if less than unsigned (sltu)
            4'b0011: begin
                if ( srcA < srcB )
                    result = 32'd1;
                else 
                    result = 32'd0;
            end
            // load upper immediate (lui copy)
            4'b1001: result = srcA;
            default: result = 32'd42;
        endcase
    end
    
endmodule
