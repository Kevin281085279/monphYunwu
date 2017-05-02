//
//  TiXianTableViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/20.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "TiXianTableViewController.h"
#import "TiXianCell.h"
#import "MJExtension.h"

@interface TiXianTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_tableArr;
    //房间list页码
    NSInteger _page;
    BOOL _canLoad;
}

@end

@implementation TiXianTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现明细";
    
    _tableArr = [NSMutableArray new];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshTableView
{
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
                              @"page":@(_page),
                              @"row":@"10"
                              };
    [NET_WORKING request4DicWithType:RequestTypeGet InterfaceUrl:GET_TIXIAN_LIST InterFaceType:@"get-tixian-list" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSArray *array = [dic objectForKey:@"list"];
        NSArray *modelArr = [TiXianModel mj_objectArrayWithKeyValuesArray:array];
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
        });
        _page++;
    } failure:^(NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        _canLoad = NO;
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
    return 115;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TiXianCell *cell = (TiXianCell*)[tableView dequeueReusableCellWithIdentifier:@"TiXianCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_tableArr.count > indexPath.row) {
        TiXianModel *listModel = [_tableArr objectAtIndex:indexPath.row];
        
        [cell.bankImgView setImageWithURL:[NSURL URLWithString:listModel.image]];
        cell.bankNameLabel.text = listModel.bankName;
        cell.cardIDLabel.text = listModel.bankId;
        cell.moneyLabel.text = listModel.money;
        cell.timeLabel.text = listModel.addTime;
        cell.dingdanhaoLabel.text = [NSString stringWithFormat:@"订单号：%@",listModel.orderId];
        switch ([listModel.status integerValue]) {
            case 0:
            {
                cell.statusLabel.textColor = UIColorFromHex(0xffa52f);
                cell.statusLabel.text = @"处理中";
            }
                break;
            case 1:
            {
                cell.statusLabel.textColor = UIColorFromHex(0xb2e2a8);
                cell.statusLabel.text = @"提现成功";
            }
                break;
            case 2:
            {
                cell.statusLabel.textColor = [UIColor redColor];
                cell.statusLabel.text = @"提现失败";
            }
                break;
                
            default:
                break;
        }
    }
    
    
    return cell;
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
