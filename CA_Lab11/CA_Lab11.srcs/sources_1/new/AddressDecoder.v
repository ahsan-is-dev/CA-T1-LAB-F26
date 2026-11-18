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