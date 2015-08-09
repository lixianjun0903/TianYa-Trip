//
//  ZZHDestinationViewController.m
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHDestinationViewController.h"

#import "DesView.h"
#import "ZZHDestination.h"
#import "ZZHCountryListViewController.h"
#import "ZZHTravelDetailViewController.h"

@interface ZZHDestinationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, retain)UICollectionView *collectionView;
@property(nonatomic, retain)NSMutableArray *arr;
@property(nonatomic, assign)NSInteger *tempNum;
@property(nonatomic, retain)NSDictionary *dic;
@property (nonatomic, retain) MBProgressHUD *hud;
@end

@implementation ZZHDestinationViewController

- (void)viewDidLoad {
    self.title = @"去何方";
    [super viewDidLoad];
    [self creatCollectionView];
    [self getData];
    [self createHUD];
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
    [NetworkHandle getDataWithURL:@"http://api.breadtrip.com/destination/v3/" completion:^(id result) {
        NSArray *tempArr = [result objectForKey:@"elements"];
        self.arr = [NSMutableArray array];
        for (NSDictionary *dic in tempArr) {
            ZZHDestination *des = [[ZZHDestination alloc]initWithDic:dic];
            [_arr addObject:des];
        }
        [_collectionView reloadData];
        [_hud removeFromSuperview];
    }];
}

- (void)creatCollectionView
{
    UICollectionViewFlowLayout *flowlayout = [[[UICollectionViewFlowLayout alloc]init]autorelease];
    //设置item大小
    flowlayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width / 2 - 10 * SCREEN_X) , ([UIScreen mainScreen].bounds.size.width / 2 - 10 *SCREEN_Y ));
    //行间距
    flowlayout.minimumLineSpacing = 5 * SCREEN_X;
    //列间距
    flowlayout.minimumInteritemSpacing = 5 * SCREEN_Y;
    //滑动方向
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //item边界
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 7 * SCREEN_X, 0, 7 * SCREEN_X);
    
    self.collectionView = [[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 10 * SCREEN_Y) collectionViewLayout:flowlayout]autorelease];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [_collectionView registerClass:[DesView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"neoHeader"];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
    UIImageView *img = [[[UIImageView alloc]initWithFrame:cell.contentView.frame]autorelease];
    [img sd_setImageWithURL:[NSURL URLWithString:[[[_arr[indexPath.section] dataArr] objectAtIndex:indexPath.item]objectForKey:@"cover_s"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.contentView addSubview:img];
    
    UILabel *siteLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height / 5)]autorelease];
    siteLabel.text = [[[_arr[indexPath.section] dataArr] objectAtIndex:indexPath.item]objectForKey:@"name"];
    siteLabel.textColor = [UIColor whiteColor];
    siteLabel.textAlignment = 1;
    siteLabel.backgroundColor = [UIColor blackColor];
    siteLabel.alpha = 0.5;
    [cell.contentView addSubview:siteLabel];
    return cell;
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[_arr objectAtIndex:section] dataArr] count];
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _arr.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZZHTravelDetailViewController *zzhTDVC = [[ZZHTravelDetailViewController alloc] init];
    NSString *str = @"http://api.breadtrip.com/destination/place/";
    zzhTDVC.url = [NSString stringWithFormat:@"%@%@/%@", str, [[[[_arr objectAtIndex:indexPath.section] dataArr] objectAtIndex:indexPath.row] objectForKey:@"type"], [[[[_arr objectAtIndex:indexPath.section] dataArr] objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:zzhTDVC animated:YES];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    DesView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"neoHeader" forIndexPath:indexPath];
    
    [headView setLabelText:[_arr[indexPath.section] title]];
    
    if (indexPath.section == 2) {
        self.dic = @{@"url":@"http://api.breadtrip.com/destination/index_places/3/", @"titleStr":@"欧洲国家"};
    
    }else if (indexPath.section == 5) {
        self.dic = @{@"url":@"http://api.breadtrip.com/destination/index_places/6/", @"titleStr":@"亚洲国家"};
        
    }else if (indexPath.section == 6) {
        self.dic = @{@"url":@"http://api.breadtrip.com/destination/index_places/8/", @"titleStr":@"国内城市"};
    }
    
    [headView.rightButton addTarget:self action:@selector(pushMore) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 4) {
        headView.rightButton.hidden = YES;
    }else {
        headView.rightButton.hidden = NO;
    }
    
    return headView;
}

- (void)pushMore
{
    ZZHCountryListViewController *contryListVC = [[[ZZHCountryListViewController alloc]init]autorelease];
    contryListVC.url = [_dic objectForKey:@"url"];
    contryListVC.titleStr = [_dic objectForKey:@"titleStr"];
    [self.navigationController pushViewController:contryListVC animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {SCREEN_WIDTH,50 * SCREEN_Y};
    return size;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
