//`include "wb_stage.sv"
//`include "Fetch.sv"
//`include "Decode.sv"
//`include "Hazard_detection.sv"
module datapath (
    input logic clk,
    rst,
    reg_wr,
    A_sel,
    B_sel,
    mem_wr,
    mem_read,
    PC_sel,
    csr_reg_r,
    csr_reg_wr,
    is_mret,
    logic [3:0] interrupt,
    input logic [1:0] wb_sel,
    input logic [3:0] ALUctrl,
    output logic [31:0] instruction,
    output logic br_taken,
    main_flush,
    stall,
    output logic [31:0] result
);
  logic [31:0] PC_decode, PC_wb, ALU_wb, wb_data, data_to_mem, instruction_wb, rdata1_wb;
  logic [4:0] rs2, rs1, rd_wb;
  logic forw_a, forw_b, flush;
  logic [31:0] epc;
  logic epc_taken, loaded;
  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];
  assign rd_wb = instruction_wb[11:7];
  assign main_flush = flush | rst;
  Fetch Fetch (
      .clk(clk),
      .rst(rst),
      .PC_sel(PC_sel),
      .flush(main_flush),
      .stall(stall),
      .epc_taken(epc_taken),
      .epc(epc),
      .instruction_ppl(instruction),
      .PC_ppl(PC_decode),
      .ALU_o(ALU_wb)
  );
  Decode Decode_instance (
      .clk(clk),
      .rst(rst),
      .flush(main_flush),
      .stall(stall),
      .reg_wr(reg_wr),
      .A_sel(A_sel),
      .B_sel(B_sel),
      .forw_a(forw_a),
      .forw_b(forw_b),
      .instruction(instruction),
      .PC(PC_decode),
      .wdata(wb_data),
      .ALUctrl(ALUctrl),
      .br_taken(br_taken),
      .PC_ppl(PC_wb),
      .ALU_ppl(ALU_wb),
      .rdata2_forwarded_ppl(data_to_mem),
      .rdata1_forwarded_ppl(rdata1_wb),
      .instruction_ppl(instruction_wb)
  );

  wb_stage wb_stage_instance (
      .clk(clk),
      .rst(rst),
      .mem_wr(mem_wr),
      .mem_read(mem_read),
      .csr_reg_wr(csr_reg_wr),
      .csr_reg_r(csr_reg_r),
      .is_mret(is_mret),
      .ALU_o(ALU_wb),
      .wb_sel(wb_sel),
      .PC(PC_wb),
      .rdata1(rdata1_wb),
      .interrupt(interrupt),
      .data_to_mem(data_to_mem),
      .instruction(instruction_wb),
      .wb_data(wb_data),
      .epc(epc),
      .epc_taken(epc_taken),
      .loaded(loaded),
      .result(result)
  );
  Hazard_detection Hazard_detection_instance (
      .reg_wr(reg_wr),
      .mem_read(mem_read),
      .loaded(loaded),
      .PC_sel(PC_sel),
      .epc_taken(epc_taken),
      .raddr1(rs1),
      .raddr2(rs2),
      .rd_wb(rd_wb),
      .wb_sel(wb_sel),
      .forw_a(forw_a),
      .forw_b(forw_b),
      .flush(flush),
      .stall(stall)
  );
endmodule
