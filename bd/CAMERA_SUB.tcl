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

# Hierarchical cell: CAMERA_SUB
proc create_hier_cell_CAMERA_SUB { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_CAMERA_SUB() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 vid_in

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 vid_iic


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk axi_clk
  create_bd_pin -dir O -type intr dma_intr
  create_bd_pin -dir O -from 0 -to 0 vid_resetn
  create_bd_pin -dir O -type intr iic_intr
  create_bd_pin -dir I -type clk vid_in_clk
  create_bd_pin -dir I -type rst vid_in_resetn
  create_bd_pin -dir I -type clk dma_clk
  create_bd_pin -dir O -from 0 -to 0 vid_pwd
  create_bd_pin -dir O -type intr demosaic_intr

  # Create instance: smartconnect_axi, and set properties
  set smartconnect_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect smartconnect_axi ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {4} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_axi


  # Create instance: v_frmbuf_wr_0, and set properties
  set v_frmbuf_wr_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr v_frmbuf_wr_0 ]
  set_property -dict [list \
    CONFIG.HAS_BGR8 {1} \
    CONFIG.HAS_RGB8 {0} \
    CONFIG.HAS_UYVY8 {0} \
    CONFIG.HAS_YUV8 {0} \
    CONFIG.HAS_YUVX8 {0} \
    CONFIG.HAS_YUYV8 {0} \
    CONFIG.HAS_Y_UV8 {0} \
    CONFIG.HAS_Y_UV8_420 {0} \
    CONFIG.HAS_Y_U_V8 {0} \
    CONFIG.HAS_Y_U_V8_420 {0} \
    CONFIG.SAMPLES_PER_CLOCK {1} \
  ] $v_frmbuf_wr_0


  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {32} \
  ] $axi_gpio_0


  # Create instance: proc_sys_reset_video, and set properties
  set proc_sys_reset_video [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_video ]
  set_property CONFIG.C_AUX_RESET_HIGH {0} $proc_sys_reset_video


  # Create instance: axi_protocol_convert_0, and set properties
  set axi_protocol_convert_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter axi_protocol_convert_0 ]

  # Create instance: proc_sys_reset_frmbuf, and set properties
  set proc_sys_reset_frmbuf [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_frmbuf ]
  set_property CONFIG.C_AUX_RESET_HIGH {1} $proc_sys_reset_frmbuf


  # Create instance: ilslice_1, and set properties
  set ilslice_1 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice ilslice_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {32} \
  ] $ilslice_1


  # Create instance: ilslice_8, and set properties
  set ilslice_8 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice ilslice_8 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {8} \
    CONFIG.DIN_TO {8} \
    CONFIG.DIN_WIDTH {32} \
  ] $ilslice_8


  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter axis_clock_converter_0 ]

  # Create instance: ilslice_0, and set properties
  set ilslice_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice ilslice_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {32} \
  ] $ilslice_0


  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic axi_iic_0 ]
  set_property -dict [list \
    CONFIG.C_SCL_INERTIAL_DELAY {0} \
    CONFIG.C_SDA_INERTIAL_DELAY {0} \
  ] $axi_iic_0


  # Create instance: v_demosaic_0, and set properties
  set v_demosaic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic v_demosaic_0 ]

  # Create instance: ilslice_9, and set properties
  set ilslice_9 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice ilslice_9 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {9} \
    CONFIG.DIN_TO {9} \
  ] $ilslice_9


  # Create instance: proc_sys_reset_demosaic, and set properties
  set proc_sys_reset_demosaic [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_demosaic ]
  set_property CONFIG.C_AUX_RESET_HIGH {1} $proc_sys_reset_demosaic


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axi_iic_0/IIC] [get_bd_intf_pins vid_iic]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins smartconnect_axi/S00_AXI] [get_bd_intf_pins S00_AXI]
  connect_bd_intf_net -intf_net axi_protocol_convert_0_M_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_protocol_convert_0/M_AXI]
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins v_demosaic_0/s_axis_video] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_axi/M00_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins smartconnect_axi/M02_AXI] [get_bd_intf_pins v_frmbuf_wr_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net smartconnect_axi_M01_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins smartconnect_axi/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_axi_M03_AXI [get_bd_intf_pins smartconnect_axi/M03_AXI] [get_bd_intf_pins v_demosaic_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net v_demosaic_0_m_axis_video [get_bd_intf_pins v_demosaic_0/m_axis_video] [get_bd_intf_pins v_frmbuf_wr_0/s_axis_video]
  connect_bd_intf_net -intf_net v_frmbuf_wr_0_m_axi_mm_video [get_bd_intf_pins axi_protocol_convert_0/S_AXI] [get_bd_intf_pins v_frmbuf_wr_0/m_axi_mm_video]
  connect_bd_intf_net -intf_net vid_in_1 [get_bd_intf_pins vid_in] [get_bd_intf_pins axis_clock_converter_0/S_AXIS]

  # Create port connections
  connect_bd_net -net axi_gpio_0_gpio_io_o  [get_bd_pins axi_gpio_0/gpio_io_o] \
  [get_bd_pins ilslice_1/Din] \
  [get_bd_pins ilslice_8/Din] \
  [get_bd_pins ilslice_0/Din] \
  [get_bd_pins ilslice_9/Din]
  connect_bd_net -net axi_iic_0_iic2intc_irpt  [get_bd_pins axi_iic_0/iic2intc_irpt] \
  [get_bd_pins iic_intr]
  connect_bd_net -net ext_reset_in_1  [get_bd_pins axi_resetn] \
  [get_bd_pins proc_sys_reset_video/ext_reset_in] \
  [get_bd_pins proc_sys_reset_frmbuf/ext_reset_in] \
  [get_bd_pins smartconnect_axi/aresetn] \
  [get_bd_pins axi_gpio_0/s_axi_aresetn] \
  [get_bd_pins axi_iic_0/s_axi_aresetn] \
  [get_bd_pins proc_sys_reset_demosaic/ext_reset_in]
  connect_bd_net -net ilslice_0_Dout  [get_bd_pins ilslice_1/Dout] \
  [get_bd_pins vid_resetn]
  connect_bd_net -net ilslice_1_Dout  [get_bd_pins ilslice_8/Dout] \
  [get_bd_pins proc_sys_reset_frmbuf/aux_reset_in]
  connect_bd_net -net ilslice_2_Dout  [get_bd_pins ilslice_0/Dout] \
  [get_bd_pins vid_pwd]
  connect_bd_net -net ilslice_9_Dout  [get_bd_pins ilslice_9/Dout] \
  [get_bd_pins proc_sys_reset_demosaic/aux_reset_in]
  connect_bd_net -net m_axis_aclk_0_1  [get_bd_pins dma_clk] \
  [get_bd_pins axis_clock_converter_0/m_axis_aclk] \
  [get_bd_pins v_frmbuf_wr_0/ap_clk] \
  [get_bd_pins smartconnect_axi/aclk1] \
  [get_bd_pins proc_sys_reset_frmbuf/slowest_sync_clk] \
  [get_bd_pins axi_protocol_convert_0/aclk] \
  [get_bd_pins v_demosaic_0/ap_clk] \
  [get_bd_pins proc_sys_reset_demosaic/slowest_sync_clk]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins proc_sys_reset_demosaic/peripheral_aresetn] \
  [get_bd_pins v_demosaic_0/ap_rst_n]
  connect_bd_net -net proc_sys_reset_dma_peripheral_aresetn  [get_bd_pins proc_sys_reset_frmbuf/peripheral_aresetn] \
  [get_bd_pins v_frmbuf_wr_0/ap_rst_n] \
  [get_bd_pins axi_protocol_convert_0/aresetn] \
  [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net proc_sys_reset_video_peripheral_aresetn  [get_bd_pins proc_sys_reset_video/peripheral_aresetn] \
  [get_bd_pins axis_clock_converter_0/s_axis_aresetn]
  connect_bd_net -net slowest_sync_clk_1  [get_bd_pins axi_clk] \
  [get_bd_pins axi_gpio_0/s_axi_aclk] \
  [get_bd_pins smartconnect_axi/aclk] \
  [get_bd_pins axi_iic_0/s_axi_aclk]
  connect_bd_net -net v_demosaic_0_interrupt  [get_bd_pins v_demosaic_0/interrupt] \
  [get_bd_pins demosaic_intr]
  connect_bd_net -net v_frmbuf_wr_0_interrupt  [get_bd_pins v_frmbuf_wr_0/interrupt] \
  [get_bd_pins dma_intr]
  connect_bd_net -net vid_in_clk_1  [get_bd_pins vid_in_clk] \
  [get_bd_pins axis_clock_converter_0/s_axis_aclk] \
  [get_bd_pins proc_sys_reset_video/slowest_sync_clk]
  connect_bd_net -net vid_in_reset_1  [get_bd_pins vid_in_resetn] \
  [get_bd_pins proc_sys_reset_video/aux_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}
