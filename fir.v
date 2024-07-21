`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 02:44:27 PM
// Design Name: 
// Module Name: fir
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


module fir(
    input clk,
    input reset,
    input enable_buff,
    input [15:0] i_data,
    output [31:0] o_data
    );
    
    wire signed [15:0] i_data;
    
    reg signed [31:0] o_data;
    
    reg enable_fir;
    
    reg [3:0] buff_count;
    
    wire signed [15:0]  tap0, tap1, tap2, tap3,tap4, tap5, tap6, tap7, tap8, tap9, tap10, tap11, tap12, tap13, tap14;
    
    reg  signed [15:0]  buff0, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14;
    
    reg  signed [31:0]  acc0, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10, acc11, acc12, acc13, acc14;
    
	reg signed [31:0] acc01, acc012, acc23, acc34, acc45, acc56, acc67, acc78, acc89, acc910, acc1011, acc1112, acc1213;
	
    //Cut-off frequency @ 400 kHZ and sampling frequency 1 MSPS
    
    assign tap0 = 16'h0xFC9C;
    assign tap1 = 16'h0x0000;
    assign tap2 = 16'h0x05A5;
    assign tap3 = 16'h0x0000;
    assign tap4 = 16'h0xF40C;
    assign tap5 = 16'h0x0000;
    assign tap6 = 16'h0x282D;
    assign tap7 = 16'h0x4000;
    assign tap8 = 16'h0x282D;
    assign tap9 = 16'h0x0000;
    assign tap10 = 16'h0xF40C;
    assign tap11 = 16'h0x0000;
    assign tap12 = 16'h0x05A5;
    assign tap13 = 16'h0x0000;
    assign tap14 = 16'h0xFC9C;
     
    
    always@(posedge clk or negedge reset)
    begin
        if(reset == 1'b0)
        begin
            buff_count <= 4'd0;
            enable_fir <= 1'b0;
        end
        else 
        begin
            if(enable_buff == 1'b1 && buff_count == 4'd15)
            begin
                buff_count <= 4'd0;
                enable_fir <= 1'b1;
            end
            else if(enable_buff == 1'b1)
            begin
                buff_count <= buff_count + 4'd1;
                enable_fir <= enable_fir;
            end
        end
    end
    
    always@(posedge clk) 
    begin
        if(enable_buff == 1'b1)
        begin
            buff0 <= i_data;
			acc0 <= tap0 * buff0;
			
			buff1 <= buff0; 
			acc1 <= tap1 * buff1;  
			acc01 <= acc0 + acc1;
				 
			buff2 <= buff1; 
			acc2 <= tap2 * buff2;
			acc012 <= acc01 + acc2;
					
			buff3 <= buff2; 
			acc3 <= tap3 * buff3;
			acc23 <= acc012 + acc3;
				 
			buff4 <= buff3; 
			acc4 <= tap4 * buff4;
			acc34 <= acc23 + acc4;
				 
			buff5 <= buff4;
			acc5 <= tap5 * buff5; 
			acc45 <= acc34 + acc5;
				  
			buff6 <= buff5; 
			acc6 <= tap6 * buff6;
			acc56 <= acc45 + acc6;
			   
			buff7 <= buff6; 
			acc7 <= tap7 * buff7;
			acc67 <= acc56 + acc7;
				  
			buff8 <= buff7;
			acc8 <= tap8 * buff8;
			acc78 <= acc67 + acc8;
				   
			buff9 <= buff8; 
			acc9 <= tap9 * buff9;
			acc89 <= acc78 + acc9;
				  
			buff10 <= buff9; 
			acc10 <= tap10 * buff10;
			acc910 <= acc89 + acc10;
				   
			buff11 <= buff10; 
			acc11 <= tap11 * buff11;
			acc1011 <= acc910 + acc11;
				  
			buff12 <= buff11; 
			acc12 <= tap12 * buff12;
			acc1112 <= acc1011 + acc12;
				  
			buff13 <= buff12; 
			acc13 <= tap13 * buff13;
			acc1213 <= acc1112 + acc13;
				  
			buff14 <= buff13; 
			acc14 <= tap14 * buff14;
			o_data <= acc1213 + acc14;
        end
    end
    
endmodule
