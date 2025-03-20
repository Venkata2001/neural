`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 19:29:11
// Design Name: 
// Module Name: weight_memory
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


module weight_memory #(parameter DATA_WIDTH = 16, NO_OF_WEIGHT = 784, ADDRS_WIDTH = $clog2(NO_OF_WEIGHT))(
    input clk,reset_n,
    input s_axis_tvalid,
    output reg m_axis_tvalid,
    output wire [DATA_WIDTH-1:0]m_axis_tdata
    );
    
    reg [ADDRS_WIDTH-1:0]addr = 0;
    reg ena = 0;
    wire [DATA_WIDTH-1:0]data_o;
    
    blk_mem_gen_0 weight_bram (
        .clka(clk),    // input wire clka
        .ena(ena),      // input wire ena
        .addra(addr),  // input wire [9 : 0] addra
        .douta(data_o)  // output wire [31 : 0] douta
        );
    integer sample_count =0;
    
    always@(posedge(clk))
    begin
        if(!reset_n)
        begin
            m_axis_tvalid <= 0;
//            m_axis_tdata  <= {DATA_WIDTH-1{1'b0}};
            addr          <= 0;
            ena           <= 0;            
            sample_count  <= 0;            
        end
        else begin
            if(s_axis_tvalid== 1)begin
                ena       = 1;
                addr      = addr +1;
                
            end
            else begin
//                addr   <= 0;
                ena    <= 0;
            end
            if(sample_count <  NO_OF_WEIGHT-1 && addr > 2)begin
                m_axis_tvalid  <= 1;
                sample_count = sample_count + 1;               
            end
            else begin
                m_axis_tvalid  <= 0;
            end
        end
    end
 
 assign m_axis_tdata   =  data_o;  
endmodule
