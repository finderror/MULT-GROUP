module uart_rx(
 
//**************输入**************
	 input			     clk,                 					   //系统50MHz时钟
    input              rst_n,               					   //系统复位，低电平有效  
    input              uart_rxd,            					   //UART接收端口
	 
//**************输出**************
    output  reg        uart_done,            				       //接收一帧数据完成标志
    output  reg        rx_flag,                                    //接收标志位
    output  reg [3:0]  rx_cnt,                                     //接收数据计数器
    output  reg [7:0]  rxdata,                                     //接收端口数据寄存
    output  reg [7:0]  uart_data                                   //接收的数据
    );
    
//************参数定义************
parameter   CLK_FREQ = 36000000;                				//系统时钟
parameter   UART_BPS = 9600;                    				//串口波特率
localparam  BPS_CNT  = CLK_FREQ/UART_BPS;      					//波特率计数，串口传输一位所需要的系统时钟周期数
																				
//************信号定义************
reg        uart_rxd_1;                                      //异步信号会带来亚稳态，常用处理方式是打拍处理，第一拍
reg        uart_rxd_2;                                      //第二拍，通常打两拍就基本上就能避免亚稳态问题
reg [15:0] clk_cnt;                              			//系统时钟计数器
 
wire       start_flag;                                      //起始标志位
 
 
//检测接收端口下降沿来捕获起始位，输出一个时钟周期的脉冲start fag，并进入串口接收过程
assign  start_flag = uart_rxd_2 & (~uart_rxd_1);    
 
//对UART接收端口的数据延迟两个时钟周期避免亚稳态
always @(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin 
        uart_rxd_1 <= 1'b0;
        uart_rxd_2 <= 1'b0;          
    end
    else begin
        uart_rxd_1  <= uart_rxd;                   
        uart_rxd_2  <= uart_rxd_1;
    end   
end
 
//当脉冲信号start_flag有效，进入数据接收过程           
always @(posedge clk or negedge rst_n) begin         
    if (!rst_n)
        rx_flag <= 1'b0;
    else begin
	    //检测到起始位，进入数据接收过程，标志位rx_flag拉高
        if(start_flag)
            rx_flag <= 1'b1;
        //当接收数据计数器计数到9(9个波特周期)且在停止位中间(数据寄存已经完成，为检测下一帧数据起始位准备)，停止接收，标志位rx_flag拉低				
        else if((rx_cnt == 4'd9) && (clk_cnt == BPS_CNT/2))     	   
            rx_flag <= 1'b0;
        else
            rx_flag <= rx_flag;
    end
end
 
//进入数据接收过程启动系统时钟计数器
always @(posedge clk or negedge rst_n) begin         
    if (!rst_n)                             
        clk_cnt <= 16'd0;
	//标志位rx_flag有效，处于接收过程	  
    else if (rx_flag) begin
        //计数没到一个波特率周期则一直计数，到了则清零	 
        if (clk_cnt < BPS_CNT - 1)
            clk_cnt <= clk_cnt + 1'b1;
        else
            clk_cnt <= 16'd0;
    end
	 //数据接收过程结束，计数器清零
    else                              				
        clk_cnt <= 16'd0;						
end
 
//进入数据接收过程启动接收数据计数器
always @(posedge clk or negedge rst_n) begin         
    if (!rst_n)                             
        rx_cnt  <= 4'd0;  
    else if (rx_flag) begin
	    //系统时钟计数到一个波特率周期，接收数据计数器加1，没到则不加
        if (clk_cnt == BPS_CNT - 1)				
            rx_cnt <= rx_cnt + 1'b1;			 //可以用来判断当前传输的是第几位
        else
            rx_cnt <= rx_cnt;       
    end
	 //接收过程结束，计数器清零
	 else
        rx_cnt  <= 4'd0;						
end
 
//根据接收数据计数器来寄存uart接收端口数据
always @(posedge clk or negedge rst_n) begin 
    if (!rst_n)  
        rxdata <= 8'd0;                                     
    else if(rx_flag)
	    //计数到数据中间的采样结果最稳定
        if (clk_cnt == BPS_CNT/2) begin
            case (rx_cnt)
			 //根据rx_cnt的值将uart接收端口的数据寄存到接收数据寄存器对应的位实现串并转换
             4'd1 : rxdata[0] <= uart_rxd_2;   //寄存数据位最低位
             4'd2 : rxdata[1] <= uart_rxd_2;
             4'd3 : rxdata[2] <= uart_rxd_2;
             4'd4 : rxdata[3] <= uart_rxd_2;
             4'd5 : rxdata[4] <= uart_rxd_2;
             4'd6 : rxdata[5] <= uart_rxd_2;
             4'd7 : rxdata[6] <= uart_rxd_2;
             4'd8 : rxdata[7] <= uart_rxd_2;   //寄存数据位最高位
             default:;                                    
            endcase
        end
        else 
            rxdata <= rxdata;
    else
        rxdata <= 8'd0;
end
 
//数据接收完毕后给出标志信号并寄存输出接收到的数据
always @(posedge clk or negedge rst_n) begin        
    if (!rst_n) begin
        uart_data <= 8'd0;                               
        uart_done <= 1'b0;
    end
	//接收数据计数器计数到停止位时，寄存输出接收到的数据并将接收完成标志位拉高
    else if(rx_cnt == 4'd9) begin                          
        uart_data <= rxdata;              
        uart_done <= 1'b1;    
    end
    else begin
        uart_data <= 8'd0;                                   
        uart_done <= 1'b0; 
    end    
end
 
endmodule	