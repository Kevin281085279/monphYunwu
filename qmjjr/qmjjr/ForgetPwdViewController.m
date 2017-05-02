//
//  ForgetPwdViewController.m
//  huxinbao
//
//  Created by zhuna on 2017/3/30.
//  Copyright © 2017年 hxb. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "NSString+MD5Addition.h"

@interface ForgetPwdViewController ()
{
    NSInteger _second;
    NSTimer *_codeTimer;
}
@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.registerBtn.layer.cornerRadius = 5;
    self.registerBtn.layer.masksToBounds = YES;
    
    NSArray *tfArr = @[self.phoneTF,self.codeTF,self.pwdTF];
    NSArray *imgNameArr = @[@"Login_number",@"Login_Verify",@"Login_cipher"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

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
    if (self.pwdTF.text.length < 6) {
        [ProgressHUD showError:@"请输入六位以上密码"];
        return;
    }

    NSString *pwd = self.pwdTF.text;
    
    NSDictionary *paramDic = @{
                               @"mobile":self.phoneTF.text,
                               @"password":pwd,
                               @"yzm":self.codeTF.text
                               };
    self.registerBtn.enabled = NO;
    [ProgressHUD show];
    [NET_WORKING request4ModelWithType:RequestTypePost ClassName:@"UserModel" InterfaceUrl:GET_BACK_PASSWORD InterFaceType:@"get-back-password" Parmeters:paramDic Yuming:YU_MIMG_LOG Success:^(id obj) {
        [ProgressHUD dismiss];
        self.registerBtn.enabled = YES;
        [AlertBoxTool AlertWithTitle:nil message:@"重置密码成功！" cancelButtonTitle:@"去登陆" otherButtonTitles:nil alertView:^(UIAlertView *alertView, NSInteger buttonIndex) {
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

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
