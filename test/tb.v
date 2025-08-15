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
     initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    initial begin
        ena   = 1;
        rst_n = 0;
        uio_in = 8'b0;
        ui_in = 8'b0;

        repeat (5) @(posedge clk);
        rst_n = 1;

        // Test 1: 3 * 2 = 6
        ui_in = {4'd3, 4'd2};
        repeat (2) @(posedge clk);
        $display("Result: %d", uo_out);

        // Test 2: 5 * 4 = 20
        ui_in = {4'd5, 4'd4};
        repeat (2) @(posedge clk);

        // Test 3: 15 * 15 = 225
        ui_in = {4'd15, 4'd15};
        repeat (2) @(posedge clk);

        // Test 4: 9 * 0 = 0
        ui_in = {4'd9, 4'd0};
        repeat (2) @(posedge clk);

        $stop;
    end
endmodule
