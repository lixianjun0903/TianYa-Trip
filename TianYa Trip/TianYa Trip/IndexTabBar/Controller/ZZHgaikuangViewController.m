//
//  ZZHgaikuangViewController.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/30.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHgaikuangViewController.h"

@interface ZZHgaikuangViewController ()

@end

@implementation ZZHgaikuangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", self.str);
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(10 *SCREEN_X, 84 *SCREEN_Y, self.view.frame.size.width - 20 *SCREEN_X, 50 *SCREEN_Y)];
    message.text = self.message;
    message.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [self.view addSubview:message];
    [message release];
    
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(10, message.frame.size.height + message.frame.origin.y, self.view.frame.size.width - 20 *SCREEN_X, self.view.frame.size.height - message.frame.size.height + message.frame.origin.y)];
    [self.view addSubview:label];
    
    label.text = self.str;
    [label release];
    
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
