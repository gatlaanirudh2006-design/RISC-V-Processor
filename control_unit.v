`timescale 1ns / 1ps

module control_unit (
    input [6:0] opcode,
    output reg reg_write,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg branch,
    output reg jump,
    output reg jalr,
    output reg lui,
    output reg auipc,
    output reg [1:0] alu_op,
    output reg illegal_instr
);
    always @(*) begin
        reg_write = 0; alu_src = 0; mem_read = 0; mem_write = 0;
        mem_to_reg = 0; branch = 0; jump = 0; jalr = 0;
        lui = 0; auipc = 0; alu_op = 2'b00; illegal_instr = 0;

        case (opcode)
            7'b0110011: begin reg_write = 1; alu_op = 2'b10; end
            7'b0010011: begin reg_write = 1; alu_src = 1; alu_op = 2'b11; end
            7'b0000011: begin reg_write = 1; alu_src = 1; mem_read = 1; mem_to_reg = 1; alu_op = 2'b00; end
            7'b0100011: begin alu_src = 1; mem_write = 1; alu_op = 2'b00; end
            7'b1100011: begin branch = 1; end
            7'b1101111: begin reg_write = 1; jump = 1; alu_op = 2'b00; end
            7'b1100111: begin reg_write = 1; jalr = 1; alu_src = 1; alu_op = 2'b00; end
            7'b0110111: begin reg_write = 1; lui = 1; end
            7'b0010111: begin reg_write = 1; auipc = 1; end
            default: illegal_instr = 1;
        endcase
    end
endmodule
