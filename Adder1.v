
// Adder using 2 half adders
// {1} Reg is used for only procedural blocks (initial / always) whereas wire is used in continuous assignments;
// {2} The internal connections are wires here due to the same reason as {1};
// .port name of the module called(The parent module port)
// Procedural blocks are how verilog describes the behaviour when there is a signal change or rather a clock trigger;

module half_adder(

    input a,b,
    output  sum, carry // Had declared it as reg we do not use reg but wire here {1}
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

module full_adder( // Full adder is a parent module with 2 child modules add1 and add2;
    input a, b, cin,
    output full_sum, full_carry
);

wire s1, c1, c2; // We need Sum from the first adder and the carry from both the adders to add later {2}

// The instance name of the child modules is mandatory without which there would be a syntax error;

half_adder add1( .a(a), .b(b), .sum(s1), .carry(c1)); // Half adder instance named add1;

half_adder add2( .a(s1), .b(cin), .sum(full_sum), .carry(c2)); // Half adder instance named add2;

// Instead of a primitive gate we can use assign statement assign full_carry = c1 | c2;
// Both the methods would synthesize to the same hardware;

or(full_carry, c1, c2); // OR between the carry output of the half adder 1 and half adder 2;

// The difference between bitwise or and logical or is that the bitwise or performs an operation and usually gives a multibit output;
// Whereas the Logical OR operates on the entire expression not individual bits the output is usually a single bit
// Example Bitwise OR --> 1010 | 1100 = 1110 Operates on each and every bit;
// Example Logical OR --> 1010 || 0000 = 1; 0000 | 0000 = 0 The input is identified as zero or non-zero;

endmodule

