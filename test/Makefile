# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# Defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = project.v

# PDK configuration
PDK_ROOT ?= $(HOME)/.volare/sky130/fa87f8f4bbcc7255b6f0c0fb506960f531ae2392
PDK_PATH = $(PDK_ROOT)

# Debug info
$(info Using PDK_ROOT: $(PDK_ROOT))

# RTL vs Gate-Level simulation
ifneq ($(GATES),yes)

# === RTL simulation ===
SIM_BUILD = sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))

else

# === Gate-level simulation ===
SIM_BUILD = sim_build/gl
COMPILE_ARGS += -DGL_TEST
COMPILE_ARGS += -DFUNCTIONAL
COMPILE_ARGS += -DUSE_POWER_PINS
COMPILE_ARGS += -DSIM
COMPILE_ARGS += -DUNIT_DELAY=\#1

# Find verilog path inside PDK
PDK_VERILOG_PATH = $(shell \
	if [ -f "$(PDK_PATH)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v" ]; then \
		echo "$(PDK_PATH)/sky130A/libs.ref/sky130_fd_sc_hd/verilog"; \
	elif [ -f "$(PDK_PATH)/libs.ref/sky130_fd_sc_hd/verilog/primitives.v" ]; then \
		echo "$(PDK_PATH)/libs.ref/sky130_fd_sc_hd/verilog"; \
	elif [ -f "$(HOME)/.volare/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v" ]; then \
		echo "$(HOME)/.volare/sky130A/libs.ref/sky130_fd_sc_hd/verilog"; \
	else \
		echo ""; \
	fi)

# Find required library files
PRIMITIVES_V = $(shell \
	if [ -f "$(PDK_VERILOG_PATH)/primitives.v" ]; then \
		echo "$(PDK_VERILOG_PATH)/primitives.v"; \
	else \
		find $(PDK_PATH) -name "primitives.v" 2>/dev/null | head -1; \
	fi)

SKY130_V = $(shell \
	if [ -f "$(PDK_VERILOG_PATH)/sky130_fd_sc_hd.v" ]; then \
		echo "$(PDK_VERILOG_PATH)/sky130_fd_sc_hd.v"; \
	else \
		find $(PDK_PATH) -name "sky130_fd_sc_hd.v" 2>/dev/null | head -1; \
	fi)

# Add to sources
ifneq ($(PRIMITIVES_V),)
VERILOG_SOURCES += $(PRIMITIVES_V)
$(info Found primitives.v at: $(PRIMITIVES_V))
else
$(warning Could not find primitives.v in PDK)
endif

ifneq ($(SKY130_V),)
VERILOG_SOURCES += $(SKY130_V)
$(info Found sky130_fd_sc_hd.v at: $(SKY130_V))
else
$(warning Could not find sky130_fd_sc_hd.v in PDK)
endif

# Detect gate-level netlist
GATE_LEVEL_NETLIST = $(shell \
	if [ -f "$(PWD)/gate_level_netlist.v" ]; then \
		echo "$(PWD)/gate_level_netlist.v"; \
	elif [ -f "$(PWD)/../runs/wokwi/results/final/verilog/gl/user_project_wrapper.v" ]; then \
		echo "$(PWD)/../runs/wokwi/results/final/verilog/gl/user_project_wrapper.v"; \
	elif [ -f "$(PWD)/../user_project_wrapper.v" ]; then \
		echo "$(PWD)/../user_project_wrapper.v"; \
	else \
		find $(PWD)/.. -name "*netlist*.v" -o -name "*gl*.v" -o -name "user_project_wrapper.v" 2>/dev/null | head -1; \
	fi)

ifneq ($(GATE_LEVEL_NETLIST),)
VERILOG_SOURCES += $(GATE_LEVEL_NETLIST)
$(info Found gate-level netlist at: $(GATE_LEVEL_NETLIST))
else
$(error Gate-level netlist not found. Expected at $(PWD)/gate_level_netlist.v or similar location)
endif

endif  # GATES

# Shared settings
COMPILE_ARGS += -I$(SRC_DIR)
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tb
MODULE = test

# Debug target
.PHONY: debug
debug:
	@echo "=== Makefile Debug Information ==="
	@echo "GATES: $(GATES)"
	@echo "PDK_ROOT: $(PDK_ROOT)"
	@echo "PDK_PATH: $(PDK_PATH)"
	@echo "PDK_VERILOG_PATH: $(PDK_VERILOG_PATH)"
	@echo "PRIMITIVES_V: $(PRIMITIVES_V)"
	@echo "SKY130_V: $(SKY130_V)"
	@echo "GATE_LEVEL_NETLIST: $(GATE_LEVEL_NETLIST)"
	@echo "VERILOG_SOURCES: $(VERILOG_SOURCES)"
	@echo "SIM_BUILD: $(SIM_BUILD)"

# Clean target (uses :: to avoid conflict with cocotb's Makefile)
.PHONY: clean
clean::
	rm -rf $(SIM_BUILD)
	rm -f results.xml
	rm -f *.vcd

# Include cocotb make rules
include $(shell cocotb-config --makefiles)/Makefile.sim
