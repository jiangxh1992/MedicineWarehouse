//
//  XHGlobalAccount.h
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/25.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHGlobalAccount : NSObject
@property (nonatomic, assign)BOOL isLogin;
@property (nonatomic, strong)Account *account;

+ (XHGlobalAccount *) Ins;


@end

NS_ASSUME_NONNULL_END
