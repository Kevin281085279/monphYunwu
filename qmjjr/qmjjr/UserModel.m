//
//  UserModel.m
//  monph
//
//  Created by 金KingHwa on 15/7/2.
//  Copyright (c) 2015年 monph. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

CoreArchiver_MODEL_M

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"uID" : @"uid",
             @"xingbieZh" : @"xingbie_zh",
             @"xingzuoZh" : @"xingzuo_zh",
             @"eduZh":@"edu_zh"};
}

@end
