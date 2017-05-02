//
//  TextViewCell.h
//  qmjjr
//
//  Created by zhuna on 2017/4/18.
//  Copyright © 2017年 monph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
