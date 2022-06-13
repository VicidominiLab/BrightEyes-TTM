//////////////////////////////////////////////////////////////////////////////////
// Company : IIT
// Engineer: Francesco Diotalevi 
// Date    : February 2019
// Design  : 
//////////////////////////////////////////////////////////////////////////////////

module one_fifo #(
        parameter DATA_LENGTH = 32)
(
	input        rstn,  //input reset active low
	input        clk,   //input clk 100 Mhz
    // Write I/f
    input [DATA_LENGTH-1:0] fifo_data_i,
    input                   write_i,
    output                  full_o,
    // Read I/f
    output [DATA_LENGTH-1:0] fifo_data_o,
    input                   read_i,
    output                  empty_o
); 

reg        full;
reg        empty;
reg  [DATA_LENGTH-1:0] data;

always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        data <= 32'bX;
        empty <= 1'b1;
        full <= 1'b0;
	end else casez({ write_i, read_i, full, empty })
	    4'b11??: begin
                data <= fifo_data_i;
            end
	    4'b1001: begin
                data <= fifo_data_i;
                full <= 1'b1;
                empty <= 1'b0;
            end
	    4'b0110: begin
                //data <= fifo_data_i;
                full <= 1'b0;
                empty <= 1'b1;
            end
        default: begin
                data <= data;
                full <= full;
                empty <= empty;
            end
    endcase
end

assign fifo_data_o = data;
assign full_o = full;
assign empty_o = empty;

endmodule