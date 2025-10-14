module full_adder_serial(
    input a, b, cin,
    output sum, carry
);
    assign sum = a ^ b ^ cin;
    assign carry = (a & b) | (b & cin) | (cin & a);
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

    always @ (posedge clk) begin
        if(rst) begin 
            reg_data <= 0;
            out_bit <= 0;
            done <= 0;
            count <= 0;
        end

        else if (load) begin
            reg_data <= data_in;
            count <= 0;
        end

        else if (!done) begin
            out_bit <= reg_data[0];
            reg_data <= reg_data >> 1;
            count <= count + 1;
            if( count == 3) begin
                done = 1'b1;
            end
        end
    end
endmodule

module d_ff(
    input clk,
    input d,
    output reg q
);

    always @ (posedge clk) begin
        if(load)
            q <= 0;
        else
            q <= d;
    end
endmodule

module shift_register_top(

    input clk,
    input 
)