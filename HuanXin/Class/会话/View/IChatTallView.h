//
//  IChatTallView.h
//  HuanXin
//
//  Created by CCP on 16/8/30.
//  Copyright © 2016年 CCP. All rights reserved.
//

typedef enum {
    XMGTollViewVoiceTypeStart,
    XMGTollViewVoiceTypeStop,
    XMGTollViewVoiceTypeCancel
}XMGTollViewVoiceType;

typedef enum {
    XMGTollViewEditTextViewTypeSend,
    XMGTollViewEditTextViewTypeBegin
}XMGTollViewEditTextViewType;

#import <UIKit/UIKit.h>

@protocol XMGTollViewVoiceDelegate <NSObject>

- (void)toolViewWithType:(XMGTollViewVoiceType)type button:(XMGNButton *)btn;

@end

typedef void(^XMGTollViewSendTextBlock)(UITextView *text,XMGTollViewEditTextViewType);
typedef void(^XMGTollViewMoreBtnBlock)();

@interface IChatTallView : UIView <UITextViewDelegate>
/** 发送消息的回调 */
@property (nonatomic, copy) XMGTollViewSendTextBlock sendTextBlock;

@property (nonatomic,assign)id<XMGTollViewVoiceDelegate> delegate;

/** 点击更多按钮的回调 */
@property (nonatomic, copy) XMGTollViewMoreBtnBlock moreBtnBlock;
@end
