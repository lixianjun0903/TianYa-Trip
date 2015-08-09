//
//  AGViewDelegate.m
//  ShareSDKForBackgroundOfNavigation
//
//  Created by lisa on 14-7-22.
//  Copyright (c) 2014年 lisa. All rights reserved.
//

#import "AGViewDelegate.h"
#import <AGCommon/UINavigationBar+Common.h>

@implementation AGViewDelegate

#pragma mark - ISSShareViewDelegate

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    //修改分享界面和授权界面的导航栏背景
    viewController.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    viewController.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

}


@end
