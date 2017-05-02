//
//  AddCardViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/19.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "AddCardViewController.h"
#import "TextFeildCell.h"

@interface AddCardViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_titleArr;
    
    NSArray * bankArry;
    NSArray * provinceArray;
    NSArray * cityArray;
    NSDictionary * selBankDic;
    NSDictionary * selCityDic;
    
    
    NSString * defultCity;
    NSString * _bankID;
    
    NSInteger _selectRow;
}
@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加银行卡";
    self.tableView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.cornerRadius = 5;
    
    _titleArr = @[@"开户城市",@"银行名称",@"开户行",@"开户人",@"银行卡号"];
    
    self.pickView.hidden = YES;
    self.doneToolBar.hidden = YES;
    _selectRow = 0;
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void) getData
{
    [NET_WORKING request4DicWithType:RequestTypeGet InterfaceUrl:GET_CITY InterFaceType:@"get-city" Parmeters:nil yuming:YU_MING Success:^(NSDictionary *dic) {
        defultCity = dic[@"defaultCity"];
        provinceArray = dic[@"areaList"];
        
    } failure:^(NSString *msg) {
        
    }];
    [NET_WORKING request4DicWithType:RequestTypeGet InterfaceUrl:GET_BANK_INFO InterFaceType:@"get-bank-info" Parmeters:nil yuming:YU_MING Success:^(NSDictionary *dic) {
        bankArry = (NSArray *)dic;
        
    } failure:^(NSString *msg) {
        
    }];
}
#pragma mark - TableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return _titleArr.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFeildCell *cell = (TextFeildCell*)[tableView dequeueReusableCellWithIdentifier:@"TextFeildCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = [_titleArr objectAtIndex:indexPath.row];
    cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",[_titleArr objectAtIndex:indexPath.row]];
    if (indexPath.row == 4) {
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.textField.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textField.placeholder = [NSString stringWithFormat:@"请选择%@",[_titleArr objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectRow = indexPath.row;
    if (_selectRow == 0) {
        [self cityBtnClick:nil];
    }else{
        [self bankBtnClick:nil];
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

- (IBAction)doneAction:(id)sender {

    NSMutableArray *strArr = [NSMutableArray new];
    for (int i = 0; i < _titleArr.count; i++)
    {
        TextFeildCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.textField.text.length < 1) {
            [ProgressHUD showError:cell.textField.placeholder];
            return;
        }
        [strArr addObject:cell.textField.text];
    }
    UserModel *userModel = [MFSystemManager shareManager].userModel;
    NSDictionary *postDic = @{
                              @"uid":userModel.uID,
                              @"password":userModel.password,
                              @"bankId":_bankID,
                              @"zhihang":[strArr objectAtIndex:2],
                              @"realname":[strArr objectAtIndex:3],
                              @"idNum":[strArr objectAtIndex:4],
                              @"city":[strArr objectAtIndex:0]
                              };
     [ProgressHUD show];
    [NET_WORKING request4DicWithType:RequestTypePost InterfaceUrl:ADD_USER_BANK InterFaceType:@"add-user-bank" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
//        [ProgressHUD showSuccess:@"添加银行卡成功"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self back];
//        });
        [ProgressHUD dismiss];
        [AlertBoxTool AlertWithTitle:@"添加银行卡成功" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil alertView:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self.view endEditing:YES];
            [self back];
        }];
        
    } failure:^(NSString *msg) {
        [ProgressHUD showError:msg];
    }];
    
}
- (IBAction)cancleBtnClick:(id)sender {
    [self dismissPickerView];
}
- (IBAction)confirmBtnClick:(id)sender {
    [self dismissPickerView];
    if (_selectRow == 0) {
        NSInteger selectedProvinceIndex = [self.pickView selectedRowInComponent:0];
        NSInteger selectedCityIndex = [self.pickView selectedRowInComponent:1];
        NSDictionary * provienceDic = provinceArray[selectedProvinceIndex];
        NSArray * tempArr = provienceDic[@"children"];
        NSDictionary * cityDic = tempArr[selectedCityIndex];
        selCityDic = cityDic;
        defultCity = cityDic[@"name"];
        TextFeildCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.textField.text = defultCity;
    }else{
        NSInteger row = [self.pickView selectedRowInComponent:0];
        NSDictionary * dic = [bankArry objectAtIndex:row];
        TextFeildCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.textField.text = dic[@"name"];
        _bankID = dic[@"id"];
        selBankDic = dic;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_selectRow == 0) {
        return 2;
    }
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_selectRow == 0) {
        if (component == 0) {//省份个数
            return [provinceArray count];
        } else {//市的个数
            return [cityArray count];
        }
    }
    return [bankArry count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_selectRow == 0) {
        if (component == 0) {//选择省份名
            NSDictionary * dic = [provinceArray objectAtIndex:row];
            return dic[@"name"];
        } else {//选择市名
            NSDictionary * dic = [cityArray objectAtIndex:row];
            return dic[@"name"];
        }
    }
    NSDictionary * dic = [bankArry objectAtIndex:row];
    return dic[@"name"];
}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_selectRow == 0) {
        if (component == 0) {
            NSDictionary * provinceDic = [provinceArray objectAtIndex:row];
            cityArray = provinceDic[@"children"];
            
            //重点！更新第二个轮子的数据
            [self.pickView reloadComponent:1];
            
            NSInteger selectedCityIndex = [self.pickView selectedRowInComponent:1];
            NSDictionary * cityDic = [cityArray objectAtIndex:selectedCityIndex];
            
            NSString *msg = [NSString stringWithFormat:@"province=%@,city=%@", provinceDic[@"name"],cityDic[@"name"]];
            NSLog(@"%@",msg);
        }
        else {
            NSInteger selectedProvinceIndex = [self.pickView selectedRowInComponent:0];
            NSDictionary * provinceDic = [provinceArray objectAtIndex:selectedProvinceIndex];
            
            NSDictionary * cityDic = [cityArray objectAtIndex:row];
            NSString *msg = [NSString stringWithFormat:@"province=%@,city=%@", provinceDic[@"name"],cityDic[@"name"]];
            NSLog(@"%@",msg);
        }
    }
}

- (void)showPickerView{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.pickView.hidden = NO;
                         self.doneToolBar.hidden = NO;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)dismissPickerView{
    //    _toolBarConstranint.constant = ScreenHeight-_nextBtn.viewBottom;
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.pickView.hidden = YES;
                         self.doneToolBar.hidden = YES;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}
- (IBAction)bankBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.pickView reloadAllComponents];
    sender.selected = !sender.selected;
    if (bankArry) {
        [self showPickerView];
    }
}
- (IBAction)cityBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.pickView reloadAllComponents];
    sender.selected = !sender.selected;
    if (provinceArray) {
        [self showPickerView];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self dismissPickerView];
}
@end
