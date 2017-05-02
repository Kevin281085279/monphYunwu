//
//  MFSystemManager.h
//  monph
//
//  Created by 金KingHwa on 15/7/3.
//  Copyright (c) 2015年 monph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "CoreArchive.h"

@interface MFSystemManager : NSObject{
    NSTimer * mimaTimer;
}
@property (nonatomic,assign)BOOL isLogin;
@property (nonatomic,copy)NSString * linshiMima;
@property (nonatomic,copy)NSString * mimaTime;
@property (nonatomic,strong)UserModel * userModel;

+ (MFSystemManager *)shareManager;
- (BOOL)logOut;
@end
