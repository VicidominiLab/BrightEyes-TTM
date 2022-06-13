## FPGA PINOUT MAP

## TO_FX3 CONNECTIONS
set_property -dict {PACKAGE_PIN AK24 IOSTANDARD LVCMOS25} [get_ports reset_in_n]
set_property -dict {PACKAGE_PIN AF22 IOSTANDARD LVCMOS25} [get_ports {fdata[0]}]
set_property -dict {PACKAGE_PIN AF20 IOSTANDARD LVCMOS25} [get_ports {fdata[1]}]
set_property -dict {PACKAGE_PIN AF21 IOSTANDARD LVCMOS25} [get_ports {fdata[2]}]
set_property -dict {PACKAGE_PIN AH21 IOSTANDARD LVCMOS25} [get_ports {fdata[3]}]
set_property -dict {PACKAGE_PIN AJ21 IOSTANDARD LVCMOS25} [get_ports {fdata[4]}]
set_property -dict {PACKAGE_PIN AG25 IOSTANDARD LVCMOS25} [get_ports {fdata[5]}]
set_property -dict {PACKAGE_PIN AH25 IOSTANDARD LVCMOS25} [get_ports {fdata[6]}]
set_property -dict {PACKAGE_PIN AE25 IOSTANDARD LVCMOS25} [get_ports {fdata[7]}]
set_property -dict {PACKAGE_PIN AF25 IOSTANDARD LVCMOS25} [get_ports {fdata[8]}]
set_property -dict {PACKAGE_PIN AC24 IOSTANDARD LVCMOS25} [get_ports {fdata[9]}]
set_property -dict {PACKAGE_PIN AD24 IOSTANDARD LVCMOS25} [get_ports {fdata[10]}]
set_property -dict {PACKAGE_PIN AJ26 IOSTANDARD LVCMOS25} [get_ports {fdata[11]}]
set_property -dict {PACKAGE_PIN AK26 IOSTANDARD LVCMOS25} [get_ports {fdata[12]}]
set_property -dict {PACKAGE_PIN AG27 IOSTANDARD LVCMOS25} [get_ports {fdata[13]}]
set_property -dict {PACKAGE_PIN AG28 IOSTANDARD LVCMOS25} [get_ports {fdata[14]}]
set_property -dict {PACKAGE_PIN AG30 IOSTANDARD LVCMOS25} [get_ports {fdata[15]}]
set_property -dict {PACKAGE_PIN AH30 IOSTANDARD LVCMOS25} [get_ports {fdata[16]}]
set_property -dict {PACKAGE_PIN AE30 IOSTANDARD LVCMOS25} [get_ports {fdata[17]}]
set_property -dict {PACKAGE_PIN AF30 IOSTANDARD LVCMOS25} [get_ports {fdata[18]}]
set_property -dict {PACKAGE_PIN AB29 IOSTANDARD LVCMOS25} [get_ports {fdata[19]}]
set_property -dict {PACKAGE_PIN AB30 IOSTANDARD LVCMOS25} [get_ports {fdata[20]}]
set_property -dict {PACKAGE_PIN Y30 IOSTANDARD LVCMOS25} [get_ports {fdata[21]}]
set_property -dict {PACKAGE_PIN AA30 IOSTANDARD LVCMOS25} [get_ports {fdata[22]}]
set_property -dict {PACKAGE_PIN AG29 IOSTANDARD LVCMOS25} [get_ports {fdata[23]}]
set_property -dict {PACKAGE_PIN AH29 IOSTANDARD LVCMOS25} [get_ports {fdata[24]}]
set_property -dict {PACKAGE_PIN AG20 IOSTANDARD LVCMOS25} [get_ports {fdata[25]}]
set_property -dict {PACKAGE_PIN AH20 IOSTANDARD LVCMOS25} [get_ports {fdata[26]}]
set_property -dict {PACKAGE_PIN AJ22 IOSTANDARD LVCMOS25} [get_ports {fdata[27]}]
set_property -dict {PACKAGE_PIN AJ23 IOSTANDARD LVCMOS25} [get_ports {fdata[28]}]
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS25} [get_ports {fdata[29]}]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD LVCMOS25} [get_ports {fdata[30]}]
set_property -dict {PACKAGE_PIN AC22 IOSTANDARD LVCMOS25} [get_ports {fdata[31]}]
set_property -dict {PACKAGE_PIN AC30 IOSTANDARD LVCMOS25} [get_ports {faddr[0]}]
set_property -dict {PACKAGE_PIN AC29 IOSTANDARD LVCMOS25} [get_ports {faddr[1]}]
set_property -dict {PACKAGE_PIN AJ27 IOSTANDARD LVCMOS25} [get_ports slrd]
set_property -dict {PACKAGE_PIN AF26 IOSTANDARD LVCMOS25} [get_ports slwr]
set_property -dict {PACKAGE_PIN AK28 IOSTANDARD LVCMOS25 PULLDOWN true} [get_ports flaga]
set_property -dict {PACKAGE_PIN AC26 IOSTANDARD LVCMOS25 PULLDOWN true} [get_ports flagb]
set_property -dict {PACKAGE_PIN AD26 IOSTANDARD LVCMOS25 PULLDOWN true} [get_ports flagc]
set_property -dict {PACKAGE_PIN AF28 IOSTANDARD LVCMOS25 PULLDOWN true} [get_ports flagd]
set_property -dict {PACKAGE_PIN AF27 IOSTANDARD LVCMOS25} [get_ports sloe]
set_property -dict {PACKAGE_PIN AD23 IOSTANDARD LVCMOS25} [get_ports clk_out]
set_property -dict {PACKAGE_PIN AD22 IOSTANDARD LVCMOS25} [get_ports slcs]
set_property -dict {PACKAGE_PIN AE28 IOSTANDARD LVCMOS25} [get_ports pktend]
set_property -dict {PACKAGE_PIN AK23 IOSTANDARD LVCMOS25} [get_ports {PMODE[2]}]
set_property -dict {PACKAGE_PIN AH22 IOSTANDARD LVCMOS25} [get_ports {PMODE[1]}]
set_property -dict {PACKAGE_PIN AG22 IOSTANDARD LVCMOS25} [get_ports {PMODE[0]}]
set_property -dict {PACKAGE_PIN AB24 IOSTANDARD LVCMOS25} [get_ports RESET_FX3]
#set_property -dict {PACKAGE_PIN B24 IOSTANDARD LVCMOS25} [get_ports RESET_GPIO59_FX3]

