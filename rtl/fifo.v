module fifo 

#(parameter WIDTH = 32, parameter DEPTH = 16)
//depth es cuantos datos puedes guardar
//width es el tamaño de la palabra
(
    input clk_i, rst_i,
    input rd_en, wr_en,
    input [WIDTH-1:0] data_i,
    output reg [WIDTH-1:0] data_o,
    output full_o, empty_o
);

reg [$clog2(DEPTH)-1:0] rd_ptr, wr_ptr;
reg [$clog2(DEPTH):0] entries;
reg [WIDTH-1:0] register [0:DEPTH-1];

wire full_w, empty_w;
assign full_w = (entries == DEPTH);
assign full_o = full_w;
assign empty_w = (entries == 32'b0);
assign empty_o = empty_w;

integer i;
always @(posedge clk_i, negedge rst_i) begin
    if (rst_i == 0) begin
        for (i=0; i<DEPTH; i=i+1)
            register [i] <= {{WIDTH}{1'b0}};
    end
    else if (wr_en && !full_w) register [wr_ptr] <= data_i;
end

always @(posedge clk_i) begin
    if (rd_en && !empty_w) data_o <= register [rd_ptr];
    else data_o <= {{WIDTH}{1'b0}};
end

always @(posedge clk_i, negedge rst_i) begin
    if (rst_i == 0) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        entries <= 0;
    end
    else begin
        case ({wr_en, rd_en})
            2'b01 : begin
                if (!empty_w) begin
                    rd_ptr <= rd_ptr + 1;
                    entries <= entries - 1;
                end
            end
            2'b10 : begin
                if (!full_w) begin
                    wr_ptr <= wr_ptr + 1;
                    entries <= entries + 1;
                end    
            end  
            2'b11 : begin
                if (empty_w) begin
                    wr_ptr <= wr_ptr + 1;
                    entries <= entries + 1;
                end
                else if (full_w) begin
                    rd_ptr <= rd_ptr + 1;
                    entries <= entries - 1;
                end 
                else begin
                    wr_ptr <= wr_ptr + 1;
                    rd_ptr <= rd_ptr + 1;
                end
            end
            default : begin
                wr_ptr <= wr_ptr;
                rd_ptr <= rd_ptr;
                entries <= entries;
            end
        endcase
    end
end

endmodule

