//
//  AppDelegate.m
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZHBaseViewController.h"
#import "ZZHDestinationViewController.h"
#import "ZZHIndexViewController.h"
#import "ZZHUserViewController.h"
#import "ZZHIndexViewController.h"
#import "ZWIntroductionViewController.h"
#import "ZZHFallFlowViewController.h"
#import "NetworkHandle.h"
#import "NeoAppTools.h"
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UINavigationBar+Common.h>
#import "WeiboSDK.h"

@interface AppDelegate ()<UITabBarControllerDelegate>
@property (nonatomic, retain) ZWIntroductionViewController *introduction;
@property (nonatomic, retain) MBProgressHUD *HUD;
@end

@implementation AppDelegate

@synthesize viewDelegate = _viewDelegate;

- (id)init
{
    if (self = [super init]) {
        _viewDelegate = [[AGViewDelegate alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:3.0];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
   
    
    ZZHIndexViewController *IndexVC = [[ZZHIndexViewController alloc] init];
    IndexVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"走天涯" image:[UIImage imageNamed:@"index"] selectedImage:[UIImage imageNamed:@"indexed"]];
    UINavigationController *naviIndex = [[UINavigationController alloc] initWithRootViewController:IndexVC];
    [IndexVC release];

    
    ZZHDestinationViewController *DestinationVC = [[ZZHDestinationViewController alloc] init];
    DestinationVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"去何方" image:[UIImage imageNamed:@"des"] selectedImage:[UIImage imageNamed:@"desed"]];
    UINavigationController *naviDestination = [[UINavigationController alloc] initWithRootViewController:DestinationVC];
    [DestinationVC release];

    
    ZZHFallFlowViewController  *fallVC = [[ZZHFallFlowViewController alloc] init];
    fallVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"天涯情" image:[UIImage imageNamed:@"flow"] selectedImage:[UIImage imageNamed:@"flowed"]];
    UINavigationController *naviBase = [[UINavigationController alloc] initWithRootViewController:fallVC];
    [fallVC release];
    
    ZZHUserViewController *UserVC = [[ZZHUserViewController alloc] init];
    UserVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"天涯窝" image:[UIImage imageNamed:@"user"] selectedImage:[UIImage imageNamed:@"usered"]];
    UINavigationController *naviUser = [[UINavigationController alloc] initWithRootViewController:UserVC];
    [UserVC release];
    
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    
    tabBar.delegate = self;
    tabBar.viewControllers = @[naviIndex, naviDestination, naviBase, naviUser];
    self.window.rootViewController = tabBar;
    tabBar.tabBar.translucent = YES;
    [tabBar.tabBar setBarStyle:UIBarStyleBlack];
    if (tabBar.selectedIndex == 0) {
        [self.window bringSubviewToFront:IndexVC.view];
    }
    
    
    
    
    
    [tabBar release];
    [_window release];
    
    //1. 注册shareSDK
    [ShareSDK registerApp:@"7a2cefd614b1"];
    
    //2. 初始化社交平台
    [self initializePlat];
    
    NSArray *coverImageNames = @[@"img_index_01t", @"img_index_02t", @"img_index_03t"];
    NSArray *background = @[@"img_01", @"img_02", @"img_03"];
    self.introduction = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:background];
    [self.window addSubview:self.introduction.view];
    
    __weak AppDelegate *weakSelf = self;
    self.introduction.didSelectedEnter = ^() {
        [weakSelf.introduction.view removeFromSuperview];
        weakSelf.introduction = nil;
    };
    
    [NetworkHandle startNetMonitoringWithCompletion:^(id result) {
        [self HUDWithImg:[result objectForKey:@"infoImg"] infoStr:[result objectForKey:@"info"]];
    }];
    
    return YES;
}

- (void)HUDWithImg:(NSString *)imgName infoStr:(NSString *)infoStr
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:_HUD];
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    _HUD.labelText = infoStr;
    _HUD.mode = MBProgressHUDModeCustomView;
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(3);
    } completionBlock:^{
        [_HUD removeFromSuperview];
        //        [_HUD release];
        _HUD = nil;
    }];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%@", viewController);
    UINavigationController *nav = (UINavigationController *)viewController;
    [nav popToRootViewControllerAnimated:YES];
}

- (void)initializePlat
{
    //初始化新浪，在新浪微博开放平台上申请应用
    [ShareSDK connectSinaWeiboWithAppKey:@"1866895434"
                               appSecret:@"3f910264800a90f785b5051a6791bcdf"
                             redirectUri:@"http://www.neoapp.cn"
                             weiboSDKCls:[WeiboSDK class]];
    
    //    [ShareSDK connectSinaWeiboWithAppKey:@"3865971016" appSecret:@"a076fcc39950225d4ba8e618ef877484" redirectUri:@"http://www.neoapp.cn"];
    //上面的方法会又客户端跳客户端，没客户端跳web.
    
}

//添加两个回调方法,return的必须要ShareSDK的方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url

{
    
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation

{
    
    return [ShareSDK handleOpenURL:url
            
                 sourceApplication:sourceApplication
            
                        annotation:annotation
            
                        wxDelegate:nil];
    
}
//禁止横屏方法
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
