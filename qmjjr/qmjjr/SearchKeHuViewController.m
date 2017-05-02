//
//  SearchKeHuViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/20.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "SearchKeHuViewController.h"
#import "KeHuCell.h"
#import "MJExtension.h"
#import "KeHuInfoViewController.h"
#import "BaseEmptyView.h"

@interface SearchKeHuViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate>
{
    NSMutableArray *_tableArr;
    
    NSString *_searchTxT;
    
    BaseEmptyView *_emptyView;
}

@end

@implementation SearchKeHuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索";
    self.tableView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    
    UIView *searchBackView = [[UIView alloc] init];
    [searchBackView setBackgroundColor:[UIColor whiteColor]];
    searchBackView.layer.borderWidth = 0.5;
    searchBackView.layer.borderColor = RGBCOLOR(204, 204, 204).CGColor;
    searchBackView.layer.cornerRadius = 14;
    searchBackView.layer.masksToBounds = YES;
    searchBackView.clipsToBounds = YES;
    [searchBackView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(searchBackView);
    }];
    [self.view addSubview:searchBackView];
    [searchBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(@35);
        make.top.mas_equalTo(self.view).offset(15);
    }];
    
    _tableArr = [NSMutableArray new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
//    [self.tableView.mj_header beginRefreshing];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)refreshTableView
{
//    _page = 1;
//    _canLoad = YES;
    //    [self.tableView.mj_footer endRefreshingWithNoMoreData];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        if (_canLoad) {
//            [self getData];
//        }else{
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//    }];
    [self getData];
}

- (void) getData
{
    [_emptyView disMiss];
    UserModel *userModel = [MFSystemManager shareManager].userModel;
    NSDictionary *postDic = @{
                              @"uid":userModel.uID,
                              @"password":userModel.password,
                              @"keyword":_searchTxT
                              };
    [NET_WORKING request4DicWithType:RequestTypeGet InterfaceUrl:GET_TUIJIAN_SEARCH_LIST InterFaceType:@"get-tuijian-search-list" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];
        NSArray *array = (NSArray*)dic;
        NSArray *modelArr = [KeHuModel mj_objectArrayWithKeyValuesArray:array];
        [_tableArr removeAllObjects];
        [_tableArr addObjectsFromArray:modelArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        if (_tableArr.count == 0) {
            [self addEmptyView];
        }
    } failure:^(NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        if (_tableArr.count == 0) {
            [self addEmptyView];
        }
    }];
    
}

- (void) addEmptyView
{
    if (!_emptyView) {
        _emptyView = [[BaseEmptyView alloc] initWithWarningStr:@"暂无客户" WarningImg:nil];
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
    return 90;
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
    KeHuCell *cell = (KeHuCell*)[tableView dequeueReusableCellWithIdentifier:@"KeHuCell"];
    KeHuModel *listModel = [_tableArr objectAtIndex:indexPath.row];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:listModel.touxiang]];
    cell.nameLabel.text = listModel.realname;
    cell.mobileLabel.text = listModel.mobile;
    cell.statusLabel.text = listModel.statusname;
    if (listModel.address) {
        cell.addressLabel.text = listModel.address;
    }else{
        cell.addressLabel.text = @"";
    }
    switch ([listModel.status integerValue]) {
        case 1:
            cell.statusLabel.textColor = UIColorFromHex(0xffa52f);
            break;
        case 2:
            cell.statusLabel.textColor = UIColorFromHex(0xb2e2a8);
            break;
        case 3:
            cell.statusLabel.textColor = DEFULT_BLUE_COLOR;
            break;
        case 4:
            cell.statusLabel.textColor = RGBCOLOR(130, 130, 130);
            break;
            
        default:
            break;
    }
    cell.typeImgView.hidden = NO;
    switch ([listModel.type integerValue]) {
        case 1:
            cell.typeImgView.image = [UIImage imageNamed:@"list_cf"];
            break;
        case 2:
            cell.typeImgView.image = [UIImage imageNamed:@"list-_tg"];
            break;
            
        default:
            break;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KeHuInfoViewController *kehuInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"KeHuInfoViewController"];
    KeHuModel *listModel = [_tableArr objectAtIndex:indexPath.row];
    kehuInfoVC.kehuModel = listModel;
    kehuInfoVC.kehuType = [listModel.type integerValue];
    [self.navigationController pushViewController:kehuInfoVC animated:YES];
}

#pragma -mark searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //[_tableArr removeAllObjects];
    NSLog(@"searchBarText = %@",searchBar.text);
   
    _searchTxT = self.searchBar.text;
    if (_searchTxT.length > 0) {
        [_searchBar endEditing:YES];
        [self.tableView.mj_header beginRefreshing];
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    _searchTxT = self.searchBar.text;
    //    _tableArr = [[NSMutableArray alloc] init];
    //    [self.tableView reloadData];
    //    [self getDateSource];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma -mark Getters
-(UISearchBar*)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"姓名/手机号";
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.tintColor = [UIColor blueColor];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.delegate = self;
    }
    return _searchBar;
}
@end
