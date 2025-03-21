`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 11:29:55
// Design Name: 
// Module Name: delay_module
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


module delay_module#(parameter DATA_WIDTH = 32)(
    input clk,reset_n,
    input s_axis_tvalid,
    input [DATA_WIDTH-1:0]s_axis_tdata,
    output reg m_axis_tvalid,
    output reg [DATA_WIDTH-1:0]m_axis_tdata
    );
    
    reg [DATA_WIDTH-1:0]m_axis_tdata_1,m_axis_tdata_2;
    reg m_axis_tvalid_1,m_axis_tvalid_2;
    
    always@(posedge(clk))
    begin
        if(!reset_n)begin
            m_axis_tvalid    =  0;
            m_axis_tvalid_1  =  0;
            m_axis_tvalid_2  =  0;
            m_axis_tdata     =  0;
            m_axis_tdata_1   =  0;
            m_axis_tdata_2   =  0;
        end
        else begin
            m_axis_tvalid_1   <= s_axis_tvalid;
            m_axis_tvalid_2   <= m_axis_tvalid_1;
            m_axis_tvalid     <= m_axis_tvalid_2;
            m_axis_tdata_1    <= s_axis_tdata;
            m_axis_tdata_2    <= m_axis_tdata_1;
            m_axis_tdata      <= m_axis_tdata_2;     
        end
    end
endmodule
