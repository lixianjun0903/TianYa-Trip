//
//  ZZHCountryListViewController.m
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHCountryListViewController.h"
#import "NEOCountryList.h"
#import "ZZHTravelDetailViewController.h"

@interface ZZHCountryListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain)UICollectionView *collectionView;
@end

@implementation ZZHCountryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatCollectionView];
    [self getData];
    
}

- (void)getData
{
    [NetworkHandle getDataWithURL:self.url completion:^(id result) {
        NSArray *tempArr = [result objectForKey:@"data"];
        self.arr = [NSMutableArray array];
        for (NSDictionary *dic in tempArr) {
            NEOCountryList *c = [[NEOCountryList alloc]initWithDic:dic];
            c.name = [dic objectForKey:@"name"];
            c.imgURL = [dic objectForKey:@"cover_s"];
            c.pageID = [dic objectForKey:@"id"];
            c.pageType = [dic objectForKey:@"type"];
            [self.arr addObject:c];
        }
        [_collectionView reloadData];
    }];
}

- (void)creatCollectionView
{
    UICollectionViewFlowLayout *flowlayout = [[[UICollectionViewFlowLayout alloc]init]autorelease];
    //layout
    //设置item大小
    flowlayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - 10 * SCREEN_X , SCREEN_WIDTH / 2 - 10 * SCREEN_X);
    //设置item最小行间距
    flowlayout.minimumLineSpacing = 5 * SCREEN_X;
    //列间距
    flowlayout.minimumInteritemSpacing = 5 * SCREEN_Y;
    //滑动方向
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //item边界
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 7 * SCREEN_X, 0, 7 * SCREEN_X);
    
    self.collectionView = [[[UICollectionView alloc]initWithFrame:CGRectMake(0, 10 * SCREEN_Y, SCREEN_WIDTH, SCREEN_HEIGHT - 20 * SCREEN_Y) collectionViewLayout:flowlayout]autorelease];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    
    UIImageView *img = [[[UIImageView alloc]initWithFrame:cell.contentView.frame]autorelease];
    [img sd_setImageWithURL:[NSURL URLWithString:[_arr[indexPath.item] imgURL]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.contentView addSubview:img];
    
    UILabel *siteLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height / 5)]autorelease];
    siteLabel.text = [_arr[indexPath.item] name];
    siteLabel.textColor = [UIColor whiteColor];
    siteLabel.textAlignment = 1;
    siteLabel.backgroundColor = [UIColor blackColor];
    siteLabel.alpha = 0.5;
    [cell.contentView addSubview:siteLabel];
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZZHTravelDetailViewController *zzhTDVC = [[ZZHTravelDetailViewController alloc] init];
    NSString *str = @"http://api.breadtrip.com/destination/place/";
    zzhTDVC.url = [NSString stringWithFormat:@"%@/%@/%@", str,[_arr[indexPath.item] pageType],[_arr[indexPath.item] pageID] ];
    [self.navigationController pushViewController:zzhTDVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
