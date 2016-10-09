//
//  IChatViewController.m
//  HuanXin
//
//  Created by CCP on 16/8/30.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "IChatViewController.h"
#import "IChatTallView.h"
#import "IChatTallCell.h"
#import "DeviceUtil.h"
#import "EMCDDeviceManager.h"
#import "IChatAnyView.h"
#import "MWPhotoBrowser.h"
#import "IChatCallViewController.h"
#import "IChatGroupMemberController.h"

@interface IChatViewController ()<UITableViewDelegate,UITableViewDataSource,IEMChatProgressDelegate,EMChatManagerDelegate,XMGTollViewVoiceDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,XMGChatCellShowImageDelegate,MWPhotoBrowserDelegate,EMCallManagerDelegate>
/** 聊天消息 */
@property (nonatomic, strong) NSMutableArray *messageData;
@property (nonatomic, strong)IChatTallView *tallView;
//@property (nonatomic, assign)BOOL isShowTimeLabel;//是否显示聊天时间
/** 更多功能 */
@property (nonatomic, weak) IChatAnyView *chatAnyView;
/** 更多功能需要拿到的textView */
@property (nonatomic, weak) UITextView *anyViewNeedTextView;

/** 保存图片的message */
@property (nonatomic, strong) EMMessage *photoMessage;

/** 实时通话的Session */
@property (nonatomic, strong) EMCallSession *callSession;

@property (nonatomic,assign)BOOL isGroup;

@property (nonatomic, strong)UILabel *voiceView;
@end

@implementation IChatViewController

- (instancetype)initWithIsGroup:(BOOL)isGroup
{
    if (self = [super init]) {
        self.isGroup = isGroup;
      
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    if (self.isGroup) {//群聊
        NSLog(@"%@",self.group.groupId);
//      EMError *error = nil;
         NSArray *array = [[EaseMob sharedInstance].chatManager fetchOccupantList:self.group.groupId error:nil];
        
        XMGNButton *button = [XMGNButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"成员" forState:UIControlStateNormal];
        button.frame = CGRectMake(ChatScreenWidth-50, 30, 50, 30);
        [self.navigationBar addSubview:button];
        button.block = ^(XMGNButton *button){
            IChatGroupMemberController *menber = [[IChatGroupMemberController alloc]init];
            if (array.count > 0) {
                menber.menberArray = array;
            }
            [self.navigationController pushViewController:menber animated:YES];
        };
        
       self.title = @"群聊";
        
    }else{//非群聊
        
          self.title =  self.budddy.username;
    }


    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"path = %@",path);
    
    [self creatTableView];
    [self setData];
    [self.view bringSubviewToFront:self.navigationBar];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.chatAnyView.top = ChatScreenHeight;
}

-(void)creatTableView{
    __block IChatViewController *weak = self;

    // 1. 创建tableview
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ChatScreenWidth, ChatScreenHeight - 64 - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    UILabel *voiceV = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    voiceV.backgroundColor =[UIColor clearColor];
    voiceV.textAlignment = NSTextAlignmentCenter;
    voiceV.font = [UIFont systemFontOfSize:25];
    voiceV.text = @"正在录音，请说话...";
    [self.view addSubview:voiceV];
    [self.view bringSubviewToFront:voiceV];
    voiceV.hidden = YES;
    self.voiceView = voiceV;
    
    
    
    self.tallView = [[IChatTallView alloc]init];
    self.tallView.frame = CGRectMake(0, self.tableView.bottom, self.tableView.width, 44);
    self.tallView.delegate = self;
    // 发送消息
    self.tallView.sendTextBlock = ^(UITextView *textView,XMGTollViewEditTextViewType type){
        if (type == XMGTollViewEditTextViewTypeSend) {
            [weak sendTextMsg:textView];
        }else{
            if (weak.chatAnyView.top < ChatScreenHeight) {
                weak.chatAnyView.top = ChatScreenHeight;
            }
            weak.anyViewNeedTextView = textView;
        }
        
    };
    
  //  [[UIApplication sharedApplication].keyWindow addSubview:self.tallView];
    [self.view addSubview:self.tallView];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 添加聊天代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    // 添加实时通话代理
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];

}

