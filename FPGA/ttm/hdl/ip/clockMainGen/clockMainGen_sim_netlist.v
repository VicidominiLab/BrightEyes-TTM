// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
// Date        : Tue Jul 13 12:27:37 2021
// Host        : IITMMSDL002 running 64-bit Linux Mint 20.1
// Command     : write_verilog -force -mode funcsim -rename_top clockMainGen -prefix
//               clockMainGen_ clockMainGen_sim_netlist.v
// Design      : clockMainGen
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NotValidForBitStream *)
module clockMainGen
   (clk_240,
    clk_400,
    clk_50,
    clk_100,
    reset,
    locked,
    clk_in1_p,
    clk_in1_n);
  output clk_240;
  output clk_400;
  output clk_50;
  output clk_100;
  input reset;
  output locked;
  input clk_in1_p;
  input clk_in1_n;

  wire clk_100;
  wire clk_240;
  wire clk_400;
  wire clk_50;
  (* DIFF_TERM = 0 *) (* IBUF_LOW_PWR *) wire clk_in1_n;
  (* DIFF_TERM = 0 *) (* IBUF_LOW_PWR *) wire clk_in1_p;
  wire locked;
  wire reset;

  clockMainGen_clockMainGen_clk_wiz inst
       (.clk_100(clk_100),
        .clk_240(clk_240),
        .clk_400(clk_400),
        .clk_50(clk_50),
        .clk_in1_n(clk_in1_n),
        .clk_in1_p(clk_in1_p),
        .locked(locked),
        .reset(reset));
endmodule

