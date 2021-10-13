// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
// Date        : Fri May  7 09:32:36 2021
// Host        : IITMMSDL002 running 64-bit Linux Mint 20.1
// Command     : write_verilog -force -mode synth_stub
//               /home/mdonato-fast/myDev/timetaggingplatform/FPGA/ttm/hdl/ip/clkSylapGen/clkSylapGen_stub.v
// Design      : clkSylapGen
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clkSylapGen(clk_sylap400, clk_sylap50, reset, locked, 
  clk_in1_p, clk_in1_n)
/* synthesis syn_black_box black_box_pad_pin="clk_sylap400,clk_sylap50,reset,locked,clk_in1_p,clk_in1_n" */;
  output clk_sylap400;
  output clk_sylap50;
  input reset;
  output locked;
  input clk_in1_p;
  input clk_in1_n;
endmodule
