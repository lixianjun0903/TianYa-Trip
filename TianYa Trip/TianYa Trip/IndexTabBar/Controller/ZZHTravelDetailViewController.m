//
//  ZZHTravelDetailViewController.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/19.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHTravelDetailViewController.h"
#import "ZZHNetworkHandle.h"
#import "UIImageView+WebCache.h"
#import "ZZHFlowPictureViewController.h"
#import "ZZHjingpinViewController.h"
#import "ZZHPhotoViewController.h"
#import "AFHTTPRequestOperation.h"
#import "ZZHCityOrSignsViewController.h"
#import "ZZHgaikuangViewController.h"
@interface ZZHTravelDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSArray *hottest_sitesArr;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) NSInteger visited_count;
@property (nonatomic, assign) NSInteger wish_to_go_count;
@property (nonatomic, retain) NSArray *message;
@property (nonatomic, retain) NSArray *detail;
@property (nonatomic, retain) UIView *btnView;
@property (nonatomic, retain) NSArray *toolsArr;
@property (nonatomic, retain) NSString *shiyongUrl;
@property (nonatomic, retain) NSString *bukeUrl;
@property (nonatomic, retain) NSString *zhutiUrl;
@property (nonatomic, retain) NSString *jingipinUrl;
@property (nonatomic, retain) MBProgressHUD *hud;
@end

@implementation ZZHTravelDetailViewController
- (void)dealloc
{
    [_shiyongUrl release];
    [_bukeUrl release];
    [_zhutiUrl release];
    [_jingipinUrl release];
    [_scrollView release];
    [_collectionView release];
    [_hottest_sitesArr release];
    [_imageUrl release];
    [_name release];
    [_toolsArr release];
    [_btnView release];
    [_hud release];
//    [_visited_count release];
//    [_wish_to_go_count release];
    [super dealloc];
}

//视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.alpha = 0.1;
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    animated = YES;
    _imageView.alpha = 1;
    
    self.navigationController.navigationBar.alpha = 0;
    self.tabBarController.tabBar.alpha = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"url === == =%@", self.url);
    
    
    
    //*********取消预留高度**********
    self.automaticallyAdjustsScrollViewInsets = NO;
    //*************
    
    self.toolsArr = [NSArray array];
    self.hottest_sitesArr = [NSArray array];
    [self createHUD];
    [self getData];
}



- (void)createHUD
{
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.dimBackground = YES;
    _hud.labelText = @"正在加载中";
    [self.view addSubview:_hud];
    [_hud show:YES];
    [_hud release];
}

