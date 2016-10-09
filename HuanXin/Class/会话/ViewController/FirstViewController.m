//
//  FirstViewController.m
//  HuanXin
//
//  Created by CCP on 15/11/3.
//  Copyright © 2015年 CCP. All rights reserved.
//

#import "FirstViewController.h"
#import "IChatViewController.h"
#import <objc/runtime.h>

@interface FirstViewController ()<IChatManagerDelegate,EMChatManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int badge;
}
@property (nonatomic,strong)NSMutableArray *frendBuddyArray;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *conversations;

/** tableview */
@property (nonatomic, weak) UITableView *m_tableView;
@end

@implementation FirstViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadConversation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"聊天";
    self.backImage.hidden = YES;
    badge = 0;

    // 创建tableview
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 66, ChatScreenWidth, ChatScreenHeight-66) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.m_tableView = tableView;
    [self.m_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
   
    [self loadConversation];
    
//    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
//    item.badgeValue=@"1";
}

- (void)loadConversation
{
    [self.conversations removeAllObjects];
    // 从本地获取
    //    NSArray *tempArr = [[EaseMob sharedInstance].chatManager conversations];
    //    self.conversations = [NSMutableArray arrayWithArray:tempArr];
    // 获取所有会话
    //    if (self.conversations.count == 0) {
    NSArray *loadArr = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    // 应该是使用添加数组的方式
    self.conversations = [NSMutableArray arrayWithArray:loadArr];
    //    [self.conversations addObjectsFromArray:loadArr];
    //    }
    [self.m_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMConversation *conver = self.conversations[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        BOOL deleat;
        BOOL deleatGroup;
        
        switch (conver.conversationType) {
            case eConversationTypeChat://单聊
            deleat = [[EaseMob sharedInstance].chatManager removeConversationByChatter:conver.chatter deleteMessages:YES append2Chat:NO];
                if (deleat) {
                    [self.conversations removeObjectAtIndex:indexPath.row];
                    [self.m_tableView reloadData];
                }
                break;
            case eConversationTypeGroupChat://群聊
                deleatGroup = [[EaseMob sharedInstance].chatManager removeConversationByChatter:conver.chatter deleteMessages:YES append2Chat:NO];
                if (deleatGroup) {
                    [self.conversations removeObjectAtIndex:indexPath.row];
                    [self.m_tableView reloadData];
                }
                break;
            case eConversationTypeChatRoom://聊天室
                
                break;
                
            default:
                break;
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ConversationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
        UILabel *unRedIcon = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
        [unRedIcon setTag:100];
        [cell.contentView addSubview:unRedIcon];
    }
    
    UILabel *unRedLabel = [(UILabel *)cell viewWithTag:100];
    unRedLabel.backgroundColor = [UIColor redColor];
    unRedLabel.textAlignment = NSTextAlignmentCenter;
    unRedLabel.textColor = [UIColor whiteColor];
    unRedLabel.text =@"80";
    unRedLabel.clipsToBounds = YES;
    unRedLabel.layer.cornerRadius = 15;
    
    EMConversation *conver = self.conversations[indexPath.row];
    NSLog(@" conversation.latestMessage = %@",conver.latestMessage);
    EMMessage *message = conver.latestMessage;
    
    NSString *textStr = nil;
    id msgBody = message.messageBodies[0];
    if ([msgBody isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = msgBody;
        textStr = textBody.text;
    }else if ([msgBody isKindOfClass:[EMImageMessageBody class]]){
        EMImageMessageBody *imgBody = msgBody;
        textStr = imgBody.displayName;
    }else if ([msgBody isKindOfClass:[EMVoiceMessageBody class]]){
        EMVoiceMessageBody *voiceBody = msgBody;
        textStr = voiceBody.displayName;
    }
    
    // 显示名字和未读消息
    NSString *chatter = nil;
    if(conver.conversationType == eConversationTypeGroupChat){
        EMGroup *group = [EMGroup groupWithId:conver.chatter];
        chatter = group.groupSubject;
    }else{
        chatter = conver.chatter;
    }
    NSString *str = [NSString stringWithFormat:@"%@-%zd",chatter,[conver unreadMessagesCount]];
    cell.textLabel.text = str;
    cell.detailTextLabel.text = textStr;
    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
    
    if ([conver unreadMessagesCount] != 0) {
        
        if ([conver unreadMessagesCount] <99) {
            unRedLabel.text = [NSString stringWithFormat:@"%zd",[conver unreadMessagesCount]];
        }else{
            unRedLabel.text = @"99+";
        }
        [cell.contentView bringSubviewToFront:unRedLabel];
    }else{
        unRedLabel.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMConversation *conversation = self.conversations[indexPath.row];
    IChatViewController *chatVC = [[IChatViewController alloc]initWithIsGroup:NO];
    [chatVC setHidesBottomBarWhenPushed:YES];
    // conversation.chatter  如果是群: 那么就是群的id  如果是单聊 : 那么就是 用户名
    chatVC.budddy = [EMBuddy buddyWithUsername:conversation.chatter];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)didUnreadMessagesCountChanged
{
    [self.m_tableView reloadData];
    NSInteger count = 0;
    for (EMConversation *conversation in self.conversations) {
        //        NSLog(@"未读消息 = %zd",[conversation unreadMessagesCount]);
        count += [conversation unreadMessagesCount];
    }
    
    NSString *badgeStr = nil;
    if (count > 0) {
        badgeStr = [NSString stringWithFormat:@"%zd",count];
    }
    
    self.navigationController.tabBarItem.badgeValue = badgeStr;
}


- (void)addBadgeNotification:(NSNotification *)notif
{
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
    item.badgeValue=nil;

     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
        badge++;
        [self.frendBuddyArray addObject:username];
        objc_setAssociatedObject(self.tabBarController, @"tabbarLink", self.frendBuddyArray, OBJC_ASSOCIATION_ASSIGN);
    
        UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:1];
        item.badgeValue=[NSString stringWithFormat:@"%d",badge];
    
    if (badge == 1) {
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBadgeNotification:) name:@"addBadgeNotification" object:nil];
    }
}

// 即将自动连接
- (void)willAutoReconnect
{
    NSLog(@"即将自动连接");
    self.title = @"即将自动连接...";
    
}

// 自动连接成功
- (void)didAutoReconnectFinishedWithError:(NSError *)error
{
    NSLog(@"自动连接成功");
    self.title = @"聊天";
}

// 监听状态的改变
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    NSLog(@"类型为 = %zd",connectionState);
    switch (connectionState) {
        case eEMConnectionConnected:
        {
            self.title = @"连接成功";
        }
            break;
        case eEMConnectionDisconnected:
        {
            self.title = @"未连接";
        }
            break;
            
        default:
            break;
    }
}

-(NSMutableArray *)frendBuddyArray{
    if (!_frendBuddyArray) {
        _frendBuddyArray = [NSMutableArray new];
    }
    return _frendBuddyArray;
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
