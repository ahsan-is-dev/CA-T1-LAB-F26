module Task1_tb();
    reg clk, reset, PCSrc;
    reg [31:0] instruction;
    reg [15: 0] sw;
    wire [15: 0] leds;
    
    wire [31:0] current_pc, next_pc, pc_plus_4, branch_target, imm_val;
    
    
    
    TopLevelProcessor dut(
     .clk(clk),
     .rst(reset),
     .switches(sw), 
     .leds(leds)     
);

//    // 1. Instantiate Program Counter
//    ProgramCounter pc_inst(
//        .clk(clk), .reset(reset), .next_pc(next_pc), .pc(current_pc)
//    );

//    // 2. Instantiate PC + 4 Adder
//    pcAdder pc_add_inst(
//        .pc(current_pc), .next_sequential_pc(pc_plus_4)
//    );

//    // 3. Instantiate Immediate Generator
//    immGen imm_gen_inst(
//        .inst(instruction), .imm_out(imm_val)
//    );

//    // 4. Instantiate Branch Adder
//    branchAdder branch_add_inst(
//        .pc(current_pc), .imm(imm_val), .branch_target(branch_target)
//    );

//    // 5. Instantiate Mux for PC selection
//    mux2 pc_mux(
//        .in0(pc_plus_4), .in1(branch_target), .sel(PCSrc), .out(next_pc)
//    );

    // Clock generation and test stimulus
    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

    initial begin
//        reset = 1; PCSrc = 0; instruction = 32'b0;
        reset = 1; sw = 0;
        #10 reset = 0;
        
        // Test 1: PC increments correctly by 4 when PCSrc = 0[cite: 2].
        // Expect PC to go 0 -> 4 -> 8
        sw = 5;
        #20;
        
        // Test 2: Immediate generation produces correct signed values[cite: 2].
        // B-Type instruction example (e.g., branch forward by 8 bytes)
        // Set up dummy instruction with B-type immediate representing '4' (which becomes 8 after << 1)
//        instruction = 32'b000000000000_00000_000_0100_0_1100011; 
        
        // Test 3: PC updates to branch target when PCSrc = 1[cite: 2].
//        PCSrc = 1;
        sw = 8;
        sw = 10;
        #100;
        sw = 0;
        #1000;
        $finish;
    end
endmodule