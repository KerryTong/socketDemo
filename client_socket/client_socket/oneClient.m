//
//  oneClient.m
//  client_socket
//
//  Created by 仝兴伟 on 2018/11/19.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "oneClient.h"
#import <stdio.h>
#import <stdlib.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import <string.h>
#import <unistd.h>
#import "Enum.h"
#import "LoginAction.h"
@interface oneClient ()
@property (nonatomic, assign) int totalRecv;
@end

int clientSock;

@implementation oneClient

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.totalRecv = 0;
}

- (IBAction)client:(NSButton *)sender {
        // 创建套接字
    clientSock = socket(AF_INET, SOCK_STREAM, 0);
    NSLog(@"clientSock ----%d", clientSock);
    // 向服务器发起请求
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    serv_addr.sin_port = htons(11234);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    connect(clientSock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    while (1) {
//        char buffer[40];
//        // 读取从服务器返回的数据
//        read(clientSock, buffer, sizeof(buffer)-1);
//        printf("Message form server: %s---%d\n", buffer, i);
//        i++;
        [self receiveMsgFromServer:clientSock];
    }
  });
}

// 接收服务器返回消息
- (void)receiveMsgFromServer: (int) handle {
    int headSize = sizeof(struct CSIPCMsgHead);
    long rval;
    char headBuf[headSize];
    
    do {
        @autoreleasepool  {
            if ((rval = read(handle, headBuf, headSize))<0) {
                NSLog(@"reading stream message <0");
                break;
            } else if (rval == 0) {
                NSLog(@"reading stream message == 0");
                break;
            } else {
                struct CSIPCMsgHead headrecv;
                memcpy(&headrecv, headBuf, sizeof(struct CSIPCMsgHead));
                BaseModel *base = [[BaseModel alloc]initWithMessageData:headrecv];
                char bodyBUF [base.bodyLength];
                NSLog(@"msgType -- %d=== %d", base.msgType,self.totalRecv);
                bzero(bodyBUF, sizeof(bodyBUF));
                read(handle, bodyBUF, base.bodyLength);
                NSLog(@"bodyBUF -- %s", bodyBUF);
                self.totalRecv += 1;
            }
        }
    } while (rval > 0);
}


// 往服务器发送消息
- (IBAction)sendMessage:(NSButton *)sender {
        LoginRequest *request = [[LoginRequest alloc]initWithClientType:CSIPCClientTypeUI email:@"xingwei.tong@doc.com" password:@"123456"];
        NSData *data = [request messageData];
        for (int i =0; i < 100; i++) {
        send(clientSock, [data bytes], data.length, 0);
    }
}

@end
