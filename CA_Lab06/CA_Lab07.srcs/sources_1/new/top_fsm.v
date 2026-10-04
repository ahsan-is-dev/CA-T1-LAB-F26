`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2026 11:33:29 AM
// Design Name: 
// Module Name: top_fsm
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

module top_fsm_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // Wires for Lab 5 Modules
    wire rst_clean;
    wire [31:0] switch_data; 
    reg  [31:0] led_write_data = 32'd0; 
    wire slow_clk;
    
    // Wires for ALU Connection
    wire [31:0] alu_result;
    wire alu_zero;
    reg  [3:0] alu_ctrl_reg;
  
    // 1. DEBOUNCER (Cleans up the physical reset button signal)[cite: 8]
    debouncer rst_db (
        .clk(clk),
        .pbin(pbin), 
        .pbout(rst_clean)
    ); 
    
    // 2. SWITCH READER (Uses your 'leds' module from Lab 5)[cite: 9]
    leds switch_reader (
        .clk(clk), .rst(rst_clean),
        .btns(16'd0),			
        .writeData(32'd0),			
        .writeEnable(1'b0),			
        .readEnable(1'b1),			
        .memAddress(30'd0),       
        .switches(physical_sw),		
        .readData(switch_data)		
    );
    
    // 3. LED WRITER (Uses your 'switches' module from Lab 5)[cite: 11]
    switches led_writer (
        .clk(clk), .rst(rst_clean),
        .writeData(led_write_data),
        .writeEnable(1'b1),         	
        .readEnable(1'b0), 
        .memAddress(30'd0),
        .readData(),                	
        .leds(physical_leds)      
    );
    
    // 4. CLOCK DIVIDER
    clock_divider ticker (
        .clk_in(clk),          		
        .rst(rst_clean),       		
        .clk_out(slow_clk)     		
    );

    // 5. ALU INSTANTIATION 
    // Hardcoding operands A and B as requested by the Lab 6 manual
    ALU my_alu (
        .A(32'h10101010),
        .B(32'h01010101),
        .ALUControl(alu_ctrl_reg),
        .ALUResult(alu_result),
        .Zero(alu_zero)
    );

    // 6. FSM LOGIC[cite: 10]
    reg state = 1'b0;  
	
    always @(posedge slow_clk or posedge rst_clean) begin 
        if (rst_clean == 1'b1) begin 
            state <= 1'b0;  
            led_write_data <= 32'b0; 
            alu_ctrl_reg <= 4'b0000;
        end else begin 
            case(state)
                1'b0: begin // STATE 0: Read switches
                    // Take the lowest 4 switches to act as ALUControl
                    alu_ctrl_reg <= switch_data[3:0]; 
                    state <= 1'b1; 
                end
                
                1'b1: begin // STATE 1: Write result to LEDs
                    // LED[15] = Zero Flag
                    // LED[14:0] = Lower 15 bits of ALU Result
                    led_write_data <= {16'd0, alu_zero, alu_result[14:0]};
                    state <= 1'b0; // Loop back to continuously read switches
                end
            endcase
        end
    end
	
endmodule