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
set_property PACKAGE_PIN AK28 [get_ports flaga]
set_property IOSTANDARD LVCMOS25 [get_ports flaga]
set_property PULLDOWN true [get_ports flaga]
set_property PACKAGE_PIN AC26 [get_ports flagb]
set_property IOSTANDARD LVCMOS25 [get_ports flagb]
set_property PULLDOWN true [get_ports flagb]
set_property PACKAGE_PIN AD26 [get_ports flagc]
set_property IOSTANDARD LVCMOS25 [get_ports flagc]
set_property PULLDOWN true [get_ports flagc]
set_property PACKAGE_PIN AF28 [get_ports flagd]
set_property IOSTANDARD LVCMOS25 [get_ports flagd]
set_property PULLDOWN true [get_ports flagd]
set_property -dict {PACKAGE_PIN AF27 IOSTANDARD LVCMOS25} [get_ports sloe]
set_property -dict {PACKAGE_PIN AD23 IOSTANDARD LVCMOS25} [get_ports clk_out]
set_property -dict {PACKAGE_PIN AD22 IOSTANDARD LVCMOS25} [get_ports slcs]
set_property -dict {PACKAGE_PIN AE28 IOSTANDARD LVCMOS25} [get_ports pktend]
set_property -dict {PACKAGE_PIN AK23 IOSTANDARD LVCMOS25} [get_ports {PMODE[2]}]
set_property -dict {PACKAGE_PIN AH22 IOSTANDARD LVCMOS25} [get_ports {PMODE[1]}]
set_property -dict {PACKAGE_PIN AG22 IOSTANDARD LVCMOS25} [get_ports {PMODE[0]}]
set_property -dict {PACKAGE_PIN AB24 IOSTANDARD LVCMOS25} [get_ports RESET_FX3]
set_property -dict {PACKAGE_PIN B24 IOSTANDARD LVCMOS25} [get_ports RESET_GPIO59_FX3]

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


## set_false_path -from [get_clocks clk_out1_clk_wiz_1] -to [get_clocks clk_240_clockMainGen]
## set_false_path -from [get_clocks clk_100_clockMainGen] -to [get_clocks clk_out1_clk_wiz_1]
## set_false_path -from [get_clocks clk_out1_clk_wiz_1] -to [get_clocks clk_100_clockMainGen]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets photon_channels*]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets laser_synchronizator/inst/clk_in1_clk_wiz_1]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets laser]
###set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets sylap_clkGen/inst/clk_in1_clk_wiz_2]



set_property CFGBVS Vcco [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]

### CLK EMCCCLK 66MHz source
set_property -dict {PACKAGE_PIN R24 IOSTANDARD LVCMOS25} [get_ports clk66mhz]

### I/Os


## J2 ON FLIM
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








#FMC_HPC_LA25P J1 FLIM
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[0]}]
#FMC_HPC_LA25N J6 FLIM
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[1]}]
#FMC_HPC_LA29P J21 FLIM
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[2]}]
#FMC_HPC_LA29N J26 FLIM
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[3]}]
#FMC_HPC_LA31P J31 FLIM
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[4]}]
#FMC_HPC_LA31N J36 FLIM
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[5]}]
##             J12 FLIM
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[6]}]
#set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS25} [get_ports {line_clock}]
##             J17 FLIM
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[7]}]
#set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS25} [get_ports {pixel_clock}]


#J11 on KC705
set_property PACKAGE_PIN L25 [get_ports frame_clock]
set_property IOSTANDARD LVCMOS25 [get_ports frame_clock]
set_property PULLUP true [get_ports frame_clock]
#J12 on KC705
set_property PACKAGE_PIN K25 [get_ports laser]
set_property IOSTANDARD LVCMOS25 [get_ports laser]
set_property PULLUP true [get_ports laser]
#J13 on KC705
set_property PACKAGE_PIN Y23 [get_ports line_clock]
set_property IOSTANDARD LVCMOS25 [get_ports line_clock]
set_property PULLUP true [get_ports line_clock]
#set_property -dict {PACKAGE_PIN Y23 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[6]}]
#J14 on KC705
set_property PACKAGE_PIN Y24 [get_ports pixel_clock]
set_property IOSTANDARD LVCMOS25 [get_ports pixel_clock]
set_property PULLUP true [get_ports pixel_clock]
#set_property -dict {PACKAGE_PIN Y24 IOSTANDARD LVCMOS25} [get_ports {HPC_FLIM[7]}]


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

