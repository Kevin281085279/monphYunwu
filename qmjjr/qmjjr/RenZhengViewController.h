//
//  RenZhengViewController.h
//  huxinbao
//
//  Created by zhuna on 2017/3/17.
//  Copyright © 2017年 hxb. All rights reserved.
//

#import "BaseViewController.h"

@interface RenZhengViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *renzhengBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *renzhengMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *kefuLabel;
@property (weak, nonatomic) IBOutlet UIView *renzhengMsgBackView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

- (IBAction)doneAction:(UIButton *)sender;
@end
