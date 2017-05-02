//
//  LogInViewController.h
//  huxinbao
//
//  Created by LiuKai on 2017/3/11.
//  Copyright © 2017年 hxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;

- (IBAction)closeAction:(id)sender;
- (IBAction)logInAction:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)forgetPWDAction:(id)sender;
@end
