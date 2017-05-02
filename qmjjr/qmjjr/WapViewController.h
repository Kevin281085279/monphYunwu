//
//  WapViewController.h
//  monph
//
//  Created by zhuna on 15/6/12.
//  Copyright (c) 2015年 monph. All rights reserved.
//

#import "BaseViewController.h"

@interface WapViewController : BaseViewController

@property (retain, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *urlStr;

@property (strong, nonatomic) NSString *imgStr;
@property (strong, nonatomic) NSString *contentStr;
@property (assign, nonatomic) BOOL isShare;

@end
