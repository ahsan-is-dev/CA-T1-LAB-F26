`timescale 1ns / 1ps

module MemorySystem_tb;
    reg clk;
    reg rst;
    reg [31:0] address;
    reg readEnable, writeEnable;
    reg [31:0] writeData;
    reg [15:0] switches;

    wire [31:0] readData;
    wire [15:0] leds;

    addressDecoderTop uut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .switches(switches),
        .readData(readData),
        .leds(leds)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1;
        address = 0; readEnable = 0; writeEnable = 0; writeData = 0;
        switches = 16'hA5A5;
        #20 rst = 0;

        // 1. Write 0xDEADBEEF to Data Memory (Address 0x004)
        #10 address = 32'h0000_0004; writeData = 32'hDEAD_BEEF; writeEnable = 1;
        #10 writeEnable = 0;

        // 2. Read from Data Memory (Address 0x004)
        #10 address = 32'h0000_0004; readEnable = 1;
        #10 readEnable = 0;

        // 3. Write 0xCAFE to LEDs (Address 0x100)
        #10 address = 32'h0000_0100; writeData = 32'h0000_CAFE; writeEnable = 1;
        #10 writeEnable = 0;

        // 4. Read from Switches (Address 0x200)
        #10 switches = 16'hF00D;
        address = 32'h0000_0200; readEnable = 1;
        #20 readEnable = 0;

        #20 $finish;
    end
endmodule