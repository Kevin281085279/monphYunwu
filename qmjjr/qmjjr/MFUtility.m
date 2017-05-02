//
//  MFUtility.m
//  monph
//
//  Created by 金KingHwa on 15/7/2.
//  Copyright (c) 2015年 monph. All rights reserved.
//

#import "MFUtility.h"
#import "NSString+MD5Addition.h"

#define  ACCESS_CODE  @"-OT-J#*)H^N#@%)#j-mofei-"
#define ORIGINAL_MAX_WIDTH 640.0f
@implementation MFUtility
+ (NSString *)getIPAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)getDate{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMMdd"];
    
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Pacific/Niue"];
    
    //NSLog(@"%@",[NSTimeZone knownTimeZoneNames]);
    
    [dateformatter setTimeZone:zone];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    //NSString *  locationString=@"20141229";
    NSLog(@"locationString:%@",locationString);
    
    return locationString;
}

+ (NSString *)getHour{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"HH"];
    
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [dateformatter setTimeZone:zone];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    return locationString;
}

+ (NSString *)getLiuLanTime{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"MM-dd hh:mm"];
    
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [dateformatter setTimeZone:zone];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    return locationString;
}

+ (NSString *)getDateByTime:(NSString *)timeStr days:(int)days{
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * date = [dateformatter dateFromString:timeStr];
    NSTimeInterval  timeInterval = 24*60*60;
    date = [NSDate dateWithTimeInterval:timeInterval*days sinceDate:date];
    
    [dateformatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString *  locationString=[dateformatter stringFromDate:date];
    
    NSLog(@"locationString:%@",locationString);
    
    return locationString;
}

+ (NSString *)getDateStrByTime:(NSString *)timeStr{
    
    if (timeStr.length == 0 || [timeStr intValue] == 0) {
        return @"";
    }
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    
    NSString * locationString = [dateformatter stringFromDate:date];
    
    return locationString;
}


+ (NSNumber *)getTimeIntervalByDateStr:(NSString *)timeStr{
    if (timeStr.length == 0) {
        return [NSNumber numberWithInt:0];
    }
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * date = [dateformatter dateFromString:timeStr];
//    NSTimeInterval times = date.timeIntervalSince1970;
//    NSTimeInterval times = [date timeIntervalSinceDate:date];
//    NSString * locationString = [NSString stringWithFormat:@"%f",times];
    
    return [NSNumber numberWithDouble:date.timeIntervalSince1970];
}

+ (NSTimeInterval)getTimeIntervalByDateStr2:(NSString *)timeStr{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * date = [dateformatter dateFromString:timeStr];
    
    NSDate * nowDate = [NSDate date];

    return [date timeIntervalSinceDate:nowDate];
}

+(NSString *)getDayWeekByTime:(NSString *)timeStr{
    NSString *weekDay;
    NSDate *dateNow;
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    dateNow = [dateformatter dateFromString:timeStr];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:dateNow];
    long weekNumber = [comps weekday]; //获取星期对应的长整形字符串
    //    long day=[comps day];//获取日期对应的长整形字符串
    //    long year=[comps year];//获取年对应的长整形字符串
    //    long month=[comps month];//获取月对应的长整形字符串
    //    long hour=[comps hour];//获取小时对应的长整形字符串
    //    long minute=[comps minute];//获取月对应的长整形字符串
    //    long second=[comps second];//获取秒对应的长整形字符串
    //    NSString *riQi =[NSString stringWithFormat:@"%ld日",day];//把日期长整形转成对应的汉字字符串
    switch (weekNumber) {
        case 1:
            weekDay=@"星期日";
            break;
        case 2:
            weekDay=@"星期一";
            break;
        case 3:
            weekDay=@"星期二";
            break;
        case 4:
            weekDay=@"星期三";
            break;
        case 5:
            weekDay=@"星期四";
            break;
        case 6:
            weekDay=@"星期五";
            break;
        case 7:
            weekDay=@"星期六";
            break;
            
        default:
            break;
    }
    //    weekDay=[riQi stringByAppendingString:weekDay];//这里我本身的程序里只需要日期和星期，所以上面的年月时分秒都没有用上
    return weekDay;
}
#pragma mark image scale utility
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 获取code
+ (NSString *)getCodeWithType:(NSString *)type
{
    NSString * code = [NSString stringWithFormat:@"%@%@%@",[MFUtility getDate],ACCESS_CODE,type];
    return [code stringFromMD5];
}
@end
