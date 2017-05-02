//
//  AddCardViewController.h
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "BaseViewController.h"

@interface AddCardViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
- (IBAction)doneAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UIToolbar *doneToolBar;
- (IBAction)cancleBtnClick:(id)sender;
- (IBAction)confirmBtnClick:(id)sender;
@end
