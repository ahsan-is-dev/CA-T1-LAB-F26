`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2026 09:00:29 AM
// Design Name: 
// Module Name: fsm_tb
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

module tb_top_fsm_system();
    reg clk; reg pbin;
    reg [15:0] physical_sw; wire [15:0] physical_leds;

    top_fsm_system uut ( .clk(clk), .pbin(pbin), .physical_sw(physical_sw), .physical_leds(physical_leds) );
    // Generate 100MHz clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialization
        clk = 0; pbin = 0;
        physical_sw = 16'd0;

        // press reset button
        #20 pbin = 1; 
        #20 pbin = 0;
        #50;

        // Case 01: Check transition from IDLE to Count state and if Count state ignore switches from input if not equal to 0 
        physical_sw = 16'd5;    
        #100;                   
        physical_sw = 16'd12;   
        #100;
        physical_sw = 16'd0;
        #100;
                     

        // Case 02: We input 8 into switches, wait for 150ns, then press reset to check if Reset state is working
        physical_sw = 16'd8;    
        #250;                   
        pbin = 1;               
        #50;                    
        pbin = 0;               
        physical_sw = 16'd0;    
        #100;

        // Test Case 03: Checking if when in IDLE state, giving zero as input keep FSM is IDLE or not
        physical_sw = 16'd0;    
        #150;                   

    end

endmodule
