//
//  YongJinViewController.h
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "BaseViewController.h"
#import "TJSelectBtn.h"

@interface YongJinViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet TJSelectBtn *chufangBtn;
@property (weak, nonatomic) IBOutlet TJSelectBtn *tuoguanBtn;
@property (weak, nonatomic) IBOutlet UIButton *tixianBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)tixianAction:(id)sender;
- (IBAction)selectTypeAction:(UIButton *)sender;

@end
