//
//  IChatGroupViewController.m
//  HuanXin
//
//  Created by CCP on 16/9/9.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "IChatGroupViewController.h"
#import "IChatViewController.h"

@interface IChatGroupViewController ()<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate>
/** 群组列表 */
@property (nonatomic, strong) NSMutableArray *groupArr;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL isOwner;
@end

@implementation IChatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XMGNButton *rightBtn = [XMGNButton createXMGButton];
    rightBtn.frame = CGRectMake(ChatScreenWidth - 80, 30, 60, 30);
    [rightBtn setTitle:@"创建群" forState:UIControlStateNormal];
    [self.navigationBar addSubview:rightBtn];
  //  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.title = @"我的群聊列表";
    self.isOwner = NO;
    
    // 显示数据
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ChatScreenWidth, ChatScreenHeight-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource =self;
    [tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    

    // 获取 群列表
    NSArray *arr = [[EaseMob sharedInstance].chatManager groupList];
    self.groupArr = [NSMutableArray arrayWithArray:arr];
    if (self.groupArr.count == 0) {
        // 从服务端获取群列表
        [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
            [self.groupArr addObjectsFromArray:groups];
            [tableView reloadData];

            
            NSLog(@"self.groupArr = %@",self.groupArr);
        } onQueue:nil];
    }
    

    
    rightBtn.block = ^(XMGNButton *btn){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"创建群" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入群名称";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"自我介绍";
        }];
        
        UITextField *groupNameFiled = [alert.textFields firstObject];
        UITextField *detailFiled = [alert.textFields lastObject];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //        @brief 群组类型
             //        @constant eGroupStyle_PrivateOnlyOwnerInvite 私有群组，只能owner权限的人邀请人加入
            //        @constant eGroupStyle_PrivateMemberCanInvite 私有群组，owner和member权限的人可以邀请人加入
            //        @constant eGroupStyle_PublicJoinNeedApproval 公开群组，允许非群组成员申请加入，需要管理员同意才能真正加入该群组
            //        @constant eGroupStyle_PublicOpenJoin         公开群组，允许非群组成员加入，不需要管理员同意
            //        @constant eGroupStyle_PublicAnonymous        公开匿名群组，允许非群组成员加入，不需要管理员同意
            //        @constant eGroupStyle_Default                默认群组类型
            //        @discussion
            //        eGroupStyle_Private：私有群组，只允许群组成员邀请人进入
            //        eGroupStyle_Public： 公有群组，允许非群组成员加入
            
             [ProgressHUD showLoadingWithMessage:@"创建中..."];
            
            EMGroupStyleSetting *groupSetting = [[EMGroupStyleSetting alloc]init];
            // 设置群里的类型
            groupSetting.groupStyle = eGroupStyle_PublicJoinNeedApproval;
            // 设置群组最多容纳多少人
            groupSetting.groupMaxUsersCount = 100;
            [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:groupNameFiled.text description:detailFiled.text invitees:@[@"13512121212",@"13412121212"] initialWelcomeMessage:@"欢迎光临" styleSetting:groupSetting completion:^(EMGroup *group, EMError *error) {
                 [ProgressHUD dismess];
                if (!error) {
                    NSLog(@"创建群组成功");
                    [ProgressHUD showMessageSuccess:@"创建群组成功"];
                    [self.groupArr addObject:group];
                    [tableView reloadData];
                }
            } onQueue:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    };
}

-(void)leaveGroupingroup:(NSIndexPath *)indexPath{
    UIAlertController *leaveGroup = [UIAlertController alertControllerWithTitle:@"您是群主" message:@"你要解散他吗：" preferredStyle:UIAlertControllerStyleAlert];
    
    [leaveGroup addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMGroup *group = self.groupArr[indexPath.row];
        
        [ProgressHUD showLoadingWithMessage:@"加载中..."];
        [[EaseMob sharedInstance].chatManager asyncDestroyGroup:group.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
            
            if (!error) {
                [self.groupArr removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                [ProgressHUD showMessageSuccess:@"解散成功"];
                
            }else{
                [ProgressHUD showMessageError:error.description];
            }
            [ProgressHUD dismess];
            
        } onQueue:nil];
    }]];
    
    [leaveGroup addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:leaveGroup animated:YES completion:nil];

}

-(void)leaveGroupinself:(NSIndexPath *)indexPath{
    UIAlertController *leaveGroup = [UIAlertController alertControllerWithTitle:@"您要退出该群" message:@"你确定吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [leaveGroup addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMGroup *group = self.groupArr[indexPath.row];
         [ProgressHUD showLoadingWithMessage:@"加载中..."];
        [[EaseMob sharedInstance].chatManager asyncLeaveGroup:group.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error){
            if (!error) {
                [self.groupArr removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                [ProgressHUD showMessageSuccess:@"退出成功"];
                
            }else{
                [ProgressHUD showMessageError:error.description];
            }
             [ProgressHUD dismess];
        } onQueue:nil];
    }]];
    
    [leaveGroup addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:leaveGroup animated:YES completion:nil];
}



#pragma mark -  tableview数据源方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        NSLog(@"%@",userName);
        
        EMGroup *group = self.groupArr[indexPath.row];
        NSArray *array = [[EaseMob sharedInstance].chatManager fetchOccupantList:group.groupId error:nil];
        if (array.count>0) {
            NSString *object = array[0];
            NSLog(@"%@",object);
            if ([object isEqualToString:userName]) {
                 [self leaveGroupingroup:indexPath];//是群主
                return;
            }
        }
        
        [self leaveGroupinself:indexPath];

        
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    EMGroup *group = self.groupArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",group.groupSubject];
    NSLog(@"%@",group.owner);
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IChatViewController *chatCtr = [[IChatViewController alloc]initWithIsGroup:YES];
    [chatCtr setHidesBottomBarWhenPushed:YES];
    chatCtr.group = self.groupArr[indexPath.row];
    
//    EMConversation *conversation = self.groupArr[indexPath.row];
//
//    chatCtr.budddy = [EMBuddy buddyWithUsername:conversation.chatter];
    [self.navigationController pushViewController:chatCtr animated:YES];
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
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
