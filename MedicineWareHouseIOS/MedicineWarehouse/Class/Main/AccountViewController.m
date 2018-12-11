//
//  AccountViewController.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/12/11.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()
@property(nonatomic, weak) IBOutlet UILabel *username;
@end

@implementation AccountViewController

- (void)viewDidAppear:(BOOL)animated{
    _username.text = XHGlobalAccount.Ins.account.username;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)Logout{
    XHGlobalAccount.Ins.isLogin = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
