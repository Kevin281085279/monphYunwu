//
//  BaseEmptyView.h
//  qmjjr
//
//  Created by zhuna on 2017/4/20.
//  Copyright © 2017年 monph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseEmptyView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

- (instancetype)initWithWarningStr:(NSString *)warningStr WarningImg:(NSString*)imgStr;

- (void) disMiss;
@end
