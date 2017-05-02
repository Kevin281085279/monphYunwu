//
//  TuiJianViewController.h
//  qmjjr
//
//  Created by zhuna on 2017/4/18.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "BaseViewController.h"
#import "TJSelectBtn.h"

@interface TuiJianViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet TJSelectBtn *chufangBtn;
@property (weak, nonatomic) IBOutlet TJSelectBtn *tuoguanBtn;
@property (weak, nonatomic) IBOutlet UIButton *tuijianBtn;

- (IBAction)tuijianTypeAction:(UIButton *)sender;

- (IBAction)doneAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *msgBackView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
- (IBAction)backAction:(id)sender;

@end
