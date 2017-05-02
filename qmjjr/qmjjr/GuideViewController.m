//
//  GuideViewController.m
//  qmjjr
//
//  Created by zhuna on 2017/4/25.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "GuideViewController.h"
#import "BaseNavgationController.h"

@interface GuideViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_imgScorllView;
    UIPageControl *_pageControl;
}
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imgScorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _imgScorllView.showsHorizontalScrollIndicator = NO;
    _imgScorllView.showsVerticalScrollIndicator = NO;
    _imgScorllView.pagingEnabled = YES;
    _imgScorllView.delegate = self;
    _imgScorllView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    [self.view addSubview:_imgScorllView];
    
    for (int i = 1; i <= 3; i++) {
        NSString *imgName = [NSString stringWithFormat:@"iphone5_%d",i];
        if(iPhone4 || iPhone4s){
            imgName = [NSString stringWithFormat:@"iphone4_%d",i];
        }else if(iPhone6){
            imgName = [NSString stringWithFormat:@"iphone6_%d",i];
        }else if (iPhone6p){
            imgName = [NSString stringWithFormat:@"iphone6p_%d",i];
        }
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        imgView.userInteractionEnabled = YES;
        imgView.frame = CGRectMake((i - 1) * ScreenWidth, 0, ScreenWidth, ScreenHeight);
        if (i == 3) {
            UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [goButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
            [goButton addTarget:self action:@selector(goHomeView) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:goButton];
            if (ScreenHeight <= 480) {
                goButton.frame = CGRectMake((ScreenWidth - (103 * Width_Ratio)) / 2, ScreenHeight - 50 - (26 * Height_Ratio), 103 * Width_Ratio, 26 * Height_Ratio);
            }else{
                goButton.frame = CGRectMake((ScreenWidth - (103 * Width_Ratio)) / 2, ScreenHeight - 60* Height_Ratio - (26 * Height_Ratio), 103 * Width_Ratio, 26 * Height_Ratio);
            }
            
        }
        [_imgScorllView addSubview:imgView];
    }
}

- (void) goHomeView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseNavgationController *mainVC = [storyBoard instantiateViewControllerWithIdentifier:@"BaseNavgationController"];
    KEY_WINDOW.rootViewController = mainVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
