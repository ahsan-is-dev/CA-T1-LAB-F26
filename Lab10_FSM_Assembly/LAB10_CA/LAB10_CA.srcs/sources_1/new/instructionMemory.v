`timescale 1ns/1ps

module instructionMemory #(
    parameter OPERAND_LENGTH = 31
)(
    input  [OPERAND_LENGTH:0] instAddress,
    output reg [31:0]         instruction
);

    reg [7:0] memory [0:255];

    integer i;
    initial begin
        // Clear all byte locations to 0
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 8'h00;

        // --------------------------------------------------------------------
        // Populated Machine Code from Task 2 (Little-Endian Byte Ordering)
        // --------------------------------------------------------------------
        // 0x00: addi sp, zero, 252       (32'h0FC00113)
        {memory[3],   memory[2],   memory[1],   memory[0]}   = 32'h0FC00113;
        // 0x04: addi s2, zero, 512       (32'h20000913)
        {memory[7],   memory[6],   memory[5],   memory[4]}   = 32'h20000913;
        // 0x08: addi s3, zero, 256       (32'h10000993)
        {memory[11],  memory[10],  memory[9],   memory[8]}   = 32'h10000993;
        // 0x0C: addi s4, zero, 768       (32'h30000A13)
        {memory[15],  memory[14],  memory[13],  memory[12]}  = 32'h30000A13;
        // 0x10: addi s1, zero, 0         (32'h00000493)
        {memory[19],  memory[18],  memory[17],  memory[16]}  = 32'h00000493;

        // --- INPUT_WAIT_STATE (0x14) ---
        // 0x14: addi s0, zero, 0         (32'h00000413)
        {memory[23],  memory[22],  memory[21],  memory[20]}  = 32'h00000413;
        // 0x18: sw zero, 0(s3)           (32'h0009A023)
        {memory[27],  memory[26],  memory[25],  memory[24]}  = 32'h0009A023;
        // 0x1C: lw t0, 0(s2)             (32'h00092283)
        {memory[31],  memory[30],  memory[29],  memory[28]}  = 32'h00092283;
        // 0x20: beq t0, zero, -12        (32'hFE028AE3)
        {memory[35],  memory[34],  memory[33],  memory[32]}  = 32'hFE028AE3;

        // --- COUNTDOWN_STATE (0x24) ---
        // 0x24: addi s0, zero, 1         (32'h00100413)
        {memory[39],  memory[38],  memory[37],  memory[36]}  = 32'h00100413;
        // 0x28: add a0, t0, zero         (32'h00028533)
        {memory[43],  memory[42],  memory[41],  memory[40]}  = 32'h00028533;
        // 0x2C: jal ra, COUNTDOWN_SUB    (32'h008000EF)
        {memory[47],  memory[46],  memory[45],  memory[44]}  = 32'h008000EF;
        // 0x30: beq zero, zero, -28      (32'hFE0002E3)
        {memory[51],  memory[50],  memory[49],  memory[48]}  = 32'hFE0002E3;

        // --- COUNTDOWN_SUB (0x34) ---
        // 0x34: addi sp, sp, -12         (32'hFF410113)
        {memory[55],  memory[54],  memory[53],  memory[52]}  = 32'hFF410113;
        // 0x38: sw ra, 8(sp)             (32'h00112423)
        {memory[59],  memory[58],  memory[57],  memory[56]}  = 32'h00112423;
        // 0x3C: sw s0, 4(sp)             (32'h00812223)
        {memory[63],  memory[62],  memory[61],  memory[60]}  = 32'h00812223;
        // 0x40: sw s1, 0(sp)             (32'h00912023)
        {memory[67],  memory[66],  memory[65],  memory[64]}  = 32'h00912023;
        // 0x44: add s1, a0, zero         (32'h000504B3)
        {memory[71],  memory[70],  memory[69],  memory[68]}  = 32'h000504B3;

        // --- COUNTDOWN_LOOP (0x48) ---
        // 0x48: sw s1, 0(s3)             (32'h0099A023)
        {memory[75],  memory[74],  memory[73],  memory[72]}  = 32'h0099A023;
        // 0x4C: lw t1, 0(s4)             (32'h000A2303)
        {memory[79],  memory[78],  memory[77],  memory[76]}  = 32'h000A2303;
        // 0x50: bne t1, zero, +20        (32'h00031A63)
        {memory[83],  memory[82],  memory[81],  memory[80]}  = 32'h00031A63;
        // 0x54: jal ra, DELAY_LOOP_INIT  (32'h02C000EF)
        {memory[87],  memory[86],  memory[85],  memory[84]}  = 32'h02C000EF;
        // 0x58: bne t1, zero, +12        (32'h00031663)
        {memory[91],  memory[90],  memory[89],  memory[88]}  = 32'h00031663;
        // 0x5C: addi s1, s1, -1          (32'hFFF48493)
        {memory[95],  memory[94],  memory[93],  memory[92]}  = 32'hFFF48493;
        // 0x60: bne s1, zero, -24        (32'hFE0494E3)
        {memory[99],  memory[98],  memory[97],  memory[96]}  = 32'hFE0494E3;

        // --- EXIT_COUNTDOWN (0x64) ---
        // 0x64: addi s1, zero, 0         (32'h00000493)
        {memory[103], memory[102], memory[101], memory[100]} = 32'h00000493;
        // 0x68: sw zero, 0(s3)           (32'h0009A023)
        {memory[107], memory[106], memory[105], memory[104]} = 32'h0009A023;
        // 0x6C: lw s1, 0(sp)             (32'h00012483)
        {memory[111], memory[110], memory[109], memory[108]} = 32'h00012483;
        // 0x70: lw s0, 4(sp)             (32'h00412403)
        {memory[115], memory[114], memory[113], memory[112]} = 32'h00412403;
        // 0x74: lw ra, 8(sp)             (32'h00812083)
        {memory[119], memory[118], memory[117], memory[116]} = 32'h00812083;
        // 0x78: addi sp, sp, 12          (32'h00C10113)
        {memory[123], memory[122], memory[121], memory[120]} = 32'h00C10113;
        // 0x7C: jalr zero, ra, 0         (32'h00008067)
        {memory[127], memory[126], memory[125], memory[124]} = 32'h00008067;

        // --- DELAY_LOOP_INIT (0x80) ---
        // 0x80: lui t2, 0x262            (32'h002623B7)
        {memory[131], memory[130], memory[129], memory[128]} = 32'h002623B7;
        // 0x84: addi t2, t2, 0x5A0       (32'h5A038393)
        {memory[135], memory[134], memory[133], memory[132]} = 32'h5A038393;

        // --- DELAY_LOOP (0x88) ---
        // 0x88: lw t1, 0(s4)             (32'h000A2303)
        {memory[139], memory[138], memory[137], memory[136]} = 32'h000A2303;
        // 0x8C: bne t1, zero, +12        (32'h00031663)
        {memory[143], memory[142], memory[141], memory[140]} = 32'h00031663;
        // 0x90: addi t2, t2, -1          (32'hFFF38393)
        {memory[147], memory[146], memory[145], memory[144]} = 32'hFFF38393;
        // 0x94: bne t2, zero, -12        (32'hFE039AE3)
        {memory[151], memory[150], memory[149], memory[148]} = 32'hFE039AE3;

        // --- DELAY_EXIT (0x98) ---
        // 0x98: jalr zero, ra, 0         (32'h00008067)
        {memory[155], memory[154], memory[153], memory[152]} = 32'h00008067;
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