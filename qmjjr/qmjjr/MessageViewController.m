//
//  MessageViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/21.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "BaseEmptyView.h"
#import "MJExtension.h"
#import "KeHuInfoViewController.h"
#import "TiXianTableViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_tableArr;
    //房间list页码
    NSInteger _page;
    BOOL _canLoad;
    
    BaseEmptyView *_emptyView;
}
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    
    self.tableView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    _tableArr = [NSMutableArray new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefault objectForKey:DEVICE_TOKEN];
    if (!deviceToken) {
        deviceToken = @"";
    }
    deviceToken = @"7ab1ffd3a876b43ebc848932da4e2c4005579c49a274c6523da15df1bcfec6c2"; //测试
    
    NSDictionary *postDic = @{
                              @"token":deviceToken,
                              @"page":@(_page),
                              @"row":@"10"
                              };
    
    [NET_WORKING request4DicWithType:RequestTypeGet InterfaceUrl:GET_DEVICE_MSGS InterFaceType:@"get-device-msgs" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSArray *array = [dic objectForKey:@"list"];
        NSArray *modelArr = [KeHuModel mj_objectArrayWithKeyValuesArray:array];
        if (_page == 1) {
            [_tableArr removeAllObjects];
        }
        [_tableArr addObjectsFromArray:modelArr];
        if (_page >= [[dic objectForKey:@"pageTotal"] integerValue]) {
            _canLoad = NO;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
            if (_tableArr.count == 0) {
                [self addEmptyView];
            }
        });
        _page++;
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

- (void) addEmptyView
{
    if (!_emptyView) {
        _emptyView = [[BaseEmptyView alloc] initWithWarningStr:@"暂无消息" WarningImg:@"msgimg"];
    }
    if (_emptyView.superview) {
        [_emptyView removeFromSuperview];
    }
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = (MessageCell*)[tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    KeHuModel *listModel = [_tableArr objectAtIndex:indexPath.row];
    cell.titleLabel.text = listModel.title;
    cell.contentLabel.text = listModel.content;
    cell.timeLabel.text = [NSString stringWithFormat:@"%@\n%@",listModel.addtime,listModel.addtime2];
    
    if ([listModel.is_read integerValue] == 0) {
        cell.dianView.hidden = NO;
    }else{
        cell.dianView.hidden = YES;
    }
    
    if ([listModel.type integerValue] == 3) {
        cell.typeImgView.image = [UIImage imageNamed:@"news_tx"];
    }else if([listModel.type integerValue] > 3){
        cell.typeImgView.image = [UIImage imageNamed:@"news_khgj"];
    }else{
        cell.typeImgView.image = [UIImage imageNamed:@"news_xtxx"];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KeHuModel *listModel = [_tableArr objectAtIndex:indexPath.row];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefault objectForKey:DEVICE_TOKEN];
    if (!deviceToken) {
        deviceToken = @"";
    }
    NSDictionary *postDic = @{
                              @"id":listModel.kehuID,
                              @"token":deviceToken
                              };
    [NET_WORKING request4DicWithType:RequestTypePost InterfaceUrl:SET_DEVICE_MSG InterFaceType:@"set-device-msg" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
        
    } failure:^(NSString *msg) {
        
    }];
    
    if ([listModel.type integerValue] == 3) {
        TiXianTableViewController *tixianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TiXianTableViewController"];
        [self.navigationController pushViewController:tixianVC animated:YES];
    }else if([listModel.type integerValue] > 3){
        KeHuInfoViewController *kehuInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"KeHuInfoViewController"];
        kehuInfoVC.kehuModel = listModel;
        kehuInfoVC.kehuType = [listModel.type integerValue] - 3;
        [self.navigationController pushViewController:kehuInfoVC animated:YES];
    }
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
