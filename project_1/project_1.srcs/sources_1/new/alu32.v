// file: alu32.v
`timescale 1ns/1ps

module alu32 #(
    parameter WIDTH = 32
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [3:0]       op,     // operation select
    output reg  [WIDTH-1:0] result,
    output reg              zero,   // result == 0
    output reg              neg,    // sign bit (result[WIDTH-1])
    output reg              carry,  // carry-out for add/sub logical carry
    output reg              overflow // signed overflow
);

    // Operation encoding (you can change these as needed)
    localparam OP_ADD  = 4'd0;
    localparam OP_SUB  = 4'd1;
    localparam OP_AND  = 4'd2;
    localparam OP_OR   = 4'd3;
    localparam OP_XOR  = 4'd4;
    localparam OP_NOR  = 4'd5;
    localparam OP_SLL  = 4'd6; // logical left shift by lower 5 bits of b
    localparam OP_SRL  = 4'd7; // logical right shift by lower 5 bits of b
    localparam OP_SRA  = 4'd8; // arithmetic right shift by lower 5 bits of b
    localparam OP_SLT  = 4'd9; // set on less than (signed)
    localparam OP_SLTU = 4'd10; // set on less than unsigned

    wire [WIDTH-1:0] b_shifted;
    wire [WIDTH-1:0] b_in;
    wire [WIDTH:0] add_full; // one extra bit for carry-out

    // For add/sub, use a carry-in (sub uses ~b + 1 trick)
    wire cin;
    assign cin = (op == OP_SUB) ? 1'b1 : 1'b0;

    // For subtraction, invert b when doing a - b
    assign b_in = (op == OP_SUB) ? (~b) : b;

    // Use wider adder to capture carry-out
    assign add_full = {1'b0, a} + {1'b0, b_in} + cin;

    // shift amount use lower log2(WIDTH) bits (for 32-bit => 5 bits)
    wire [4:0] shamt = b[4:0];

    always @(*) begin
        // default outputs
        result = {WIDTH{1'b0}};
        zero   = 1'b0;
        neg    = 1'b0;
        carry  = 1'b0;
        overflow = 1'b0;

        case (op)
            OP_ADD: begin
                result = add_full[WIDTH-1:0];
                carry  = add_full[WIDTH];
                // overflow for signed add: (a_msb & b_msb & ~res_msb) | (~a_msb & ~b_msb & res_msb)
                overflow = (a[WIDTH-1] & b[WIDTH-1] & ~result[WIDTH-1]) |
                           (~a[WIDTH-1] & ~b[WIDTH-1] & result[WIDTH-1]);
            end
            OP_SUB: begin
                result = add_full[WIDTH-1:0];
                carry  = add_full[WIDTH]; // in two's complement, carry=1 means no borrow for unsigned
                // overflow for signed subtraction: (a_msb & ~b_msb & ~res_msb) | (~a_msb & b_msb & res_msb)
                overflow = (a[WIDTH-1] & ~b[WIDTH-1] & ~result[WIDTH-1]) |
                           (~a[WIDTH-1] & b[WIDTH-1] & result[WIDTH-1]);
            end
            OP_AND:  result = a & b;
            OP_OR:   result = a | b;
            OP_XOR:  result = a ^ b;
            OP_NOR:  result = ~(a | b);
            OP_SLL:  result = a << shamt;
            OP_SRL:  result = a >> shamt;
            OP_SRA:  result = $signed(a) >>> shamt;
            OP_SLT:  result = ($signed(a) < $signed(b)) ? {{(WIDTH-1){1'b0}}, 1'b1} : {WIDTH{1'b0}};
            OP_SLTU: result = (a < b) ? {{(WIDTH-1){1'b0}}, 1'b1} : {WIDTH{1'b0}};
            default: result = {WIDTH{1'b0}};
        endcase

        // Flags
        zero = (result == {WIDTH{1'b0}});
        neg  = result[WIDTH-1];
        // For non-add/sub ops, keep carry/overflow = 0 (already defaulted)
    end

endmodule



