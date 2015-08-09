//
//  ZZHfangdaViewController.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/27.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHfangdaViewController.h"
#import "ZZHsecondPhotoCell.h"
@interface ZZHfangdaViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain) UICollectionView *collectionView;
@end

@implementation ZZHfangdaViewController

- (void)dealloc
{
    [_collectionView release];
    [_arr release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup anomorefter loading the view.
    [self createCollectionView];
    
}
//视图将要出现的时候 偏转量变化
- (void)viewWillAppear:(BOOL)animated
{
    _collectionView.contentOffset = CGPointMake(self.view.frame.size.width *_index, 0);
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[ZZHsecondPhotoCell class] forCellWithReuseIdentifier:@"reuse"];
    [self.view addSubview:_collectionView];
    [_collectionView release];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHsecondPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    [cell.MyImageView sd_setImageWithURL:[NSURL URLWithString:[[_arr objectAtIndex:indexPath.row] objectForKey:@"photo_w640"]]];
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
