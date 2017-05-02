//
//  RegisterViewController.h
//  huxinbao
//
//  Created by LiuKai on 2017/3/11.
//  Copyright © 2017年 hxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *tjPhoneTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)registerAction:(id)sender;
- (IBAction)getCodeAction:(id)sender;
- (IBAction)xieyiAction:(id)sender;
- (IBAction)selectAction:(id)sender;
- (IBAction)backAction:(id)sender;
@end
