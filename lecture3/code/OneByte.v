module RS_latch(
    input wire S,
    input wire R,
    output wire Q,
    output wire NQ
    );

assign Q = ~(R | NQ);
assign NQ = ~(S | Q);

endmodule


module D_latch(
    input wire CLK,
    input wire D,
    output wire Q,
    output wire NQ
    );
wire R, S;
assign R = CLK & ~D;
assign S = D & CLK;

RS_latch rs_imp(S, R, Q, NQ);

endmodule


module D_flip_flope(
    input wire CLK,
    input wire D,
    output wire Q,
    output wire NQ
    );

wire connect;

D_latch d_master(~CLK, D, connect, );
D_latch d_slave(CLK, connect, Q, NQ);

endmodule

module OneByte(    
    input wire CLK,
    input wire [1:8]D,
    output wire [1:8]Q
    );

D_flip_flope D1(CLK, D[1], Q[1], );
D_flip_flope D2(CLK, D[2], Q[2], );
D_flip_flope D3(CLK, D[3], Q[3], );
D_flip_flope D4(CLK, D[4], Q[4], );
D_flip_flope D5(CLK, D[5], Q[5], );
D_flip_flope D6(CLK, D[6], Q[6], );
D_flip_flope D7(CLK, D[7], Q[7], );
D_flip_flope D8(CLK, D[8], Q[8], );

endmodule


module test_onebyte;

reg [1:8]D;
reg CLK;
wire [1:8]Q;

OneByte reg_imp(CLK, D, Q);


initial
begin
    D = 8'h0; 
    CLK = 0;

    #5 D = 8'h4;

    #5 D = 8'hA;
    #1 CLK = ~CLK; 

    #5 D = 8'h9;
    #1 CLK = ~CLK; 

    #5 D = 8'b1111_0000;
    #1 CLK = ~CLK;

    #5 D = 8'b0101_1010;
    #1 CLK = ~CLK; 

end

initial
begin
  #40 $finish;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0, test_onebyte);
end

endmodule