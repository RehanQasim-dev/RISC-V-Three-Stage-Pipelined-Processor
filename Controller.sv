`include "LS_controller.sv"
`include "Pipeline_reg.sv"
module Controller (
    input clk,
    input rst,
    stall,
    input logic [31:0] instruction,
    input logic br_taken,
    flush,
    output logic [3:0] ALUctrl,
    output logic mem_wr_ppl,
    mem_read_ppl,
    output logic A_sel,
    B_sel,
    reg_wr_ppl,
    PC_sel_ppl,
    is_mret_ppl,
    csr_reg_r_ppl,
    csr_reg_wr_ppl,
    output logic [1:0] wb_sel_ppl
);
  localparam R_type = 5'b01100;
  localparam I_type = 5'b00100;
  localparam Load_type = 5'b00000;
  localparam S_type = 5'b01000;
  localparam B_type = 5'b11000;
  localparam J_type = 5'b11011;
  localparam Jalr_type = 5'b11001;
  localparam lui_type = 5'b01101;
  localparam auipc_type = 5'b00101;
  localparam csr_type = 5'b11100;
  logic [6:0] opcode;
  logic func7, func7_mret, is_mret, csr_reg_r, csr_reg_wr;
  logic [2:0] func3;
  assign func3 = instruction[14:12];
  assign opcode = instruction[6:0];
  assign func7 = instruction[30];
  assign func7_mret = instruction[29];

  logic [1:0] wb_sel;
  logic PC_sel, reg_wr, mem_wr, mem_read;
  always_comb begin
    case (opcode[6:2])
      R_type: begin
        casex ({
          func7, func3
        })
          4'b0000: ALUctrl = 4'd0;  //ADD
          4'b1000: ALUctrl = 4'd1;  //Sub
          4'bX001: ALUctrl = 4'd2;  //SLL
          4'bX010: ALUctrl = 4'd3;  //SLT
          4'bX100: ALUctrl = 4'd4;  //XOR
          4'bX011: ALUctrl = 4'd5;  //SLTU
          4'b0101: ALUctrl = 4'd6;  //SRL
          4'b1101: ALUctrl = 4'd7;  //SRA
          4'bX110: ALUctrl = 4'd8;  //OR
          4'bX111: ALUctrl = 4'd9;  //AND
          default: ALUctrl = 4'bXXXX;
        endcase
        A_sel = 1;
        PC_sel = 0;
        mem_wr = 0;
        mem_read = '0;
        B_sel = 0;
        wb_sel = 2'b01;
        reg_wr = 1;
        csr_reg_r = 1'b0;
        csr_reg_wr = 1'b0;
        is_mret = 1'b0;
      end
      I_type: begin
        casex ({
          func7, func3
        })
          4'bX000: ALUctrl = 4'd0;  //ADD
          4'bX001: ALUctrl = 4'd2;  //SLL
          4'bX010: ALUctrl = 4'd3;  //SLT
          4'bX100: ALUctrl = 4'd4;  //XOR
          4'bX011: ALUctrl = 4'd5;  //SLTU
          4'b0101: ALUctrl = 4'd6;  //SRL
          4'b1101: ALUctrl = 4'd7;  //SRA
          4'bX110: ALUctrl = 4'd8;  //OR
          4'bX111: ALUctrl = 4'd9;  //AND
          default: begin
            ALUctrl = 4'bXXXX;
            $display("run %b%b", func7, func3);
          end
        endcase
        mem_wr = 0;
        mem_read = '0;
        A_sel = 1;
        PC_sel = 0;
        B_sel = 1;
        wb_sel = 2'b01;
        reg_wr = 1;
        csr_reg_r = 1'b0;
        csr_reg_wr = 1'b0;
        is_mret = 1'b0;
      end
      Load_type: begin
        mem_wr = 0;
        mem_read = 1'b1;
        A_sel = 1;
        PC_sel = 0;
        B_sel = 1;
        wb_sel = 2'b10;
        reg_wr = 1;
        ALUctrl = 4'd0;
        csr_reg_r = 1'b0;
        csr_reg_wr = 1'b0;
        is_mret = 1'b0;
      end
      S_type: begin
        mem_wr = 1;
        mem_read = '0;
        A_sel = 1;
        PC_sel = 0;
        B_sel = 1;
        wb_sel = 'x;
        reg_wr = 0;
        ALUctrl = 4'd0;
        csr_reg_r = 1'b0;
        csr_reg_wr = 1'b0;
        is_mret = 1'b0;
      end
      B_type: begin
        mem_wr = 0;
        mem_read = '0;
        A_sel = 0;
        B_sel = 1;
        wb_sel = 'x;
        reg_wr = 0;
        ALUctrl = 4'd0;
        csr_reg_r = 1'b0;
        csr_reg_wr = 1'b0;
        is_mret = 1'b0;
        case (br_taken)
          0: PC_sel = 0;
          1: PC_sel = 1;
          default: PC_sel = 'x;
        endcase
      end
      J_type: begin
        mem_wr = 0;
        mem_read = '0;
        A_sel = 0;
        B_sel = 1;
        wb_sel = 2'b00;
        reg_wr = 1;
        ALUctrl = 4'd0;
        PC_sel = 1'b1;
        csr_reg_r = 1'b0;
        csr_reg_wr = 1'b0;
        is_mret = 1'b0;
      end
      Jalr_type: begin
        mem_wr = 0;
        mem_read = '0;
        A_sel = 1;
        B_sel = 1;
        wb_sel = 2'b00;
        reg_wr = 1'b1;
        ALUctrl = 4'd0;
        PC_sel = 1'b1;
        csr_reg_r = 1'b0;
        csr_reg_wr = 1'b0;
        is_mret = 1'b0;
      end
      lui_type: begin
        mem_wr = 0;
        mem_read = '0;
        A_sel = 1'bx;
        B_sel = 1;
        wb_sel = 2'b01;
        reg_wr = 1'b1;
        ALUctrl = 4'd10;
        PC_sel = 1'b0;
        csr_reg_r = 1'b0;
        csr_reg_wr = 1'b0;
        is_mret = 1'b0;
      end
      auipc_type: begin
        mem_wr = 0;
        mem_read = '0;
        A_sel = 0;
        B_sel = 1;
        wb_sel = 2'b01;
        reg_wr = 1;
        ALUctrl = 4'd0;
        PC_sel = 1'b0;
        csr_reg_r = 1'b0;
        csr_reg_wr = 1'b0;
        is_mret = 1'b0;
      end
      csr_type: begin
        mem_wr = 0;
        mem_read = '0;
        A_sel = 1;
        B_sel = 1'bx;
        wb_sel = 2'b11;
        reg_wr = 1'b1;
        ALUctrl = 4'd0;
        PC_sel = 1'b0;
        casex ({
          func7_mret, func3
        })
          4'b1000: begin
            csr_reg_r = 1'b0;
            csr_reg_wr = 1'b0;
            is_mret = 1'b1;
          end
          4'bx001: begin
            csr_reg_r = 1'b1;
            csr_reg_wr = 1'b1;
            is_mret = 1'b0;
          end
          default: begin
            csr_reg_r = 1'b0;
            csr_reg_wr = 1'b0;
            is_mret = 1'b0;
          end
        endcase
      end
      default: begin
        mem_wr = '0;
        mem_read = '0;
        B_sel = 'x;
        wb_sel = 'x;
        reg_wr = '0;
        ALUctrl = '0;
        PC_sel = '0;
        csr_reg_r = 1'b0;
        csr_reg_wr = 1'b0;
        is_mret = 1'b0;
      end
    endcase
  end
  // 
  Pipeline_reg #(
      .WIDTH(1),
      .reset(0)
  ) Pipeline1 (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(reg_wr),
      .out(reg_wr_ppl)
  );
  Pipeline_reg #(
      .WIDTH(1),
      .reset(0)
  ) pipeline2 (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(mem_wr),
      .out(mem_wr_ppl)
  );
  Pipeline_reg #(
      .WIDTH(2),
      .reset(0)
  ) pipeline3 (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(wb_sel),
      .out(wb_sel_ppl)
  );

  Pipeline_reg #(
      .WIDTH(1),
      .reset(0)
  ) Pipieline4 (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(PC_sel),
      .out(PC_sel_ppl)
  );
  Pipeline_reg #(
      .WIDTH(1),
      .reset(0)
  ) Pipeline_reg_instance (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(mem_read),
      .out(mem_read_ppl)
  );
  Pipeline_reg #(
      .WIDTH(1),
      .reset(0)
  ) Pipeline_ismret (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(is_mret),
      .out(is_mret_ppl)
  );
  Pipeline_reg #(
      .WIDTH(1),
      .reset(0)
  ) Pipeline_csr_reg_wr (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(csr_reg_r),
      .out(csr_reg_r_ppl)
  );
  Pipeline_reg #(
      .WIDTH(1),
      .reset(0)
  ) Pipeline_csr_reg_r (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(csr_reg_wr),
      .out(csr_reg_wr_ppl)
  );
endmodule
