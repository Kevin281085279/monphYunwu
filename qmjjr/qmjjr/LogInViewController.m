//
//  LogInViewController.m
//  huxinbao
//
//  Created by LiuKai on 2017/3/11.
//  Copyright © 2017年 hxb. All rights reserved.
//

#import "LogInViewController.h"
#import "RegisterViewController.h"
#import <ProgressHUD.h>
#import "LKNetWorkingUtil.h"
#import "NSString+MD5Addition.h"
#import "UserModel.h"
#import "MFSystemManager.h"
#import <MJExtension.h>
#import "ForgetPwdViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.logInBtn.layer.cornerRadius = 5;
    self.logInBtn.layer.masksToBounds = YES;
    
    UIImageView *nameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_number"]];
    nameView.frame = CGRectMake(0, 0, 40, 49);
    nameView.contentMode = UIViewContentModeCenter;
    UIImageView *pwdView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_cipher"]];
    pwdView.frame = CGRectMake(0, 0, 40, 49);
    pwdView.contentMode = UIViewContentModeCenter;
    self.phoneTF.leftView = nameView;
    self.phoneTF.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTF.leftView = pwdView;
    self.pwdTF.leftViewMode = UITextFieldViewModeAlways;
    
    //测试用
//    self.phoneTF.text = @"15238655643";
//    self.pwdTF.text = @"haha123";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)logInAction:(id)sender {
    if (self.phoneTF.text.length < 5) {
        [ProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if (self.pwdTF.text.length < 6) {
        [ProgressHUD showError:@"请输入六位以上密码"];
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefault objectForKey:DEVICE_TOKEN];
    if (!deviceToken) {
        deviceToken = @"";
    }
    NSDictionary *postDic = @{
                              @"mobile":self.phoneTF.text,
                              @"password":self.pwdTF.text,
                              @"device":@"ios",
                              @"token":deviceToken,
                              @"pingtaiType":@"1"
                              };
    self.logInBtn.enabled = NO;
    [ProgressHUD show];
    [NET_WORKING request4ModelWithType:RequestTypePost ClassName:@"UserModel" InterfaceUrl:POST_LOGIN InterFaceType:@"check-login" Parmeters:postDic Yuming:YU_MIMG_LOG Success:^(id obj) {
        [ProgressHUD dismiss];
        self.logInBtn.enabled = YES;
        UserModel *userModel = (UserModel*)obj;
        [MFSystemManager shareManager].userModel = userModel;
        [MFSystemManager shareManager].isLogin = YES;
        BOOL res = [UserModel saveSingleModel:userModel forKey:@"userInfo"];
        if(res){
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存失败");
        }

        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString *msg) {
        self.logInBtn.enabled = YES;
         [ProgressHUD showError:msg];
    }];
}

- (IBAction)registerAction:(id)sender {
    RegisterViewController *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)forgetPWDAction:(id)sender {
    ForgetPwdViewController *forgetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPwdViewController"];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
@end
