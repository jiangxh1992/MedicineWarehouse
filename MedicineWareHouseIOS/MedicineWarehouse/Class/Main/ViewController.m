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
    [self.view addSubview:_lbl_msg];
    
    // 扫描结果
    CGFloat label_Y = CGRectGetMaxY(_lbl_msg.frame);
    _lbl_res = [[UILabel alloc] init];
    _lbl_res.frame = CGRectMake(0, label_Y, self.view.frame.size.width, 30);
    _lbl_res.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbl_res];

    
    XHNetGlobal.Ins.socketDidConnected = ^(NSString * _Nullable data) {
        self->_lbl_msg.text = data;
    };
    XHNetGlobal.Ins.socketDidReadDta = ^(NSString * _Nullable data) {
        self->_lbl_res.text = data;
    };
    
    [XHNetGlobal.Ins.clientSocket connectToHost:@"10.246.149.17" onPort:8080 error:nil];
    [XHNetGlobal.Ins.clientSocket readDataWithTimeout:-1 tag:200];
}

- (void)Go:(id)sender {
    /*
    NSDictionary *dic = @{@"id":@"987654321"};
    [XHNetGlobal.Ins POSTWithUrl:UrlMedicine param:dic success:^(id  _Nonnull json) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
     */
    if(XHNetGlobal.Ins.isSocketConected) {
        NSString *param = @"test param";
        [XHNetGlobal.Ins.clientSocket writeData:[param dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }
    else{
        [XHNetGlobal.Ins.clientSocket connectToHost:@"10.246.149.17" onPort:5003 error:nil];
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[_input resignFirstResponder];
}

@end
