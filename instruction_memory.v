`timescale 1ns / 1ps
module instruction_memory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] rom [0:255];
    initial begin
        $readmemh("program.mem", rom);
    end
    assign instruction = rom[address[9:2]];
endmodule
