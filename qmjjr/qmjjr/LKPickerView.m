//
//  LKPickerView.m
//  monphSinged
//
//  Created by zhuna on 16/3/30.
//  Copyright © 2016年 monph. All rights reserved.
//

#import "LKPickerView.h"
#define kWinH [[UIScreen mainScreen] bounds].size.height
#define kWinW [[UIScreen mainScreen] bounds].size.width

// pickerView高度
#define kPVH 230
@interface LKPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) UIButton *bgButton;
@property (strong, nonatomic) UIView *pickerBackView;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIView *btnBackView;
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) PickViewSelect selectBlock;

@end

@implementation LKPickerView

- (instancetype)init
{
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        self.pickViewArr = [[NSArray alloc] init];
        _selectIndexsArr = [NSMutableArray new];
        //半透明背景按钮
        _bgButton = [[UIButton alloc] init];
        [self addSubview:_bgButton];
        [_bgButton addTarget:self action:@selector(dismissPickView) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.backgroundColor = [UIColor blackColor];
        _bgButton.alpha = 0.0;
        _bgButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);

        [self addSubview:self.pickerBackView];
        
        [self pushPickView];
    }
    return self;
}

- (void) setPickViewArr:(NSArray *)pickViewArr
{
    _pickViewArr = pickViewArr;
    [self.pickerView reloadAllComponents];
}
//出现
- (void)pushPickView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.pickerBackView.frame = CGRectMake(0, kWinH - kPVH, kWinW, kPVH);
        weakSelf.bgButton.alpha = 0.2;
    }];
}
//消失
- (void)dismissPickView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.pickerBackView.frame = CGRectMake(0, kWinH, kWinW, kPVH);
        weakSelf.bgButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.doneBtn removeFromSuperview];
        [weakSelf.cancelBtn removeFromSuperview];
        [weakSelf.pickerView removeFromSuperview];
        [weakSelf.btnBackView removeFromSuperview];
        [weakSelf.pickerBackView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}
//确定选择
- (IBAction)doneAction:(id)sender
{
    [_selectIndexsArr removeAllObjects];
    for (NSInteger i = 0; i < self.components; i++) {
        NSInteger selectIndex = [self.pickerView selectedRowInComponent:i];
        [_selectIndexsArr addObject:[NSNumber numberWithInteger:selectIndex]];
    }
    if (_selectBlock) {
        _selectBlock(_selectIndexsArr);
    }
    [self dismissPickView];
}

- (void)didFinishSelectedDate:(PickViewSelect)selectIndexs
{
    _selectBlock = selectIndexs;
}

#pragma mark -pickViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.components;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *array = [self.pickViewArr objectAtIndex:component];
    return array.count;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *array = [self.pickViewArr objectAtIndex:component];
    
    return [array objectAtIndex:row];
}

#pragma mark -Getters
- (UIView*) pickerBackView
{
    if (!_pickerBackView) {
        _pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kWinH - kPVH, kWinW, kPVH)];
        _pickerBackView.backgroundColor = [UIColor whiteColor];
        [_pickerBackView addSubview:self.pickerView];
        [_pickerBackView addSubview:self.btnBackView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_pickerBackView);
            make.height.equalTo(@180);
        }];
        [self.btnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_pickerBackView);
            make.bottom.equalTo(self.pickerView.top);
        }];
    }
    return _pickerBackView;
}

- (UIPickerView*) pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIView*) btnBackView
{
    if (!_btnBackView) {
        _btnBackView = [[UIView alloc] init];
        _btnBackView.backgroundColor = DEFULT_BACKGROUND_COLOR;
        [_btnBackView addSubview:self.cancelBtn];
        [_btnBackView addSubview:self.doneBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(_btnBackView);
            make.width.equalTo(@80);
        }];
        [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_btnBackView);
            make.width.equalTo(@80);
        }];
    }
    return _btnBackView;
}

- (UIButton*)doneBtn
{
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc] init];
        [_doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:DEFULT_BLUE_COLOR forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _doneBtn;
}

- (UIButton*)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:DEFULT_BLUE_COLOR forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismissPickView) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _cancelBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
