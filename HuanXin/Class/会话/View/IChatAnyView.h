//
//  IChatAnyView.h
//  HuanXin
//
//  Created by CCP on 16/9/5.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IChatAnyView : UIView
/** 图片按钮 */
@property (nonatomic, weak) XMGNButton *imgBtn;


/** 语音按钮 */
@property (nonatomic, weak) XMGNButton *talkBtn;

/** 视频按钮 */
@property (nonatomic, weak) XMGNButton *vedioBtn;
- (instancetype)initImageBlock:(void (^)(void))imageBlock talkBlock:(void (^)(void))talkBlock vedioBlock:(void (^)(void))vedioBlock;
@end
