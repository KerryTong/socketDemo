//
//  BaseModel.h
//  socket_server
//
//  Created by 仝兴伟 on 2018/11/20.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enum.h"
@interface BaseModel : NSObject<NSCopying>

@property (nonatomic, assign) int64_t bodyLength;

@property (nonatomic, strong) NSData * contentData;

@property (nonatomic, assign) int64_t requestId;

@property (nonatomic, assign) int msgType;

@property (nonatomic, assign) CSIPCClientType clientType;

@property (nonatomic, assign) int64_t errorCode;

@property (nonatomic, assign) int32_t hasProgress;  // 0无进度/1有进度

@property (nonatomic, assign) int32_t progress;

- (instancetype)initWithClientType: (CSIPCClientType) clientType;

- (instancetype)initWithMessageType: (int) msgType clientType: (CSIPCClientType) clientType;

- (instancetype)initWithMessageType: (int) msgType clientType: (CSIPCClientType) clientType contentData: (NSData *) data;


- (instancetype)initWithMessageData: (struct CSIPCMsgHead) data;

- (instancetype)initWithBaseMessage: (BaseModel *) message;

- (NSData *)messageData;

- (void)encodeParamter;

- (void)decodeParamter;

- (int64_t)createCSUID;

@end