- (void)getData
{
    [ZZHNetworkHandle getDataWithUrl:self.url Cookie:@"bt_devid=i_9637109f377c2bf9ef66a5d9fb0029f0516d899027b696161b375dc02483b27dcc2530d0; Hm_lvt_39ccc5353de4e1969b414e80e516d5a7=1431654060,1431772717,1431910099,1432018143; sessionid=0efebca25d8334f1af45179879b9db64" completion:^(id result) {
        
        //        NSLog(@"%@", result);
        
        if ([(NSArray *)[result objectForKey:@"hottest_places"] count] != 0) {
            
            self.imageUrl = [[[result objectForKey:@"hottest_places"] objectAtIndex:0] objectForKey:@"photo"];
        }
        self.name = [result objectForKey:@"name"];
        if ([(NSArray *)[result objectForKey:@"hottest_sites"] count] != 0) {
            
            self.hottest_sitesArr = [result objectForKey:@"hottest_sites"];
        }
        self.visited_count = [[result objectForKey:@"visited_count"] integerValue];
        self.wish_to_go_count = [[result objectForKey:@"wish_to_go_count"] integerValue];
        self.toolsArr = [result objectForKey:@"tools"];
        //        NSLog(@"%@", _hottest_sitesArr);
        [self createScrollView];
        if (![[result objectForKey:@"description"] isEqualToString:@""]) {
            self.message = @[@"概况", @"地址", @"到达方式", @"开放时间", @"门票价格", @"联系方式", @"官方网站"];
            self.detail = @[[result objectForKey:@"description"], [result objectForKey:@"address"], [result objectForKey:@"arrival_type"], [result objectForKey:@"opening_time"], [result objectForKey:@"fee"], [result objectForKey:@"tel"], [result objectForKey:@"website"]];
            _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (self.detail.count * 100 + 300)* SCREEN_Y);
            [self createTableView];
            //            NSLog(@"!!!!!!%@", self.detail);
        }
        [_hud removeFromSuperview];
        //        [_collectionView reloadData];
    }];
}
//创建tableview
- (void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 260 * self.view.frame.size.height / 667, self.view.frame.size.width,self.detail.count * 100 * SCREEN_Y) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 100;
    tableView.scrollEnabled = NO;
    [self.scrollView addSubview:tableView];
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view sendSubviewToBack:self.imageView];
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    [tableView release];
}
//个数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detail.count;
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuse"];
    }
    cell.textLabel.text = self.message[indexPath.row];
    cell.detailTextLabel.text = self.detail[indexPath.row];
    cell.detailTextLabel.numberOfLines = 3;
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }
    NSLog(@"%@", [self.detail objectAtIndex:indexPath.row]);
    
    return cell;
}
//点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
        ZZHgaikuangViewController *zzhgaikuang = [[ZZHgaikuangViewController alloc] init];
        zzhgaikuang.message = [_message objectAtIndex:indexPath.row];
        zzhgaikuang.str = [_detail objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:zzhgaikuang animated:YES];
    }
}
//
- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    if (_hottest_sitesArr.count % 2 == 0) {
        //被2整除的item个数
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (150 *_hottest_sitesArr.count / 2 + 250 + 49  + 130) * self.view.frame.size.height / 667);
        NSLog(@"heihti%f", _scrollView.contentSize.height);
    }else
    {
        //可滑动大小**********
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (150 * (_hottest_sitesArr.count / 2 + 1) + 250 + 130) * self.view.frame.size.height / 667);
    }
//    NSLog(@"haha%f", _scrollView.contentSize.height);
    if (_scrollView.contentSize.height < self.view.frame.size.height) {
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 10);
    }
    //取消滑动线
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView release];
    //添加大图
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 0.5)];
    //测试*******
//     self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.width * 0.25 * self.view.frame.size.height / 667, self.view.frame.size.width, self.view.frame.size.width * 0.5 * self.view.frame.size.height / 667)];
//    imageView.backgroundColor = [UIColor redColor];
    //遮盖视图
    UIView *view22 = [[UIView alloc] initWithFrame:CGRectMake(0, 260 *SCREEN_Y, self.view.frame.size.height, 500 *SCREEN_Y)];
    view22.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view22];
    [view22 release];
    
    [self.view addSubview:_imageView];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.userInteractionEnabled = YES;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"占位图"]];
    [_imageView release];
    //创建轻拍手势
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    [_imageView addGestureRecognizer:tap];
//    [tap release];
    //namelabel
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * self.view.frame.size.width / 375, (self.imageView.frame.size.height - 10) *SCREEN_Y, self.view.frame.size.width, 50 * self.view.frame.size.height / 375)];
    [self.scrollView addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:20];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = self.name;
    nameLabel.shadowColor = [UIColor blackColor];
    nameLabel.shadowOffset = CGSizeMake(0, 1);
    [nameLabel release];
    
    UILabel *visitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * self.view.frame.size.width / 375, nameLabel.frame.origin.y + 40 *SCREEN_Y, SCREEN_WIDTH, 30 * self.view.frame.size.height / 375)];
    if (_visited_count > 10000 && _wish_to_go_count > 10000) {
        visitLabel.text = [NSString stringWithFormat:@"%.1f万 去过 / %.1f万 喜欢", (CGFloat)self.visited_count / 10000, (CGFloat)self.wish_to_go_count / 10000];
    }else if(_visited_count > 10000){
        visitLabel.text = [NSString stringWithFormat:@"%.1f万 去过 / %ld 喜欢", (CGFloat)self.visited_count / 10000, (long)self.wish_to_go_count];
    }else if(_wish_to_go_count > 10000){
        visitLabel.text = [NSString stringWithFormat:@"%ld 去过 / %.1f万 喜欢", (long)self.visited_count,(CGFloat)self.wish_to_go_count / 10000];
    }else{
        visitLabel.text = [NSString stringWithFormat:@"%ld 去过 / %ld 喜欢", (long)self.visited_count, (long)self.wish_to_go_count];
    }
    visitLabel.font = [UIFont systemFontOfSize:13];
    visitLabel.textColor = [UIColor whiteColor];
    [self.scrollView addSubview:visitLabel];
    visitLabel.shadowColor = [UIColor blackColor];
    visitLabel.shadowOffset = CGSizeMake(0, 1);
    [visitLabel release];
    //创建button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 20 *SCREEN_Y, 50 *SCREEN_X, 44 *SCREEN_Y);
