# Makefile for Cocotb simulation of Vedic 4x4 multiplier

# Simulator
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Project structure
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = project.v

# PDK path (used only if GATES=yes)
PDK_ROOT ?= /home/runner/.volare/sky130/fa87f8f4bbcc7255b6f0c0fb506960f531ae2392
PDK_PATH = $(PDK_ROOT)

$(info Using PDK_ROOT: $(PDK_ROOT))

ifeq ($(GATES),yes)
  SIM_BUILD = sim_build/gl
  COMPILE_ARGS += -DGL_TEST -DFUNCTIONAL -DUSE_POWER_PINS -DSIM -DUNIT_DELAY=\#1

  # Hardcoded paths to PDK files
  PRIMITIVES_V = $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
  SKY130_V = $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

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

  # Gate-level netlist (adjust this if your path changes)
  GATE_LEVEL_NETLIST = /home/runner/work/sky_verilog_vedic_multipler/sky_verilog_vedic_multipler/dependencies/sky130/sky130A/libs.tech/xschem/decred_hash_macro/user_project_wrapper.v
  VERILOG_SOURCES += $(GATE_LEVEL_NETLIST)
  COMPILE_ARGS += -I/home/runner/work/sky_verilog_vedic_multipler/sky_verilog_vedic_multipler/dependencies/decred_top/rtl/src
else
  SIM_BUILD = sim_build/rtl
  VERILOG_SOURCES += $(addprefix $(SRC_DIR)/, $(PROJECT_SOURCES))
endif

# Include paths
COMPILE_ARGS += -I$(SRC_DIR)

# Testbench and simulation
VERILOG_SOURCES += tb.v
TOPLEVEL = tb
MODULE = test  # This is your test.py module name (without .py)

# Disable debug mode (fixes GDB issue)
export COCOTB_SIM_DEBUG = 0

# Targets
.PHONY: debug
debug::
	@echo "=== Makefile Debug Information ==="
	@echo "GATES: $(GATES)"
	@echo "PDK_ROOT: $(PDK_ROOT)"
	@echo "SIM_BUILD: $(SIM_BUILD)"
	@echo "VERILOG_SOURCES: $(VERILOG_SOURCES)"
	@echo "COMPILE_ARGS: $(COMPILE_ARGS)"

.PHONY: clean
clean::
	rm -rf $(SIM_BUILD)
	rm -f results.xml *.vcd

# Include cocotb’s simulator rules
include $(shell cocotb-config --makefiles)/Makefile.sim
