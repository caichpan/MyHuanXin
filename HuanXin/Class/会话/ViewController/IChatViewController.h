//
//  IChatViewController.h
//  HuanXin
//
//  Created by CCP on 16/8/30.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "FTDBaseViewController.h"

@interface IChatViewController : FTDBaseViewController
/** 用户信息 */
@property (nonatomic, strong) EMBuddy *budddy;
@property (nonatomic,strong) EMGroup *group;//这是群聊的，我操你妹！
@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithIsGroup:(BOOL)isGroup;

@end
