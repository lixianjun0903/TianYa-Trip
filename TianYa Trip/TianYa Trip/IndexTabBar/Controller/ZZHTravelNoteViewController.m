//
//  ZZHTravelNoteViewController.m
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AGCommon/UINavigationBar+Common.h>
#import "AppDelegate.h"
#import "ZZHTravelNoteViewController.h"
#import "UIImageView+WebCache.h"
#import "ZZHNetworkHandle.h"
#import "ZZHHotTravelNote.h"
#import "ZZHHotTravelTableViewCell.h"
//#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "ZZHCollectionViewController.h"
#import "ZZHSC.h"

@interface ZZHTravelNoteViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *arr;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) NSMutableArray *arrOfFile;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, retain) NSMutableDictionary *dic;
@property (nonatomic, retain) ZZHSC *zzhsc;
@property (nonatomic, retain) MBProgressHUD *Myhud;

@end

@implementation ZZHTravelNoteViewController

- (void)dealloc
{
    [_tableView release];
    [_arr release];
    [_headImageView release];
    [_HUD release];
    [_arrOfFile release];
    [_Myhud release];
    [_dic release];
    [_zzhsc release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.arr = [NSMutableArray array];
    self.dic = [NSMutableDictionary dictionary];
//    [self createJuhua];
    [self createTableView];
   
    [self createHUD];
    [self getData];
    NSLog(@"%@", self.url);
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
//        //创建文件管理器
//        NSFileManager *manager = [NSFileManager defaultManager];
//        //获取路径
//        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//        //拼接路径
//        NSString *filepath = [path stringByAppendingPathComponent:@"shoucang"];
//        //新建文件夹
//        //    [manager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
//        //拼接plist路径
//        NSString *plistPath = [filepath stringByAppendingPathComponent:@"shoucang1.plist"];
//        NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
//        //    ZZHSC *zzhsc = [[ZZHSC alloc] initWithDic:_dic];
//        //    zzhsc.url = self.url;
//        if (arr.count == 0) {
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"faved"] style:UIBarButtonItemStyleDone target:self action:@selector(shoucang)];
//        }
//        for (NSInteger i = 0; i < arr.count; i++) {
//            ZZHSC *a = arr[i];
//            if ([a.url isEqualToString:self.url]) {
//                 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fav"] style:UIBarButtonItemStyleDone target:self action:@selector(cancelShoucang)];
//                NSLog(@"asdasd");
//            }else{
//                 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"faved"] style:UIBarButtonItemStyleDone target:self action:@selector(shoucang)];
//            }
//        }
//    }
//}
//收藏按钮
- (void)shoucang
{
    NSLog(@"chenggong");
        
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
    //创建文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    //获取路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //拼接路径
    NSString *filepath = [path stringByAppendingPathComponent:@"shoucang"];
    //新建文件夹
    [manager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    //拼接plist路径
    NSString *plistPath = [filepath stringByAppendingPathComponent:@"shoucang1.plist"];
    NSLog(@"%@", plistPath);
    if (![manager fileExistsAtPath:plistPath]) {
//        [_dic setObject:self.url forKey:@"url"];
        self.zzhsc = [[ZZHSC alloc] initWithDic:_dic];
        _zzhsc.url = self.url;
        NSLog(@"%@", self.zzhsc);
        self.arrOfFile = [NSMutableArray array];
        [_arrOfFile addObject:_zzhsc];
        [NSKeyedArchiver archiveRootObject:_arrOfFile toFile:plistPath];
//        [_dic release];
        
        [self HUDWithImg:@"fav" infoStr:@"收藏成功"];
        UIBarButtonItem *vc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"myfav"] style:UIBarButtonItemStyleDone target:self action:@selector(cancelShoucang)];
        UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(sinaShare)];
        self.navigationItem.rightBarButtonItems = @[share, vc];
    }else{
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        for (ZZHSC *zzhsc in array) {
        if ([self.url isEqualToString:zzhsc.url]) {
            [self HUDWithImg:@"fav" infoStr:@"已收藏"];
            break;
        }else if ([zzhsc isEqual:[array lastObject]]){
            self.zzhsc = [[ZZHSC alloc] initWithDic:_dic];
            _zzhsc.url = self.url;
            NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
            [array addObject:_zzhsc];
            [NSKeyedArchiver archiveRootObject:array toFile:plistPath];
           [self HUDWithImg:@"fav" infoStr:@"收藏成功"];
            UIBarButtonItem *vc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"myfav"] style:UIBarButtonItemStyleDone target:self action:@selector(cancelShoucang)];
            UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(sinaShare)];
            self.navigationItem.rightBarButtonItems = @[share, vc];
        }
        }
        }
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fav"] style:UIBarButtonItemStyleDone target:self action:@selector(cancelShoucang)];
    }else{
        [self HUDWithImg:@"info" infoStr:@"登陆后收藏"];
    }
    
}
//取消收藏
- (void)cancelShoucang
{
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
    //创建文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    //获取路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //拼接路径
    NSString *filepath = [path stringByAppendingPathComponent:@"shoucang"];
    //新建文件夹
//    [manager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    //拼接plist路径
    NSString *plistPath = [filepath stringByAppendingPathComponent:@"shoucang1.plist"];
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
//    ZZHSC *zzhsc = [[ZZHSC alloc] initWithDic:_dic];
//    zzhsc.url = self.url;
        for (NSInteger i = 0; i < arr.count; i++) {
            ZZHSC *a = arr[i];
            if ([a.url isEqualToString:self.url]) {
                [arr removeObjectAtIndex:i];
            }
        }
        
        NSLog(@"%@", _zzhsc);
        NSLog(@"%@", arr);
    [NSKeyedArchiver archiveRootObject:arr toFile:plistPath];
//        UIAlertView *alerb = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消收藏" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        [alerb show];
//        [self.view addSubview:alerb];
//        [alerb release];
        [self HUDWithImg:@"faved" infoStr:@"已取消收藏"];
        
        if (arr.count == 0) {
            [manager removeItemAtPath:plistPath error:nil];
        }
        UIBarButtonItem *vc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"myfaved"] style:UIBarButtonItemStyleDone target:self action:@selector(shoucang)];
        UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(sinaShare)];
        self.navigationItem.rightBarButtonItems = @[share, vc];
        
    }
}

