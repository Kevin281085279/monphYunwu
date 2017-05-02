//
//  BankCardTableViewController.h
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "LKBaseTableViewController.h"

typedef void(^SelectBankCard)(BankCardModel * cardModel);
@interface BankCardTableViewController : LKBaseTableViewController
@property (weak, nonatomic) IBOutlet UIButton *addCardBtn;
- (IBAction)addCardAction:(id)sender;

@property (copy, nonatomic) SelectBankCard selectBankCard;
- (void) returnModelBlock:(SelectBankCard)block;
@end
