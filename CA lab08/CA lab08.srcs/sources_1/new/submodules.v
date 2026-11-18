`timescale 1ns / 1ps

module debouncer (
    input  wire clk,
    input  wire pbin,
    output reg  pbout
);
    reg [19:0] count;
    reg sync_0, sync_1;

    always @(posedge clk) begin
        sync_0 <= pbin;
        sync_1 <= sync_0;
        if (sync_1 == pbout) begin
            count <= 20'd0;
        end else begin
            count <= count + 1'b1;
            if (count == 20'hFFFFF)
                pbout <= sync_1;
        end
    end
endmodule

module AddressDecoder (
    input  wire [1:0] addr_sel,
    input  wire       readEnable,
    input  wire       writeEnable,
    output reg        DataMemWrite,
    output reg        DataMemRead,
    output reg        LEDWrite,
    output reg        SwitchReadEnable
);
    always @(*) begin
        DataMemWrite     = 1'b0;
        DataMemRead      = 1'b0;
        LEDWrite         = 1'b0;
        SwitchReadEnable = 1'b0;

        case (addr_sel)
            2'b00: begin
                DataMemWrite = writeEnable;
                DataMemRead  = readEnable;
            end
            2'b01: begin
                LEDWrite     = writeEnable;
            end
            2'b10: begin
                SwitchReadEnable = readEnable;
            end
            default: begin
                DataMemWrite     = 1'b0;
                DataMemRead      = 1'b0;
                LEDWrite         = 1'b0;
                SwitchReadEnable = 1'b0;
            end
        endcase
    end
endmodule

module DataMemory (
    input  wire        clk,
    input  wire        MemWrite,
    input  wire        MemRead,
    input  wire [8:0]  address,
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);
    reg [31:0] mem [0:511];

    always @(posedge clk) begin
        if (MemWrite)
            mem[address] <= write_data;
    end

    always @(*) begin
        if (MemRead)
            read_data = mem[address];
        else
            read_data = 32'd0;
    end
endmodule

module leds (
    input  wire        clk,
    input  wire        rst,
    input  wire        writeEnable,
    input  wire [31:0] writeData,
    output reg  [15:0] leds
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            leds <= 16'd0;
        else if (writeEnable)
            leds <= writeData[15:0];
    end
endmodule

module switches (
    input  wire        clk,
    input  wire        rst,
    input  wire        readEnable,
    input  wire [15:0] switches,
    output reg  [31:0] readData
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            readData <= 32'd0;
        else if (readEnable)
            readData <= {16'd0, switches};
    end
endmodule

module addressDecoderTop (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] address,
    input  wire        readEnable,
    input  wire        writeEnable,
    input  wire [31:0] writeData,
    input  wire [15:0] switches,
    output reg  [31:0] readData,
    output wire [15:0] leds
);
    wire DataMemWrite, DataMemRead, LEDWrite, SwitchReadEnable;
    wire [31:0] dmem_out, sw_out;

    AddressDecoder u_dec (
        .addr_sel         (address[9:8]),
        .readEnable       (readEnable),
        .writeEnable      (writeEnable),
        .DataMemWrite     (DataMemWrite),
        .DataMemRead      (DataMemRead),
        .LEDWrite         (LEDWrite),
        .SwitchReadEnable (SwitchReadEnable)
    );

    DataMemory u_dmem (
        .clk        (clk),
        .MemWrite   (DataMemWrite),
        .MemRead    (DataMemRead),
        .address    (address[8:0]),
        .write_data (writeData),
        .read_data  (dmem_out)
    );

    leds u_leds (
        .clk         (clk),
        .rst         (rst),
        .writeEnable (LEDWrite),
        .writeData   (writeData),
        .leds        (leds)
    );

    switches u_sw (
        .clk        (clk),
        .rst        (rst),
        .readEnable (SwitchReadEnable),
        .switches   (switches),
        .readData   (sw_out)
    );

    always @(*) begin
        case (address[9:8])
            2'b00:   readData = dmem_out;
            2'b10:   readData = sw_out;
            default: readData = 32'd0;
        endcase
    end
endmodule