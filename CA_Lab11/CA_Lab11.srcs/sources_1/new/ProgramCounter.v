module ProgramCounter(
    input clk,
    input reset,
    input [31:0] next_pc,
    output reg [31:0] pc
);
    // PC must update on every positive clock edge.
    always @(posedge clk) begin
        if (reset)
            pc <= 32'b0; // Reset PC to starting address
        else
            pc <= next_pc;
    end
endmodule