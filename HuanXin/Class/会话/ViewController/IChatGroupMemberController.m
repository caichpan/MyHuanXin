//
//  IChatGroupMemberController.m
//  HuanXin
//
//  Created by CCP on 16/9/9.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import "IChatGroupMemberController.h"

@interface IChatGroupMemberController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation IChatGroupMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"群成员";
    if (self.menberArray.count > 0) {
        [self setMenberList];
    }else{
        [ProgressHUD showMessageError:@"获取群组列表出错"];
    }
    
    
}

-(void)setMenberList{
    // 显示数据
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, ChatScreenWidth, ChatScreenHeight-70) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource =self;
    [tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.view addSubview:tableView];
}

#pragma mark -  tableview数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.menberArray[indexPath.row]];
    
    return cell;
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
