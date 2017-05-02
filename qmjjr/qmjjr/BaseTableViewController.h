//
//  BaseTableViewController.h
//  qmjjr
//
//  Created by zhuna on 2017/4/18.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "BaseViewController.h"
#import "JHEmptyView.h"

@interface BaseTableViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray *tableArr;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger pageCount;
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic)JHEmptyView * emptyView;
@property (assign, nonatomic) BOOL canLoad;

- (void)getData;
- (void)addEmptyViewWithMessage:(NSString *)message;
@end
