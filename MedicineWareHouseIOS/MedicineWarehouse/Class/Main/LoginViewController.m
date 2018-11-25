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
    };
    [XHNetGlobal.Ins ClientSocketConnect];
}

- (IBAction)Login {
    NSDictionary *param = @{@"username":_username.text,
                            @"password":_password.text
                            };
    [XHNetGlobal ClientSocketSend:[param mj_JSONString]];
    XHGlobalAccount.Ins.isLogin = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)SignIn {
    [self.navigationController pushViewController:[[SignInViewController alloc] init] animated:YES];
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
