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
############################################
## Makefile for Vivado project on
## Smart Zynq SP2 boards
############################################

##############
## Variable ##
##############
WORK_DIR ?= WORK

##################
## Vivado build ##
##################

### Variable ###
# Vivado cmd
VIVADO ?= vivado

# Vivado launch params
VIVADO_PARAMS ?=

# Execute vivado in gui
VIVADO_GUI ?= 0

# Vivado working directory
VIVADO_DIR ?= $(WORK_DIR)/Vivado

# Vivado script dir
VIVADO_SCRIPT_DIR ?= scripts/Vivado

# Vivado project name
VIVADO_PROJ_NAME ?= Smart_Zynq_SP2_Base

# Vivado top file
VIVADO_TOP_NAME ?= TopModule

# Vivado hw server
VIVADO_HW_SERVER ?= localhost:3121

### Derive variable ###
VIVADO_AB_DIR = $(realpath $(VIVADO_DIR))
VIVADO_SCRIPT_AB_DIR = $(realpath $(VIVADO_SCRIPT_DIR))

ifneq "$(VIVADO_GUI)" "1"
VIVADO_PARAMS += -mode batch
endif

### Target ###
## Real target
$(VIVADO_DIR):
	mkdir -p $(VIVADO_DIR)

$(VIVADO_DIR)/$(VIVADO_PROJ_NAME).xpr: | $(VIVADO_DIR)
	cd $(VIVADO_DIR); $(VIVADO) $(VIVADO_PARAMS) -script $(VIVADO_SCRIPT_AB_DIR)/project.tcl -tclargs --origin_dir $(PWD) --project_name $(VIVADO_PROJ_NAME)

$(VIVADO_DIR)/.trigger_rebuild:
	touch $@

$(VIVADO_DIR)/$(VIVADO_PROJ_NAME).xsa: $(VIVADO_DIR)/$(VIVADO_PROJ_NAME).xpr $(VIVADO_DIR)/.trigger_rebuild
	cd $(VIVADO_DIR); $(VIVADO) $(VIVADO_PARAMS) -script $(VIVADO_SCRIPT_AB_DIR)/build.tcl $(VIVADO_PROJ_NAME).xpr

## Virtual target
# Init project
.PHONY: _trigger_reinit vivado-init
_trigger_reinit:
# TODO: backup when reinit project
	rm -rf $(VIVADO_DIR)

vivado-init: _trigger_reinit $(VIVADO_DIR)/$(VIVADO_PROJ_NAME).xpr

# Build project
.PHONY: _trigger_rebuild vivado-build
_trigger_rebuild:
	touch $(VIVADO_DIR)/.trigger_rebuild

vivado-build: _trigger_rebuild $(VIVADO_DIR)/$(VIVADO_PROJ_NAME).xsa

# Export project
.PHONY: vivado-export
vivado-export: $(VIVADO_DIR)/$(VIVADO_PROJ_NAME).xpr
	cd $(VIVADO_DIR); $(VIVADO) $(VIVADO_PARAMS) -script $(VIVADO_SCRIPT_AB_DIR)/export.tcl $(VIVADO_PROJ_NAME).xpr -tclargs --origin_dir $(PWD)

# Open project
.PHONY: vivado-gui
vivado-gui: $(VIVADO_DIR)/$(VIVADO_PROJ_NAME).xpr
	cd $(VIVADO_DIR); $(VIVADO) $(VIVADO_PARAMS) -script $(VIVADO_SCRIPT_AB_DIR)/start_gui.tcl $(VIVADO_PROJ_NAME).xpr

# Open hw server
.PHONY: vivado-hw_server
vivado-hw_server: $(VIVADO_DIR)/$(VIVADO_PROJ_NAME).xpr
	cd $(VIVADO_DIR); hw_server -s"TCP:$(VIVADO_HW_SERVER)"

#####################
## Petalinux build ##
#####################

### Variable ###
# Petalinux project name
PETALINUX_PROJ_NAME ?= Petalinux

# Petalinux template
PETALINUX_TEMPLATE_NAME ?= zynq

# Petalinux working directory
PETALINUX_DIR ?= $(WORK_DIR)/$(PETALINUX_PROJ_NAME)

### Derive variable ###
PETALINUX_AB_DIR = $(realpath $(PETALINUX_DIR))

### Target ###
## Real target
$(PETALINUX_DIR):
	cd $(WORK_DIR); petalinux-create project --template $(PETALINUX_TEMPLATE_NAME) --name $(PETALINUX_PROJ_NAME)

$(PETALINUX_DIR)/.trigger_update: | $(PETALINUX_DIR)
	touch $@

$(PETALINUX_DIR)/.updated: $(PETALINUX_DIR)/.trigger_update
# FIXME: cannot use PETALINUX_AB_DIR
	cd petalinux; find . -type f | cpio -pduv $(PWD)/$(WORK_DIR)/$(PETALINUX_PROJ_NAME)
	cd petalinux; find . -type f -exec sed -i 's%\$${FPGA_PROJECT_ROOT}%$(PWD)%g' $(PWD)/$(WORK_DIR)/$(PETALINUX_PROJ_NAME)/{} \;

## Virtual target
# Init project
.PHONY: _petalinux_trigger_reinit petalinux-init
_petalinux_trigger_reinit:
# TODO: backup when reinit project
	rm -rf $(PETALINUX_DIR)

petalinux-init: _petalinux_trigger_reinit petalinux-update petalinux-update-hardware
	sed -i "s/\(target.append(get_attr(dir)\)/if len(os.listdir(os.path.join(rootpath, dir))) == 0: \1/" $(PETALINUX_DIR)/components/yocto/layers/poky/meta/classes-global/package_rpm.bbclass

# Update project
.PHONY: _petalinux_trigger_update petalinux-update
_petalinux_trigger_update: | $(PETALINUX_DIR)
	touch $(PETALINUX_DIR)/.trigger_update

.PHONY: petalinux-update
petalinux-update: _petalinux_trigger_update $(PETALINUX_DIR)/.updated

.PHONY: petalinux-update-hardware
petalinux-update-hardware: $(VIVADO_DIR)/$(VIVADO_PROJ_NAME).xsa | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-config --get-hw-description=$(VIVADO_AB_DIR)/$(VIVADO_PROJ_NAME).xsa --silentconfig

# Config
.PHONY: petalinux-config
petalinux-config: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-config

.PHONY: petalinux-config-uboot
petalinux-config-uboot: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-config -c uboot

.PHONY: petalinux-config-kernel
petalinux-config-kernel: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-config -c kernel

.PHONY: petalinux-config-rootfs
petalinux-config-rootfs: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-config -c rootfs

# Clean
petalinux-clean-kernel: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-build -c kernel -x cleansstate

petalinux-clean-rootfs: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-build -c rootfs -x cleansstate

# Build
.PHONY: petalinux-build
petalinux-build: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-build
	cd $(PETALINUX_DIR); petalinux-package boot --fsbl ./images/linux/zynq_fsbl.elf --u-boot --fpga --force
	cd $(PETALINUX_DIR); petalinux-package prebuilt --force

# Run
.PHONY: petalinux-run
petalinux-run: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-boot jtag --prebuilt 3 --hw_server-url "TCP:$(VIVADO_HW_SERVER)"
