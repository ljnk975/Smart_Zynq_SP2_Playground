// @Copyright@
// 
// Copyright (c) 2026, Van Linh (Ljnk975@gmail.com)
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
//Date        : Sun May 17 23:03:06 2026
//Host        : sp.core running 64-bit AlmaLinux 9.7 (Moss Jungle Cat)
//Command     : generate_target ZYNQ_CORE_wrapper.bd
//Design      : ZYNQ_CORE_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

module ZYNQ_CORE_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    ENET0_EXT_INTIN,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    GPIO_0_tri_io,
    vid_pwd,
    vid_resetn,
    vid_in_clk,
    vid_in_resetn,
    vid_in_tready,
    vid_in_tvalid,
    vid_in_tlast,
    vid_in_tuser,
    vid_in_tid,
    vid_in_tdest,
    vid_in_tdata,
    vid_in_tkeep,
    vid_in_tstrb,
    vid_iic_scl_io,
    vid_iic_sda_io,
    MDIO_PHY_0_mdc,
    MDIO_PHY_0_mdio_io,
    RGMII_0_rd,
    RGMII_0_rx_ctl,
    RGMII_0_rxc,
    RGMII_0_td,
    RGMII_0_tx_ctl,
    RGMII_0_txc,
    SPI_0_io0_io,
    SPI_0_io1_io,
    SPI_0_sck_io,
    SPI_0_ss1_o,
    SPI_0_ss2_o,
    SPI_0_ss_io,
    IIC_0_scl_io,
    IIC_0_sda_io,
    TMDS_0_clk_n,
    TMDS_0_clk_p,
    TMDS_0_data_n,
    TMDS_0_data_p,
    UART_0_rxd,
    UART_0_txd);

  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  input ENET0_EXT_INTIN;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  inout [5:0]GPIO_0_tri_io;
  output vid_pwd;
  output vid_resetn;
  input vid_in_clk;
  input vid_in_resetn;
  output vid_in_tready;
  input vid_in_tvalid;
  input vid_in_tlast;
  input vid_in_tuser;
  input vid_in_tid;
  input vid_in_tdest;
  input [7:0]vid_in_tdata;
  input [1:0]vid_in_tkeep;
  input [1:0]vid_in_tstrb;
  inout vid_iic_scl_io;
  inout vid_iic_sda_io;
  output MDIO_PHY_0_mdc;
  inout MDIO_PHY_0_mdio_io;
  input [3:0]RGMII_0_rd;
  input RGMII_0_rx_ctl;
  input RGMII_0_rxc;
  output [3:0]RGMII_0_td;
  output RGMII_0_tx_ctl;
  output RGMII_0_txc;
  inout SPI_0_io0_io;
  inout SPI_0_io1_io;
  inout SPI_0_sck_io;
  output SPI_0_ss1_o;
  output SPI_0_ss2_o;
  inout SPI_0_ss_io;
  inout IIC_0_scl_io;
  inout IIC_0_sda_io;
  output TMDS_0_clk_n;
  output TMDS_0_clk_p;
  output [2:0]TMDS_0_data_n;
  output [2:0]TMDS_0_data_p;
  input UART_0_rxd;
  output UART_0_txd;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire ENET0_EXT_INTIN;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [0:0]GPIO_0_tri_i_0;
  wire [1:1]GPIO_0_tri_i_1;
  wire [2:2]GPIO_0_tri_i_2;
  wire [3:3]GPIO_0_tri_i_3;
  wire [4:4]GPIO_0_tri_i_4;
  wire [5:5]GPIO_0_tri_i_5;
  wire [0:0]GPIO_0_tri_io_0;
  wire [1:1]GPIO_0_tri_io_1;
  wire [2:2]GPIO_0_tri_io_2;
  wire [3:3]GPIO_0_tri_io_3;
  wire [4:4]GPIO_0_tri_io_4;
  wire [5:5]GPIO_0_tri_io_5;
  wire [0:0]GPIO_0_tri_o_0;
  wire [1:1]GPIO_0_tri_o_1;
  wire [2:2]GPIO_0_tri_o_2;
  wire [3:3]GPIO_0_tri_o_3;
  wire [4:4]GPIO_0_tri_o_4;
  wire [5:5]GPIO_0_tri_o_5;
  wire [0:0]GPIO_0_tri_t_0;
  wire [1:1]GPIO_0_tri_t_1;
  wire [2:2]GPIO_0_tri_t_2;
  wire [3:3]GPIO_0_tri_t_3;
  wire [4:4]GPIO_0_tri_t_4;
  wire [5:5]GPIO_0_tri_t_5;
  wire vid_pwd;
  wire vid_resetn;
  wire vid_in_clk;
  wire vid_in_resetn;
  wire vid_in_tready;
  wire vid_in_tvalid;
  wire vid_in_tlast;
  wire vid_in_tuser;
  wire vid_in_tid;
  wire vid_in_tdest;
  wire [7:0]vid_in_tdata;
  wire [0:0]vid_in_tkeep;
  wire [0:0]vid_in_tstrb;
  wire vid_iic_scl_i;
  wire vid_iic_scl_io;
  wire vid_iic_scl_o;
  wire vid_iic_scl_t;
  wire vid_iic_sda_i;
  wire vid_iic_sda_io;
  wire vid_iic_sda_o;
  wire vid_iic_sda_t;
  wire MDIO_PHY_0_mdc;
  wire MDIO_PHY_0_mdio_i;
  wire MDIO_PHY_0_mdio_io;
  wire MDIO_PHY_0_mdio_o;
  wire MDIO_PHY_0_mdio_t;
  wire [3:0]RGMII_0_rd;
  wire RGMII_0_rx_ctl;
  wire RGMII_0_rxc;
  wire [3:0]RGMII_0_td;
  wire RGMII_0_tx_ctl;
  wire RGMII_0_txc;
  wire SPI_0_io0_i;
  wire SPI_0_io0_io;
  wire SPI_0_io0_o;
  wire SPI_0_io0_t;
  wire SPI_0_io1_i;
  wire SPI_0_io1_io;
  wire SPI_0_io1_o;
  wire SPI_0_io1_t;
  wire SPI_0_sck_i;
  wire SPI_0_sck_io;
  wire SPI_0_sck_o;
  wire SPI_0_sck_t;
  wire SPI_0_ss1_o;
  wire SPI_0_ss2_o;
  wire SPI_0_ss_i;
  wire SPI_0_ss_io;
  wire SPI_0_ss_o;
  wire SPI_0_ss_t;
  wire IIC_0_scl_i;
  wire IIC_0_scl_io;
  wire IIC_0_scl_o;
  wire IIC_0_scl_t;
  wire IIC_0_sda_i;
  wire IIC_0_sda_io;
  wire IIC_0_sda_o;
  wire IIC_0_sda_t;
  wire TMDS_0_clk_n;
  wire TMDS_0_clk_p;
  wire [2:0]TMDS_0_data_n;
  wire [2:0]TMDS_0_data_p;
  wire UART_0_rxd;
  wire UART_0_txd;

  IOBUF GPIO_0_tri_iobuf_0
       (.I(GPIO_0_tri_o_0),
        .IO(GPIO_0_tri_io[0]),
        .O(GPIO_0_tri_i_0),
        .T(GPIO_0_tri_t_0));
  IOBUF GPIO_0_tri_iobuf_1
       (.I(GPIO_0_tri_o_1),
        .IO(GPIO_0_tri_io[1]),
        .O(GPIO_0_tri_i_1),
        .T(GPIO_0_tri_t_1));
  IOBUF GPIO_0_tri_iobuf_2
       (.I(GPIO_0_tri_o_2),
        .IO(GPIO_0_tri_io[2]),
        .O(GPIO_0_tri_i_2),
        .T(GPIO_0_tri_t_2));
  IOBUF GPIO_0_tri_iobuf_3
       (.I(GPIO_0_tri_o_3),
        .IO(GPIO_0_tri_io[3]),
        .O(GPIO_0_tri_i_3),
        .T(GPIO_0_tri_t_3));
  IOBUF GPIO_0_tri_iobuf_4
       (.I(GPIO_0_tri_o_4),
        .IO(GPIO_0_tri_io[4]),
        .O(GPIO_0_tri_i_4),
        .T(GPIO_0_tri_t_4));
  IOBUF GPIO_0_tri_iobuf_5
       (.I(GPIO_0_tri_o_5),
        .IO(GPIO_0_tri_io[5]),
        .O(GPIO_0_tri_i_5),
        .T(GPIO_0_tri_t_5));
  IOBUF MDIO_PHY_0_mdio_iobuf
       (.I(MDIO_PHY_0_mdio_o),
        .IO(MDIO_PHY_0_mdio_io),
        .O(MDIO_PHY_0_mdio_i),
        .T(MDIO_PHY_0_mdio_t));
  IOBUF vid_iic_scl_iobuf
       (.I(vid_iic_scl_o),
        .IO(vid_iic_scl_io),
        .O(vid_iic_scl_i),
        .T(vid_iic_scl_t));
  IOBUF vid_iic_sda_iobuf
       (.I(vid_iic_sda_o),
        .IO(vid_iic_sda_io),
        .O(vid_iic_sda_i),
        .T(vid_iic_sda_t));
  IOBUF SPI_0_io0_iobuf
       (.I(SPI_0_io0_o),
        .IO(SPI_0_io0_io),
        .O(SPI_0_io0_i),
        .T(SPI_0_io0_t));
  IOBUF SPI_0_sck_iobuf
       (.I(SPI_0_sck_o),
        .IO(SPI_0_sck_io),
        .O(SPI_0_sck_i),
        .T(SPI_0_sck_t));
  IOBUF SPI_0_ss_iobuf
       (.I(SPI_0_ss_o),
        .IO(SPI_0_ss_io),
        .O(SPI_0_ss_i),
        .T(SPI_0_ss_t));
  IOBUF IIC_0_scl_iobuf
       (.I(IIC_0_scl_o),
        .IO(IIC_0_scl_io),
        .O(IIC_0_scl_i),
        .T(IIC_0_scl_t));
  IOBUF IIC_0_sda_iobuf
       (.I(IIC_0_sda_o),
        .IO(IIC_0_sda_io),
        .O(IIC_0_sda_i),
        .T(IIC_0_sda_t));
  ZYNQ_CORE ZYNQ_CORE_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .ENET0_EXT_INTIN(ENET0_EXT_INTIN),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .GPIO_0_tri_i({GPIO_0_tri_i_5,GPIO_0_tri_i_4,GPIO_0_tri_i_3,GPIO_0_tri_i_2,GPIO_0_tri_i_1,GPIO_0_tri_i_0}),
        .GPIO_0_tri_o({GPIO_0_tri_o_5,GPIO_0_tri_o_4,GPIO_0_tri_o_3,GPIO_0_tri_o_2,GPIO_0_tri_o_1,GPIO_0_tri_o_0}),
        .GPIO_0_tri_t({GPIO_0_tri_t_5,GPIO_0_tri_t_4,GPIO_0_tri_t_3,GPIO_0_tri_t_2,GPIO_0_tri_t_1,GPIO_0_tri_t_0}),
        .vid_pwd(vid_pwd),
        .vid_resetn(vid_resetn),
        .vid_in_clk(vid_in_clk),
        .vid_in_resetn(vid_in_resetn),
        .vid_in_tready(vid_in_tready),
        .vid_in_tvalid(vid_in_tvalid),
        .vid_in_tlast(vid_in_tlast),
        .vid_in_tuser(vid_in_tuser),
        .vid_in_tid(vid_in_tid),
        .vid_in_tdest(vid_in_tdest),
        .vid_in_tdata(vid_in_tdata),
        .vid_in_tkeep(vid_in_tkeep),
        .vid_in_tstrb(vid_in_tstrb),
        .vid_iic_scl_i(vid_iic_scl_i),
        .vid_iic_scl_o(vid_iic_scl_o),
        .vid_iic_scl_t(vid_iic_scl_t),
        .vid_iic_sda_i(vid_iic_sda_i),
        .vid_iic_sda_o(vid_iic_sda_o),
        .vid_iic_sda_t(vid_iic_sda_t),
        .MDIO_PHY_0_mdc(MDIO_PHY_0_mdc),
        .MDIO_PHY_0_mdio_i(MDIO_PHY_0_mdio_i),
        .MDIO_PHY_0_mdio_o(MDIO_PHY_0_mdio_o),
        .MDIO_PHY_0_mdio_t(MDIO_PHY_0_mdio_t),
        .RGMII_0_rd(RGMII_0_rd),
        .RGMII_0_rx_ctl(RGMII_0_rx_ctl),
        .RGMII_0_rxc(RGMII_0_rxc),
        .RGMII_0_td(RGMII_0_td),
        .RGMII_0_tx_ctl(RGMII_0_tx_ctl),
        .RGMII_0_txc(RGMII_0_txc),
        .SPI_0_io0_i(SPI_0_io0_i),
        .SPI_0_io0_o(SPI_0_io0_o),
        .SPI_0_io0_t(SPI_0_io0_t),
        .SPI_0_io1_i(SPI_0_io1_i),
        .SPI_0_io1_o(SPI_0_io1_o),
        .SPI_0_io1_t(SPI_0_io1_t),
        .SPI_0_sck_i(SPI_0_sck_i),
        .SPI_0_sck_o(SPI_0_sck_o),
        .SPI_0_sck_t(SPI_0_sck_t),
        .SPI_0_ss1_o(SPI_0_ss1_o),
        .SPI_0_ss2_o(SPI_0_ss2_o),
        .SPI_0_ss_i(SPI_0_ss_i),
        .SPI_0_ss_o(SPI_0_ss_o),
        .SPI_0_ss_t(SPI_0_ss_t),
        .IIC_0_scl_i(IIC_0_scl_i),
        .IIC_0_scl_o(IIC_0_scl_o),
        .IIC_0_scl_t(IIC_0_scl_t),
        .IIC_0_sda_i(IIC_0_sda_i),
        .IIC_0_sda_o(IIC_0_sda_o),
        .IIC_0_sda_t(IIC_0_sda_t),
        .TMDS_0_clk_n(TMDS_0_clk_n),
        .TMDS_0_clk_p(TMDS_0_clk_p),
        .TMDS_0_data_n(TMDS_0_data_n),
        .TMDS_0_data_p(TMDS_0_data_p),
        .UART_0_rxd(UART_0_rxd),
        .UART_0_txd(UART_0_txd));

endmodule
