module Command_decoder(
    input wire [0:1]COMMAND,
    output wire [0:3]Q
    );

// 00 -> 0001  -> NOT_B
// 01 -> 0010  -> A_OR_B
// 10 -> 0100  -> A_AND_B
// 11 -> 1000  -> SUM

assign Q[0] = COMMAND[0] & COMMAND[1];
assign Q[1] = COMMAND[0] & ~COMMAND[1];
assign Q[2] = ~COMMAND[0] & COMMAND[1];
assign Q[3] = ~COMMAND[0] & ~COMMAND[1];

endmodule


module Sum(
    input wire ENABLE,
    input wire A,
    input wire B,
    output wire SUM,
    output wire CARRY
    );

assign {CARRY, SUM} = ((ENABLE & A) + (ENABLE & B));

endmodule

module Logic_unit(
    input wire [0:2]COMMAND,
    input wire A,
    input wire B,
    output wire NOT_B,
    output wire A_OR_B,
    output wire A_AND_B
    );

assign NOT_B =  COMMAND[0] & (~B);

assign A_OR_B = ((COMMAND[1] & A) | (COMMAND[1] & B));

assign A_AND_B = ((COMMAND[2] & A) & (COMMAND[2] & B));

endmodule


module Alu(
    input wire A,
    input wire B,
    input wire [0:1]COMMAND,
    output wire RES,
    output wire CARRY
    );


wire [0:3]Q;
wire NOT_B, A_AND_B, A_OR_B, SUM;

Command_decoder com_imp(COMMAND, Q);
Sum sum_imp(Q[3], A, B, SUM ,CARRY);
Logic_unit logic_imp(Q[0:2], A, B, NOT_B, A_OR_B, A_AND_B);

assign RES = NOT_B | A_AND_B | A_OR_B | SUM;
endmodule

module test_alu;

reg [0:1]com;
reg a,b;
wire res, carry;

Alu alu_imp(a, b, com, res, carry);


initial
begin
   a = 1;
   b = 1;
   com = 2'b00;

   #10 com = 2'b01;

   #10 com = 2'b10;

   #10 com = 2'b11;

   #10 a = 0;
   b = 1;

   #10 com = 2'b00;

    #10 com = 2'b01;

   #10 com = 2'b10;

   #10 com = 2'b11;

end

initial
begin
  #150 $finish;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0, test_alu);
end

endmodule