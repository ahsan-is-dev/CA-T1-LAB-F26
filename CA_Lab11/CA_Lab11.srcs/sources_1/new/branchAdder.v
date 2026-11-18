`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 09:55:18 AM
// Design Name: 
// Module Name: branchAdder
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


module branchAdder(
    input [31:0] pc,
    input [31:0] imm,
    output [31:0] branch_target
);
    // branchAdder must compute PC + (sign-extended immediate << 1).
    assign branch_target = pc + (imm << 1);
endmodule