#set_false_path -from [get_pins TDC_with_event_fiter/memoria/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwas.gpf.wrpf/gpf1.prog_full_i_reg/C] -to [get_pins write_enable_to_fx3_reg/D]


#create_pblock pblock_sylpInstGN.sylpTpINST
#add_cells_to_pblock [get_pblocks pblock_sylpInstGN.sylpTpINST] [get_cells -quiet [list sylapInstGEN.sylapTopINST]]


create_pblock pblock_to_cypress_fx3
add_cells_to_pblock [get_pblocks pblock_to_cypress_fx3] [get_cells -quiet [list {to_cypress_fx3/FSM_sequential_state[0]_i_10} {to_cypress_fx3/FSM_sequential_state[0]_i_12} {to_cypress_fx3/FSM_sequential_state[0]_i_13} {to_cypress_fx3/FSM_sequential_state[0]_i_14} {to_cypress_fx3/FSM_sequential_state[0]_i_2} {to_cypress_fx3/FSM_sequential_state[0]_i_5} {to_cypress_fx3/FSM_sequential_state[0]_i_7} {to_cypress_fx3/FSM_sequential_state[0]_i_9} {to_cypress_fx3/FSM_sequential_state[1]_i_3} {to_cypress_fx3/FSM_sequential_state[2]_i_10} {to_cypress_fx3/FSM_sequential_state[2]_i_3} {to_cypress_fx3/FSM_sequential_state[2]_i_6} {to_cypress_fx3/FSM_sequential_state[2]_i_9} {to_cypress_fx3/FSM_sequential_state[3]_i_1} {to_cypress_fx3/FSM_sequential_state[3]_i_10} {to_cypress_fx3/FSM_sequential_state[3]_i_2} {to_cypress_fx3/FSM_sequential_state[3]_i_3} {to_cypress_fx3/FSM_sequential_state[3]_i_4} {to_cypress_fx3/FSM_sequential_state[3]_i_5} {to_cypress_fx3/FSM_sequential_state[3]_i_6} {to_cypress_fx3/FSM_sequential_state[3]_i_7} {to_cypress_fx3/FSM_sequential_state[3]_i_8} {to_cypress_fx3/FSM_sequential_state[3]_i_9} {to_cypress_fx3/FSM_sequential_state_reg[0]} {to_cypress_fx3/FSM_sequential_state_reg[1]} {to_cypress_fx3/FSM_sequential_state_reg[2]} {to_cypress_fx3/FSM_sequential_state_reg[3]} to_cypress_fx3/GND to_cypress_fx3/VCC {to_cypress_fx3/fdata_OBUFT[31]_inst_i_2} to_cypress_fx3/fifo_iit/Enable_write_i_1 to_cypress_fx3/fifo_iit/Enable_write_reg to_cypress_fx3/fifo_iit/GND to_cypress_fx3/fifo_iit/TDC_module_complete_i_24 to_cypress_fx3/fifo_iit/VCC to_cypress_fx3/fifo_iit/dout_valid_to_fx3_i_1 to_cypress_fx3/fifo_iit/i_empty_middle_s_reg to_cypress_fx3/fifo_iit/i_fifo_empty_s_i_1 to_cypress_fx3/fifo_iit/i_fifo_empty_s_reg to_cypress_fx3/fifo_iit/middle_fifo to_cypress_fx3/fifo_iit/top_fifo {to_cypress_fx3/i_zlp_workaround[0]_i_2} {to_cypress_fx3/i_zlp_workaround[0]_i_3} {to_cypress_fx3/i_zlp_workaround[0]_i_4} {to_cypress_fx3/i_zlp_workaround[0]_i_5} {to_cypress_fx3/i_zlp_workaround[0]_i_6} {to_cypress_fx3/i_zlp_workaround[12]_i_2} {to_cypress_fx3/i_zlp_workaround[12]_i_3} {to_cypress_fx3/i_zlp_workaround[12]_i_4} {to_cypress_fx3/i_zlp_workaround[12]_i_5} {to_cypress_fx3/i_zlp_workaround[16]_i_2} {to_cypress_fx3/i_zlp_workaround[16]_i_3} {to_cypress_fx3/i_zlp_workaround[16]_i_4} {to_cypress_fx3/i_zlp_workaround[16]_i_5} {to_cypress_fx3/i_zlp_workaround[4]_i_2} {to_cypress_fx3/i_zlp_workaround[4]_i_3} {to_cypress_fx3/i_zlp_workaround[4]_i_4} {to_cypress_fx3/i_zlp_workaround[4]_i_5} {to_cypress_fx3/i_zlp_workaround[8]_i_2} {to_cypress_fx3/i_zlp_workaround[8]_i_3} {to_cypress_fx3/i_zlp_workaround[8]_i_4} {to_cypress_fx3/i_zlp_workaround[8]_i_5} {to_cypress_fx3/i_zlp_workaround_reg[0]} {to_cypress_fx3/i_zlp_workaround_reg[0]_i_1} {to_cypress_fx3/i_zlp_workaround_reg[10]} {to_cypress_fx3/i_zlp_workaround_reg[11]} {to_cypress_fx3/i_zlp_workaround_reg[12]} {to_cypress_fx3/i_zlp_workaround_reg[12]_i_1} {to_cypress_fx3/i_zlp_workaround_reg[13]} {to_cypress_fx3/i_zlp_workaround_reg[14]} {to_cypress_fx3/i_zlp_workaround_reg[15]} {to_cypress_fx3/i_zlp_workaround_reg[16]} {to_cypress_fx3/i_zlp_workaround_reg[16]_i_1} {to_cypress_fx3/i_zlp_workaround_reg[17]} {to_cypress_fx3/i_zlp_workaround_reg[18]} {to_cypress_fx3/i_zlp_workaround_reg[19]} {to_cypress_fx3/i_zlp_workaround_reg[1]} {to_cypress_fx3/i_zlp_workaround_reg[2]} {to_cypress_fx3/i_zlp_workaround_reg[3]} {to_cypress_fx3/i_zlp_workaround_reg[4]} {to_cypress_fx3/i_zlp_workaround_reg[4]_i_1} {to_cypress_fx3/i_zlp_workaround_reg[5]} {to_cypress_fx3/i_zlp_workaround_reg[6]} {to_cypress_fx3/i_zlp_workaround_reg[7]} {to_cypress_fx3/i_zlp_workaround_reg[8]} {to_cypress_fx3/i_zlp_workaround_reg[8]_i_1} {to_cypress_fx3/i_zlp_workaround_reg[9]} to_cypress_fx3/oddr_y to_cypress_fx3/oddr_y_i_1 to_cypress_fx3/pktend_OBUF_inst_i_1 to_cypress_fx3/pktend_OBUF_inst_i_2 to_cypress_fx3/pktend_OBUF_inst_i_3 to_cypress_fx3/pktend_OBUF_inst_i_4 to_cypress_fx3/slcs_OBUF_inst_i_1 to_cypress_fx3/slwr_OBUF_inst_i_1 to_cypress_fx3/timer_count0_carry to_cypress_fx3/timer_count0_carry__0 to_cypress_fx3/timer_count0_carry__1 to_cypress_fx3/timer_count0_carry__2 to_cypress_fx3/timer_count0_carry__3 {to_cypress_fx3/timer_count[0]_i_1} {to_cypress_fx3/timer_count[10]_i_1} {to_cypress_fx3/timer_count[11]_i_1} {to_cypress_fx3/timer_count[12]_i_1} {to_cypress_fx3/timer_count[13]_i_1} {to_cypress_fx3/timer_count[14]_i_1} {to_cypress_fx3/timer_count[15]_i_1} {to_cypress_fx3/timer_count[16]_i_1} {to_cypress_fx3/timer_count[17]_i_1} {to_cypress_fx3/timer_count[18]_i_1} {to_cypress_fx3/timer_count[19]_i_1} {to_cypress_fx3/timer_count[19]_i_2} {to_cypress_fx3/timer_count[19]_i_3} {to_cypress_fx3/timer_count[19]_i_4} {to_cypress_fx3/timer_count[19]_i_5} {to_cypress_fx3/timer_count[1]_i_1} {to_cypress_fx3/timer_count[2]_i_1} {to_cypress_fx3/timer_count[3]_i_1} {to_cypress_fx3/timer_count[4]_i_1} {to_cypress_fx3/timer_count[5]_i_1} {to_cypress_fx3/timer_count[6]_i_1} {to_cypress_fx3/timer_count[7]_i_1} {to_cypress_fx3/timer_count[8]_i_1} {to_cypress_fx3/timer_count[9]_i_1} {to_cypress_fx3/timer_count_reg[0]} {to_cypress_fx3/timer_count_reg[10]} {to_cypress_fx3/timer_count_reg[11]} {to_cypress_fx3/timer_count_reg[12]} {to_cypress_fx3/timer_count_reg[13]} {to_cypress_fx3/timer_count_reg[14]} {to_cypress_fx3/timer_count_reg[15]} {to_cypress_fx3/timer_count_reg[16]} {to_cypress_fx3/timer_count_reg[17]} {to_cypress_fx3/timer_count_reg[18]} {to_cypress_fx3/timer_count_reg[19]} {to_cypress_fx3/timer_count_reg[1]} {to_cypress_fx3/timer_count_reg[2]} {to_cypress_fx3/timer_count_reg[3]} {to_cypress_fx3/timer_count_reg[4]} {to_cypress_fx3/timer_count_reg[5]} {to_cypress_fx3/timer_count_reg[6]} {to_cypress_fx3/timer_count_reg[7]} {to_cypress_fx3/timer_count_reg[8]} {to_cypress_fx3/timer_count_reg[9]} {to_cypress_fx3/word_count[0]_i_1} {to_cypress_fx3/word_count[0]_i_3} {to_cypress_fx3/word_count[0]_i_4} {to_cypress_fx3/word_count[0]_i_5} {to_cypress_fx3/word_count[0]_i_6} {to_cypress_fx3/word_count[0]_i_7} {to_cypress_fx3/word_count[12]_i_2} {to_cypress_fx3/word_count[12]_i_3} {to_cypress_fx3/word_count[12]_i_4} {to_cypress_fx3/word_count[12]_i_5} {to_cypress_fx3/word_count[4]_i_2} {to_cypress_fx3/word_count[4]_i_3} {to_cypress_fx3/word_count[4]_i_4} {to_cypress_fx3/word_count[4]_i_5} {to_cypress_fx3/word_count[8]_i_2} {to_cypress_fx3/word_count[8]_i_3} {to_cypress_fx3/word_count[8]_i_4} {to_cypress_fx3/word_count[8]_i_5} {to_cypress_fx3/word_count_reg[0]} {to_cypress_fx3/word_count_reg[0]_i_2} {to_cypress_fx3/word_count_reg[10]} {to_cypress_fx3/word_count_reg[11]} {to_cypress_fx3/word_count_reg[12]} {to_cypress_fx3/word_count_reg[12]_i_1} {to_cypress_fx3/word_count_reg[13]} {to_cypress_fx3/word_count_reg[14]} {to_cypress_fx3/word_count_reg[15]} {to_cypress_fx3/word_count_reg[1]} {to_cypress_fx3/word_count_reg[2]} {to_cypress_fx3/word_count_reg[3]} {to_cypress_fx3/word_count_reg[4]} {to_cypress_fx3/word_count_reg[4]_i_1} {to_cypress_fx3/word_count_reg[5]} {to_cypress_fx3/word_count_reg[6]} {to_cypress_fx3/word_count_reg[7]} {to_cypress_fx3/word_count_reg[8]} {to_cypress_fx3/word_count_reg[8]_i_1} {to_cypress_fx3/word_count_reg[9]}]]
resize_pblock [get_pblocks pblock_to_cypress_fx3] -add {CLOCKREGION_X1Y3:CLOCKREGION_X1Y3}