-(void)setData{
    // 创建更多功能
   __block IChatViewController *weak = self;
    IChatAnyView *anyView = [[IChatAnyView alloc]initImageBlock:^{
        self.tableView.top = 64;
        self.tallView.top = self.tableView.bottom;
        
        NSLog(@"你点击了图片");
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [self presentViewController:picker animated:YES
                         completion:nil];
    } talkBlock:^{
        NSLog(@"你点击了语音");
        
        // 实时通话的类  ICallManagerCall
        // 发送一个语音通话请求
        EMCallSession *callSin = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:self.budddy.username timeout:20 error:nil];
        self.callSession = callSin;
    } vedioBlock:^{
        NSLog(@"你点击了视频");
      
     //   [EaseMob sharedInstance].deviceManager
        [[EaseMob sharedInstance].callManager asyncMakeVideoCall:self.budddy.username timeout:20 error:nil];
    }];
    anyView.frame = CGRectMake(0, ChatScreenHeight, ChatScreenWidth, 271);
    [[UIApplication sharedApplication].keyWindow addSubview:anyView];
    
    self.chatAnyView = anyView;
    
    // 1. 现在滚动视图隐藏
    // 2. 在输入文字的时候同时点击更多功能
    // 3. 在文本框同时显示的时候隐藏更多功能
    // 4. 当开始编辑的时候应该隐藏掉更多功能
    
    // moreBtn 的点击
    self.tallView.moreBtnBlock = ^(){
        
        if (weak.anyViewNeedTextView) {
            [weak.anyViewNeedTextView resignFirstResponder];
        }
        
     //   [[UIApplication sharedApplication].keyWindow bringSubviewToFront:anyView];
       
        weak.tableView.top = -271+64;
        weak.tallView.frame = CGRectMake(0, weak.tableView.bottom, weak.tableView.width, 44);
        anyView.top = ChatScreenHeight - 271;
        
     //   weak.tallView.bottom = anyView.top;
    };
    

    // 获取本地的聊天消息
     NSString *reciver = self.isGroup ? self.group.groupId : self.budddy.username;
    // 获取当前对象的会话
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:reciver conversationType:eConversationTypeChat];
    // 加载当前会话的所有消息
    NSArray *conArr = [conversation loadAllMessages];
    
    for (EMMessage *msg in conArr) {
        [conversation markMessageWithId:msg.messageId asRead:YES];
    }
    NSLog(@"%lu",(unsigned long)conArr.count);
    NSLog(@"conArr = %@",conArr);
    // 初始化数组
    self.messageData = [NSMutableArray arrayWithArray:conArr];
    if (self.messageData.count > 0) {
        [self scrollBottom];
    }

    
}

// 发送文字消息
- (void)sendTextMsg:(UITextView *)textView
{
    
   __block IChatViewController *weak = self;
    // 发送消息
    NSLog(@"你点击了完成按钮");
    
    // 5. 内容对象
    EMChatText *text = [[EMChatText alloc]initWithText:[textView.text substringToIndex:textView.text.length - 1]];
    
    // 4. 消息体
    //        EMTextMessageBody;  文本消息体
    //        EMImageMessageBody; 图片消息体
    //        EMVideoMessageBody; 视频消息体
    //        EMVoiceMessageBody; 语音消息体
    EMTextMessageBody *textBody = [[EMTextMessageBody alloc]initWithChatObject:text];
    
    // 3.接收者
    // 3.接收者
    NSString *reciver = self.isGroup ? self.group.groupId : self.budddy.username;    // 2.EMMessage对象
    EMMessage *msg = [[EMMessage alloc]initWithReceiver:reciver bodies:@[textBody]];
     msg.messageType = self.isGroup ? eMessageTypeGroupChat : eMessageTypeChat;
    // 1.异步发送消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:weak prepare:^(EMMessage *message, EMError *error) {
        NSLog(@"消息即将发送");
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"消息发送完成");
        // 添加数据
        [weak.messageData addObject:message];
        // 刷新表格
        [weak.tableView reloadData];
        [weak scrollBottom];
        // 清空数据
        textView.text = @"";
    } onQueue:nil];

}

