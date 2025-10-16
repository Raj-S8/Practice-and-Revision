// module full_adder_serial(
//     input a, b, cin,
//     output sum, carry
// );
//     if(load)
//         carry = 0;
//     assign sum = a ^ b ^ cin;
//     assign carry = (a & b) | (b & cin) | (cin & a);
// endmodule

module full_adder_serial(
    input a, b, cin,
    input load,
    output reg sum,
    output reg carry
);

    always @(*) begin
        if (load)
            carry = 0;  
        else
            carry = (a & b) | (b & cin) | (cin & a);

        sum = a ^ b ^ cin;
    end

endmodule


module in_registers(
    input rst,
    input clk,
    input load,
    input [3:0] data_in,
    output reg out_bit,
    output reg done
);
    reg [2:0] count;
    reg [3:0] reg_data;

    always @ (posedge clk or posedge rst) begin
        if(rst) begin 
            reg_data <= 0;
            out_bit <= 0;
            done <= 0;
            count <= 0;
        end

        else if (load) begin
            reg_data <= data_in;
            count <= 0;
            done <= 0;
        end

        else if (!done) begin
            out_bit <= reg_data[0];
            reg_data <= reg_data >> 1;
            count <= count + 1;
            if( count == 3) begin
                done <= 1'b1;
            end
        end
    end
endmodule

module d_ff(
    input load,
    input rst,
    input clk,
    input d,
    output reg q
);

    always @ (posedge clk or posedge rst) begin
        if(rst || load)
            q <= 0;
        else
            q <= d;
    end
endmodule

module shift_register_top(
    input rst,
    input load,
    input clk,
    input [3:0] a, b,
    // input c_bit,
    output sum_bit, carry_bit,
    output done
);

    wire a_bit, b_bit;
    wire done_a, done_b;
    wire carry_present, carry_next;

    in_registers in_a(
        .rst(rst),
        .clk(clk),
        .load(load),
        .data_in(a),
        .done(done_a),
        .out_bit(a_bit)
    );

    in_registers in_b(
        .rst(rst),
        .clk(clk),
        .load(load),
        .data_in(b),
        .done(done_b),
        .out_bit(b_bit)
    );

    full_adder_serial adder1(
        .a(a_bit),
        .b(b_bit),
        .cin(carry_present),
        .sum(sum_bit),
        .carry(carry_next)
    );

    d_ff flipf1(
        .clk(clk),
        .rst(rst),
        .load(load),
        .d(carry_next),
        .q(carry_present)
    );

    assign done = done_a & done_b;
    assign carry_bit = carry_next;

endmodule