## TO_FX3 TIMING
## OUTPUT DELAY DATA
# INPUT DELAY DATA
### END TO_FX3 CONNECTIONS
########################################################################################


## CLOCK SOURCES 200MHz
set_property -dict {PACKAGE_PIN AD12 IOSTANDARD DIFF_SSTL15} [get_ports clk200_p]
set_property -dict {PACKAGE_PIN AD11 IOSTANDARD DIFF_SSTL15} [get_ports clk200_n]

# SI560 (156.25MHz) input
set_property -dict {PACKAGE_PIN K28 IOSTANDARD LVDS_25} [get_ports clk156_25_p]
set_property -dict {PACKAGE_PIN K29 IOSTANDARD LVDS_25} [get_ports clk156_25_n]


### TIMING CONSTRAINTS
### INPUT DELAY DATA
### OUTPUT DELAY DATA
### FALSE PATHS

### TIMING CONSTRAINTS
create_generated_clock -name clock_out_FX3 -source [get_pins to_cypress_fx3/oddr_y/C] -multiply_by 1 [get_ports clk_out]

### INPUT DELAY DATA
set_input_delay -clock [get_clocks clock_out_FX3] -max 3.000 [get_ports fdata*]
set_input_delay -clock [get_clocks clock_out_FX3] -min 1.500 [get_ports fdata*]

