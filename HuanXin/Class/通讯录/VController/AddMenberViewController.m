//
//  AddMenberViewController.m
//  HuanXin
//
//  Created by CCP on 16/8/29.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "AddMenberViewController.h"
#import <EaseMob.h>
#import <EMChatManagerBuddyDelegate.h>

@interface AddMenberViewController ()<IChatManagerDelegate>

@end

@implementation AddMenberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(ChatScreenWidth-50-10, 28, 50, 30);
    btn.backgroundColor=[UIColor clearColor];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment=NSTextAlignmentRight;
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem=back;
    [self.navigationBar addSubview:btn];
    
}

-(void)rightBtnClick:(UIButton *)button{
    
    if ([self.textFBtn.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入联系人账号" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    self.menberLabel.text=self.textFBtn.text;
    self.menberView.hidden=NO;
}


- (IBAction)addMenber:(UIButton *)sender {
    
    EMError *error;
    
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:self.menberLabel.text message:@"我想加您为好友" error:&error];
    
    
    if (isSuccess && !error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息已发送，等待对方验证" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSLog(@"添加成功");
    }

}

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
