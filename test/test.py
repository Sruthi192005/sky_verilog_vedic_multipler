import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting 4x4 Vedic Multiplier Test")

    clock = Clock(dut.clk, 10, units="ns")  # 100 MHz clock
    cocotb.start_soon(clock.start())

    # Reset sequence
    dut.rst_n.value = 0
    dut.ena.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    dut.ena.value = 1
    await ClockCycles(dut.clk, 5)

    test_vectors = [
        (3, 2, 6),
        (5, 4, 20),
        (15, 15, 225),
        (9, 0, 0),
    ]

    for a, b, expected in test_vectors:
        dut.ui_in.value = (a << 4) | b
        await ClockCycles(dut.clk, 2)  # wait for output to stabilize
        result = dut.uo_out.value.integer
        assert result == expected, f"Failed: {a}*{b}={result}, expected {expected}"
        dut._log.info(f"Passed: {a}*{b}={result}")

    dut._log.info("All test cases passed.")
