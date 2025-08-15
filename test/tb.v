`timescale 1ns / 1ps

module tb;
   initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  reg        clk;
  reg        rst_n;
  reg        ena;
  reg [7:0]  ui_in;
  wire [7:0] uo_out;

  reg  [7:0] uio_in = 8'b0;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  tt_um_vedic_4x4 dut (
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena),
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe)
  );

  always #5 clk = ~clk;

  initial begin
   

    clk = 0;
    ena = 1;
    rst_n = 0;
    ui_in = 8'b0;

    #20 rst_n = 1;

    ui_in = {4'd3, 4'd2};
    #20;

    ui_in = {4'd5, 4'd4};
    #20;

    ui_in = {4'd15, 4'd15};
    #20;

    ui_in = {4'd9, 4'd0};
    #20;

   
  end

endmodule
