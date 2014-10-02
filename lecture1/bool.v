module Bool(
	input a, 
	input b,
    output not_a, 
    output not_b, 
    output a_and_b,
    output a_or_b, 
    output a_nand_b
    );

assign not_a = ~a;          // NOT
assign not_b = ~b;          // NOT
assign a_and_b = a & b;     // AND
assign a_or_b = a | b; 	    // OR
assign a_nand_b = ~(a & b); // NAND

endmodule


module Test_bool;

reg a, b;
wire not_a, not_b, a_and_b, a_or_b, a_nand_b;

Bool Bool_imp(a, b, not_a, not_b, a_and_b, a_or_b, a_nand_b);

initial
begin
	a = 0;
	b = 0;

	#10 a = 1;
	b = 0;

	#10 a = 0;
	b = 1;

	#10 a = 1;
	b = 1;
end

initial
begin
  $dumpfile("out.vcd");
  $dumpvars(0, Test_bool);
  #40 $finish;
end
endmodule