//    [btn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5 *SCREEN_X, 12 *SCREEN_Y, 20 *SCREEN_X, 20 *SCREEN_Y)];
    image.image = [UIImage imageNamed:@"fanhui"];
    [btn addSubview:image];
    [image release];
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
    
    
    //更多图片
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(0, 60 *SCREEN_Y, self.view.frame.size.width, _imageView.frame.size.height - 60 *SCREEN_Y);
//    [btn2 setTitle:@"photo" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn2];
    
    //调用创建collectionView方法
    [self createCollectionView];
    
}
//轻拍方法
- (void)tap
{
    ZZHPhotoViewController *zzhphoto = [[ZZHPhotoViewController alloc] init];
    zzhphoto.str = [self.url stringByAppendingString:@"/photos/?gallery_mode=1&count=18"];
    [self.navigationController pushViewController:zzhphoto animated:YES];
}
//实现按钮方法
- (void)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 1;
}
//滑动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static NSInteger i = 0;
    if ((i = (_scrollView.contentOffset.y - 60) / 20)) {
        self.navigationController.navigationBar.alpha = 0.1 * i ;
    }
//    NSLog(@"%f", _scrollView.contentOffset.y);
//    NSLog(@"center%f %f", _imageView.center.x, _imageView.center.y);
        CGFloat down = (self.view.frame.size.width * 0.5) - scrollView.contentOffset.y;
//    NSLog(@"!!!!%f", down);
    
        if (down < self.view.frame.size.width * 0.5) return;
    
        CGRect frame = self.imageView.frame;
        // 2 决定图片变大的速度,值越大,速度越快
        frame.size.height = self.view.frame.size.width * 0.5 + down;
        self.imageView.frame = frame;
    _imageView.center = CGPointMake(187.5 *SCREEN_X, 187.5 *SCREEN_Y);
    
    

}
//创建放置按钮的视图
- (void)createView
{
    
    //各种按钮1
    static NSInteger index = 0;
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 260 * SCREEN_Y, self.view.frame.size.width, 90 * SCREEN_Y)];
    
    [self.scrollView addSubview:_btnView];
    _btnView.backgroundColor = [UIColor whiteColor];
    [_btnView release];
    for (NSDictionary *dic in self.toolsArr) {
        if ([[[dic objectForKey:@"type"] stringValue] isEqualToString:@"1"] && ![[dic objectForKey:@"url"] isEqualToString:@""]) {
            UIButton *shiyong = [UIButton buttonWithType:UIButtonTypeSystem];
            [shiyong addTarget:self action:@selector(shiyong) forControlEvents:UIControlEventTouchUpInside];
            shiyong.frame = CGRectMake(90* index * SCREEN_X, 0, 90 *SCREEN_X, 90 *SCREEN_Y);
//            [shiyong setTitle:@"实用须知" forState:UIControlStateNormal];
            [shiyong setImage:[UIImage imageNamed:@"实用须知"] forState:UIControlStateNormal];
            shiyong.tintColor = [UIColor grayColor];
            self.shiyongUrl = [dic objectForKey:@"url"];
            [self.btnView addSubview:shiyong];
            index += 1;
        }
        if ([[[dic objectForKey:@"type"] stringValue] isEqualToString:@"7"] && ![[dic objectForKey:@"url"] isEqualToString:@""]) {
            //    各种按钮2
            UIButton *buke = [UIButton buttonWithType:UIButtonTypeSystem];
            buke.tintColor = [UIColor grayColor];
            buke.frame = CGRectMake(90 * index * SCREEN_X, 0, 90 *SCREEN_X, 90 *SCREEN_Y);
            [buke addTarget:self action:@selector(buke) forControlEvents:UIControlEventTouchUpInside];
            [buke setImage:[UIImage imageNamed:@"不可错过"] forState:UIControlStateNormal];
//            UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
//            imageview1.center = buke.center;
//            imageview1.image = [UIImage imageNamed:@"不可错过"];
//            [buke addSubview:imageview1];
//            [imageview1 release];
            self.bukeUrl = [dic objectForKey:@"url"];
            [self.btnView addSubview:buke];
            index += 1;
        }
//        if ([[[dic objectForKey:@"type"] stringValue] isEqualToString:@"4"] && ![[dic objectForKey:@"url"] isEqualToString:@""]) {
//            //    各种按钮3
//            UIButton *zhuti = [UIButton buttonWithType:UIButtonTypeSystem];
//            zhuti.tintColor = [UIColor grayColor];
//            zhuti.frame = CGRectMake(90 * index * SCREEN_X, 0, 90 *SCREEN_X, 90 *SCREEN_Y);
//            [zhuti addTarget:self action:@selector(zhuti) forControlEvents:UIControlEventTouchUpInside];
////            [zhuti setTitle:@"主题榜单" forState:UIControlStateNormal];
//            [zhuti setImage:[UIImage imageNamed:@"主题榜单"] forState:UIControlStateNormal];
//            self.zhutiUrl = [dic objectForKey:@"url"];
//            [self.btnView addSubview:zhuti];
//            index += 1;
//        }

    }
