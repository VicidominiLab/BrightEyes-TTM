`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2021 09:49:18 AM
// Design Name: 
// Module Name: therm2bin_easy
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module therm2bin_easy #(
    parameter out_length = 9,
    parameter in_length = 128
    )
    (
        input clock,
        input reset,
        input valid,
        input [((2**out_length)-1):0] thermo,
        output [out_length-1:0] bin,
        output valid_bin    
    
    );
    
        integer i;
        
        reg [out_length-1:0] bin_r ; 
        //reg [((2**out_length)-1):0] thermo_pre_r;
        reg [in_length:0] thermo_pre_r;
        reg valid_bin_r;
        reg valid_pre_r;
        reg valid_pre_rr;
        
        reg [out_length-1:0] bin_pre [4:0];
        reg [4:0] valid_bin_pre ;
        
        
        
        always @(posedge clock)
            begin
                thermo_pre_r <= thermo[in_length:0];
                valid_pre_rr <= valid;                
            end
        
        always @(posedge clock)
            begin
                //valid_pre_r  <= valid_pre_rr;
                valid_bin_r <= valid_pre_rr; 
                bin_r=0;
                
                for (i=0; i<in_length; i=i+1)
                    begin
                         if (thermo_pre_r[i-1]==1'b1) bin_r=i;
                    end
            end    
            
        always @(posedge clock)
                begin
                    bin_pre[3] <= bin_r;
                    valid_bin_pre[3] <= valid_bin_r;
                    
                    bin_pre[2] <= bin_pre[3];
                    valid_bin_pre[2] <= valid_bin_pre[3];
                    
                    bin_pre[1] <= bin_pre[2];
                    valid_bin_pre[1] <= valid_bin_pre[2];

                    bin_pre[0] <= bin_pre[1];
                    valid_bin_pre[0] <= valid_bin_pre[1];

                end   

        assign bin = bin_pre[0];
        assign valid_bin = valid_bin_pre[0];
    
endmodule
