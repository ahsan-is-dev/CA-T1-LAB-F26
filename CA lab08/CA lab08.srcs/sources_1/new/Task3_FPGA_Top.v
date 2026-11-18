`timescale 1ns / 1ps

module Task3_FPGA_Top (
    input  wire        clk,        // 100 MHz FPGA Clock
    input  wire        btnC,       // Center push button for Reset
    input  wire        btnU,       // UP push button for Write Enable
    input  wire [15:0] sw,         // 16 Slide Switches on FPGA
    output wire [15:0] led         // 16 LEDs on FPGA
);

    // 1.Deboucers
    wire rst;

    debouncer u_debouncer (
        .clk   (clk),
        .pbin  (btnC),
        .pbout (rst)
    );
    
    wire write_en_deb;
    debouncer u_debouncer_we (
        .clk   (clk),
        .pbin  (btnU),
        .pbout (write_en_deb)
    );

    // ---------------------------------------------------------
    // 2. Internal Bus Signals to/from addressDecoderTop
    // ---------------------------------------------------------
    reg  [31:0] address;
    reg         readEnable;
    reg         writeEnable;
    reg  [31:0] writeData;
    wire [31:0] readData;

    // Map Switches to Address and Data
    wire [31:0] bus_address    = {22'b0, sw[9:0]};   // Switches 0-9 for address
    wire [31:0] bus_writeData  = {26'b0, sw[15:10]}; // Switches 10-15 for data
    
    // Continuous read (optional: you could map this to another button like btnD)
    wire        bus_readEnable = 1'b1;
    
    
       // 6. Instantiate Memory System Top (addressDecoderTop)
    
    wire [31:0] readData_out; // Internal wire to catch read data
    wire [15:0] led_module_out; // New wire to catch the LED peripheral's output
    

    addressDecoderTop u_memory_system (
        .clk         (clk),
        .rst         (rst),
        .address     (bus_address),       // Driven by sw[9:0]
        .readEnable  (bus_readEnable),    // Always reading
        .writeEnable (write_en_deb),      // Driven by debounced btnU
        .writeData   (bus_writeData),     // Driven by sw[15:10]
        .switches    (sw),
        .readData    (readData_out),
        .leds        (led_module_out)
    );

   // Route the read bus directly to the physical LEDs
//    assign led = readData_out[15:0];
    assign led = (sw[9:8] == 2'b01) ? led_module_out : readData_out[15:0];  
endmodule