create_pblock pblock_sylap


create_pblock pblock_TDC_module_complete
add_cells_to_pblock [get_pblocks pblock_TDC_module_complete] [get_cells -quiet [list TDC_module_complete]]
resize_pblock [get_pblocks pblock_TDC_module_complete] -add {CLOCKREGION_X0Y0:CLOCKREGION_X1Y2}


create_pblock pblock_i_fifo_decoupler
add_cells_to_pblock [get_pblocks pblock_i_fifo_decoupler] [get_cells -quiet [list to_cypress_fx3/fifo_iit/i_fifo_decoupler]]
resize_pblock [get_pblocks pblock_i_fifo_decoupler] -add {CLOCKREGION_X0Y4:CLOCKREGION_X1Y6}


set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets sys_clk]



#False Path TAP DELAY LINE

set_false_path -from [get_pins TDC_module_complete/TDL_ch*.TDL/input_shaping/second_photon_filter/C] -to [get_pins TDC_module_complete/TDL_ch*.TDL/delay_line/flip_flop_barrier*.AFF_FF.first_latch/D]
set_false_path -from [get_pins TDC_module_complete/TDL_laser/input_shaping/second_photon_filter/C] -to [get_pins TDC_module_complete/TDL_laser/delay_line/flip_flop_barrier*.AFF_FF.first_latch/D]
set_false_path -through [get_pins TDC_module_complete/TDL_ch*.TDL/input_shaping/second_photon_filter/C]

