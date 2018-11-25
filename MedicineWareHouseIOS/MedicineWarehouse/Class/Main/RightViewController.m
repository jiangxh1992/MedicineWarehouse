//
//  RightViewController.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/16.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "RightViewController.h"
#import "LoginViewController.h"
@interface RightViewController ()
@property(nonatomic, strong) IBOutlet UILabel *lbl_res;
@property(nonatomic, strong) IBOutlet UILabel *lbl_msg;
@property(nonatomic, strong) IBOutlet UITextField *inputIP;
@property(nonatomic, strong) IBOutlet UITextField *inputPort;
@property(nonatomic, strong) IBOutlet UITextView *textView;
@end

@implementation RightViewController

- (void)viewDidAppear:(BOOL)animated {
    // 检查是否已经登陆
    if(!XHGlobalAccount.Ins.isLogin){
        [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
    else
    {
        [self SetSocketListener];
        [XHNetGlobal.Ins ClientSocketConnect];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理员";
    self.view.backgroundColor = [UIColor whiteColor];
    if(XHNetGlobal.Ins.isSocketConected) _lbl_msg.text = @"服务器已连接";
}

// 设置socket服务器监听
- (void)SetSocketListener {
    XHNetGlobal.Ins.socketDidConnected = ^(NSString * _Nullable data) {
        self->_lbl_msg.text = data;
    };
    XHNetGlobal.Ins.socketDidReadDta = ^(NSDictionary * _Nullable dic) {
        self->_lbl_res.text = [dic mj_JSONString];
    };
}

- (IBAction)ConnetServer {
    if(!XHNetGlobal.Ins.isSocketConected){
        NSString *IP = _inputIP.text;
        //int Port = [_inputPort.text intValue];
        [XHNetGlobal.Ins.clientSocket connectToHost:IP onPort:8080 error:nil];
        [XHNetGlobal.Ins.clientSocket readDataWithTimeout:-1 tag:0];
    }
}

- (IBAction)DisConnectServer {
    if(XHNetGlobal.Ins.isSocketConected){
        [XHNetGlobal.Ins.clientSocket disconnect];
    }
}

- (IBAction)SendMessage {
    NSDictionary *dic = @{@"status":@0,
                          @"content":@"",
                          @"id":@"12345",
                          @"bh":@"007",
                          @"ypmc":@"huangshi",
                          @"ypid":@"3575982",
                          @"ph":@"01-031-02",
                          @"storge":@5000,
                          @"need":@1,
                          @"zt":@"normal",
                          };
    [XHNetGlobal ClientSocketSend:[dic mj_JSONString]];
    //[XHNetGlobal ClientSocketSend:_textView.text];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    [_inputIP resignFirstResponder];
    [_inputPort resignFirstResponder];
}

@end