//    各种按钮4
        UIButton *traveleNote = [UIButton buttonWithType:UIButtonTypeSystem];
        traveleNote.frame = CGRectMake(90 *index *SCREEN_X, 0, 90 *SCREEN_X, 90 * SCREEN_Y);
    self.jingipinUrl = [self.url stringByAppendingString:@"/trips"];
    traveleNote.tintColor = [UIColor grayColor];
    [traveleNote addTarget:self action:@selector(travelNote) forControlEvents:UIControlEventTouchUpInside];
//        [traveleNote setTitle:@"精品游记" forState:UIControlStateNormal];
    [traveleNote setImage:[UIImage imageNamed:@"精品游记"] forState:UIControlStateNormal];
    index +=1;
    
//    if (index > 3) {
//        self.btnView.frame = CGRectMake(0, 260 * SCREEN_Y, self.view.frame.size.width, 180 * SCREEN_Y);
//    }
        [self.btnView addSubview:traveleNote];
    
    //    各种按钮5
//    if (_hottest_sitesArr.count == 6) {
    
        UIButton *gengduo = [UIButton buttonWithType:UIButtonTypeSystem];
//        [gengduo setTitle:@"更多" forState:UIControlStateNormal];
        [gengduo setImage:[UIImage imageNamed:@"更多景点"] forState:UIControlStateNormal];
        [gengduo addTarget:self action:@selector(gengduo) forControlEvents:UIControlEventTouchUpInside];
        gengduo.tintColor = [UIColor grayColor];
        [self.btnView addSubview:gengduo];
//        if (index < 4) {
            _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _scrollView.contentSize.height + 170 *SCREEN_Y);
            gengduo.frame = CGRectMake(90 *index * SCREEN_X, 0, 90 *SCREEN_X, 90 * SCREEN_Y);
