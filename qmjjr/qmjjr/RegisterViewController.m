//
//  RegisterViewController.m
//  huxinbao
//
//  Created by LiuKai on 2017/3/11.
//  Copyright © 2017年 hxb. All rights reserved.
//

#import "RegisterViewController.h"
#import "LKNetWorkingUtil.h"
#import "RequestURL.h"
#import "NSString+MD5Addition.h"
#import <ProgressHUD.h>
#import <Masonry.h>
#import "Macro.h"
#import "AlertBoxTool.h"

@interface RegisterViewController ()
{
    NSInteger _second;
    NSTimer *_codeTimer;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.registerBtn.layer.cornerRadius = 5;
    self.registerBtn.layer.masksToBounds = YES;
    
    [self.selectBtn setImage:[UIImage imageNamed:@"Login_selected"] forState:UIControlStateSelected];
    [self.selectBtn setImage:[UIImage imageNamed:@"Login_normal"] forState:UIControlStateNormal];

    NSArray *tfArr = @[self.phoneTF,self.codeTF,self.pwdTF,self.tjPhoneTF];
    NSArray *imgNameArr = @[@"Login_number",@"Login_Verify",@"Login_cipher",@"Login_cipher"];
    for (UITextField *textField in tfArr) {
        NSInteger index = [tfArr indexOfObject:textField];
        NSString *imgName = [imgNameArr objectAtIndex:index];
        UIImageView *leftView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        leftView.frame = CGRectMake(0, 0, 40, 49);
        leftView.contentMode = UIViewContentModeCenter;
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registerAction:(id)sender {
    NSString *mobilePhone = @"^[1][0-9]{10}$";
    NSPredicate *predicate_phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobilePhone];
    if (![predicate_phone evaluateWithObject:self.phoneTF.text]) {

        [ProgressHUD showError:@"请输入正确的11位手机号码"];
        return;
    }
    if (self.codeTF.text.length < 1) {
        [ProgressHUD showError:@"请输入验证码"];
        return;
    }
    if (self.pwdTF.text.length < 1) {
        [ProgressHUD showError:@"请输入密码"];
        return;
    }
    if (![self.pwdTF.text isEqualToString:self.tjPhoneTF.text]) {

        [ProgressHUD showError:@"两次输入密码不同"];
        return;
    }
//    if (!self.selectBtn.selected) {
//        [ProgressHUD showError:@"请阅读并同意注册协议"];
//        return;
//    }
    NSString *pwd = self.pwdTF.text;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefault objectForKey:DEVICE_TOKEN];
    if (!deviceToken) {
        deviceToken = @"";
    }
    NSDictionary *paramDic = @{
                               @"mobile":self.phoneTF.text,
                               @"password":pwd,
                               @"yzm":self.codeTF.text,
                               @"device":@"ios",
                               @"token":deviceToken,
                               @"pingtaiType":@"1",
                               @"agentId":@"262"
                               };
    self.registerBtn.enabled = NO;
    [ProgressHUD show];
    [NET_WORKING request4ModelWithType:RequestTypePost ClassName:@"UserModel" InterfaceUrl:POST_REGISTER InterFaceType:@"register" Parmeters:paramDic Yuming:YU_MIMG_LOG Success:^(id obj) {
        [ProgressHUD dismiss];
        self.registerBtn.enabled = YES;
        [AlertBoxTool AlertWithTitle:nil message:@"注册成功！" cancelButtonTitle:@"去登陆" otherButtonTitles:nil alertView:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self backAction:nil];
        }];
    } failure:^(NSString *msg) {
        [ProgressHUD showError:msg];
        self.registerBtn.enabled = YES;
    }];
    

}

- (IBAction)getCodeAction:(id)sender {
//    if (self.phoneTF.text.length < 5) {
//        [ProgressHUD showError:@"请输入正确的手机号"];
//        return;
//    }
    NSString *mobilePhone = @"^[1][0-9]{10}$";
    NSPredicate *predicate_phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobilePhone];
    if (![predicate_phone evaluateWithObject:self.phoneTF.text]) {
        [ProgressHUD showError:@"请输入正确的11位手机号码"];
        return;
    }
    self.getCodeBtn.enabled = NO;
    _second = 60;
    
    [self.getCodeBtn setTitleColor:FONT_COLOR_200 forState:UIControlStateNormal];
    
    NSString *titleStr = [NSString stringWithFormat:@"%ld秒后重新获取",(long)_second];
    [self.getCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        [make.width.equalTo(@100) priorityHigh];;
    }];
    [self.getCodeBtn setTitle:titleStr forState:UIControlStateNormal];
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    
    NSDictionary *postDic = @{
                              @"mobile":self.phoneTF.text
                              };
    [NET_WORKING request4ModelWithType:RequestTypePost ClassName:@"UserModel" InterfaceUrl:GET_CAPTCHA InterFaceType:@"get-captcha" Parmeters:postDic Yuming:YU_MINGV3 Success:^(id obj) {
        
    } failure:^(NSString *msg) {
        _second = 1;
        [ProgressHUD showError:msg];
    }];
}

- (void) countTime
{
    _second--;
    NSString *titleStr = [NSString stringWithFormat:@"%ld秒后重新获取",(long)_second];
    [self.getCodeBtn setTitle:titleStr forState:UIControlStateNormal];
    if (_second == 0) {
        [_codeTimer invalidate];
        [self.getCodeBtn setTitleColor:DEFULT_BLUE_COLOR forState:UIControlStateNormal];
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            [make.width.equalTo(@80) priorityHigh];;
        }];
        self.getCodeBtn.enabled = YES;
    }
}

- (IBAction)xieyiAction:(id)sender {
}

- (IBAction)selectAction:(id)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
}

- (IBAction)backAction:(id)sender {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
@end