- (void)HUDWithImg:(NSString *)imgName infoStr:(NSString *)infoStr
{
    self.Myhud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_Myhud];

    _Myhud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    _Myhud.labelText = infoStr;
    _Myhud.mode = MBProgressHUDModeCustomView;
    [_Myhud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [_Myhud removeFromSuperview];
                [_Myhud release];
        _Myhud = nil;
    }];
}

- (void)getData
{
    [ZZHNetworkHandle getDataWithUrl:self.url completion:^(id result) {
        self.dic = result;
        self.arr = [result objectForKey:@"days"];
        
        [_tableView reloadData];
        [_HUD removeFromSuperview];

//         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"faved"] style:UIBarButtonItemStyleDone target:self action:@selector(shoucang)];
        if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
            //        //创建文件管理器
//                    NSFileManager *manager = [NSFileManager defaultManager];
                    //获取路径
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                    //拼接路径
                    NSString *filepath = [path stringByAppendingPathComponent:@"shoucang"];
                    //新建文件夹
                    //    [manager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
                    //拼接plist路径
                    NSString *plistPath = [filepath stringByAppendingPathComponent:@"shoucang1.plist"];
                    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
                    //    ZZHSC *zzhsc = [[ZZHSC alloc] initWithDic:_dic];
                    //    zzhsc.url = self.url;

                if (arr.count == 0) {
                    UIBarButtonItem *vc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"myfaved"] style:UIBarButtonItemStyleDone target:self action:@selector(shoucang)];
                    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(sinaShare)];
                    self.navigationItem.rightBarButtonItems = @[share, vc];
                    return;
                }
            for (ZZHSC *zzhsc in arr) {
                if ([self.url isEqualToString:zzhsc.url]) {
                    UIBarButtonItem *vc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"myfav"] style:UIBarButtonItemStyleDone target:self action:@selector(cancelShoucang)];
                    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(sinaShare)];
                    self.navigationItem.rightBarButtonItems = @[share, vc];
                    NSLog(@"asdasd");
                    break;
                    
                }else{
                    UIBarButtonItem *vc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"myfaved"] style:UIBarButtonItemStyleDone target:self action:@selector(shoucang)];
                    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(sinaShare)];
                    self.navigationItem.rightBarButtonItems = @[share, vc];
                    }
            }
            
//        NSLog(@"%@", _arr);
        }else{
             UIBarButtonItem *vc = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"myfaved"] style:UIBarButtonItemStyleDone target:self action:@selector(shoucang)];
            UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(sinaShare)];
            self.navigationItem.rightBarButtonItems = @[share, vc];
        }
        
    }];
}

