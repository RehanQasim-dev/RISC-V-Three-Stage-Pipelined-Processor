module Pipieline_reg (input logic clk, input logic flush,stall,input logic [31:0] in,output logic [31:0] out);
    always_ff @( clk ) begin
        if(flush) out<=32'd13;
        else if (!stall) out<=in;
    end
endmodule
