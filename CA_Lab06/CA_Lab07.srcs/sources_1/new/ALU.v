`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 08:59:28 AM
// Design Name: 
// Module Name: ALU
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

module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUControl,
    output [31:0] ALUResult,
    output Zero
);

    wire ainvert, bnegate;
    wire [2:0] operation;
    wire is_shift;
    wire is_srl;
    
    wire [31:0] carry;
    wire [31:0] alu_slice_result;
    wire [31:0] shift_result;

    // 1. Control Decoder (Updated for your testbench mapping)
    assign ainvert = 1'b0; 
    assign bnegate = (ALUControl == 4'b0001); // SUB is now 0001
    
    assign operation = (ALUControl == 4'b0010) ? 3'b000 : // AND
                       (ALUControl == 4'b0011) ? 3'b001 : // OR
                       (ALUControl == 4'b0000) ? 3'b010 : // ADD
                       (ALUControl == 4'b0001) ? 3'b010 : // SUB
                       (ALUControl == 4'b0100) ? 3'b100 : // XOR
                       3'b000;
                       
    assign is_shift = (ALUControl == 4'b0101) | (ALUControl == 4'b0110); // SLL or SRL
    assign is_srl   = (ALUControl == 4'b0110); // SRL
    

    // 2. Instantiate 32 1-bit ALU slices
    // ALU0 (LSB)
    alu_1bit alu0 (
        .a(A[0]), .b(B[0]), 
        .ainvert(ainvert), .bnegate(bnegate), 
        .cin(bnegate), // bnegate acts as +1 for 2's complement SUB
        .operation(operation), 
        .result(alu_slice_result[0]), 
        .cout(carry[0])
    );

    // ALU1 to ALU30
    genvar i;
    generate
        for (i = 1; i < 31; i = i + 1) begin : alu_chain
            alu_1bit alu_inst (
                .a(A[i]), .b(B[i]), 
                .ainvert(ainvert), .bnegate(bnegate), 
                .cin(carry[i-1]), 
                .operation(operation), 
                .result(alu_slice_result[i]), 
                .cout(carry[i])
            );
        end
    endgenerate

    // ALU31 (MSB)
    alu_1bit alu31 (
        .a(A[31]), .b(B[31]), 
        .ainvert(ainvert), .bnegate(bnegate), 
        .cin(carry[30]), 
        .operation(operation), 
        .result(alu_slice_result[31]), 
        .cout(carry[31])
    );

    // 3. Instantiate the 32-bit Shifter
    shifter_32bit shifter_inst (
        .a(A),
        .shamt(B[4:0]), 
        .is_srl(is_srl),
        .result(shift_result)
    );

    // 4. Final Output Mux & Zero Flag
    // Select between shift result and arithmetic/logic result
    assign ALUResult = is_shift ? shift_result : alu_slice_result;
    
    // Zero flag generation required by lab manual[cite: 2]
    assign Zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;

endmodule
    

