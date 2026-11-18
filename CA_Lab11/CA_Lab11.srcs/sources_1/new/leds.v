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