//////////////////////////////////////////////////////////////////////////////////
// Company : Electronic Design Laboratory, Istituto Italiano di Tecnologia
// Engineer: Francesco Diotalevi 
// Date    : February 2019
// Design  : RTL interface for writing on Cypress FX3
// License : CC BY-NC 4.0 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 10ps

module to_fx3_workaround #(
        parameter DEBUG = 1)
(   
    // System signals
	input        rstn,            //system reset active low
	input        clk,             //system clk @100 Mhz
    // Stream Interface
    input         stream_rstn,
    input         stream_clk,
	input [255:0] stream_data_i,
    input         stream_write_i,
    output        stream_full_o,
    output        stream_prog_full_o,
    output        stream_empty_o,      
    output        stream_prog_empty_o, 
       
       
	// GPIF2 Interface
    inout [31:0]  fdata,  
	output [1:0]  faddr,                //output fifo address  
	output        slrd,                 //output read select
	output        slwr,                 //output write select
	input         flaga,
	input         flagb,
	input         flagc,
	input         flagd,
	output        sloe,                //output output enable select
	output        clk_out,             //output clk 100 Mhz and 180 phase shift
	output        slcs,                //output chip select
	output        pktend,              //output pkt end
	output [2:0]  PMODE,
	output        RESET,
	input [31:0] counter_for_keep_reset_in_n

);

// Most of the GPIFII I/f signals are active low...
localparam SIGNAL_ACTIVE     = 1'b0;
localparam SIGNAL_NOT_ACTIVE = 1'b1;

function multiple_1k;
  input [15:0] word_count; 
  begin     
    case (word_count)
      16'h0400,
      16'h0800,
      16'h1000,
      16'h2000,
      16'h4000  : multiple_1k = 1'b1;
      default   : multiple_1k = 1'b0;
    endcase 
  end
endfunction

wire        i_dma_ready;
wire        i_dma_wtrmk;

wire [31:0] i_data;
reg         i_read;
wire        i_data_valid_top;
wire        i_data_valid_second;
wire        i_data_valid_third;
reg  [15:0] word_count;
wire        i_write_ok;

reg        i_slwr;
reg        i_slcs;
reg        i_pktend;

reg        i_error_in;
reg        i_error;
wire       i_error_in_synched;
reg [255:0] prev_data_in;
reg [31:0] prev_data;
wire       i_stream_full;
reg [19:0] timer_count;
reg [19:0] i_zlp_workaround;

// 1K or multiple boundaries
`define ONEKBOUNDARY (10'h3FF)
// ASM states definition
`define STATE_WIDTH 4

reg [`STATE_WIDTH-1:0] state;
reg [`STATE_WIDTH-1:0] next_state;

localparam idle              = `STATE_WIDTH'd0,
           write             = `STATE_WIDTH'd1,
           last_one          = `STATE_WIDTH'd2,
           packet_end        = `STATE_WIDTH'd3,
           pre_zlp           = `STATE_WIDTH'd4,
           zlp               = `STATE_WIDTH'd5,
           wait_no_write_zlp = `STATE_WIDTH'd6,
           suspend           = `STATE_WIDTH'd7,
           pre_pkt_end       = `STATE_WIDTH'd8,
           wait_no_write     = `STATE_WIDTH'd9;

localparam LOW  = 1'b0,
           HIGH = 1'b1;

assign i_dma_ready = flaga;
assign i_dma_wtrmk = flagb;

// We can write on GPIF2 interface only if i_write_ok==1
assign i_write_ok = i_dma_ready;// & i_dma_wtrmk;

fifo_iit  fifo_iit
(
    // From data producer
    .stream_rstn(stream_rstn),
    .stream_clk(stream_clk),
	.stream_data_i(stream_data_i),
    .stream_write_i(stream_write_i),
    .stream_full_o(i_stream_full),
    .stream_prog_full_o(stream_prog_full_o),
    .stream_empty_o(stream_empty_o),
    .stream_prog_empty_o(stream_prog_empty_o),
    // To logic
	.data_rstn(rstn),  //input reset active low
	.data_clk(clk),   //input clk 100 Mhz
    .data_o(i_data),
    .data_valid_top_o(i_data_valid_top),
    .data_valid_second_o(i_data_valid_second),
    .data_valid_third_o(i_data_valid_third),
    .data_read_i(i_read)
); 

