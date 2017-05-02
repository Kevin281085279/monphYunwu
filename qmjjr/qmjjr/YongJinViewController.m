//
//  YongJinViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "YongJinViewController.h"
#import "YongJinListCell.h"
#import "ShenQingTiXianViewController.h"
#import "TiXianTableViewController.h"
#import "BaseEmptyView.h"

@interface YongJinViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_tableArr;
    //房间list页码
    NSInteger _page;
    BOOL _canLoad;
    
    NSInteger _status;
    
    YongJinModel *_yjModel;
    
    BaseEmptyView *_emptyView;
}
@end

@implementation YongJinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的佣金";
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [rightBtn setTitle:@"提现明细" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = Font28;
    [rightBtn setTitleColor:DEFULT_BLUE_COLOR forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(mingxiAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.chufangBtn setSelected:YES];
    [self.tuoguanBtn setSelected:NO];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    _tableArr = [NSMutableArray new];
    _status = 1;
    
    self.tixianBtn.layer.masksToBounds = YES;
    self.tixianBtn.layer.cornerRadius = 5;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshTableView
{
    [_emptyView disMiss];
    _page = 1;
    _canLoad = YES;
    //    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_canLoad) {
            [self getData];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [self getData];
}

- (void) getData
{
    UserModel *userModel = [MFSystemManager shareManager].userModel;
    NSDictionary *postDic = @{
                              @"uid":userModel.uID,
                              @"password":userModel.password,
                              @"status":@(_status),
                              @"page":@(_page),
                              @"row":@"10"
                              };
    [NET_WORKING request4ModelWithType:RequestTypeGet ClassName:@"YongJinModel" InterfaceUrl:GET_MY_YONGJIN InterFaceType:@"get-my-yongjin" Parmeters:postDic Yuming:YU_MING Success:^(id obj) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        YongJinModel *yongjinModel = (YongJinModel*)obj;
        _yjModel = yongjinModel;
        self.moneyLabel.text = [NSString stringWithFormat:@"%@",yongjinModel.yue];
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"总收入：%@",yongjinModel.shouru];
        if (_page == 1) {
            [_tableArr removeAllObjects];
        }
        [_tableArr addObjectsFromArray:yongjinModel.list];
        if (_page >= [yongjinModel.pageTotal integerValue]) {
            _canLoad = NO;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
        _page++;
        if (_tableArr.count == 0) {
            [self addEmptyView];
        }
    } failure:^(NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        _canLoad = NO;
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        if (_tableArr.count == 0) {
            [self addEmptyView];
        }
    }];
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

- (IBAction)tixianAction:(id)sender {
    ShenQingTiXianViewController *sqtxVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShenQingTiXianViewController"];
    if (_yjModel) {
        sqtxVC.tixianMoney = _yjModel.tixianMoney;
    }
    [self.navigationController pushViewController:sqtxVC animated:YES];
}

- (IBAction)selectTypeAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender == self.chufangBtn) {
        [self.chufangBtn setSelected:YES];
        [self.tuoguanBtn setSelected:NO];
        _status = 1;
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self.chufangBtn setSelected:NO];
        [self.tuoguanBtn setSelected:YES];
        _status = 2;
        [self.tableView.mj_header beginRefreshing];
    }
}


- (IBAction)mingxiAction:(id)sender
{
    TiXianTableViewController *tixianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TiXianTableViewController"];
    [self.navigationController pushViewController:tixianVC animated:YES];
}

- (void) addEmptyView
{
    if (!_emptyView) {
        _emptyView = [[BaseEmptyView alloc] initWithWarningStr:@"暂无佣金" WarningImg:nil];
    }
    if (_emptyView.superview) {
        [_emptyView removeFromSuperview];
    }
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
}
#pragma mark - TableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArr.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YongJinListCell *cell = (YongJinListCell*)[tableView dequeueReusableCellWithIdentifier:@"YongJinListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_tableArr.count > indexPath.row) {
        YongJinListModel *listModel = [_tableArr objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = listModel.msg;
        cell.neirongLabel.text = [NSString stringWithFormat:@"%@ %@",listModel.realname,listModel.address];
        cell.moneyLabel.text = listModel.money;
        
        if ([listModel.typeName isEqualToString:@"托管"]) {
            [cell.typeImgView setImage:[UIImage imageNamed:@"list-_tg"]];
        }else{
            [cell.typeImgView setImage:[UIImage imageNamed:@"list_cf"]];
        }
        
    }
    
    return cell;
}



@end
