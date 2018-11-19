//
//  ScanSuccessJumpVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 16/8/29.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "ScanSuccessJumpVC.h"

@interface ScanSuccessJumpVC ()
@property (nonatomic, strong) UILabel *lbl_msg;
@property (nonatomic, strong) UILabel *lbl_res;
@end

@implementation ScanSuccessJumpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItem];
    
    _lbl_msg = [[UILabel alloc] init];
    _lbl_msg.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    _lbl_msg.textColor = [UIColor redColor];
    _lbl_msg.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbl_msg];
    
    // 扫描结果
    CGFloat label_Y = CGRectGetMaxY(_lbl_msg.frame);
    _lbl_res = [[UILabel alloc] init];
    _lbl_res.frame = CGRectMake(0, label_Y, self.view.frame.size.width, 300);
    _lbl_res.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbl_res];
    
    [self setupLabel];
    
    UIButton *addMedicineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addMedicineBtn setTitle:@"补药(10)" forState:UIControlStateNormal];
    addMedicineBtn.titleLabel.textColor = [UIColor greenColor];
    addMedicineBtn.backgroundColor = [UIColor orangeColor];
    addMedicineBtn.frame = CGRectMake(0, CGRectGetMaxY(_lbl_res.frame), ScreenW, 30);
    [addMedicineBtn addTarget:self action:@selector(ReqAddMedicine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMedicineBtn];

    
    XHNetGlobal.Ins.socketDidConnected = ^(NSString * _Nullable data) {
        self->_lbl_msg.text = data;
    };
    XHNetGlobal.Ins.socketDidReadDta = ^(NSDictionary * _Nullable dic) {
        if(dic){
                if([dic objectForKey:@"status"] == 0){
                NSString *info = [NSString stringWithFormat:@"药品名称：%@\n药品批号：%@\n库存：%d\n需要补药：%@\n单元机运行状态：%@",[dic objectForKey:@"ypmc"],[dic objectForKey:@"ph"],(int)[dic objectForKey:@"storage"],[dic objectForKey:@"need"],[dic objectForKey:@"zt"]];
                self->_lbl_res.text = info;
            }
            else{
                self->_lbl_res.text = [NSString stringWithFormat:@"请求失败：%@",[dic objectForKey:@"content"]];
            }
        }
    };
    [self OnloadResult];
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
// 添加Label，加载扫描过来的内容
- (void)setupLabel {
    // 提示文字
    _lbl_msg.text = @"您扫描的条形码结果如下： ";
    // 扫描结果
    _lbl_res.text = _qrcodeRes;
}

- (void)OnloadResult {
    if(XHNetGlobal.Ins.isSocketConected) {
        
        ParamBase *param = [ParamBase param];
        param.medicine_id = _qrcodeRes;
        NSString *paramstr = [param mj_JSONString];
        [XHNetGlobal ClientSocketSend:paramstr];
        _lbl_msg.text = [NSString stringWithFormat:@"参数已经发送：%@",paramstr];
    }
    else{
        [XHNetGlobal.Ins ClientSocketConnect];
        _lbl_msg.text = @"服务器断开请重试";
    }
}

- (void)ReqAddMedicine{
    ParamBase *param = [ParamBase param];
    param.type = 2;
    param.medicine_id = _qrcodeRes;
    param.num = 10;
    NSString *paramstr = [param mj_JSONString];
    [XHNetGlobal ClientSocketSend:paramstr];
}

@end
