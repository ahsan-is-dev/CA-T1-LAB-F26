`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 08:52:42 AM
// Design Name: 
// Module Name: int_TB
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

module int_TB;

    // Clock and Reset
    reg clk;
    reg rst;

    // Register File Control Signals
    reg WriteEnable;
    reg [4:0] rs1, rs2, rd;
    
    // ALU Control Signal
    reg [3:0] ALUControl;

    // Data Routing Signals
    reg [31:0] tb_WriteData;  // Constants supplied directly by the testbench
    reg use_alu_result;       // MUX control: 0 = write constant, 1 = write ALU result

    // Interconnect Wires
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] ALUResult;
    wire Zero;
    
    // Multiplexer to choose what data gets written into the Register File
    wire [31:0] WriteData_in = use_alu_result ? ALUResult : tb_WriteData;

    // 1. Instantiate the Register File
    REG_FIlE rf (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData_in),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // 2. Instantiate the ALU
    ALU alu (
        .A(ReadData1),
        .B(ReadData2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // 3. FSM State Definitions
    localparam INIT        = 3'd0,
               LOAD_X1     = 3'd1,
               LOAD_X2     = 3'd2,
               ALU_ADD     = 3'd3,
               ALU_SUB     = 3'd4,
               CHECK_ZERO  = 3'd5,
               DONE        = 3'd6;
               
    reg [2:0] state;

    // Clock Generation
    always #5 clk = ~clk;

    // FSM State Transition Logic
    always @(posedge clk) begin
        if (rst) begin
            state <= INIT;
        end else begin
            case (state)
                INIT:        state <= LOAD_X1;
                LOAD_X1:     state <= LOAD_X2;
                LOAD_X2:     state <= ALU_ADD;
                ALU_ADD:     state <= ALU_SUB;
                ALU_SUB:     state <= CHECK_ZERO;
                CHECK_ZERO:  state <= DONE;
                DONE:        state <= DONE;
                default:     state <= INIT;
            endcase
        end
    end

    // FSM Output Logic (What happens in each state)
    always @(*) begin
        // Default safe values to prevent latches
        WriteEnable = 0; rs1 = 0; rs2 = 0; rd = 0; 
        ALUControl = 4'b0000; tb_WriteData = 32'h0; use_alu_result = 0;

        case (state)
            LOAD_X1: begin
                // Write 10 into register x1
                WriteEnable = 1; rd = 5'd1; tb_WriteData = 32'd10; use_alu_result = 0;
            end
            LOAD_X2: begin
                // Write 5 into register x2
                WriteEnable = 1; rd = 5'd2; tb_WriteData = 32'd5; use_alu_result = 0;
            end
            ALU_ADD: begin
                // Read x1 and x2, ADD them, write result (15) into x3
                rs1 = 5'd1; rs2 = 5'd2;
                ALUControl = 4'b0000; // ADD operation
                WriteEnable = 1; rd = 5'd3;
                use_alu_result = 1;   // Route ALU result to RF write port
            end
            ALU_SUB: begin
                // Read x1 and x2, SUB them, write result (5) into x4
                rs1 = 5'd1; rs2 = 5'd2;
                ALUControl = 4'b0001; // SUB operation
                WriteEnable = 1; rd = 5'd4;
                use_alu_result = 1;
            end
            CHECK_ZERO: begin
                // Read x1 and x1, SUB them. Result is 0, Zero flag should be 1.
                rs1 = 5'd1; rs2 = 5'd1;
                ALUControl = 4'b0001; // SUB operation
                WriteEnable = 1; rd = 5'd5; // Write 0 into x5
                use_alu_result = 1;
            end
        endcase
    end

    // Testbench Execution
    initial begin
        clk = 0;
        rst = 1;
        #10;
        rst = 0;
        
        // Let the FSM run through all states
        #70;
        $finish;
    end

endmodule
