`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2022 15:13:31
// Design Name: 
// Module Name: islemcib
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


module islemcib(
    input clk, rst,
    input [31:0] buyruk,
    input [31:0] vb_oku_veri,
    output reg vb_oku_aktif, vb_yaz_aktif,
    output reg [31:0] vb_yaz_veri,
    output reg [31:0] vb_adres,
    output [31:0] ps
    );


    reg [31:0] yazmac_obegi [7:0];

    wire [6:0] op_code = buyruk[6:0];
    wire [2:0] funct_3 = buyruk[14:12];
    wire [6:0] funct_7 = buyruk[31:25];
    wire [4:0] rd      = buyruk[11:7];
    wire [4:0] rs1     = buyruk[19:15];
    wire [4:0] rs2     = buyruk[24:20];

    wire [31:0] imm_i  = {{21{buyruk[31]}}, buyruk[30:25], buyruk[24:21], buyruk[20]};
    wire [31:0] imm_s  = {{21{buyruk[31]}}, buyruk[30:25], buyruk[11:8], buyruk[7]};
    wire [31:0] imm_b  = {{20{buyruk[31]}}, buyruk[7], buyruk[30:25], buyruk[11:8], 1'b0};
    wire [31:0] imm_u  = {buyruk[31], buyruk[30:20], buyruk[19:12], 12'b0};
    wire [31:0] imm_j  = {{12{buyruk[31]}}, buyruk[19:12], buyruk[20], buyruk[30:25], buyruk[24:21], 1'b0};

    wire [31:0] rs1_d  = yazmac_obegi[rs1];
    wire [31:0] rs2_d  = yazmac_obegi[rs2];

    reg [31:0] ps_r;
    reg [31:0] ps_next;
    reg [31:0] rd_d;

    integer i;
    initial begin
        ps_r = 32'h0000_0000;

        for(i = 0; i < 8; i = i + 1)
            yazmac_obegi[i] = 32'b0;
    end

    always @(*) begin
        ps_next      = ps_r;
        vb_yaz_aktif = 0;
        vb_oku_aktif = 0;

        case (op_code)
            7'b0110111: begin   //LUI
                rd_d    = imm_u;
                ps_next = ps_r + 4;
            end

            7'b0010111: begin   //AUIPC
                rd_d    = ps_r + imm_u; 
                ps_next = ps_r + 4;
            end

            7'b1101111: begin   //JAL
                rd_d    = ps_r + 4;
                ps_next = ps_r + imm_j;
            end

            7'b1100111: begin   //JALR
                rd_d    = ps_r + 4;
                ps_next = (rs1_d + imm_i) & 32'hFFFFFFFE;
            end

            7'b1100011: begin   //BEQ & BNE & BLT
                //--------------------------------------------------------
                case (funct_3)
                    3'b000: begin   //BEQ
                        ps_next = rs1_d == rs2_d ? ps_r + imm_b : ps_r + 4;
                    end
                    3'b001: begin   //BNE
                        ps_next = rs1_d != rs2_d ? ps_r + imm_b : ps_r + 4;
                    end
                    3'b100: begin   //BLT
                        ps_next = $signed(rs1_d) < $signed(rs2_d) ? ps_r + imm_b : ps_r + 4; 
                    end
                endcase
                //--------------------------------------------------------
            end

            7'b0000011: begin   //LW
                vb_oku_aktif = 1'b1;
                vb_adres     = rs1_d + imm_i;
                rd_d         = vb_oku_veri;
                ps_next      = ps_r + 4;
            end

            7'b0100011: begin   //SW
                vb_yaz_aktif = 1'b1;
                vb_yaz_veri  = rs2_d;
                vb_adres     = rs1_d + imm_s;
                ps_next      = ps_r + 4;
            end

            7'b0010011: begin   //ADDI
                rd_d    = rs1_d + imm_i;
                ps_next = ps_r + 4;
            end

            7'b0110011: begin   //ADD & SUB & OR & AND & XOR
                //--------------------------------------------------------
                case ({funct_7, funct_3})
                    10'b0000000000: begin   //ADD
                        rd_d    = rs1_d + rs2_d;
                        ps_next = ps_r + 4;
                    end
                    10'b0100000000: begin   //SUB
                        rd_d    = rs1_d - rs2_d;
                        ps_next = ps_r + 4;
                    end
                    10'b0000000110: begin   //OR
                        rd_d    = rs1_d | rs2_d;
                        ps_next = ps_r + 4;
                    end
                    10'b0000000111: begin   //AND
                        rd_d    = rs1_d & rs2_d;
                        ps_next = ps_r + 4;
                    end
                    10'b0000000100: begin   //XOR
                        rd_d    = rs1_d ^ rs2_d;
                        ps_next = ps_r + 4;
                    end
                endcase
                //--------------------------------------------------------
            end
        endcase
    end

    always @(posedge clk) begin
        if(rst) begin
            ps_r <= 32'h0000_0000;

            for(i = 0; i < 8; i = i + 1)
                yazmac_obegi[i] <= 32'b0;

        end else begin
            ps_r <= ps_next;

            if(vb_oku_aktif)
                yazmac_obegi[rd] <= vb_oku_veri;
            else 
                yazmac_obegi[rd] <= rd_d;

            yazmac_obegi[0]  <= 32'b0;
        end
    end

    assign ps = ps_next;

endmodule

