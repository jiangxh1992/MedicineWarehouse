//
//  LoginViewController.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/25.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "LoginViewController.h"
#import "SignInViewController.h"
#import "AccountViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated{
    _tip.text = @"";
    XHNetGlobal.Ins.socketDidReadDta = ^(NSDictionary * _Nullable data) {
        self->_tip.text = [data mj_JSONString];
        if(data){
            int type = [[data objectForKey:@"type"] intValue];
            if(type == XHSocketRequestTypeLogin){
                int status = [[data objectForKey:@"status"] intValue];
                if(status == 0) {
                    //self->_tip.text = @"登录成功";
                    XHShowMsg(@"登录成功");
                    XHGlobalAccount.Ins.isLogin = YES;
                    XHGlobalAccount.Ins.account.username = [data objectForKey:@"name"];
                    [self.navigationController pushViewController:[[AccountViewController alloc] init] animated:YES];
                    //[self.navigationController popToRootViewControllerAnimated:YES];
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
    self.title = @"账号";
    
    //[XHNetGlobal.Ins ClientSocketConnect];
    if(XHGlobalAccount.Ins.isLogin){
        [self.navigationController pushViewController:[[AccountViewController alloc] init] animated:YES];
    }
}

- (IBAction)Login {
    if([_password.text  isEqualToString: @""]){
        //_tip.text = @"密码输入不能为空";
        XHShowMsg(@"密码输入不能为空");
        return;
    }
    
    NSDictionary *param = @{@"type":@0,
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

- (IBAction)SignIn {
    [self.navigationController pushViewController:[[SignInViewController alloc] init] animated:YES];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
}

@end
