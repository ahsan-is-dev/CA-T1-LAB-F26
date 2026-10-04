`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Habib Univerity
// Engineer: Mustafa, Ahsan, Ibneali
// 
// Create Date: 10/01/2026 10:32:14 AM
// Design Name: 
// Module Name: ALU_1bit
// Project Name: ALU Design
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

module alu_1bit (
    input a, 
    input b,
    input ainvert, 
    input bnegate,
    input cin,
    input [2:0] operation,
    output reg result,
    output cout
);

    // Input inversion muxes
    wire a_mux = ainvert ? ~a : a;
    wire b_mux = bnegate ? ~b : b; // Used for logical ops
    
    // Wires to connect outputs of operation modules
    wire addsub_out, and_out, or_out, xor_out;
    
    // Instantiate separate operation modules
    adder_subtractor addsub_inst (
        .a(a_mux), .b(b), .bnegate(bnegate), .cin(cin), 
        .result(addsub_out), .cout(cout)
    );
    
    and_1bit and_inst (.a(a_mux), .b(b_mux), .result(and_out));
    or_1bit  or_inst  (.a(a_mux), .b(b_mux), .result(or_out));
    xor_1bit xor_inst (.a(a_mux), .b(b_mux), .result(xor_out));

    // The 'set' signal is used by the MSB to feed the 'less' input of LSB
    //assign set = addsub_out; 

    // Final operation selection multiplexer
    always @(*) begin
        case(operation)
            3'b000: result = and_out;
            3'b001: result = or_out;
            3'b010: result = addsub_out;
            //3'b011: result = less;
            3'b100: result = xor_out;
            default: result = 1'b0;
        endcase
    end
endmodule
