`timescale 1ns / 1ps
module alu_control (
    input [1:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] alu_ctrl
);
    // Optional: validate shift immediate fields.
    // For SRLI/SRAI, funct7[6:1] must be 6'b000000 or 6'b010000 respectively.
    // If invalid, you could raise an illegal instruction signal.
    // Here we ignore this for simplicity, but the hardware works correctly for legal encodings.

    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl = 4'b0000;
            2'b01: alu_ctrl = 4'b0001;
            2'b10: begin
                case ({funct7[5], funct3})
                    4'b0_000: alu_ctrl = 4'b0000; // add
                    4'b1_000: alu_ctrl = 4'b0001; // sub
                    4'b0_001: alu_ctrl = 4'b0010; // sll
                    4'b0_010: alu_ctrl = 4'b0011; // slt
                    4'b0_011: alu_ctrl = 4'b0100; // sltu
                    4'b0_100: alu_ctrl = 4'b0101; // xor
                    4'b0_101: alu_ctrl = 4'b0110; // srl
                    4'b1_101: alu_ctrl = 4'b0111; // sra
                    4'b0_110: alu_ctrl = 4'b1000; // or
                    4'b0_111: alu_ctrl = 4'b1001; // and
                    default:  alu_ctrl = 4'b0000;
                endcase
            end
            2'b11: begin
                case (funct3)
                    3'b000: alu_ctrl = 4'b0000; // addi
                    3'b001: alu_ctrl = 4'b0010; // slli
                    3'b010: alu_ctrl = 4'b0011; // slti
                    3'b011: alu_ctrl = 4'b0100; // sltiu
                    3'b100: alu_ctrl = 4'b0101; // xori
                    3'b101: alu_ctrl = funct7[5] ? 4'b0111 : 4'b0110; // srai/srli
                    3'b110: alu_ctrl = 4'b1000; // ori
                    3'b111: alu_ctrl = 4'b1001; // andi
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            default: alu_ctrl = 4'b0000;
        endcase
    end
endmodule