// Count real transfered words
always @(posedge clk or negedge rstn) begin
    if (rstn==1'b0) begin
        word_count <= 0;
    end else begin 
        if ((i_slwr==1'b1) && (i_slcs==1'b1)) begin
            word_count <= 0;
        end else if (i_slwr== 1'b0 && i_slcs==1'b0) begin
            word_count <= word_count + 1;
        end
    end
end

// Sequential ASM
always @(posedge clk, negedge rstn) begin
        if (!rstn)
                state <= idle;
        else
                state <= next_state;
end

// wait at least 125uS after ZLP before issuing a write
always @(posedge clk, negedge rstn) begin
        if (!rstn)
                i_zlp_workaround <= 0;
        else if ((state==wait_no_write_zlp) && (i_zlp_workaround < 13000))
                i_zlp_workaround <= i_zlp_workaround + 1;
        else
                i_zlp_workaround <= 0;
end

always @(posedge clk, negedge rstn) begin
        if (!rstn)
            timer_count <= 0;
        else if (word_count == 0)
            timer_count <= 0;
        else
            timer_count <= timer_count + 1;
end

// Combo ASM
always @(*) begin
    case (state)
        idle :
            if (i_write_ok==1'b0)
                next_state <= idle;
            else if (i_data_valid_top==1'b0)
                next_state <= idle;
            else if (i_data_valid_top==1'b1 && i_data_valid_second==1'b0)
                next_state <= pre_pkt_end;
            else
                next_state <= write;
        write:
            if (word_count == 16'hffe)
                next_state <= last_one;
            else if (i_data_valid_top==1'b1 && i_data_valid_second==1'b0)
                next_state <= suspend;
            else if (i_data_valid_top==1'b1 && i_data_valid_second==1'b1 && i_data_valid_third==1'b0)
                next_state <= pre_pkt_end;
            else
                next_state <= write;
        suspend:
            if (i_data_valid_top==1'b0)
                next_state <= suspend;
            else if (i_data_valid_top==1'b1 && i_data_valid_second==1'b0)
                next_state <= pre_pkt_end;
            else
                next_state <= write;
        pre_pkt_end:
            if (i_data_valid_top==1'b1 && i_data_valid_second==1'b1)
                next_state <= write;
            else if (timer_count==50000) // after 500uS finalize pkt
                next_state <= packet_end;
            else
                next_state <= pre_pkt_end;
        packet_end :
            if (word_count[9:0]==`ONEKBOUNDARY)
                next_state <= pre_zlp;
            else
                next_state <= wait_no_write;
        pre_zlp :
            if (i_data_valid_top==1'b0)
                next_state <= zlp;
            else if (i_data_valid_second==1'b1)
                next_state <= write;
            else
                next_state <= pre_pkt_end;
        wait_no_write_zlp:
            if (i_zlp_workaround < 13000)
                next_state <= wait_no_write_zlp;
            else
                next_state <= idle;
        wait_no_write:
            if (i_write_ok==1)
                next_state <= wait_no_write;
            else
                next_state <= idle;
        last_one :
            next_state <= wait_no_write;
        zlp:
            next_state <= wait_no_write_zlp;
        default :
            next_state <= idle;
    endcase
end

// GPIF2 Signal for writing assigments
always @(*) begin
    case (state)
        idle,
        wait_no_write_zlp,
        wait_no_write : begin
            i_slwr   <= SIGNAL_NOT_ACTIVE;
            i_slcs   <= SIGNAL_NOT_ACTIVE;
            i_pktend <= SIGNAL_NOT_ACTIVE;
            i_read   <= LOW;
        end
        write: begin
            i_slwr   <= SIGNAL_ACTIVE;
            i_slcs   <= SIGNAL_ACTIVE;
            i_pktend <= SIGNAL_NOT_ACTIVE;
            i_read   <= HIGH;
        end
        packet_end : begin
            i_slwr   <= SIGNAL_ACTIVE;
            i_slcs   <= SIGNAL_ACTIVE;
            i_pktend <= (word_count[9:0]==`ONEKBOUNDARY) ? SIGNAL_NOT_ACTIVE : SIGNAL_ACTIVE; // Packet end never happens at 1K boundary SIGNAL_ACTIVE;
            i_read   <= HIGH;
        end
        last_one : begin
            i_slwr   <= SIGNAL_ACTIVE;
            i_slcs   <= SIGNAL_ACTIVE;
            i_pktend <= SIGNAL_NOT_ACTIVE;
            i_read   <= (i_data_valid_top==1) ? HIGH : LOW; // If there are data, extract it for the next stream
        end
        pre_pkt_end,
        suspend : begin
            i_slwr   <= SIGNAL_NOT_ACTIVE;
            i_slcs   <= SIGNAL_ACTIVE;
            i_pktend <= SIGNAL_NOT_ACTIVE;
            i_read   <= LOW;
        end
        pre_zlp : begin
            i_slwr   <= SIGNAL_NOT_ACTIVE;
            i_slcs   <= SIGNAL_NOT_ACTIVE;
            i_pktend <= SIGNAL_NOT_ACTIVE;
            i_read   <= LOW;
        end
        zlp : begin
            i_slwr   <= SIGNAL_NOT_ACTIVE;
            i_slcs   <= SIGNAL_ACTIVE;
            i_pktend <= SIGNAL_ACTIVE;
            i_read   <= LOW;
        end
        default : begin
            i_slwr   <= SIGNAL_NOT_ACTIVE;
            i_slcs   <= SIGNAL_NOT_ACTIVE;
            i_pktend <= SIGNAL_NOT_ACTIVE;
            i_read   <= LOW;
        end
    endcase
end

// Signals assignments:

//oddr is used to send out the clk
ODDR oddr_y                       
        ( 
	  .D1(1'b1),
	  .D2(1'b0),
	  .C(clk),
	  .Q(clk_out),
	  .CE(1'b1), 
	  .R(!rstn)
	); 

assign RESET = 1'b1;
assign PMODE = 3'bZ1Z;// 3'b1ZZ;
assign fdata  = (i_slwr==1'b0) ? i_data : 32'dz;
assign faddr  = 2'b00;
assign sloe   = 1'b1;
assign slrd   = 1'b1;
assign slwr   = i_slwr;
assign slcs   = i_slcs;  
assign pktend = i_pktend;
assign stream_full_o = i_stream_full;

// Debug part
if (DEBUG==1) begin
    // Check Input Fifo
    always @(posedge stream_clk)
    begin
        if (~stream_rstn) begin
            i_error_in <= 1'b0;
            prev_data_in <= 0;
        end else if (stream_write_i==1'b1 && i_stream_full==1'b0) begin
            prev_data_in <= stream_data_i;
            if (stream_data_i==prev_data_in+1) begin
                i_error_in <= 1'b0;
            end else begin
                i_error_in <= 1'b1;
            end
        end
    end

    synch_pulf2s  synch_pulf2s  (
        .resetnf(stream_rstn), 
        .ckf(stream_clk), 
        .pulsef(i_error_in), 
        .donef(),
        .cks(clk),
        .resetns(rstn), 
        .pulses(i_error_in_synched)
    );


    // Check GPIF bus output data
    always @(posedge clk)
    begin
        if (~rstn) begin
            i_error <= 1'b0;
            prev_data <= 0;
        end else if (i_slcs==SIGNAL_ACTIVE && i_slwr==SIGNAL_ACTIVE) begin
            prev_data <= i_data;
            if (i_data==prev_data+1) begin
                i_error <= 1'b0;
            end else begin
                i_error <= 1'b1;
            end
        end
    end

    ila_0 ila_0 (
        .clk(clk), // input wire clk
        .probe0(fdata), // input wire [31:0]  probe0  
        .probe1(faddr), // input wire [1:0]  probe1 
        .probe2(fifo_iit.i_fifo_empty), // input wire [0:0]  probe2 
        .probe3(i_slwr), // input wire [0:0]  probe3 
        .probe4(i_dma_ready), // input wire [0:0]  probe4 
        .probe5(i_dma_wtrmk), // input wire [0:0]  probe5 
        .probe6(fifo_iit.i_empty_top), // input wire [0:0]  probe6 
        .probe7(i_slcs), // input wire [0:0]  probe7 
        .probe8(i_pktend), // input wire [0:0]  probe8 
        .probe9(RESET), // input wire [0:0]  probe9 
        .probe10(i_stream_full), // input wire [0:0]  probe10 
        .probe11(i_error), // input wire [0:0]  probe11 
        .probe12(i_error_in_synched), // input wire [0:0]  probe12
        .probe13(state), // input wire [3:0]  probe13
        .probe14(i_write_ok), // input wire [0:0]  probe14
        .probe15(fifo_iit.i_fifo_read), // input wire [0:0]  probe15
        .probe16(i_data_valid_top), // input wire [0:0]  probe16
        .probe17(fifo_iit.i_fifo_data), // input wire [31:0]  probe17
        .probe18(fifo_iit.i_read_top), // input wire [0:0]  probe18
        .probe19(fifo_iit.i_full_top), // input wire [0:0]  probe19
        .probe20(fifo_iit.i_read_middle), // input wire [0:0]  probe20
        .probe21(word_count), // input wire [15:0]  probe21
        .probe22(i_data_valid_second), // input wire [0:0]  probe22
        .probe23(fifo_iit.data_top), // input wire [31:0]  probe23
        .probe24(fifo_iit.i_ne_fifo_empty), // input wire [0:0]  probe24
        .probe25(fifo_iit.i_ne_empty_middle),// input wire [0:0]  probe25
        .probe26(rstn),
        .probe27(clk),
        .probe28(stream_rstn),      
        .probe29(stream_clk),    
        .probe30(stream_data_i),       
        .probe31(stream_write_i),
        .probe32(stream_full_o),
        .probe33(stream_prog_full_o),  
        .probe34(counter_for_keep_reset_in_n)
    );                    
end                  
endmodule
