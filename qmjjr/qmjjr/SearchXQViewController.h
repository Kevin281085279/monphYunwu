//
//  SearchXiaoQuViewController.h
//  monphSinged
//
//  Created by zhuna on 16/3/30.
//  Copyright © 2016年 monph. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelctXiaoQu)(NSDictionary * xqDic);
@interface SearchXQViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIView *searchHisBackView;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (copy, nonatomic) SelctXiaoQu selectXiaoQu;
@end
