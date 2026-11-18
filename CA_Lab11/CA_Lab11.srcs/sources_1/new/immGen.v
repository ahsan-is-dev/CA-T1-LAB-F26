`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 10:03:36 AM
// Design Name: 
// Module Name: immGen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module immGen(
    input [31:0] inst,
    output reg [31:0] imm_out
);
    wire [6:0] opcode = inst[6:0];

    always @(*) begin
        case(opcode)
            // I-Type Immediate
            7'b0010011, 7'b0000011, 7'b1100111: 
                imm_out = {{20{inst[31]}}, inst[31:20]};
                
            // S-Type Immediate
            7'b0100011: 
                imm_out = {{20{inst[31]}}, inst[31:25], inst[11:7]};
                
            // B-Type Immediate
            7'b1100011: 
                // Extracts the 12-bit immediate and sign-extends it.
                // The shift left by 1 is handled in the branchAdder[cite: 2].
                imm_out = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8]};
                
            default: 
                imm_out = 32'b0;
        endcase
    end
endmodule
