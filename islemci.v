`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2022 11:33:49
// Design Name: 
// Module Name: islemci
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


module islemci(
    input clk, rst,
    input [31:0] buyruk,
    output [31:0] ps
    );

    //TODO: output'u reg yapmak yerine _ns ve _r degiskenleri ile en sonunda assign yapmak daha iyi
    //TODO: x0 her zaman 0 olacak
    //TODO: need to implement proper reset

    reg [31:0] yazmac_obegi [7:0];
    reg [31:0] veri_bellek  [127:0];

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
    reg [31:0] mem_d;
    reg [8:0]  mem_address;
    reg        mem_write;


    integer i;
    initial begin
        ps_r      = 32'h0000_0000;
        for(i = 0; i < 128; i = i + 1)
            veri_bellek[i] = 32'b0;

        for(i = 0; i < 8; i = i + 1)
            yazmac_obegi[i] = 32'b0;
    end

    always @(*) begin
        ps_next   = ps_r;
        mem_write = 0;

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
                rd_d    = veri_bellek[(rs1_d + imm_i) >> 2];
                ps_next = ps_r + 4;
            end

            7'b0100011: begin   //SW
                mem_write   = 1'b1;
                mem_address = rs1_d + imm_s;
                mem_d       = rs2_d;
                ps_next     = ps_r + 4;
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
            for(i = 0; i < 128; i = i + 1)
                veri_bellek[i] <= 32'b0;

            for(i = 0; i < 8; i = i + 1)
                yazmac_obegi[i] <= 32'b0;
        end else begin
            ps_r <= ps_next;
            yazmac_obegi[rd] <= rd_d;
            yazmac_obegi[0]  <= 32'b0;
        end

        if(mem_write && !rst)
            veri_bellek[mem_address >> 2] <= mem_d;
    end

    assign ps = ps_next;

endmodule
