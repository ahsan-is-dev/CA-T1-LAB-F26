`timescale 1ns/1ps

module instructionMemory_tb;

    // Parameters and Signals matching the reference module
    parameter OPERAND_LENGTH = 31;
    reg  [OPERAND_LENGTH:0] instAddress;
    wire [31:0]             instruction;

    // Instantiate the Unit Under Test (UUT)
    instructionMemory #(
        .OPERAND_LENGTH(OPERAND_LENGTH)
    ) uut (
        .instAddress(instAddress),
        .instruction(instruction)
    );

    integer pc;

    initial begin
        // Initialize Program Counter (PC) to 0
        instAddress = 32'h0000_0000;
        #10;

        $display("==========================================================");
        $display("  PC (Hex)  |  Instruction (Hex)  |  Stage / Label");
        $display("==========================================================");

        // Step PC by 4 bytes across all 39 instructions (0x00 to 0x98)
        for (pc = 0; pc <= 32'h98; pc = pc + 4) begin
            instAddress = pc;
            #10; // Wait 10 ns per instruction fetch
            $display("  0x%08h |     0x%08h     |  Byte Addr: %0d", instAddress, instruction, pc);
        end

        // Optional: Simulate a branch/jump sequence (e.g., S0 polling loop & subroutine call)
        #10 instAddress = 32'h0000_0014; // Jump to INPUT_WAIT_STATE (S0)
        #10 instAddress = 32'h0000_0018;
        #10 instAddress = 32'h0000_001C;
        #10 instAddress = 32'h0000_0020; // beq back to 0x14
        #10 instAddress = 32'h0000_0014; // Back at INPUT_WAIT_STATE
        #10 instAddress = 32'h0000_002C; // jal to COUNTDOWN_SUB (0x34)
        #10 instAddress = 32'h0000_0034; // First instruction of COUNTDOWN_SUB

        #20;
        $finish;
    end

endmodule