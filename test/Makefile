# Makefile for Cocotb + Sky130 VLSI Test
# Compatible with RTL and Gate-level simulation

SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = project.v

# PDK Configuration
PDK_ROOT ?= /home/runner/.volare/sky130/fa87f8f4bbcc7255b6f0c0fb506960f531ae2392
PDK_PATH = $(PDK_ROOT)

$(info Using PDK_ROOT: $(PDK_ROOT))

# RTL or Gate-Level Simulation Selection
ifneq ($(GATES),yes)

# RTL
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

else

# Gate-Level
SIM_BUILD = sim_build/gl
COMPILE_ARGS += -DGL_TEST -DFUNCTIONAL -DUSE_POWER_PINS -DSIM -DUNIT_DELAY=\#1

# Hardcoded paths to required PDK Verilog models
PRIMITIVES_V = $(PDK_PATH)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
SKY130_V = $(PDK_PATH)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

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

# Hardcoded gate-level netlist path
GATE_LEVEL_NETLIST = /home/runner/work/sky_verilog_vedic_multipler/sky_verilog_vedic_multipler/dependencies/sky130/sky130A/libs.tech/xschem/decred_hash_macro/user_project_wrapper.v
VERILOG_SOURCES += $(GATE_LEVEL_NETLIST)
$(info Found gate-level netlist at: $(GATE_LEVEL_NETLIST))

# Include path for missing "decred_defines.v"
COMPILE_ARGS += -I/home/runner/work/sky_verilog_vedic_multipler/sky_verilog_vedic_multipler/dependencies/decred_top/rtl/src

endif # GATES

# Add testbench and source
COMPILE_ARGS += -I$(SRC_DIR)
VERILOG_SOURCES += tb.v

TOPLEVEL = tb
MODULE = test  # Only needed if you have test/test.py (optional)

# Debug target (optional)
.PHONY: debug
debug:
	@echo "=== Makefile Debug Information ==="
	@echo "GATES: $(GATES)"
	@echo "PDK_ROOT: $(PDK_ROOT)"
	@echo "VERILOG_SOURCES: $(VERILOG_SOURCES)"
	@echo "SIM_BUILD: $(SIM_BUILD)"

# Clean target (append, not replace Cocotb's clean)
.PHONY: clean
clean::
	rm -rf $(SIM_BUILD)
	rm -f results.xml *.vcd

# Include Cocotb rules
include $(shell cocotb-config --makefiles)/Makefile.sim
