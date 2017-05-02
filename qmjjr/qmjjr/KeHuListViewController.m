//
//  KeHuListViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/20.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "KeHuListViewController.h"
#import "KeHuCell.h"
#import "MJExtension.h"
#import "KeHuInfoViewController.h"
#import "SearchKeHuViewController.h"
#import "BaseEmptyView.h"

@interface KeHuListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_tableArr;
    //房间list页码
    NSInteger _page;
    BOOL _canLoad;
    
    NSInteger _type;
    
    NSInteger _status;
    BaseEmptyView *_emptyView;
}

@property (strong, nonatomic) UIControl *backControl;

@end

@implementation KeHuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"screen0"] style:UIBarButtonItemStylePlain target:self action:@selector(screenAction)];
    UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 240, 32)];
    [titleBtn setBackgroundImage:[UIImage imageNamed:@"searchBtn"] forState:UIControlStateNormal];
    [titleBtn setBackgroundImage:[UIImage imageNamed:@"search-selected"] forState:UIControlStateHighlighted];
    [titleBtn addTarget: self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    [self.chufangBtn setSelected:YES];
    [self.tuoguanBtn setSelected:NO];
    
    self.tableView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    _tableArr = [NSMutableArray new];
    _type = 1;
    _status = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *interfaceUrl = @"";
    NSString *interfaceType = @"";
    if (_type == 1) {
        interfaceUrl = GET_TUIJIAN_CHUFANG_LIST;
        interfaceType = @"get-tuijian-chufang-list";
    }else{
        interfaceUrl = GET_TUIJIAN_TUOGUAN_LIST;
        interfaceType = @"get-tuijian-tuoguan-list";
    }
    
    [NET_WORKING request4DicWithType:RequestTypeGet InterfaceUrl:interfaceUrl InterFaceType:interfaceType Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
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
    if (indexPath.row < _tableArr.count) {
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
    }
    
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KeHuInfoViewController *kehuInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"KeHuInfoViewController"];
    KeHuModel *listModel = [_tableArr objectAtIndex:indexPath.row];
    kehuInfoVC.kehuModel = listModel;
    kehuInfoVC.kehuType = _type;
    [self.navigationController pushViewController:kehuInfoVC animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectTypeAction:(UIButton *)sender {
    _status = 0;
    if (sender == self.chufangBtn) {
        [self.chufangBtn setSelected:YES];
        [self.tuoguanBtn setSelected:NO];
        _type = 1;
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self.chufangBtn setSelected:NO];
        [self.tuoguanBtn setSelected:YES];
        _type = 2;
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)screenAction{
//    NSLog(@"screenAction");
    [KEY_WINDOW addSubview:self.backControl];
    [self.backControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(KEY_WINDOW);
    }];
}

- (void)touchDownAction
{
    [self.backControl removeFromSuperview];
}

- (IBAction)filterAction:(UIButton*)sender
{
    _status = sender.tag;
    [self touchDownAction];
    [self.tableView.mj_header beginRefreshing];
}

- (void)searchAction
{
    SearchKeHuViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchKeHuViewController"];
    [self.navigationController pushViewController:searchVC animated:YES];
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

#pragma mark - getters
- (UIControl*)backControl
{
    if (!_backControl) {
        _backControl = [[UIControl alloc] init];
        _backControl.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        [_backControl addTarget:self action:@selector(touchDownAction) forControlEvents:UIControlEventTouchDown];
        UIImageView *filterImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter-bj"]];
        filterImgView.userInteractionEnabled = YES;
        [_backControl addSubview:filterImgView];
        [filterImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_backControl).offset(-10);
            make.top.mas_equalTo(_backControl).offset(60);
        }];
        
        float top = 8.0;
        float height = (filterImgView.frame.size.height - top) / 4.0;
        NSArray *titleArr = @[@"受理中",@"已受理",@"已成交",@"已结佣"];
        for (NSInteger i = 0; i < titleArr.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            [button setTitleColor:FONT_COLOR_51 forState:UIControlStateNormal];
            button.tag = 1 + i;
            button.titleLabel.font = Font30;
            [button setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
            [filterImgView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(filterImgView).offset(top + (height * i));
                make.left.right.mas_equalTo(filterImgView);
                make.height.mas_equalTo(@(height));
            }];
            if (i < 3) {
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = DEFULT_LINE_COLOR;
                [filterImgView addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(button.bottom);
                    make.left.right.mas_equalTo(filterImgView);
                    make.height.mas_equalTo(@(0.5));
                }];
            }
        }
    }
    return _backControl;
}
@end
