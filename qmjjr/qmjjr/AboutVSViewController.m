//
//  AboutVSViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/25.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "AboutVSViewController.h"

@interface AboutVSViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AboutVSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    self.tableView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    self.versonLabel.text = [NSString stringWithFormat:@"V%@",currentVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutVSCell"];
    
    NSArray *titleArr = @[@"魔飞公寓官网",@"微信公众号",@"客服电话"];
    NSArray *detailArr = @[@"www.monph.com",@"monph2015",@"400-0371-921"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [detailArr objectAtIndex:indexPath.row];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = DEFULT_LINE_COLOR;
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell.contentView);
        make.height.mas_offset(@0.5);
    }];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        NSString *urlStr = @"telprompt://4000371921";
        NSURL *url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
