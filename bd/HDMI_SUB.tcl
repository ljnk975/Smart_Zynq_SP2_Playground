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

# Hierarchical cell: HDMI_SUB
proc create_hier_cell_HDMI_SUB { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_HDMI_SUB() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS_0


  # Create pins
  create_bd_pin -dir I -type clk axi_clk
  create_bd_pin -dir I -type clk dma_clk
  create_bd_pin -dir I -type rst resetn
  create_bd_pin -dir O -type intr iic2_intr
  create_bd_pin -dir O -type intr dma_intr
  create_bd_pin -dir O -type intr vmix_intr
  create_bd_pin -dir O -type intr vtc_intr
  create_bd_pin -dir O -type intr lock_intr
  create_bd_pin -dir O -type intr overflow_intr
  create_bd_pin -dir O -type intr underflow_intr

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic axi_iic_0 ]
  set_property CONFIG.C_DEFAULT_VALUE {0x01} $axi_iic_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_0 ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_0 ]
  set_property CONFIG.C_AUX_RESET_HIGH {0} $proc_sys_reset_0


  # Create instance: v_frmbuf_rd_0, and set properties
  set v_frmbuf_rd_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_rd v_frmbuf_rd_0 ]
  set_property -dict [list \
    CONFIG.HAS_ALPHA {0} \
    CONFIG.HAS_BGR8 {1} \
    CONFIG.HAS_BGRX8 {0} \
    CONFIG.HAS_INTERLACED {0} \
    CONFIG.HAS_RGB8 {0} \
    CONFIG.HAS_RGBX8 {0} \
    CONFIG.SAMPLES_PER_CLOCK {1} \
  ] $v_frmbuf_rd_0


  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000000} \
    CONFIG.C_GPIO_WIDTH {3} \
  ] $axi_gpio_0


  # Create instance: rgb2dvi_0, and set properties
  set rgb2dvi_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi rgb2dvi_0 ]
  set_property -dict [list \
    CONFIG.kClkRange {1} \
    CONFIG.kGenerateSerialClk {true} \
    CONFIG.kRstActiveHigh {false} \
  ] $rgb2dvi_0


  # Create instance: rst_ps7_0_frmbuf, and set properties
  set rst_ps7_0_frmbuf [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_ps7_0_frmbuf ]
  set_property CONFIG.C_AUX_RESET_HIGH {0} $rst_ps7_0_frmbuf


  # Create instance: ilslice_1, and set properties
  set ilslice_1 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice ilslice_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {3} \
  ] $ilslice_1


  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out v_axi4s_vid_out_0 ]
  set_property -dict [list \
    CONFIG.C_HAS_ASYNC_CLK {1} \
    CONFIG.C_S_AXIS_VIDEO_DATA_WIDTH {8} \
    CONFIG.C_S_AXIS_VIDEO_FORMAT {2} \
  ] $v_axi4s_vid_out_0


  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect ps7_0_axi_periph ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {6} \
    CONFIG.NUM_SI {1} \
  ] $ps7_0_axi_periph


  # Create instance: rst_ps7_0_axi, and set properties
  set rst_ps7_0_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_ps7_0_axi ]

  # Create instance: v_tc_0, and set properties
  set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc v_tc_0 ]
  set_property -dict [list \
    CONFIG.GEN_FIELDID_EN {false} \
    CONFIG.HAS_AXI4_LITE {true} \
    CONFIG.HAS_INTC_IF {false} \
    CONFIG.INTERLACE_EN {true} \
    CONFIG.VIDEO_MODE {480p} \
    CONFIG.active_chroma_generation {false} \
    CONFIG.enable_detection {false} \
  ] $v_tc_0


  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKIN1_JITTER_PS {200.0} \
    CONFIG.CLKOUT1_DRIVES {BUFG} \
    CONFIG.CLKOUT1_JITTER {156.886} \
    CONFIG.CLKOUT1_PHASE_ERROR {160.484} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {120} \
    CONFIG.CLKOUT1_USED {true} \
    CONFIG.CLKOUT2_DRIVES {BUFG} \
    CONFIG.CLKOUT2_JITTER {184.592} \
    CONFIG.CLKOUT2_PHASE_ERROR {143.270} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100.000} \
    CONFIG.CLKOUT2_USED {false} \
    CONFIG.CLKOUT3_DRIVES {BUFG} \
    CONFIG.CLKOUT4_DRIVES {BUFG} \
    CONFIG.CLKOUT5_DRIVES {BUFG} \
    CONFIG.CLKOUT6_DRIVES {BUFG} \
    CONFIG.CLKOUT7_DRIVES {BUFG} \
    CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
    CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {19.500} \
    CONFIG.MMCM_CLKIN1_PERIOD {20.000} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.125} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
    CONFIG.MMCM_COMPENSATION {ZHOLD} \
    CONFIG.MMCM_DIVCLK_DIVIDE {1} \
    CONFIG.NUM_OUT_CLKS {1} \
    CONFIG.PRIMITIVE {MMCM} \
    CONFIG.PRIM_IN_FREQ {50} \
    CONFIG.USE_DYN_RECONFIG {true} \
    CONFIG.USE_RESET {true} \
  ] $clk_wiz_0


  # Create instance: ilslice_0, and set properties
  set ilslice_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice ilslice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {3} \
  ] $ilslice_0


  # Create instance: axi_protocol_convert_0, and set properties
  set axi_protocol_convert_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter axi_protocol_convert_0 ]

  # Create instance: v_mix_0, and set properties
  set v_mix_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_mix v_mix_0 ]
  set_property -dict [list \
    CONFIG.LAYER1_ALPHA {true} \
    CONFIG.LAYER1_UPSAMPLE {true} \
    CONFIG.LAYER1_VIDEO_FORMAT {27} \
    CONFIG.LAYER2_ALPHA {true} \
    CONFIG.LAYER2_UPSAMPLE {true} \
    CONFIG.LAYER2_VIDEO_FORMAT {27} \
    CONFIG.LAYER3_ALPHA {true} \
    CONFIG.LAYER3_UPSAMPLE {true} \
    CONFIG.LAYER3_VIDEO_FORMAT {27} \
  ] $v_mix_0


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect smartconnect_0 ]
  set_property CONFIG.NUM_SI {4} $smartconnect_0


  # Create instance: rst_ps7_0_mixer, and set properties
  set rst_ps7_0_mixer [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_ps7_0_mixer ]
  set_property CONFIG.C_AUX_RESET_HIGH {0} $rst_ps7_0_mixer


  # Create instance: ilslice_2, and set properties
  set ilslice_2 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice ilslice_2 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {3} \
  ] $ilslice_2


  # Create instance: rst_ps7_0_dma, and set properties
  set rst_ps7_0_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_ps7_0_dma ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axi_iic_0/IIC] [get_bd_intf_pins IIC_0]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins ps7_0_axi_periph/S00_AXI] [get_bd_intf_pins S00_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins rgb2dvi_0/TMDS] [get_bd_intf_pins TMDS_0]
  connect_bd_intf_net -intf_net axi_protocol_convert_0_M_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_protocol_convert_0/M_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins ps7_0_axi_periph/M00_AXI] [get_bd_intf_pins v_frmbuf_rd_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M05_AXI [get_bd_intf_pins ps7_0_axi_periph/M05_AXI] [get_bd_intf_pins v_mix_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins axi_protocol_convert_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins clk_wiz_0/s_axi_lite] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins v_tc_0/ctrl] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out] [get_bd_intf_pins rgb2dvi_0/RGB]
  connect_bd_intf_net -intf_net v_frmbuf_rd_0_m_axi_mm_video [get_bd_intf_pins v_frmbuf_rd_0/m_axi_mm_video] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net v_frmbuf_rd_0_m_axis_video [get_bd_intf_pins v_frmbuf_rd_0/m_axis_video] [get_bd_intf_pins v_mix_0/s_axis_video]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video1 [get_bd_intf_pins v_mix_0/m_axi_mm_video1] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video2 [get_bd_intf_pins v_mix_0/m_axi_mm_video2] [get_bd_intf_pins smartconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video3 [get_bd_intf_pins v_mix_0/m_axi_mm_video3] [get_bd_intf_pins smartconnect_0/S03_AXI]
  connect_bd_intf_net -intf_net v_mix_0_m_axis_video [get_bd_intf_pins v_axi4s_vid_out_0/video_in] [get_bd_intf_pins v_mix_0/m_axis_video]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_tc_0/vtiming_out] [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in]

  # Create port connections
  connect_bd_net -net Net  [get_bd_pins clk_wiz_0/clk_out1] \
  [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] \
  [get_bd_pins v_tc_0/clk] \
  [get_bd_pins proc_sys_reset_0/slowest_sync_clk] \
  [get_bd_pins rgb2dvi_0/PixelClk]
  connect_bd_net -net Net1  [get_bd_pins rst_ps7_0_dma/peripheral_aresetn] \
  [get_bd_pins axi_protocol_convert_0/aresetn] \
  [get_bd_pins v_axi4s_vid_out_0/aresetn]
  connect_bd_net -net axi_gpio_0_gpio_io_o  [get_bd_pins axi_gpio_0/gpio_io_o] \
  [get_bd_pins ilslice_0/Din] \
  [get_bd_pins ilslice_1/Din] \
  [get_bd_pins ilslice_2/Din]
  connect_bd_net -net axi_iic_0_iic2intc_irpt  [get_bd_pins axi_iic_0/iic2intc_irpt] \
  [get_bd_pins iic2_intr]
  connect_bd_net -net clk_in1_1  [get_bd_pins axi_clk] \
  [get_bd_pins clk_wiz_0/clk_in1] \
  [get_bd_pins rst_ps7_0_axi/slowest_sync_clk] \
  [get_bd_pins clk_wiz_0/s_axi_aclk] \
  [get_bd_pins v_tc_0/s_axi_aclk] \
  [get_bd_pins axi_gpio_0/s_axi_aclk] \
  [get_bd_pins ps7_0_axi_periph/aclk] \
  [get_bd_pins axi_iic_0/s_axi_aclk]
  connect_bd_net -net clk_wiz_0_locked  [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
  [get_bd_pins v_tc_0/resetn] \
  [get_bd_pins rgb2dvi_0/aRst_n]
  connect_bd_net -net clk_wiz_0_locked1  [get_bd_pins clk_wiz_0/locked] \
  [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net ext_reset_in_1  [get_bd_pins resetn] \
  [get_bd_pins rst_ps7_0_axi/ext_reset_in] \
  [get_bd_pins rst_ps7_0_frmbuf/ext_reset_in] \
  [get_bd_pins proc_sys_reset_0/ext_reset_in] \
  [get_bd_pins rst_ps7_0_mixer/ext_reset_in] \
  [get_bd_pins rst_ps7_0_dma/ext_reset_in]
  connect_bd_net -net ilslice_1_Dout  [get_bd_pins ilslice_1/Dout] \
  [get_bd_pins rst_ps7_0_frmbuf/aux_reset_in]
  connect_bd_net -net ilslice_1_Dout1  [get_bd_pins ilslice_0/Dout] \
  [get_bd_pins proc_sys_reset_0/aux_reset_in]
  connect_bd_net -net ilslice_2_Dout  [get_bd_pins ilslice_2/Dout] \
  [get_bd_pins rst_ps7_0_mixer/aux_reset_in]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset  [get_bd_pins proc_sys_reset_0/peripheral_reset] \
  [get_bd_pins v_axi4s_vid_out_0/vid_io_out_reset]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn  [get_bd_pins rst_ps7_0_frmbuf/peripheral_aresetn] \
  [get_bd_pins v_frmbuf_rd_0/ap_rst_n]
  connect_bd_net -net rst_ps7_0_50M_interconnect_aresetn  [get_bd_pins rst_ps7_0_axi/interconnect_aresetn] \
  [get_bd_pins ps7_0_axi_periph/aresetn]
  connect_bd_net -net rst_ps7_0_50M_peripheral_aresetn  [get_bd_pins rst_ps7_0_axi/peripheral_aresetn] \
  [get_bd_pins clk_wiz_0/s_axi_aresetn] \
  [get_bd_pins v_tc_0/s_axi_aresetn] \
  [get_bd_pins axi_iic_0/s_axi_aresetn] \
  [get_bd_pins axi_gpio_0/s_axi_aresetn]
  connect_bd_net -net rst_ps7_0_dma_interconnect_aresetn  [get_bd_pins rst_ps7_0_dma/interconnect_aresetn] \
  [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net rst_ps7_0_mixer_peripheral_aresetn  [get_bd_pins rst_ps7_0_mixer/peripheral_aresetn] \
  [get_bd_pins v_mix_0/ap_rst_n]
  connect_bd_net -net slowest_sync_clk_1  [get_bd_pins dma_clk] \
  [get_bd_pins rst_ps7_0_frmbuf/slowest_sync_clk] \
  [get_bd_pins v_axi4s_vid_out_0/aclk] \
  [get_bd_pins v_frmbuf_rd_0/ap_clk] \
  [get_bd_pins ps7_0_axi_periph/aclk1] \
  [get_bd_pins axi_protocol_convert_0/aclk] \
  [get_bd_pins v_mix_0/ap_clk] \
  [get_bd_pins smartconnect_0/aclk] \
  [get_bd_pins rst_ps7_0_mixer/slowest_sync_clk] \
  [get_bd_pins rst_ps7_0_dma/slowest_sync_clk]
  connect_bd_net -net v_axi4s_vid_out_0_locked  [get_bd_pins v_axi4s_vid_out_0/locked] \
  [get_bd_pins lock_intr]
  connect_bd_net -net v_axi4s_vid_out_0_overflow  [get_bd_pins v_axi4s_vid_out_0/overflow] \
  [get_bd_pins overflow_intr]
  connect_bd_net -net v_axi4s_vid_out_0_underflow  [get_bd_pins v_axi4s_vid_out_0/underflow] \
  [get_bd_pins underflow_intr]
  connect_bd_net -net v_axi4s_vid_out_0_vtg_ce  [get_bd_pins v_axi4s_vid_out_0/vtg_ce] \
  [get_bd_pins v_tc_0/clken]
  connect_bd_net -net v_frmbuf_rd_0_interrupt  [get_bd_pins v_frmbuf_rd_0/interrupt] \
  [get_bd_pins dma_intr]
  connect_bd_net -net v_mix_0_interrupt  [get_bd_pins v_mix_0/interrupt] \
  [get_bd_pins vmix_intr]
  connect_bd_net -net v_tc_0_irq  [get_bd_pins v_tc_0/irq] \
  [get_bd_pins vtc_intr]
  connect_bd_net -net xlconstant_0_dout  [get_bd_pins xlconstant_0/dout] \
  [get_bd_pins v_tc_0/gen_clken] \
  [get_bd_pins v_tc_0/s_axi_aclken] \
  [get_bd_pins v_axi4s_vid_out_0/aclken] \
  [get_bd_pins v_axi4s_vid_out_0/vid_io_out_ce]

  # Restore current instance
  current_bd_instance $oldCurInst
}
