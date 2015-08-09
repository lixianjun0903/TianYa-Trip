//
//  ZZHFlowPictureViewController.m
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHFlowPictureViewController.h"
#import "MBProgressHUD.h"
@interface ZZHFlowPictureViewController ()<UIWebViewDelegate>
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@end

@implementation ZZHFlowPictureViewController

- (void)dealloc
{
    [_webView release];
    [_HUD release];
    [_activityIndicator release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.translucent = YES;
    NSLog(@"%@", self.str);
    [self createWebView];
    
    
}

//- (void)createHUD
//{
//    //创建小菊花
//    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.webView addSubview:_HUD];
//    _HUD.dimBackground = YES;
//    _HUD.labelText = @"正在加载";
//    [_HUD showAnimated:YES whileExecutingBlock:^{
//        sleep(100);
//    }];
//    
//}

- (void)createWebView
{
    NSLog(@"%@", _str);
    
    //创建webView
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.str]];
    
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:request];
    
}
//加入等待
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
    [_activityIndicator setCenter:self.view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:_activityIndicator];
    
    [_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:108];
    [view removeFromSuperview];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
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