module clockMainGen_clockMainGen_clk_wiz
   (clk_240,
    clk_400,
    clk_50,
    clk_100,
    reset,
    locked,
    clk_in1_p,
    clk_in1_n);
  output clk_240;
  output clk_400;
  output clk_50;
  output clk_100;
  input reset;
  output locked;
  input clk_in1_p;
  input clk_in1_n;

  wire clk_100;
  wire clk_100_clockMainGen;
  wire clk_100_clockMainGen_en_clk;
  wire clk_240;
  wire clk_240_clockMainGen;
  wire clk_240_clockMainGen_en_clk;
  wire clk_400;
  wire clk_400_clockMainGen;
  wire clk_400_clockMainGen_en_clk;
  wire clk_50;
  wire clk_50_clockMainGen;
  wire clk_50_clockMainGen_en_clk;
  wire clk_in1_clockMainGen;
  wire clk_in1_n;
  wire clk_in1_p;
  wire clkfbout_buf_clockMainGen;
  wire clkfbout_clockMainGen;
  wire locked;
  wire reset;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) wire [7:0]seq_reg1;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) wire [7:0]seq_reg2;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) wire [7:0]seq_reg3;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) wire [7:0]seq_reg4;
  wire NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED;
  wire NLW_mmcm_adv_inst_DRDY_UNCONNECTED;
  wire NLW_mmcm_adv_inst_PSDONE_UNCONNECTED;
  wire [15:0]NLW_mmcm_adv_inst_DO_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkf_buf
       (.I(clkfbout_clockMainGen),
        .O(clkfbout_buf_clockMainGen));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  (* IBUF_DELAY_VALUE = "0" *) 
  (* IFD_DELAY_VALUE = "AUTO" *) 
  IBUFDS #(
    .IOSTANDARD("DEFAULT")) 
    clkin1_ibufgds
       (.I(clk_in1_p),
        .IB(clk_in1_n),
        .O(clk_in1_clockMainGen));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* XILINX_LEGACY_PRIM = "BUFGCE" *) 
  (* XILINX_TRANSFORM_PINMAP = "CE:CE0 I:I0" *) 
  BUFGCTRL #(
    .INIT_OUT(0),
    .PRESELECT_I0("TRUE"),
    .PRESELECT_I1("FALSE")) 
    clkout1_buf
       (.CE0(seq_reg1[7]),
        .CE1(1'b0),
        .I0(clk_240_clockMainGen),
        .I1(1'b1),
        .IGNORE0(1'b0),
        .IGNORE1(1'b1),
        .O(clk_240),
        .S0(1'b1),
        .S1(1'b0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFH clkout1_buf_en
       (.I(clk_240_clockMainGen),
        .O(clk_240_clockMainGen_en_clk));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* XILINX_LEGACY_PRIM = "BUFGCE" *) 
  (* XILINX_TRANSFORM_PINMAP = "CE:CE0 I:I0" *) 
  BUFGCTRL #(
    .INIT_OUT(0),
    .PRESELECT_I0("TRUE"),
    .PRESELECT_I1("FALSE")) 
    clkout2_buf
       (.CE0(seq_reg2[7]),
        .CE1(1'b0),
        .I0(clk_400_clockMainGen),
        .I1(1'b1),
        .IGNORE0(1'b0),
        .IGNORE1(1'b1),
        .O(clk_400),
        .S0(1'b1),
        .S1(1'b0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFH clkout2_buf_en
       (.I(clk_400_clockMainGen),
        .O(clk_400_clockMainGen_en_clk));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* XILINX_LEGACY_PRIM = "BUFGCE" *) 
  (* XILINX_TRANSFORM_PINMAP = "CE:CE0 I:I0" *) 
  BUFGCTRL #(
    .INIT_OUT(0),
    .PRESELECT_I0("TRUE"),
    .PRESELECT_I1("FALSE")) 
    clkout3_buf
       (.CE0(seq_reg3[7]),
        .CE1(1'b0),
        .I0(clk_50_clockMainGen),
        .I1(1'b1),
        .IGNORE0(1'b0),
        .IGNORE1(1'b1),
        .O(clk_50),
        .S0(1'b1),
        .S1(1'b0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFH clkout3_buf_en
       (.I(clk_50_clockMainGen),
        .O(clk_50_clockMainGen_en_clk));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* XILINX_LEGACY_PRIM = "BUFGCE" *) 
  (* XILINX_TRANSFORM_PINMAP = "CE:CE0 I:I0" *) 
  BUFGCTRL #(
    .INIT_OUT(0),
    .PRESELECT_I0("TRUE"),
    .PRESELECT_I1("FALSE")) 
    clkout4_buf
       (.CE0(seq_reg4[7]),
        .CE1(1'b0),
        .I0(clk_100_clockMainGen),
        .I1(1'b1),
        .IGNORE0(1'b0),
        .IGNORE1(1'b1),
        .O(clk_100),
        .S0(1'b1),
        .S1(1'b0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFH clkout4_buf_en
       (.I(clk_100_clockMainGen),
        .O(clk_100_clockMainGen_en_clk));
  (* BOX_TYPE = "PRIMITIVE" *) 
  MMCME2_ADV #(
    .BANDWIDTH("HIGH"),
    .CLKFBOUT_MULT_F(6.000000),
    .CLKFBOUT_PHASE(0.000000),
    .CLKFBOUT_USE_FINE_PS("FALSE"),
    .CLKIN1_PERIOD(5.000000),
    .CLKIN2_PERIOD(0.000000),
    .CLKOUT0_DIVIDE_F(5.000000),
    .CLKOUT0_DUTY_CYCLE(0.500000),
    .CLKOUT0_PHASE(0.000000),
    .CLKOUT0_USE_FINE_PS("FALSE"),
    .CLKOUT1_DIVIDE(3),
    .CLKOUT1_DUTY_CYCLE(0.500000),
    .CLKOUT1_PHASE(0.000000),
    .CLKOUT1_USE_FINE_PS("FALSE"),
    .CLKOUT2_DIVIDE(24),
    .CLKOUT2_DUTY_CYCLE(0.500000),
    .CLKOUT2_PHASE(0.000000),
    .CLKOUT2_USE_FINE_PS("FALSE"),
    .CLKOUT3_DIVIDE(12),
    .CLKOUT3_DUTY_CYCLE(0.500000),
    .CLKOUT3_PHASE(0.000000),
    .CLKOUT3_USE_FINE_PS("FALSE"),
    .CLKOUT4_CASCADE("FALSE"),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.500000),
    .CLKOUT4_PHASE(0.000000),
    .CLKOUT4_USE_FINE_PS("FALSE"),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.500000),
    .CLKOUT5_PHASE(0.000000),
    .CLKOUT5_USE_FINE_PS("FALSE"),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.500000),
    .CLKOUT6_PHASE(0.000000),
    .CLKOUT6_USE_FINE_PS("FALSE"),
    .COMPENSATION("ZHOLD"),
    .DIVCLK_DIVIDE(1),
    .IS_CLKINSEL_INVERTED(1'b0),
    .IS_PSEN_INVERTED(1'b0),
    .IS_PSINCDEC_INVERTED(1'b0),
    .IS_PWRDWN_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .REF_JITTER1(0.010000),
    .REF_JITTER2(0.010000),
    .SS_EN("FALSE"),
    .SS_MODE("CENTER_HIGH"),
    .SS_MOD_PERIOD(10000),
    .STARTUP_WAIT("FALSE")) 
    mmcm_adv_inst
       (.CLKFBIN(clkfbout_buf_clockMainGen),
        .CLKFBOUT(clkfbout_clockMainGen),
        .CLKFBOUTB(NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED),
        .CLKFBSTOPPED(NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED),
        .CLKIN1(clk_in1_clockMainGen),
        .CLKIN2(1'b0),
        .CLKINSEL(1'b1),
        .CLKINSTOPPED(NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED),
        .CLKOUT0(clk_240_clockMainGen),
        .CLKOUT0B(NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED),
        .CLKOUT1(clk_400_clockMainGen),
        .CLKOUT1B(NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED),
        .CLKOUT2(clk_50_clockMainGen),
        .CLKOUT2B(NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED),
        .CLKOUT3(clk_100_clockMainGen),
        .CLKOUT3B(NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED),
        .CLKOUT4(NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED),
        .CLKOUT5(NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED),
        .CLKOUT6(NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED),
        .DADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DCLK(1'b0),
        .DEN(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DO(NLW_mmcm_adv_inst_DO_UNCONNECTED[15:0]),
        .DRDY(NLW_mmcm_adv_inst_DRDY_UNCONNECTED),
        .DWE(1'b0),
        .LOCKED(locked),
        .PSCLK(1'b0),
        .PSDONE(NLW_mmcm_adv_inst_PSDONE_UNCONNECTED),
        .PSEN(1'b0),
        .PSINCDEC(1'b0),
        .PWRDWN(1'b0),
        .RST(reset));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg1_reg[0] 
       (.C(clk_240_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(locked),
        .Q(seq_reg1[0]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg1_reg[1] 
       (.C(clk_240_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg1[0]),
        .Q(seq_reg1[1]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg1_reg[2] 
       (.C(clk_240_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg1[1]),
        .Q(seq_reg1[2]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg1_reg[3] 
       (.C(clk_240_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg1[2]),
        .Q(seq_reg1[3]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg1_reg[4] 
       (.C(clk_240_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg1[3]),
        .Q(seq_reg1[4]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg1_reg[5] 
       (.C(clk_240_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg1[4]),
        .Q(seq_reg1[5]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg1_reg[6] 
       (.C(clk_240_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg1[5]),
        .Q(seq_reg1[6]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg1_reg[7] 
       (.C(clk_240_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg1[6]),
        .Q(seq_reg1[7]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg2_reg[0] 
       (.C(clk_400_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(locked),
        .Q(seq_reg2[0]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg2_reg[1] 
       (.C(clk_400_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg2[0]),
        .Q(seq_reg2[1]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg2_reg[2] 
       (.C(clk_400_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg2[1]),
        .Q(seq_reg2[2]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg2_reg[3] 
       (.C(clk_400_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg2[2]),
        .Q(seq_reg2[3]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg2_reg[4] 
       (.C(clk_400_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg2[3]),
        .Q(seq_reg2[4]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg2_reg[5] 
       (.C(clk_400_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg2[4]),
        .Q(seq_reg2[5]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg2_reg[6] 
       (.C(clk_400_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg2[5]),
        .Q(seq_reg2[6]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg2_reg[7] 
       (.C(clk_400_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg2[6]),
        .Q(seq_reg2[7]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg3_reg[0] 
       (.C(clk_50_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(locked),
        .Q(seq_reg3[0]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg3_reg[1] 
       (.C(clk_50_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg3[0]),
        .Q(seq_reg3[1]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg3_reg[2] 
       (.C(clk_50_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg3[1]),
        .Q(seq_reg3[2]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg3_reg[3] 
       (.C(clk_50_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg3[2]),
        .Q(seq_reg3[3]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg3_reg[4] 
       (.C(clk_50_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg3[3]),
        .Q(seq_reg3[4]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg3_reg[5] 
       (.C(clk_50_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg3[4]),
        .Q(seq_reg3[5]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg3_reg[6] 
       (.C(clk_50_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg3[5]),
        .Q(seq_reg3[6]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg3_reg[7] 
       (.C(clk_50_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg3[6]),
        .Q(seq_reg3[7]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg4_reg[0] 
       (.C(clk_100_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(locked),
        .Q(seq_reg4[0]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg4_reg[1] 
       (.C(clk_100_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg4[0]),
        .Q(seq_reg4[1]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg4_reg[2] 
       (.C(clk_100_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg4[1]),
        .Q(seq_reg4[2]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg4_reg[3] 
       (.C(clk_100_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg4[2]),
        .Q(seq_reg4[3]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg4_reg[4] 
       (.C(clk_100_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg4[3]),
        .Q(seq_reg4[4]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg4_reg[5] 
       (.C(clk_100_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg4[4]),
        .Q(seq_reg4[5]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg4_reg[6] 
       (.C(clk_100_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg4[5]),
        .Q(seq_reg4[6]));
  (* ASYNC_REG *) 
  FDCE #(
    .INIT(1'b0)) 
    \seq_reg4_reg[7] 
       (.C(clk_100_clockMainGen_en_clk),
        .CE(1'b1),
        .CLR(reset),
        .D(seq_reg4[6]),
        .Q(seq_reg4[7]));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
