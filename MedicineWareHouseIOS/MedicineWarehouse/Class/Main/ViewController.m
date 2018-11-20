//
//  ViewController.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/13.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UILabel *lbl_msg;
@property (nonatomic, strong) UILabel *lbl_res;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:RGBAColor(30, 50, 60, 0.5)];
    button.frame = self.view.frame;
    [button addTarget:self action:@selector(Go:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _lbl_msg = [[UILabel alloc] init];
    _lbl_msg.frame = CGRectMake(0, 200, self.view.frame.size.width, 30);
    _lbl_msg.textColor = [UIColor redColor];
    _lbl_msg.textAlignment = NSTextAlignmentCenter;
    _lbl_msg.textColor = [UIColor redColor];
    _lbl_msg.text = @"等待服务器链接...";
    [self.view addSubview:_lbl_msg];
    
    CGFloat label_Y = CGRectGetMaxY(_lbl_msg.frame);
    _lbl_res = [[UILabel alloc] init];
    _lbl_res.frame = CGRectMake(0, label_Y, self.view.frame.size.width, 30);
    _lbl_res.textAlignment = NSTextAlignmentCenter;
    _lbl_res.textColor = [UIColor redColor];
    _lbl_res.text = @"服务器返回数据：...";
    [self.view addSubview:_lbl_res];

    
    XHNetGlobal.Ins.socketDidConnected = ^(NSString * _Nullable data) {
        self->_lbl_msg.text = data;
    };
    XHNetGlobal.Ins.socketDidReadDta = ^(NSDictionary * _Nullable data) {
        self->_lbl_res.text = [data mj_JSONString];
    };
    [XHNetGlobal.Ins ClientSocketConnect];
}

- (void)Go:(id)sender {
    if(XHNetGlobal.Ins.isSocketConected) {
        NSString *param = @"test param";
        [XHNetGlobal.Ins.clientSocket writeData:[param dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }
    else{
        [XHNetGlobal.Ins ClientSocketConnect];
    }
}


@end
