module alu16_two_mux (
    input  logic [9:0]   instr10,
    input  logic [15:0]  rf_src1,
    input  logic [15:0]  rf_src2,
    input  logic         MUX_alu1,
    input  logic         MUX_alu2,
    input  logic [1:0]   FUNC_alu,
    output logic [15:0]  alu_out,
    output logic         eq
);
    wire [15:0] imm7_se   = {{9{instr10[6]}}, instr10[6:0]};
    wire [15:0] imm10_lsh6 = {instr10, 6'b0};
    wire [15:0] src1 = (MUX_alu1) ? imm10_lsh6 : rf_src1;
    wire [15:0] src2 = (MUX_alu2) ? imm7_se : rf_src2;
    assign eq = (src1 == src2);
    localparam ALU_ADD   = 2'b00;
    localparam ALU_NAND  = 2'b01;
    localparam ALU_PASS1 = 2'b10;
    localparam ALU_EQL   = 2'b11;
    always_comb begin
        unique case (FUNC_alu)
            ALU_ADD:   alu_out = src1 + src2;
            ALU_NAND:  alu_out = ~(src1 & src2);
            ALU_PASS1: alu_out = src1;
            ALU_EQL:   alu_out = 16'h0000;
            default:   alu_out = 16'h0000;
        endcase
    end
endmodule