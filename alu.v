`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.06.2026 11:44:52
// Design Name: 
// Module Name: alu
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


module alu (
    input [31:0] src_a, src_b,
    input [3:0] alu_ctrl,
    output reg [31:0] result,
    output zero
);
    always @(*) begin
        case (alu_ctrl)
            4'b0000: result = src_a + src_b;
            4'b0001: result = src_a - src_b;
            4'b0010: result = src_a << src_b[4:0];
            4'b0011: result = ($signed(src_a) < $signed(src_b)) ? 32'd1 : 32'd0;
            4'b0100: result = ($unsigned(src_a) < $unsigned(src_b)) ? 32'd1 : 32'd0;
            4'b0101: result = src_a ^ src_b;
            4'b0110: result = src_a >> src_b[4:0];
            4'b0111: result = $signed(src_a) >>> src_b[4:0];
            4'b1000: result = src_a | src_b;
            4'b1001: result = src_a & src_b;
            default: result = 32'b0;
        endcase
    end
    assign zero = (result == 32'b0);
endmodule
