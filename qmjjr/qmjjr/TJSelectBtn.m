//
//  TJSelectBtn.m
//  qmjjr
//
//  Created by zhuna on 2017/4/18.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "TJSelectBtn.h"

@implementation TJSelectBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setTitleColor:FONT_COLOR_130 forState:UIControlStateNormal];
    [self setTitleColor:DEFULT_BLUE_COLOR forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    UIView *view100 = [self viewWithTag:100];
    if (view100.superview) {
        [view100 removeFromSuperview];
    }
    if (selected) {
        UIView *view = [[UIView alloc] init];
        view.tag = 100;
        view.backgroundColor = DEFULT_BLUE_COLOR;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(@65);
            make.height.mas_equalTo(@2);
        }];
    }else{
        
    }
}

@end
