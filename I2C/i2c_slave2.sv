`timescale 1ns / 1ps

module i2c_slave2(
    input run,scl,
    inout sda
    );
    
    reg [7:0]addr=18;
    reg [7:0]rcvd_slv_addr=0;
    
    reg [7:0]register_1_addr=251;
    reg [7:0]register_2_addr=252;
    reg [7:0]register_3_addr=253;
    
    reg [7:0]rcv_reg_addr;
    reg [7:0]rcv_data;
    reg [7:0]send_data;
    
    reg [7:0]register_1_data=10;
    reg [7:0]register_2_data=20;
    reg [7:0]register_3_data=30;
    reg [28:0]frame;
    reg data_dir;
    reg send_bit;
    reg done;
    
    always @(posedge scl) begin
    if(!run) begin done=0;data_dir=0;send_bit=1'bz;end
    else if(run && (!done)) begin 
        receive_start_bit();
        receive_slave_addr();
        receive_rw();
        if(addr!=rcvd_slv_addr)begin 
        send_slave_addr_invalid_ack();
        done=1;
        end
        else if (addr==rcvd_slv_addr)begin
        send_slave_addr_valid_ack();
        receive_reg_addr();
        if((rcv_reg_addr!=register_1_addr)&&(rcv_reg_addr!=register_2_addr)&&(rcv_reg_addr!=register_3_addr)) 
        begin 
        send_reg_addr_invalid_ack();
        done=1;
        end
        else begin
        send_reg_addr_valid_ack();
        data_operation();
        receive_stop_bit();
        display();
        done=1;
        end
        end
        
    end
    end
    
      task receive_start_bit();
       data_dir=1;
       @(posedge scl);
       frame[0]=sda;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
       endtask
       
       task receive_slave_addr();
       for(int i=0;i<=6;i++) begin
       data_dir=1;
       @(posedge scl);
       frame[i+1]=sda; rcvd_slv_addr[i]=frame[i+1];
       end
       endtask
       
       task receive_rw();
       data_dir=1;
       @(posedge scl);
       frame[8]=sda;
       endtask
        
        task send_slave_addr_invalid_ack();
        data_dir=0;send_bit=0;frame[9]=send_bit;
        @(posedge scl);
        endtask
        
        task send_slave_addr_valid_ack();
        data_dir=0;send_bit=1;frame[9]=send_bit;
        @(posedge scl);
        endtask
        
        task receive_reg_addr();
            for(int i=0;i<=7;i++) begin
            data_dir=1;
            @(posedge scl);
            frame[i+10]=sda; rcv_reg_addr[i]=frame[i+10];     
            end 
        endtask
       
       
        task send_reg_addr_invalid_ack();
        data_dir=0;send_bit=0;frame[18]=send_bit;
        @(posedge scl);
        endtask
        
        task send_reg_addr_valid_ack();
        data_dir=0;send_bit=1;frame[18]=send_bit;
        @(posedge scl);
        endtask
        
        task data_operation();
            if(frame[8]==0)begin
            rcv_reg_data();
            send_data_ack();
            end
            else if(frame[8]==1) begin
            send_reg_data();
            rcv_data_ack();            
            end
        endtask
       
       task send_reg_data();
            if(rcv_reg_addr==register_1_addr) send_data=register_1_data;
            else if(rcv_reg_addr==register_2_addr) send_data=register_2_data;
            else if(rcv_reg_addr==register_3_addr) send_data=register_3_data;
       for(int i=0;i<=7;i++)begin
       data_dir=0;send_bit=send_data[i];frame[i+19]=send_bit;
       @(posedge scl);
       end
       endtask
       
       task rcv_reg_data();
       for(int i=0;i<=7;i++) begin
       data_dir=1;
       @(posedge scl);
       frame[i+19]=sda;
       rcv_data[i]=frame[i+19];
       end
       endtask
       
       task send_data_ack();
       data_dir=0;send_bit=1;frame[27]=send_bit;
       @(posedge scl);
       endtask
       
       task rcv_data_ack();
       data_dir=1;
       @(posedge scl);
       frame[27]=sda;
       endtask
       
       task receive_stop_bit();
       data_dir=1;
       @(posedge scl);
       frame[28]=sda;
       endtask
       
       task display();
       $display("[LCD DISPLAY]: %0d ",rcv_data);
       endtask
              
        assign sda=data_dir?1'bz:send_bit;
    endmodule
