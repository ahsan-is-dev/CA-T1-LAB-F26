`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 09:24:04 AM
// Design Name: 
// Module Name: ALU_tb
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


`timescale 1ns / 1ps

module ALU_tb();
    reg [31:0] A, B;
    reg [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire Zero;

    // Instantiate the Unit Under Test (UUT)
    ALU uut (
        .A(A), 
        .B(B), 
        .ALUControl(ALUControl), 
        .ALUResult(ALUResult), 
        .Zero(Zero)
    );

    initial begin
        // Initialize Inputs
        A = 32'h10101010;
        B = 32'h01010101;
        
        // Test ADD
        ALUControl = 4'b0000; #10;
        
        // Test SUB
        ALUControl = 4'b0001; #10;
        
        // Test AND
        ALUControl = 4'b0010; #10;
        
        // Test OR
        ALUControl = 4'b0011; #10;
        
        // Test XOR
        ALUControl = 4'b0100; #10;
        
        // Test SLL (Shift by 1)
        B = 32'h00000001; 
        ALUControl = 4'b0101; #10;
        
        // Test SRL (Shift by 1)
        ALUControl = 4'b0110; #10;
        
        // Test BEQ (Zero Flag triggers)
        B = 32'h01010101;
        ALUControl = 4'b0001; #10; // SUB should yield ALUResult = 0, Zero = 1
        
        $finish;
    end
endmodule
