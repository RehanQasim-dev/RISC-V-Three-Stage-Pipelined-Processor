`include "RISC_V.sv"

module RISC_V_tb;
  logic rst, clk;
  logic [3:0] interrupt;
  RISC_V DUT (
      .clk(clk),
      .rst(rst),
      .interrupt(interrupt)
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
    rst = 1;
    interrupt = 4'b0000;
    @(posedge clk);
    rst = 0;
    repeat (4) @(posedge clk);
    interrupt = 4'b0001;
    repeat (4) @(posedge clk);
    $finish;
  end

  //Monitor values at posedge
  always @(posedge clk) begin
    $strobe(
        "PC=%0d\tFlush=%0d\tinstr=%h|\nPC=%0d\tinstr=%h\tx1=%0h\tx2=%0h\tx3=%0h\tA=%h\tB=%h|\nPC=%0d\twb_data=%h\tmem=%h\tregwr=%b\twb_sel=%b\tPC_sel=%b\nmem_wr=%b\tdata_to_wr=%h",
        DUT.datapath.Fetch.PC, DUT.datapath.flush, DUT.datapath.Fetch.instruction,
        DUT.datapath.Decode_instance.PC, DUT.datapath.Decode_instance.instruction,
        DUT.datapath.Decode_instance.Regfile_instance.mem[1],
        DUT.datapath.Decode_instance.Regfile_instance.mem[2],
        DUT.datapath.Decode_instance.Regfile_instance.mem[3], DUT.datapath.Decode_instance.ALU_op_a,
        DUT.datapath.Decode_instance.ALU_op_b, DUT.datapath.wb_stage_instance.PC,
        DUT.datapath.wdata, DUT.datapath.wb_stage_instance.data_mem_instance.mem[0], DUT.reg_wr,
        DUT.wb_sel, DUT.PC_sel, DUT.mem_wr, DUT.datapath.wb_stage_instance.data_to_mem);
    $display("\n---------------------------------------------");
  end
  initial begin
    $dumpfile("RISC_R_dump.vcd");
    $dumpvars;
  end
endmodule
