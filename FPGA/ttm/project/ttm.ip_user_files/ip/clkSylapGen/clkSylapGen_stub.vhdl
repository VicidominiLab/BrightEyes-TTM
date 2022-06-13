-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
-- Date        : Tue Jun 29 12:35:59 2021
-- Host        : IITMMSDL002 running 64-bit Linux Mint 20.1
-- Command     : write_vhdl -force -mode synth_stub -rename_top clkSylapGen -prefix
--               clkSylapGen_ clkSylapGen_stub.vhdl
-- Design      : clkSylapGen
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clkSylapGen is
  Port ( 
    clk_sylap400 : out STD_LOGIC;
    clk_sylap50 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );

end clkSylapGen;

architecture stub of clkSylapGen is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_sylap400,clk_sylap50,reset,locked,clk_in1_p,clk_in1_n";
begin
end;
