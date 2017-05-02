//
//  YongJinModel.h
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YongJinModel : NSObject
@property (copy, nonatomic)NSString * yue;
@property (copy, nonatomic)NSString * shouru;
@property (copy, nonatomic)NSString * page;
@property (copy, nonatomic)NSString * count;
@property (copy, nonatomic)NSString * total;
@property (copy, nonatomic)NSString * pageTotal;
@property (copy, nonatomic)NSString * tixianMoney;

@property (strong, nonatomic)NSArray * list;  
@end
