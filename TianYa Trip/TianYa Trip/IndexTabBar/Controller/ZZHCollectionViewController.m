//
//  ZZHCollectionViewController.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/21.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHCollectionViewController.h"
#import "UIImageView+WebCache.h"
#import "ZZHCollectionViewCell.h"
#import "ZZHCollection.h"
@interface ZZHCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) ZZHCollectionViewCell *cell;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UIView *NAVIview;
@end

@implementation ZZHCollectionViewController

- (void)dealloc
{
    [_collectionView release];
    [_backgroundView release];
    [_NAVIview release];
    [super dealloc];
}
//视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.alpha = 0;
    self.tabBarController.tabBar.alpha = 0;
}
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBar.alpha = 1;
    self.tabBarController.tabBar.alpha = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_backgroundView];
    self.index = 1;
    [self createCollectionView];
//    [self createNAVI];
//    [self createGesture];
    
}
//创建模拟导航
//- (void)createNAVI
//{
//    self.NAVIview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//    [self.view addSubview:_NAVIview];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    btn.frame = CGRectMake(0, 20 *SCREEN_Y, 50 *SCREEN_X, 50 *SCREEN_Y);
//    btn.tintColor = [UIColor whiteColor];
//    [btn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(btnPOP) forControlEvents:UIControlEventTouchUpInside];
//    [self.NAVIview addSubview:btn];
//    
//}
//实现跳转方法
- (void)btnPOP
{
    [self.navigationController popViewControllerAnimated:YES];
}
////创建轻拍手势
//- (void) createGesture
//{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollDispear:)];
//    [self.collectionView addGestureRecognizer:tap];
//    [tap release];
//}
////实现手势方法
//- (void)scrollDispear:(UITapGestureRecognizer *)tap
//{
//    if (self.index % 2 == 1) {
//        [UIView animateWithDuration:0.5 animations:^{
//            _scroll.alpha = 0;
//            
//        }];
//    }else{
//        [UIView animateWithDuration:0.5 animations:^{
//            _scroll.alpha = 1;
//        }];
//    }
//    self.index++;
//        
//    }
//创建scrollVIew
- (void)createScrollVIew
{
    //创建放置 text  timelabel 的滚动视图
   

}
//创建collectionVIew
- (void)createCollectionView
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    flow.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flow];
    //代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //注册
    [_collectionView registerClass:[ZZHCollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    _collectionView.pagingEnabled = YES;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //加到主视图
    [self.backgroundView addSubview:_collectionView];
}

//个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.arr objectAtIndex:section] count];
}
//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];

    
    ZZHCollection *ZZH = [[ZZHCollection alloc] initWithDic:[[self.arr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    _cell.ZZHC = ZZH;
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pin:)];
    [_cell.imageView addGestureRecognizer:pin];
    [pin release];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_cell addGestureRecognizer:tap];
    [tap release];
    _cell.contentView.backgroundColor = [UIColor blackColor];
    if (_cell.tap == YES) {
        _cell.textView.hidden = YES;
        _cell.timeLabel.hidden = YES;
    }else{
        _cell.textView.hidden = NO;
        _cell.timeLabel.hidden = NO;
    }
//    [_collectionView reloadData];
    return _cell;
}


- (void)pin:(UIPinchGestureRecognizer *)pin
{
//        pin.scale = 2;
    _cell.imageView.center = _cell.contentView.center;
    _cell.imageView = (UIImageView *)pin.view;
    [_cell.imageView setTransform:CGAffineTransformMakeScale(pin.scale, pin.scale)];
  
   
}
- (void)tap:(UITapGestureRecognizer *)tap
{
    if (self.index % 2 ==0) {
        _cell.tap = YES;
    }else{
        _cell.tap = NO;
    }
//    [_collectionView reloadData];
    self.index++;
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    _collectionView.minimumZoomScale = 1;
//    _collectionView.maximumZoomScale = 1;
//}
//- (void)tap:(UITapGestureRecognizer *)tap
//{
//        if (self.index % 2 == 1) {
//            [UIView animateWithDuration:0.5 animations:^{
//                self.cell.textView.alpha = 0;
//                self.cell.timeLabel.alpha = 0;
////                self.NAVIview.alpha = 0;
//            }];
//        }else{
//            [UIView animateWithDuration:0.5 animations:^{
//                self.cell.textView.alpha = 1;
//                self.cell.timeLabel.alpha = 1;
////                self.NAVIview.alpha = 1;
//            }];
//        }
//        self.index++;
//
//}
//点击方法
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    
//    
//    
//    if (self.index % 2 == 1) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.cell.textView.alpha = 0;
//            self.cell.timeLabel.alpha = 0;
//            self.NAVIview.alpha = 0;
//        }];
//    }else{
//        [UIView animateWithDuration:0.5 animations:^{
//            self.cell.textView.alpha = 1;
//            self.cell.timeLabel.alpha = 1;
//            self.NAVIview.alpha = 1;
//        }];
//    }
//    self.index++;
//}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.arr.count;
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