### OUTPUT DELAY DATA
set_output_delay -clock [get_clocks clock_out_FX3] -max 3.000 [get_ports fdata*]
set_output_delay -clock [get_clocks clock_out_FX3] -min 1.500 [get_ports fdata*]

set_output_delay -clock [get_clocks clock_out_FX3] -max 3.000 [get_ports slwr]
set_output_delay -clock [get_clocks clock_out_FX3] -min 1.500 [get_ports slwr]
set_output_delay -clock [get_clocks clock_out_FX3] -max 3.000 [get_ports pktend]
set_output_delay -clock [get_clocks clock_out_FX3] -min 1.500 [get_ports pktend]





## set_false_path -from [get_clocks clk_out1_clk_wiz_1] -to [get_clocks clk_240_clockMainGen]
## set_false_path -from [get_clocks clk_100_clockMainGen] -to [get_clocks clk_out1_clk_wiz_1]
## set_false_path -from [get_clocks clk_out1_clk_wiz_1] -to [get_clocks clk_100_clockMainGen]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets photon_channels*]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets laser_synchronizator/inst/clk_in1_clk_wiz_1]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets laser]
###set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets sylap_clkGen/inst/clk_in1_clk_wiz_2]



set_property CFGBVS Vcco [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]

### CLK EMCCCLK 66MHz source
set_property -dict {PACKAGE_PIN R24 IOSTANDARD LVCMOS25} [get_ports clk66mhz]

### I/Os


# J2 ON FLIM
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS25} [get_ports {photon_channels[0]}]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS25} [get_ports {photon_channels[1]}]
set_property -dict {PACKAGE_PIN H30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[2]}]
set_property -dict {PACKAGE_PIN G30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[3]}]
set_property -dict {PACKAGE_PIN D29 IOSTANDARD LVCMOS25} [get_ports {photon_channels[4]}]

set_property -dict {PACKAGE_PIN C30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[5]}]
set_property -dict {PACKAGE_PIN B28 IOSTANDARD LVCMOS25} [get_ports {photon_channels[6]}]
set_property -dict {PACKAGE_PIN A28 IOSTANDARD LVCMOS25} [get_ports {photon_channels[7]}]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS25} [get_ports {photon_channels[8]}]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS25} [get_ports {photon_channels[9]}]

set_property -dict {PACKAGE_PIN G29 IOSTANDARD LVCMOS25} [get_ports {photon_channels[10]}]
set_property -dict {PACKAGE_PIN F30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[11]}]
set_property -dict {PACKAGE_PIN B30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[12]}]
set_property -dict {PACKAGE_PIN A30 IOSTANDARD LVCMOS25} [get_ports {photon_channels[13]}]
set_property -dict {PACKAGE_PIN A25 IOSTANDARD LVCMOS25} [get_ports {photon_channels[14]}]

set_property -dict {PACKAGE_PIN A26 IOSTANDARD LVCMOS25} [get_ports {photon_channels[15]}]
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS25} [get_ports {photon_channels[16]}]
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVCMOS25} [get_ports {photon_channels[17]}]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS25} [get_ports {photon_channels[18]}]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS25} [get_ports {photon_channels[19]}]

set_property -dict {PACKAGE_PIN H26 IOSTANDARD LVCMOS25} [get_ports {photon_channels[20]}]


#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CHANNELS_P*]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CHANNELS_N*]

