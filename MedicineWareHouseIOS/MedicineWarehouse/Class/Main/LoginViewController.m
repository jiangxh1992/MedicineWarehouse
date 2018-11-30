//
//  LoginViewController.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/25.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "LoginViewController.h"
#import "SignInViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    _tip.text = @"";
    XHNetGlobal.Ins.socketDidReadDta = ^(NSDictionary * _Nullable data) {
        self->_tip.text = [data mj_JSONString];
        if(data){
            int type = [[data objectForKey:@"type"] intValue];
            if(type == XHSocketRequestTypeLogin){
                int status = [[data objectForKey:@"status"] intValue];
                if(status == 0) {
                    self->_tip.text = @"登录成功";
                    XHGlobalAccount.Ins.isLogin = YES;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else{
                    self->_tip.text = [data objectForKey:@"content"];
                }
            }
                
        }
    };
    [XHNetGlobal.Ins ClientSocketConnect];
}

- (IBAction)Login {
    if([_password.text  isEqualToString: @""] || [_passwordconfirm.text  isEqualToString: @""]){
        _tip.text = @"密码输入不能为空";
        return;
    }
    
    NSDictionary *param = @{@"type":@0,
                            @"name":_username.text,
                            @"password":_password.text
                            };
    [XHNetGlobal ClientSocketSend:[param mj_JSONString]];
}

- (IBAction)SignIn {
    [self.navigationController pushViewController:[[SignInViewController alloc] init] animated:YES];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
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
