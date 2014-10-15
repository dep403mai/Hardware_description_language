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



module test_d_flip_flop;

reg D, CLK;
wire Q, NQ;

D_flip_flope d_imp(CLK, D, Q, NQ);


initial
begin
    D = 0; CLK = 0;

    #10 D = 1; 

    #10 D = 0;

    #10 CLK = 1;

    #10 D = 1;

    #10 CLK = 0;

    #10 D = 0;

    #10 D = 1;

    #10 CLK = 0;
    #0 D = 0;

    #10 D = 1;
    #0 CLK = 1;

    #10 D = 0;
    #0 CLK = 0;

    #10 D = 0;
    #0 CLK = 1;
end

initial
begin
  #120 $finish;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0, test_d_flip_flop);
end

endmodule