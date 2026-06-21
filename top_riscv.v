`timescale 1ns / 1ps

module top_riscv#(
// ------------------------------------------------------------
    // Tick generator: 300,000,000 cycles = 3 seconds at 100 MHz
    // ------------------------------------------------------------
parameter TICK_COUNT = 29'd300000000
)
 (
    input clk,               // 100 MHz clock (Basys 3)
    input reset,             // active-high reset (button)
    input [2:0] sw,          // SW2, SW1, SW0 on Basys 3
    output [15:0] led        // 16 LEDs LD0-LD15
);

    
    reg [28:0] clk_div;
    reg tick;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_div <= 0;
            tick    <= 1'b0;
        end else if (clk_div == TICK_COUNT - 1) begin
            clk_div <= 0;
            tick    <= 1'b1;
        end else begin
            clk_div <= clk_div + 1'b1;
            tick    <= 1'b0;
        end
    end

    // ------------------------------------------------------------
    // PC and next PC logic (enabled by tick)
    // ------------------------------------------------------------
    wire [31:0] pc_current, pc_next, pc_plus4;
    assign pc_plus4 = pc_current + 32'd4;

    pc PC (
        .clk(clk),
        .reset(reset),
        .tick(tick),
        .next_pc(pc_next),
        .pc_out(pc_current)
    );

    // ------------------------------------------------------------
    // Instruction memory (ROM) - 256 words
    // ------------------------------------------------------------
    wire [31:0] instruction;
    instruction_memory IMEM (
        .address(pc_current),
        .instruction(instruction)
    );

    // ------------------------------------------------------------
    // Decode instruction fields
    // ------------------------------------------------------------
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rd     = instruction[11:7];
    wire [2:0] funct3 = instruction[14:12];
    wire [4:0] rs1    = instruction[19:15];
    wire [4:0] rs2    = instruction[24:20];
    wire [6:0] funct7 = instruction[31:25];

    // ------------------------------------------------------------
    // Control unit
    // ------------------------------------------------------------
    wire reg_write, alu_src, mem_read, mem_write, mem_to_reg, branch, jump, jalr, lui, auipc;
    wire [1:0] alu_op;
    wire illegal_instr;
    control_unit CU (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .lui(lui),
        .auipc(auipc),
        .alu_op(alu_op),
        .illegal_instr(illegal_instr)
    );

    // ------------------------------------------------------------
    // Immediate generator (FIXED J-type)
    // ------------------------------------------------------------
    wire [31:0] imm_out;
    imm_gen IMM_GEN (
        .instr(instruction),
        .imm_out(imm_out)
    );

    // ------------------------------------------------------------
    // Register file
    // ------------------------------------------------------------
    wire [31:0] reg_data1, reg_data2, write_back_data;
    wire [31:0] debug_x3;
    register_file RF (
        .clk(clk),
        .reset(reset),
        .tick(tick),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .read_data1(reg_data1),
        .read_data2(reg_data2),
        .debug_x3(debug_x3)
    );

    // ------------------------------------------------------------
    // ALU control
    // ------------------------------------------------------------
    wire [3:0] alu_ctrl;
    alu_control ALUCTRL (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_ctrl)
    );

    // ------------------------------------------------------------
    // ALU source mux
    // ------------------------------------------------------------
    wire [31:0] alu_src_b = alu_src ? imm_out : reg_data2;

    // ------------------------------------------------------------
    // ALU
    // ------------------------------------------------------------
    wire [31:0] alu_result;
    wire zero;
    alu alu(
        .src_a(reg_data1),
        .src_b(alu_src_b),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero)
    );

    // ------------------------------------------------------------
    // Data memory
    // ------------------------------------------------------------
    wire [31:0] mem_read_data;
    wire [31:0] debug_mem0;
    data_memory DMEM (
    .clk(clk),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .funct3(funct3),
    .address(alu_result),
    .write_data(reg_data2),
    .read_data(mem_read_data),
    .debug_mem0(debug_mem0)
    );

    // ------------------------------------------------------------
    // Branch unit
    // ------------------------------------------------------------
    wire branch_taken;
    branch_unit BU (
        .rs1(reg_data1),
        .rs2(reg_data2),
        .funct3(funct3),
        .branch_taken(branch_taken)
    );

    // ------------------------------------------------------------
    // Write-back mux
    // ------------------------------------------------------------
    wire [31:0] auipc_result = pc_current + imm_out;
    assign write_back_data = lui      ? imm_out :
                             auipc    ? auipc_result :
                             jump     ? pc_plus4 :
                             jalr     ? pc_plus4 :
                             mem_to_reg ? mem_read_data :
                             alu_result;

    // ------------------------------------------------------------
    // Next PC logic
    // ------------------------------------------------------------
    wire [31:0] branch_target = pc_current + imm_out;
    wire [31:0] jump_target   = pc_current + imm_out;
    wire [31:0] jalr_target   = (reg_data1 + imm_out) & ~32'd1;

    assign pc_next = jalr     ? jalr_target :
                     jump     ? jump_target :
                     (branch && branch_taken) ? branch_target :
                     pc_plus4;

    // ------------------------------------------------------------
    // LED multiplexer (3 switches, 5 selections)
    // ------------------------------------------------------------

    reg [15:0] led_display;
always @(*) begin
    case (sw)

        // Program Counter
        3'b000: led_display = pc_current[17:2];

        // Current Instruction
        3'b001: led_display = instruction[15:0];

        // ALU Result
        3'b010: led_display = alu_result[15:0];

        // Write Back Data
       // 3'b011: led_display = write_back_data[15:0];

        // Memory[0]
    //    3'b100: led_display = debug_mem0[15:0];

        // Optional extra debug
        3'b101: led_display = RF.regs[3][15:0];   // x3
        3'b110: led_display = RF.regs[4][15:0];   // x4
        3'b111: led_display = RF.regs[13][15:0];  // x13

        default: led_display = 16'h0000;
    endcase
end
    assign led = led_display;

endmodule
