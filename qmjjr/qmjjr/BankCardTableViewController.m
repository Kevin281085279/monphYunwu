//
//  BankCardTableViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "BankCardTableViewController.h"
#import "MJExtension.h"
#import "BankCardCell.h"
#import "AddCardViewController.h"

@interface BankCardTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_tableArr;
}
@end

@implementation BankCardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"银行卡";
    _tableArr = [NSArray new];
    
    self.addCardBtn.layer.masksToBounds = YES;
    self.addCardBtn.layer.cornerRadius = 5;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
}

- (void) getData
{
    UserModel *userModel = [MFSystemManager shareManager].userModel;
    NSDictionary *postDic = @{
                              @"uid":userModel.uID,
                              @"password":userModel.password,
                              @"page":@"1",
                              @"row":@"100"
                              };
    [NET_WORKING request4DicWithType:RequestTypeGet InterfaceUrl:GET_USER_BANK_LIST InterFaceType:@"get-user-bank-list" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
        NSArray *_listDic = [dic objectForKey:@"list"];
        _tableArr = [BankCardModel mj_objectArrayWithKeyValuesArray:_listDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSString *msg) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableViewDatasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArr.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardCell *cell = (BankCardCell*)[tableView dequeueReusableCellWithIdentifier:@"BankCardCell"];
    BankCardModel *model = [_tableArr objectAtIndex:indexPath.row];
    [cell.bankImgView setImageWithURL:[NSURL URLWithString:model.bankImage]];
    cell.bankNameLabel.text = model.bankName;
    cell.bankIDLabel.text = model.cardNum;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankCardModel *model = [_tableArr objectAtIndex:indexPath.row];

    if (self.selectBankCard) {
        self.selectBankCard(model);
    }
    [self back];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) returnModelBlock:(SelectBankCard)block
{
    self.selectBankCard = block;
}

- (IBAction)addCardAction:(id)sender {
    AddCardViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCardViewController"];
    [self.navigationController pushViewController:addVC animated:YES];
}
@end
