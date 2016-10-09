//
//  FriendApplyViewController.h
//  HuanXin
//
//  Created by CCP on 16/9/12.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "FTDBaseViewController.h"

@interface FriendApplyViewController : FTDBaseViewController
@property (nonatomic , strong)NSMutableArray *friendArray;
@property (nonatomic , copy)void(^backBlock)(NSMutableArray * array);
@end
