//
//  KeHuModel.h
//  qmjjr
//
//  Created by zhuna on 2017/4/20.
//  Copyright © 2017年 monph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeHuModel : NSObject
@property (copy, nonatomic)NSString * touxiang;
@property (copy, nonatomic)NSString * kehuID;
@property (copy, nonatomic)NSString * realname;
@property (copy, nonatomic)NSString * mobile;
@property (copy, nonatomic)NSString * address;
@property (copy, nonatomic)NSString * leixing;
@property (copy, nonatomic)NSString * huxing_name;
@property (copy, nonatomic)NSString * mianji;
@property (copy, nonatomic)NSString * statusname;
@property (copy, nonatomic)NSString * status;
@property (copy, nonatomic)NSString * date;
@property (copy, nonatomic)NSString * beizhu;
//搜索
@property (copy, nonatomic)NSString * type;

//消息列表
@property (copy, nonatomic)NSString * is_read;
@property (copy, nonatomic)NSString * title;
@property (copy, nonatomic)NSString * content;
@property (copy, nonatomic)NSString * addtime;
@property (copy, nonatomic)NSString * addtime2;
@end
