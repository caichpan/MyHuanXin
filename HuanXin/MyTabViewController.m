//
//  MyTabViewController.m
//  HuanXin
//
//  Created by CCP on 15/11/3.
//  Copyright © 2015年 CCP. All rights reserved.
//

#import "MyTabViewController.h"
#import <EaseMob.h>

@interface MyTabViewController ()//<IChatManagerDelegate>

@end

@implementation MyTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   //  [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];

}
//
//-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
//    
//        UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
//        item.badgeValue=@"1";
//    NSLog(@"%@",message);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
