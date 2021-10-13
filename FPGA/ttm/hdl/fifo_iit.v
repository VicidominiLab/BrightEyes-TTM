//////////////////////////////////////////////////////////////////////////////////
// Company : Electronic Design Laboratory, Istituto Italiano di Tecnologia
// Engineer: Francesco Diotalevi 
// Date    : February 2019
// Design  : FIFO for RTL interface for writing on Cypress FX3
// License : CC BY-NC 4.0 
//////////////////////////////////////////////////////////////////////////////////

module fifo_iit 
(

    // From data producer
    input         stream_rstn,
    input         stream_clk,
	input [255:0] stream_data_i,
    input         stream_write_i,
    output        stream_full_o,
    output        stream_prog_full_o,
    output        stream_empty_o,
    output        stream_prog_empty_o,
    
    // To logic
	input         data_rstn,  //input reset active low
	input         data_clk,   //input clk 100 Mhz
    output [31:0] data_o,
    output        data_valid_top_o,
    output        data_valid_second_o,
    output        data_valid_third_o,
    input         data_read_i
); 

//
//     Fifo decoupler      Middle      Top
//   -----+-+-+-+-+-+         --       --   
//        | | | | | |        |  |     |  |
//        | | | | | | ======>|  |=>==>|  |=>
//        | | | | | |        |  |     |  |
//        | | | | | |        |  |     |  |
//   -----+-+-+-+-+-+         --       --  --> data_valid_top_o
//                  |          --> data_valid_middle_o
//                  --> data_valid_thirs_o

wire reset = ~(stream_rstn & data_rstn);
reg Enable_write;

// Fifo
wire [12:0] i_fifo_data_count;
wire [31:0] i_fifo_data;
wire        i_fifo_read;
wire        i_fifo_empty;
wire        i_fifo_prog_empty;
reg         i_fifo_empty_s;
wire        i_ne_fifo_empty;
wire        i_fifo_full;

// Middle
wire i_fifo_write_middle;
wire i_full_middle;
wire [31:0] data_middle;
wire i_read_middle;
wire i_empty_middle;
reg  i_empty_middle_s;
wire i_ne_empty_middle;

// Top
wire i_fifo_write_top;
wire i_full_top;
wire [31:0] data_top;
wire i_read_top;
wire i_empty_top;

assign stream_full_o = i_fifo_full;
assign stream_empty_o         = i_fifo_empty;
assign stream_prog_empty_o    = i_fifo_prog_empty;

// Wait until the fifo is really resetted
always @(posedge stream_clk)
begin
    if (stream_rstn==1'b0)
        Enable_write <= 0;
    else
        if (i_fifo_full==1'b0 && Enable_write==1'b0)
            Enable_write <= 1'b1;
end

// 8K Word FIFO length
fifo_decoupler i_fifo_decoupler
(
    .rd_clk(data_clk),
    .wr_clk(stream_clk),
    .rst(reset),
    .din(stream_data_i),
    .wr_en(stream_write_i & Enable_write),
    .rd_en(i_fifo_read),
    .dout(i_fifo_data),
    .full(i_fifo_full),
    .prog_full(stream_prog_full_o),
    .empty(i_fifo_empty),
    .prog_empty(i_fifo_prog_empty),
    .rd_data_count(i_fifo_data_count)
  );

always @(posedge data_clk)
begin
      if (reset)
          i_fifo_empty_s <= 0;
      else
          i_fifo_empty_s <= i_fifo_empty;
end
assign i_ne_fifo_empty = ~i_fifo_empty & i_fifo_empty_s;

assign i_fifo_read = (i_ne_fifo_empty & ~i_full_middle) |               // Read when is not empty and middle can be filled
                     (~i_fifo_empty & i_full_middle & i_read_middle);   // even if the fifo is not empty and the middle is full but is being read
assign i_fifo_write_middle = i_fifo_read; 



one_fifo middle_fifo
(
	.rstn(~reset),  //input reset active low
	.clk(data_clk),   //input clk 100 Mhz
    // Write I/f
    .fifo_data_i(i_fifo_data),
    .write_i(i_fifo_write_middle),
    .full_o(i_full_middle),
    // Read I/f
    .fifo_data_o(data_middle),
    .read_i(i_read_middle),
    .empty_o(i_empty_middle)
);
 
always @(posedge data_clk)
begin
      if (reset)
          i_empty_middle_s <= 0;
      else
          i_empty_middle_s <= i_empty_middle;
end
assign i_ne_empty_middle = ~i_empty_middle & i_empty_middle_s;

assign i_read_middle = (i_ne_empty_middle & ~i_full_top) |            // Read when is not empty and top can be filled
                       (~i_empty_middle & i_full_top & i_read_top);   // even if the fifo is not empty and the middle is full but is being read
assign i_fifo_write_top = i_read_middle; 

one_fifo top_fifo
(
	.rstn(~reset),  //input reset active low
	.clk(data_clk),   //input clk 100 Mhz
    // Write I/f
    .fifo_data_i(data_middle),
    .write_i(i_fifo_write_top),
    .full_o(i_full_top),
    // Read I/f
    .fifo_data_o(data_top),
    .read_i(i_read_top),
    .empty_o(i_empty_top)
); 

assign i_read_top = data_read_i;
assign data_valid_top_o = ~i_empty_top;
assign data_valid_second_o = ~i_empty_middle;
assign data_valid_third_o = ~i_fifo_empty;

assign data_o = data_top;

endmodule

