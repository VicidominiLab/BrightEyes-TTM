//////////////////////////////////////////////////////////////////////////////////
// Company : Electronic Design Laboratory, Istituto Italiano di Tecnologia
// Engineer: Francesco Diotalevi 
// Date    : 2015
// Design  : synchronize a pulse signal from slow clock domain to fast clock domain
// License : CC BY-NC 4.0 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module synch_pulf2s    (
	input  resetnf, 
	input  ckf, 
	input  pulsef, 
	output donef,
    input  cks,
	input  resetns, 
	output pulses
);

reg pulsef_s;
reg [2 : 0] ackf;
reg [2 : 0] reqs_s;
wire i_donef;

always @(posedge ckf or negedge resetnf)
begin
    if (resetnf==0) begin
        ackf<= 0;
        pulsef_s <= 0;
    end
    else begin
        ackf <= {ackf[1:0],pulses};
    
        if (i_donef)
            pulsef_s <= 0;
        else if (pulsef)
            pulsef_s <= 1;
    end
end

assign req = pulsef | pulsef_s;

always @(posedge cks or negedge resetns)
begin
    if (resetns==0)
        reqs_s <= 0;
    else
        reqs_s <= {reqs_s[1:0],req};
end

assign pulses  = reqs_s[1]&~reqs_s[2];
assign i_donef = ~ackf[1]&ackf[2];
assign donef   = i_donef;

endmodule 
