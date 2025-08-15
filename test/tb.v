`timescale 1ns/1ps

module tb;

    reg  [7:0] ui_in;
    wire [7:0] uo_out;
    reg  [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg clk, rst_n, ena;

    tt_um_vedic_4x4 dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize
        rst_n = 0;
        ena = 0;
        ui_in = 0;
        uio_in = 0;

        // Apply reset
        #20;
        rst_n = 1;
        ena = 1;

        // Apply test: 3 * 2 = 6
        ui_in = {4'd3, 4'd2};
        #20;
        $display("3 * 2 = %d", uo_out);  // should be 6

        // Apply test: 4 * 5 = 20
        ui_in = {4'd4, 4'd5};
        #20;
        $display("4 * 5 = %d", uo_out);  // should be 20

        // Apply test: 15 * 15 = 225
        ui_in = {4'd15, 4'd15};
        #20;
        $display("15 * 15 = %d", uo_out);  // should be 225

        // Done
        $finish;
    end
endmodule