-(void)sinaShare
{
    
    // 图片路径以及图片名
    //    NSString *path = [[NSBundle mainBundle]pathForResource:@"neoapp" ofType:@"jpg"];
    // 设置分享内容
    NSString *str = [NSString stringWithFormat:@"#走天涯推荐# 刚在 走天涯 发现一篇不错的游记<%@>, 感兴趣的朋友请在AppStore里面搜索'走天涯'应用吧!https://itunes.apple.com/cn/app/id999211568", self.str];
    id<ISSContent> publishContent = [ShareSDK content:str defaultContent:nil image:nil title:nil url:nil description:nil mediaType:0];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES      allowCallback:NO
                                                                scopes:nil powerByHidden:YES followAccounts:nil authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:_appDelegate.viewDelegate authManagerViewDelegate:nil];
    //通过shareViewDelegate:参数修改分享界面的导航栏背景
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:_appDelegate.viewDelegate
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //调用分享菜单分享
    [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:authOptions shareOptions:shareOptions result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        //如果分享成功
        if (state == SSResponseStateSuccess) {
            NSLog(@"分享成功");
            [self HUDWithImg:@"ok" infoStr:@"分享成功"];
        }
        //如果分享失败
        if (state == SSResponseStateFail) {
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            [self HUDWithImg:@"error" infoStr:@"分享失败"];
        }
        if (state == SSResponseStateCancel){
            NSLog(@"分享取消");
            
        }
    }];
    
}

- (void)createHUD
{
    //初始化 至于当前View当中
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    //设置此属性 则当前的View至于后台
    _HUD.dimBackground = YES;
    //设置对话框文字
    _HUD.labelText = @"正在加载中";
    //显示对话框
    [_HUD show:YES];
    [_HUD release];
}

//创建tableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    //设置代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    //注册cell
    [_tableView registerClass:[ZZHHotTravelTableViewCell class] forCellReuseIdentifier:@"reuse"];
    //加入主视图
    [self.view addSubview:_tableView];
    
//    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200 *self.view.frame.size.height / 667)];
//     _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [_tableView release];
//    self.headImageView = [[UIImageView alloc] initWithFrame:_tableView.tableHeaderView.frame];
//    [_headImageView setImage:[UIImage imageNamed:@"Image_index_02bg"]];
//    [_tableView.tableHeaderView addSubview:_headImageView];
//    [_headImageView release];
    
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_arr objectAtIndex:section] objectForKey:@"waypoints"] count];
}
//tableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHHotTravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    ZZHHotTravelNote *hot = [[ZZHHotTravelNote alloc] initWithDic:[[[_arr objectAtIndex:indexPath.section] objectForKey:@"waypoints"] objectAtIndex:indexPath.row]];
    cell.HotTravelNote = hot;
    return cell;
}
//tableViewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHHotTravelNote *hot = [[ZZHHotTravelNote alloc] initWithDic:[[[_arr objectAtIndex:indexPath.section] objectForKey:@"waypoints"] objectAtIndex:indexPath.row]];
//    UIImageView *imageView = [[UIImageView alloc] init];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:hot.photo]];
    CGFloat f = 0;
    if (hot.photo_info) {
        f = [[hot.photo_info objectForKey:@"h"] integerValue] / (CGFloat)[[hot.photo_info objectForKey:@"w"] integerValue] * SCREEN_WIDTH - 20 * SCREEN_X ;
    }
    
//    NSLog(@"----------------------------%lf", f);
    return  f + [ZZHHotTravelTableViewCell getHeightWithText:hot.text] + 30 *SCREEN_Y ;

}

//section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arr.count;
}
//section名字

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"第%ld天   %@", [[[_arr objectAtIndex:section] objectForKey:@"day"] integerValue], [[_arr objectAtIndex:section] objectForKey:@"date"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50 * self.view.frame.size.height / 667;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZZHCollectionViewController *zzhCVC = [[ZZHCollectionViewController alloc] init];
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSDictionary *dic in self.arr) {
        NSMutableArray *arr = [dic objectForKey:@"waypoints"];
        for (NSDictionary *temp in arr) {
            NSMutableArray *array = [NSMutableArray array];
            if (![temp objectForKey:@"photo"] || [[temp objectForKey:@"photo"] isEqualToString:@""] || [[temp objectForKey:@"text"] isEqualToString:@""]) {
//                [[[self.arr objectAtIndex:indexPath.section] objectForKey:@"waypoints"] removeObject:temp];
            } else {
                [array addObject:temp];
                [tempArr addObject:array];
            }
        }
    }
//    zzhCVC.index = indexPath.row;
    zzhCVC.arr = tempArr;
    [self.navigationController pushViewController:zzhCVC animated:YES];
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
