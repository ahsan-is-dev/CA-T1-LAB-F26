`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 11:17:58 AM
// Design Name: 
// Module Name: switches
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


module switches (
    input  wire        clk,
    input  wire        rst,
    input  wire        readEnable,
    input  wire [15:0] switches,
    output wire  [31:0] readData
);
//    always @(posedge clk or posedge rst) begin
//        if (rst)
//            readData <= 32'd0;
//        else if (readEnable)
//            readData <= {16'd0, switches};
//    end

    assign readData = (readEnable) ? {16'd0, switches} : 32'd0;
endmodule
