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

Memory memory_imp(clk, load, rst ,data, command);

initial begin
// a[0]=4'b0011;
// a[1]=4'b0111;
// a[2]=4'b1011;
// a[3]=4'b1111;

// a[4]=4'b0001;
// a[5]=4'b0101;
// a[6]=4'b1001;
// a[7]=4'b1101;

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