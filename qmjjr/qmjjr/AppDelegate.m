//
//  AppDelegate.m
//  qmjjr
//
//  Created by zhuna on 2017/4/12.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "AppDelegate.h"
#import <UMessage.h>
#import <UserNotifications/UserNotifications.h>
#import "MessageViewController.h"
#import "GuideViewController.h"
#import "BaseNavgationController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    [UMessage startWithAppkey:UPushKey launchOptions:launchOptions];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    [self loadUserInfo];
    
    [self loadMainView];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) loadMainView
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:currentVersion]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:currentVersion];
        //第一次启动
        GuideViewController *guideVC = [[GuideViewController alloc] init];
        self.window.rootViewController = guideVC;
    }else{
        //不是第一次启动了
//        GuideViewController *guideVC = [[GuideViewController alloc] init];
//        self.window.rootViewController = guideVC;
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BaseNavgationController *mainVC = [storyBoard instantiateViewControllerWithIdentifier:@"BaseNavgationController"];
        self.window.rootViewController = mainVC;
    }
}
#pragma mark -推送处理
#pragma mark -推送处理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"DeviceToken ===================== %@",[[[[deviceToken description]
                                                     stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                                                   stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<" withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSString *devName = [[UIDevice currentDevice] model];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:devToken forKey:DEVICE_TOKEN];

    if (!devToken) {
        return;
    }
    NSDictionary *postDic = @{
                              @"type":@"1",
                              @"token":devToken,
                              @"device":devName
                              };
    [NET_WORKING request4DicWithType:RequestTypePost InterfaceUrl:ADD_DEVICE_TOKEN InterFaceType:@"add-device-token" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
        NSLog(@"设备token记录成功");
    } failure:^(NSString *msg) {
        NSLog(@"设备token记录失败");
    }];
//    [JHRequestManager requestSendToken:dic Success:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
//    } failure:^(NSString *msg) {
//        NSLog(@"失败");
//    }];
    
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    //关闭友盟对话框
    [UMessage setAutoAlert:NO];
    //此方法不要删除
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        [AlertBoxTool AlertWithTitle:@"收到推送消息" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] cancelButtonTitle:@"取消" otherButtonTitles:@"去看看" alertView:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self turnToMsgVC];
        }];

    }else{
        [self turnToMsgVC];
    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [self turnToMsgVC];
    }else{
        //应用处于后台时的本地推送接受
        [self turnToMsgVC];
    }
}

- (void) turnToMsgVC
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MessageViewController *msgvc = [story instantiateViewControllerWithIdentifier:@"MessageViewController"];
    [(UINavigationController*)self.window.rootViewController pushViewController:msgvc animated:YES];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 获取用户信息
- (void)loadUserInfo{
    UserModel * userModel = [UserModel readSingleModelForKey:@"userInfo"];
    if (userModel) {
        [MFSystemManager shareManager].isLogin = YES;
        [MFSystemManager shareManager].userModel = userModel;
    }
}
@end
