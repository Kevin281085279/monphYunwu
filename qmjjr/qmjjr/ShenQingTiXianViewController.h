//
//  ShenQingTiXianViewController.h
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "LKBaseTableViewController.h"

@interface ShenQingTiXianViewController : LKBaseTableViewController

@property (strong, nonatomic) NSString *tixianMoney;

@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *xianeLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitAction:(id)sender;
- (IBAction)tixianAllAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *successBackView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UILabel *tixianMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tixianCardLabel;
- (IBAction)backAction:(id)sender;
@end
