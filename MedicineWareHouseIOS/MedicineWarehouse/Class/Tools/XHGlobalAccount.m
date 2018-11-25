//
//  XHGlobalAccount.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/25.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "XHGlobalAccount.h"

@implementation XHGlobalAccount

+ (XHGlobalAccount *) Ins{
    static dispatch_once_t once;
    static id Instance;
    dispatch_once(&once, ^{
        Instance = [[XHGlobalAccount alloc] init];
    });
    return Instance;
}
- (id)init{
    if(self = [super init]){
        _account = [[Account alloc] init];
        _isLogin = false;
    }
    return self;
}

@end
