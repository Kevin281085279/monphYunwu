//
//  LKNetWorkingUtil.m
//  huxinbao
//
//  Created by LiuKai on 2017/3/14.
//  Copyright © 2017年 hxb. All rights reserved.
//

#import "LKNetWorkingUtil.h"
#import <ProgressHUD.h>
#import "NSString+MD5Addition.h"
#import "MFUtility.h"
#import "MJExtension.h"

#define  ACCESS_CODE  @"-OT-J#*)H^N#@%)#j-mofei-"
@implementation LKNetWorkingUtil

static LKNetWorkingUtil * instance = nil;
static int netWorkState;

+(LKNetWorkingUtil *)shareUtil{
    if (!instance) {
        instance = [[super allocWithZone:NULL] init];
        [self reach];
        netWorkState = 2;
    }
    return instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self shareUtil];
}
- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)init {
    if (instance) {
        return instance;
    }
    self = [super init];
    return self;
}
#pragma mark - 获取全民经纪人URL
- (NSString *)getRequestUrlWithInterfaceUrl:(NSString *)interfaceUrl Yuming:(NSString *)yuming Type:(NSString*)type{
    NSString * tempURL = [NSString stringWithFormat:@"%@%@code=%@",yuming,interfaceUrl,
                          [MFUtility getCodeWithType:type]];
    return tempURL;
}

- (NSDictionary *)configUserIdToPara:(NSDictionary *)para{
    NSMutableDictionary *requestPara = nil;
    if (para) {
        requestPara = [[NSMutableDictionary alloc] initWithDictionary:para];
    }else{
        requestPara = [[NSMutableDictionary alloc] init];
    }
    
    UserModel *userLoginModel = [MFSystemManager shareManager].userModel;
    if (userLoginModel) {
        [requestPara setObject:userLoginModel.uID forKey:@"uid"];
    }
//    [requestPara setObject:@"iphone" forKey:@"os"];
//    [requestPara setObject:Version forKey:@"version"];
    return requestPara;
}


#pragma mark -
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
                      failure:(void (^)(NSString * msg))failureMSG{
    parmeters = [self configUserIdToPara:parmeters];
    NSString * url = [self getRequestUrlWithInterfaceUrl:interfaceUrl Yuming:yuming Type:interfaceType];
    
//    @"code":[MFUtility getCodeWithType:@"register"]
    
    [self baseRequestType:type URL:url Parameters:parmeters Success:^(NSDictionary *dic) {
        NSDictionary *tempDic = [self deleteEmpty:dic];
        Class class = NSClassFromString(className);
        id obj = [class mj_objectWithKeyValues:tempDic];
        success(obj);
    } failure:^(NSString *msg) {
        failureMSG(msg);
    }];
}

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
                      failure:(void (^)(NSString * msg))failureMSG{
    NSString * url = [self getRequestUrlWithInterfaceUrl:interfaceUrl Yuming:yuming Type:interfaceType];
    parmeters = [self configUserIdToPara:parmeters];
    [self baseRequestType:type URL:url Parameters:parmeters Success:^(NSDictionary *dic) {
        NSArray * dicArr = [self deleteEmptyArr:(NSArray *)dic];
        //        NSArray * dicArr = (NSArray *)dic;
        Class class = NSClassFromString(className);
        NSArray * arr = [class mj_objectArrayWithKeyValuesArray:dicArr];
        success(arr);
    } failure:^(NSString *msg) {
        failureMSG(msg);
    }];
}

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
                                  failure:(void (^)(NSString * msg))failureMSG{
    NSString * url = [self getRequestUrlWithInterfaceUrl:interfaceUrl Yuming:yuming Type:interfaceType];
    parmeters = [self configUserIdToPara:parmeters];
    [self baseRequestType:type URL:url Parameters:parmeters Success:^(NSDictionary *dic) {
        NSDictionary *tempDic = [self deleteEmpty:dic];
        Class class = NSClassFromString(className);
        NSArray * arr = [class mj_objectArrayWithKeyValuesArray:tempDic[@"list"]];
        success(arr,[[tempDic objectForKey:@"page_count"] intValue]);
    } failure:^(NSString *msg) {
        failureMSG(msg);
    }];
}


/**
 *  直接返回字典，无model类名
 *  增添域名 云屋
 */
