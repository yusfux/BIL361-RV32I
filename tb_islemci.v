`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2022 22:38:38
// Design Name: 
// Module Name: tb_islemci
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//`define ARITHMETIC
//`define BRANCH
`define DEBUG
//define BONUS
module tb_islemci(
    );

    reg [31:0] buyruk_bellek [127:0];
    initial begin
        `ifdef ARITHMETIC
            buyruk_bellek[0] = 32'h01430313;    //ADDI x6, x6, 20   x6 = 20;
            buyruk_bellek[1] = 32'hff628293;    //ADDI x5, x5, 10   x5 = -10;
            buyruk_bellek[2] = 32'h006283b3;    //ADD  x7, x5, x6   x7 = 10;
            buyruk_bellek[3] = 32'h40638233;    //SUB  x4, x7, x6   x4 = -10;
            buyruk_bellek[4] = 32'h0062e1b3;    //OR   x3, x5, x6   x3 = -10; I hope,
            buyruk_bellek[5] = 32'h0062f133;    //AND  x2, x5, x6   x2 = 20;  again, I hope,
            buyruk_bellek[6] = 32'h0062c0b3;    //XOR  x1, x5, x6   x1 = -30; I believe this time,
            buyruk_bellek[7] = 32'h40128033;    //SUB  x0, x5, x1   x0 = 20;
            buyruk_bellek[8] = 32'h00112223;    //SW   x1, 4,  x2   mem[4 + 20] = x1(-30);
            buyruk_bellek[9] = 32'h00412283;    //LW   x5, 4,  x2   x5 = mem[4 + 20](-30);
        `elsif BRANCH
            buyruk_bellek[0] = 32'h00000013;    //ADDI x0, x0, 0    x0 = 0;
            buyruk_bellek[1] = 32'h00508093;    //ADDI x1, x1, 5    x1 = 5;
            buyruk_bellek[2] = 32'h00100663;    //BEQ  x0, x1, 12   if x1 != x0, inc x0
            buyruk_bellek[3] = 32'h00100013;    //ADDI x0, x0, 1    inc x0;
            buyruk_bellek[4] = 32'hff9ff2ef;    //JAL  x5, -8       jump to BEQ, x1 = program_counter + 4;
            buyruk_bellek[5] = 32'h00500013;    //ADDI x0, x0, 5    x0 = 10;
            buyruk_bellek[6] = 32'h00108093;    //ADDI x1, x1, 1    inc x1;
            buyruk_bellek[7] = 32'hfe009ee3;    //BNE  x1, x0, -4   jump to previous ADDI

            buyruk_bellek[8] = 32'hfffff3b7;    //LUI  x7, -1       x7 = -4096;
            buyruk_bellek[9] = 32'hfffd8317;    //AUIPC x6, -40     x6 = -163804;
            buyruk_bellek[10] = 32'hff608093;   //ADDI x1, x1, -10  x1 = 0;
            buyruk_bellek[11] = 32'h00008067;   //JALR x0, x1, 0    x0 = program_counter + 4; jump to x1 + 0 (0)
        `elsif DEBUG
            buyruk_bellek[0] = 32'h01430313;    //ADDI x6, x6, 20    x6 = 20;
            buyruk_bellek[1] = 32'hff628293;    //ADDI x5, x5, -10   x5 = -10;
            buyruk_bellek[2] = 32'h006283b3;    //ADD  x7, x5, x6    x7 = 10;
            buyruk_bellek[3] = 32'h406280b3;    //SUB  x1, x5, x6    x1 = -30;
            buyruk_bellek[4] = 32'h40530133;    //SUB  x2, x6, x5    x2 = 30;
            buyruk_bellek[5] = 32'h00508093;    //ADDI x1, x1, 5     x1 = -25;
            buyruk_bellek[6] = 32'hfe50cee3;    //BLT  x1, x5, -4    jump to previous ADDI until x1 >= x2
            buyruk_bellek[7] = 32'h00508093;    //ADDI x1, x1, 5     x1 = -5;
            buyruk_bellek[8] = 32'h01428013;    //ADDI x0, x5, 20    x0 shoudln't change
        `elsif BONUS
            uut.veri_bellek[0] = 32'd2 ;
            uut.veri_bellek[1] = 32'd4 ;
            uut.veri_bellek[2] = 32'd6 ;
            uut.veri_bellek[3] = 32'd8 ;
            uut.veri_bellek[4] = 32'd10;
            uut.veri_bellek[5] = 32'd20;
            uut.veri_bellek[6] = 32'd30;
            uut.veri_bellek[7] = 32'd40;
            uut.veri_bellek[8] = 32'd50;
            uut.veri_bellek[9] = 32'd60;
        
            buyruk_bellek[0] = 32'h00002083;    //LW x1, 0, x0
            buyruk_bellek[1] = 32'h00402103;    //LW x2, 4, x0
            buyruk_bellek[2] = 32'h00802183;    //LW x3, 8, x0
            buyruk_bellek[3] = 32'h00c02203;    //LW x4, 12, x0
            buyruk_bellek[4] = 32'h01002283;    //LW x5, 16, x0
            buyruk_bellek[5] = 32'h00208333;    //ADD x6, x1, x2
            buyruk_bellek[6] = 32'h00330333;    //ADD x6, x6, x3
            buyruk_bellek[7] = 32'h00430333;    //ADD x6, x6, x4
            buyruk_bellek[8] = 32'h00530333;    //ADD x6, x6, x5

            buyruk_bellek[9]  = 32'h01402083;    //LW x1, 20, x0
            buyruk_bellek[10] = 32'h01802103;    //LW x2, 24, x0
            buyruk_bellek[11] = 32'h01c02183;    //LW x3, 28, x0
            buyruk_bellek[12] = 32'h02002203;    //LW x4, 22, x0
            buyruk_bellek[13] = 32'h02402283;    //LW x5, 36, x0
            buyruk_bellek[14] = 32'h002083b3;    //ADD x7, x1, x2
            buyruk_bellek[15] = 32'h003383b3;    //ADD x7, x7, x3
            buyruk_bellek[16] = 32'h004383b3;    //ADD x7, x7, x4
            buyruk_bellek[17] = 32'h005383b3;    //ADD x7, x7, x5

            buyruk_bellek[18] = 32'h406380b3;    //SUB x1, x7, x6
            buyruk_bellek[19] = 32'h1e102e23;    //SW x1, 508, x0
        `endif
    end
    

    
    wire [31:0]ps;
    reg clk, rst;
    
    reg [31:0] bellek_r;
    always @(posedge clk) begin
        bellek_r <= buyruk_bellek[ps >> 2];
    end

    islemci uut (
        .clk(clk),
        .rst(rst),
        .buyruk(bellek_r),
        .ps(ps)
    );

    initial clk = 0;
    initial rst = 0;
    always begin
        clk = ~clk;
        #5;
    end

endmodule
