//
//  RenZhengViewController.m
//  huxinbao
//
//  Created by zhuna on 2017/3/17.
//  Copyright © 2017年 hxb. All rights reserved.
//

#import "RenZhengViewController.h"
#import "TextFeildCell.h"
#import "UpLoadPicCell.h"

@interface RenZhengViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    UserModel *_userModel;
    NSString *_nameStr;
    NSString *_shenfenzhengID;
    
    NSString *_id_F_Url_Str;
    NSString *_id_B_Url_Str;
    
    UIButton *_currentBtn;
    
}
@end

@implementation RenZhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"实名认证";
 
    self.tableView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    self.renzhengMsgBackView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    
    self.renzhengBtn.layer.cornerRadius = 5;
    self.renzhengBtn.layer.masksToBounds = YES;
    [self.renzhengBtn addTarget:self action:@selector(renzhengAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.doneBtn.layer.cornerRadius = 5;
    self.doneBtn.layer.masksToBounds = YES;
    
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    _userModel = [MFSystemManager shareManager].userModel;
//    self.kefuLabel.text = [NSString stringWithFormat:@"客服电话：%@",KeFuNum];
    switch ([_userModel.shiming_status integerValue]) {
        case 2:
            //已实名认证
            self.renzhengMsgLabel.text = @"实名认证成功";
            self.kefuLabel.text = @"";
            self.renzhengMsgBackView.hidden = NO;
            break;
        case 1:
            //审核中
            self.renzhengMsgLabel.text = @"证件提交成功";
            self.kefuLabel.text = @"请耐心等待工作人员审核";
            self.renzhengMsgBackView.hidden = NO;
            break;
            
        default:
            self.renzhengMsgBackView.hidden = YES;
            break;
    }
    
    _id_F_Url_Str = @"";
    _id_B_Url_Str = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) renzhengAction
{
    for (int i = 0; i < 2; i++) {
        TextFeildCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        switch (i) {
            case 0:
                _nameStr = cell.textField.text;
                break;
            case 1:
                _shenfenzhengID = cell.textField.text;
                break;
                
            default:
                break;
        }
    }
    if (_nameStr.length < 2) {
        [ProgressHUD showError:@"请输入真实姓名"];
        return;
    }
    if (_shenfenzhengID.length < 15) {
        [ProgressHUD showError:@"请输入正确身份证号码"];
        return;
    }

    if (_id_B_Url_Str.length < 5 || _id_F_Url_Str.length < 5) {
        [ProgressHUD showError:@"请上传证件照"];
        return;
    }

    
    NSDictionary *postDic = @{
                              @"uid":[MFSystemManager shareManager].userModel.uID,
                              @"password":[MFSystemManager shareManager].userModel.password,
                              @"realname":_nameStr,
                              @"cardId":_shenfenzhengID,
                              @"zhengmian":_id_F_Url_Str,
                              @"fanmian":_id_B_Url_Str
                              };
    [ProgressHUD show:@"认证信息上传中"];
    [NET_WORKING request4DicWithType:RequestTypePost InterfaceUrl:UPDATE_USER_SHIMING InterFaceType:@"update-user-shiming" Parmeters:postDic yuming:YU_MING Success:^(NSDictionary *dic) {
        [ProgressHUD dismiss];
        self.renzhengMsgLabel.text = @"证件提交成功";
        self.kefuLabel.text = @"请耐心等待工作人员审核";
        self.renzhengMsgBackView.hidden = NO;
//        [AlertBoxTool AlertWithTitle:@"已提交审核" message:@"你的审核信息已提交，我们会尽快处理！" cancelButtonTitle:@"确定" otherButtonTitles:nil alertView:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self back];
//            });
//        }];
    } failure:^(NSString *msg) {
        [ProgressHUD showError:msg];
    }];
    /*
    [[LKNetWorkingUtil shareUtil] baseRequestType:RequestTypePost URL:YU_MIMG_CESHI Parameters:postDic WAction:@"106" Success:^(NSDictionary *dic) {
        [ProgressHUD dismiss];
        [AlertBoxTool AlertWithTitle:@"已提交审核" message:@"你的审核信息已提交，我们会尽快处理！" cancelButtonTitle:@"确定" otherButtonTitles:nil alertView:^(UIAlertView *alertView, NSInteger buttonIndex) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    } failure:^(NSString *msg) {
        [ProgressHUD dismiss];
        [AlertBoxTool AlertWithTitle:msg message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil alertView:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
    }];
     */
}

- (IBAction)upLoadPicAction:(UIButton*)sender
{
    _currentBtn = sender;
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark -TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
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
    if (indexPath.section == 0) {
        TextFeildCell *cell = (TextFeildCell*)[tableView dequeueReusableCellWithIdentifier:@"TextFeildCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *titleArr = @[@"真实姓名",@"身份证号"];
        cell.titleLabel.text = [titleArr objectAtIndex:indexPath.row];
        cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",[titleArr objectAtIndex:indexPath.row]];
        if (indexPath.row == 1) {
            cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
        }
        if (indexPath.row == 3) {
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        return cell;
    }else{
        UpLoadPicCell *cell = (UpLoadPicCell*)[tableView dequeueReusableCellWithIdentifier:@"UpLoadPicCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btn1 addTarget:self action:@selector(upLoadPicAction:) forControlEvents:UIControlEventTouchUpInside];
//        cell.btn1.backgroundColor = [UIColor redColor];
        [cell.btn2 addTarget:self action:@selector(upLoadPicAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma mark UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //进入照相界面
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        //        picker.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        
        
        //        UIImageView *overLayImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, ScreenWidth, ScreenWidth)];
        //        overLayImg.userInteractionEnabled = YES;
        //        overLayImg.image = [UIImage imageNamed:@"123"];
        //        picker.cameraOverlayView = overLayImg;
        
        
        [self presentViewController:picker animated:YES completion:nil];
        
        
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    NSLog(@"didFinishPickingImage");
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"didFinishPickingMediaWithInfo");
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//        [self.photoImgView setImage:portraitImg];
        [_currentBtn setImage:portraitImg forState:UIControlStateNormal];
        NSDictionary * dic = @{@"uid":[MFSystemManager shareManager].userModel.uID,
                               @"password":[MFSystemManager shareManager].userModel.password};
        NSString * url = [NSString stringWithFormat:@"%@%@code=%@",YU_MIMGV1,UPLOAD_PICTURE,[MFUtility getCodeWithType:@"upload-picture"]];
        [NET_WORKING BasePicturePostMethodByURL:url Img:portraitImg Imgkey:@"filedata" Parameters:dic Success:^(NSDictionary *dic) {
            [ProgressHUD showSuccess:@"图片已上传"];
            switch (_currentBtn.tag) {
                case 101:
                    _id_F_Url_Str = [dic objectForKey:@"picture"];
                    break;
                case 102:
                    _id_B_Url_Str = [dic objectForKey:@"picture"];
                    break;
                    
                default:
                    break;
            }
            
            
        } failure:^(NSString *msg) {
            [ProgressHUD showError:msg];
        }];
        
    }];
     
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneAction:(UIButton *)sender {
    [self back];
}
@end
