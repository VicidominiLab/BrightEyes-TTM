//////////////////////////////////////////////////////////////////////////////////
// Company:  Istituto Italiano di Tecnologia (Genova, Italy)
// Engineer: Mattia Donato
// Create Date: July 2020
// License : GPLv2
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps


module uart_commands(
    input        clk_50,
    input        reset,
    input        UartRxDV,
    input  [7:0] uartRxData,
    output enableGenerator,
    output [31:0]pulseLength,
    output [31:0]pulseOffset,
    output [31:0]pulseOffsetPlusLength,
    output [31:0]laserLengthHalf,
    output [7:0] laserCountsMax,
    output [7:0] lastValidValue,
    output [4:0] fineDelay1,
    output [4:0] fineDelay2,
    output [4:0] fineDelay3, 
    output resetCmd
    );
    
    reg [31:0]pulseLength_reg=32'd100;
    reg [31:0]pulseOffset_reg=32'd100;
    reg [31:0]pulseOffsetPlusLength_reg=32'd102;
    reg [31:0]laserLengthHalf_reg=32'd4000;
    reg [7:0] laserCountsMax_reg=7'd10;
    reg [4:0] fineDelay1_reg=5'd0;
    reg [4:0] fineDelay2_reg=5'd0;
    reg [4:0] fineDelay3_reg=5'd0;
    
    
    reg enableGenerator_reg=0;
    reg resetCmd_reg=0;
    
    assign resetCmd=resetCmd_reg;
    assign enableGenerator=enableGenerator_reg;
    assign pulseLength=pulseLength_reg;
    assign pulseOffset=pulseOffset_reg;
    assign pulseOffsetPlusLength=pulseOffsetPlusLength_reg;
    assign laserLengthHalf=laserLengthHalf_reg;
    assign laserCountsMax=laserCountsMax_reg;
    assign fineDelay1=fineDelay1_reg;
    assign fineDelay2=fineDelay2_reg;
    assign fineDelay3=fineDelay3_reg;
    
    reg blinkLEDreg,UartRxClr;
    
    reg UartRxDV_reg, UartRxDV_regreg;
    reg UartRxDV_clear;
    reg [7:0] uartRxData_store [0:7];
    assign lastValidValue=uartRxData_store[4];
     
     always @ (posedge clk_50)
          begin
               if (reset)
               begin
                   uartRxData_store[0]<=0;
                   uartRxData_store[1]<=0;
                   uartRxData_store[2]<=0;
                   uartRxData_store[3]<=0;
                   uartRxData_store[4]<=0;
                   enableGenerator_reg<=0;
                   UartRxDV_clear<=0;
                   fineDelay1_reg<=5'd0;
                   fineDelay2_reg<=5'd0;
                   resetCmd_reg<=0;
               end
               else 
                begin 
                UartRxDV_clear <= 0;
                resetCmd_reg<=0;

                        if(UartRxDV==1)
                          begin
                           UartRxDV_reg <= UartRxDV;
                           uartRxData_store[7]<=uartRxData_store[6];                          
                           uartRxData_store[6]<=uartRxData_store[5];                          
                           uartRxData_store[5]<=uartRxData_store[4];                          
                           uartRxData_store[4]<=uartRxData_store[3];
                           uartRxData_store[3]<=uartRxData_store[2];
                           uartRxData_store[2]<=uartRxData_store[1];
                           uartRxData_store[1]<=uartRxData_store[0];
                           uartRxData_store[0]<=uartRxData;
                          end
                       else if(UartRxDV_reg==1)
                          begin
                              if ((uartRxData_store[7]==8'hAA) & (uartRxData_store[6]==8'hBB) & (uartRxData_store[5]==8'hCC)) 
                                begin
                                      resetCmd_reg<=0;
                                            if ((uartRxData_store[4]==8'h00) && (uartRxData_store[0]==8'h80))
                                                begin
                                                    enableGenerator_reg<=uartRxData_store[1][0];
                                                    resetCmd_reg<=1;
                                                end
                                       else if ((uartRxData_store[4]==8'h01) && (uartRxData_store[0]==8'h81))
                                               begin
                                                   pulseOffset_reg<={uartRxData_store[2],uartRxData_store[1]};
                                                   pulseOffsetPlusLength_reg<=(pulseOffset_reg+pulseLength_reg);
                                               end
                                       else if ((uartRxData_store[4]==8'h02) && (uartRxData_store[0]==8'h82))
                                               begin
                                                   pulseLength_reg <= {uartRxData_store[2],uartRxData_store[1]};
                                                   pulseOffsetPlusLength_reg<=(pulseOffset_reg+{uartRxData_store[2],uartRxData_store[1]});
                                               end
                                       else if ((uartRxData_store[4]==8'h03) && (uartRxData_store[0]==8'h83))
                                               begin
                                                   laserLengthHalf_reg<={uartRxData_store[2],uartRxData_store[1]};
                                               end
                                       else if ((uartRxData_store[4]==8'h04) && (uartRxData_store[0]==8'h84))
                                               begin
                                                   laserCountsMax_reg<={24'd0,uartRxData_store[1]};
                                               end
               
                                       else if ((uartRxData_store[4]==8'h05) && (uartRxData_store[0]==8'h85))
                                               begin
                                                   fineDelay1_reg<=uartRxData_store[1][4:0];
                                               end
                                       else if ((uartRxData_store[4]==8'h06) && (uartRxData_store[0]==8'h86))
                                               begin
                                                   fineDelay2_reg<=uartRxData_store[1][4:0];
                                               end
                                       else if ((uartRxData_store[4]==8'h07) && (uartRxData_store[0]==8'h87))
                                                       begin
                                                           fineDelay2_reg<=uartRxData_store[1][4:0];
                                                       end                                               
                                       else if ((uartRxData_store[4]==8'h08) && (uartRxData_store[0]==8'h88))
                                               begin
                                                 fineDelay1_reg<={1'd0,uartRxData_store[1][4:1]}+{4'd0,uartRxData_store[1][0]};
                                                 fineDelay2_reg<={1'd0,uartRxData_store[1][4:1]};
                                               end
                                                                                                                         
                                       else if ((uartRxData_store[4]==8'h10) && (uartRxData_store[0]==8'h90))
                                                               begin
                                                                   enableGenerator_reg<=1;
                                                                   pulseLength_reg <= 32'd100;
                                                                   pulseOffset_reg <= 32'd100;
                                                                   pulseOffsetPlusLength_reg <= 32'd102;
                                                                   laserLengthHalf_reg <= 32'd4000;
                                                                   laserCountsMax_reg <= 7'd10;
                                                                   fineDelay1_reg<=0;
                                                                   fineDelay2_reg<=0;                                                                   
                                                               end   
                                       else if ((uartRxData_store[4]==8'h11) && (uartRxData_store[0]==8'h91))  //To set the [16:0]Offset + [7:2]FineOffset
                                                                      begin
                                                                         pulseOffset_reg <= {uartRxData_store[3],uartRxData_store[2]};
                                                                         pulseOffsetPlusLength_reg<=({uartRxData_store[3],uartRxData_store[2]})+(pulseLength_reg);
                                                                         
                                                                         if (uartRxData_store[1][7:2]==6'd63)
                                                                            begin
                                                                                fineDelay1_reg <=5'b11111;
                                                                                fineDelay2_reg<=5'b11111;
                                                                                fineDelay3_reg<=5'b00001;
                                                                            end
                                                                         else
                                                                            begin 
                                                                                fineDelay1_reg<={1'd0,uartRxData_store[1][7:3]}+{4'd0,uartRxData_store[1][2]};
                                                                                fineDelay2_reg<={1'd0,uartRxData_store[1][7:3]};
                                                                                fineDelay3_reg<=0;
                                                                            end                                                                                                                                                                     
                                                                                                                                                                                                                
                                                                      end     
                                       else if ((uartRxData_store[4]==8'h12) && (uartRxData_store[0]==8'h92))  //To set the [16:0]Offset + [7:2]FineOffset
                                                                          begin
                                                                              resetCmd_reg<=1;
                                                                          end                                                                                                                                                             
                                end                                   
                          end
               end
          end 
                
endmodule
