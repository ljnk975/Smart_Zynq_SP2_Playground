############################################
## Makefile for Vivado project on
## Smart Zynq SP2 boards
##
## @author: Van Linh
## @email: ljnk975@gmail.com
##
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
	cd $(VIVADO_DIR); $(VIVADO) $(VIVADO_PARAMS) -script $(VIVADO_SCRIPT_AB_DIR)/export.tcl $(VIVADO_PROJ_NAME).xpr

# Open project
.PHONY: vivado-gui
vivado-gui: $(VIVADO_DIR)/$(VIVADO_PROJ_NAME).xpr
	cd $(VIVADO_DIR); $(VIVADO) $(VIVADO_PARAMS) -script $(VIVADO_SCRIPT_AB_DIR)/start_gui.tcl $(VIVADO_PROJ_NAME).xpr

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

petalinux-init: _petalinux_trigger_reinit petalinux-update
	sed -i "s/\(target.append(get_attr(dir)\)/if len(os.listdir(os.path.join(rootpath, dir))) == 0: \1/" $(PETALINUX_DIR)/components/yocto/layers/poky/meta/classes-global/package_rpm.bbclass

# Update project
.PHONY: _petalinux_trigger_update petalinux-update
_petalinux_trigger_update: | $(PETALINUX_DIR)
	touch $(PETALINUX_DIR)/.trigger_update

.PHONY: petalinux-update
petalinux-update: _petalinux_trigger_update $(PETALINUX_DIR)/.updated

# Config
.PHONY: petalinux-config-hardware
petalinux-config-hardware: $(VIVADO_DIR)/$(VIVADO_PROJ_NAME).xsa | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-config --get-hw-description=$(VIVADO_AB_DIR)/$(VIVADO_PROJ_NAME).xsa

.PHONY: petalinux-config-uboot
petalinux-config-uboot: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-config -c uboot

.PHONY: petalinux-config-kernel
petalinux-config-kernel: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-config -c kernel

.PHONY: petalinux-config-rootfs
petalinux-config-rootfs: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-config -c rootfs

# Build
.PHONY: petalinux-build
petalinux-build: | $(PETALINUX_DIR)
	cd $(PETALINUX_DIR); petalinux-build
	cd $(PETALINUX_DIR); petalinux-package boot --fsbl ./images/linux/zynq_fsbl.elf --u-boot --fpga --force
