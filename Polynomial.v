`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-2.8.20240817
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            MultiFields &Group
// All rights reserved     
// File name:              
// Last modified Date:     2024/08/27 13:49:34
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:              ShaoKang Shan
// Created date:           2024/08/27 13:49:34
// mail      :             981494860fun@gmail.com
// Version:                V1.0
// TEXT NAME:              Polynomial.v
// PATH:                   E:\work\diamond\fix_floating\Polynomial.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Polynomial (
    input             clk_in,
    input             rst_n,
    input      [31:0] Data_x_s,
    input             Data_Begin,
    output reg [31:0] Data_y
);
    wire clk;
    My_pll my_pll (
        .CLKI (clk_in),
        .CLKOP(clk)
    );

    reg  [31:0] input_a_1;
    reg         input_a_stb_1;
    reg  [31:0] input_b_1;
    reg         input_b_stb_1;
    wire [31:0] output_z_1;
    wire        output_z_stb_1;

    reg  [31:0] input_a_2;
    reg         input_a_stb_2;
    reg  [31:0] input_b_2;
    reg         input_b_stb_2;
    wire [31:0] output_z_2;
    wire        output_z_stb_2;

    reg  [31:0] input_a_A_1;
    reg         input_a_stb_A_1;
    reg  [31:0] input_b_A_1;
    reg         input_b_stb_A_1;
    wire [31:0] output_z_A_1;
    wire        output_z_stb_A_1;

    reg  [31:0] input_a_A_2;
    reg         input_a_stb_A_2;
    reg  [31:0] input_b_A_2;
    reg         input_b_stb_A_2;
    wire [31:0] output_z_A_2;
    wire        output_z_stb_A_2;

    reg  [31:0] input_a_A_3;
    reg         input_a_stb_A_3;
    reg  [31:0] input_b_A_3;
    reg         input_b_stb_A_3;
    wire [31:0] output_z_A_3;
    wire        output_z_stb_A_3;

    reg  [31:0] input_a_A_4;
    reg         input_a_stb_A_4;
    reg  [31:0] input_b_A_4;
    reg         input_b_stb_A_4;
    wire [31:0] output_z_A_4;
    wire        output_z_stb_A_4;


    reg  [ 7:0] param_2;
    reg  [31:0] Data_X_X2;
    reg         A_X_X2_sig;



    reg  [ 7:0] param_1;
    reg  [31:0] Data_x;  //x
    reg  [31:0] Data_x2;  //x^2
    reg  [31:0] Data_x3;  //x^3
    reg  [31:0] Data_x4;  //x^4
    reg  [31:0] Data_x5;  //x^5

    reg         X_Sig;
    reg         X2_Sig;
    reg         X3_Sig;
    reg         X4_Sig;
    reg         X5_Sig;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Data_x <= 32'd0;
            input_a_1 <= 32'b0;
            input_a_stb_1 <= 1'b0;
            input_b_stb_1 <= 1'b0;
            input_a_stb_2 <= 1'b0;
            input_b_stb_2 <= 1'b0;
            X2_Sig <= 1'b0;
            X3_Sig <= 1'b0;
            X4_Sig <= 1'b0;
            X5_Sig <= 1'b0;
            Data_x2 <= 32'd0;
            Data_x3 <= 32'd0;
            param_1 <= 8'd0;
        end else begin
            case (param_1)

                8'd0: begin  //得到x^2
                    if (Data_Begin) begin
                        Data_x <= Data_x_s;
                        input_a_1 <= Data_x_s;
                        input_a_stb_1 <= 1'b1;
                        input_b_1 <= Data_x_s;
                        input_b_stb_1 <= 1'b1;
                        param_1 <= param_1 + 8'd1;
                    end else begin
                        param_1 <= 8'd0;
                    end
                end

                8'd1: begin
                    input_a_stb_1 <= 1'b0;
                    input_b_stb_1 <= 1'b0;
                    if (output_z_stb_1 == 1'b1) begin
                        Data_x2 <= output_z_1;  //x^2
                        X2_Sig  <= 1'b1;
                        param_1 <= 8'd2;
                    end else begin
                        param_1 <= 8'd1;
                    end

                end

                8'd2: begin
                    X2_Sig <= 1'b0;

                    input_a_1 <= Data_x2;
                    input_a_stb_1 <= 1'b1;
                    input_b_1 <= Data_x;
                    input_b_stb_1 <= 1'b1;  //x^3

                    input_a_2 <= Data_x2;
                    input_a_stb_2 <= 1'b1;
                    input_b_2 <= Data_x2;
                    input_b_stb_2 <= 1'b1;  //x^4
                    param_1 <= 8'd3;
                end

                8'd3: begin
                    input_a_stb_1 <= 1'b0;
                    input_b_stb_1 <= 1'b0;
                    input_a_stb_2 <= 1'b0;
                    input_b_stb_2 <= 1'b0;
                    if (output_z_stb_2 && output_z_stb_1) begin
                        Data_x3 <= output_z_1;
                        Data_x4 <= output_z_2;
                        param_1 <= 8'd6;

                        X3_Sig  <= 1'b1;
                        X4_Sig  <= 1'b1;
                    end else if (output_z_stb_1) begin
                        Data_x3 <= output_z_1;
                        X3_Sig  <= 1'b1;
                        param_1 <= 8'd4;
                    end else if (output_z_stb_2) begin
                        Data_x4 <= output_z_2;
                        param_1 <= 8'd5;
                        X4_Sig  <= 1'b1;
                    end else begin
                        param_1 <= 8'd3;
                    end

                end
                8'd4: begin
                    if (output_z_stb_2) begin
                        Data_x4 <= output_z_2;
                         X4_Sig  <= 1'b1;
                        param_1 <= 8'd6;
                    end else begin
                        param_1 <= 8'd4;
                    end
                end
                8'd5: begin
                    if (output_z_stb_1) begin
                        Data_x3 <= output_z_1;
                        X3_Sig  <= 1'b1;
                        param_1<=8'd6;
                    end else begin
                        param_1<=8'd5;
                    end
                end
                8'd6: begin  //X^5
                    X3_Sig <= 1'b0;
                    X4_Sig <= 1'b0;

                    input_a_stb_1 <= 1'b1;
                    input_a_1 <= Data_x2;
                    input_b_stb_1 <= 1'b1;
                    input_b_1 <= Data_x3;
                    param_1 <= 8'd7;
                end

                8'd7: begin
                    input_a_stb_1 <= 1'b0;
                    input_b_stb_1 <= 1'b0;
                    if (output_z_stb_1) begin
                        Data_x5 <= output_z_1;
                        X5_Sig  <= 1'b1;
                        param_1 <= param_1 + 8'd1;
                    end else begin
                        param_1 <= 8'd7;
                    end

                end

                default: begin
                    X5_Sig  <= 1'b0;
                    param_1 <= 8'd0;
                end

            endcase
        end
    end
    multiplier u1_multiplier (
        .clk(clk),
        .rst(rst_n),
        .input_a(input_a_1),
        .input_a_stb                        (input_a_stb_1             ),// 输入a数据可用，两个本模块时钟周期就可以
        .input_b(input_b_1),
        .input_b_stb                        (input_b_stb_1             ),// 输入b数据可用，两个本模块时钟周期就可以
        .output_z(output_z_1),
        .output_z_stb(output_z_stb_1)  // 输出z可用
    );
    multiplier u2_multiplier (
        .clk(clk),
        .rst(rst_n),
        .input_a(input_a_2),
        .input_a_stb                        (input_a_stb_2             ),// 输入a数据可用，两个本模块时钟周期就可以
        .input_b(input_b_2),
        .input_b_stb                        (input_b_stb_2               ),// 输入b数据可用，两个本模块时钟周期就可以
        .output_z(output_z_2),
        .output_z_stb(output_z_stb_2)  // 输出z可用
    );


    always @(posedge clk or negedge rst_n) begin  //求x1+x2
        if (!rst_n) begin
            input_a_stb_A_1 <= 1'b0;
            input_b_stb_A_1 <= 1'b0;
            param_2 <= 8'd0;
            A_X_X2_sig <= 1'b0;
            Data_X_X2 <= 32'd0;
        end else begin
            case (param_2)

                8'd0: begin
                    if (X2_Sig) begin
                        input_a_A_1 <= Data_x2;
                        input_a_stb_A_1 <= 1'b1;
                        input_b_stb_A_1 <= 1'b1;
                        input_b_A_1 <= Data_x;
                        param_2 <= param_2 + 8'd1;
                    end else begin
                        input_a_stb_A_1 <= 1'b0;
                        input_b_stb_A_1 <= 1'b0;
                        param_2 <= 8'd0;
                    end
                end

                8'd1: begin
                    input_a_stb_A_1 <= 1'b0;
                    input_b_stb_A_1 <= 1'b0;

                    if (output_z_A_1) begin
                        A_X_X2_sig <= 1'b1;
                        Data_X_X2 <= output_z_A_1;
                        param_2 <= param_2 + 8'd1;
                    end else begin
                        param_2 <= 8'd1;
                    end
                end

                default: begin
                    param_2 <= 8'd0;
                    A_X_X2_sig <= 1'b0;
                end
            endcase
        end
    end

    reg [7:0] param_3;
    reg [31:0] Data_X3_X4;
    reg A_X3_X4_sig;
    always @(posedge clk or negedge rst_n) begin  //求x3+x4
        if (!rst_n) begin
            input_a_stb_A_2 <= 1'b0;
            input_b_stb_A_2 <= 1'b0;
            param_3 <= 8'd0;
            A_X3_X4_sig <= 1'b0;
            Data_X3_X4 <= 32'd0;
        end else begin
            case (param_3)

                8'd0: begin
                    if (X3_Sig && X4_Sig) begin
                        input_a_A_2 <= Data_x3;
                        input_a_stb_A_2 <= 1'b1;
                        input_b_A_2 <= Data_x4;
                        input_b_stb_A_2 <= 1'b1;
                        param_3 <= param_3 + 8'd1;
                    end else begin
                        param_3 <= 8'd0;
                    end
                end

                8'd1: begin
                    input_a_stb_A_2 <= 1'b0;
                    input_b_stb_A_2 <= 1'b0;

                    if (output_z_stb_A_2) begin
                        Data_X3_X4 <= output_z_A_2;
                        A_X3_X4_sig <= 1'b1;
                        param_3 <= param_3 + 8'd1;
                    end else begin
                        param_3 <= 8'd1;
                    end
                end
                default: begin
                    param_3 <= 8'd0;
                    A_X3_X4_sig <= 1'b0;
                end
            endcase
        end
    end
    reg [7:0] param_4;
    reg [31:0] A_Data_X_X2;
    reg [31:0] A_Data_X3_X4;
    reg [31:0] A_D_x_x2_x3_x4;
    reg A_D_x_x2_x3_x4_sig;
    always @(posedge clk or negedge rst_n) begin  //求x+x2+x3+x4
        if (!rst_n) begin
            A_Data_X_X2 <= 32'd0;
            param_4 <= 8'd0;
            A_Data_X3_X4 <= 32'd0;
            input_a_stb_A_3 <= 1'b0;
            input_b_stb_A_3 <= 1'b0;
            A_D_x_x2_x3_x4 <= 32'd0;
            param_4 <= 8'd0;
        end else begin
            case (param_4)

                8'd0: begin
                    if (A_X_X2_sig) begin
                        A_Data_X_X2 <= Data_X_X2;
                        param_4 <= param_4 + 8'd1;
                    end else begin
                        param_4 <= 8'd0;
                    end
                end

                8'd1: begin
                    if (A_X3_X4_sig) begin
                        A_Data_X3_X4 <= Data_X3_X4;
                        param_4 <= param_4 + 8'd1;
                    end else begin
                        param_4 <= 8'd1;
                    end
                end

                8'd2: begin
                    input_a_A_3 <= A_Data_X_X2;
                    input_b_A_3 <= A_Data_X3_X4;
                    input_a_stb_A_3 <= 1'b1;
                    input_b_stb_A_3 <= 1'b1;
                    param_4 <= param_4 + 8'd1;
                end

                8'd3: begin
                    input_a_stb_A_3 <= 1'b0;
                    input_b_stb_A_3 <= 1'b0;
                    if (output_z_stb_A_3) begin
                        A_D_x_x2_x3_x4 <= output_z_A_3;
                        A_D_x_x2_x3_x4_sig <= 1'b1;
                        param_4 <= param_4 + 8'd1;
                    end
                end

                default: begin
                    A_D_x_x2_x3_x4_sig <= 1'b0;
                    param_4 <= 8'd0;
                end

            endcase
        end
    end
    reg [31:0] A_D_X5;
    reg [31:0] A_DT_x_x2_x3_x4;
    reg A_X5_sig;

    reg [7:0] param_5;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            A_D_X5 <= 32'd0;
            param_5 <= 8'd0;
            A_DT_x_x2_x3_x4 <= 32'd0;
            input_a_stb_A_4 <= 1'b0;
            input_b_stb_A_4 <= 1'b0;
            Data_y <= 32'd0;
        end else begin

            case (param_5)

                8'd0: begin
                    if (X5_Sig) begin
                        A_D_X5  <= Data_x5;
                        param_5 <= 8'd1;
                    end else if (A_D_x_x2_x3_x4_sig) begin
                        A_DT_x_x2_x3_x4 <= A_D_x_x2_x3_x4;
                        param_5 <= 8'd2;
                    end else begin
                        param_5 <= 8'd0;
                    end
                end

                8'd1: begin
                    if (A_D_x_x2_x3_x4_sig) begin
                        A_DT_x_x2_x3_x4 <= A_D_x_x2_x3_x4;
                        param_5 <= 8'd3;
                    end else begin
                        param_5 <= 8'd1;
                    end
                end

                8'd2: begin
                    if (X5_Sig) begin
                        A_D_X5  <= Data_x5;
                        param_5 <= 8'd3;
                    end else begin
                        param_5 <= 8'd2;
                    end

                end

                8'd3: begin
                    input_a_A_4 <= A_D_X5;
                    input_a_stb_A_4 <= 1'b1;
                    input_b_A_4 <= A_DT_x_x2_x3_x4;
                    input_b_stb_A_4 <= 1'b1;
                    param_5 <= 8'd4;
                end

                8'd4: begin
                    input_a_stb_A_4 <= 1'b0;
                    input_b_stb_A_4 <= 1'b0;

                    if (output_z_stb_A_4) begin
                        Data_y  <= output_z_A_4;
                        param_5 <= 8'd5;
                    end else begin
                        param_5 <= 8'd4;
                    end
                end
                default: begin
                    param_5 <= 8'd0;
                end
            endcase
        end
    end

    adder u1_adder (
        .clk(clk),
        .rst(rst_n),
        .input_a(input_a_A_1),
        .input_a_stb                        (input_a_stb_A_1               ), // 输入a数据可用，两个本模块时钟周期就可以
        .input_b(input_b_A_1),
        .input_b_stb                        (input_b_stb_A_1               ), // 输入b数据可用，两个本模块时钟周期就可以
        .output_z(output_z_A_1),
        .output_z_stb(output_z_stb_A_1)  // 输出z可用
    );
    adder u2_adder (
        .clk(clk),
        .rst(rst_n),
        .input_a(input_a_A_2),
        .input_a_stb                        (input_a_stb_A_2               ), // 输入a数据可用，两个本模块时钟周期就可以
        .input_b(input_b_A_2),
        .input_b_stb                        (input_b_stb_A_2               ), // 输入b数据可用，两个本模块时钟周期就可以
        .output_z(output_z_A_2),
        .output_z_stb(output_z_stb_A_2)  // 输出z可用
    );



    adder u3_adder (
        .clk(clk),
        .rst(rst_n),
        .input_a(input_a_A_3),
        .input_a_stb                        (input_a_stb_A_3              ), // 输入a数据可用，两个本模块时钟周期就可以
        .input_b(input_b_A_3),
        .input_b_stb                        (input_b_stb_A_3               ), // 输入b数据可用，两个本模块时钟周期就可以
        .output_z(output_z_A_3),
        .output_z_stb(output_z_stb_A_3)  // 输出z可用
    );

    adder u4_adder (
        .clk(clk),
        .rst(rst_n),
        .input_a(input_a_A_4),
        .input_a_stb                        (input_a_stb_A_4              ), // 输入a数据可用，两个本模块时钟周期就可以
        .input_b(input_b_A_4),
        .input_b_stb                        (input_b_stb_A_4               ), // 输入b数据可用，两个本模块时钟周期就可以
        .output_z(output_z_A_4),
        .output_z_stb(output_z_stb_A_4)  // 输出z可用
    );
endmodule
