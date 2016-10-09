//
//  AppDelegate.m
//  HuanXin
//
//  Created by CCP on 16/9/3.
//  Copyright (c) 2016年 CCP. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabViewController.h"
#import "ViewController.h"

@interface AppDelegate ()<IChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"futongdai#futongdaitt" apnsCertName:@"kulianxia"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];//实现代理
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];//获取好友

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fistVeiwController) name:@"fistVCN" object:nil];
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];//状态栏设成白色
    
    // 自动登录
    if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        
        [ProgressHUD showLoadingWithMessage:@"自动登录中..."];
   //     [MBProgressHUD showMessag:@"正在登录" toView:self.window];
//        [self fistVeiwController];
    }else{
        return YES;
    }
    

    return YES;
}

/*
//接收到添加好友请求
-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"username",message,@"message", nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:dic forKey:@"dic"];
    
    [userDefaults synchronize];
    
    NSString *title = [NSString stringWithFormat:@"来自%@的好友申请",username];
    UIAlertController *alterController = [YCCommonCtrl commonAlterControllerWithTitle:title message:message];
    [self.window.rootViewController presentViewController:alterController animated:YES completion:nil];


}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        NSLog(@"sdf");
    }
}


-(void)fistVeiwController{
    UIStoryboard *mainsb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MyTabViewController *fir=[mainsb instantiateViewControllerWithIdentifier:@"MyTabViewController"];
    self.window.rootViewController=fir;
}

-(void)logOut{
    
    ViewController *logout =[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
    self.window.rootViewController = logout;
    // 退出登录成功之后  不能在设置自动登录
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
}

#pragma mark - EMChatManagerDelegate
- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    NSLog(@"即将自动登录");
}

- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
 //   [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
    // 切换控制器
   
     [ProgressHUD dismess];
    if (error) {
       
        ViewController *logout =[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
        self.window.rootViewController = logout;

    }else{
        [self fistVeiwController];
        [ProgressHUD showMessageSuccess:@"自动登录成功"];
        
        [[NSUserDefaults standardUserDefaults] setObject:loginInfo[@"username"] forKey:@"username"];
        
    }
    

    
    NSLog(@"%@",error);
    
    NSLog(@"自动登录成功");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   [[EaseMob sharedInstance] applicationDidEnterBackground:application];}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  [[EaseMob sharedInstance] applicationWillEnterForeground:application];}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
   [[EaseMob sharedInstance] applicationWillTerminate:application];
}

@end
