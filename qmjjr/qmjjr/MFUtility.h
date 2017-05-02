//
//  MFUtility.h
//  monph
//
//  Created by 金KingHwa on 15/7/2.
//  Copyright (c) 2015年 monph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface MFUtility : NSObject
+ (NSString *)getIPAddress;
+ (NSString *)getDate;
+ (NSString *)getHour;
+ (NSString *)getLiuLanTime;
+ (NSString *)getDateByTime:(NSString *)timeStr days:(int)days;
+(NSString *)getDayWeekByTime:(NSString *)timeStr;
+ (NSString *)getDateStrByTime:(NSString *)timeStr;
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;
+ (NSNumber *)getTimeIntervalByDateStr:(NSString *)timeStr;
+ (NSTimeInterval)getTimeIntervalByDateStr2:(NSString *)timeStr;

+ (NSString *)getCodeWithType:(NSString *)type;
@end
