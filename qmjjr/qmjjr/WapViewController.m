//
//  WapViewController.m
//  monph
//
//  Created by zhuna on 15/6/12.
//  Copyright (c) 2015年 monph. All rights reserved.
//

#import "WapViewController.h"




@interface WapViewController ()<UIWebViewDelegate>

@end

@implementation WapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (Ios7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//    self.hidesBottomBarWhenPushed = YES;
    
    [self.view addSubview:self.webView];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%@url=\n%@",self.title,self.urlStr);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
 
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
       NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
    [ProgressHUD show:@"努力加载中..."];
//    [self performSelector:@selector(dismissProgress) withObject:nil afterDelay:5];
}
- (void)dismissProgress{
    [ProgressHUD dismiss];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [ProgressHUD dismiss];
    
}

- (void) back
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    [ProgressHUD dismiss];


}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError");
    [ProgressHUD dismiss];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIWebView*)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.backgroundColor = DEFULT_BACKGROUND_COLOR;
    }
    return _webView;
}

@end
