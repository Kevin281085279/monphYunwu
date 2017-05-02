//
//  BankCardCell.h
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankImgView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankIDLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
