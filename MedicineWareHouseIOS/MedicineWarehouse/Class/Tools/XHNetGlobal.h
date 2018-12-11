//
//  XHNetGlobal.h
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/14.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SocketCallbackMsg)(NSString * _Nullable data);
typedef void (^SocketCallbackData)(NSDictionary * _Nullable data);

@interface XHNetGlobal : NSObject{
}

@property (nonatomic, assign)BOOL isSocketConected;
@property (nonatomic, copy)NSString *serverIP;
@property (nonatomic, assign)int serverPort;
@property (nonatomic, copy) SocketCallbackData socketDidReadDta;
@property (nonatomic, copy) SocketCallbackMsg socketDidConnected;

/**
 *  获取QueuesSingleton单例对象
 */
+ (XHNetGlobal *)Ins;

/**
 * socket
 */
- (GCDAsyncSocket *)clientSocket;
- (void) ClientSocketConnect;
+ (void) ClientSocketSend :(NSString *)msg;

/**
 * POST WITH DIC
 */
- (void)POSTWithUrl:(NSString *)url param:(NSDictionary *)dic success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;

/**
 * POSTBASE
 */
- (void)POST:(NSString *)Apiurl form: (NSString *)param success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
