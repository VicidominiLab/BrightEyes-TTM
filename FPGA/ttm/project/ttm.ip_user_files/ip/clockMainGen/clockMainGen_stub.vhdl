-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
-- Date        : Tue Jul 13 12:27:37 2021
-- Host        : IITMMSDL002 running 64-bit Linux Mint 20.1
-- Command     : write_vhdl -force -mode synth_stub -rename_top clockMainGen -prefix
--               clockMainGen_ clockMainGen_stub.vhdl
-- Design      : clockMainGen
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clockMainGen is
  Port ( 
    clk_240 : out STD_LOGIC;
    clk_400 : out STD_LOGIC;
    clk_50 : out STD_LOGIC;
    clk_100 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );

end clockMainGen;

architecture stub of clockMainGen is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_240,clk_400,clk_50,clk_100,reset,locked,clk_in1_p,clk_in1_n";
begin
end;
