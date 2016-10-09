//
//  MeViewController.m
//  HuanXin
//
//  Created by CCP on 16/9/12.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "MeViewController.h"
#import "EaseMob.h"
#import "ViewController.h"

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.backImage.hidden = YES;
    
    XMGNButton *logout = [XMGNButton buttonWithType:UIButtonTypeCustom];
    logout.frame =  CGRectMake(50,100, self.view.frame.size.width - 100, 40);
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    logout.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:21.0f];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logout.block = ^(XMGNButton *button){
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            if (error && error.errorCode != EMErrorServerNotLogin) {
                
            }
            else{
                AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                [app logOut];
                
            }
        }  onQueue:nil];

    };
    
    logout.backgroundColor = [UIColor redColor];
    [self.view addSubview:logout];

}


@end