//        }
//        else{
//            _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _scrollView.contentSize.height + 155 *SCREEN_Y);
//            gengduo.frame = CGRectMake(0, 80 * SCREEN_X, 90 *SCREEN_X, 90 * SCREEN_Y);
//        }
//    }
    index = 0;
    
}
//各种按钮方法1
- (void)shiyong
{
    ZZHFlowPictureViewController *ZZHflow = [[ZZHFlowPictureViewController alloc] init];
    ZZHflow.str = self.shiyongUrl;
    [self.navigationController pushViewController:ZZHflow animated:YES];
}
//各种按钮方法2
- (void)buke
{
    ZZHFlowPictureViewController *ZZHflow = [[ZZHFlowPictureViewController alloc] init];
    ZZHflow.str = self.bukeUrl;
    [self.navigationController pushViewController:ZZHflow animated:YES];
}
//各种按钮方法3
- (void)zhuti
{
    ZZHFlowPictureViewController *ZZHflow = [[ZZHFlowPictureViewController alloc] init];
    ZZHflow.str = self.zhutiUrl;
    [self.navigationController pushViewController:ZZHflow animated:YES];
}
//各种按钮方法4
- (void)travelNote
{
    ZZHjingpinViewController *ZZHjingpin = [[ZZHjingpinViewController alloc] init];
    ZZHjingpin.str = self.jingipinUrl;
    [self.navigationController pushViewController:ZZHjingpin animated:YES];
}
//各种按钮方法5
- (void)gengduo
{
    ZZHCityOrSignsViewController *ZZHCOSVC = [[ZZHCityOrSignsViewController alloc] init];
    
    ZZHCOSVC.str1 = [self.url stringByAppendingString:@"/cities"];
    
    ZZHCOSVC.str2 = [self.url stringByAppendingString:@"/pois/sights/?sort=default&"];
    
    [self.navigationController pushViewController:ZZHCOSVC animated:YES];
}

//创建collectionView
- (void)createCollectionView
{
    
    
    
    
    
    [self.view sendSubviewToBack:self.imageView];
    [self createView];
    UIImageView  *MyimageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, _btnView.frame.size.height + 270* self.view.frame.size.height / 667, 250 *SCREEN_X, 30 *SCREEN_Y)];
    MyimageView.image = [UIImage imageNamed:@"推荐地点"];
    MyimageView.contentMode = UIViewContentModeScaleAspectFit;
//    MyimageView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:MyimageView];
    [MyimageView release];
    
//    if (_hottest_sitesArr.count == 6) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        button.frame = CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//    }
    
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    //大小
    flow.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - (10 * SCREEN_X), SCREEN_WIDTH / 2 - (10 * SCREEN_X));
    //距离
    flow.minimumLineSpacing = 5 * SCREEN_X;
    flow.minimumInteritemSpacing = 5 *SCREEN_Y;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _btnView.frame.size.height + 300 * self.view.frame.size.height / 667, self.view.frame.size.width,(self.view.frame.size.width / 2 + 10)  * _hottest_sitesArr.count * self.view.frame.size.height / 667) collectionViewLayout:flow];
    //代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    //注册
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    //取消滑动线
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(7 * SCREEN_X, 7 * SCREEN_X, 0, 7 * SCREEN_X);
   
    [_collectionView release];
    
    
    
    
    
    
    
    
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _hottest_sitesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
    [cell.contentView addSubview:imageView];
//    imageView.backgroundColor = [UIColor redColor];
    //添加图片到cell的view上
    [imageView sd_setImageWithURL:[NSURL URLWithString:[[_hottest_sitesArr objectAtIndex:indexPath.row] objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //锐角
    imageView.layer.cornerRadius = 5;
    //截图
    imageView.clipsToBounds = YES;
    [imageView release];
    //在图片上加上名字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, 40 * self.view.frame.size.height / 667)];
    [imageView addSubview:label];
    label.text = [[_hottest_sitesArr objectAtIndex:indexPath.row] objectForKey:@"name"];
//    label.textColor = [UIColor whiteColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor blackColor];
    label.alpha = 0.5;
    [label release];
    return cell;
}

//collection点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHTravelDetailViewController *zzhTDVC = [[ZZHTravelDetailViewController alloc] init];
    NSString *str = @"http://api.breadtrip.com/destination/place/";
    zzhTDVC.url = [NSString stringWithFormat:@"%@/%@/%@", str, [[_hottest_sitesArr objectAtIndex:indexPath.row] objectForKey:@"type"], [[_hottest_sitesArr objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    [self.navigationController pushViewController:zzhTDVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _imageView.alpha = 0;
    self.navigationController.navigationBar.alpha = 1;
    self.tabBarController.tabBar.alpha = 1;
    
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
