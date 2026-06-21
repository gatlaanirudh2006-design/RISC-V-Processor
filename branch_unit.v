`timescale 1ns / 1ps

module branch_unit (
    input [31:0] rs1, rs2,
    input [2:0] funct3,
    output reg branch_taken
);
    wire signed [31:0] rs1_s = rs1;
    wire signed [31:0] rs2_s = rs2;

    always @(*) begin
        case (funct3)
            3'b000: branch_taken = (rs1 == rs2);
            3'b001: branch_taken = (rs1 != rs2);
            3'b100: branch_taken = (rs1_s < rs2_s);
            3'b101: branch_taken = (rs1_s >= rs2_s);
            3'b110: branch_taken = ($unsigned(rs1) < $unsigned(rs2));
            3'b111: branch_taken = ($unsigned(rs1) >= $unsigned(rs2));
            default: branch_taken = 1'b0;
        endcase
    end
endmodule
