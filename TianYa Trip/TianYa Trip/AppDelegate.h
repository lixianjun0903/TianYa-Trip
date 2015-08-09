//
//  AppDelegate.h
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGViewDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,readonly)AGViewDelegate *viewDelegate;


@end

