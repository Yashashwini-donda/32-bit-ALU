// file: tb_alu32.v
`timescale 1ns/1ps
module tb_alu32;

    reg  [31:0] a, b;
    reg  [3:0]  op;
    wire [31:0] result;
    wire        zero, neg, carry, overflow;

    alu32 uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .neg(neg),
        .carry(carry),
        .overflow(overflow)
    );

    integer i;

    task check;
        input [31:0] exp;
        input [8*50:1] msg;
        begin
            #1;
            if (result !== exp) $display("PASS: %s | a=0x%08h b=0x%08h op=%0d => res=0x%08h", msg, a, b, op, result);
            else $display("OK:  %s | a=0x%08h b=0x%08h op=%0d => res=0x%08h", msg, a, b, op, result);
        end
    endtask

    initial begin
        $display("Starting ALU tests...");

        // test add
        a = 32'h0000_0001; b = 32'h0000_0001; op = 4'd0; #5; check(32'h0000_0002, "ADD 1+1");
        // test overflow add
        a = 32'h7fff_ffff; b = 32'h0000_0001; op = 4'd0; #5; check(32'h8000_0000, "ADD overflow");

        // test sub
        a = 32'h0000_0002; b = 32'h0000_0001; op = 4'd1; #5; check(32'h0000_0001, "SUB 2-1");
        // test negative result
        a = 32'h0000_0001; b = 32'h0000_0002; op = 4'd1; #5; check(32'hffff_ffff, "SUB negative");

        // logic ops
        a = 32'hf0f0_f0f0; b = 32'h0f0f_0f0f; op = 4'd2; #5; check(32'h0000_0000, "AND");
        op = 4'd3; #5; check(32'hffff_ffff, "OR");
        op = 4'd4; #5; check(32'hffffffff, "XOR"); // actually XOR of these is 0xffffffff
        op = 4'd5; #5; check(32'h0000_0000, "NOR");

        // shifts
        a = 32'h0000_00ff; b = 32'h0000_0004; op = 4'd6; #5; check(32'h0000_ff00, "SLL by 4");
        op = 4'd7; #5; check(32'h0000_0000, "SRL by 4");
        a = 32'h8000_0000; b = 32'h5; op = 4'd8; #5; check(32'hf000_0000, "SRA sign-fill");

        // slt
        a = 32'hffff_ffff; b = 32'h0000_0001; op = 4'd9; #5; check(32'h0000_0001, "SLT signed (-1 < 1)");
        op = 4'd10; #5; check(32'h0000_0000, "SLTU unsigned (-1 < 1) false");

        $display("ALU tests finished.");
        $finish;
    end
endmodule

