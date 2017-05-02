//
//  LKPickerView.h
//  monphSinged
//
//  Created by zhuna on 16/3/30.
//  Copyright © 2016年 monph. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PickViewSelect)(NSArray *selectIndexs);

@interface LKPickerView : UIView

@property (assign, nonatomic) NSInteger components;
@property (strong, nonatomic) NSArray *pickViewArr;

@property (strong, nonatomic) NSMutableArray *selectIndexsArr;

- (void)didFinishSelectedDate:(PickViewSelect)selectIndexs;

@end
