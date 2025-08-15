# Makefile for Cocotb testbench with Sky130 gate-level support

# Choose the simulator and language
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Project structure
SRC_DIR := $(PWD)/../src
PROJECT_SOURCES := project.v

# Output directories
ifeq ($(GATES),yes)
	SIM_BUILD := sim_build/gl
else
	SIM_BUILD := sim_build/rtl
endif

# Default compile arguments
COMPILE_ARGS += -I$(SRC_DIR)

# Source files (RTL or Gate-level)
VERILOG_SOURCES :=

ifeq ($(GATES),yes)

	# Gate-level simulation
	COMPILE_ARGS    += -DGL_TEST -DFUNCTIONAL -DSIM

	# Include sky130 standard cell libraries
	VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

	
	VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd__udp_primitives.v
	VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v

	# Gate-level netlist
	VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

else

	# RTL simulation
	VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

endif

# Include testbench and top module
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL := tb

# Python test module
MODULE := test

# Include cocotb rules
include $(shell cocotb-config --makefiles)/Makefile.sim
