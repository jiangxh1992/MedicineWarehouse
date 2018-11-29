//
//  ScanSuccessJumpVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 16/8/29.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "ScanSuccessJumpVC.h"
#import "MedicineUnit.h"
#import "WCQRCodeVC.h"
#import "SGQRCode.h"

@interface ScanSuccessJumpVC ()
@property (nonatomic, strong) UILabel *lbl_msg;
@property (nonatomic, strong) UILabel *lbl_res;
@property (nonatomic, strong) UITextField *inputView;

@property (nonatomic, strong) MedicineUnit *curMedicineUnit;
@property (nonatomic, assign) BOOL isMatched; // 单元机和药品是否已经匹配
@end

@implementation ScanSuccessJumpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItem];
    [self setupUI];
    
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
- (void)ReqAddMedicine{
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


- (void)setupUI {
    // tip
    _lbl_msg = [[UILabel alloc] init];
    _lbl_msg.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    _lbl_msg.textColor = [UIColor redColor];
    _lbl_msg.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbl_msg];
    // 提示文字
    _lbl_msg.text = @"服务器连接...";
    
    // 扫描结果
    CGFloat label_Y = CGRectGetMaxY(_lbl_msg.frame);
    _lbl_res = [[UILabel alloc] init];
    _lbl_res.frame = CGRectMake(5, label_Y, self.view.frame.size.width - 10, ScreenH / 2);
    _lbl_res.textAlignment = NSTextAlignmentCenter;
    _lbl_res.layer.cornerRadius = 3;
    _lbl_res.layer.borderColor = [[UIColor grayColor] CGColor];
    _lbl_res.layer.borderWidth = 1;
    [self.view addSubview:_lbl_res];
    _lbl_res.text = [NSString stringWithFormat:@"您扫描的条形码结果如下： %@",_qrcodeRes];

    // 补药
    _inputView = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lbl_res.frame) + 20, ScreenW - 50, 30)];
    _inputView.placeholder = @"数量";
    //_inputView.textColor = [UIColor greenColor];
    _inputView.borderStyle = UITextBorderStyleRoundedRect;
    _inputView.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_inputView];
    
    UIButton *addMedicineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addMedicineBtn setTitle:@"补药" forState:UIControlStateNormal];
    addMedicineBtn.titleLabel.textColor = [UIColor greenColor];
    addMedicineBtn.backgroundColor = [UIColor orangeColor];
    addMedicineBtn.frame = CGRectMake(ScreenW - 50, CGRectGetMaxY(_lbl_res.frame) + 20, 50, 30);
    [addMedicineBtn addTarget:self action:@selector(ReqAddMedicine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMedicineBtn];

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

@end