## CONNECTOR ON 7x7ADAPTER
## OUT21_P LA06_P C10
#set_property -dict {PACKAGE_PIN H30 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[20]}]
## OUT21_N LA06_N C11
#set_property -dict {PACKAGE_PIN G30 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[20]}]
## OUT34_P LA10_P C14
#set_property -dict {PACKAGE_PIN D29 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[33]}]
## OUT34_N LA10_N C15
#set_property -dict {PACKAGE_PIN C30 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[33]}]
## OUT9_P LA14_P C18
#set_property -dict {PACKAGE_PIN B28 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[8]}]
## OUT9_N LA14_N C19
#set_property -dict {PACKAGE_PIN A28 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[8]}]
## OUT8_P LA18_P C22
#set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[7]}]
## OUT8_N LA18_N C23
#set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[7]}]
## OUT47_P LA27_P C26
#set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[46]}]
## OUT47_N LA27_N C27
#set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[46]}]
## OUT6_P LA01_P D8
#set_property -dict {PACKAGE_PIN D26 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[5]}]
## OUT6_N LA01_N D9
#set_property -dict {PACKAGE_PIN C26 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[5]}]
## OUT1_P LA05_P D11
#set_property -dict {PACKAGE_PIN G29 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[0]}]
## OUT1_N LA05_N D12
#set_property -dict {PACKAGE_PIN F30 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[0]}]
## OUT28_P LA09_P D14
#set_property -dict {PACKAGE_PIN B30 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[27]}]
## OUT28_N LA09_N D15
#set_property -dict {PACKAGE_PIN A30 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[27]}]
## OUT16_P LA13_P D17
#set_property -dict {PACKAGE_PIN A25 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[15]}]
## OUT16_N LA13_N D18
#set_property -dict {PACKAGE_PIN A26 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[15]}]
## OUT29_P LA17_P D20
#set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[28]}]
## OUT29_N LA17_N D21
#set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[28]}]
## OUT23_P LA23_P D23
#set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[22]}]
## OUT23_N LA23_N D24
#set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[22]}]
## OUT7_P HA01_P E2
#set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[6]}]
## OUT7_N HA01_N E3
#set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[6]}]
## OUT3_P HA05_P E6
#set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[2]}]
## OUT3_N HA05_N E7
#set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[2]}]
## OUT25_P HA09_P E9
#set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[24]}]
## OUT25_N HA09_N E10
#set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[24]}]
## OUT40_P HA13_P E12
#set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[39]}]
## OUT40_N HA13_N E13
#set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[39]}]
## OUT43_P HA16_P E15
#set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[42]}]
## OUT43_N HA16_N E16
#set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[42]}]
## OUT24_P HA20_P E18
#set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[23]}]
## OUT24_N HA20_N E19
#set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[23]}]
## OUT27_P HA00_P F4
#set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[26]}]
## OUT27_N HA00_N F5
#set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[26]}]
## OUT13_P HA04_P F7
#set_property -dict {PACKAGE_PIN F11 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[12]}]
## OUT13_N HA04_N F8
#set_property -dict {PACKAGE_PIN E11 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[12]}]
## OUT33_P HA08_P F10
#set_property -dict {PACKAGE_PIN E14 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[32]}]
## OUT33_N HA08_N F11
#set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[32]}]
## OUT48_P HA12_P F13
#set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[47]}]
## OUT48_N HA12_N F14
#set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[47]}]
## OUT22_P HA15_P F16
#set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[21]}]
## OUT22_N HA15_N F17
#set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[21]}]
## OUT36_P HA19_P F19
#set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[35]}]
## OUT36_N HA19_N F20
#set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[35]}]
## OUT11_P LA00_P G6
#set_property -dict {PACKAGE_PIN C25 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[10]}]
## OUT11_N LA00_N G7
#set_property -dict {PACKAGE_PIN B25 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[10]}]
## OUT14_P LA03_P G9
#set_property -dict {PACKAGE_PIN H26 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[13]}]
## OUT42_P LA08_P G12
#set_property -dict {PACKAGE_PIN E29 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[41]}]
## OUT42_N LA08_N G13
#set_property -dict {PACKAGE_PIN E30 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[41]}]
## OUT46_P LA12_P G15
#set_property -dict {PACKAGE_PIN C29 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[45]}]
## OUT46_N LA12_N G16
#set_property -dict {PACKAGE_PIN B29 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[45]}]
## OUT49_P LA16_P G18
#set_property -dict {PACKAGE_PIN B27 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[48]}]
## OUT49_N LA16_N G19
#set_property -dict {PACKAGE_PIN A27 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[48]}]
## OUT15_P LA20_P G21
#set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[14]}]
## OUT15_N LA20_N G22
#set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[14]}]
## OUT31_P LA22_P G24
#set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[30]}]
## OUT31_N LA22_N G25
#set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[30]}]
## OUT5_P LA02_P H7
#set_property -dict {PACKAGE_PIN H24 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[4]}]
## OUT5_N LA02_N H8
#set_property -dict {PACKAGE_PIN H25 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[4]}]
## OUT20_P LA04_P H10
#set_property -dict {PACKAGE_PIN G28 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[19]}]
## OUT20_N LA04_N H11
#set_property -dict {PACKAGE_PIN F28 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[19]}]
## OUT2_P LA07_P H13
#set_property -dict {PACKAGE_PIN E28 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[1]}]
## OUT2_N LA07_N H14
#set_property -dict {PACKAGE_PIN D28 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[1]}]
## OUT41_P LA11_P H16
#set_property -dict {PACKAGE_PIN G27 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[40]}]
## OUT41_N LA11_N H17
#set_property -dict {PACKAGE_PIN F27 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[40]}]
## OUT32_P LA15_P H19
#set_property -dict {PACKAGE_PIN C24 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[31]}]
## OUT32_N LA15_N H20
#set_property -dict {PACKAGE_PIN B24 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[31]}]
## OUT44_P LA19_P H22
#set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[43]}]
## OUT44_N LA19_N H23
#set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[43]}]
## OUT37_P LA21_P H25
#set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[36]}]
## OUT37_N LA21_N H26
#set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[36]}]
## OUT19_P HA03_P J6
#set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[18]}]
## OUT19_N HA03_N J7
#set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[18]}]
## OUT4_P HA07_P J9
#set_property -dict {PACKAGE_PIN B14 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[3]}]
## OUT4_N HA07_N J10
#set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[3]}]
## OUT35_P HA11_P J12
#set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[34]}]
## OUT35_N HA11_N J13
#set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[34]}]
## OUT10_P HA14_P J15
#set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[9]}]
## OUT10_N HA14_N J16
#set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[9]}]
## OUT39_P HA18_P J18
#set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[38]}]
## OUT39_N HA18_N J19
#set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[38]}]
## OUT18_P HA02_P K7
#set_property -dict {PACKAGE_PIN D11 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[17]}]
## OUT18_N HA02_N K8
#set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[17]}]
## OUT12_P HA06_P K10
#set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[11]}]
## OUT12_N HA06_N K11
#set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[11]}]
## OUT26_P HA10_P K13
#set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[25]}]
## OUT26_N HA10_N K14
#set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[25]}]
## OUT17_P HA17_P K16
#set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[16]}]
## OUT17_N HA17_N K17
#set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[16]}]
## OUT45_P HA21_P K19
#set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[44]}]
## OUT38_P HA22_P J21
#set_property -dict {PACKAGE_PIN L11 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[37]}]
## OUT38_N HA22_N J22
#set_property -dict {PACKAGE_PIN K11 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[37]}]
## OUT45_N HA21_N K20
#set_property -dict {PACKAGE_PIN J12 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[44]}]
## OUT30_P HA23_P K22
#set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVDS_25} [get_ports {CHANNELS_P[29]}]
## OUT30_N HA23_N K23
#set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVDS_25} [get_ports {CHANNELS_N[29]}]

