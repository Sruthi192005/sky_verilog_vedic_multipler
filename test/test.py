# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Clock setup
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset and enable
    dut.ena.value = 1
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    # Test 1: 3 * 2 = 6
    dut.ui_in.value = (3 << 4) | 2
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 6, f"Expected 6, got {dut.uo_out.value.integer}"

    # Test 2: 5 * 4 = 20
    dut.ui_in.value = (5 << 4) | 4
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 20, f"Expected 20, got {dut.uo_out.value.integer}"

    # Test 3: 15 * 15 = 225
    dut.ui_in.value = (15 << 4) | 15
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 225, f"Expected 225, got {dut.uo_out.value.integer}"

    # Test 4: 9 * 0 = 0
    dut.ui_in.value = (9 << 4) | 0
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 0, f"Expected 0, got {dut.uo_out.value.integer}"

    dut._log.info("All test cases passed.")
