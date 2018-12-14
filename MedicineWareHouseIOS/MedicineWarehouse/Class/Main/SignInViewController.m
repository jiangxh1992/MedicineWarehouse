//
//  SignInViewController.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/25.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidAppear:(BOOL)animated{
    _tip.text = @"";
    XHNetGlobal.Ins.socketDidReadDta = ^(NSDictionary * _Nullable data) {
        self->_tip.text = [data mj_JSONString];
        if(data){
            int type = [[data objectForKey:@"type"] intValue];
            if(type == XHSocketRequestTypeSignIn){
                int status = [[data objectForKey:@"status"] intValue];
                if(status == 0) {
                    //self->_tip.text = @"注册成功";
                    XHShowMsg(@"注册成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    self->_tip.text = [data objectForKey:@"content"];
                }
            }
        }
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
    
    //[XHNetGlobal.Ins ClientSocketConnect];
}

- (IBAction)SignIn {
    if(![_password.text isEqualToString:_passwordconfirm.text]){
        //_tip.text = @"两次密码输入不一致";
        XHShowMsg(@"两次密码输入不一致");
        return;
    }
    
    if([_password.text  isEqualToString: @""] || [_passwordconfirm.text  isEqualToString: @""]){
        //_tip.text = @"密码输入不能为空";
        XHShowMsg(@"密码输入不能为空");
        return;
    }
    
    NSDictionary *param = @{@"type":@100,
                            @"name":_username.text,
                            @"password":_password.text
                            };
    if(!XHNetGlobal.Ins.isSocketConected){
        //_tip.text = @"服务器未连接";
        XHShowMsg(@"服务器未连接");
        return;
    }
    [XHNetGlobal ClientSocketSend:[param mj_JSONString]];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    [_passwordconfirm resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
