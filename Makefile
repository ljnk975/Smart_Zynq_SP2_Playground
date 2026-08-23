############################################
## Makefile for Vivado project on
## Smart Zynq SP2 boards
##
## @author: Van Linh
## @email: ljnk975@gmail.com
##
############################################

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
VIVADO_DIR ?= Vivado

# Vivado script dir
VIVADO_SCRIPT_DIR ?= scripts/Vivado

# Vivado project name
VIVADO_PROJ_NAME ?= Smart_Zynq_SP2_Base

# Vivado top file
VIVADO_TOP_NAME ?= TopModule

### Derive variable ###
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