# SMA CONNECTOR ON 7x7ADAPTER
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS25} [get_ports CONN_J2]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS25} [get_ports CONN_J3]

set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS25} [get_ports CONN_J4]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS25} [get_ports CONN_J5]

set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS25} [get_ports CONN_J6]
set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS25} [get_ports CONN_J7]

set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS25} [get_ports CONN_J8]
set_property -dict {PACKAGE_PIN C21 IOSTANDARD LVCMOS25} [get_ports CONN_J9]


# EXTRA ON 7x7ADAPTER
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS25} [get_ports DETECTOR_VREF1]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS25} [get_ports DETECTOR_VREF0]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS25} [get_ports DETECTOR_EN_SPAD]
#set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS25} [get_ports {SDA}]






#FMC_HPC_LA25P J1 FLIM
#FMC_HPC_LA25N J6 FLIM
#FMC_HPC_LA29P J21 FLIM
#FMC_HPC_LA29N J26 FLIM
#FMC_HPC_LA31P J31 FLIM
#FMC_HPC_LA31N J36 FLIM
##             J12 FLIM
#set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[6]}]
#set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS25} [get_ports {line_clock}]
##             J17 FLIM
#set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[7]}]
#set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25} [get_ports {pixel_clock}]

set_property -dict {PACKAGE_PIN L25 IOSTANDARD LVCMOS25 PULLUP true} [get_ports frame_clock]
set_property -dict {PACKAGE_PIN K25 IOSTANDARD LVCMOS25 PULLUP true} [get_ports laser]
set_property -dict {PACKAGE_PIN Y23 IOSTANDARD LVCMOS25 PULLUP true} [get_ports line_clock]
set_property -dict {PACKAGE_PIN Y24 IOSTANDARD LVCMOS25 PULLUP true} [get_ports pixel_clock]

