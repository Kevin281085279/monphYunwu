//
//  SearchXiaoQuViewController.m
//  monphSinged
//
//  Created by zhuna on 16/3/30.
//  Copyright © 2016年 monph. All rights reserved.
//

#import "SearchXQViewController.h"

@interface SearchXQViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate>
{
    NSMutableArray *_listArr;
    
    NSString *_searchTxT;
    
    NSMutableArray *_searchHisArr;
}

@end

@implementation SearchXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"搜索小区";
    _searchTxT = [NSString new];
    self.view.backgroundColor = DEFULT_BACKGROUND_COLOR;
    self.tableView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Return0"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
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
    [self.tableHeaderView addSubview:searchBackView];
    [searchBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableHeaderView);
        make.size.equalTo(CGSizeMake(ScreenWidth - 25, 30));
    }];
    
    _listArr = [[NSMutableArray alloc] initWithCapacity:0];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
//    [self.tableView.mj_header beginRefreshing];

//    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"xiaoquSearchHistory"];
    _searchHisArr = [NSMutableArray arrayWithArray:arr];
    
    NSInteger i = 0;
    for (NSString *btnTitle in _searchHisArr) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"whiteBG"] forState:UIControlStateNormal];
        [button setTitle:btnTitle forState:UIControlStateNormal];
        [button setTitleColor:DEFULT_BLUE_COLOR forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchHisBackView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(i / 2 * 44 + 30);
            make.left.equalTo(@((i % 2) * ScreenWidth / 2));
            make.size.equalTo(CGSizeMake(ScreenWidth / 2, 44));
        }];
        
        if (i % 2 == 0) {
            UIView *horLine = [[UIView alloc] init];
            horLine.backgroundColor = RGBCOLOR( 222, 222, 222);
            [self.searchHisBackView addSubview:horLine];
            [horLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.searchHisBackView);
                make.height.equalTo(@0.5);
                make.top.equalTo(i / 2 * 44 + 30);
            }];
        }
        i++;
    }
    for (UIView *line in self.searchHisBackView.subviews) {
        if ([line isMemberOfClass:[UIView class]]) {
            [self.searchHisBackView bringSubviewToFront:line];
        }
    }
    UIView *verLine = [[UIView alloc] init];
    verLine.backgroundColor = RGBCOLOR( 222, 222, 222);
    [self.searchHisBackView addSubview:verLine];
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchHisBackView).offset(30);
        make.centerX.equalTo(self.searchHisBackView);
        make.width.equalTo(@0.5);
        make.height.equalTo(@((i / 2 + 1) * 44));
    }];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSSet *set = [NSSet setWithArray:_searchHisArr];
    NSArray *arr = [set allObjects];
    NSMutableArray *mArr = [NSMutableArray new];
    if (arr.count > 8) {
        for (int i = 0; i < 8; i++) {
            [mArr addObject:[arr objectAtIndex:i]];
        }
    }else{
        [mArr addObjectsFromArray:arr];
    }
    [[NSUserDefaults standardUserDefaults] setObject:mArr forKey:@"xiaoquSearchHistory"];
}

//刷新
- (void) refreshTableView
{
    _searchTxT = self.searchBar.text;
    [self.searchBar endEditing:YES];
    //    _tableArr = [[NSMutableArray alloc] init];
    //    [self.tableView reloadData];
    [self getDateSource];
}

- (IBAction)searchAction:(UIButton*)sender
{
    self.searchBar.text = sender.titleLabel.text;
    _searchTxT = self.searchBar.text;
    [self.tableView.mj_header beginRefreshing];
}

- (void)getDateSource{
    [self.view bringSubviewToFront:self.tableView];
    NSLog(@"getDateSource");
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)_searchTxT,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    NSDictionary *postDic = @{
                              @"txt":outputStr
                              };
    [NET_WORKING request4DicWithType:RequestTypeGet InterfaceUrl:SEARCH_XIAOQU InterFaceType:@"search-xiaoqu" Parmeters:postDic yuming:YU_MIMG_JJR Success:^(NSDictionary *dic) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        NSArray *array = [dic objectForKey:@"list"];
        [_listArr removeAllObjects];
        [_listArr addObjectsFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(NSString *msg) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        [ProgressHUD showError:msg];
        [_listArr removeAllObjects];
        [self.tableView reloadData];
    }];

//    [JHRequestManager requestGetXiaoQuListWithTXT:outputStr Success:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
//        if ([self.tableView isHeaderRefreshing]) {
//            [self.tableView headerEndRefreshing];
//        }
//        NSArray *array = [dic objectForKey:@"list"];
//        [_listArr removeAllObjects];
//        [_listArr addObjectsFromArray:array];
//        [self.tableView reloadData];
//    } failure:^(NSString *msg) {
//        if ([self.tableView isHeaderRefreshing]) {
//            [self.tableView headerEndRefreshing];
//        }
//        [ProgressHUD showError:msg];
//        [_listArr removeAllObjects];
//        [self.tableView reloadData];
//    }];
}

- (IBAction)leftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark tableViewDatasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *xqDic = [_listArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [xqDic objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *xqDic = [_listArr objectAtIndex:indexPath.row];
    if (self.selectXiaoQu) {
        [_searchHisArr addObject:[xqDic objectForKey:@"name"]];
        self.selectXiaoQu(xqDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
    
}

#pragma -mark searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //[_tableArr removeAllObjects];
    NSLog(@"searchBarText = %@",searchBar.text);
    [_searchBar endEditing:YES];
    //    _searchTxT = searchBar.text;
    //    [self.tableView headerBeginRefreshing];
    _searchTxT = self.searchBar.text;
//    if (self.searchBar.text.length > 0) {
//        [_searchHisArr addObject:self.searchBar.text];
//    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    _searchTxT = self.searchBar.text;
    //    _tableArr = [[NSMutableArray alloc] init];
    //    [self.tableView reloadData];
//    [self getDateSource];
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    [self.tableView headerBeginRefreshing];
//}
#pragma -mark Getters
-(UISearchBar*)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"输入小区名称搜索";
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.tintColor = [UIColor blueColor];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.delegate = self;
    }
    return _searchBar;
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
