//
//  XHConstGlobal.h
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/14.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, XHSocketRequestType){
    XHSocketRequestTypeLogin = 0,
    XHSocketRequestTypeMedicineUnit = 1,
    XHSocketRequestTypeMatchUnit = 2,
    XHSocketRequestTypeMedicinePlus = 3,
    
    XHSocketRequestTypeSignIn = 100,
};

typedef NS_ENUM(NSInteger, QRCodeScanType){
    QRCodeScanTypeMedicineUnit = 1,
    QRCodeScanTypeMatchUnit = 2,
};

extern NSString *const UrlMedicine;

NS_ASSUME_NONNULL_END
