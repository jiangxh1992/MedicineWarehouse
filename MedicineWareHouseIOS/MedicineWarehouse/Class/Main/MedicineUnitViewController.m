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
    _isMatched = false;
    _curMedicineUnit = nil;
    
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
    if (!_isMatched) {
        _lbl_msg.text = @"无法补药，请先扫描药品匹配单元机！";
        return;
    }
    
    if([self isNum:_inputView.text] && [_inputView.text integerValue] > 0){
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
        _curMedicineUnit.jqbh = [dic objectForKey:@"jqbh"];
        _curMedicineUnit.ypmc = [dic objectForKey:@"ypmc"];
        _curMedicineUnit.ypid = [dic objectForKey:@"ypid"];
        _curMedicineUnit.ypph = [dic objectForKey:@"ypph"];
        _curMedicineUnit.storage = [dic objectForKey:@"storage"];
        _curMedicineUnit.store = [dic objectForKey:@"store"];
        _curMedicineUnit.need = [[dic objectForKey:@"need"] integerValue];
        _curMedicineUnit.zt = [dic objectForKey:@"zt"];
        [self RefreshUnitInfo];
        }
    else {
        self->_lbl_res.text = [NSString stringWithFormat:@"请求失败：%@",[dic objectForKey:@"content"]];
    }
}
// 药品匹配返回
- (void)OnMatchMedicineResponse: (NSDictionary *)dic{
    int status = [[dic objectForKey:@"status"] intValue];
    if(status == 0) {
        _isMatched = true;
        self->_lbl_res.text = @"单元机与药品匹配成功";
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
    else {
        self->_lbl_res.text = [NSString stringWithFormat:@"请求失败：%@",[dic objectForKey:@"content"]];
    }
}
// 请求补药返回
- (void)OnMedicinePlusResponse: (NSDictionary *)dic{
    int status = [[dic objectForKey:@"status"] intValue];
    if(status == 0) {
        self->_lbl_res.text = @"补药成功！";

        _curMedicineUnit.jqid = [dic objectForKey:@"jqid"];
        _curMedicineUnit.jqbh = [dic objectForKey:@"jqbh"];
        _curMedicineUnit.ypmc = [dic objectForKey:@"ypmc"];
        _curMedicineUnit.ypid = [dic objectForKey:@"ypid"];
        _curMedicineUnit.ypph = [dic objectForKey:@"ypph"];
        _curMedicineUnit.storage = [dic objectForKey:@"storage"];
        _curMedicineUnit.store = [dic objectForKey:@"store"];
        _curMedicineUnit.need = [[dic objectForKey:@"need"] integerValue];
        _curMedicineUnit.zt = [dic objectForKey:@"zt"];
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

- (void)RefreshUnitInfo {
    _lblItem_1.text = [NSString stringWithFormat:@"药品名称：%@",_curMedicineUnit.ypmc];
    _lblItem_2.text = [NSString stringWithFormat:@"药品余量：%@",_curMedicineUnit.storage];
    _lblItem_3.text = [NSString stringWithFormat:@"库存：%@",_curMedicineUnit.store];
    if(_curMedicineUnit.need == 0){
        _lblItem_4.text = @"不需要补药";
        _lblItem_4.textColor = [UIColor greenColor];
    }
    else{
        _lblItem_4.text = @"需要补药";
        _lblItem_4.textColor = [UIColor redColor];
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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
