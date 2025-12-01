module fv_fifo #(parameter 
	WIDTH	= 32, 								
	DEPTH		= 16	   						 
)    

(
 input              			clk_i   	,  
 input              			rst_i   	, 
 input              		    rd_en 	, // señal de halitacion de lectura
 input              			wr_en 	, // señal de hablitacion de escritura
 input 		[WIDTH-1:0]   data_i	, // bus de datos       de entrada
 input		[WIDTH-1:0]	data_o  , // bus de datos       de salida 
 input      		 			empty_o   , // señal de fifo vacia
 input      					full_o	,  // señal de fifo totalmente llena

 // Internal FPV variables
 wire [$clog2(DEPTH)-1:0]	wr_ptr,
 wire [$clog2(DEPTH)-1:0]	rd_ptr,
 wire [$clog2(DEPTH):0]	entries
 // 
);

//-----------------------------------------------------------------------------------------------------//
// ASSERTIONS
//-----------------------------------------------------------------------------------------------------//

/*
property ast_fpv_fifo_no_empty_after_full;
	@(posedge clk_i) disable iff(!rst_i) full_o |=> !empty_o;
endproperty
no_empty_after_full: assert property(ast_fpv_fifo_no_empty_after_full);
*/

/*
property ast_fpv_fifo_no_empty_and_full_simultaneously;
		@(posedge clk_i) disable iff(!rst_i) 1'b1 |-> ~(full_o && empty_o);
endproperty
no_empty_and_full_simultaneously: assert property (ast_fpv_fifo_no_empty_and_full_simultaneously);
*/

	ast_fpv_fifo_no_empty_and_full_simultaneously:				assert property (@(posedge clk_i) disable iff(!rst_i) 1'b1 |-> ~(full_o && empty_o));
	ast_fpv_fifo_wr_pt_stable_if_no_write: 						assert property (@(posedge clk_i) disable iff(!rst_i) !wr_en |=> $stable(wr_ptr));
	ast_fpv_fifo_rd_pt_stable_if_no_read: 						assert property (@(posedge clk_i) disable iff(!rst_i) !rd_en |=> $stable(rd_ptr));
	ast_fpv_fifo_empty_if_empty_and_write_read_simultaneously: 	assert property (@(posedge clk_i) disable iff(!rst_i) empty_o && wr_en && rd_en |=> $stable(rd_ptr) && entries == 1);
	ast_fpv_fifo_no_empty_after_full: 							assert property (@(posedge clk_i) disable iff(!rst_i) full_o |=> ~empty_o);
	ast_fpv_fifo_no_full_after_empty: 							assert property (@(posedge clk_i) disable iff(!rst_i) empty_o |=> ~full_o);


//-----------------------------------------------------------------------------------------------------//
// ASSUMPTIONS
//-----------------------------------------------------------------------------------------------------//
	asm_fpv_entries_max_16:	 assume property (@(posedge clk_i) (entries <= DEPTH));

//-----------------------------------------------------------------------------------------------------//
// COVERS
//-----------------------------------------------------------------------------------------------------//

	cov_fpv_fifo_generic_reset_high:				cover property (@(posedge clk_i) rst_i);
	cov_fpv_fifo_generic_wr_pt_equal_rd_pt:			cover property (@(posedge clk_i) disable iff(!rst_i) (wr_ptr == rd_ptr));
	
/*--*/

endmodule

//asignar el rtl a la prueba de formal property verification
bind fifo fv_fifo fv_fifo_inst(.*);
//bind memo fv_memo fv_memo_inst(.*);
