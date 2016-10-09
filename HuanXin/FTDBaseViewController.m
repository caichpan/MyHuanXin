//
//  FTDBaseViewController.m
//  FuTongDai
//
//  Created by CCP on 16/6/20.
//  Copyright © 2016年 OFIM. All rights reserved.
//

#import "FTDBaseViewController.h"

@interface FTDBaseViewController ()
@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation FTDBaseViewController

-(void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    _navigationBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64.0f)];
    _navigationBar.image = [UIImage imageNamed:@"topbarbg_ios7"];
    _navigationBar.userInteractionEnabled = YES;
//    _navigationBar.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_navigationBar];
    
    _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 32, 11, 17)];
    _backImage.image = [UIImage imageNamed:@"navigationBackIcon"];
    [_navigationBar addSubview:_backImage];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 0, 70, 64);
    [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _backButton.backgroundColor = [UIColor clearColor];
    [_navigationBar addSubview:_backButton];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 54)];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:20];
    _titleLabel.text = @"";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navigationBar addSubview:_titleLabel];

}

-(void)backButtonClick:(UIButton *)button{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
