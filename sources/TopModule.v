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

//www.hellofpga.com
`timescale 1ns / 1ps

module TopModule(
    inout  [5:0] GPIO_EMIO,

    inout  SPI_0_sck_io,
    inout  SPI_0_ss_io,
    inout  SPI_0_io0_io,

    inout  IIC_0_scl_io,
    inout  IIC_0_sda_io,
    output TMDS_0_clk_n,
    output TMDS_0_clk_p,
    output [2:0] TMDS_0_data_n,
    output [2:0] TMDS_0_data_p,

    input  CAM0_CLK,
    output CAM0_PWD,
    output CAM0_RST,
    input  CAM0_VSYNC,
    input  CAM0_HSYNC,
    input  [7:0] CAM0_D,
    inout  CAM0_SCL,
    inout  CAM0_SDA,

    output MDIO_PHY_mdc,
    inout  MDIO_PHY_mdio_io,
    input  [3:0] RGMII_rd,
    input  RGMII_rx_ctl,
    input  RGMII_rxc,
    output [3:0] RGMII_td,
    output RGMII_tx_ctl,
    output RGMII_txc,
    input  ENET0_EXT_INTIN,

    input  UART_rxd,
    output UART_txd
);

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
    wire [7:0] vid_in_tdata;
    wire [0:0] vid_in_tkeep;
    wire [0:0] vid_in_tstrb;

 ZYNQ_CORE_wrapper zynq_u(
    .GPIO_0_tri_io(GPIO_EMIO),

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

    .vid_iic_scl_io(CAM0_SCL),
    .vid_iic_sda_io(CAM0_SDA),

    .SPI_0_sck_io(SPI_0_sck_io),
    .SPI_0_ss_io(SPI_0_ss_io),
    .SPI_0_io0_io(SPI_0_io0_io),

    .IIC_0_scl_io(IIC_0_scl_io),
    .IIC_0_sda_io(IIC_0_sda_io),

    .TMDS_0_clk_n(TMDS_0_clk_n),
    .TMDS_0_clk_p(TMDS_0_clk_p),
    .TMDS_0_data_n(TMDS_0_data_n),
    .TMDS_0_data_p(TMDS_0_data_p),

    .MDIO_PHY_0_mdc(MDIO_PHY_mdc),
    .MDIO_PHY_0_mdio_io(MDIO_PHY_mdio_io),
    .RGMII_0_rd(RGMII_rd),
    .RGMII_0_rx_ctl(RGMII_rx_ctl),
    .RGMII_0_rxc(RGMII_rxc),
    .RGMII_0_td(RGMII_td),
    .RGMII_0_tx_ctl(RGMII_tx_ctl),
    .RGMII_0_txc(RGMII_txc),
    .ENET0_EXT_INTIN(ENET0_EXT_INTIN),

    .UART_0_rxd(UART_rxd),
    .UART_0_txd(UART_txd)
 );

    ///-> Camera output
    assign CAM0_PWD = vid_pwd;
    assign CAM0_RST = vid_resetn;

    ///-> Stream output
    assign vid_in_clk = CAM0_CLK;
    assign vid_in_resetn = vid_resetn;
    
    wire vid_clk;
    assign vid_clk = CAM0_CLK;

    reg hsync_dly;
    reg vsync_dly;

    always @(posedge vid_clk)
    begin
        hsync_dly <= CAM0_HSYNC;
        vsync_dly <= CAM0_VSYNC;
    end

    // start of line handle
    wire start_of_line_w;
    assign start_of_line_w = ~hsync_dly && CAM0_HSYNC;

    // end of line handle
    wire end_of_line_w;
    assign end_of_line_w = hsync_dly && ~CAM0_HSYNC;

    // start of frame handle
    wire start_of_frame_w;
    assign start_of_frame_w = ~vsync_dly && CAM0_VSYNC;

    // Keep until first byte send
    reg start_of_frame;

    always @(posedge vid_clk)
        if (hsync_dly)
            start_of_frame <= 1'b0;
        else if (start_of_frame_w)
            start_of_frame <= 1'b1;

    // data handle
    reg [7:0] dataword;

    always @(posedge vid_clk)
        dataword <= CAM0_D;

    assign vid_in_tvalid = hsync_dly;
    assign vid_in_tdata = dataword;
    assign vid_in_tlast = end_of_line_w;
    assign vid_in_tuser = start_of_frame;
    assign vid_in_tkeep = 1'b1;
    assign vid_in_tstrb = 1'b1;
    assign vid_in_tdest = 1'b0;
    assign vid_in_tid = 1'b0;

endmodule
