//
//  KeHuInfoViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/20.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "KeHuInfoViewController.h"

@interface KeHuInfoViewController ()

@end

@implementation KeHuInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    self.userImgView.layer.masksToBounds = YES;
    self.userImgView.layer.cornerRadius = 25;
    
    if (self.kehuType == 1) {
        self.typeImgView.image = [UIImage imageNamed:@"list_cf"];
        self.beizhuLabel.text = self.kehuModel.beizhu;
    }else{
        self.typeImgView.image = [UIImage imageNamed:@"list-_tg"];
        NSString *beizhuStr = [NSString stringWithFormat:@"%@\n%@\n%@    %@",self.kehuModel.address,self.kehuModel.huxing_name,self.kehuModel.mianji,self.kehuModel.leixing];
        self.beizhuLabel.text = beizhuStr;
    }
    
    [self.userImgView setImageWithURL:[NSURL URLWithString:self.kehuModel.touxiang]];
    self.nameLabel.text = self.kehuModel.realname;
    self.mobileLabel.text = self.kehuModel.mobile;
    
    for (UIView *view in self.jinduBackView.subviews) {
        if (view.tag >= 100 && view.tag < 200) {
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 5;
        }
        if (view.tag >= 100) {
            NSInteger status = [self.kehuModel.status integerValue] - 1;
            if ([view isMemberOfClass:[UIView class]]) {
                if (view.tag % 100 <= status) {
                    view.backgroundColor = DEFULT_BLUE_COLOR;
                }else{
                    view.backgroundColor = FONT_COLOR_200;
                }
            }
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel*)view;
                if (label.tag % 100 <= status) {
                    label.textColor = DEFULT_BLUE_COLOR;
                }else{
                    label.textColor = FONT_COLOR_200;
                }
            }
        }
    }
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

- (IBAction)phoneAction:(id)sender {
    NSString *urlStr = [NSString stringWithFormat:@"telprompt://%@",self.kehuModel.mobile];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)msgAction:(id)sender {
    NSString *urlStr = [NSString stringWithFormat:@"sms://%@",self.kehuModel.mobile];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}
@end
