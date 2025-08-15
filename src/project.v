module tt_um_vedic_4x4 (
    input  [7:0] ui_in,    // ui_in[3:0] = a, ui_in[7:4] = b
    output [7:0] uo_out,   // r = a × b
    input  [7:0] uio_in,   // unused
    output [7:0] uio_out,  // unused
    output [7:0] uio_oe,   // unused
    input clk,             // unused
    input rst_n,           // unused
    input ena            // unused
  
);

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;
  
    wire [3:0] a = ui_in[3:0];
    wire [3:0] b = ui_in[7:4];
    wire [7:0] r;

    vedic4 v4 (
        .a(a),
        .b(b),
        .r(r)
    );

    assign uo_out = r;

endmodule


module vedic4 (
    input [3:0] a,
    input [3:0] b,
    output [7:0] r
);
    wire [3:0] p0, p1, p2, p3;
    wire [7:0] temp1, temp2, temp3;

    vedic2 v0 (a[1:0], b[1:0], p0);
    vedic2 v1 (a[3:2], b[1:0], p1);
    vedic2 v2 (a[1:0], b[3:2], p2);
    vedic2 v3 (a[3:2], b[3:2], p3);

    assign temp1 = {4'b0000, p1} << 2;
    assign temp2 = {4'b0000, p2} << 2;
    assign temp3 = {p3, 4'b0000};

    assign r = p0 + temp1 + temp2 + temp3;
endmodule


module vedic2 (
    input [1:0] a,
    input [1:0] b,
    output [3:0] r
);
    wire p0, p1, p2, p3;
    wire s1, c1, s2, c2;

    assign p0 = a[0] & b[0];
    assign p1 = a[1] & b[0];
    assign p2 = a[0] & b[1];
    assign p3 = a[1] & b[1];

    assign s1 = p1 ^ p2;
    assign c1 = p1 & p2;
    assign s2 = p3 ^ c1;
    assign c2 = p3 & c1;

    assign r[0] = p0;
    assign r[1] = s1;
    assign r[2] = s2;
    assign r[3] = c2;
endmodule
