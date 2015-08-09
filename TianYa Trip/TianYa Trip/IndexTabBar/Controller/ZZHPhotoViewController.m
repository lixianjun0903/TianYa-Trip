//
//  ZZHPhotoViewController.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/27.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHPhotoViewController.h"
#import "ZZHPhotoCollectionViewCell.h"
#import "ZZHNetworkHandle.h"
#import "ZZHCollectionViewController.h"
#import "ZZHfangdaViewController.h"
@interface ZZHPhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *photoArr;
@property (nonatomic, retain) NSString *tempUrl;
@property (nonatomic, retain) MBProgressHUD *hud;
@end

@implementation ZZHPhotoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tempUrl = [self.str stringByAppendingString:@"&start="];
    self.tempUrl = [self.tempUrl stringByReplacingCharactersInRange:NSMakeRange(0, 25) withString:@"http://api.breadtrip.com//"];
    [self createHUD];
    [self createCollectionView];
    [self getData];
//    [self refresh];
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

//获取数据
- (void)getData
{
    NSLog(@"%@", self.str);
    [ZZHNetworkHandle getDataWithUrl:self.str completion:^(id result) {
        self.photoArr = [NSMutableArray array];
        self.photoArr = [result objectForKey:@"items"];
        [_collectionView reloadData];
        if ([result objectForKey:@"next_start"] != [NSNull null]){
            self.str = [NSString stringWithFormat:@"%@%@", self.tempUrl, [result objectForKey:@"next_start"]];
            [self refresh];
        }
        if (_photoArr.count == 0) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120 *SCREEN_X, 90 *SCREEN_Y)];
            //            imageView.backgroundColor = [UIColor blackColor];
            imageView.center = self.view.center;
            imageView.image = [UIImage imageNamed:@"noinfo"];
            [self.view addSubview:imageView];
            [imageView release];
        }
        
        [_hud removeFromSuperview];
    }];
}
//下拉刷新数据
- (void)refreshGetData
{
    NSLog(@"%@", self.str);
    [ZZHNetworkHandle getDataWithUrl:self.str completion:^(id result) {
//        NSLog(@"%@", [[result objectForKey:@"next_start"] stringValue]);
        for (NSDictionary *dic in [result objectForKey:@"items"]) {
            [self.photoArr addObject:dic];
        }
        [_collectionView reloadData];
        [self.collectionView.footer endRefreshing];
//        http://api.breadtrip.com/destination/place//1/MV/photos/?gallery_mode=1&count=18&strat=18
//        http://api.breadtrip.com//destination/place/1/MV/photos/?gallery_mode=1&count=18&start=18
//        http://api.breadtrip.com//destination/place/1/MV/photos/?gallery_mode=1&count=18&strat=18

        if ([result objectForKey:@"next_start"] != [NSNull null]){
        self.str = [NSString stringWithFormat:@"%@%@", self.tempUrl, [result objectForKey:@"next_start"]];
        }else{
        [self.collectionView.footer noticeNoMoreData];
        }
    }];
}
//下拉
- (void)refresh
{
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        [self refreshGetData];
    }];
}
- (void)createCollectionView
{
    //创建布局
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    
    flow.minimumInteritemSpacing = 2;
    flow.minimumLineSpacing = 2;
    
    flow.itemSize = CGSizeMake((self.view.frame.size.width - 4) / 3, (self.view.frame.size.width - 4) / 3);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) collectionViewLayout:flow];
    //代理
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    //注册
//    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ZZHPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    //加入主视图
    [self.view addSubview:_collectionView];
    [_collectionView release];
}
//个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photoArr.count;
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell.MyImageView sd_setImageWithURL:[NSURL URLWithString:[[_photoArr objectAtIndex:indexPath.row] objectForKey:@"photo_w640"]] placeholderImage:[UIImage imageNamed:@"占位图"]];
     cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

//点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHfangdaViewController *zzhCVC = [[[ZZHfangdaViewController alloc] init] autorelease];
    zzhCVC.arr = _photoArr;
    zzhCVC.index = indexPath.row;
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