// 通知回调的方法
- (void)keyboardWillChangeFrameNotification:(NSNotification *)noti
{
    // 获取窗口的高度
    
//    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
    
    // 键盘结束的Frm
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获取键盘结束的y值
    CGFloat kbEndY = kbEndFrm.origin.y;
    
    int height = CGRectGetHeight(self.tallView.frame);
   
    
    if (kbEndY < ChatScreenHeight) {
        self.tableView.top = -271+64;
    }else{
        self.tableView.top = 64;
    }
    
     self.tallView.frame = CGRectMake(0, kbEndY-height, self.tableView.width, 44);// windowH - kbEndY;
    
    NSLog(@"%lf",self.tableView.top);
}

// 发送一条消息
- (void)scrollBottom
{
     if (self.messageData.count == 0) return;
    // 滚到最后一行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageData.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3f animations:^{
        self.chatAnyView.top = ChatScreenHeight;
        self.tallView.top =ChatScreenHeight -44;
        if (self.tableView.top < 0) self.tableView.top = 64;
    }];

}

#pragma mark - 发送消息的进度
- (void)setProgress:(float)progress forMessage:(EMMessage *)message forMessageBody:(id<IEMMessageBody>)messageBody
{
    NSLog(@"progress  = %f",progress);
}

#pragma mark - EMChatManagerDelegate
// 接收消息的回调
- (void)didReceiveMessage:(EMMessage *)message
{
    NSLog(@"=== %@",message);
    // 添加数据
    [self.messageData addObject:message];
    // 刷新表格
    [self.tableView reloadData];
    // 滚到最后一行
    [self scrollBottom];
}

#pragma mark - 实时通话的代理方法
- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    NSLog(@"callSession = %@  reason %ld  status = %zd",callSession,reason,callSession.status);
    // 通话已连接 才跳转到下一个界面
    if (callSession.status == eCallSessionStatusConnected) {
        IChatCallViewController *callCtr = [[IChatCallViewController alloc]init];
        callCtr.currentSession = callSession;
        [self presentViewController:callCtr animated:YES completion:nil];
        
         self.tableView.top = 64;
         self.tallView.frame = CGRectMake(0, self.tableView.bottom, self.tableView.width, 44);
    }
    
}


#pragma mark - XMGTollViewVoiceDelegate
- (void)toolViewWithType:(XMGTollViewVoiceType)type button:(XMGNButton *)btn
{
    switch (type) {
        case XMGTollViewVoiceTypeStart:
        {
            NSLog(@"开始录音");
            int fileNameNum = arc4random() % 1000;
            NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
            [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:[NSString stringWithFormat:@"%zd%d",fileNameNum,(int)time] completion:^(NSError *error) {
                if (!error) {
                    self.voiceView.hidden = NO;
                    NSLog(@"录音成功");
                }
            }];
        }
            break;
            
        case XMGTollViewVoiceTypeStop:
        {
            self.voiceView.hidden = YES;
            [ProgressHUD showLoadingWithMessage:@"语音发送中"];
            NSLog(@"停止录音");
            [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
                NSLog(@"recordPath = %@ , duration = %zd",recordPath,aDuration);
                [self sendVoiceWithFilePath:recordPath duration:aDuration];
            }];
        }
            break;
            
        case XMGTollViewVoiceTypeCancel:
        {
        self.voiceView.hidden = YES;
            NSLog(@"退出录音");
        }
            break;
            
        default:
            break;
    }
}

