//
//  FriendListViewController.h
//  HuanXin
//
//  Created by CCP on 16/8/29.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "FTDBaseViewController.h"

@interface FriendListViewController : FTDBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *frendArray;
@property (strong, nonatomic)NSMutableArray *teamArray;
@end
