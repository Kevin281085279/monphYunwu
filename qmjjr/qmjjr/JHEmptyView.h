//
//  JHEmptyView.h
//  monphV3
//
//  Created by 金KingHwa on 15/12/21.
//  Copyright © 2015年 monph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHEmptyView : UIView{
    
    __weak IBOutlet UILabel *warningLabel;
}
- (instancetype)initWithWarningStr:(NSString *)warningStr;
@end
