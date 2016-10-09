//
//  FriendListViewController.m
//  HuanXin
//
//  Created by CCP on 16/8/29.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "FriendListViewController.h"
#import "NewFrendViewController.h"
#import "EaseMob.h"
#import "EMError.h"
#import <objc/runtime.h>
#import "IChatViewController.h"
#import "IChatGroupViewController.h"

#import "FriendApplyViewController.h"

@interface FriendListViewController ()<IChatManagerDelegate,EMChatManagerDelegate>
@property (nonatomic,strong)NSMutableArray *addFriendArray;
@end

@implementation FriendListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self loadFrendList];
}

-(void)frendList:(NSArray *)array{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backImage.hidden = YES;
    self.title = @"通讯录";
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(ChatScreenWidth-80-10, 28, 80, 30);
    btn.backgroundColor=[UIColor clearColor];
    [btn setTitle:@"添加好友" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment=NSTextAlignmentRight;
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:btn];
//    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem=back;
    
    
    // 设置代理方法
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];//实现代理
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];//获取好友
    
    _frendArray=[NSMutableArray array];
    
    NSArray  *message = objc_getAssociatedObject(self.tabBarController, @"tabbarLink");
    objc_setAssociatedObject(self.tabBarController, @"tabbarLink", nil, OBJC_ASSOCIATION_ASSIGN);
    
    NSString *msg =@"申请与通知";
    if (message.count>0) {
        for (NSString *str in message) {
            [self.addFriendArray addObject:str];
        }
        msg = [NSString stringWithFormat:@"申请与通知(您有%ld个好友申请)",message.count];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addBadgeNotification" object:nil];
    }
    
    _teamArray=[[NSMutableArray alloc]initWithObjects:msg,@"群聊",@"聊天室", nil];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
   // [self loadFrendList];
}

-(void)loadFrendList{
    // 从本地获取好友列表
    self.frendArray = [[EaseMob sharedInstance].chatManager buddyList];
    if (self.frendArray.count == 0) {
        // 从服务器上获取到的好友列表
        [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
            self.frendArray = buddyList;
            [self.tableView reloadData];
        } onQueue:nil];
    }
  [self.tableView reloadData];
}

-(void)rightBtnClick:(UIButton *)button{
    [self performSegueWithIdentifier:@"AddMenberViewController" sender:nil];
    
}

- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd
{
    NSString *str = isAdd ? @"添加的":@"删除的";
    NSLog(@"添加或者是删除  = %@",str);
    self.frendArray = buddyList;
    [self.tableView reloadData];
}


// 好友同意添加的回调
- (void)didAcceptBuddySucceed:(NSString *)username
{
    NSLog(@"同意添加好友成功%@",username);
}

// 当前用户被别人移除的时候调用
- (void)didRemovedByBuddy:(NSString *)username
{
    NSLog(@"我被%@删除",username);
}

//接收到好友的请求
-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    NSLog(@"%@",username);
    NSLog(@"%@",message);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _teamArray.count;
    }else{
        return _frendArray.count;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMBuddy *buddy = self.frendArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:nil];
        if (isSuccess) {
            [ProgressHUD showMessageSuccess:@"删除好友成功"];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *_Cell=@"indentify";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:_Cell];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_Cell];
    }
    if (indexPath.section == 0) {
        
        cell.textLabel.text=_teamArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"groupPublicHeader"];
    }else{
        
        EMBuddy *eMBuddy = [_frendArray objectAtIndex:indexPath.row];
        cell.textLabel.text = eMBuddy.username;
        cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
        
    }
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *headerSectionID = @"headerSectionID";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
    UILabel *label;
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerSectionID];
        label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
        label.font = [UIFont systemFontOfSize:13];
        [headerView addSubview:label];
    }
    if (section == 0) {
        label.text = @"我的群组";
    }else {
        label.text = @"我的好友";
    }
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __block FriendListViewController *weak = self;
    
    if (indexPath.section == 1) {

            IChatViewController *chat = [[IChatViewController alloc]initWithIsGroup:NO];
            [chat setHidesBottomBarWhenPushed:YES];
            chat.budddy = self.frendArray[indexPath.row];
            [self.navigationController pushViewController:chat animated:YES];

        
    }else{
        if (indexPath.row == 0) {
            FriendApplyViewController *sysVC = [[FriendApplyViewController alloc] init];
            [sysVC setHidesBottomBarWhenPushed:YES];
            if (self.addFriendArray.count >0) {
                sysVC.friendArray = self.addFriendArray;
            }

            [self.navigationController pushViewController:sysVC animated:YES];
            
            sysVC.backBlock = ^(NSMutableArray *ary){
                [weak updataTableList:ary];
            };

        }else if (indexPath.row ==1){
            IChatGroupViewController *group = [[IChatGroupViewController alloc]init];
            [group setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:group animated:YES];

        }
    }
}


-(void)updataTableList:(NSMutableArray *)array{
    if (array.count == 0) {
        _teamArray=[[NSMutableArray alloc]initWithObjects:@"申请与通知",@"群聊",@"聊天室", nil];
    }else{
       NSString *msg = [NSString stringWithFormat:@"申请与通知(您有%ld个好友申请)",array.count];
     _teamArray=[[NSMutableArray alloc]initWithObjects:msg,@"群聊",@"聊天室", nil];
    }
    
    [self.tableView reloadData];

}

-(NSMutableArray *)addFriendArray{
    if (!_addFriendArray) {
        _addFriendArray = [NSMutableArray new];
    }
    return _addFriendArray;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isEqualToString:@"NewFrendViewController"]) {
        NewFrendViewController *nF=segue.destinationViewController;
        nF.testString=@"test";
    }//else if (<#expression#>)
    //AddMenberViewController
    
}


-(void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

@end
