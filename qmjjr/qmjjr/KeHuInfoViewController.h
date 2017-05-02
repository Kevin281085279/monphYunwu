//
//  KeHuInfoViewController.h
//  qmjjr
//
//  Created by zhuna on 2017/4/20.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "BaseViewController.h"

@interface KeHuInfoViewController : BaseViewController
@property (strong, nonatomic) KeHuModel *kehuModel;
@property (assign, nonatomic) NSInteger kehuType;

@property (weak, nonatomic) IBOutlet UIView *jinduBackView;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
- (IBAction)phoneAction:(id)sender;
- (IBAction)msgAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *beizhuLabel;

@end
