//
//  ViewController.m
//  HuanXin
//
//  Created by CCP on 15/10/22.
//  Copyright (c) 2015年 CCP. All rights reserved.
//

#import "ViewController.h"
#import "IChatRegisterController.h"

@interface ViewController ()<EMChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *testF_userName;

@property (weak, nonatomic) IBOutlet UITextField *testF_passWord;

@end

@implementation ViewController

//注册
//- (IBAction)regester:(UIButton *)sender {
//    IChatRegisterController *regi = [[IChatRegisterController alloc]init];
//    [self.navigationController pushViewController:regi animated:YES];
//}

//登陆
- (IBAction)loginIn:(UIButton *)sender {
    /*
     *注册过可以用的号：13812121212：密码：123456
     13012121212，密码：123456
     13412121212  123456
     135
     */
//  
    if (_testF_userName.text.length==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入用户名" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (_testF_passWord.text.length==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
//    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请注册" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
//    
//    if (![[NSUserDefaults standardUserDefaults]objectForKey:_testF_userName.text]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码错误" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }

//    _testF_userName.text = @"13012121212";
//    _testF_passWord.text = @"123456";
    [self.view endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
     [MBProgressHUD showMessag:@"正在登录" toView:window];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_testF_userName.text password:_testF_passWord.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆成功" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
//            [alert show];
            
            [ProgressHUD showMessageSuccess:@"登陆成功"];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"fistVCN" object:nil];
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            [[NSUserDefaults standardUserDefaults] setObject:_testF_userName.text forKey:@"username"];
            NSLog(@"登陆成功");
        }else{
            [ProgressHUD showMessage:error.description];
            NSLog(@"%@",error);
        }
        [ProgressHUD dismess];
    } onQueue:nil];
    
    
    //12345678912
    //13027967839
    //13825452682
    
    /*
    //23456789123
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"12345678912" password:@"123456" completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆成功" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fistVCN" object:nil];
            NSLog(@"登陆成功");
        }
    } onQueue:nil];
     
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.testF_userName.text = @"13012121212";
    self.testF_passWord.text = @"123456";
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"wev"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"wev"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blueColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];
    
    // 添加代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
//    [ProgressHUD dismess];

}

// 登录成功代理方法
- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    // loginInfo:
    //    LastLoginTime = 1451183463240;
    //    jid = "xjcoder#xmg5easemob_xmg3@easemob.com";
    //    password = Xmg3;
    //    resource = mobile;
    //    token = "YWMt_VJVmqxAEeWi0Ktov3qQ5gAAAVMWPh76b8FMyXClc3o1dz-WuZNNWSi9qR8";
    //    username = xmg3;
    NSLog(@"userName = %@  password = %@",loginInfo[@"username"],loginInfo[@"password"]);
}

-(void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

@end
