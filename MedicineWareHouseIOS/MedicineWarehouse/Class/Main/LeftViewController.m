//
//  LeftViewController.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/16.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "LeftViewController.h"
#import "SGQRCode.h"
#import "WCQRCodeVC.h"

@interface LeftViewController (){
    SGQRCodeObtain *qrcodeObtain;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"补药";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self UILayoutSetting];
    [self DataInit];
}

- (void)UILayoutSetting {
    UIButton *qrcodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [qrcodeBtn setImage:[UIImage imageNamed:@"qrcode-scan"] forState:UIControlStateNormal];
    qrcodeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [qrcodeBtn addTarget:self action:@selector(OpenQRCodeScan) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:qrcodeBtn];
}

- (void)DataInit {
    qrcodeObtain = [SGQRCodeObtain QRCodeObtain];
}

- (void)OpenQRCodeScan {
    WCQRCodeVC *WCVC = [[WCQRCodeVC alloc] init];
    [self QRCodeScanVC:WCVC];
}

- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.navigationController pushViewController:scanVC animated:YES];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self.navigationController pushViewController:scanVC animated:YES];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

@end
