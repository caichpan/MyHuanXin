//
//  NewFrendViewController.m
//  HuanXin
//
//  Created by CCP on 16/8/29.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "NewFrendViewController.h"

@interface NewFrendViewController ()

@end

@implementation NewFrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationItem.hidesBackButton=YES;
    _dataArray=[NSMutableArray array];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    //  self.tableView.userInteractionEnabled=NO;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"newFrend"]) {
        NSMutableArray *ar=[[NSUserDefaults standardUserDefaults] objectForKey:@"newFrend"];
        for (NSString *str in ar) {
            [_dataArray addObject:str];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *_Cell=@"indentify_cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:_Cell];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_Cell];
        
        UIButton *regect=[UIButton buttonWithType:UIButtonTypeCustom];
        regect.frame=CGRectMake(self.view.frame.size.width-50-50-10-5, 10, 50, 30);
        [regect setTitle:@"拒绝" forState:UIControlStateNormal];
        regect.backgroundColor=[UIColor cyanColor];
        [regect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        regect.tag=100+indexPath.row;
        [regect addTarget:self action:@selector(regectClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:regect];
        
        UIButton *agree=[UIButton buttonWithType:UIButtonTypeCustom];
        agree.frame=CGRectMake(CGRectGetMaxX(regect.frame)+5, 10, 50, 30);
        [agree setTitle:@"同意" forState:UIControlStateNormal];
        agree.backgroundColor=[UIColor grayColor];
        [agree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        agree.tag=10+indexPath.row;
        [agree addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:agree];
        
    }
    if (_dataArray.count > 0) {
        NSString *frend=_dataArray[indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@邀请你为好友",frend];
    }
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//拒绝好友请求
-(void)regectClick:(UIButton *)button{
    NSString *regect=_dataArray[button.tag-100];
    
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:regect reason:@"111111" error:&error];
    if (isSuccess && !error) {
        
        [_dataArray removeObjectAtIndex:button.tag-100];
        if (_dataArray.count == 0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newFrend"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:_dataArray forKey:@"newFrend"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self.tableView reloadData];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"拒绝好友成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        NSLog(@"发送拒绝成功");
    }
    
}

//同意好友请求
-(void)agreeClick:(UIButton *)button{
    NSString *agree=_dataArray[button.tag-10];
    
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:agree error:&error];
    if (isSuccess && !error) {
        [_dataArray removeObjectAtIndex:button.tag-10];
        if (_dataArray.count == 0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newFrend"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:_dataArray forKey:@"newFrend"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self.tableView reloadData];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"同意好友申请成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"发送同意成功");
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
