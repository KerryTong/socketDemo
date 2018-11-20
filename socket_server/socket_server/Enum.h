
struct CSIPCMsgHead {
    int64_t body_length;
    int32_t msg_type;
    int32_t client_type;
    int64_t request_id;
    int64_t error_code;
    int32_t hasProgress;
    int32_t progress;
};

typedef NS_ENUM(NSUInteger, CSIPCClientType) {
    CSIPCClientTypeServer = 0,
    CSIPCClientTypeUI,
    CSIPCClientTypeProxy,
    CSIPCClientTypeScan
};

// UI模块协议
typedef NS_ENUM(NSInteger, CSIPCUIProtocol) {
    
    CSIPCUIProtoLoginResponse               = -2,
    CSIPCUIProtoHelloResponse               = -1,
    
    CSIPCUIProtoHello                       = 1,
    CSIPCUIProtoLoginRequest                = 2,
    
};
