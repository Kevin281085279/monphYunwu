//
//  TiXianCell.h
//  qmjjr
//
//  Created by zhuna on 2017/4/20.
//  Copyright © 2017年 monph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiXianCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankImgView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *dingdanhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
