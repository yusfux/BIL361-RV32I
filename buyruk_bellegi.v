`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2022 15:12:21
// Design Name: 
// Module Name: buyruk_bellegi
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


module buyruk_bellegi(
    input clk, rst,
    input [31:0] adres,
    output reg [31:0] veri
    );

    reg [31:0] buyruk_bellek [127:0];

    always @(posedge clk) begin
        veri <= buyruk_bellek[adres >> 2];
    end

endmodule
