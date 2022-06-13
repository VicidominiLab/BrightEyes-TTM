// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
// Date        : Tue Jun 29 12:35:59 2021
// Host        : IITMMSDL002 running 64-bit Linux Mint 20.1
// Command     : write_verilog -force -mode synth_stub -rename_top clockUsbGen -prefix
//               clockUsbGen_ clockUsbGen_stub.v
// Design      : clockUsbGen
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clockUsbGen(clk_out100, reset, locked, clk_in400)
/* synthesis syn_black_box black_box_pad_pin="clk_out100,reset,locked,clk_in400" */;
  output clk_out100;
  input reset;
  output locked;
  input clk_in400;
endmodule
