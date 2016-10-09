//
//  IChatRegisterController.m
//  HuanXin
//
//  Created by CCP on 16/9/12.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "IChatRegisterController.h"

@interface IChatRegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *testF_userName;

@property (weak, nonatomic) IBOutlet UITextField *testF_passWord;

@end

@implementation IChatRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
   
}
- (IBAction)registerBtn:(UIButton *)sender {
    
    if ([_testF_userName.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机号码为空" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([_testF_userName.text length]<11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确手机号" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([_testF_passWord.text length]<6 || [_testF_passWord.text length]>11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入6~11位密码" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_testF_userName.text password:_testF_passWord.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            
            [[NSUserDefaults standardUserDefaults] setObject:_testF_userName.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:_testF_passWord.text forKey:_testF_userName.text];
            
            [ProgressHUD showMessageSuccess:@"注册成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"注册成功");
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已经注册过" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
            
        }
    } onQueue:nil];
    

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_testF_userName]) {
        
        //删除
        if ([string isEqualToString:@""] ){
            if(textField.text.length > 0) {
                return YES;
            } else {
                return NO;
            }
        } else {
            if (textField.text.length   >= 11) {
                //  [DXFAlertView showMessage:NSLocalizedStringFromTable(kTips_PhoneNoBeyondMaxLength, kTipsFile, nil) autoDismiss:YES];
                return NO;
            } else {
                return YES;
            }
        }
    } else {
        return YES;
    }
    
}

@end
