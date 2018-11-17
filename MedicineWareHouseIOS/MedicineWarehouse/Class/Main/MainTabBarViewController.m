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
    leftNavController.tabBarItem.title = @"左";
    leftNavController.tabBarItem.image = [UIImage imageNamed:@"home"];
    [self addChildViewController:leftNavController];
    
    ViewController *rightViewController = [[ViewController alloc] init];
    UINavigationController *rightNavController = [[UINavigationController alloc] initWithRootViewController:rightViewController];
    rightNavController.tabBarItem.title = @"右";
    rightNavController.tabBarItem.image = [UIImage imageNamed:@"home"];
    [self addChildViewController:rightNavController];
    
    // 底部导航选中后内容颜色
    self.tabBar.tintColor = RGBColor(28, 190, 164);
    
    if(!XHNetGlobal.Ins.isSocketConected)
        [XHNetGlobal.Ins.clientSocket connectToHost:@"10.246.149.17" onPort:5003 error:nil];
    XHNetGlobal.Ins.socketDidConnected = ^(NSString * _Nullable data) {
        
    };
    XHNetGlobal.Ins.socketDidReadDta = ^(NSString * _Nullable data) {
        
    };
}

@end
