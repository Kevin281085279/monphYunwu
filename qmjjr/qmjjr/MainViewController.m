//
//  MainViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/17.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "MainViewController.h"
#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "UserInfoTableViewController.h"
#import "TuiJianViewController.h"
#import "YongJinViewController.h"
#import "KeHuListViewController.h"
#import "MessageViewController.h"
#import "WapViewController.h"
#import "QuickLogViewController.h"

@interface MainViewController ()<UIGestureRecognizerDelegate>
{
    BOOL _hiddenNav;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DEFULT_BACKGROUND_COLOR;
    
    [self.topBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        [make.width.mas_equalTo(ScreenWidth) priorityHigh];
        [make.height.mas_equalTo(@(205 * Height_Ratio)) priorityHigh];
    }];
    [self.btnBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        [make.height.mas_equalTo(ScreenWidth) priorityHigh];
    }];
    
    self.logBtn.layer.masksToBounds = YES;
    self.logBtn.layer.cornerRadius = 35.0 / 2;
    self.logBtn.layer.borderWidth = 1;
    self.logBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.numBackView.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    [self.touxiangImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(70 * Width_Ratio));
    }];
    self.touxiangImgView.layer.masksToBounds = YES;
    self.touxiangImgView.layer.cornerRadius = (70 * Width_Ratio) / 2.0f;
    self.touxiangImgView.layer.borderWidth = 1;
    self.touxiangImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.touxiangImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapUser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoAction)];
    [self.touxiangImgView addGestureRecognizer:tapUser];
    
    for (UIButton *button in self.btnBackView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            CGSize imageSize = button.imageView.frame.size;
            CGSize titleSize = button.titleLabel.frame.size;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height - 5, 0);
            button.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height - 5,  0, 0, -titleSize.width);
        }
    }
    
    self.dianView.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _hiddenNav = NO;
    if (self.navigationController.navigationBar.hidden == NO)
    {
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    if ([MFSystemManager shareManager].isLogin) {
        self.logBackView.hidden = YES;
        self.touxiangImgView.hidden = NO;
        self.numBackView.hidden = NO;
        self.homeNewsBtn.hidden = NO;
        self.topImgView.image = [UIImage imageNamed:@"home_bj7"];
        UserModel *model = [MFSystemManager shareManager].userModel;
        [self.touxiangImgView setImageWithURL:[NSURL URLWithString:model.touxiang]];
        [self getTuiJianNumData];
        [self getMsgNum];
    }else{
        self.topImgView.image = [UIImage imageNamed:@"home_bj8"];
        self.logBackView.hidden = NO;
        self.touxiangImgView.hidden = YES;
        self.numBackView.hidden = YES;
        self.homeNewsBtn.hidden = YES;
        self.dianView.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (self.navigationController.navigationBar.hidden == YES && _hiddenNav == NO)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getMsgNum
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefault objectForKey:DEVICE_TOKEN];
    if (!deviceToken) {
        deviceToken = @"";
    }
    NSDictionary *postDic = @{
                              @"token":deviceToken
                              };
    [NET_WORKING request4DicWithType:RequestTypeGet InterfaceUrl:GET_MSG_NUM InterFaceType:@"get-msg-num" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
        NSString *numStr = (NSString*)dic;
        if ([numStr integerValue] > 0) {
            self.dianView.hidden = NO;
        }else{
            self.dianView.hidden = YES;
        }
    } failure:^(NSString *msg) {
        self.dianView.hidden = YES;
    }];
}

- (void) getTuiJianNumData
{
    UserModel *model = [MFSystemManager shareManager].userModel;
    NSDictionary *postDic = @{
//                              @"uid":model.uID,
                              @"password":model.password
                              };
    [NET_WORKING request4DicWithType:RequestTypeGet InterfaceUrl:GET_TUIJIAN_NUM InterFaceType:@"get-tuijian-num" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
        self.tuijianNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tuijianNum"]];
        self.chengjiaoNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"chengjiaoNum"]];
    } failure:^(NSString *msg) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma -mark 右滑返回控制

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSUserDefaults *defauts = [NSUserDefaults standardUserDefaults];
    if ([defauts boolForKey:@"swipeForberd"]) {
        return NO;
    }
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }else{
        return YES;
    }
}
- (IBAction)registerAction:(id)sender {
    RegisterViewController *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerVC];
    [nav setNavigationBarHidden:YES animated:NO];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (IBAction)loginAction:(id)sender {
    
//    LogInViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
    QuickLogViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickLogViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [nav setNavigationBarHidden:YES animated:NO];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
- (IBAction)homeNewAction:(id)sender {
    MessageViewController *msgvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    [self.navigationController pushViewController:msgvc animated:YES];
}

- (IBAction)navBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1001:
        {
            if (![MFSystemManager shareManager].isLogin) {
                [self loginAction:nil];
                return;
            }
            TuiJianViewController *tuijianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TuiJianViewController"];
            [self.navigationController pushViewController:tuijianVC animated:YES];
        }
            break;
        case 1002:
        {
            if (![MFSystemManager shareManager].isLogin) {
                [self loginAction:nil];
                return;
            }
            KeHuListViewController *kehuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"KeHuListViewController"];
            [self.navigationController pushViewController:kehuVC animated:YES];
        }
            break;
        case 1003:
        {
            if (![MFSystemManager shareManager].isLogin) {
                [self loginAction:nil];
                return;
            }
            YongJinViewController *yongjinVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YongJinViewController"];
            [self.navigationController pushViewController:yongjinVC animated:YES];
        }
            break;
        case 1004:
        {
            WapViewController *wapVC = [[WapViewController alloc] init];
            wapVC.title = @"活动细则";
            wapVC.urlStr = @"http://m.monph.com/quanminjingjiren/rules.php";
            [self.navigationController pushViewController:wapVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)userInfoAction
{
    if (![MFSystemManager shareManager].isLogin) {
        [self loginAction:nil];
        return;
    }
    UserInfoTableViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoTableViewController"];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}
@end