- (void)request4DicWithType:(RequestType)type
               InterfaceUrl:(NSString *)interfaceUrl
              InterFaceType:(NSString*)interfaceType
                  Parmeters:(NSDictionary *)parmeters
                     yuming:(NSString *)yuming
                    Success:(void (^)(NSDictionary * dic))success
                    failure:(void (^)(NSString * msg))failureMSG{
    NSString * url = [self getRequestUrlWithInterfaceUrl:interfaceUrl Yuming:yuming Type:interfaceType];
    parmeters = [self configUserIdToPara:parmeters];
    [self baseRequestType:type URL:url Parameters:parmeters Success:^(NSDictionary *dic) {
        if ([dic isKindOfClass:[NSArray class]]) {
            NSArray * dicArr = [self deleteEmptyArr:(NSArray *)dic];
            success((NSDictionary *)dicArr);
        }else{
            NSDictionary *tempDic = [self deleteEmpty:dic];
            success(tempDic);
        }
    } failure:^(NSString *msg) {
        failureMSG(msg);
    }];
}

- (void)baseRequestType:(RequestType)type
                    URL:(NSString *)url
             Parameters:(NSDictionary *)parameters
                Success:(void (^)(NSDictionary * dic))success
                failure:(void (^)(NSString * msg))failureMSG{
    switch (type) {
        case RequestTypeGet:
        {
            [self BaseGetMethodByURL:url Parameters:parameters Success:^(NSDictionary *dic) {
                success(dic);
            } failure:^(NSString *msg) {
                failureMSG(msg);
            }];
        }
            break;
            
        default:
        {
            [self BasePostMethodByURL:url Parameters:parameters Success:^(NSDictionary *dic) {
                success(dic);
            } failure:^(NSString *msg) {
                failureMSG(msg);
            }];
        }
            break;
    }
}


#pragma mark - 基础get请求
- (void)BaseGetMethodByURL:(NSString *)url
                Parameters:(NSDictionary *)parameters
                   Success:(void (^)(NSDictionary * dic))success
                   failure:(void (^)(NSString * msg))failureMSG
{
    if (![self isConnection]) {
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = YES;
    manager.securityPolicy  = securityPolicy;
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    
    NSLog(@"url====>%@  \n  parameters====>%@",url,parameters);
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //success(responseObject);
         NSDictionary * dic = (NSDictionary *)responseObject;
         NSLog(@"********%@",dic);
         if ([[dic objectForKey:@"retsuces"] integerValue] == 1) {
             success([dic objectForKey:@"reqdata"]);
         }else{
             failureMSG([dic objectForKey:@"retmsg"]);
         }
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failureMSG(@"请求错误");
     }];
}

