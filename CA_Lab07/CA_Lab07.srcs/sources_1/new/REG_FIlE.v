`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 09:57:13 AM
// Design Name: 
// Module Name: REG_FIlE
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


module REG_FIlE(
    input clk,
    input rst,
    input WriteEnable,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);

    reg [31:0] registers [31:0];    // 32 registers, each 32 bits wide
    integer i;
    
    always @(posedge clk) begin     // Synchronous write and reset logic
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end
        
        else if (WriteEnable && (rd != 5'b00000)) begin             // Write occurs on rising edge if WriteEnable is high AND destination is not x0
            registers[rd] <= WriteData;
        end
    end

    assign ReadData1 = (rs1 == 5'b00000) ? 32'b0 : registers[rs1];  // Ensures x0 always outputs 0, otherwise outputs the requested register value
    assign ReadData2 = (rs2 == 5'b00000) ? 32'b0 : registers[rs2];

endmodule

