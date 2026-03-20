`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Paulo Dietrich
// 
// Create Date: 02/17/2026 02:38:34 PM
// Module Name: Filter
// Project Name: Mini_Trading_Pipeline
// Description: This module implements the filtering strategy 
// 
//////////////////////////////////////////////////////////////////////////////////

import Data_Structures::*;

module Filter(
        input logic clk, rst_n, // Signals
        
        input quote_t in_quote, // Upstream
        output quote_t out_quote // Downstream
    );
    
    // Register variables
    quote_t reg_quote;
    logic [31:0] last_timestamp;
    
    // pipeline stage variables
    quote_t reg_quote_p;
    logic take_r;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            take_r <= 1'b0;
            reg_quote_p <= '0;
        end else begin 
            take_r <= in_quote.valid && (in_quote.timestamp >= last_timestamp);
            reg_quote_p <= in_quote;
        end
    end
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_quote <= '0;
            last_timestamp <= '0;
        end else begin
            if (take_r) begin
                last_timestamp <= reg_quote_p.timestamp;
                reg_quote <= reg_quote_p;
            end else begin
                reg_quote.valid <= 1'b0;
            end
        end
    end
    
    assign out_quote = reg_quote;
    
endmodule
