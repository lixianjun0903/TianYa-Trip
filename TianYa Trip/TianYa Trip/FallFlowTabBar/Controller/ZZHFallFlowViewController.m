//
//  ZZHFallFlowViewController.m
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHFallFlowViewController.h"
#import "RPSlidingMenu.h"
#import "SubViewController.h"

@interface ZZHFallFlowViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, retain)UICollectionView *collectionView;
@property(nonatomic, retain)NSMutableArray *arr;
@property(nonatomic, retain)NSArray *webURLArr;
@property(nonatomic, retain)NSString *webURL;
@property(nonatomic, assign)NSInteger countNum;
@property (nonatomic, retain) MBProgressHUD *hud;
@end

@implementation ZZHFallFlowViewController

- (void)dealloc
{
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
    [_collectionView release];
    [_arr release];
    [_webURL release];
    [_webURLArr release];
    [_hud release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.887 green:0.316 blue:0.106 alpha:1.000];
    self.title = @"天涯情";
        self.countNum = 0;
    [self creatCollectionView];
    [self createHUD];
    [self getData];
    self.webURLArr =@[@"https://chanyouji.com/api/articles.json?page=2",
                      @"https://chanyouji.com/api/articles.json?page=3",
                      @"https://chanyouji.com/api/articles.json?page=4",
                      @"https://chanyouji.com/api/articles.json?page=5",
                      @"https://chanyouji.com/api/articles.json?page=6",
                      @"https://chanyouji.com/api/articles.json?page=7",
                      @"https://chanyouji.com/api/articles.json?page=8",
                      @"https://chanyouji.com/api/articles.json?page=9",
                      @"https://chanyouji.com/api/articles.json?page=10",
                      @"https://chanyouji.com/api/articles.json?page=11",
                      @"https://chanyouji.com/api/articles.json?page=12",
                      @"https://chanyouji.com/api/articles.json?page=13",
                      @"https://chanyouji.com/api/articles.json?page=14",
                      @"https://chanyouji.com/api/articles.json?page=15",
                      @"https://chanyouji.com/api/articles.json?page=16",
                      @"https://chanyouji.com/api/articles.json?page=17"];

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
    [NetworkHandle getDataWithHttpsURL:@"https://chanyouji.com/api/articles.json?page=1" completion:^(id result) {
        self.arr = result;
        [_collectionView reloadData];
        [_hud removeFromSuperview];
    }];
}

- (void)getMoreInfo
{
    if (_countNum < _webURLArr.count) {
       
        [NetworkHandle getDataWithHttpsURL:[_webURLArr objectAtIndex:_countNum] completion:^(id result) {
            for (NSDictionary *dic in result) {
                [self.arr addObject:dic];
            }
            [_collectionView reloadData];
            
        }];
        _countNum += 1;
    } else {
        [_collectionView.footer noticeNoMoreData];
    }
}
- (void)creatCollectionView
{
    //第一步:重定义flowlayout
    RPSlidingMenuLayout *flowlayout = [[RPSlidingMenuLayout alloc]init];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView addLegendFooterWithRefreshingBlock:^{
        [self getMoreInfo];
    }];
    _collectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_collectionView];
    
    //第二步:重注册Cell class
    [_collectionView registerClass:[RPSlidingMenuCell class] forCellWithReuseIdentifier:@"cell"];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //第三步:重定义Cell 重用池
    RPSlidingMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor grayColor];
    cell.textLabel.text = [_arr[indexPath.row] objectForKey:@"name"];
    cell.textLabel.shadowColor = [UIColor blackColor];
    cell.textLabel.shadowOffset = CGSizeMake(0, 2.0);
    cell.detailTextLabel.text = [_arr[indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.shadowColor = [UIColor blackColor];
    cell.detailTextLabel.shadowOffset = CGSizeMake(0, 1.0);
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[_arr[indexPath.row] objectForKey:@"image_url"]]placeholderImage:[UIImage imageNamed:@"占位图"]];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.arr.count - 1) {
        [self getMoreInfo];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arr.count;
}
//item点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    SubViewController *subVC = [[[SubViewController alloc]init]autorelease];
    
    subVC.webURL = [NSString stringWithFormat:@"https://chanyouji.com/api/articles/%@.json?page=1", [[_arr objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    [self.navigationController pushViewController:subVC animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
