`include "data_mem.sv"
`include "CSR_reg.sv"
module wb_stage (
    input logic clk,
    rst,
    mem_wr,
    mem_read,
    csr_reg_wr,
    csr_reg_r,
    is_mret,
    input logic [31:0] ALU_o,
    input logic [1:0] wb_sel,
    input logic [31:0] PC,
    data_to_mem,
    instruction,
    rdata1,
    logic [3:0] interrupt,
    output logic [31:0] wdata,
    epc,
    output logic epc_taken,
    loaded,
    output logic [31:0] result
);
  logic [31:0] mem_data, csr_read_data;
  logic [ 2:0] func3;
  logic [ 1:0] mem_col;
  logic [11:0] csr_addr;
  localparam I_type = 5'b00100;
  localparam Load_type = 5'b00000;
  localparam B_type = 5'b11000;
  localparam S_type = 5'b01000;
  localparam J_type = 5'b11011;
  localparam Jalr_type = 5'b11001;
  localparam lui_type = 5'b01101;
  localparam auipc_type = 5'b00101;
  assign func3 = instruction[14:12];
  assign mem_col = ALU_o[1:0];
  assign csr_addr = instruction[31:20];
  always_comb begin
    case (wb_sel)
      2'b00:   wdata = PC + 4;
      2'b01:   wdata = ALU_o;
      2'b10:   wdata = mem_data;
      2'b11:   wdata = csr_read_data;
      default: wdata = 'x;
    endcase
  end
  always_ff @(posedge clk) begin
    if (wb_sel == 2'b01) loaded <= 1'b0;
    else loaded <= loaded + 1'b1;
  end
  data_mem data_mem_instance (
      .clk(clk),
      .rst(rst),
      .mem_wr(mem_wr),
      .mem_read(mem_read),
      .addr(ALU_o),
      .data_wr(data_to_mem),
      .func3(func3),
      .mem_col(mem_col),
      .mem_data(mem_data),
      .result(result)
  );
  CSR_reg CSR_reg_instance (
      .clk(clk),
      .rst(rst),
      .reg_wr(csr_reg_wr),
      .reg_r(csr_reg_r),
      .PC(PC),
      .addr(csr_addr),
      .interrupt(interrupt),
      .wdata_csr(rdata1),
      .is_mret(is_mret),
      .rdata(csr_read_data),
      .epc(epc),
      .epc_taken(epc_taken)
  );
endmodule
