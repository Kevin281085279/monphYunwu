
//
//  TextViewCell.m
//  qmjjr
//
//  Created by zhuna on 2017/4/18.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "TextViewCell.h"

@implementation TextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate = self;
    self.textView.textColor = FONT_COLOR_200;
    self.textView.text = @"请输入客户需求";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入客户需求"]) {
        textView.text = @"";
        textView.textColor = RGBCOLOR(51, 51, 51);
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        textView.text = @"请输入客户需求";
        textView.textColor = FONT_COLOR_200;
    }
}

@end