set_input_delay  -clock [get_clocks clk_240_clockMainGen] -max 1.500 [get_ports frame_clock]
set_input_delay  -clock [get_clocks clk_240_clockMainGen] -max 1.500 [get_ports line_clock]
set_input_delay  -clock [get_clocks clk_240_clockMainGen] -max 1.500 [get_ports pixel_clock]


##J11 on KC705
#set_property PACKAGE_PIN L25 [get_ports frame_clock]
#set_property IOSTANDARD LVCMOS25 [get_ports frame_clock]
#set_property  [get_ports frame_clock]
##J12 on KC705
#set_property PACKAGE_PIN K25 [get_ports laser]
#set_property IOSTANDARD LVCMOS25 [get_ports laser]
#set_property PULLUP true [get_ports laser]
##J13 on KC705
#set_property PACKAGE_PIN Y23 [get_ports line_clock]
#set_property IOSTANDARD LVCMOS25 [get_ports line_clock]
#set_property PULLUP true [get_ports line_clock]
##set_property -dict {PACKAGE_PIN Y23 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[6]}]
##J14 on KC705
#set_property PACKAGE_PIN Y24 [get_ports pixel_clock]
#set_property IOSTANDARD LVCMOS25 [get_ports pixel_clock]
#set_property PULLUP true [get_ports pixel_clock]
##set_property -dict {PACKAGE_PIN Y24 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[7]}]




## FIFO FULL DEBUG
## LATCHED OUTPUT for FIFO FULL
#GPIO_LED_7
#GPIO_LED_5
#CENTRAL Button for manual FIFO FULL RESET - SW5

#LED

set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS15} [get_ports {LED[0]}]
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS15} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN AC9 IOSTANDARD LVCMOS15} [get_ports {LED[2]}]
set_property -dict {PACKAGE_PIN AB9 IOSTANDARD LVCMOS15} [get_ports {LED[3]}]
set_property -dict {PACKAGE_PIN AE26 IOSTANDARD LVCMOS25} [get_ports {LED[4]}]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS25} [get_ports {LED[5]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS25} [get_ports {LED[6]}]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS25} [get_ports {LED[7]}]

set_property -dict {PACKAGE_PIN K24 IOSTANDARD LVCMOS25} [get_ports UART_PORT_TX]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports UART_PORT_RX]

set_property -dict {PACKAGE_PIN L26 IOSTANDARD LVCMOS25} [get_ports SM_FAN_PWM]

set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS15} [get_ports GPIO_SW_N]
set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVCMOS15} [get_ports GPIO_SW_S]
set_property -dict {PACKAGE_PIN AG5 IOSTANDARD LVCMOS15} [get_ports GPIO_SW_E]
set_property -dict {PACKAGE_PIN AC6 IOSTANDARD LVCMOS15} [get_ports GPIO_SW_W]
set_property -dict {PACKAGE_PIN G12 IOSTANDARD LVCMOS25} [get_ports GPIO_SW_C]

