`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2022 16:58:30
// Design Name: 
// Module Name: cevreleyici
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


module cevreleyici(
    input clk, rst
    );

    wire [31:0] buyruk;
    wire [31:0] vb_oku_veri;
    wire [31:0] vb_yaz_veri;
    wire [31:0] vb_adres;
    wire vb_oku_aktif, vb_yaz_aktif;

    wire [31:0] ps;

    islemcib core (
        .clk(clk),
        .rst(rst),
        .buyruk(buyruk),
        .vb_oku_veri(vb_oku_veri),
        .vb_oku_aktif(vb_oku_aktif),
        .vb_yaz_aktif(vb_yaz_aktif),
        .vb_yaz_veri(vb_yaz_veri),
        .vb_adres(vb_adres),
        .ps(ps)
    );

    buyruk_bellegi bb (
        .clk(clk),
        .rst(rst),
        .adres(ps),
        .veri(buyruk)
    );

    veri_bellegi vb (
        .clk(clk),
        .rst(rst),
        .oku_aktif(vb_oku_aktif),
        .yaz_aktif(vb_yaz_aktif),
        .adres(vb_adres),
        .yaz_veri(vb_yaz_veri),
        .oku_veri(vb_oku_veri)
    );
    
endmodule
