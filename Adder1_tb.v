module adder1_tb;

// There is no input or output declarations while writing the testbench

    reg a, b, cin;
    wire sum, carry;

// Integer i must be declared outside the initial block and in the starting along with the other declarations;

    integer i; // This has 32 bits by default i.e. size of i == 32 bits;

    full_adder DUT ( .a(a), .b(b), .cin(cin), .full_carry(carry), .full_sum(sum) );

    initial begin
    $monitor (" A = %b || B = %b || Cin = %b Sum = %b || Carry = %b ", a, b, cin, sum, carry);
    end

    initial  begin

// Remember that in verilog you will have to write i = i + 1 and not i++;        

        for ( i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i; // Could also have written i[2:0] but verilog automatically truncates the excess bits and use the LSB;
            #10;
        end
    
    end

    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0,DUT);
    end

endmodule
