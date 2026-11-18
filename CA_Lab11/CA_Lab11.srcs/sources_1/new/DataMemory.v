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