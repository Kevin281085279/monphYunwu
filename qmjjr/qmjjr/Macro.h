//
//  Macro.h
//  JingWaiYou
//
//  Created by SaNPanG.K on 14-8-29.
//  Copyright (c) 2014年 ZhunNa. All rights reserved.
//

//Apple ID ： 975951327

#ifndef JingWaiYou_Macro_h
#define JingWaiYou_Macro_h

//#define Version @"3.4.1"//每次上传更改版本号

#define KeFuNum @"400000000"//400电话
#define KeFuUrl [NSURL URLWithString:@"telprompt://400-0371-921"]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
//背景，线，主色
#define DEFULT_LINE_COLOR RGBCOLOR(230, 230, 230)
#define DEFULT_BACKGROUND_COLOR RGBCOLOR(245, 245, 245)
#define DEFULT_NAV_COLOR RGBCOLOR(251, 251, 251)
//#define DEFULT_BLUE_COLOR RGBCOLOR(96, 217, 252)
#define DEFULT_BLUE_COLOR RGBCOLOR(53, 210, 255)

//字体颜色
#define FONT_COLOR_51 RGBCOLOR(51, 51, 51)
#define FONT_COLOR_130 RGBCOLOR(130, 130, 130)
#define FONT_COLOR_153 RGBCOLOR(153, 161, 172)
#define FONT_COLOR_200 RGBCOLOR(200, 200, 200)

#define TABBARHEIGHT 64

#define TABBARBUTTON 14 //突出的 部分

#define NumberPad  111//数字 键盘

#define FromIphone  1

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define Width_Ratio ScreenWidth/320
#define Height_Ratio (ScreenHeight/568<1?1:ScreenHeight/568)

#define Height_RatioFrom6 (ScreenHeight/568<1?568.0/667.0:ScreenHeight/667)


#define Font26 [UIFont systemFontOfSize:13]
#define Font28 [UIFont systemFontOfSize:14]
#define Font30 [UIFont systemFontOfSize:15]



#define strIsEmpty(str) (str==nil || [str length]<1 ? YES : NO )

#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define DownloadUrl @"https://itunes.apple.com/us/app/mo-fei-gong-yu/id887776293?&mt=8"
//#define DownloadUrl @"https://itunes.apple.com/cn/app/lu-xing-qing-dan-lu-you-chu/id981748795?mt=8"

#define RequestFailed @"请求数据失败，请稍后再试。"

#define evaluateAlert1 @"打败我们的不是天真,而是没有您的支持😊"
#define evaluateAlert2 @"相识已久,用的好不好,客官您给个评价吧🌹"
#define evaluateAlert3 @"如今有一个评价的机会您再不珍惜,我们就摊上事儿了,摊上大事儿了!"

#define alertCancel1 @"试试再说"
#define alertCancel2 @"继续观望"
#define alertCancel3 @"不再提醒"

#define alertSure1 @"支持一下"
#define alertSure2 @"赐个评价"
#define alertSure3 @"鼓励一下"

#define alertLog @"亲，你还没有登录"
#define alertLogSure @"去登录"
#define alertLogCancel @"先逛逛"

#define kTriggerOffSet 80.0f

#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]

#define CODESTRING (@"interface@#$%^*goulvxing")

#define Ios7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7? YES :NO)
#define Ios8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8? YES :NO)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define APP_NAME (@"全民经纪人")

#define UMengAppKey @""
#define UMengMasterSecret @""

#define UPushKey @"58f95aba8f4a9d27a300056e"
#define UPushAppSecret @"lqmthulfx533p4s3cudb1sj6oirx82w7"

#define SinaWeiBo @"sina"
#define Tencent @"qq"
#define Wechat @"wechat"

////旅行清单，分享微信，微博需要独立APPKey
//#define WeiXinAppID @"wx9c6ed6322c936eae"//支付Key
#define WeiXinAppID @"wxaa6d943d30e58b14"//支付Key
#define WeiXinAppSecret @"ff7f176f378701c12604ae65920f8cf8"
//#define SinaAppKey @"1897079170"
//#define SinaAppSecret @"151aec43cec22a6619484b88f6f1f2a6"
//#define QQAppID @"1104451945"
//#define QQAppKey @"hZOUAFufKQl0YkpA"
//独立APPKEY
#define WeiXinAppIDShare @"wx51ec86535f46f292"//分享Key
#define WeiXinAppSecretShare @"0a855363e6774dc3061a583a32cda1a3"
#define SinaAppKey @"659952310"
#define SinaAppSecret @"8027a7b1f2328d89f9e8bd101bf8bd16"
#define QQAppID @"1104786932"
#define QQAppKey @"cWxU7D69pxmEpulC"

#define SERVICE @"com.game.userinfo"
#define ACCOUNT @"uuid"


//支付信息 宏定义

//支付宝信息
#define ALIPAY_APPID @""

//微信信息



#define TISHI @"数据加载中..."

#define DEVICE_TOKEN @"deviceToken"

#define FILTESTRDIC @"filteStrDic"

#endif
