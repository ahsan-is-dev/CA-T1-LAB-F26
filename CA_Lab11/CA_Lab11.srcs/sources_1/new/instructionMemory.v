`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 11:26:35 AM
// Design Name: 
// Module Name: instructionMemory
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


`timescale 1ns/1ps
module instructionMemory #(
    parameter OPERAND_LENGTH = 31
)(
    input [OPERAND_LENGTH:0] instAddress,
    output reg [31:0] instruction
);

    reg [7:0] memory [0:255];
    integer i;

    initial begin
        // Clear all byte locations to 0
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 8'h00;

        // 1. SYSTEM INITIALIZATION & RESET STATE
        // 0x00: addi x2, x0, 252
        {memory[3], memory[2], memory[1], memory[0]}     = 32'h0FC00113;
        // 0x04: addi x18, x0, 512
        {memory[7], memory[6], memory[5], memory[4]}     = 32'h20000913;
        // 0x08: addi x19, x0, 256
        {memory[11], memory[10], memory[9], memory[8]}   = 32'h10000993;
        // 0x0C: addi x20, x0, 768
        {memory[15], memory[14], memory[13], memory[12]} = 32'h30000A13;
        // 0x10: addi x9, x0, 0
        {memory[19], memory[18], memory[17], memory[16]} = 32'h00000493;

        // 2. STATE S0: INPUT WAITING STATE (IDLE) - PC: 0x14
        // 0x14: addi x8, x0, 0
        {memory[23], memory[22], memory[21], memory[20]} = 32'h00000413;
        // 0x18: sw x0, 0(x19)
        {memory[27], memory[26], memory[25], memory[24]} = 32'h0009A023;
        // 0x1C: lw x5, 0(x18)
        {memory[31], memory[30], memory[29], memory[28]} = 32'h00092283;
        // 0x20: beq x5, x0, -12 (to INPUT_WAIT_STATE at 0x14)
        {memory[35], memory[34], memory[33], memory[32]} = 32'hFE028AE3;

        // 3. STATE S1: COUNTDOWN STATE (INLINED) - PC: 0x24
        // 0x24: addi x8, x0, 1
        {memory[39], memory[38], memory[37], memory[36]} = 32'h00100413;
        // 0x28: add x10, x5, x0
        {memory[43], memory[42], memory[41], memory[40]} = 32'h00028533;
        // 0x2C: addi x2, x2, -8
        {memory[47], memory[46], memory[45], memory[44]} = 32'hFF810113;
        // 0x30: sw x8, 4(x2)
        {memory[51], memory[50], memory[49], memory[48]} = 32'h00812223;
        // 0x34: sw x9, 0(x2)
        {memory[55], memory[54], memory[53], memory[52]} = 32'h00912023;
        // 0x38: add x9, x10, x0
        {memory[59], memory[58], memory[57], memory[56]} = 32'h000504B3;

        // COUNTDOWN_LOOP - PC: 0x3C
        // 0x3C: sw x9, 0(x19)
        {memory[63], memory[62], memory[61], memory[60]} = 32'h0099A023;
        // 0x40: lw x6, 0(x20)
        {memory[67], memory[66], memory[65], memory[64]} = 32'h000A2303;
        // 0x44: beq x6, x0, +8 (to START_DELAY at 0x4C)
        {memory[71], memory[70], memory[69], memory[68]} = 32'h00030463;
        // 0x48: beq x0, x0, +48 (to EXIT_COUNTDOWN at 0x78)
        {memory[75], memory[74], memory[73], memory[72]} = 32'h02000863;

        // 4. INLINED 1-SECOND DELAY & RESET POLLING - PC: 0x4C
        // START_DELAY
        // 0x4C: addi x7, x0, 1000
        {memory[79], memory[78], memory[77], memory[76]} = 32'h3E800393;
        // 0x50: slli x7, x7, 15
        {memory[83], memory[82], memory[81], memory[80]} = 32'h00F39393;

        // DELAY_LOOP - PC: 0x54
        // 0x54: beq x7, x0, +24 (to DELAY_DONE at 0x6C)
        {memory[87], memory[86], memory[85], memory[84]} = 32'h00038C63;
        // 0x58: lw x6, 0(x20)
        {memory[91], memory[90], memory[89], memory[88]} = 32'h000A2303;
        // 0x5C: beq x6, x0, +8 (to CONTINUE_DELAY at 0x64)
        {memory[95], memory[94], memory[93], memory[92]} = 32'h00030463;
        // 0x60: beq x0, x0, +24 (to EXIT_COUNTDOWN at 0x78)
        {memory[99], memory[98], memory[97], memory[96]} = 32'h00000C63;

        // CONTINUE_DELAY - PC: 0x64
        // 0x64: addi x7, x7, -1
        {memory[103], memory[102], memory[101], memory[100]} = 32'hFFF38393;
        // 0x68: beq x0, x0, -20 (to DELAY_LOOP at 0x54)
        {memory[107], memory[106], memory[105], memory[104]} = 32'hFE0006E3;

        // DELAY_DONE - PC: 0x6C
        // 0x6C: addi x9, x9, -1
        {memory[111], memory[110], memory[109], memory[108]} = 32'hFFF48493;
        // 0x70: beq x9, x0, +8 (to EXIT_COUNTDOWN at 0x78)
        {memory[115], memory[114], memory[113], memory[112]} = 32'h00048463;
        // 0x74: beq x0, x0, -56 (to COUNTDOWN_LOOP at 0x3C)
        {memory[119], memory[118], memory[117], memory[116]} = 32'hFC0004E3;

        // 5. EXIT COUNTDOWN & RESTORE STACK - PC: 0x78
        // EXIT_COUNTDOWN
        // 0x78: addi x9, x0, 0
        {memory[123], memory[122], memory[121], memory[120]} = 32'h00000493;
        // 0x7C: sw x0, 0(x19)
        {memory[127], memory[126], memory[125], memory[124]} = 32'h0009A023;
        // 0x80: lw x9, 0(x2)
        {memory[131], memory[130], memory[129], memory[128]} = 32'h00012483;
        // 0x84: lw x8, 4(x2)
        {memory[135], memory[134], memory[133], memory[132]} = 32'h00412403;
        // 0x88: addi x2, x2, 8
        {memory[139], memory[138], memory[137], memory[136]} = 32'h00810113;
        // 0x8C: beq x0, x0, -120 (to INPUT_WAIT_STATE at 0x14)
        {memory[143], memory[142], memory[141], memory[140]} = 32'hF80004E3;
    end

    // Combinational instruction fetch based on Program Counter (instAddress)
    always @(*) begin
        instruction = {
            memory[instAddress + 3],
            memory[instAddress + 2],
            memory[instAddress + 1],
            memory[instAddress]
        };
    end

endmodule
