//
//  BankCardModel.h
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCardModel : NSObject
//获取银行卡
@property (copy, nonatomic)NSString * cardID;
@property (copy, nonatomic)NSString * bankName;
@property (copy, nonatomic)NSString * cardNum;
@property (copy, nonatomic)NSString * bankImage;

@end
