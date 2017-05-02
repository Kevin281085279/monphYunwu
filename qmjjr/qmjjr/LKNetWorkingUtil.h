//
//  LKNetWorkingUtil.h
//  huxinbao
//
//  Created by LiuKai on 2017/3/14.
//  Copyright © 2017年 hxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestURL.h"
#import <AFNetworking.h>

typedef enum : NSUInteger{
    RequestTypeGet       = 0,
    RequestTypePost      = 1,
}RequestType;

@interface LKNetWorkingUtil : NSObject
/**
 *  单例类
 */
+ (LKNetWorkingUtil *)shareUtil;

/**
 *  直接返回 数据 model
 *
 *  @param className     model类名
 *  @param interfaceUrl  接口地址
 */
- (void)request4ModelWithType:(RequestType)type
                    ClassName:(NSString *)className
                 InterfaceUrl:(NSString *)interfaceUrl
                InterFaceType:(NSString*)interfaceType
                    Parmeters:(NSDictionary *)parmeters
                       Yuming:(NSString *)yuming
                      Success:(void (^)(id obj))success
                      failure:(void (^)(NSString * msg))failureMSG;

/**
 *  返回含有数据model的 数组
 *
 *  @param className     model类名
 */
- (void)request4ArrayWithType:(RequestType)type
                    ClassName:(NSString *)className
                 InterfaceUrl:(NSString *)interfaceUrl
                InterFaceType:(NSString*)interfaceType
                    Parmeters:(NSDictionary *)parmeters
                       Yuming:(NSString *)yuming
                      Success:(void (^)(NSArray * arr))success
                      failure:(void (^)(NSString * msg))failureMSG;

/**
 *  返回含有数据model的数组和数据总页数，用于分页
 *
 *  @param className     model类名
 */
- (void)request4ArrayAndPageTotalWithType:(RequestType)type
                                ClassName:(NSString *)className
                             InterfaceUrl:(NSString *)interfaceUrl
                            InterFaceType:(NSString*)interfaceType
                                Parmeters:(NSDictionary *)parmeters
                                   Yuming:(NSString *)yuming
                                  Success:(void (^)(NSArray * arr,int pageTotal))success
                                  failure:(void (^)(NSString * msg))failureMSG;

/**
 *  直接返回字典，无model类名
 *  增添域名
 *  云屋
 */
- (void)request4DicWithType:(RequestType)type
               InterfaceUrl:(NSString *)interfaceUrl
              InterFaceType:(NSString*)interfaceType
                  Parmeters:(NSDictionary *)parmeters
                     yuming:(NSString *)yuming
                    Success:(void (^)(NSDictionary * dic))success
                    failure:(void (^)(NSString * msg))failureMSG;

#pragma mark - 基础图片Post
- (void)BasePicturePostMethodByURL:(NSString *)url
                               Img:(UIImage *)img
                            Imgkey:(NSString *)imgKey
                        Parameters:(NSDictionary *)parameters
                           Success:(void (^)(NSDictionary * dic))success
                           failure:(void (^)(NSString * msg))failureMSG;



@end
