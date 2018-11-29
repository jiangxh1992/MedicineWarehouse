//
//  MedicineUnitViewController.h
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/29.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedicineUnitViewController : UIViewController
/** 接收扫描的二维码信息 */
@property (nonatomic, copy) NSString *qrcodeRes;
/** 扫描类型 **/
@property (nonatomic, assign) QRCodeScanType type;
@end

NS_ASSUME_NONNULL_END
