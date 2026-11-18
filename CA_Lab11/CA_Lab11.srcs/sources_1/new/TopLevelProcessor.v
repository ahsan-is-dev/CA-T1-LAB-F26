`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 11:30:23 AM
// Design Name: 
// Module Name: TopLevelProcessor
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

module TopLevelProcessor (
    input clk,
    input rst,
    input [15:0] switches, 
    output [15:0] leds     
);

    // ==========================================
    // 1. Wire Declarations
    // ==========================================
    wire [31:0] PC, PC_Next, PC_Plus_4, PC_Target;
    wire [31:0] Instruction;
    
    // Control Signals
    wire RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;
    wire PCSrc;
    
    // Register File & ALU Wires
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] Result; 
    wire [31:0] ImmExt;
    wire [31:0] ALU_SrcB;
    wire [31:0] ALUResult;
    wire Zero;
    
    // Memory I/O Wires
    wire [31:0] MemReadData;

    // ==========================================
    // 2. PC & Instruction Fetch (Task 1 Modules)
    // ==========================================
    assign PCSrc = Branch & Zero;
    
    mux2 pc_mux (
        .in0(PC_Plus_4),
        .in1(PC_Target),
        .sel(PCSrc),
        .out(PC_Next)
    );

    ProgramCounter pc_inst (
        .clk(clk),
        .reset(rst),
        .next_pc(PC_Next),
        .pc(PC)
    );

    pcAdder pc_add_4 (
        .pc(PC),
        .next_sequential_pc(PC_Plus_4)
    );

    branchAdder branch_add (
        .pc(PC),
        .imm(ImmExt),     
        .branch_target(PC_Target)
    );

    // Instantiating the Lab 10 instruction memory
    instructionMemory #(31) imem (
        .instAddress(PC),
        .instruction(Instruction)
    );

    // ==========================================
    // 3. Instruction Decode & Control (Lab 9)
    // ==========================================
    MainControl main_ctrl (
        .opcode(Instruction[6:0]),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch)
    );

    ALUControlUnit alu_ctrl (
        .ALUOp(ALUOp),
        .funct3(Instruction[14:12]),
        .funct7(Instruction[31:25]), 
        .ALUControl(ALUControl)
    );

    // ==========================================
    // 4. Register File & Immediate Gen (Lab 7 / Task 1)
    // ==========================================
    REG_FIlE rf (
        .clk(clk),
        .rst(rst),
        .WriteEnable(RegWrite),
        .rs1(Instruction[19:15]),
        .rs2(Instruction[24:20]),
        .rd(Instruction[11:7]),
        .WriteData(Result),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    immGen imm_generator (
        .inst(Instruction),
        .imm_out(ImmExt)
    );

    // ==========================================
    // 5. ALU Execution (Lab 6)
    // ==========================================
    mux2 alusrc_mux (
        .in0(ReadData2),
        .in1(ImmExt),
        .sel(ALUSrc),
        .out(ALU_SrcB)
    );

    ALU alu_inst (
        .A(ReadData1),
        .B(ALU_SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // ==========================================
    // 6. Memory & Peripheral I/O (Lab 8)
    // ==========================================
    addressDecoderTop memory_io_system (
        .clk(clk),
        .rst(rst),
        .address(ALUResult),       
        .readEnable(MemRead),
        .writeEnable(MemWrite),
        .writeData(ReadData2),     
        .switches(switches),       
        .readData(MemReadData),
        .leds(leds)                
    );

    // ==========================================
    // 7. Write Back Stage
    // ==========================================
    mux2 memtoreg_mux (
        .in0(ALUResult),
        .in1(MemReadData),
        .sel(MemtoReg),
        .out(Result)
    );

endmodule
