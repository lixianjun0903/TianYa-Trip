//
//  ZZHUserViewController.m
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHUserViewController.h"
#import "CZQCollectionViewControlle.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "RegWeiboViewController.h"


#define WIDTH self.view.frame.size.width / 375
#define HEIGHT self.view.frame.size.height / 667

@interface ZZHUserViewController () <UITableViewDelegate, UITableViewDataSource, ChangeDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) NSArray *arr;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) NSString *touxiangURL;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) UIImageView *imageBackGround;
@property (nonatomic, retain) UIImageView *imageHead;
@property (nonatomic, retain) UILabel *labelUserName;
@property (nonatomic, retain) UIButton *buttonHead;
@property (nonatomic, retain) UIAlertView *msg ;
@property (nonatomic, retain) NSArray *iconArr;
@property (nonatomic, retain) MBProgressHUD *Myhud;

@end

@implementation ZZHUserViewController
- (void)dealloc
{

    [_tableView release];
    [_arr release];
    [_alert release];
    [_touxiangURL release];
    [_userName release];
    [_imageBackGround release];
    [_imageHead release];
    [_labelUserName release];
    [_buttonHead release];
    [_msg release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    self.title = @"天涯窝";
    [self createTableView];
    self.arr = [@[@"我的收藏", @"清除缓存", @"关于我们", @"分享应用"] mutableCopy];
    self.iconArr = @[[UIImage imageNamed:@"我的收藏"], [UIImage imageNamed:@"清除缓存"], [UIImage imageNamed:@"关于我们"], [UIImage imageNamed:@"夜间模式"]];
     // 背景图片
    self.imageBackGround = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375 * WIDTH, 260 * HEIGHT)] autorelease];
    _imageBackGround.image = [UIImage imageNamed:@"占位图"];
    _imageBackGround.contentMode = UIViewContentModeScaleAspectFill;
    _tableView.tableHeaderView = _imageBackGround;
    

     // 用户名(Label)
    self.labelUserName = [[[UILabel alloc] initWithFrame:CGRectMake(40 * WIDTH, 140 * HEIGHT, 295 * WIDTH,  30 * HEIGHT)] autorelease];
    [_labelUserName setTextAlignment:1];
//    _labelUserName.text = @"点击头像用新浪微博登录";
    [_labelUserName setTextColor:[UIColor whiteColor]];
    [_labelUserName setShadowColor:[UIColor blackColor]];
    // 阴影大小(阴影偏移)
    [_labelUserName setShadowOffset:CGSizeMake(0, 1)];
    _labelUserName.numberOfLines = 0;
    [_labelUserName setTextAlignment:NSTextAlignmentCenter];
    [_labelUserName setFont:[UIFont systemFontOfSize:17]];
    [_labelUserName setLineBreakMode:NSLineBreakByWordWrapping];
    [_tableView addSubview:_labelUserName];

    
    // 用户头像
    self.imageHead = [[[UIImageView alloc] initWithFrame:CGRectMake(150 *WIDTH, 40 * HEIGHT, 75 *WIDTH, 75 *WIDTH)] autorelease];
    _imageHead.backgroundColor = [UIColor whiteColor];
//    _imageHead.image = [UIImage imageNamed:@"weibo.png"];
    _imageHead.layer.cornerRadius = 75 *WIDTH / 2;
    _imageHead.layer.masksToBounds = YES;
    [_tableView addSubview:_imageHead];
    

    // 点击用户头像
    self.buttonHead= [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonHead.frame = CGRectMake(150 * WIDTH, 40 * HEIGHT, 75 * WIDTH, 75 * WIDTH);
    _buttonHead.layer.cornerRadius = 75 * WIDTH / 2;
    _buttonHead.layer.masksToBounds = YES;
    [_buttonHead addTarget:self action:@selector(SinaLogin) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:_buttonHead];

    //判断登陆状态
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo] == YES) {
        
        [self SinaLogin];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(loginOut)];
        self.navigationItem.leftBarButtonItem = nil;
        
    } else {
        self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(regWeibo)];
        _labelUserName.text = @"点击头像用新浪微博登录";
        _imageHead.image = [UIImage imageNamed:@"weibo.png"];
    }

}

- (void)regWeibo
{
    RegWeiboViewController *regVC = [[[RegWeiboViewController alloc]init]autorelease];
    [self.navigationController pushViewController:regVC animated:YES];
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
#pragma mark -  创建tableView
- (void) createTableView
{
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375 * WIDTH, 667 * HEIGHT +49 * HEIGHT) style:UITableViewStyleGrouped] autorelease];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1000;
    _tableView.rowHeight = 50 * HEIGHT;
//    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
}
#pragma mark -  控制每个区域显示的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}
#pragma mark -  根据行和区确定cell的显示样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *a = @"a";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:a];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:a];
    }
    
    
//    if (indexPath.row == 3) {
    
//        [self sinaShare];
        
//        https://itunes.apple.com/cn/app/id999211568
        
        // 夜间模式
//        UISwitch *swith = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//        swith.center = CGPointMake(self.view.frame.size.width / 6 * 5, cell.contentView.frame.size.height / 2);
//        
//        [cell.contentView addSubview:swith];
//        
//        [swith addTarget:self action:@selector(switch1Teg:) forControlEvents:UIControlEventValueChanged];
//        [swith release];
//    }
    cell.imageView.image = [_iconArr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = _arr[indexPath.row];
    return cell;
}

