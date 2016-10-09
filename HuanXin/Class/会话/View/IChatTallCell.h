//
//  IChatTallCell.h
//  HuanXin
//
//  Created by CCP on 16/8/30.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMGChatCellShowImageDelegate <NSObject>
/*
 * 显示大图片
 */
- (void)chatCellWithMessage:(EMMessage *)message;

@end

@interface IChatTallCell : UITableViewCell
/** 消息模型 */
@property (nonatomic, strong) EMMessage *message;

/** 时间 */
@property (nonatomic, weak) UILabel *chatTime;

@property (nonatomic, assign)CGFloat rowHeight;

@property (nonatomic,assign)id<XMGChatCellShowImageDelegate> delegate;
@end