// 发送语音消息
- (void)sendVoiceWithFilePath:(NSString *)path duration:(NSInteger)aDuration
{
    EMChatVoice *voice = [[EMChatVoice alloc]initWithFile:path displayName:@"[AUDIO]"];
    // 需要设置语音时间
    voice.duration = aDuration;
    
    EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc]initWithChatObject:voice];
    
     NSString *reciver = self.isGroup ? self.group.groupId : self.budddy.username;
    
    // message
    EMMessage *message = [[EMMessage alloc]initWithReceiver:reciver bodies:@[voiceBody]];
    
    message.messageType = self.group ? eMessageTypeGroupChat : eMessageTypeChat;
    
    // 发送消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:self prepare:^(EMMessage *message, EMError *error) {
        NSLog(@"即将发送");
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"发送完成");
        [ProgressHUD dismess];
        [self.view endEditing:YES];
        // 添加数据
        [self.messageData addObject:message];
        // 刷新表格
        [self.tableView reloadData];
        // 滚到最后一行
        [self scrollBottom];
    } onQueue:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 隐藏picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 取出图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // 发送图片
    [self sendImage:image];
}

- (void)sendImage:(UIImage *)image
{
    EMChatImage *chatImg = [[EMChatImage alloc]initWithUIImage:image displayName:@"[IMAGE]"];
    
    // 第一个参数的原图片
    // 第二个参数是预览图片 如果传nil环信默认帮我们生成预览图片
    EMImageMessageBody *body = [[EMImageMessageBody alloc]initWithImage:chatImg thumbnailImage:nil];
    
    NSString *reciver = self.isGroup ? self.group.groupId : self.budddy.username;

    
    // 创建EMMessage对象
    EMMessage *msg = [[EMMessage alloc]initWithReceiver:reciver bodies:@[body]];
    
    msg.messageType = self.isGroup ? eMessageTypeGroupChat : eMessageTypeChat;
    
    [ProgressHUD showLoadingWithMessage:@"图片发送中..."];
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:self prepare:^(EMMessage *message, EMError *error) {
        NSLog(@"即将发送");
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        [ProgressHUD dismess];
        
        if (!error) {
            NSLog(@"发送成功");
            //添加到数据源中
            [self.messageData addObject:message];
            // 刷新表格
            [self.tableView reloadData];
            // 滚到底部
            [self scrollBottom];
        }else{
            [ProgressHUD showMessageError:error.description];
        }
    } onQueue:nil];
}

#pragma mark - 显示大图片
- (void)chatCellWithMessage:(EMMessage *)message
{
//    EMImageMessageBody *body = self.photoMessage.messageBodies[0];
//    NSString *path = body.remotePath;
//    NSLog(@"%@",path);
    
    self.photoMessage = message;
    NSLog(@"delegate message = %@",message);
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
   
    
    [self.navigationController pushViewController:browser animated:YES];
}


#pragma mark - 图片浏览器的代理方法
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 1;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    EMImageMessageBody *body = self.photoMessage.messageBodies[0];
    
    NSString *path = body.localPath;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:path]) {
        // 设置图片浏览器中的图片对象 (本地获取的)
        return [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:path]];
    }else{
        // 设置图片浏览器中的图片对象 (使用网络请求)
        path = body.remotePath;
        return [MWPhoto photoWithURL:[NSURL URLWithString:path]];
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CHATCELL";
    IChatTallCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[IChatTallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.message = self.messageData[indexPath.row];
    NSLog(@"cell. roheight = %f",cell.rowHeight);
    return cell.rowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CHATCELL";
    IChatTallCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[IChatTallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.message = self.messageData[indexPath.row];
    // 设置显示大图片的代理
    cell.delegate = self;
    [cell setSelectedBackgroundView:[[UIView alloc]init]];
    return cell;
}


- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
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
