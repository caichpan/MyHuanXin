//
//  NewFrendViewController.h
//  HuanXin
//
//  Created by CCP on 16/8/29.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "FTDBaseViewController.h"
#import "EaseMob.h"
#import "EMError.h"

@interface NewFrendViewController : FTDBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *dataArray;

@property (copy, nonatomic)NSString *testString;
@end
