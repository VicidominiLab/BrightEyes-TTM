// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
// Date        : Mon Sep 13 16:33:22 2021
// Host        : IITMMSDL002 running 64-bit Linux Mint 20.2
// Command     : write_verilog -force -mode synth_stub
//               /home/mdonato-fast/myDev/timetaggingplatform-v1-Modified/FPGA/ttm/hdl/ip/clockMainGen/clockMainGen_stub.v
// Design      : clockMainGen
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clockMainGen(clk_240, clk_400, clk_50, clk_100, reset, locked, 
  clk_in1_p, clk_in1_n)
/* synthesis syn_black_box black_box_pad_pin="clk_240,clk_400,clk_50,clk_100,reset,locked,clk_in1_p,clk_in1_n" */;
  output clk_240;
  output clk_400;
  output clk_50;
  output clk_100;
  input reset;
  output locked;
  input clk_in1_p;
  input clk_in1_n;
endmodule
