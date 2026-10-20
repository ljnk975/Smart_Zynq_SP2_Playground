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


 ZYNQ_CORE_wrapper zynq_u(
    .GPIO_0_tri_io(GPIO_EMIO),

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
    
endmodule
