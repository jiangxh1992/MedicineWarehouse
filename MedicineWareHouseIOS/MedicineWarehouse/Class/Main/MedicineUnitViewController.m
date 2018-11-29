//
//  MedicineUnitViewController.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/29.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "MedicineUnitViewController.h"
#import "MedicineUnit.h"
#import "WCQRCodeVC.h"
#import "SGQRCode.h"

@interface MedicineUnitViewController ()

@property (nonatomic, strong) UILabel *lbl_res;

@property (nonatomic, weak) IBOutlet UILabel *lblItem_1;
@property (nonatomic, weak) IBOutlet UILabel *lblItem_2;
@property (nonatomic, weak) IBOutlet UILabel *lblItem_3;
@property (nonatomic, weak) IBOutlet UILabel *lblItem_4;
@property (nonatomic, weak) IBOutlet UITextField *inputView;
@property (nonatomic, weak) IBOutlet UILabel *lbl_msg;

@property (nonatomic, strong) MedicineUnit *curMedicineUnit;
@property (nonatomic, assign) BOOL isMatched; // 单元机和药品是否已经匹配
@end

@implementation MedicineUnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationItem];
    
    [XHNetGlobal.Ins ClientSocketConnect];
    XHNetGlobal.Ins.socketDidReadDta = ^(NSDictionary * _Nullable dic) {
        if(dic){
            int type = [[dic objectForKey:@"type"] intValue];
            if(type == XHSocketRequestTypeMedicineUnit){
                [self OnMedicineUnitResponse:dic];
            }
            else if(type == XHSocketRequestTypeMedicinePlus){
                [self OnMedicinePlusResponse:dic];
            }
            else if (type == XHSocketRequestTypeMatchUnit){
                [self OnMatchMedicineResponse:dic];
            }
        }
    };
    [self OnloadResult];
}

// 二维码扫描结果
- (void)OnloadResult {
    if(XHNetGlobal.Ins.isSocketConected) {
        ParamBase *param = [ParamBase param];
        param.type = (int)_type;
        if(_type == QRCodeScanTypeMedicineUnit){ // 获取单元机信息
            param.jqid = _qrcodeRes;
        }
        else if(_type == QRCodeScanTypeMatchUnit){
            param.jqid = _curMedicineUnit.jqid;  // 单元机和药品匹配
            param.ypid = _qrcodeRes;
        }
        NSString *paramstr = [param mj_JSONString];
        [XHNetGlobal ClientSocketSend:paramstr];
        _lbl_msg.text = [NSString stringWithFormat:@"参数已经发送：%@",paramstr];
    }
    else{
        [XHNetGlobal.Ins ClientSocketConnect];
        _lbl_msg.text = @"服务器断开请重试";
    }
}

// 请求补药
- (IBAction)ReqAddMedicine{
    if([self isNum:_inputView.text]){
        ParamBase *param = [ParamBase param];
        param.type = (int)XHSocketRequestTypeMedicinePlus;
        param.jqid = _qrcodeRes;
        param.num = [_inputView.text integerValue];
        NSString *paramstr = [param mj_JSONString];
        [XHNetGlobal ClientSocketSend:paramstr];
    }
    else{
        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"输入数量非法" toView:self.view];
    }
}


// 获取单元机服务器返回
- (void)OnMedicineUnitResponse: (NSDictionary *)dic{
    _isMatched = NO;
    int status = [[dic objectForKey:@"status"] intValue];
    if(status == 0) {
        if(_curMedicineUnit == nil) _curMedicineUnit = [[MedicineUnit alloc] init];
        _curMedicineUnit.jqid = [dic objectForKey:@"jqid"];
        /*
         “type”:1,
         “status”:”0”,
         “content”:””,
         “jqid”:”12345”,
         “jqbh”:”007”,
         “ypmc”:”黄芪”,
         “ypid”:”3575982”,
         “ypph”:”01-031-02”,
         “storage”:5000,
         “stor3”:20000,
         “need”:1,
         “zt”:”正常”
         */
        /*
         {
         "type":1
         “status”:”-1”,
         “content”:”单元机ID不正确，请重新扫码！”,
         “jqid”:””,
         “jqbh”:””,
         “ypmc”:””,
         “ypid”:””,
         “ypph”:””,
         “storage”:-1,
         “store”:-1,
         “need”:-1,
         “zt”:””
         }
         */
    }
    else {
        self->_lbl_res.text = [NSString stringWithFormat:@"请求失败：%@",[dic objectForKey:@"content"]];
    }
}
// 药品匹配返回
- (void)OnMatchMedicineResponse: (NSDictionary *)dic{
    int status = [[dic objectForKey:@"status"] intValue];
    if(status == 0) {
        /*
         {
         “status”:”0”,
         “content”:””,
         “ypmc”:”黄芪”,
         “ypid”:”3575982”,
         “ypph”:”01-031-02”,
         “defaultnum”:1000
         }
         */
    }
}
// 请求补药返回
- (void)OnMedicinePlusResponse: (NSDictionary *)dic{
    int status = [[dic objectForKey:@"status"] intValue];
    if(status == 0) {
        /*
         "type":3
         “status”:”0”,
         “content”:””,
         “jqid”:”12345”,
         “jqbh”:”007”,
         “ypmc”:”黄芪”,
         “ypid”:”3575982”,
         “ypph”:”01-031-02”,
         “storage”:10000,
         “store”:20000,
         “need”:0,
         “zt”:”正常”
         
         */
        /*
         "type":3
         “status”:”-1”,
         “content”:”请求补药失败！”,
         “jqid”:”12345”,
         “jqbh”:”007”,
         “ypmc”:”黄芪”,
         “ypid”:”3575982”,
         “ypph”:”01-031-02”,
         “storage”:5000,
         “store”:20000,
         “need”:1,
         “zt”:”正常”
         
         */
    }
    else {
        self->_lbl_res.text = [NSString stringWithFormat:@"请求失败：%@",[dic objectForKey:@"content"]];
    }
    
}

- (void)setupNavigationItem {
    UIButton *left_Button = [[UIButton alloc] init];
    [left_Button setTitle:@"返回" forState:UIControlStateNormal];
    [left_Button setTitleColor:[UIColor colorWithRed: 21/ 255.0f green: 126/ 255.0f blue: 251/ 255.0f alpha:1.0] forState:(UIControlStateNormal)];
    [left_Button sizeToFit];
    [left_Button addTarget:self action:@selector(left_BarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left_BarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_Button];
    self.navigationItem.leftBarButtonItem = left_BarButtonItem;
}

- (void)left_BarButtonItemAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_inputView resignFirstResponder];
}

- (IBAction)OpenQRCodeScan {
    WCQRCodeVC *WCVC = [[WCQRCodeVC alloc] init];
    WCVC.type = QRCodeScanTypeMatchUnit;
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
