# Makefile for simulation with cocotb and Icarus Verilog

# General simulation settings
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR := $(PWD)/../src
PROJECT_SOURCES := project.v

# Top-level module (testbench)
TOPLEVEL := tb         # Must match the testbench module name in tb.v
VERILOG_SOURCES += tb.v

# PDK configuration
PDK_ROOT ?= /home/runner/.volare/sky130/fa87f8f4bbcc7255b6f0c0fb506960f531ae2392
PDK_PATH := $(PDK_ROOT)
$(info Using PDK_ROOT: $(PDK_ROOT))

# RTL vs Gate-Level Simulation
ifeq ($(GATES),yes)

# === Gate-level simulation ===
SIM_BUILD := sim_build/gl
COMPILE_ARGS += -DGL_TEST -DFUNCTIONAL -DUSE_POWER_PINS -DSIM -DUNIT_DELAY=\#1

# PDK Verilog sources (hardcoded)
PRIMITIVES_V := $(PDK_PATH)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
SKY130_V     := $(PDK_PATH)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# Check if files exist and include
ifneq ($(wildcard $(PRIMITIVES_V)),)
  VERILOG_SOURCES += $(PRIMITIVES_V)
  $(info Found primitives.v at: $(PRIMITIVES_V))
else
  $(warning Could not find primitives.v in PDK)
endif

ifneq ($(wildcard $(SKY130_V)),)
  VERILOG_SOURCES += $(SKY130_V)
  $(info Found sky130_fd_sc_hd.v at: $(SKY130_V))
else
  $(warning Could not find sky130_fd_sc_hd.v in PDK)
endif

# Gate-level netlist path (manually specified)
GATE_LEVEL_NETLIST := /home/runner/work/sky_verilog_vedic_multipler/sky_verilog_vedic_multipler/dependencies/sky130/sky130A/libs.tech/xschem/decred_hash_macro/user_project_wrapper.v

ifneq ($(wildcard $(GATE_LEVEL_NETLIST)),)
  VERILOG_SOURCES += $(GATE_LEVEL_NETLIST)
  $(info Found gate-level netlist at: $(GATE_LEVEL_NETLIST))
else
  $(error Gate-level netlist not found at: $(GATE_LEVEL_NETLIST))
endif

# Add include path if needed (comment out if decred_defines.v isn't needed)
COMPILE_ARGS += -I/home/runner/work/sky_verilog_vedic_multipler/sky_verilog_vedic_multipler/dependencies/decred_top/rtl/src

else

# === RTL simulation ===
SIM_BUILD := sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

endif

# Always include source directory
COMPILE_ARGS += -I$(SRC_DIR)

# Debug target to inspect what’s being used
.PHONY: debug
debug:
	@echo "=== Makefile Debug Information ==="
	@echo "GATES: $(GATES)"
	@echo "PDK_ROOT: $(PDK_ROOT)"
	@echo "VERILOG_SOURCES: $(VERILOG_SOURCES)"
	@echo "SIM_BUILD: $(SIM_BUILD)"
	@echo "COMPILE_ARGS: $(COMPILE_ARGS)"

# Clean target
.PHONY: clean
clean:
	rm -rf $(SIM_BUILD)
	rm -f results.xml *.vcd

# Include cocotb simulation make rules
include $(shell cocotb-config --makefiles)/Makefile.sim
