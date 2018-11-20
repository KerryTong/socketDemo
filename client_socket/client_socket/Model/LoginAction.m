//
//  LoginAction.m
//  client_socket
//
//  Created by 仝兴伟 on 2018/11/20.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "LoginAction.h"
#import "BaseModel.h"
@implementation LoginRequest
- (instancetype)initWithClientType: (CSIPCClientType) clientType email: (NSString *) email password: (NSString *) password {
    self = [super initWithMessageType:CSIPCUIProtoLoginRequest clientType:clientType];
    if (self) {
        _email = email;
        _password = password;
        [self encodeParamter];
    }
    return self;
}

- (void)encodeParamter {
    NSDictionary * paraDic = @{
                               @"password" : self.password,
                               @"email" : self.email
                               };
    self.contentData = [NSData data];
    self.contentData = [NSJSONSerialization dataWithJSONObject: paraDic options: NSJSONWritingPrettyPrinted error: nil];
}

- (void)decodeParamter {
    if (self.contentData) {
        NSDictionary * paraDic = [NSJSONSerialization JSONObjectWithData: self.contentData options: NSJSONReadingAllowFragments error: nil];
        self.email = paraDic[@"password"];
        self.password = paraDic[@"email"];
    }
}

- (id)copyWithZone:(NSZone *)zone {
    BaseModel * message = [super copyWithZone: zone];
    LoginRequest * request = [[LoginRequest alloc] initWithBaseMessage: message];
    request.password = [self.password copy];
    request.email = [self.email copy];
    return request;
}

@end

@implementation LoginResponse


- (instancetype)initWithClientType: (CSIPCClientType) clientType returnString: (NSString *) str {
    self = [super initWithMessageType:CSIPCUIProtoLoginResponse clientType:clientType];
    if (self) {
        self.loginResponse = str;
        [self encodeParamter];
    }
    return self;
}

- (void)encodeParamter {
        NSDictionary * paraDic = @{
                                   @"response" : self.loginResponse,
                                   };
        self.contentData = [NSData data];
        self.contentData = [NSJSONSerialization dataWithJSONObject: paraDic options: NSJSONWritingPrettyPrinted error: nil];
}

-(void)decodeParamter {
    if (self.contentData) {
        NSDictionary * paraDic = [NSJSONSerialization JSONObjectWithData: self.contentData options: NSJSONReadingAllowFragments error: nil];
        self.loginResponse = paraDic[@"response"];
    }
}


- (id)copyWithZone:(NSZone *)zone {
    BaseModel * message = [super copyWithZone: zone];
    LoginResponse * request = [[LoginResponse alloc] initWithBaseMessage: message];
    request.loginResponse = [self.loginResponse copy];
    return request;
}


@end
