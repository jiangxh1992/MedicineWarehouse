//
//  ScanSuccessJumpVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 16/8/29.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanSuccessJumpVC : UIViewController
/** 接收扫描的二维码信息 */
@property (nonatomic, copy) NSString *qrcodeRes;
/** 扫描类型 **/
@property (nonatomic, assign) QRCodeScanType type;
@end
