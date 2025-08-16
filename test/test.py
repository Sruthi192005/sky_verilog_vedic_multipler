import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import os

@cocotb.test()
async def test_project(dut):
    # Dump waveform to tb.vcd in current working directory
    cocotb.start_soon(cocotb.triggers.DumpVcd(dut._log, os.path.join(os.getcwd(), "tb.vcd")))

    dut._log.info("Starting 4x4 Vedic Multiplier Test")

    clock = Clock(dut.clk, 10, units="ns")  # 100 MHz clock
    cocotb.start_soon(clock.start())

    # Reset sequence
    dut.rst_n.value = 0
    dut.ena.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    dut.ena.value = 1
    await RisingEdge(dut.clk)

    test_vectors = [
        (3, 2, 6),
        (5, 4, 20),
        (15, 15, 225),
        (9, 0, 0),
    ]

    for a, b, expected in test_vectors:
        dut.ui_in.value = (a << 4) | b
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)
        result = dut.uo_out.value.integer
        dut._log.info(f"Testing {a} * {b}: got {result}, expected {expected}")
        assert result == expected, f"Failed: {a}*{b}={result}, expected {expected}"

    dut._log.info("All test cases passed.")
