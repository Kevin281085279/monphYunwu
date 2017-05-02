//
//  TuiJianViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/18.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "TuiJianViewController.h"
#import "TextViewCell.h"
#import "TextFeildCell.h"
#import "LKPickerView.h"
#import "SearchXQViewController.h"

@interface TuiJianViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _tuijianType;
    NSArray *_titleArr;
    
//    NSString *_xiaoquName;
    NSString *_xiaoquID;
}
@end

@implementation TuiJianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我要推荐";
    [self.chufangBtn setSelected:YES];
    [self.tuoguanBtn setSelected:NO];
    _tuijianType = 1;
    self.tableView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    
    self.tuijianBtn.layer.masksToBounds = YES;
    self.tuijianBtn.layer.cornerRadius = 5;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.doneBtn.layer.cornerRadius = 5;
    self.doneBtn.layer.masksToBounds = YES;
    
    self.msgBackView.hidden = YES;
    
    _titleArr = @[@"客户姓名",@"手机号码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _titleArr.count;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45;
    }
    return 120;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TextFeildCell *cell = (TextFeildCell*)[tableView dequeueReusableCellWithIdentifier:@"TextFeildCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = [_titleArr objectAtIndex:indexPath.row];
        cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",[_titleArr objectAtIndex:indexPath.row]];
        if (indexPath.row == 1) {
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (indexPath.row == 6) {
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            UILabel *danweiLabel = [[UILabel alloc] init];
            danweiLabel.text = @"㎡";
            danweiLabel.textColor = DEFULT_BLUE_COLOR;
            danweiLabel.font = Font30;
            [cell.contentView addSubview:danweiLabel];
            [danweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.contentView);
                make.right.mas_equalTo(cell.contentView).offset(-15);
            }];
        }
        if (indexPath.row == 2 || indexPath.row == 4) {
            cell.textField.enabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }else{
        TextViewCell *cell = (TextViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TextViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   [self.view endEditing:YES];
    if (indexPath.row == 2) {
//        NSLog(@"%@",indexPath);
        SearchXQViewController *searchXQVC = [[SearchXQViewController alloc] init];
        searchXQVC.selectXiaoQu = ^(NSDictionary *xqDic){
            TextFeildCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.textField.text = [xqDic objectForKey:@"name"];
            _xiaoquID = [xqDic objectForKey:@"id"];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:searchXQVC animated:YES];
        return;
    }
    if (indexPath.row == 4) {
//        NSLog(@"%@",indexPath);
        LKPickerView *pickView = [[LKPickerView alloc] init];
        pickView.components = 1;
        NSArray *dataArr = @[@[@"毛坯",@"简装"]];
        pickView.pickViewArr = dataArr;
        [pickView didFinishSelectedDate:^(NSArray *selectIndexs) {
            NSInteger selectIndex = [[selectIndexs objectAtIndex:0] integerValue];
            NSArray *arr = [dataArr objectAtIndex:0];
            TextFeildCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.textField.text = [arr objectAtIndex:selectIndex];
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tuijianTypeAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender == self.chufangBtn) {
        [self.chufangBtn setSelected:YES];
        [self.tuoguanBtn setSelected:NO];
        _tuijianType = 1;
        _titleArr = @[@"客户姓名",@"手机号码"];
        [self.tableView reloadData];
    }else{
        [self.chufangBtn setSelected:NO];
        [self.tuoguanBtn setSelected:YES];
        _tuijianType = 2;
        _titleArr = @[@"客户姓名",@"手机号码",@"小区名称",@"单元楼号",@"装修类型",@"户型",@"面积"];
        [self.tableView reloadData];
    }
}

- (IBAction)doneAction:(id)sender {
    NSString *nameStr = @"";
    NSString *mobieStr = @"";
    NSString *xiaoquStr = @"";
    NSString *danyuanStr = @"";
    NSString *zhuangxiuStr = @"";
    NSString *huxingStr = @"";
    NSString *mianjiStr = @"";
    NSString *beizhuStr = @"";
    for (int i = 0; i < _titleArr.count; i++) {
        TextFeildCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.textField.text.length < 1) {
            [ProgressHUD showError:cell.textField.placeholder];
            return;
        }
        switch (i) {
            case 0:
                nameStr = cell.textField.text;
                break;
            case 1:
                mobieStr = cell.textField.text;
                break;
            case 2:
                xiaoquStr = cell.textField.text;
                break;
            case 3:
                danyuanStr = cell.textField.text;
                break;
            case 4:
            {
                if ([cell.textField.text isEqualToString:@"毛坯"]) {
                    zhuangxiuStr = @"0";
                }else{
                    zhuangxiuStr = @"1";
                }
            }
                break;
            case 5:
                huxingStr = cell.textField.text;
                break;
            case 6:
                mianjiStr = cell.textField.text;
                break;
                
            default:
                break;
        }
    }
    
    TextViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    beizhuStr = cell.textView.text;
    
    if ([beizhuStr isEqualToString:@"请输入客户需求"]) {
        beizhuStr = @"";
    }
    
    NSString *mobilePhone = @"^[1][0-9]{10}$";
    NSPredicate *predicate_phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobilePhone];
    if (![predicate_phone evaluateWithObject:mobieStr]) {
        
        [ProgressHUD showError:@"请输入正确的11位手机号码"];
        return;
    }
    UserModel *userModel = [MFSystemManager shareManager].userModel;
    if (_tuijianType == 1) {
        NSDictionary *postDic = @{
                                  @"uid":userModel.uID,
                                  @"password":userModel.password,
                                  @"realname":nameStr,
                                  @"mobile":mobieStr,
                                  @"beizhu":beizhuStr
                                  };
        [ProgressHUD show];
        [NET_WORKING request4DicWithType:RequestTypePost InterfaceUrl:ADD_TUIJIAN_CHUFANG InterFaceType:@"add-tuijian-chufang" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
            NSLog(@"推荐成功");
            [ProgressHUD dismiss];
            self.msgBackView.hidden = NO;
            self.titleLabel.text = @"推荐成功";
            self.detailLabel.text = @"";
        } failure:^(NSString *msg) {
            [ProgressHUD showError:msg];
        }];
    }else{
        NSDictionary *postDic = @{
                                  @"uid":userModel.uID,
                                  @"password":userModel.password,
                                  @"realname":nameStr,
                                  @"mobile":mobieStr,
                                  @"xiaoqu":xiaoquStr,
                                  @"xiaoquId":_xiaoquID,
                                  @"danyuan":danyuanStr,
                                  @"zhuangxiuType":zhuangxiuStr,
                                  @"huxing":huxingStr,
                                  @"mianji":mianjiStr,
                                  @"beizhu":beizhuStr
                                  };
        [ProgressHUD show];
        [NET_WORKING request4DicWithType:RequestTypePost InterfaceUrl:ADD_TUIJIAN_TUOGUAN InterFaceType:@"add-tuijian-tuoguan" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
            NSLog(@"推荐成功");
            [ProgressHUD dismiss];
            self.msgBackView.hidden = NO;
            self.titleLabel.text = @"推荐成功";
            self.detailLabel.text = @"";
        } failure:^(NSString *msg) {
            [ProgressHUD showError:msg];
        }];
    }

}
- (IBAction)backAction:(id)sender {
    [self back];
}
@end
