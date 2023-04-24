`include "Pipeline_reg.sv"

module Pipeline_reg_tb;
  logic flush, stall, clk;
  logic [31:0] in, out;
  Pipeline_reg #(
      .WIDTH(32),
      .reset(3)
  ) DUT (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(in),
      .out(out)
  );

  //clock generation
  localparam CLK_PERIOD = 10;
  initial begin
    clk = 0;
    forever begin
      #(CLK_PERIOD / 2);
      clk = ~clk;
    end
  end
  //Testbench

  initial begin
    flush = 1;
    stall = 0;
    @(posedge clk);
    flush = 0;
    in = 32'd86;
    @(posedge clk);
    stall = 1;
    in = 32'd5;
    @(posedge clk);
    stall = 0;
    repeat (2) @(posedge clk);
    $finish;
  end

  //Monitor values at posedge
  always @(posedge clk) begin
    $display("out=%d", DUT.out);
    $display("----------------------------------------------------------");
  end

  //Value change dump

  initial begin
    $dumpfile("Pipeline_reg_dump.vcd");
    $dumpvars(1, DUT);
  end
endmodule
