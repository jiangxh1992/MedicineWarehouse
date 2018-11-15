//
//  ViewController.m
//  MedicineWarehouse
//
//  Created by xinhou on 2018/11/13.
//  Copyright © 2018 xinhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    XHNetGlobal.Ins.socketDidConnected = ^(NSString * _Nullable data) {
        self->_text.text = data;
    };
    XHNetGlobal.Ins.socketDidReadDta = ^(NSString * _Nullable data) {
        self->_output.text = data;
    };
    
    [XHNetGlobal.Ins.clientSocket connectToHost:@"10.246.149.17" onPort:8080 error:nil];
    [XHNetGlobal.Ins.clientSocket readDataWithTimeout:-1 tag:200];
}

- (IBAction)Go:(id)sender {
    /*
    NSDictionary *dic = @{@"id":@"987654321"};
    [XHNetGlobal.Ins POSTWithUrl:UrlMedicine param:dic success:^(id  _Nonnull json) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
     */
    if(XHNetGlobal.Ins.isSocketConected) {
        NSString *param = _input.text;
        [XHNetGlobal.Ins.clientSocket writeData:[param dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }
    else{
        [XHNetGlobal.Ins.clientSocket connectToHost:@"10.246.149.17" onPort:8080 error:nil];
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_input resignFirstResponder];
}

@end