#False Path clk_100 to clk_240
set_false_path -from [get_pins to_cypress_fx3/fifo_iit/i_fifo_decoupler/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gras.gpe.rdpe/gpe1.prog_empty_i_reg/C] -to [get_pins dout_valid_to_fx3_reg/D]
set_false_path -from [get_pins resetUsbFifo_n_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/Enable_write_reg/D]
set_false_path -from [get_pins locked_usbClk_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/Enable_write_reg/D]


set_false_path -from [get_pins to_fx3_resetUsbFifo_n_reg_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/i_fifo_empty_s_reg/D]
set_false_path -from [get_pins to_fx3_resetUsbFifo_n_reg_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/i_empty_middle_s_reg/D]

set_false_path -from [get_pins locked_usbClk_reg/C] -to [get_pins to_fx3_resetUsbFifo_n_reg_reg/D]
set_false_path -from [get_pins resetUsbFifo_n_reg/C] -to [get_pins to_fx3_resetUsbFifo_n_reg_reg/D]

set_false_path -from [get_pins to_cypress_fx3/synch_pulf2s/pulsef_s_reg/C] -to [get_pins {to_cypress_fx3/synch_pulf2s/reqs_s_reg[0]/D}]
set_false_path -from [get_pins {to_cypress_fx3/synch_pulf2s/reqs_s_reg[1]_fret/C}] -to [get_pins {to_cypress_fx3/synch_pulf2s/ackf_reg[0]/D}]

