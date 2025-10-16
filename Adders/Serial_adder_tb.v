module serial_adder_tb();
    reg rst;
    reg load;
    reg clk;
    reg [3:0] a, b;
    wire sum_bit;
    wire done;

    shift_register_top DUT(
        .rst(rst),
        .load(load),
        .clk(clk),
        .a(a),
        .b(b),
        .carry_bit(carry_next),
        .sum_bit(sum_bit),
        .done (done)
    );

    initial begin
        $monitor("Time = %0t || clk = %b || rst = %b || load = %b || a = %b || b = %b || sum_bit = %b || carry_bit = %b || done = %b", $time, clk, rst, load, a, b, sum_bit, carry_next, done);
    end
        
    initial clk = 0;

    always begin
        #10 clk = ~clk;
    end

    initial begin
        rst = 1;
        #10;
        a = 4'b1011;
        b = 4'b0101;
        rst = 0;
        load = 1;
        #10;
        load = 0;
        #140;
        rst = 1;
    end

    initial begin
        $dumpfile("Serial_Adder.vcd");
        $dumpvars(0, DUT);
    end

    initial begin
        #150;
        $finish;
    end    

endmodule