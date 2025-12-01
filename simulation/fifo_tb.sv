`timescale 1ns/1ns

module fifo_tb;

    parameter WIDTH = 32;
    parameter DEPTH = 16;
    reg clk_i; reg rst_i; reg rd_en; reg wr_en; 
    reg [WIDTH-1:0] data_i;
    wire full_o; wire empty_o;
    wire [WIDTH-1:0] data_o;

fifo DUT (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .rd_en(rd_en),
    .wr_en(wr_en),
    .data_i(data_i),
    .data_o(data_o),
    .full_o(full_o),
    .empty_o(empty_o)
);

task random(); 
begin 
    repeat(10)   
    begin
        wr_en = $random(); 
        rd_en = $random(); 
        data_i = $random(); // {$random} % 255;  
        #10;    
    end
end
endtask


task write(); 
begin 
    wr_en = 1;
    rd_en = 0;
    repeat(20)
        begin
            data_i = $random(); // {$random} % 255;  
            #10;    
        end
end
endtask

task read(); 
begin 
    wr_en = 0;
    rd_en = 1;
    repeat(20)
        begin
            data_i = $random(); // {$random} % 255;  
            #10;    
        end
end
endtask

initial begin
    forever begin
        #5; 
        clk_i = ~clk_i;
    end
end

initial 
begin 
clk_i = 0; rst_i = 1;
#10;
rst_i = 0;
#10;
rst_i = 1;

write();
random();
read();
random();

$finish;
end
endmodule
