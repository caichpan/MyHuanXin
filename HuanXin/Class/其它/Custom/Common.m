//
//  Common.m
//  HuanXin
//
//  Created by CCP on 16/9/2.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "Common.h"

@implementation Common
+(void)saveFailtime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:date forKey:@"key_Failtime"];
    [defaults synchronize];
}

+(int)intervalSinceNow{
    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
    NSString * failtime=[defaults stringForKey:@"key_Failtime"]; //可能返回nil
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:failtime];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    //这是一天的时间，晚上可以测试一下12个小时的
    if (cha/60>1)
    {
        timeString = [NSString stringWithFormat:@"%.2f", cha/60];
        //    NSLog(@"%.0f,%.0f,%.0f,%@",late,now,cha,timeString);
        return [timeString intValue];
    }
    return -1;

}
@end
