//
//  UserInfoTableViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/17.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "RenZhengViewController.h"
#import "AboutVSViewController.h"
#import "WapViewController.h"

@interface UserInfoTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSArray *_titleArr;
    NSArray *_detailArr;
    
    NSString *_cacheSumStr;
    
    UserModel *_userModel;
    
    UIImageView *_userImgView;
}
@end

@implementation UserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"个人中心";
//    self.view.backgroundColor = DEFULT_BACKGROUND_COLOR;
//    self.tableView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    
    _userModel = [MFSystemManager shareManager].userModel;
    _titleArr = @[@[@"头像",@"手机号",@"实名认证",@"我要推广"],@[@"清除缓存",@"关于我们"],@[@""]];
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _cacheSumStr = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:cachPath]];
    _detailArr = @[@[@"",_userModel.mobile,@"",@""],@[_cacheSumStr,@""],@[@""]];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.bounces = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserInfoData];
}

- (void) getUserInfoData
{
    NSDictionary *postDic = @{
                              //                              @"uid":model.uID,
                              @"password":_userModel.password
                              };
    [NET_WORKING request4ModelWithType:RequestTypeGet ClassName:@"UserModel" InterfaceUrl:GET_USER_INFO InterFaceType:@"get-userinfo" Parmeters:postDic Yuming:YU_MIMG_LOG Success:^(id obj) {
        _userModel = (UserModel*)obj;
        [MFSystemManager shareManager].userModel = _userModel;
        [MFSystemManager shareManager].isLogin = YES;
        BOOL res = [UserModel saveSingleModel:_userModel forKey:@"userInfo"];
        if(res){
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存失败");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _detailArr = @[@[@"",_userModel.mobile,@"",@""],@[_cacheSumStr,@""],@[@""]];
            [self.tableView reloadData];
        });
    } failure:^(NSString *msg) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [_titleArr objectAtIndex:section];
    return array.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]]) {
        return 60;
    }
    if (indexPath.section == 2) {
        return 50;
    }
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"exitCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"userInfoCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"userInfoCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (_userImgView.superview) {
                    [_userImgView removeFromSuperview];
                }
                _userImgView = [[UIImageView alloc] init];
                _userImgView.layer.cornerRadius = 20;
                _userImgView.layer.masksToBounds = YES;
                [cell.contentView addSubview:_userImgView];
                [_userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(cell.contentView);
                    make.right.mas_equalTo(cell.right).offset(-20);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                }];
                [_userImgView setImageWithURL:[NSURL URLWithString:_userModel.touxiang]];
            }else if (indexPath.row == 1){
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row == 2){
                UIView *view = [cell.contentView viewWithTag:100];
                if (view) {
                    [view removeFromSuperview];
                }
                UILabel *renzhengLabel = [[UILabel alloc] init];
                renzhengLabel.tag = 100;
                renzhengLabel.layer.masksToBounds = YES;
                renzhengLabel.layer.cornerRadius = 10;
                renzhengLabel.font = [UIFont systemFontOfSize:12];
                renzhengLabel.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:renzhengLabel];
                [renzhengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(cell.contentView);
                    make.right.mas_equalTo(cell.right).offset(-35);
                    make.size.mas_equalTo(CGSizeMake(50, 20));
                }];
                switch ([_userModel.shiming_status integerValue]) {
                    case 0:
                    case 3:
                    {
                        renzhengLabel.text = @"未实名";
                        renzhengLabel.textColor = FONT_COLOR_130;
                        renzhengLabel.backgroundColor = UIColorFromHex(0xf1f1f1);
                    }
                        break;
                    case 1:
                    {
                        renzhengLabel.text = @"审核中";
                        renzhengLabel.textColor = FONT_COLOR_130;
                        renzhengLabel.backgroundColor = UIColorFromHex(0xf1f1f1);
                    }
                        break;
                    case 2:
                    {
                        renzhengLabel.text = @"已实名";
                        renzhengLabel.textColor = [UIColor whiteColor];
                        renzhengLabel.backgroundColor = DEFULT_BLUE_COLOR;
                    }
                        
                    default:
                        break;
                }
            }else{
                
            }
        }else{
            
        }
        
        NSArray *titleArr = [_titleArr objectAtIndex:indexPath.section];
        NSArray *detalArr = [_detailArr objectAtIndex:indexPath.section];
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [detalArr objectAtIndex:indexPath.row];
    }
    
    
    // Configure the cell...
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                
                UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"取消"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"拍照", @"从相册中选取", nil];
                [choiceSheet showInView:self.view];
            }
                break;
            case 1:
            {
                [AlertBoxTool AlertWithTitle:@"提示"
                                     message:@"解除或更换绑定手机，请联系客服。\n谢谢"
                                       style:UIAlertViewStyleDefault
                           cancelButtonTitle:nil
                           otherButtonTitles:@"确定"
                                   alertView:nil];
            }
                break;
            case 2:
            {
                RenZhengViewController *renZhengVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RenZhengViewController"];
                [self.navigationController pushViewController:renZhengVC animated:YES];
            }
                break;
            case 3:
            {
//                NSLog(@"我要推广");
                NSString *urlStr = [NSString stringWithFormat:@"http://m.monph.com/weixin/qmjingjiren/spread.php?app=1&qm=1&uid=%@&password=%@",_userModel.uID,_userModel.password];
                WapViewController *wapVC = [[WapViewController alloc] init];
                wapVC.title = @"我要推广";
                wapVC.urlStr = urlStr;
                [self.navigationController pushViewController:wapVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            [AlertBoxTool AlertWithTitle:@"清空确认" message:@"是否清空缓存" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" alertView:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self myClearCacheAction];
                }
            }];
        }else if(indexPath.row == 1){
//            NSLog(@"关于我们");
            AboutVSViewController *aboutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutVSViewController"];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }else
    {
        [[MFSystemManager shareManager] logOut];
        [self back];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -缓存处理
//遍历文件夹获得文件夹大小，返回多少M
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
-(void)myClearCacheAction{
    [ProgressHUD show:@"正在清除..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showSuccess:@"清除成功"];
            //获取尺寸重新加载
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            _cacheSumStr = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:cachPath]];
            _detailArr = @[@[@"",_userModel.mobile,@"",@""],@[_cacheSumStr,@""],@[@""]];
            [self.tableView reloadData];
        });
    });
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
        [_userImgView setImage:portraitImg];
        NSDictionary * dic = @{@"uid":[MFSystemManager shareManager].userModel.uID,
                               @"password":[MFSystemManager shareManager].userModel.password};
        NSString * url = [NSString stringWithFormat:@"%@%@code=%@",YU_MIMGV1,UPDATE_USERFACE,[MFUtility getCodeWithType:@"upload-userface"]];
        [NET_WORKING BasePicturePostMethodByURL:url Img:portraitImg Imgkey:@"userface" Parameters:dic Success:^(NSDictionary *dic) {
            [ProgressHUD showSuccess:@"图片已上传"];
            _userModel.touxiang = [dic objectForKey:@"original"];
            [MFSystemManager shareManager].userModel = _userModel;
            BOOL res = [UserModel saveSingleModel:_userModel forKey:@"userInfo"];
            if(res){
                NSLog(@"保存成功");
            }else{
                NSLog(@"保存失败");
            }

        } failure:^(NSString *msg) {
            [ProgressHUD showError:msg];
        }];
        
        
    }];
}
@end