#False Path clk_240 to clk_100
set_false_path -from [get_pins to_fx3_resetUsbFifo_n_reg_reg/C] -to [get_pins led_resetFX3_reg/D]
set_false_path -from [get_pins to_cypress_fx3/fifo_iit/i_fifo_decoupler/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwas.wsts/ram_full_i_reg/C] -to [get_pins led_full_flag_fx3_reg/D]
set_false_path -from [get_pins to_cypress_fx3/fifo_iit/i_fifo_decoupler/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwas.gpf.wrpf/gpf1.prog_full_i_reg/C] -to [get_pins led_prog_full_flag_fx3_reg/D]
set_false_path -from [get_pins {to_cypress_fx3/synch_pulf2s/reqs_s_reg[1]_fret/C}] -to [get_pins {to_cypress_fx3/synch_pulf2s/ackf_reg[0]/D}]

set_false_path -from [get_pins to_cypress_fx3/fifo_iit/i_fifo_decoupler/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwas.wsts/ram_full_i_reg/C] -to [get_pins {to_cypress_fx3/ila_fx3/U0/ila_core_inst/u_trig/U_TM/N_DDR_MODE.G_NMU[10].U_M/allx_typeA_match_detection.ltlib_v1_0_0_allx_typeA_inst/probeDelay1_reg[0]/D}]
set_false_path -from [get_pins to_cypress_fx3/fifo_iit/i_fifo_decoupler/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.wr/gwas.wsts/ram_full_i_reg/C] -to [get_pins {to_cypress_fx3/ila_fx3/U0/ila_core_inst/shifted_data_in_reg[7][42]_srl8/D}]
set_false_path -from [get_pins to_cypress_fx3/i_error_in_reg/C] -to [get_pins {to_cypress_fx3/synch_pulf2s/reqs_s_reg[0]/D}]

#False Path SYLAP 
#set_false_path -from [get_clocks -of_objects [get_pins clock_gen/inst/mmcm_adv_inst/CLKOUT3]] -to [get_clocks -of_objects [get_pins clock_gen/inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins sylapInstGEN.clkSylapGenINST/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins clock_gen/inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins sylapInstGEN.clkSylapGenINST/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins sylapInstGEN.clkSylapGenINST/inst/mmcm_adv_inst/CLKOUT0]]
