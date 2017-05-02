//
//  MainViewController.h
//  qmjjr
//
//  Created by zhuna on 2017/4/17.
//  Copyright © 2017年 monph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *btnBackView;

@property (weak, nonatomic) IBOutlet UIButton *logBtn;
@property (weak, nonatomic) IBOutlet UIView *logBackView;
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;

- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *numBackView;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImgView;
@property (weak, nonatomic) IBOutlet UILabel *tuijianNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *chengjiaoNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *homeNewsBtn;
- (IBAction)homeNewAction:(id)sender;

- (IBAction)navBtnAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *dianView;
@end
