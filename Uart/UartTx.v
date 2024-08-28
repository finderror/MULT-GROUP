module uart_tx(
    
//**************输入**************	 
	 input	           clk,                 //系统50MHz时钟
    input              rst_n,               //系统复位，低电平有效  
    input              uart_en,             //发送使能信号
	 input       [ 7:0] uart_din,            //待发送数据
	 
//**************输出**************
 
    output             uart_tx_busy,        //发送忙状态标志 
    output             en_flag,             //使能标志位
    output  reg        tx_flag,             //发送过程标志信号
    output  reg [ 7:0] tx_data,             //寄存发送数据
    output  reg [ 3:0] tx_cnt,              //发送数据计数器
    output  reg        uart_txd             //UART发送端口
    );
    
//************参数定义************
parameter   CLK_FREQ = 36000000;            //系统时钟频率
parameter   UART_BPS = 9600;                //串口波特率
localparam  BPS_CNT  = CLK_FREQ/UART_BPS;   //波特率计数，串口传输一位所需要的系统时钟周期数
 
//************信号定义************
reg        uart_en_1; 
reg        uart_en_2;  
reg [15:0] clk_cnt;                           //系统时钟计数器
 
//在串口发送过程中给出忙状态标志，其他模块就可以判断串口发送模块是否处于空闲状态
assign uart_tx_busy = tx_flag;
 
//捕获uart_en上升沿，得到一个时钟周期的脉冲信号，进入数据发送过程
assign en_flag = (~uart_en_2) & uart_en_1;
 
//对发送使能信号uart_en延迟两个时钟周期避免亚稳态
always @(posedge clk or negedge rst_n) begin         
    if (!rst_n) begin
        uart_en_1 <= 1'b0;                                  
        uart_en_2 <= 1'b0;
    end                                                      
    else begin                                               
        uart_en_1 <= uart_en;                               
        uart_en_2 <= uart_en_1;                            
    end
end
 
//当脉冲信号en_flag到达时,寄存待发送的数据，进入发送过程          
always @(posedge clk or negedge rst_n) begin         
    if (!rst_n) begin                                  
        tx_flag <= 1'b0;
        tx_data <= 8'd0;
    end 
	 //检测到发送使能上升沿，进入发送过程，标志位tx_flag拉高，寄存待发送数据
    else if (en_flag) begin                                       
            tx_flag <= 1'b1;
            tx_data <= uart_din;
        end
        //计数到停止位结束时，停止发送过程，标志位tx_flag拉低                                    
        else if ((tx_cnt == 4'd9) && (clk_cnt == BPS_CNT - (BPS_CNT/16))) begin  //提前1/16个停止位拉低，保证发送数据时间略小于接收数据时间，避免数据积累造成丢失
            tx_flag <= 1'b0;                                 
            tx_data <= 8'd0;
        end
        else begin
            tx_flag <= tx_flag;
            tx_data <= tx_data;
        end 
end
 
//进入发送过程后，启动系统时钟计数器
always @(posedge clk or negedge rst_n) begin         
    if (!rst_n)                             
        clk_cnt <= 16'd0;                                  
    else if (tx_flag) begin 
        if (clk_cnt < BPS_CNT - 1)
            clk_cnt <= clk_cnt + 1'b1;
        else
            clk_cnt <= 16'd0; 
    end
    else                             
        clk_cnt <= 16'd0;
end
 
//进入发送过程后，启动发送数据计数器
always @(posedge clk or negedge rst_n) begin         
    if (!rst_n)                             
        tx_cnt <= 4'd0;
    else if (tx_flag) begin 
        if (clk_cnt == BPS_CNT - 1)	
            tx_cnt <= tx_cnt + 1'b1;
        else
            tx_cnt <= tx_cnt;       
    end
    else                              
        tx_cnt  <= 4'd0;
end
 
//根据发送数据计数器来给uart发送端口赋值
always @(posedge clk or negedge rst_n) begin        
    if (!rst_n)  
        uart_txd <= 1'b1;        
    else if (tx_flag)
        case(tx_cnt)
            4'd0: uart_txd <= 1'b0;         //起始位 
            4'd1: uart_txd <= tx_data[0];   //数据位最低位
            4'd2: uart_txd <= tx_data[1];
            4'd3: uart_txd <= tx_data[2];
            4'd4: uart_txd <= tx_data[3];
            4'd5: uart_txd <= tx_data[4];
            4'd6: uart_txd <= tx_data[5];
            4'd7: uart_txd <= tx_data[6];
            4'd8: uart_txd <= tx_data[7];   //数据位最高位
            4'd9: uart_txd <= 1'b1;         //停止位
            default: ;
        endcase
    else 
        uart_txd <= 1'b1;                   //空闲时发送端口为高电平
end
 
endmodule	          