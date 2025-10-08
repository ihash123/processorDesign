module register_file (
    input  clk,

    // control signals
    input [1:0] MUX_tgt,
    input MUX_rf,
    input WE_rf,

    // Data sources for write-back
    input [15:0] alu_out,
    input [15:0] mem_out,
    input [15:0] pc,

    // Instruction
    input [15:0] instruction,

    output [15:0] reg_out1,
    output [15:0] reg_out2
);

    reg [15:0] register_file [0:7];

    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) register_file[i] = 16'd0;
    end

    reg [2:0] opcode;
    reg [2:0] rA, rB, rC;

    always @(*) begin
        opcode = instruction[15:13];
        rA     = instruction[12:10];
        rB     = instruction[9:7];
        rC     = instruction[2:0];  // rC is in the lower 3 bits
    end

    assign reg_out1 = register_file[rB];
    assign reg_out2 = (MUX_rf == 1'b0) ? register_file[rC] : register_file[rA];

    reg [15:0] pc_plus1;
    reg [15:0] write_data;

    always @(*) pc_plus1 = pc + 16'd1;

    always @(*) begin
        case (MUX_tgt)
            2'b00: write_data = mem_out;
            2'b01: write_data = alu_out;
            2'b10: write_data = pc_plus1;
            default: write_data = alu_out;
        endcase
    end

    always @(posedge clk) begin
        register_file[0] <= 16'd0;

        if (WE_rf && (rA != 3'd0)) begin
            register_file[rA] <= write_data;
        end
    end

endmodule
