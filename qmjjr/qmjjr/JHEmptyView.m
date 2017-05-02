//
//  JHEmptyView.m
//  monphV3
//
//  Created by 金KingHwa on 15/12/21.
//  Copyright © 2015年 monph. All rights reserved.
//

#import "JHEmptyView.h"

@implementation JHEmptyView

- (instancetype)initWithWarningStr:(NSString *)warningStr{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JHEmptyView" owner:nil options:nil] firstObject];
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        warningLabel.text = warningStr;
        self.backgroundColor = DEFULT_BACKGROUND_COLOR;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
