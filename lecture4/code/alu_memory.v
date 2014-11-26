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

assign NOT_B =  COMMAND[2] & (~B);

assign A_OR_B = ((COMMAND[1] & A) | (COMMAND[1] & B));

assign A_AND_B = ((COMMAND[0] & A) & (COMMAND[0] & B));

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
Sum sum_imp(Q[0], A, B, SUM ,CARRY);
Logic_unit logic_imp(Q[1:3], A, B, NOT_B, A_OR_B, A_AND_B);

assign RES = NOT_B | A_AND_B | A_OR_B | SUM;
endmodule


module Memory(
    input wire CLK,                 // Тактирование
    input wire LOAD,                // Сигнал разрешения рагрузки
    input wire RST,                 // Сброс
    input wire [0:3]INPUT_DATA,     // Шина входных слов
    output reg [0:3]OUTPUT_COMMAND  // Шина выходных слов
    );

reg [0:3]memory[0:7];       // Внутренняя память (ОЗУ)
reg [0:2] input_count = 0;  // Счетчик количества считанных слов
integer i = 0;
reg [0:2] output_count = 0; // Счетчик количества выданных слов

always @(posedge CLK or posedge RST) begin

    if (RST) begin      // Очищаем все регистры
        for (i = 0; i < 8; i = i + 1) memory[i] = 3'hx;
        OUTPUT_COMMAND = 3'hx;
        output_count = 0;
        input_count = 0;
    end

    else begin          // Cчитываем с входной шины слова в память
        if (LOAD) begin
            if (input_count != 8) begin
                memory[input_count] = INPUT_DATA;
                input_count = input_count + 1;
            end
        end

        else begin      // Считываем слова из памяти
            OUTPUT_COMMAND = memory[output_count];
            if (output_count > 7) begin
                output_count = 0;
            end

            else begin
                output_count = output_count + 1;
            end
        end // end of else if (LOAD)
    end // end of else if (RST)
end // end of always @(posedge CLK or posedge RST)
endmodule // end of module Memory

module test_memory;
reg clk;
reg load;
reg rst;
reg [0:3]a[0:7];
reg [0:3]data;
wire [0:3]command;
reg [0:3]n;
wire res, carry;

Memory memory_imp(clk, load, rst ,data, command);
Alu alu_imp(command[2], command[3], command[0:1], res, carry);

initial begin
$readmemb("program.bin", a);
end

always begin
    #1 clk = ~clk;
end

initial begin
 clk = 0;
 load = 1;
 rst = 0;
 n = 0;

 #60 rst = 1;

 #10 rst = 0;
 load = 1;
end

always @(posedge clk) begin
    if (load) begin

        data = a[n];

        if (n > 7) begin
            load = 0;
            n = 0;
            data = 3'hx;
        end
        else begin
            n = n + 1;
        end
    end

end

initial
begin
  $dumpfile("out.vcd");
  $dumpvars(0, test_memory);
  #120 $finish;
end

endmodule