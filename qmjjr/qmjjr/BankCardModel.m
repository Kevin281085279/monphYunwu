//
//  BankCardModel.m
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "BankCardModel.h"

@implementation BankCardModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"cardID" : @"id",
             @"cardNum" : @"idNum"
             };
}
@end
