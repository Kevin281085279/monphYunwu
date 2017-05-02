//
//  KeHuCell.m
//  qmjjr
//
//  Created by zhuna on 2017/4/20.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "KeHuCell.h"

@implementation KeHuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 25;
    
    self.typeImgView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
