`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 09:53:54 AM
// Design Name: 
// Module Name: pcAdder
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


module pcAdder(
    input [31:0] pc,
    output [31:0] next_sequential_pc
);
    // pcAdder must add a constant value of 4 to the PC.
    assign next_sequential_pc = pc + 32'd4;
endmodule
