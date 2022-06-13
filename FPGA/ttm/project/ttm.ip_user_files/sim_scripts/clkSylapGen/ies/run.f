-makelib ies_lib/xil_defaultlib -sv \
  "/opt/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/opt/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/opt/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../../hdl/ip/clkSylapGen/clkSylapGen_clk_wiz.v" \
  "../../../../../hdl/ip/clkSylapGen/clkSylapGen.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

