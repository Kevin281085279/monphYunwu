//
//  KeHuListViewController.h
//  qmjjr
//
//  Created by zhuna on 2017/4/20.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "BaseViewController.h"
#import "TJSelectBtn.h"

@interface KeHuListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet TJSelectBtn *chufangBtn;
@property (weak, nonatomic) IBOutlet TJSelectBtn *tuoguanBtn;
- (IBAction)selectTypeAction:(UIButton *)sender;

@end
