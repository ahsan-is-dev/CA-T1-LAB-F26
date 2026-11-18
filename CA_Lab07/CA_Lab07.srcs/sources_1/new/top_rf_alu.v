`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 10:09:31 AM
// Design Name: 
// Module Name: top_rf_alu
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

module top_rf_alu (
    input clk,              // 100MHz board clock
    input rst_btn,          // Physical reset button
    input step_btn,         // Physical button to advance FSM states
    input [15:0] sw,        // Switches (e.g., to manually select registers if FSM allows)
    output [15:0] led       // LEDs to show ALU result and current state
);

    // ==========================================
    // 1. Debouncers & Edge Detection
    // ==========================================
    wire debounced_rst, debounced_step;
    
    debouncer rst_debouncer (
        .clk(clk),
        .pbin(rst_btn),
        .pbout(debounced_rst)
    );

    debouncer step_debouncer (
        .clk(clk),
        .pbin(step_btn),
        .pbout(debounced_step)
    );

    // One-shot edge detector for the step button so the FSM advances only 1 state per press
    reg step_prev;
    always @(posedge clk) begin
        step_prev <= debounced_step;
    end
    wire step_pulse = debounced_step & ~step_prev;

    // ==========================================
    // 2. FSM & Control Signals
    // ==========================================
    reg [2:0] state;
    
    // 1. Rename FSM-specific registers
    reg fsm_WriteEnable;
    reg [4:0] fsm_rs1, fsm_rs2, fsm_rd;
    reg [3:0] fsm_ALUControl;
    
    reg [31:0] tb_WriteData;
    reg use_alu_result;

    // 2. Declare the final control wires/regs that connect to your modules
    reg WriteEnable;
    reg [4:0] rs1, rs2, rd;
    reg [3:0] ALUControl;

    localparam INIT       = 3'd0,
               LOAD_X1    = 3'd1,
               LOAD_X2    = 3'd2,
               ALU_ADD    = 3'd3,
               ALU_SUB    = 3'd4,
               CHECK_ZERO = 3'd5,
               DONE       = 3'd6;

    // FSM State Transition (advances on button press)
    always @(posedge clk) begin
        if (debounced_rst) begin
            state <= INIT;
        end else if (step_pulse) begin
            case (state)
                INIT:        state <= LOAD_X1;
                LOAD_X1:     state <= LOAD_X2;
                LOAD_X2:     state <= ALU_ADD;
                ALU_ADD:     state <= ALU_SUB;
                ALU_SUB:     state <= CHECK_ZERO;
                CHECK_ZERO:  state <= DONE;
                DONE:        state <= INIT; // Loop back to start
                default:     state <= INIT;
            endcase
        end
    end

    // FSM Output Logic (Using fsm_ prefixed variables)
    always @(*) begin
        // Default safe values
        fsm_WriteEnable = 0; fsm_rs1 = 0; fsm_rs2 = 0; fsm_rd = 0; 
        fsm_ALUControl = 4'b0000; tb_WriteData = 32'h0; use_alu_result = 0;

        case (state)
            LOAD_X1: begin
                fsm_WriteEnable = 1; fsm_rd = 5'd1; tb_WriteData = 32'h10101010; use_alu_result = 0;
            end
            LOAD_X2: begin
                fsm_WriteEnable = 1; fsm_rd = 5'd2; tb_WriteData = 32'h01010101; use_alu_result = 0;
            end
            ALU_ADD: begin
                fsm_rs1 = 5'd1; fsm_rs2 = 5'd2; fsm_ALUControl = 4'b0000; 
                fsm_WriteEnable = 1; fsm_rd = 5'd3; use_alu_result = 1;
            end
            ALU_SUB: begin
                fsm_rs1 = 5'd1; fsm_rs2 = 5'd2; fsm_ALUControl = 4'b0001; 
                fsm_WriteEnable = 1; fsm_rd = 5'd4; use_alu_result = 1;
            end
            CHECK_ZERO: begin
                fsm_rs1 = 5'd1; fsm_rs2 = 5'd1; fsm_ALUControl = 4'b0001; 
                fsm_WriteEnable = 1; fsm_rd = 5'd5; use_alu_result = 1;
            end
        endcase
    end

    // 3. Switch Multiplexer: Chooses between Manual Switches and FSM 
    always @(*) begin
        if (sw[15]) begin 
            // Manual Mode: sw[15] is HIGH
            WriteEnable = sw[14];
            rd          = sw[13:9];
            rs1         = sw[8:4];
            ALUControl  = sw[3:0];
            
            // Note: Since all 16 switches are used above, rs2 is hardcoded 
            // to register x2 for manual testing.
            rs2         = 5'd2; 
        end else begin    
            // FSM Mode: sw[15] is LOW
            WriteEnable = fsm_WriteEnable;
            rd          = fsm_rd;
            rs1         = fsm_rs1;
            rs2         = fsm_rs2;
            ALUControl  = fsm_ALUControl;
        end
    end
    // ==========================================
    // 3. Register File & ALU Instantiation
    // ==========================================
    wire [31:0] ReadData1, ReadData2, ALUResult;
    wire Zero;
    wire [31:0] WriteData_in = use_alu_result ? ALUResult : tb_WriteData;

    REG_FIlE rf (
        .clk(clk),
        .rst(debounced_rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData_in),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    ALU alu (
        .A(ReadData1),
        .B(ReadData2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // ==========================================
    // 4. Output Mapping (LEDs)
    // ==========================================
    // Map the bottom 3 LEDs to show the current FSM state
    // Map the upper LEDs to show the lower bits of the ALU Result and the Zero flag
//    assign led[2:0]   = state;
    assign led[14:0]  = ALUResult[14:0];
    assign led[15]    = Zero;

endmodule