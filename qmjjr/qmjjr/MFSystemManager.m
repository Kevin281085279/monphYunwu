//
//  MFSystemManager.m
//  monph
//
//  Created by 金KingHwa on 15/7/3.
//  Copyright (c) 2015年 monph. All rights reserved.
//

#import "MFSystemManager.h"

static MFSystemManager * manager = nil;

@implementation MFSystemManager

+ (MFSystemManager *)shareManager{
    @synchronized(self){
        if (manager == nil) {
            manager = [[self alloc] init];
            manager.isLogin = NO;
            manager.userModel = nil;
        }
        return manager;
    }
}
+ (id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if (manager == nil) {
            manager = [super allocWithZone:zone];
            return manager;
        }
    }
    return nil;
}
- (id)copyWithZone:(NSZone *)zone{
    return self;
}


- (BOOL)logOut{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Badge"
                                                        object:nil
                                                      userInfo:@{@"fixtime":[NSNumber numberWithBool:0],
                                                                 @"jfnum":[NSNumber numberWithBool:0],
                                                                 @"msgnum":[NSNumber numberWithBool:0]}];
    
    self.isLogin = NO;
    BOOL res = [UserModel saveSingleModel:nil forKey:@"userInfo"];
    if (res) {
        self.userModel = nil;
        return YES;
    }else{
        return NO;
    }
}


@end
