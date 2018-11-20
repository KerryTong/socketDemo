//
//  BaseModel.m
//  socket_server
//
//  Created by 仝兴伟 on 2018/11/20.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "BaseModel.h"
@implementation BaseModel

- (instancetype)initWithClientType: (CSIPCClientType) clientType {
    return [self initWithMessageType: self.msgType clientType: clientType contentData: nil];;
}

- (instancetype)initWithMessageType: (int) msgType clientType: (CSIPCClientType) clientType {
    return [self initWithMessageType: msgType clientType: clientType contentData: nil];
}

- (instancetype)initWithMessageType: (int) msgType clientType: (CSIPCClientType) clientType contentData: (NSData *) data {
    self = [super init];
    if (self) {
        _msgType = msgType;
        _clientType = clientType;
        _contentData = [data copy];
        _requestId = [self createCSUID];
        _bodyLength = [_contentData length];
        _hasProgress = 0;
        _progress = 0;
        _errorCode = 0;
    }
    return self;
}

- (instancetype)initWithMessageData: (struct CSIPCMsgHead) data {
    if (sizeof(data) <= 0) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _clientType = data.client_type;
        _msgType = data.msg_type;
        _requestId = data.request_id;
        _bodyLength = data.body_length;
        _errorCode = data.error_code;
        _hasProgress = data.hasProgress;
        _progress = data.progress;
    }
    return self;
}

- (instancetype)initWithBaseMessage: (BaseModel *) message {
    if (!message) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _clientType = message.clientType;
        _msgType = message.msgType;
        _requestId = message.requestId;
        _bodyLength = message.bodyLength;
        _errorCode = message.errorCode;
        _hasProgress = message.hasProgress;
        _progress = message.progress;
        
        if (message.contentData > 0) {
            _contentData = [message.contentData copy];
        }
        [self decodeParamter];
    }
    return self;
}

- (NSData *)messageData {
    NSMutableData * all = [[NSMutableData alloc] init];
    
    struct CSIPCMsgHead head;
    head.body_length = [self.contentData length];
    head.client_type = self.clientType;
    head.msg_type = self.msgType;
    head.request_id = self.requestId;
    head.error_code = self.errorCode;
    head.hasProgress = self.hasProgress;
    head.progress = self.progress;
    NSData * headData = [NSData dataWithBytes:&head length:sizeof(struct CSIPCMsgHead)];
    
    [all appendData:headData];
    [all appendData:self.contentData];
    
    return [all copy];
}

- (void)encodeParamter {
    return;
}

- (void)decodeParamter {
    return;
}

- (int64_t)createCSUID {
    NSString * uid = [[NSString alloc]initWithFormat:@"%d%ld%ld%ld",self.msgType&0xFFFF,random()&0xFFFF,random()&0xFFFF,random()&0xFFFF];
    long long uuid  = [uid longLongValue];
    return uuid;
}

- (id)copyWithZone:(NSZone *)zone {
    BaseModel * message = [[[self class] allocWithZone: zone] init];
    message.clientType = self.clientType;
    message.msgType = self.msgType;
    message.contentData = [self.contentData copy];
    message.requestId = self.requestId;
    message.bodyLength = self.bodyLength;
    message.hasProgress = self.hasProgress;
    message.progress = self.progress;
    message.errorCode = self.errorCode;
    
    return message;
}


@end
