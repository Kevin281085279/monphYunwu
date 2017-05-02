//
//  BaseEmptyView.m
//  qmjjr
//
//  Created by zhuna on 2017/4/20.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "BaseEmptyView.h"

@implementation BaseEmptyView

- (instancetype) initWithWarningStr:(NSString *)warningStr WarningImg:(NSString *)imgStr
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BaseEmptyView" owner:nil options:nil] firstObject];
        self.warningLabel.text = warningStr;
        if (imgStr) {
            self.imgView.image = [UIImage imageNamed:@"blank_xiaoxi"];
        }else{
            self.imgView.image = [UIImage imageNamed:@"blank_kehu"];
        }
    }
    return self;
}

- (void) disMiss
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

@end
