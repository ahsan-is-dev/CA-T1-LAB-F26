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