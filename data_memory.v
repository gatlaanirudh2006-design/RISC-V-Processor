`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.06.2026 11:49:54
// Design Name: 
// Module Name: data_memory
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

module data_memory (
    input clk,
    input mem_read,
    input mem_write,
    input [2:0] funct3,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data,
    output [31:0] debug_mem0
);
    // Use 128 words (512 bytes) - enough for demo
    (* ram_style = "block" *) reg [31:0] mem [0:127];
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1) mem[i] = 32'b0;
    end
    assign debug_mem0 = mem[0];

    wire [6:0] word_addr = address[7:2];   // 128 words
    wire [1:0] byte_offset = address[1:0];

    // Write - no tick, no reset - infers BRAM
    always @(posedge clk) begin
        if (mem_write) begin
            case (funct3)
                3'b000: begin // SB
                    case (byte_offset)
                        2'b00: mem[word_addr][7:0]   <= write_data[7:0];
                        2'b01: mem[word_addr][15:8]  <= write_data[7:0];
                        2'b10: mem[word_addr][23:16] <= write_data[7:0];
                        2'b11: mem[word_addr][31:24] <= write_data[7:0];
                    endcase
                end
                3'b001: begin // SH
                    if (byte_offset == 2'b00)
                        mem[word_addr][15:0] <= write_data[15:0];
                    else if (byte_offset == 2'b10)
                        mem[word_addr][31:16] <= write_data[15:0];
                end
                3'b010: begin // SW
                    mem[word_addr] <= write_data;
                end
                default: ;
            endcase
        end
    end

    // Read - combinational
    always @(*) begin
        if (mem_read) begin
            case (funct3)
                3'b000: begin // LB (sign-extend)
                    case (byte_offset)
                        2'b00: read_data = {{24{mem[word_addr][7]}}, mem[word_addr][7:0]};
                        2'b01: read_data = {{24{mem[word_addr][15]}}, mem[word_addr][15:8]};
                        2'b10: read_data = {{24{mem[word_addr][23]}}, mem[word_addr][23:16]};
                        2'b11: read_data = {{24{mem[word_addr][31]}}, mem[word_addr][31:24]};
                    endcase
                end
                3'b001: begin // LH (sign-extend)
                    if (byte_offset == 2'b00)
                        read_data = {{16{mem[word_addr][15]}}, mem[word_addr][15:0]};
                    else if (byte_offset == 2'b10)
                        read_data = {{16{mem[word_addr][31]}}, mem[word_addr][31:16]};
                    else
                        read_data = 32'b0;
                end
                3'b010: read_data = mem[word_addr];
                3'b100: begin // LBU (zero-extend)
                    case (byte_offset)
                        2'b00: read_data = {24'b0, mem[word_addr][7:0]};
                        2'b01: read_data = {24'b0, mem[word_addr][15:8]};
                        2'b10: read_data = {24'b0, mem[word_addr][23:16]};
                        2'b11: read_data = {24'b0, mem[word_addr][31:24]};
                    endcase
                end
                3'b101: begin // LHU (zero-extend)
                    if (byte_offset == 2'b00)
                        read_data = {16'b0, mem[word_addr][15:0]};
                    else if (byte_offset == 2'b10)
                        read_data = {16'b0, mem[word_addr][31:16]};
                    else
                        read_data = 32'b0;
                end
                default: read_data = 32'b0;
            endcase
        end else begin
            read_data = 32'b0;
        end
    end
endmodule