set_property -dict {PACKAGE_PIN Y28 IOSTANDARD LVCMOS25} [get_ports GPIO_DIP_SW1]
set_property -dict {PACKAGE_PIN AA28 IOSTANDARD LVCMOS25} [get_ports GPIO_DIP_SW2]
set_property -dict {PACKAGE_PIN W29 IOSTANDARD LVCMOS25} [get_ports GPIO_DIP_SW3]
set_property -dict {PACKAGE_PIN Y29 IOSTANDARD LVCMOS25} [get_ports GPIO_DIP_SW4]

create_pblock pblock_datapreparation_impl
add_cells_to_pblock [get_pblocks pblock_datapreparation_impl] [get_cells -quiet [list datapreparation_impl]]
resize_pblock [get_pblocks pblock_datapreparation_impl] -add {CLOCKREGION_X1Y0:CLOCKREGION_X1Y2}
create_pblock pblock_to_cypress_fx3
add_cells_to_pblock [get_pblocks pblock_to_cypress_fx3] [get_cells -quiet [list to_cypress_fx3]]
resize_pblock [get_pblocks pblock_to_cypress_fx3] -add {CLOCKREGION_X1Y3:CLOCKREGION_X1Y3}
create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list sylapInstGEN.clkSylapGenINST sylapInstGEN.sylapTopINST]]
resize_pblock [get_pblocks pblock_1] -add {CLOCKREGION_X1Y6:CLOCKREGION_X1Y6}

create_pblock pblock_TDC_module_complete
add_cells_to_pblock [get_pblocks pblock_TDC_module_complete] [get_cells -quiet [list TDC_module_complete]]
resize_pblock [get_pblocks pblock_TDC_module_complete] -add {CLOCKREGION_X0Y0:CLOCKREGION_X0Y6}


set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets sys_clk]

#False Path clk_100 to clk_240
set_false_path -from [get_pins to_cypress_fx3/fifo_iit/i_fifo_decoupler/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gras.gpe.rdpe/gpe1.prog_empty_i_reg/C] -to [get_pins dout_valid_to_fx3_reg/D]
set_false_path -from [get_pins resetUsbFifo_n_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/Enable_write_reg/D]
set_false_path -from [get_pins locked_usbClk_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/Enable_write_reg/D]

#False Path clk_240 to clk_100
set_false_path -from [get_pins to_cypress_fx3/fifo_iit/i_fifo_decoupler/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwas.wsts/ram_full_i_reg/C] -to [get_pins led_full_flag_fx3_reg/D]
set_false_path -from [get_pins to_cypress_fx3/fifo_iit/i_fifo_decoupler/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwas.gpf.wrpf/gpf1.prog_full_i_reg/C] -to [get_pins led_prog_full_flag_fx3_reg/D]



#False Path TAP DELAY LINE
set_false_path -from [get_pins {TDC_module_complete/TDL_ch*.TDL/hit_filter/input_filter2/C}] -to [get_pins {TDC_module_complete/TDL_ch*.TDL/tdl/latch*.AFF_FF.FDR_1/D}]
set_false_path -from [get_pins TDC_module_complete/TDL_laser/hit_filter/input_filter2/C] -to [get_pins {TDC_module_complete/TDL_laser/tdl/latch*.AFF_FF.FDR_1/D}]
set_false_path -through [get_pins {TDC_module_complete/TDL_ch*.TDL/hit_filter/input_filter2/C}]

#False Path SYLAP 
#set_false_path -from [get_clocks -of_objects [get_pins clock_gen/inst/mmcm_adv_inst/CLKOUT3]] -to [get_clocks -of_objects [get_pins clock_gen/inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins sylapInstGEN.clkSylapGenINST/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins clock_gen/inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins sylapInstGEN.clkSylapGenINST/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins sylapInstGEN.clkSylapGenINST/inst/mmcm_adv_inst/CLKOUT0]]