#pragma mark - 点击相应方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            NSLog(@"对应的方法");
            CZQCollectionViewControlle *collectionVC = [[[CZQCollectionViewControlle alloc] init] autorelease];
            collectionVC.str = _arr[indexPath.row];
            collectionVC.delegate = self;
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [self.navigationController pushViewController:collectionVC animated:YES];
            break;
        case 1:
                NSLog(@"判断");
            self.alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否清除缓存" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"返回", nil];
            [_tableView addSubview:_alert];
            _alert.tag = 1001;
            [_alert show];
            [_alert release];
            break;
        case 2:
            NSLog(@"判断2");
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:nil message:@"团队:NeoAppTeam\n邮箱:jack_yao_work@163.com" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [_tableView addSubview:alert2];
            [alert2 show];
            [alert2 release];
            break;
        case 3:
            [self sinaShare];
            break;
        default:
            break;
    }
}

#pragma mark - 通过判断弹窗按钮的索引值来做相应的事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == _alert) {
    if (buttonIndex == 0) {
        NSLog(@"hehe");
        NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES));
        NSLog(@"%.1f", (CGFloat)[[SDImageCache sharedImageCache] getSize] / 1024 / 1024.0);
        NSString *str = [NSString stringWithFormat:@"清除缓存%.1fM", (CGFloat)[[SDImageCache sharedImageCache] getSize] / 1024 / 1024.0];
        [[SDImageCache sharedImageCache] clearDisk];
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [al show];
        [self.view addSubview:al];
    }
    }
    if (buttonIndex == 0 && alertView == _msg) {
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        _labelUserName.text = @"点击头像用新浪微博登录";
        _imageHead.image = [UIImage imageNamed:@"weibo.png"];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(regWeibo)];
    }
}

-(void)change:(NSString *)str
{
    self.title = str;
    UITableView *t = (UITableView *)[self.view viewWithTag:1000];
    [t reloadData];
}

#pragma mark - 实现第三方登录
-(void)SinaLogin
{
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES      allowCallback:NO
                                                                scopes:nil powerByHidden:YES followAccounts:nil authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:_appDelegate.viewDelegate authManagerViewDelegate:nil];
    
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            NSLog(@"授权登陆成功，已获取用户信息");
            
            //获取ID[userInfo uid]
            //获取昵称[userInfo nickname]
            //获取头像[userInfo profileImage]
//            NSString *uid = [userInfo uid];
            NSString *nickname = [userInfo nickname];
            NSString *profileImage = [userInfo profileImage];
            self.touxiangURL  = profileImage;
            self.userName = nickname;
            NSLog(@"~~~~~~~~~~~~~~~%@",_touxiangURL);
             [_imageHead sd_setImageWithURL:[NSURL URLWithString:_touxiangURL]];
            _labelUserName.text = _userName;
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(loginOut)];
            self.navigationItem.leftBarButtonItem = nil;

        }else{
            NSLog(@"登录失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(regWeibo)];
        }
    }];
}

#pragma mark - 注销登录
- (void)loginOut
{
    self.msg = [[UIAlertView alloc]initWithTitle:@"注销登录" message:@"是否注销登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [_msg show];
    [_msg release];

}

-(void)sinaShare
{
    
    // 图片路径以及图片名
    //    NSString *path = [[NSBundle mainBundle]pathForResource:@"neoapp" ofType:@"jpg"];
    // 设置分享内容
    NSString *str = [NSString stringWithFormat:@"刚发现一款不错的旅游APP, 感兴趣的朋友请在AppStore里面搜索'走天涯'应用吧! https://itunes.apple.com/cn/app/id999211568"];//999222175
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


#pragma mark - 夜间模式实现方法
-(void)switch1Teg:(UISwitch *)Switch
{
    if (Switch.on) {
        self.view.window.alpha = 0.3;
    }else{
        self.view.window.alpha = 1;
    }
}


//下拉放大
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    CGFloat down = - 260 *SCREEN_Y *  - scrollView.contentOffset.y;
////    //    NSLog(@"!!!!%f", down);
////    NSLog(@"%f", scrollView.contentOffset.y);
////    
////    if (down < 324.5 *SCREEN_Y) return;
////    
////    CGRect frame = self.imageBackGround.frame;
////    // 2 决定图片变大的速度,值越大,速度越快
////    frame.size.height = 260 *SCREEN_Y - down;
////    self.imageBackGround.frame = frame;
//////    _imageBackGround.center = CGPointMake(187.5 *SCREEN_X, 187.5 *SCREEN_Y);
////
//    CGFloat yOffset  = scrollView.contentOffset.y;
//    NSLog(@"yOffset===%f",yOffset);
//    CGFloat xOffset = (yOffset + 260 *SCREEN_Y)/2;
//    if (yOffset < 162 *SCREEN_Y) {
//        CGRect f = self.imageBackGround.frame;
//        f.origin.y = yOffset - 60.0f;
//        f.size.height =  -yOffset + 60.0f;
//        f.origin.x = xOffset;
//        f.size.width = self.view.frame.size.width + fabsf(xOffset)*2;
//        self.imageBackGround.frame = f;
//    }
//}

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
