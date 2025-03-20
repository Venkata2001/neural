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


module weight_memory #(parameter DATA_WIDTH = 31, NO_OF_WEIGHT = 784, ADDRS_WIDTH = $clog2(NO_OF_WEIGHT))(
    input clk,reset_n,
    input s_axis_tvalid,
    input wr_en,
    input rd_en,
    input rd_ram_or_rom,
    input [DATA_WIDTH-1:0]dina,
    input [ADDRS_WIDTH-1:0]addra_in,
    output reg m_axis_tvalid,
    output wire [DATA_WIDTH-1:0]m_axis_tdata
    );
    
    reg [ADDRS_WIDTH-1:0]addr = 0;
    reg [ADDRS_WIDTH-1:0]addrb_1 = 0;
    reg ena   = 0;
    reg enb_1 = 0;
    wire [DATA_WIDTH-1:0]data_o;
    wire [DATA_WIDTH-1:0]data_b;
    
    blk_mem_gen_0 weight_brom (
        .clka(clk),    // input wire clka
        .ena(ena),      // input wire ena
        .addra(addr),  // input wire [9 : 0] addra
        .douta(data_o)  // output wire [31 : 0] douta
        );
        
    blk_mem_gen_1  weight_bram(
        .clka(clk),    // input wire clka
        .ena(wr_en),      // input wire ena
        .wea(wr_en),      // input wire [0 : 0] wea
        .addra(addra_in),  // input wire [9 : 0] addra
        .dina(dina),    // input wire [31 : 0] dina
        .clkb(clk),    // input wire clkb
        .enb(enb_1),      // input wire enb
        .addrb(addrb),  // input wire [9 : 0] addrb
        .doutb(data_b)  // output wire [31 : 0] doutb
        );
    integer sample_count, sample_count_1 =0;
    
    always@(posedge(clk))
    begin
        if(!reset_n)
        begin
            m_axis_tvalid <= 0;
            addr          <= 0;
            ena           <= 0; 
            enb_1         <= 0;           
            sample_count  <= 0; 
            sample_count_1<= 0; 
            addrb_1       <= {ADDRS_WIDTH{1'b1}};           
        end
        else begin
            if(rd_ram_or_rom == 1)begin
                if(s_axis_tvalid== 1)begin
                    ena       = 1;
                    addr      = addr +1;
                end
                else begin
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
            else begin
               //read data from bram
               if(rd_en  == 1 && rd_ram_or_rom == 0)begin
                 if(s_axis_tvalid == 1)begin
                    enb_1  <= 1;
                    addrb_1<= addrb_1 + 1;
                 end
                 else begin
                     enb_1    <= 0;
                 end
                 if(sample_count_1 <  NO_OF_WEIGHT-1 && addrb_1 > 2)begin
                     m_axis_tvalid  <= 1;
                     sample_count_1 = sample_count_1 + 1;               
                 end
                 else begin
                     m_axis_tvalid  <= 0;
                 end
               end
            end
        end
    end
 
 assign m_axis_tdata   =  (rd_en)? data_b : data_o;  
endmodule
