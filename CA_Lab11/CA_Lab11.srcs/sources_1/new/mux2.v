`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 10:01:09 AM
// Design Name: 
// Module Name: mux2
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


module mux2(
    input [31:0] in0, // Typically PC + 4
    input [31:0] in1, // Typically Branch Target
    input sel,        // PCSrc control signal
    output [31:0] out
);
    // mux2 must select between sequential and branch target addresses using PCSrc[cite: 2].
    assign out = sel ? in1 : in0;
endmodule
