//
//  QuickLogViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/27.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "QuickLogViewController.h"
#import "ForgetPwdViewController.h"

@interface QuickLogViewController ()
{
    BOOL _isMember;
    NSInteger _second;
    NSTimer *_codeTimer;
}
@end

@implementation QuickLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.registerBtn.layer.cornerRadius = 5;
    self.registerBtn.layer.masksToBounds = YES;
    
    _isMember = YES;
    
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
    
    self.logType = LogTypeQuick;
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
- (void) setLogType:(LogType)logType
{
    _logType = logType;
    switch (logType) {
        case LogTypeQuick:
        {
            [self.registerBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                [make.top.equalTo(self.titleLabel.bottom).offset(180) priorityHigh];
            }];
            self.titleLabel.text = @"登录";
            [self.logTypeBtn setTitle:@"密码登录" forState:UIControlStateNormal];
            self.forgetPwdBtn.hidden = YES;
            
            [self.pwdTF mas_updateConstraints:^(MASConstraintMaker *make) {
                [make.top.equalTo(self.line1.bottom).offset(50) priorityHigh];
            }];
            self.pwdTF.hidden = YES;
            self.line3.hidden = YES;
            
            self.line2.hidden = NO;
            self.codeTF.hidden = NO;
            self.lineVer.hidden = NO;
            self.getCodeBtn.hidden = NO;
            
        }
            break;
        case LogTypeRegister:
        {
            [self.registerBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                [make.top.equalTo(self.titleLabel.bottom).offset(230) priorityHigh];
            }];
            self.titleLabel.text = @"登录";
            [self.logTypeBtn setTitle:@"密码登录" forState:UIControlStateNormal];
            self.forgetPwdBtn.hidden = YES;
            
            [self.pwdTF mas_updateConstraints:^(MASConstraintMaker *make) {
                [make.top.equalTo(self.line1.bottom).offset(50) priorityHigh];
            }];
            self.pwdTF.hidden = NO;
            self.line3.hidden = NO;
            
            self.line2.hidden = NO;
            self.codeTF.hidden = NO;
            self.lineVer.hidden = NO;
            self.getCodeBtn.hidden = NO;
        }
            break;
        case LogTypePwd:
        {
            [self.registerBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                [make.top.equalTo(self.titleLabel.bottom).offset(180) priorityHigh];
            }];
            self.titleLabel.text = @"密码登录";
            [self.logTypeBtn setTitle:@"快速登录" forState:UIControlStateNormal];
            self.forgetPwdBtn.hidden = NO;
            
            [self.pwdTF mas_updateConstraints:^(MASConstraintMaker *make) {
                [make.top.equalTo(self.line1.bottom) priorityHigh];
            }];
            self.pwdTF.hidden = NO;
            self.line3.hidden = NO;
            
            self.line2.hidden = YES;
            self.codeTF.hidden = YES;
            self.lineVer.hidden = YES;
            self.getCodeBtn.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

- (void) registerLogAction
{
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
        UserModel *userModel = (UserModel*)obj;
        [MFSystemManager shareManager].userModel = userModel;
        [MFSystemManager shareManager].isLogin = YES;
        BOOL res = [UserModel saveSingleModel:userModel forKey:@"userInfo"];
        if(res){
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存失败");
        }
    } failure:^(NSString *msg) {
        [ProgressHUD showError:msg];
        self.registerBtn.enabled = YES;
    }];
}

- (void) pwdLogAction
{
    NSString *mobilePhone = @"^[1][0-9]{10}$";
    NSPredicate *predicate_phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobilePhone];
    if (![predicate_phone evaluateWithObject:self.phoneTF.text]) {
        
        [ProgressHUD showError:@"请输入正确的11位手机号码"];
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
    self.registerBtn.enabled = NO;
    [ProgressHUD show];
    [NET_WORKING request4ModelWithType:RequestTypePost ClassName:@"UserModel" InterfaceUrl:POST_LOGIN InterFaceType:@"check-login" Parmeters:postDic Yuming:YU_MIMG_LOG Success:^(id obj) {
        [ProgressHUD dismiss];
        self.registerBtn.enabled = YES;
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
        self.registerBtn.enabled = YES;
        [ProgressHUD showError:msg];
    }];

}

- (void) quickLogAction
{
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
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefault objectForKey:DEVICE_TOKEN];
    if (!deviceToken) {
        deviceToken = @"";
    }
    NSDictionary *postDic = @{
                              @"mobile":self.phoneTF.text,
                              @"yzm":self.codeTF.text,
                              @"device":@"ios",
                              @"token":deviceToken,
                              @"pingtaiType":@"1"
                              };
    self.registerBtn.enabled = NO;
    [ProgressHUD show];
    [NET_WORKING request4ModelWithType:RequestTypePost ClassName:@"UserModel" InterfaceUrl:YZM_LOGIN InterFaceType:@"yzm-login" Parmeters:postDic Yuming:YU_MIMG_LOG Success:^(id obj) {
        [ProgressHUD dismiss];
        self.registerBtn.enabled = YES;
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
        self.registerBtn.enabled = YES;
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
#pragma mark ButtonActions
- (IBAction)forgetPwdAction:(id)sender {
    ForgetPwdViewController *forgetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPwdViewController"];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (IBAction)logTypeAction:(id)sender {
    if (self.logType == LogTypePwd) {
        if (_isMember) {
            self.logType = LogTypeQuick;
        }else{
            self.logType = LogTypeRegister;
        }
    }else{
        self.logType = LogTypePwd;
    }
}

- (IBAction)registerAction:(id)sender
{
    switch (self.logType) {
        case LogTypeQuick:
        {
            [self quickLogAction];
        }
            break;
        case LogTypeRegister:
        {
            [self registerLogAction];
        }
            break;
        case LogTypePwd:
        {
            [self pwdLogAction];
        }
            break;
            
        default:
            break;
    }

}
- (IBAction)getCodeAction:(id)sender
{
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
    self.logTypeBtn.enabled = NO;
    [NET_WORKING request4DicWithType:RequestTypePost InterfaceUrl:GET_CAPTCHA InterFaceType:@"get-captcha" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
        _isMember = [[dic objectForKey:@"is_user"] boolValue];
        if (_isMember) {
            self.logType = LogTypeQuick;
        }else{
            self.logType = LogTypeRegister;
        }
        self.logTypeBtn.enabled = YES;
    } failure:^(NSString *msg) {
        _second = 1;
        [ProgressHUD showError:msg];
        self.logTypeBtn.enabled = YES;
    }];

}
- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
