`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Istituto Italiano di Tecnologia (Genova, Italy)
// Engineer: Mattia Donato
// 
// Create Date: 07/30/2020 02:50:39 PM
// Design Name: 
// Module Name: uart_commands
// License : to be defined
// 
//////////////////////////////////////////////////////////////////////////////////



module sylapTop(
    output output_simLaser,
    output output_simPulse,
    output output_simPulseFineDelayed,
    output output_simStart,

    output[7:0] DebugLED,
    input reset,
    input clk_400, 
    input clk_50,
    input UART_PORT_RX,
    output UART_PORT_TX
    );

        
    
    reg uart_enable=1;
    
    wire simLaser, simPulse, simStart;
    wire rxclk_en, txclk_en;
    wire resetCmd;
    
    wire UartRxDV;
    wire [7:0] uartRxData;
    wire [7:0] lastValidValue;
    wire [31:0]pulseLength;         
    wire [31:0]pulseOffset;            
    wire [31:0]pulseOffsetPlusLength; 
    wire [31:0]laserLengthHalf;  
    wire [7:0] laserCountsMax;
    wire [4:0] fineDelay1,  fineDelay_out1;
    wire [4:0] fineDelay2,  fineDelay_out2;
    wire [4:0] fineDelay3,  fineDelay_out3;
    wire enableGenerator;
    
    wire pulse,pulse_finedelayed;
    
    
    assign pulse = simPulse&simStart;
    
    assign output_simLaser = simLaser;
    assign output_simPulse = pulse;
    assign output_simPulseFineDelayed = pulse_finedelayed;
    assign output_simStart = simStart;
    
    
    
    
    
    
      sylapGen SYLAPGEN
      (
      .clk(clk_400),
      .reset(reset | !enableGenerator | resetCmd),
      .pulseOffset(pulseOffset),
      .pulseOffsetPlusLength(pulseOffsetPlusLength),
      .laserLengthHalf(laserLengthHalf),
      .laserCountsMax(laserCountsMax),
      .LED(),
      .simLaser(simLaser),
      .simPulse(simPulse),
      .simStart(simStart)
            
      );
      
              
        baud_rate_gen uart_baud(.clk_50m(clk_50),
                                .rxclk_en(rxclk_en),
                                .txclk_en(txclk_en));
                          
        receiver uart_rx(.rx(UART_PORT_RX),
                         .rdy(UartRxDV),
                         .rdy_clr(0),
                         .clk_50m(clk_50),
                         .clken(rxclk_en),
                         .data(uartRxData));
    
       uart_commands commands(.clk_50(clk_50),
                              .reset(reset),        
                              .UartRxDV(UartRxDV),              
                              .uartRxData(uartRxData),   
                              .enableGenerator(enableGenerator),         
                              .pulseLength(pulseLength),           
                              .pulseOffset(pulseOffset),           
                              .pulseOffsetPlusLength(pulseOffsetPlusLength), 
                              .laserLengthHalf(laserLengthHalf),       
                              .laserCountsMax(laserCountsMax),        
                              .lastValidValue(lastValidValue),
                              .fineDelay1(fineDelay1),
                              .fineDelay2(fineDelay2),
                              .fineDelay3(fineDelay3),
                              .resetCmd(resetCmd)
                              );
    
    
                      
                          
      
       
       //assign LED=lastValidValue;
       assign DebugLED={3'd0,fineDelay_out1};
    
       fine_delay pulse_fine_delayer(
        .clk_400(clk_400),
        .reset(reset),
        .fineDelay1(fineDelay1),
        .fineDelay2(fineDelay2),
        .fineDelay3(fineDelay3),
        .signal_in(pulse),
        .fineDelay_data1(fineDelay_out1),
        .fineDelay_data2(fineDelay_out2),
        .fineDelay_data3(fineDelay_out3),
        .signal_delayed(pulse_finedelayed)
        );
     
     
                      
                      

endmodule