#pragma mark - 基础post请求
- (void)BasePostMethodByURL:(NSString *)url
                 Parameters:(NSDictionary *)parameters
                    Success:(void (^)(NSDictionary * dic))success
                    failure:(void (^)(NSString * msg))failureMSG
{
    if (![self isConnection]) {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = YES;
    manager.securityPolicy  = securityPolicy;
    
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    NSLog(@"url====>%@  \n  parameters====>%@",url,parameters);
    [manager POST:url
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary * dic = (NSDictionary *)responseObject;
              NSLog(@"********%@",dic);
              if ([[dic objectForKey:@"retsuces"] integerValue] == 1) {
                  success([dic objectForKey:@"reqdata"]);
              }else{
                  failureMSG([dic objectForKey:@"retmsg"]);
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failureMSG(@"请求错误");
          }];

    
}


#pragma mark - 基础图片Post
- (void)BasePicturePostMethodByURL:(NSString *)url
                               Img:(UIImage *)img
                            Imgkey:(NSString *)imgKey
                        Parameters:(NSDictionary *)parameters
                           Success:(void (^)(NSDictionary * dic))success
                           failure:(void (^)(NSString * msg))failureMSG{
    if (![self isConnection]) {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    // 设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    [ProgressHUD show:@"图片上传中..."];
    NSData * imgData = UIImageJPEGRepresentation([MFUtility imageByScalingToMaxSize:img], 1.0);
    
//    NSString * urlStr = [NSString stringWithFormat:@"%@%@",YU_MING,@"other/uploadPhoto.php?"];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imgData name:imgKey fileName:fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        NSLog(@"=======%@",dic);
        if ([[dic objectForKey:@"retsuces"] integerValue] == 1) {
//            [ProgressHUD dismiss];
            
            success([dic objectForKey:@"reqdata"]);
        }else{
            failureMSG([dic objectForKey:@"retmsg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureMSG(@"请求错误");
        //        [ProgressHUD dismiss];
//        [ProgressHUD showError:@"请求错误"];
    }];
    
}

/*
 #pragma mark - Session 下载
 - (void)sessionDownloadWithURL:(NSString *)urlString
 {
 NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
 
 //    urlString = @"http://localhost/itcast/videos/01.C语言-语法预览.mp4";
 urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
 NSURL *url = [NSURL URLWithString:urlString];
 NSURLRequest *request = [NSURLRequest requestWithURL:url];
 
 NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
 // 指定下载文件保存的路径
 //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
 // 将下载文件保存在缓存路径中
 NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
 NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
 
 // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
 NSURL *fileURL1 = [NSURL URLWithString:path];
 NSURL *fileURL = [NSURL fileURLWithPath:path];
 
 NSLog(@"== %@ |||| %@", fileURL1, fileURL);
 
 return fileURL;
 } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
 NSLog(@"%@ %@", filePath, error);
 }];
 
 [task resume];
 }
 */

/**
 *  @author Jakey
 *
 *  @brief  下载文件
 *
 *  @param paramDic   附加post参数
 *  @param requestURL 请求地址
 *  @param savedPath  保存 在磁盘的位置
 *  @param success    下载成功回调
 *  @param failure    下载失败回调
 *  @param progress   实时下载进度回调
 
 - (void)downloadFileWithOption:(NSDictionary *)paramDic
 withInferface:(NSString*)requestURL
 savedPath:(NSString*)savedPath
 downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
 downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
 progress:(void (^)(float progress))progress
 
 {
 
 //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
 AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
 NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:paramDic error:nil];
 
 AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
 [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
 [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
 float p = (float)totalBytesRead / totalBytesExpectedToRead;
 progress(p);
 NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
 
 }];
 
 [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 success(operation,responseObject);
 NSLog(@"下载成功");
 
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 failure(operation,error);
 NSLog(@"下载失败");
 
 }];
 
 [operation start];
 
 }
 */
#pragma mark - 检测网路状态
-(BOOL)isConnection
{
    if (netWorkState < 1)
    {
        return NO;
    }
    return YES;
}
+ (void)reach{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        netWorkState = status;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [ProgressHUD showError:@"当前网络不可用，请检测网络"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [ProgressHUD showError:@"当前网络不可用，请检测网络"];
                break;
            default:
                break;
        }
    }];
}


//删除字典里的null值
- (NSDictionary *)deleteEmpty:(NSDictionary *)dic
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return dic;
    }
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    NSMutableArray *set = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicSet = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *arrSet = [[NSMutableDictionary alloc] init];
    for (id obj in mdic.allKeys)
    {
        id value = mdic[obj];
        if ([value isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *changeDic = [self deleteEmpty:value];
            [dicSet setObject:changeDic forKey:obj];
        }
        else if ([value isKindOfClass:[NSArray class]])
        {
            NSArray *changeArr = [self deleteEmptyArr:value];
            [arrSet setObject:changeArr forKey:obj];
        }
        else
        {
            if ([value isKindOfClass:[NSNull class]]) {
                [set addObject:obj];
            }
        }
    }
    for (id obj in set)
    {
        mdic[obj] = @"";
    }
    for (id obj in dicSet.allKeys)
    {
        mdic[obj] = dicSet[obj];
    }
    for (id obj in arrSet.allKeys)
    {
        mdic[obj] = arrSet[obj];
    }
    
    return mdic;
}

//删除数组中的null值
- (NSArray *)deleteEmptyArr:(NSArray *)arr
{
    NSMutableArray *marr = [NSMutableArray arrayWithArray:arr];
    NSMutableArray *set = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicSet = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *arrSet = [[NSMutableDictionary alloc] init];
    
    for (id obj in marr)
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *changeDic = [self deleteEmpty:obj];
            NSInteger index = [marr indexOfObject:obj];
            [dicSet setObject:changeDic forKey:@(index)];
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            NSArray *changeArr = [self deleteEmptyArr:obj];
            NSInteger index = [marr indexOfObject:obj];
            [arrSet setObject:changeArr forKey:@(index)];
        }
        else
        {
            if ([obj isKindOfClass:[NSNull class]]) {
                NSInteger index = [marr indexOfObject:obj];
                [set addObject:@(index)];
            }
        }
    }
    for (id obj in set)
    {
        marr[(int)obj] = @"";
    }
    for (id obj in dicSet.allKeys)
    {
        int index = [obj intValue];
        marr[index] = dicSet[obj];
    }
    for (id obj in arrSet.allKeys)
    {
        int index = [obj intValue];
        marr[index] = arrSet[obj];
    }
    return marr;
}

@end
