//
//  XHNetGlobal.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/14.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "XHNetGlobal.h"

@interface XHNetGlobal()<GCDAsyncSocketDelegate>

/**
 * session
 */
@property(nonatomic, strong)NSURLSession *session;

@property(nonatomic, strong)GCDAsyncSocket *clientSocket;


@end

@implementation XHNetGlobal

/**
 *  获取单例对象
 */
+ (XHNetGlobal *)Ins
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 *  init
 */
- (id)init
{
    if (self = [super init])
    {
        _session = [NSURLSession sharedSession];
        [self setSocketDidConnected:^(NSString * _Nullable data) {
            
        }];
        [self setSocketDidReadDta:^(NSDictionary * _Nullable data) {
            
        }];
    }
    return self;
}

- (GCDAsyncSocket *)clientSocket {
    if(_clientSocket == nil)
        _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    return _clientSocket;
}

/**
 * Post with dic
 */
- (void)POSTWithUrl:(NSString *)url param:(NSDictionary *)dic success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *json = [dic mj_JSONString];
    NSString *param = [NSString stringWithFormat:@"param=%@",json];
    [self POST:url form:param success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 * Post base
 */
- (void)POST:(NSString *)Apiurl form:(NSString *)param success:(void (^)(id json))success failure:(void (^)(NSError *))failure {
    // 根据会话对象创建task
    NSURL *URL = [NSURL URLWithString:Apiurl];
    // 创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    // 修改请求方法为POST
    request.HTTPMethod = @"POST";
    // 参数
    request.HTTPBody = [[self AES128Convert:param] dataUsingEncoding:NSUTF8StringEncoding];
    // 请求超时
    request.timeoutInterval = 30;
    //根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解密解析数据
        id aesjson = [self decrypeJsonWithData:data];
        if (!error) {
            success(aesjson);
            NSLog(@"返回数据：%@",aesjson);
        }else {
            failure(error);
        }
    }];
    //执行任务
    [dataTask resume];
}

/**
 *  NSData转JSON(解密)
 */
- (id)decrypeJsonWithData:(NSData *)data
{
    // 转成字符串
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 2 解密
    //jsonStr = [DES3Util AES128Decrypt:jsonStr];
    // 去掉末尾的\0\0\0...
    //const char *convert = [jsonStr UTF8String];
    //NSString *jsonTrim = [NSString stringWithCString:convert encoding:NSUTF8StringEncoding];
    // 3 转json
    return [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}

/**
 *  aes128加密后的密文编码处理，参数为128加密后的密文
 */
- (NSString *)AES128Convert: (NSString *)aes128 {
    
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    
    return [aes128 stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

+ (void) ClientSocketSend :(NSString *)msg {
    [XHNetGlobal.Ins.clientSocket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
- (void)ClientSocketConnect {
    if(!XHNetGlobal.Ins.isSocketConected){
        [XHNetGlobal.Ins.clientSocket connectToHost:@"169.254.11.246" onPort:8080 error:nil];
        [XHNetGlobal.Ins.clientSocket readDataWithTimeout:-1 tag:0];
    }
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    _isSocketConected = true;
    _socketDidConnected(@"服务器已连接");
    NSLog(@"链接服务器成功！服务器IP：%@端口：%d",host,port);
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    NSLog(@"服务器返回数据：%@",[dic mj_JSONString]);
    _socketDidReadDta(dic);
    [XHNetGlobal.Ins.clientSocket readDataWithTimeout:-1 tag:0];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    _isSocketConected = false;
    _socketDidConnected(@"服务器已断开");
    NSLog(@"服务器断开：%@",err);
    [XHNetGlobal.Ins ClientSocketConnect];
    //_clientSocket.delegate = nil;
    //_clientSocket = nil;
}

@end
