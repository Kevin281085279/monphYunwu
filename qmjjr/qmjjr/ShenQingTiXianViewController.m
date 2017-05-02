//
//  ShenQingTiXianViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "ShenQingTiXianViewController.h"
#import "BankCardTableViewController.h"

@interface ShenQingTiXianViewController ()<UITextFieldDelegate,UITableViewDelegate>
{
    BankCardModel *_selectCardModel;
}
@end

@implementation ShenQingTiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请提现";
    self.moneyTF.delegate = self;
    if (self.tixianMoney) {
        self.xianeLabel.text = [NSString stringWithFormat:@"可提现金额：¥%@",self.tixianMoney];
    }
    
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.cornerRadius = 5;
    
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.successBackView.superview) {
        [self.successBackView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitAction:(id)sender {
    if (!_selectCardModel) {
        [ProgressHUD showError:@"请选择银行卡"];
        return;
    }
    if ([self.moneyTF.text floatValue] <= 0) {
        [ProgressHUD showError:@"请输入提现金额"];
        return;
    }
    UserModel *userModel = [MFSystemManager shareManager].userModel;
    NSDictionary *postDic = @{
                              @"uid":userModel.uID,
                              @"password":userModel.password,
                              @"userBankId":_selectCardModel.cardID,
                              @"money":self.moneyTF.text
                              };
    [NET_WORKING request4DicWithType:RequestTypePost InterfaceUrl:ADD_TIXIAN InterFaceType:@"add-tixian" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
        NSArray *arr = (NSArray*)dic;
        NSDictionary *moneyDic = [arr objectAtIndex:0];
        self.tixianMoneyLabel.text = [NSString stringWithFormat:@"%@",[moneyDic objectForKey:@"val"]];
        NSDictionary *cardDic = [arr objectAtIndex:1];
        self.tixianCardLabel.text = [NSString stringWithFormat:@"%@",[cardDic objectForKey:@"val"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [KEY_WINDOW addSubview:self.successBackView];
            [self.successBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(KEY_WINDOW);
                make.top.mas_equalTo(KEY_WINDOW).offset(64);
            }];
        });
        
    } failure:^(NSString *msg) {
        [ProgressHUD showError:msg];
    }];

}

- (IBAction)tixianAllAction:(id)sender {
    self.moneyTF.text = [NSString stringWithFormat:@"%@",self.tixianMoney];
    [self submitAction:nil];
}

- (IBAction)backAction:(id)sender {
//    [self.successBackView removeFromSuperview];
    [self back];
}
#pragma -mark TableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        BankCardTableViewController *bankVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BankCardTableViewController"];
        bankVC.selectBankCard = ^(BankCardModel *cardModel) {
            _selectCardModel = cardModel;
            NSString *cardNum = _selectCardModel.cardNum;
            NSString *cardNumWh = [cardNum substringFromIndex:cardNum.length - 4];
            self.bankCardLabel.text = [NSString stringWithFormat:@"%@(尾号%@)",_selectCardModel.bankName,cardNumWh];
        };
        [self.navigationController pushViewController:bankVC animated:YES];
    }
    
}
#pragma -mark textFieldDelegate
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isHaveDian;
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }else{
        isHaveDian = YES;
    }
    
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    //                    [self alertView:@"亲，第一个数字不能为小数点"];
                    //                    [AlertBoxTool AlertWithTitle:nil message:@"第一个数字不能为小数点" cancelButtonTitle:@"确定" otherButtonTitles:nil alertView:nil];
                    [ProgressHUD showError:@"第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }
                if (single == '0') {
                    //                    [self alertView:@"亲，第一个数字不能为0"];
                    //                    [AlertBoxTool AlertWithTitle:nil message:@"第一个数字不能为0" cancelButtonTitle:@"确定" otherButtonTitles:nil alertView:nil];
                    [ProgressHUD showError:@"第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                    
                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    //                    [self alertView:@"亲，您已经输入过小数点了"];
                    //                    [AlertBoxTool AlertWithTitle:nil message:@"您已经输入过小数点了" cancelButtonTitle:@"确定" otherButtonTitles:nil alertView:nil];
                    [ProgressHUD showError:@"您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSInteger tt = range.location - ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        //                        [self alertView:@"亲，您最多输入两位小数"];
                        //                        [AlertBoxTool AlertWithTitle:nil message:@"最多输入两位小数" cancelButtonTitle:@"确定" otherButtonTitles:nil alertView:nil];
                        [ProgressHUD showError:@"最多输入两位小数"];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            //            [self alertView:@"亲，您输入的格式不正确"];
            //            [AlertBoxTool AlertWithTitle:nil message:@"您输入的格式不正确" cancelButtonTitle:@"确定" otherButtonTitles:nil alertView:nil];
            [ProgressHUD showError:@"您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
@end
