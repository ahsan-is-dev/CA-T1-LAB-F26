`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 10:19:34 AM
// Design Name: 
// Module Name: REG_FIlE_TB
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

module REG_FIlE_TB;
    reg clk;// 1. Declare inputs as 'reg' (registers) to hold values
    reg rst;
    reg WriteEnable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] WriteData;

    // 2. Declare outputs as 'wire' to observe the module
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    // 3. Instantiate the Design Under Test (DUT)
    REG_FIlE dut (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // 4. Clock Generation
    always #5 clk = ~clk; 

    // 5. Test Stimulus
    initial begin
        // Initialize all inputs to known states
        clk = 0;
        rst = 1;
        WriteEnable = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        WriteData = 0;

        // Apply reset for 10ns, then release it
        #10;
        rst = 0;
        #10;

        // Test Case 1: Write a value to a register (e.g., x5 = 0xDEADBEEF)
        WriteEnable = 1;
        rd = 5'd5;
        WriteData = 32'hDEADBEEF;
        #10; // Wait for one clock cycle to lock in the data
        WriteEnable = 0;

        // Test Case 2: Simultaneous two read ports
        rs1 = 5'd5; // Read port 1 points to x5
        rs2 = 5'd5; // Read port 2 points to x5
        #10;        // Both ReadData1 and ReadData2 should show DEADBEEF

        // Test Case 3: Attempt to write to x0
        WriteEnable = 1;
        rd = 5'd0;
        WriteData = 32'hFFFFFFFF;
        #10;
        WriteEnable = 0;
        rs1 = 5'd0; // ReadData1 should remain 00000000, not FFFFFFFF
        #10;

        // Test Case 4: Overwrite a register
        WriteEnable = 1;
        rd = 5'd5;
        WriteData = 32'h12345678;
        #10;
        WriteEnable = 0;
        rs1 = 5'd5; // ReadData1 should now reflect the overwritten value 12345678
        #10;

        // Test Case 5: Reset behavior
        rst = 1;
        #10;
        rst = 0;
        rs1 = 5'd5; // ReadData1 should return to 00000000 after reset
        #10;

        $finish; // End the simulation
    end

endmodule