`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 12:52:21
// Design Name: 
// Module Name: mul
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


module mul#(parameter  DATA_WIDTH = 32)(
    input clk, reset_n,
    input s_axis_tvalid,s_axis_tvalid_1,
    input [DATA_WIDTH-1:0]s_axis_tdata,s_axis_tdata_1,
    output reg [2*DATA_WIDTH-1:0]m_axis_tdata,
    output reg m_axis_tvalid
    );
    reg [2*DATA_WIDTH-1:0]sum;
    wire [2*DATA_WIDTH-1:0]combadd;
    reg [2*DATA_WIDTH-1:0]mul_o;
    integer sample_count = 0;
    
    always@(posedge(clk))
    begin
        if(!reset_n)begin
            m_axis_tvalid <= 0;
            sample_count  <= 0;
            mul_o         <= 0;
            sum           <= 0;
        end
        else begin
            if(s_axis_tvalid == 1 && s_axis_tvalid_1 == 1)begin
                sample_count   <= sample_count + 1;
                mul_o          <=  $signed(s_axis_tdata) * $signed(s_axis_tdata_1);
                m_axis_tvalid  <= 1;
                m_axis_tdata   <= combadd;
                if((!mul_o[2*DATA_WIDTH-1] && !sum[2*DATA_WIDTH-1]) && combadd[2*DATA_WIDTH-1])begin
                    sum[2*DATA_WIDTH-1]   <= 1'b0;
                    sum[2*DATA_WIDTH-2:0] <= {2*DATA_WIDTH-1{1'b1}};   
                                 
                end
                else if((mul_o[2*DATA_WIDTH-1] && sum[2*DATA_WIDTH-1]) && !combadd[2*DATA_WIDTH-1])begin
                    sum[2*DATA_WIDTH-1]   <= 1'b1;
                    sum[2*DATA_WIDTH-2:0] <= {2*DATA_WIDTH-1{1'b0}};      
                end
                else
                    sum <= combadd;
            end
            else begin
                m_axis_tvalid  <= 0;
            end
            
        end
    end
    
    assign combadd       = sum + mul_o;
//    assign m_axis_tdata  = combadd;
    
endmodule
