//
//  NEOADViewController.m
//  TianYa Trip
//
//  Created by BOSSNEO on 15/6/3.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "NEOADViewController.h"

@interface NEOADViewController ()

@end

@implementation NEOADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多精彩,敬请期待";
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *bgImg = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 64 *SCREEN_Y, SCREEN_WIDTH, SCREEN_HEIGHT)]autorelease];
    bgImg.image = [UIImage imageNamed:@"more"];
    [self.view addSubview:bgImg];
//    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBar.hidden = NO;
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
