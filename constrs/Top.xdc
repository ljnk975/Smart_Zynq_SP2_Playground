# @Copyright@
# 
# Copyright (c) 2026, Van Linh (Ljnk975@gmail.com)
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# UART
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports UART_rxd]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports UART_txd]

# SPI Display
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS33} [get_ports SPI_0_sck_io]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports SPI_0_ss_io]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports SPI_0_io0_io]

set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {GPIO_EMIO[0]}]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {GPIO_EMIO[1]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports {GPIO_EMIO[2]}]

# HDMI
#set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports HDMI_RX_HPD]

set_property -dict {PACKAGE_PIN K20 IOSTANDARD LVCMOS33} [get_ports IIC_0_sda_io]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports IIC_0_scl_io]

set_property -dict {PACKAGE_PIN M21} [get_ports {TMDS_0_data_p[0]}]
set_property -dict {PACKAGE_PIN L21} [get_ports {TMDS_0_data_p[1]}]
set_property -dict {PACKAGE_PIN J21} [get_ports {TMDS_0_data_p[2]}]

set_property -dict {PACKAGE_PIN N19} [get_ports TMDS_0_clk_p]

# Ethernet
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS33} [get_ports MDIO_PHY_mdc]
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS33} [get_ports MDIO_PHY_mdio_io]
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVCMOS33} [get_ports {RGMII_rd[0]}]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {RGMII_rd[1]}]
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS33} [get_ports {RGMII_rd[2]}]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports {RGMII_rd[3]}]
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS33} [get_ports RGMII_rx_ctl]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS33} [get_ports RGMII_rxc]
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33} [get_ports {RGMII_td[0]}]
set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVCMOS33} [get_ports {RGMII_td[1]}]
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVCMOS33} [get_ports {RGMII_td[2]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports {RGMII_td[3]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS33} [get_ports RGMII_tx_ctl]
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS33} [get_ports RGMII_txc]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports ENET0_EXT_INTIN]

set_property SLEW FAST [get_ports {RGMII_td[0]}]
set_property SLEW FAST [get_ports {RGMII_td[1]}]
set_property SLEW FAST [get_ports {RGMII_td[2]}]
set_property SLEW FAST [get_ports {RGMII_td[3]}]
set_property SLEW FAST [get_ports RGMII_tx_ctl]
set_property SLEW FAST [get_ports RGMII_txc]

create_clock -period 8 -name RGMII_rxc [get_ports RGMII_rxc]

# KEY
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports GPIO_EMIO[3]]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports GPIO_EMIO[4]]

# LED
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports GPIO_EMIO[5]]
