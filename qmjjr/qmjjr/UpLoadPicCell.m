//
//  UpLoadPicCell.m
//  huxinbao
//
//  Created by zhuna on 2017/3/17.
//  Copyright © 2017年 hxb. All rights reserved.
//

#import "UpLoadPicCell.h"

@implementation UpLoadPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btn1.tag = 101;
    self.btn2.tag = 102;
    [self.btn1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(143 * Width_Ratio, 97 * Height_Ratio));
    }];
    [self.btn2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(143 * Width_Ratio, 97 * Height_Ratio));
    }];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
