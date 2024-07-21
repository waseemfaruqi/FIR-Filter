`timescale 1ns / 1ps

module tb_fir;

    reg clk, reset, enable_buff;
    reg signed [15:0] i_data;
    wire [31:0] o_data;
    
    /*
     * 100Mhz (10ns) clock 
     */
    always 
    begin
        clk = 1; #5;
        clk = 0; #5;
    end
    
    initial begin
        reset = 1; #20;
        reset = 0; #50;
        reset = 1; #1000000;
    end
    
    initial begin
        enable_buff = 0; #100;
        enable_buff = 1; #1000;
    end
        
    /* Instantiate FIR module to test. */
    fir fir_i(
        .clk(clk),
        .reset(reset),
        .enable_buff(enable_buff),
        .i_data(i_data),   
        .o_data(o_data));  
    
    reg [4:0] state_reg;
    reg [3:0] cntr;
    
    parameter wvfm_period = 4'd4;
    
    parameter init               = 5'd0;
    parameter sendSample0        = 5'd1;
    parameter sendSample1        = 5'd2;
    parameter sendSample2        = 5'd3;
    parameter sendSample3        = 5'd4;
    parameter sendSample4        = 5'd5;
    parameter sendSample5        = 5'd6;
    parameter sendSample6        = 5'd7;
    parameter sendSample7        = 5'd8;
    
    /* This state machine generates a 200kHz sinusoid. */
    always @ (posedge clk or negedge reset)
        begin
            if (reset == 1'b0)
                begin
                    cntr      <= 4'd0;
                    i_data    <= 16'd0;
                    state_reg <= init;
                end
            else
                begin
                    case (state_reg)
                        init : //0
                            begin
                                cntr <= 4'd0;
                                i_data <= 16'h0000;
                                state_reg <= sendSample0;
                            end
                            
                        sendSample0 : //1
                            begin
                                i_data <= 16'h0000;
                                
                                if (cntr == wvfm_period)
                                    begin
                                        cntr <= 4'd0;
                                        state_reg <= sendSample1;
                                    end
                                else
                                    begin 
                                        cntr <= cntr + 1;
                                        state_reg <= sendSample0;
                                    end
                            end 
                        
                        sendSample1 : //2
                            begin
                                i_data <= 16'h5A7E; 
                                
                                if (cntr == wvfm_period)
                                    begin
                                        cntr <= 4'd0;
                                        state_reg <= sendSample2;
                                    end
                                else
                                    begin 
                                        cntr <= cntr + 1;
                                        state_reg <= sendSample1;
                                    end
                            end 
                        
                        sendSample2 : //3
                            begin
                                i_data <= 16'h7FFF;
                                
                                if (cntr == wvfm_period)
                                    begin
                                        cntr <= 4'd0;
                                        state_reg <= sendSample3;
                                    end
                                else
                                    begin 
                                        cntr <= cntr + 1;
                                        state_reg <= sendSample2;
                                    end
                            end 
                        
                        sendSample3 : //4
                            begin
                                i_data <= 16'h5A7E;
                                
                                if (cntr == wvfm_period)
                                    begin
                                        cntr <= 4'd0;
                                        state_reg <= sendSample4;
                                    end
                                else
                                    begin 
                                        cntr <= cntr + 1;
                                        state_reg <= sendSample3;
                                    end
                            end 
                        
                        sendSample4 : //5
                            begin
                                i_data <= 16'h0000;
                                
                                if (cntr == wvfm_period)
                                    begin
                                        cntr <= 4'd0;
                                        state_reg <= sendSample5;
                                    end
                                else
                                    begin 
                                        cntr <= cntr + 1;
                                        state_reg <= sendSample4;
                                    end
                            end 
                        
                        sendSample5 : //6
                            begin
                                i_data <= 16'hA582; 
                                
                                if (cntr == wvfm_period)
                                    begin
                                        cntr <= 4'd0;
                                        state_reg <= sendSample6;
                                    end
                                else
                                    begin 
                                        cntr <= cntr + 1;
                                        state_reg <= sendSample5;
                                    end
                            end 
                        
                        sendSample6 : //6
                            begin
                                i_data <= 16'h8000; 
                                
                                if (cntr == wvfm_period)
                                    begin
                                        cntr <= 4'd0;
                                        state_reg <= sendSample7;
                                    end
                                else
                                    begin 
                                        cntr <= cntr + 1;
                                        state_reg <= sendSample6;
                                    end
                            end 
                        
                        sendSample7 : //6
                            begin
                                i_data <= 16'hA582; 
                                
                                if (cntr == wvfm_period)
                                    begin
                                        cntr <= 4'd0;
                                        state_reg <= sendSample0;
                                    end
                                else
                                    begin 
                                        cntr <= cntr + 1;
                                        state_reg <= sendSample7;
                                    end
                            end                     
                    
                    endcase
                end
        end
    
endmodule
