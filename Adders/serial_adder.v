module full_adder_serial(
    input a, b, cin,
    output sum, carry
);
    assign sum = a ^ b ^ cin;
    assign carry = (a & b) | (b & cin) | (cin & a);
endmodule

module in_registers(
    input clk,
    input [3:0] a, b,
    output reg a_inbit, b_inbit
);
    reg[3:0] a_up, b_up;
    reg[2:0] count;
    reg done;

    initial begin
        a_up = a;
        b_up = b;
    end

    always @ (posedge clk) begin
        
        if(!done) begin
            a_inbit <= a[3];
            b_inbit <= b[3];
            a_up <= a_up >> 1;
            b_up <= b_up >> 1;
            count <= count + 1;
        end

        if (count == 4)
            done = 1'b1;
    end
endmodule

module d_ff(

    input clk, d,
    output reg q,
);

    always @ (posedge clk)
        q <= d;
    end

endmodule

module top(
    input clk,
    input a, b,
    output sum_bit, carry_bit
);
    reg a_inbit_top, b_inbit_top

    always @ (posedge clk) begin

        in_register in1(.a(a), .b(b), .a_inbit(a_inbit_top), b_inbit(b_inbit_top));
        d_ff ff1 (.d(cin), .q(carry);
        full_adder_serial fa1(.a(a_inbit_top), .b(b_inbit_top), .cin(c_d), .sum(sum_bit),.carry(carry_bit));
    end
endmodule