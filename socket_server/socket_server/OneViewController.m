//
//  OneViewController.m
//  socket_server
//
//  Created by 仝兴伟 on 2018/11/19.
//  Copyright © 2018年 TW. All rights reserved.
//  长链接

#import "OneViewController.h"
#import <stdio.h>
#import <stdlib.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import <string.h>
#import <unistd.h>
#import "Enum.h"

@interface OneViewController ()
@property (nonatomic, assign) int serv_sock;
@property (nonatomic, assign) int client_socket;
@property (nonatomic, assign) int totalRecv;

@property (nonatomic, strong) BaseModel *base;
@end




@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.totalRecv = 0;
}

- (IBAction)openServer:(NSButton *)sender {
    
    // 创建套接字
    self.serv_sock = socket(AF_INET, SOCK_STREAM, 0);
    if (-1 == self.serv_sock) {
        NSLog(@"sock created");
        return;
    }
    // 将套接字和IP，端口绑定
    struct sockaddr_in serv_addr;
    
    memset( &serv_addr, 0, sizeof( struct sockaddr_in ));
    
    serv_addr.sin_family = AF_INET; // 使用IPV4地址
    serv_addr.sin_port = htons(11234); // 端口
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY); // 具体IP地址
    
    int on = 1;
    if (setsockopt(self.serv_sock, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(int))<0) {
        perror("setsockopt  SO_REUSEADDR fail");
        exit(1);
    }
    if (setsockopt(self.serv_sock, SOL_SOCKET, SO_NOSIGPIPE, &on, sizeof(int))<0) {
        perror("setsockopt  SO_NOSIGPIPE fail");
        exit(1);
    }
    
    bind(self.serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    
    // 进入监听状态，等待用户发起请求
    listen(self.serv_sock, 10);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 接受客户端请求
        struct sockaddr_in client_addr;
//        bzero(&client_addr, sizeof(client_addr));
        socklen_t client_addr_size = sizeof(client_addr);
        self.client_socket  = accept(self.serv_sock, (struct sockaddr*)&client_addr, &client_addr_size);
        NSLog(@"client_socket %d", self.client_socket);
        if (-1 == self.client_socket) {
            NSLog(@"sock accept");
            return ;
        }
        // 接受消息
        while (1) {
            [self receiveMsgFromClient:self.client_socket];
        }
    });
}

// 收到客户端消息
- (void)receiveMsgFromClient: (int) handle  {
    int headSize = sizeof(struct CSIPCMsgHead);
    char headBuf[headSize];
    long rval;
    do {
        @autoreleasepool {
            if ((rval = read(handle, headBuf, headSize))<0) {
                NSLog(@"reading stream message < 0");
                break;
            } else if(rval == 0){
                NSLog(@"reading stream message == 0");
                break;
            } else {
                // 接收客户端
                struct CSIPCMsgHead headrecv;
                memcpy(&headrecv, headBuf, sizeof(struct CSIPCMsgHead));
                BaseModel *base = [[BaseModel alloc]initWithMessageData:headrecv];
                self.base = base;
                char bodyBUF [base.bodyLength];
                NSLog(@"msgType -- %d=== %d", base.msgType,self.totalRecv);
                bzero(bodyBUF, sizeof(bodyBUF));
                read(handle, bodyBUF, base.bodyLength);
                NSLog(@"bodyBUF -- %s", bodyBUF);
                self.totalRecv += 1;
            }
        }
    } while (rval >0);
}




// 发送消息至客户端
- (IBAction)serversend:(id)sender {
    LoginResponse *resp = [[LoginResponse alloc]initWithClientType:CSIPCClientTypeServer returnString:@"收到了"];
    resp.requestId = self.base.requestId;
    BaseModel *base = [resp copy];
    NSData *data = [base messageData];
    for (int i =0; i < 100; i++) {
    send(self.client_socket, [data bytes], data.length, 0);
    }

}


@end
