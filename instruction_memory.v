`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.06.2026 11:37:54
// Design Name: 
// Module Name: instruction_memory
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
