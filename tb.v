`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 20:04:40
// Design Name: 
// Module Name: tb
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



module tb(

    );
    parameter DATA_WIDTH   = 32;    
    parameter NO_OF_WEIGHT = 784;    
    parameter ADDRS_WIDTH = $clog2(NO_OF_WEIGHT);    
    
    reg clk, reset_n;
    reg s_axis_tvalid;
    reg [DATA_WIDTH-1:0]s_axis_tdata;
    reg [ADDRS_WIDTH-1:0]addr_r;
    wire m_axis_tvalid;
    wire [DATA_WIDTH-1:0]m_axis_tdata;
    reg wr_en;
    reg rd_en;
    reg rd_ram_or_rom;
    reg [DATA_WIDTH-1:0]dina;
    reg [ADDRS_WIDTH-1:0]addra_in;
     integer count;
    
//    reg [DATA_WIDTH-1:0]data_rd[NO_OF_WEIGHT-1:0];
    
   weight_memory  #(.DATA_WIDTH(DATA_WIDTH), .NO_OF_WEIGHT(NO_OF_WEIGHT)) 
                dut (.clk(clk),.reset_n(reset_n),
                      .s_axis_tvalid(s_axis_tvalid),.m_axis_tvalid(m_axis_tvalid),
                      .m_axis_tdata(m_axis_tdata));
                      
     always #5 clk = ~clk;
     
     initial begin
        clk     = 0;
        reset_n = 0;
        s_axis_tvalid = 0;
        count    <= 0;
        #50;
        reset_n  = 1;
     end 
     
    
     always@(posedge(clk))begin
        if(count < NO_OF_WEIGHT && reset_n == 1)begin
            s_axis_tvalid <= 1;
//            s_axis_tdata  <= data_rd[count];
            count         <= count +1;
        end
        else begin
            s_axis_tvalid  <= 0;
        end
     end
                       
endmodule
