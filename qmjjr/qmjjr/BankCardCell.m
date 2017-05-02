//
//  BankCardCell.m
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "BankCardCell.h"

@implementation BankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
