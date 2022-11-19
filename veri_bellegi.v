`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2022 15:12:46
// Design Name: 
// Module Name: veri_bellegi
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


module veri_bellegi(
    input clk, rst,
    input oku_aktif, yaz_aktif,
    input [31:0] adres,
    input [31:0] yaz_veri,
    output reg [31:0] oku_veri
    );

    reg [31:0] veri_bellek [127:0];
    
    integer i;
    initial begin
        for(i = 0; i < 128; i = i + 1)
            veri_bellek[i] = 32'b0;
    end

    always @(negedge clk) begin
        if(oku_aktif)
            oku_veri <= veri_bellek[adres >> 2];
        else if(yaz_aktif)
            veri_bellek[adres >> 2] <= yaz_veri;
    end

endmodule
