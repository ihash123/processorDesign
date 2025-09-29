module pc (
    input  logic clk,
    input  logic rst_n,

    input  logic [1:0]  MUX_output,
    input  logic signed [6:0] imm,
    input  logic [15:0] alu_out,


    output logic [15:0] pc_plus1,
    output logic [15:0] pc_plus1_imm,
    output logic [15:0] nxt_instr
);

    logic [15:0] pc_q, pc_next;
    logic signed [15:0] imm_se;
    assign imm_se = imm;

    assign pc_plus1 = pc_q + 16'd1;
    assign pc_plus1_imm  = pc_q + 16'd1 + imm_se;

    always_comb begin
        unique case (MUX_output)
            2'b00: pc_next = pc_plus1;
            2'b01: pc_next = pc_plus1_imm;
            2'b10: pc_next = alu_out;
            default: pc_next = pc_plus1;
        endcase
    end

    // Expose the registered PC value to the testbench (pc_q).
    // The testbench expects nxt_instr to reflect the stored PC, not the combinational next value.
    assign nxt_instr = pc_q;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) pc_q <= 16'd0;
        else pc_q <= pc_next;
    end

endmodule
