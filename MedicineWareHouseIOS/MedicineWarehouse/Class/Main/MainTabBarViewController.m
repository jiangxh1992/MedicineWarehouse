//
//  MainTabBarViewController.m
//  YiFuLibrary
//
//  Created by txbydev3 on 15/9/22.
//  Copyright © 2015年 Jiangxh. All rights reserved.
//
/**************************************
 *这个类用来作为主页面底部导航
 **************************************/

#import "MainTabBarViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "LoginViewController.h"
#import "ViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

/**
 * 视图加载
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    /*添加导航子视图*/
    LeftViewController *leftViewController = [[LeftViewController alloc] init];
    UINavigationController *leftNavController = [[UINavigationController alloc] initWithRootViewController:leftViewController];
    leftNavController.tabBarItem.title = @"二维码";
    leftNavController.tabBarItem.image = [UIImage imageNamed:@"home"];
    [self addChildViewController:leftNavController];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    loginNavController.tabBarItem.title = @"账号";
    loginNavController.tabBarItem.image = [UIImage imageNamed:@"home"];
    [self addChildViewController:loginNavController];
    
    RightViewController *rightViewController = [[RightViewController alloc] init];
    UINavigationController *rightNavController = [[UINavigationController alloc] initWithRootViewController:rightViewController];
    rightNavController.tabBarItem.title = @"服务器";
    rightNavController.tabBarItem.image = [UIImage imageNamed:@"home"];
    [self addChildViewController:rightNavController];
    
    // 底部导航选中后内容颜色
    self.tabBar.tintColor = RGBColor(28, 190, 164);
    
    //[XHNetGlobal.Ins ClientSocketConnect];
}

@end
