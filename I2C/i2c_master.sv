`timescale 1ns / 1ps

module i2c_master(
    input [6:0]slave_address_in,
    input [7:0]slave_register_addr_in,
    input [7:0]data_in,
    input rw,run,clk,
    inout sda, 
    output scl,
    output reg [7:0]data_out
    );
    
    reg [6:0]slave_addr;
    reg [7:0]slave_register_addr;
    reg [7:0]rd_data;
    reg [7:0]wr_data;
    reg [7:0]rcvd_data;
    reg [28:0]frame;
    
    reg io;
    reg send_bit;
    reg data_dir;
    reg done;
    
    always @(posedge clk) begin
        if(!run)begin
        done=0;
        slave_addr=slave_address_in;
        slave_register_addr=slave_register_addr_in;
        wr_data=data_in;
        io = rw;
        data_dir=0;
        send_bit=1'bz;
        end
        else if (run && (!done) ) begin
            send_start_bit();
            send_slave_address();
            send_rw_signal(io);
            receive_slave_addr_valid_ack();
            if(frame[9]==0) begin
                done=1;
                $display("INVALID SLAVE ADDRESS");
                end
            else if (frame[9]==1) begin
                send_reg_addr();
                receive_reg_addr_valid_ack();
                if(frame[18]==0)begin
                done=1;
                $display("INVALID SLAVE REGISTER ADDRESS");
                end
                else if(frame[18]==1)begin
                    data_operation();
                    send_stop_bit();
                    done=1;
                end
            end    
            end
        end
        
        task send_start_bit();
            data_dir=0;send_bit=0;frame[0]=send_bit;
            @(posedge clk);
        endtask
    
        task send_slave_address();
            for(int i=0;i<=6;i++)begin
                data_dir=0;send_bit=slave_addr[i];frame[i+1]=send_bit;
                @(posedge clk);
            end
        endtask
        
        task send_rw_signal(input bit a);
            if(a==1)begin
                        data_dir=0;send_bit=1;frame[8]=send_bit;
                        @(posedge clk);
            end
            else if(a==0)begin
                            data_dir=0;send_bit=0;frame[8]=send_bit;
                            @(posedge clk);
            end
        endtask
        
        task receive_slave_addr_valid_ack() ;
            data_dir=1;
            @(posedge clk);
            frame[9]=sda;
        endtask
        
         task send_reg_addr();
            for(int i=0;i<=7;i++)begin
                data_dir=0;send_bit=slave_register_addr[i];frame[i+10]=send_bit;
                @(posedge clk);
            end
        endtask
        
        task receive_reg_addr_valid_ack() ;
            data_dir=1;
            @(posedge clk);
            frame[18]=sda;
        endtask
        
        task data_operation();
            if(io==0) begin
             send_data();
             receive_data_ack();
            end
            else if (io ==1)begin
             receive_data();
             send_data_ack();            
            end
        endtask
        
        task send_data();
        for(int i=0;i<=7;i++)begin
                data_dir=0;send_bit=wr_data[i];frame[i+19]=send_bit;
                @(posedge clk);
                end
        endtask
        task receive_data();
        for(int i=0;i<=7;i++)begin
                data_dir=1;
                @(posedge clk);
                frame[i+19]=sda;
                rd_data[i]=frame[i+19];
                end
        endtask        
        task send_data_ack();
            data_dir=0;send_bit=1;frame[27]=send_bit;
            @(posedge clk);
        endtask
        task receive_data_ack();
            data_dir=1;
            @(posedge clk);
            frame[27]=sda;
        endtask
         
         task send_stop_bit();
            data_dir=0;send_bit=1;frame[28]=send_bit;data_out=rd_data;
            @(posedge clk);
        endtask
    
    assign scl=clk;
    assign sda=data_dir?1'bz:send_bit;
endmodule
