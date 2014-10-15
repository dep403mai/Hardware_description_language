module RS_latch(
    input wire S,
    input wire R,
    output wire Q,
    output wire NQ
    );

assign Q = ~(R & NQ);
assign NQ = ~(S & Q);

endmodule



module test_rs;

reg S, R;
wire Q, NQ;

RS_latch rs_imp(S, R, Q, NQ);

initial
begin
    S = 0; R = 0;

    #10 S = 1; R = 0;

    #10 S = 0; R = 1;

    #10 S = 1; R = 0;

    #10 S = 1; R = 1;

    #10 S = 0; R = 0;
end

initial
begin
  #60 $finish;
end

initial
begin
    $dumpfile("out.vcd");
    $dumpvars(0, test_rs);
end

endmodule