//
//  RegWeiboViewController.m
//  TianYa Trip
//
//  Created by BOSSNEO on 15/6/12.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "RegWeiboViewController.h"

@interface RegWeiboViewController ()<UIWebViewDelegate>

@end

@implementation RegWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *web = [[[UIWebView alloc]initWithFrame:SCREEN_FRAME]autorelease];
    web.backgroundColor = [UIColor clearColor];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.weibo.cn/reg/index?&vt=4&wm=3349&backURL=http%3A%2F%2Fm.weibo.cn%2F"]];
    [self.view addSubview: web];
    [web loadRequest:request];

    
    // Do any additional setup after loading the view.
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
