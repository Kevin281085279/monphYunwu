//
//  ForgetPwdViewController.h
//  huxinbao
//
//  Created by zhuna on 2017/3/30.
//  Copyright © 2017年 hxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)registerAction:(id)sender;
- (IBAction)getCodeAction:(id)sender;
- (IBAction)backAction:(id)sender;
@end
