module tb_RISCV;
  logic rst, clk, ext_inter, timer_en;
  logic [31:0] result;
  logic gemm_valid, gemm_done;
  logic [31:0] gemm_rdata1;
  logic [31:0] gemm_rdata2;
  RISC_V DUT (
      .clk(clk),
      .rst(rst),
      .timer_en(timer_en),
      .ext_inter(ext_inter),
      .gemm_done(gemm_done),
      .gemm_valid(gemm_valid),
      .gemm_rdata1(gemm_rdata1),
      .gemm_rdata2(gemm_rdata2),
      .result(result)
  );

  //clock generation
  localparam CLK_PERIOD = 2;
  initial begin
    clk = 0;
    forever begin
      #(CLK_PERIOD / 2);
      clk = ~clk;
    end
  end
  //Testbench

  initial begin
    rst <= 1'b1;
    timer_en <= 0;
    ext_inter <= 0;
    gemm_done <= 1;
    @(posedge clk);
    rst <= 1'b0;
    @(posedge clk);
    @(posedge gemm_valid);
    gemm_done <= 0;
    repeat (5) @(posedge clk);
    gemm_done <= 1;
    repeat (20) @(posedge clk);
    $finish;
  end
  //Monitor values at posedge
  always @(posedge DUT.clk) begin
    $strobe(
        "rst=%d PC=%0d\tFlush=%0d\tstall=%d\tinstr=%h|\nPC=%0d\tinstr=%h\tx1=%0h\tx2=%0d\tx3=%0h\tA=%h\tB=%h\tforw_a=%0d\tforw_b=%0d|\nPC=%0d\tALU_o=%0h\twb_data=%h\tmem=%d\tregwr=%b\twb_sel=%b\tPC_sel=%b\nmem_wr=%b\tdata_to_wr=%h\nmie_wr_flag=%0h\tinterupt_taken=%0h\tmstatus_wr_flag=%0h\tmtvec_wr_flag=%0h\ttimer_inter=%0h\texternal_inter=%0h\nmepc_q=%0d\tmie_q=%0h\tmstatus_q=%0h\tmtvec_q=%0h\tmcause_q=%0h\tmip_q=%0h\nISR_addr=%0b\tcsr_addr=%0h\tepc=%0d\tepc_taken=%0h",
        rst, DUT.datapath.Fetch.PC, DUT.datapath.flush, DUT.datapath.stall,
        DUT.datapath.Fetch.instruction, DUT.datapath.Decode_instance.PC,
        DUT.datapath.Decode_instance.instruction,
        DUT.datapath.Decode_instance.Regfile_instance.mem[1],
        DUT.datapath.Decode_instance.Regfile_instance.mem[2],
        DUT.datapath.Decode_instance.Regfile_instance.mem[3], DUT.datapath.Decode_instance.ALU_op_a,
        DUT.datapath.Decode_instance.ALU_op_b, DUT.datapath.Decode_instance.forw_a,
        DUT.datapath.Decode_instance.forw_b, DUT.datapath.wb_stage_instance.PC, DUT.datapath.ALU_wb,
        DUT.datapath.wb_data, DUT.datapath.wb_stage_instance.data_mem_instance.mem[0], DUT.reg_wr,
        DUT.wb_sel, DUT.PC_sel, DUT.mem_wr, DUT.datapath.wb_stage_instance.data_to_mem,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mie_wr_flag,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.interupt_taken,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mstatus_wr_flag,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mtvec_wr_flag,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.timer_inter,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.external_inter,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mepc_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mie_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mstatus_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mtvec_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mcause_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mip_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.ISR_addr,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.addr,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.epc,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.epc_taken);
    $strobe("ovf", DUT.ovf);
    $strobe("\n---------------------------------------------");

  end
  initial begin
    $dumpfile("RISC_R_dump.vcd");
    $dumpvars;
  end
endmodule
