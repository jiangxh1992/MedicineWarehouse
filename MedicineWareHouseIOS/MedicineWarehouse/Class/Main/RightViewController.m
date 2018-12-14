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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务器配置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self SetSocketListener];
    //[XHNetGlobal.Ins ClientSocketConnect];
    _lbl_res.text = @"";
    _lbl_msg.text = @"";
    if(XHNetGlobal.Ins.isSocketConected) _lbl_msg.text = @"服务器已连接";
    
    //UIBarButtonItem *login = [[UIBarButtonItem alloc] initWithTitle:@"账号登录" style:UIBarButtonItemStyleDone target:self action:@selector(Login)];
    //self.navigationItem.rightBarButtonItem = login;
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

- (void)Login{
    [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
}

- (IBAction)ConnetServer {
    if(!XHNetGlobal.Ins.isSocketConected){
        XHNetGlobal.Ins.serverIP = _inputIP.text;
        XHNetGlobal.Ins.serverPort = [_inputPort.text intValue];
        [XHNetGlobal.Ins ClientSocketConnect];
        [XHNetGlobal.Ins.clientSocket readDataWithTimeout:-1 tag:0];
    }
}

- (IBAction)DisConnectServer {
    if(XHNetGlobal.Ins.isSocketConected){
        [XHNetGlobal.Ins.clientSocket disconnect];
    }
}

- (IBAction)SendMessage {
    NSDictionary *dic = @{@"type":@0,
                          @"status":@0,
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
