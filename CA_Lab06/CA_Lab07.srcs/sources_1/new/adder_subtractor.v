`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 10:22:31 AM
// Design Name: 
// Module Name: adder_subtractor
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


module adder_subtractor (
    input a, 
    input b, 
    input bnegate, 
    input cin, 
    output result, 
    output cout
);
    wire b_mux;
    
    assign b_mux = bnegate ? ~b : b;  // add or subtract?
    
    // Call the full adder
    full_adder fa (
        .a(a), 
        .b(b_mux), 
        .cin(cin), 
        .sum(result), 
        .cout(cout)
    );
endmodule
