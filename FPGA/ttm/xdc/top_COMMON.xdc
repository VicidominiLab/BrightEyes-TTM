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

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets laser_synchronizator/inst/clk_in1_clk_wiz_1]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets laser]
###set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets sylap_clkGen/inst/clk_in1_clk_wiz_2]



set_property CFGBVS Vcco [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]

### CLK EMCCCLK 66MHz source
set_property -dict {PACKAGE_PIN R24 IOSTANDARD LVCMOS25} [get_ports clk66mhz]











































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

# VERSION VERTICAL TDC
#create_pblock pblock_datapreparation_impl
#add_cells_to_pblock [get_pblocks pblock_datapreparation_impl] [get_cells -quiet [list datapreparation_impl]]
#resize_pblock [get_pblocks pblock_datapreparation_impl] -add {CLOCKREGION_X1Y1:CLOCKREGION_X1Y4}
#create_pblock pblock_to_cypress_fx3
#add_cells_to_pblock [get_pblocks pblock_to_cypress_fx3] [get_cells -quiet [list to_cypress_fx3]]
#resize_pblock [get_pblocks pblock_to_cypress_fx3] -add {CLOCKREGION_X1Y0:CLOCKREGION_X1Y0}
#create_pblock pblock_1
#add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list sylapInstGEN.clkSylapGenINST sylapInstGEN.sylapTopINST]]
#resize_pblock [get_pblocks pblock_1] -add {CLOCKREGION_X1Y6:CLOCKREGION_X1Y6}

#create_pblock pblock_TDC_module_complete
#add_cells_to_pblock [get_pblocks pblock_TDC_module_complete] [get_cells -quiet [list TDC_module_complete]]
#resize_pblock [get_pblocks pblock_TDC_module_complete] -add {CLOCKREGION_X0Y0:CLOCKREGION_X0Y6}

# VERSION HORIZONAL TDC
create_pblock pblock_datapreparation_impl
add_cells_to_pblock [get_pblocks pblock_datapreparation_impl] [get_cells -quiet [list datapreparation_impl]]
resize_pblock [get_pblocks pblock_datapreparation_impl] -add {CLOCKREGION_X0Y3:CLOCKREGION_X0Y6}
create_pblock pblock_to_cypress_fx3
add_cells_to_pblock [get_pblocks pblock_to_cypress_fx3] [get_cells -quiet [list to_cypress_fx3]]
resize_pblock [get_pblocks pblock_to_cypress_fx3] -add {CLOCKREGION_X1Y3:CLOCKREGION_X1Y3}
create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list sylapInstGEN.clkSylapGenINST sylapInstGEN.sylapTopINST]]
resize_pblock [get_pblocks pblock_1] -add {CLOCKREGION_X1Y6:CLOCKREGION_X1Y6}

create_pblock pblock_TDC_module_complete
add_cells_to_pblock [get_pblocks pblock_TDC_module_complete] [get_cells -quiet [list TDC_module_complete]]
resize_pblock [get_pblocks pblock_TDC_module_complete] -add {CLOCKREGION_X0Y0:CLOCKREGION_X1Y2}


set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets sys_clk]

#False Path clk_100 to clk_240
set_false_path -from [get_pins to_cypress_fx3/fifo_iit/i_fifo_decoupler/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gras.gpe.rdpe/gpe1.prog_empty_i_reg/C] -to [get_pins dout_valid_to_fx3_reg/D]
set_false_path -from [get_pins resetUsbFifo_n_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/Enable_write_reg/D]
set_false_path -from [get_pins locked_usbClk_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/Enable_write_reg/D]

set_false_path -from [get_pins locked_usbClk_reg/C] -to [get_pins {to_cypress_fx3/synch_pulf2s/ackf_reg*/CLR}]
set_false_path -from [get_pins locked_usbClk_reg/C] -to [get_pins to_cypress_fx3/synch_pulf2s/pulsef_s_reg/CLR]


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

set_false_path -from [get_pins to_fx3_resetUsbFifo_n_reg_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/middle_fifo/empty_reg/PRE]
set_false_path -from [get_pins to_fx3_resetUsbFifo_n_reg_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/middle_fifo/full_reg/CLR]
set_false_path -from [get_pins to_fx3_resetUsbFifo_n_reg_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/top_fifo/empty_reg/PRE]
set_false_path -from [get_pins to_fx3_resetUsbFifo_n_reg_reg/C] -to [get_pins to_cypress_fx3/fifo_iit/top_fifo/full_reg/CLR]

#False Path TAP DELAY LINE
set_false_path -from [get_pins {TDC_module_complete/TDL_ch*.TDL/hit_filter/input_filter2/C}] -to [get_pins {TDC_module_complete/TDL_ch*.TDL/tdl/latch*.AFF_FF.FDR_1/D}]
set_false_path -from [get_pins TDC_module_complete/TDL_laser/hit_filter/input_filter2/C] -to [get_pins {TDC_module_complete/TDL_laser/tdl/latch*.AFF_FF.FDR_1/D}]
set_false_path -through [get_pins {TDC_module_complete/TDL_ch*.TDL/hit_filter/input_filter2/C}]

#False Path SYLAP 
#set_false_path -from [get_clocks -of_objects [get_pins clock_gen/inst/mmcm_adv_inst/CLKOUT3]] -to [get_clocks -of_objects [get_pins clock_gen/inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins sylapInstGEN.clkSylapGenINST/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins clock_gen/inst/mmcm_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins sylapInstGEN.clkSylapGenINST/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins sylapInstGEN.clkSylapGenINST/inst/mmcm_adv_inst/CLKOUT0]]
