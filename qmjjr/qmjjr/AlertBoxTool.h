//
//  AlertBoxTool.h
//  zhuna2.0
//
//  Created by zyj on 14-5-9.
//  Copyright (c) 2014年 zhuna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertBoxTool : NSObject <UIAlertViewDelegate>{
    
  
}


/*
 
 [AlertBoxTool AlertWithTitle:@"提示" message:@"你想干啥？" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" alertView:^(UIAlertView *alertView, NSInteger buttonIndex) {
 
 }];
 
 */

/**
 *  系统
 */
+(void)AlertWithTitle:(NSString*)string
              message:(NSString*)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSString *)otherButtonTitles
            alertView:(void (^)( UIAlertView *alertView, NSInteger buttonIndex))alertView;

/**
 *  系统  三选
 */
+(void)AlertWithTitle:(NSString*)string
              message:(NSString*)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSString *)otherButtonTitles
   otherButtonTitles1:(NSString *)otherButtonTitles1
            alertView:(void (^)( UIAlertView *alertView, NSInteger buttonIndex))alertView;

+(void)AlertWithTitle:(NSString*)string
              message:(NSString*)message
                style:(UIAlertViewStyle)style
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSString *)otherButtonTitles
            alertView:(void (^)( UIAlertView *alertView, NSInteger buttonIndex))alertView;
@end
