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
