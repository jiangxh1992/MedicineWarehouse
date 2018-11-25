//
//  RightViewController.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/16.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()
@property(nonatomic, strong) UILabel *lbl_msg;
@property(nonatomic, strong) UITextField *inputIP;
@property(nonatomic, strong) UITextField *inputPort;
@property(nonatomic, strong) UITextView *textView;
@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理员";
    self.view.backgroundColor = [UIColor whiteColor];
    
    XHNetGlobal.Ins.socketDidConnected = ^(NSString * _Nullable data) {
        self->_lbl_msg.text = data;
    };
    XHNetGlobal.Ins.socketDidReadDta = ^(NSDictionary * _Nullable dic) {
        self->_lbl_msg.text = [dic mj_JSONString];
    };

    
    // tip
    _lbl_msg = [[UILabel alloc] init];
    _lbl_msg.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    _lbl_msg.textColor = [UIColor redColor];
    _lbl_msg.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lbl_msg];
    // 提示文字
    _lbl_msg.text = @"服务器未连接";
    
    _inputIP = [[UITextField alloc] initWithFrame:CGRectMake(0, ScreenH / 3, ScreenW - 100, 30)];
    _inputIP.placeholder = @"服务器IP";
    //_inputView.textColor = [UIColor greenColor];
    _inputIP.borderStyle = UITextBorderStyleRoundedRect;
    _inputIP.text = @"169.254.11.246";
    [self.view addSubview:_inputIP];
    
    _inputPort = [[UITextField alloc] initWithFrame:CGRectMake(_inputIP.frame.size.width, ScreenH / 3, 100, 30)];
    _inputPort.placeholder = @"端口号";
    _inputPort.borderStyle = UITextBorderStyleRoundedRect;
    _inputPort.keyboardType = UIKeyboardTypeNumberPad;
    _inputPort.text = @"8080";
    [self.view addSubview:_inputPort];

    UIButton *connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [connectBtn setTitle:@"重连服务器" forState:UIControlStateNormal];
    connectBtn.titleLabel.textColor = [UIColor greenColor];
    connectBtn.backgroundColor = [UIColor orangeColor];
    connectBtn.frame = CGRectMake(50, CGRectGetMaxY(_inputPort.frame) + 20, ScreenW - 100, 30);
    [connectBtn addTarget:self action:@selector(ConnetServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectBtn];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxX(connectBtn.frame) + 50, ScreenW - 10, 200) textContainer:nil];
    _textView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_textView];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.textColor = [UIColor greenColor];
    sendBtn.backgroundColor = [UIColor orangeColor];
    sendBtn.frame = CGRectMake(50, CGRectGetMaxY(_textView.frame) + 20, ScreenW - 100, 30);
    [sendBtn addTarget:self action:@selector(SendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    [self ConnetServer];
}

- (void)ConnetServer {
    if(!XHNetGlobal.Ins.isSocketConected){
        NSString *IP = _inputIP.text;
        int Port = [_inputPort.text intValue];
        [XHNetGlobal.Ins.clientSocket connectToHost:IP onPort:8080 error:nil];
        [XHNetGlobal.Ins.clientSocket readDataWithTimeout:-1 tag:0];
    }
}

- (void)SendMessage {
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
