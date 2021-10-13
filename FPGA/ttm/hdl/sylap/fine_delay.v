//////////////////////////////////////////////////////////////////////////////////
// Company:  Istituto Italiano di Tecnologia (Genova, Italy)
// Engineer: Mattia Donato
// Create Date: July 2020
// License : GPLv2
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module fine_delay(
    input clk_400,
    input reset,
    input [4:0] fineDelay1,
    input [4:0] fineDelay2,
    input [4:0] fineDelay3,
    input signal_in,
    output [4:0] fineDelay_data1,
    output [4:0] fineDelay_data2,
    output [4:0] fineDelay_data3,
    output signal_delayed
    );

  
 wire signal_predelayed, signal_predelayed2;
 
 wire idelayctrl_rdy;
   IDELAYCTRL IDELAYCTRL_inst (
      .RDY(idelayctrl_rdy),       // 1-bit output: Ready output
      .REFCLK(clk_400), // 1-bit input: Reference clock input
      .RST(reset)        // 1-bit input: Active high reset input
   );   

 IDELAYE2 #(
    .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
    .DELAY_SRC("DATAIN"),           // Delay input (IDATAIN, DATAIN)
    .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
    .IDELAY_TYPE("VAR_LOAD_PIPE"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
    .IDELAY_VALUE(0),                // Input delay tap setting (0-31)
    .PIPE_SEL("TRUE"),              // Select pipelined mode, FALSE, TRUE
    .REFCLK_FREQUENCY(400.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
    .SIGNAL_PATTERN("DATA")          // DATA, CLOCK input signal
 )
 IDELAYE2_inst (
    .CNTVALUEOUT(fineDelay_data1), // 5-bit output: Counter value output
    .DATAOUT(signal_predelayed),         // 1-bit output: Delayed data output
    .C(clk_400),                     // 1-bit input: Clock input
    .CE(),                   // 1-bit input: Active high enable increment/decrement input
    .CINVCTRL(),       // 1-bit input: Dynamic clock inversion input
    .CNTVALUEIN(fineDelay1),   // 5-bit input: Counter value input
    .DATAIN(signal_in),           // 1-bit input: Internal delay data input
    .IDATAIN(),         // 1-bit input: Data input from the I/O
    .INC(),                 // 1-bit input: Increment / Decrement tap delay input
    .LD(1),                   // 1-bit input: Load IDELAY_VALUE input
    .LDPIPEEN(1),       // 1-bit input: Enable PIPELINE register to load data input
    .REGRST(!idelayctrl_rdy)            // 1-bit input: Active-high reset tap-delay input
 );
 
 
 
 

 IDELAYE2 #(
     .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
     .DELAY_SRC("DATAIN"),           // Delay input (IDATAIN, DATAIN)
     .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
     .IDELAY_TYPE("VAR_LOAD_PIPE"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
     .IDELAY_VALUE(0),                // Input delay tap setting (0-31)
     .PIPE_SEL("TRUE"),              // Select pipelined mode, FALSE, TRUE
     .REFCLK_FREQUENCY(400.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
     .SIGNAL_PATTERN("DATA")          // DATA, CLOCK input signal
  )
 IDELAYE2_inst2 (
     .CNTVALUEOUT(fineDelay_data2), // 5-bit output: Counter value output
     .DATAOUT(signal_predelayed2),         // 1-bit output: Delayed data output
     .C(clk_400),                     // 1-bit input: Clock input
     .CE(),                   // 1-bit input: Active high enable increment/decrement input
     .CINVCTRL(),       // 1-bit input: Dynamic clock inversion input
     .CNTVALUEIN(fineDelay2),   // 5-bit input: Counter value input
     .DATAIN(signal_predelayed),           // 1-bit input: Internal delay data input
     .IDATAIN(),         // 1-bit input: Data input from the I/O
     .INC(),                 // 1-bit input: Increment / Decrement tap delay input
     .LD(1),                   // 1-bit input: Load IDELAY_VALUE input
     .LDPIPEEN(1),       // 1-bit input: Enable PIPELINE register to load data input
     .REGRST(!idelayctrl_rdy)            // 1-bit input: Active-high reset tap-delay input
  );
  
  
  
  
  
 IDELAYE2 #(
      .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
      .DELAY_SRC("DATAIN"),           // Delay input (IDATAIN, DATAIN)
      .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
      .IDELAY_TYPE("VAR_LOAD_PIPE"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .IDELAY_VALUE(0),                // Input delay tap setting (0-31)
      .PIPE_SEL("TRUE"),              // Select pipelined mode, FALSE, TRUE
      .REFCLK_FREQUENCY(400.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
      .SIGNAL_PATTERN("DATA")          // DATA, CLOCK input signal
   )
 IDELAYE2_inst3 (
      .CNTVALUEOUT(fineDelay_data3), // 5-bit output: Counter value output
      .DATAOUT(signal_delayed),         // 1-bit output: Delayed data output
      .C(clk_400),                     // 1-bit input: Clock input
      .CE(),                   // 1-bit input: Active high enable increment/decrement input
      .CINVCTRL(),       // 1-bit input: Dynamic clock inversion input
      .CNTVALUEIN(fineDelay3),   // 5-bit input: Counter value input
      .DATAIN(signal_predelayed2),           // 1-bit input: Internal delay data input
      .IDATAIN(),         // 1-bit input: Data input from the I/O
      .INC(),                 // 1-bit input: Increment / Decrement tap delay input
      .LD(1),                   // 1-bit input: Load IDELAY_VALUE input
      .LDPIPEEN(1),       // 1-bit input: Enable PIPELINE register to load data input
      .REGRST(!idelayctrl_rdy)            // 1-bit input: Active-high reset tap-delay input
   );      
    
endmodule
