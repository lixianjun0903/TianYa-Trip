//
//  ZZHFallCollectionViewController.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/31.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHFallCollectionViewController.h"
#import "ZZHfallCollectionViewCell.h"
@interface ZZHFallCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain) UICollectionView *collectionView;
@end

@implementation ZZHFallCollectionViewController

- (void)dealloc
{
    [_collectionView release];
    [_array release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCollectionView];
}


- (void)viewWillAppear:(BOOL)animated
{
    _collectionView.contentOffset = CGPointMake(self.indexTemp * self.view.frame.size.width, 0);
}
- (void)createCollectionView
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    flow.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flow];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;

    [_collectionView registerClass:[ZZHfallCollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    [self.view addSubview:_collectionView];
    [_collectionView release];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHfallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    ZZHSUb *sub = [[ZZHSUb alloc] initWithDic:[self.array objectAtIndex:indexPath.row]];
    cell.sub = sub;
    return cell;
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
