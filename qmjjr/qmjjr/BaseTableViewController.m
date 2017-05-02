//
//  BaseTableViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/18.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (Ios7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = DEFULT_BACKGROUND_COLOR;
//    self.tableView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    _tableArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self setUpTableView];
}

- (void)setUpTableView{
    self.tableView = [UITableView new];
    self.tableView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"baseCell"];
    
    //添加刷新
//    [self.tableView addHeaderWithTarget:self action:@selector(refreshTableView)];
//    self.tableView.headerPullToRefreshText = @"下拉刷新";
//    self.tableView.headerReleaseToRefreshText = @"松开刷新";
//    self.tableView.headerRefreshingText = @"正在加载";
//    [self.tableView headerBeginRefreshing];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

//刷新
- (void)refreshTableView
{
    _page = 1;
    self.canLoad = YES;
    //    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.canLoad) {
            [self getData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [self getData];
}
- (void)getData{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"baseCell" forIndexPath:indexPath];
    return cell;
}

- (void)addEmptyViewWithMessage:(NSString *)message{
    _emptyView = [[JHEmptyView alloc] initWithWarningStr:message];
    [self.view addSubview:_emptyView];
    self.tableView.hidden = YES;
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

@end
