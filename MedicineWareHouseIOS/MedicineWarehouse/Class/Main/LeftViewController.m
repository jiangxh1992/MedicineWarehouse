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
@property (nonatomic, strong)UIButton *qrcodeBtn;

@end

@implementation LeftViewController

- (void)viewDidAppear:(BOOL)animated{
    if(XHGlobalAccount.Ins.isLogin){
        self.title = @"扫描二维码补药";
        
        [self UILayoutSetting];
        [self DataInit];
    }
    else
    {
        [self ClearView];
        self.title = @"请先登录";
        XHShowMsg(@"请先登录");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)UILayoutSetting {
    _qrcodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_qrcodeBtn setImage:[UIImage imageNamed:@"qrcode-scan"] forState:UIControlStateNormal];
    _qrcodeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_qrcodeBtn addTarget:self action:@selector(OpenQRCodeScan) forControlEvents:UIControlEventTouchUpInside];
    _qrcodeBtn.center = self.view.center;
    [self.view addSubview:_qrcodeBtn];
}

- (void)DataInit {
    qrcodeObtain = [SGQRCodeObtain QRCodeObtain];
}

- (void)ClearView {
    [_qrcodeBtn removeFromSuperview];
    _qrcodeBtn = nil;
    qrcodeObtain = nil;
}

- (void)OpenQRCodeScan {
    WCQRCodeVC *WCVC = [[WCQRCodeVC alloc] init];
    WCVC.type = QRCodeScanTypeMedicineUnit;
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
