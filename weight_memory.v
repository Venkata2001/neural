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
`define READ_RAM

module weight_memory #(parameter DATA_WIDTH = 32, NO_OF_WEIGHT = 784, ADDRS_WIDTH = $clog2(NO_OF_WEIGHT))(
    input clk,reset_n,
    input s_axis_tvalid,re_en,
    input [DATA_WIDTH-1:0]s_axis_tdata,
    output reg m_axis_tvalid,
    output reg [DATA_WIDTH-1:0]m_axis_tdata
    );
    
    reg [ADDRS_WIDTH-1:0]addr = 0;
    reg ena   = 0;
    reg enb_1 = 0;
    wire [DATA_WIDTH-1:0]data_o;
    wire [DATA_WIDTH-1:0]data_b;
    
    reg ena_1 =0, wea = 0;
    reg [ADDRS_WIDTH-1:0]addra_in;
    reg [ADDRS_WIDTH-1:0]addrb;
    reg [DATA_WIDTH-1:0]dina;
    
    blk_mem_gen_0 weight_brom (
        .clka(clk),    // input wire clka
        .ena(ena),      // input wire ena
        .addra(addr),  // input wire [9 : 0] addra
        .douta(data_o)  // output wire [31 : 0] douta
        );
        
    blk_mem_gen_1  weight_bram(
        .clka(clk),    // input wire clka
        .ena(ena_1),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(addra_in),  // input wire [9 : 0] addra
        .dina(dina),    // input wire [31 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(enb_1),      // input wire enb
        .addrb(addrb),  // input wire [9 : 0] addrb
        .doutb(data_b)  // output wire [31 : 0] doutb
        );
    integer sample_count=0, sample_count_1 =0,rd_count=0;
    
    `ifdef READ_RAM
        always@(posedge(clk))
        begin
            if(!reset_n)
            begin
                m_axis_tvalid <= 0;
                addr          <= 0;
                ena           <= 0;          
                sample_count  <= 0; 
                sample_count_1<= 0; 
                m_axis_tdata  <= 0;          
            end
            else begin
                if(sample_count < NO_OF_WEIGHT + 2)begin
                    ena       <= 1;
                    addr      <= addr +1;
                    sample_count<= sample_count + 1;
                    if(sample_count >= 2)begin
                        m_axis_tvalid  <= 1;
                        m_axis_tdata   <= dina;
                    end
                    else begin
                        m_axis_tvalid <= 0;
                    end
                end
                else begin
                    ena    <= 0;
                    addr   <= 0;
                    m_axis_tvalid <= 0;
                end
            end
        end
    `else
        always@(posedge(clk))
        begin
            if(!reset_n)begin
                m_axis_tvalid  <= 0;
                m_axis_tdata   <= 0;
                sample_count_1 <= 0;
                addra_in       <= 0;
                ena_1    <= 0;
                wea      <= 0;  
                addrb    <= 0;
                rd_count <= 0;
                enb_1    <= 0;
            end
            else begin
                if(s_axis_tvalid == 1)begin
                    if(sample_count_1 < NO_OF_WEIGHT)begin
                        ena_1  <= 1;
                        wea    <= 1;
                        addra_in <= sample_count_1;
                        dina   <= s_axis_tdata;
                    end 
                    else begin
                        sample_count_1 <= 0;
                        addra_in       <= 0;
                        ena_1    <= 0;
                        wea      <= 0;  
                    end                    
                end
                else begin
                   sample_count_1 <= 0;
                   addra_in       <= 0;
                   ena_1    <= 0;
                   wea      <= 0;   
                   if(re_en == 1)begin
                       if(rd_count < NO_OF_WEIGHT + 2)begin
                           enb_1  <= 1;
                           addrb  <= addrb + 1;
                           rd_count<= rd_count + 1;
                           if(rd_count >= 2)begin
                               m_axis_tdata <= data_b;
                               m_axis_tvalid<= 1;
                           end
                           else begin
                               m_axis_tvalid <= 0;
                               enb_1   <= 0;
                               addrb   <= 0;
                           end
                       end
                       else begin
                           m_axis_tvalid <= 0;
                           enb_1   <= 0;
                           addrb   <= 0;
                       end
                   end
                   else begin
                       m_axis_tvalid <= 0; 
                       enb_1   <= 0;       
                       addrb   <= 0;                   
                   end
                end
            end
        end        
    `endif 
endmodule
