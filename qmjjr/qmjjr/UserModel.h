//
//  UserModel.h
//  monph
//
//  Created by 金KingHwa on 15/7/2.
//  Copyright (c) 2015年 monph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreArchive.h"

@interface UserModel : NSObject

CoreArchiver_MODEL_H
@property (copy, nonatomic)NSString * uID;
@property (copy, nonatomic)NSString * mobile;
@property (copy, nonatomic)NSString * password;
//@property (copy, nonatomic)NSString * salt;
@property (copy, nonatomic)NSString * status;           //1=启用; 2=禁言; 3=封号; 0=未激活
@property (copy, nonatomic)NSString * touxiang;
@property (copy, nonatomic)NSString * nicheng;
@property (copy, nonatomic)NSString * xingbie;
@property (copy, nonatomic)NSString * xingbieZh;
@property (copy, nonatomic)NSString * shengri;
@property (copy, nonatomic)NSString * xingzuo;
@property (copy, nonatomic)NSString * xingzuoZh;
@property (copy, nonatomic)NSString * zhiye;
@property (copy, nonatomic)NSString * edu;
@property (copy, nonatomic)NSString * eduZh;
@property (copy, nonatomic)NSString * is_zuke;
@property (copy, nonatomic)NSString * yue;
@property (copy, nonatomic)NSString * tixian_jine;
@property (copy, nonatomic)NSString * shiming_status;//0=未认证，1=审核中，2=已认证，3=认证失败

@end

