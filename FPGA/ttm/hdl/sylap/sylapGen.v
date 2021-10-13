//////////////////////////////////////////////////////////////////////////////////
// Company:  Istituto Italiano di Tecnologia (Genova, Italy)
// Engineer: Mattia Donato
// Create Date: July 2020
// License : GPLv2
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module sylapGen(
    input clk,
    input reset,
    
    input [31:0] pulseOffset,
    input [31:0] pulseOffsetPlusLength,
    input [31:0] laserLengthHalf,
    input [7:0] laserCountsMax,
    output [7:0] LED,
    output simLaser,
    output simPulse,
    output simStart
            
    
    );
    
    reg [7:0]laserCounts = 0;
    reg [7:0]pulseCounter = 0;
    reg [31:0]counts_continuous;
    reg [31:0]counts;
    reg [31:0]counts_plus_1;
    reg simLaser_reg,simPulse_reg,simStart_reg;
    
    assign simLaser=simLaser_reg;
    assign simPulse=simPulse_reg;
    assign simStart=simStart_reg;
             
    reg reset_counts, reset_counts_continuous, reset_laserCounts;
    reg enable_counts, enable_counts_continuous, enable_laserCounts;


    always @ (posedge clk or posedge reset_counts or posedge reset)
     begin
          if (reset_counts || reset)
            begin
                   counts <= 0;
                   counts_plus_1 <= 32'd1;
            end
          else if (enable_counts)
            begin
               counts <= counts+1;
               counts_plus_1 <=counts_plus_1+1;
            end
     end 


    always @ (posedge clk or posedge reset_counts_continuous or posedge reset)
     begin
          if (reset_counts_continuous || reset)
                   counts_continuous <= 0;
          else if (enable_counts_continuous)
               counts_continuous <= counts_continuous+1;
     end 

    always @ (posedge clk or posedge reset_laserCounts or posedge reset)
     begin
          if (reset_laserCounts || reset)
            begin
                   laserCounts <= 0;
                    simStart_reg <= 1;
            end
          else if (laserCounts >= laserCountsMax) 
            begin
              laserCounts <=0;
              simStart_reg <= 1;
            end            
          else if (reset_counts==1) 
            begin          
               laserCounts <= laserCounts+1;
               simStart_reg <= 0;
               if ((laserCountsMax==0) || (laserCountsMax==1)) simStart_reg <= 1;
            end

     end 



    always @ (posedge clk)
      begin
          if (reset)
             begin
                   reset_counts <= 1;
                   reset_counts_continuous <= 1;
                   reset_laserCounts <= 1;
                   
                   simLaser_reg <= 0;
                   simPulse_reg <= 0;
             end
          else
             begin
                 enable_counts <= 1;
                 enable_counts_continuous <= 1 ;
                 
                 reset_counts <= 0;
                 reset_counts_continuous <= 0;
                 reset_laserCounts <=0;
                 simLaser_reg <= 0;                          
                
                          
                 
                 if ((counts >= laserLengthHalf))
                    begin
                     simLaser_reg <= 1;
                     if (counts[31:1] >= laserLengthHalf[30:0]) 
                          begin
                            simLaser_reg <= 1;
                            reset_counts <= 1; //counts <= 0;
                          end
                    end

                simPulse_reg <= 0;
                if ((counts > pulseOffset) && (counts <= pulseOffsetPlusLength)) simPulse_reg <= 1;
        end 
        
     end 
     
     
     assign LED[7] = counts_continuous[29];
     assign LED[6:0] = counts[10:4];
     
    
    
endmodule
