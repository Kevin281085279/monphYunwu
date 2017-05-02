//
//  QuickLogViewController.h
//  qmjjr
//
//  Created by zhuna on 2017/4/27.
//  Copyright © 2017年 monph. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger{
    LogTypeQuick       = 0,
    LogTypeRegister    = 1,
    LogTypePwd         = 2,
}LogType;

@interface QuickLogViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIView *lineVer;
@property (weak, nonatomic) IBOutlet UIButton *logTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;

@property (assign, nonatomic) LogType logType;

- (IBAction)forgetPwdAction:(id)sender;

- (IBAction)logTypeAction:(id)sender;

- (IBAction)registerAction:(id)sender;
- (IBAction)getCodeAction:(id)sender;
- (IBAction)backAction:(id)sender;
@end
