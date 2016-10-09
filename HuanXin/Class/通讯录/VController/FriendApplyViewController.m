//
//  FriendApplyViewController.m
//  HuanXin
//
//  Created by CCP on 16/9/12.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "FriendApplyViewController.h"

@interface FriendApplyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation FriendApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请与通知";
    NSLog(@"%@",self.friendArray);
    
    if (self.friendArray.count == 0) {
        [ProgressHUD showMessageError:@"您暂无好友请求"];
        return;
    }
    
    
    // 1. 创建tableview
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ChatScreenWidth, ChatScreenHeight - 64 - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];

}


#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        UIButton *btnAccept = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-140, 10.0, 60, 35.0)];
        [btnAccept setTag:100];
        [cell.contentView addSubview:btnAccept];
        
        UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, 10.0, 60, 35.0)];
        [btnCancel setTag:101];
        [cell.contentView addSubview:btnCancel];
        
        UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 55)];
        [messageLabel setTag:102];
        messageLabel.textColor =[UIColor blackColor];
        messageLabel.numberOfLines = 0;
        [cell.contentView addSubview:messageLabel];
    }
    
    if (self.friendArray.count > 0) {
        UILabel *label = (UILabel *)[cell viewWithTag:102];
        NSString *msg = self.friendArray[indexPath.row];
        label.text =[NSString stringWithFormat:@"来自%@的家伙想添加你为好友",msg];
    }
    
    UIButton *btnAccept = (UIButton *)[cell viewWithTag:100];
    [btnAccept setTitle:@"同意" forState:UIControlStateNormal];
    [btnAccept setBackgroundColor:[UIColor blueColor]];

    [btnAccept addTarget:self action:@selector(btnAccept:) forControlEvents:UIControlEventTouchUpInside];
    btnAccept.tag = indexPath.row;
  //  [YCCommonCtrl setViewBorderWithView:btnAccept borderColor:kColor_Blue borderWidth:1.0f cornerRadius:5.0f];
    
    UIButton *btnCancel = (UIButton *)[cell viewWithTag:101];
    [btnCancel setTitle:@"拒绝" forState:UIControlStateNormal];
    [btnCancel setBackgroundColor:[UIColor cyanColor]];
 //   [btnCancel setBackgroundImage:[YCCommonCtrl imageWithColor:kColor_Blue] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.tag = indexPath.row;
//    [YCCommonCtrl setViewBorderWithView:btnCancel borderColor:kColor_Blue borderWidth:1.0f cornerRadius:5.0f];
    
    return cell;
}


#pragma mark - Private Menthods

- (void)btnAccept:(UIButton *)sender
{
    
    NSInteger tag = sender.tag;
    NSString *name = self.friendArray[tag];
    
    //同意好友请求
    [[EaseMob sharedInstance].chatManager acceptBuddyRequest:name error:nil];
    
    [self.friendArray removeObjectAtIndex:tag];
    [self.tableView reloadData];
}

- (void)btnCancel:(UIButton *)sender
{
    
    NSInteger tag = sender.tag;
    NSString *name = self.friendArray[tag];
    //拒绝好友请求
    [[EaseMob sharedInstance].chatManager rejectBuddyRequest:name reason:@"不认识你" error:nil];
    
    [self.friendArray removeObjectAtIndex:tag];
    [self.tableView reloadData];
    
}


@end
