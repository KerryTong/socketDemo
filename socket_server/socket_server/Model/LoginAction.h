//
//  LoginAction.h
//  client_socket
//
//  Created by 仝兴伟 on 2018/11/20.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "BaseModel.h"

@interface LoginRequest : BaseModel
@property (nonatomic, strong) NSString * email;

@property (nonatomic, strong) NSString * password;

- (instancetype)initWithClientType: (CSIPCClientType) clientType email: (NSString *) email password: (NSString *) password;
@end

@interface LoginResponse : BaseModel

@property(nonatomic, strong) NSString *loginResponse;

- (instancetype)initWithClientType: (CSIPCClientType) clientType returnString: (NSString *) str;

@end
