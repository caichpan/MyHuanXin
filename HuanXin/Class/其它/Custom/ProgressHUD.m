//
//  ProgressHUD.m
//  HuanXin
//
//  Created by CCP on 16/9/1.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "ProgressHUD.h"


@implementation ProgressHUD
+(void)showLoadingWithMessage:(NSString *)message{
    [SVProgressHUD showWithStatus:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];

}

+(void)dismess{
    [SVProgressHUD dismiss];
}

+(void)showMessage:(NSString *)message{

  //  [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:message];
}

+(void)showMessageSuccess:(NSString *)message{
    
        [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showSuccessWithStatus:message];
}

+(void)showMessageError:(NSString *)message{
    [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showInfoWithStatus:message];

}
@end



