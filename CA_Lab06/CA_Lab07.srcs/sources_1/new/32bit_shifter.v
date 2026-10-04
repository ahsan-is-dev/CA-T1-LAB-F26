`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 10:46:04 AM
// Design Name: 
// Module Name: 32bit_shifter
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


module shifter_32bit (
    input [31:0] a,
    input [4:0] shamt, // Shift amount (lower 5 bits of B operand)
    input is_srl,      // 0 for SLL, 1 for SRL
    output reg [31:0] result
);
    always @(*) begin
        if (is_srl)
            result = a >> shamt; // Logical Right Shift
        else
            result = a << shamt; // Logical Left Shift
    end
endmodule
