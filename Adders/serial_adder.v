// module full_adder_serial(
//     input a, b, cin,
//     output sum, carry
// );
//     if(load) Cant write the if block without the initial or always block
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

// module out_register(
//     input clk, rst,
//     input in_bit, load
//     output [3:0] result
// );
//     reg [3:0] res;

//     always @ (posedge clk or posedge rst or posedge load) begin
//         if (rst || load) begin
//             res <= 0;
//         end

//         else begin
//             res[3] <= in_bit;
//             res <= res >> 1;
//         end
//     end
//     always @ (*) begin
//         result <= res;
//     end

// endmodule

module out_register(
     input clk, rst,
     input in_bit, load,
     output [3:0] result // Forgot the use of reg but used it inside an always block at first...see the comment below;
 );
     reg [3:0] res;

     always @ (posedge clk or posedge rst or posedge load) begin
         if (rst || load) begin
             res <= 0;
         end

         else begin
             res <= {in_bit, res[3:1]};
         end
     end

     assign result = res;

    //  always @ (*) begin
    //     result <= res;   // Not necessary we can simply use assign
    // end

endmodule

module shift_register_top(
    input rst,
    input load,
    input clk,
    input [3:0] a, b,
    // input c_bit,
    output sum_bit, carry_bit,
    output [3:0] result,
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

    out_register out1(
        .clk(clk),
        .load(load),
        .rst(rst),
        .in_bit(sum_bit),
        .result(result)
    );

    assign done = done_a & done_b;

    /* In actual implementation of the serial adder we need the carry_bit which is propagated by the d_flip flop. Therefore the 
    correct statement should be assign carry_bit = carry_next;*/
    
    assign carry_bit = carry_next;


endmodule

