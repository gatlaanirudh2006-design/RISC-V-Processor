`timescale 1ns / 1ps
module register_file (
    input clk,
    input reset,
    input tick,
    input reg_write,
    input [4:0] rs1, rs2, rd,
    input [31:0] write_data,
    output [31:0] read_data1, read_data2,
    output [31:0] debug_x3
);
    reg [31:0] regs [0:31];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) regs[i] = 32'b0;
    end

    assign read_data1 = (rs1 == 0) ? 32'b0 : regs[rs1];
    assign read_data2 = (rs2 == 0) ? 32'b0 : regs[rs2];
    assign debug_x3 = regs[3];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) regs[i] <= 32'b0;
        end else if (tick && reg_write && rd != 0) begin
            regs[rd] <= write_data;
        end
    end
endmodule
