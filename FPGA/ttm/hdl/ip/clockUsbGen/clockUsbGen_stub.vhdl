-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
-- Date        : Fri May  7 09:32:36 2021
-- Host        : IITMMSDL002 running 64-bit Linux Mint 20.1
-- Command     : write_vhdl -force -mode synth_stub
--               /home/mdonato-fast/myDev/timetaggingplatform/FPGA/ttm/hdl/ip/clockUsbGen/clockUsbGen_stub.vhdl
-- Design      : clockUsbGen
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clockUsbGen is
  Port ( 
    clk_out100 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in400 : in STD_LOGIC
  );

end clockUsbGen;

architecture stub of clockUsbGen is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out100,reset,locked,clk_in400";
begin
end;
