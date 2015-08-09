//
//  ZZHIndexViewController.m
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHIndexViewController.h"
#import "ZZHNetworkHandle.h"
#import "ZZHFlowPictureViewController.h"
#import "ZZHTravelNoteViewController.h"
#import "UIImageView+WebCache.h"
#import "ZZHNetworkHandle.h"
#import "ZZHIndexTravelTableViewCell.h"
#import "MBProgressHUD.h"
#import "ZZHTravel.h"
#import "MJRefresh.h"
#import "ZZHSearchViewController.h"
#import "ZZHFlowCollectionViewCell.h"
#import "NEOADViewController.h"

@interface ZZHIndexViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate>
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UIPageControl *page;
//@property (nonatomic, retain) NSDictionary *myDic;
@property (nonatomic, retain) NSMutableArray *flowPictureArrTemp;
@property (nonatomic, retain) NSMutableArray *flowPicture;
@property (nonatomic, retain) NSMutableArray *travelNoteArr;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) NSArray *searchArr;
@property (nonatomic, retain) NSString *url;
//@property (nonatomic, assign) NSInteger num;
@end

@implementation ZZHIndexViewController

- (void)dealloc
{
    [_searchBar release];
    [_tableView release];
    [_scrollView release];
    [_page release];
    [_searchArr release];
    [_url release];
    [_collectionView release];
    [_page release];
//    [_myDic release];
    [_flowPictureArrTemp release];
    [_flowPicture release];
    [_HUD release];
    [_travelNoteArr release];
    [super dealloc];
}
//视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.alpha = 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"走天涯";
    
//    self.myDic = [NSDictionary dictionary];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.flowPictureArrTemp = [NSMutableArray array];
    self.flowPictureArrTemp = [@[[UIImage imageNamed:@"banner11"], [UIImage imageNamed:@"banner22"], [UIImage imageNamed:@"banner33"], [UIImage imageNamed:@"banner44"]] mutableCopy];
    self.flowPicture = [@[[UIImage imageNamed:@"banner44"], [UIImage imageNamed:@"banner11"], [UIImage imageNamed:@"banner22"], [UIImage imageNamed:@"banner33"], [UIImage imageNamed:@"banner44"], [UIImage imageNamed:@"banner11"]] mutableCopy];
    self.travelNoteArr = [NSMutableArray array];
    self.searchArr = [NSArray array];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(sousuo)];
    self.url = @"http://api.breadtrip.com/v5/index/?inext_start=";
    
    [self createScrollView];
    [self createCollectionView];
    _collectionView.alpha = 0;
    [self createTableView];
    [self getDataUP];
   
    [self createRefresh];
    [self createHUD];
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(lunbo) userInfo:nil repeats:YES];
}

//创建search
//- (void)createSearchBar
//{
//    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(70, 0, 300, 44)];
//    search.delegate = self;
//    search.showsCancelButton = YES;
//    
//    search.placeholder = @"搜索目的地，游记……";
//    [self.navigationController.navigationBar addSubview:search];
//    [search release];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    btn.frame = search.frame;
//    [btn addTarget:self action:@selector(sousuo) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:btn];
//    
//}

//计时器方法
- (void)lunbo
{
    static NSInteger num = 1;
    _page.currentPage = num - 1;
    [_collectionView setContentOffset:CGPointMake(self.view.frame.size.width * num, 0) animated:YES];
    if (_collectionView.contentOffset.x == self.view.frame.size.width * (_flowPicture.count - 1 )) {
        [_collectionView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:NO];
        _page.currentPage = 0;
    }
    num += 1;
    if (num == 5) {
        num = 1;
   
    }
}
- (void)sousuo
{
    ZZHSearchViewController *zzhSearchVC = [[[ZZHSearchViewController alloc] init] autorelease];
    [zzhSearchVC setModalTransitionStyle:0];
    zzhSearchVC.array = _searchArr;
    [self.navigationController pushViewController:zzhSearchVC animated:YES];
}
//上 下拉刷新
- (void)createRefresh
{
    [self.scrollView addLegendHeaderWithRefreshingBlock:^{

        self.url = @"http://api.breadtrip.com/v5/index/?inext_start=";
//        [self.flowPictureArrTemp removeAllObjects];
//        [self.flowPicture removeAllObjects];
////        self.flowPicture =[NSMutableArray array];
//        [self.travelNoteArr removeAllObjects];
////        self.travelNoteArr = [NSMutableArray array];
//        [_page release];
//        _collectionView.dataSource = nil;
//        [_tableView reloadData];
//        _collectionView.alpha = 0;
        [self getDataUP];
    }];
//    _scrollView.footer.hidden = YES;
//    [self.scrollView.header beginRefreshing];
    
    [self.scrollView addLegendFooterWithRefreshingBlock:^{
        [self getDataDOWN];
    }];
//
//    [self.scrollView.footer beginRefreshing];

//    [self.scrollView.footer beginRefreshing];
////    _scrollView.header.hidden = YES;
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
- (void)getDataUP
{
    //通过遍历构造器获得数据
    [ZZHNetworkHandle getDataWithUrl:self.url completion:^(id result) {
//        [self.flowPictureArrTemp removeAllObjects];
//        [self.flowPicture removeAllObjects];
        [self.travelNoteArr removeAllObjects];
//        [_page release];
        
//        NSLog(@"%@", result);
        //获得搜索数组
        //        [self.flowPicture addObject:[_flowPictureArrTemp objectAtIndex:_flowPictureArrTemp.count -
        
//        if ([self.url isEqualToString:@"http://api.breadtrip.com/v5/index/?inext_start="]) {
            self.searchArr = [result objectForKey:@"search_data"];
        
        //获得临时轮播图数组
//        self.flowPictureArrTemp = [[[[result objectForKey:@"elements"] objectAtIndex:0] objectForKey:@"data"] objectAtIndex:0];
////        NSLog(@"%ld", _flowPictureArrTemp.count);
//        [self.flowPicture addObject:[self.flowPictureArrTemp lastObject]];
//            for (NSInteger i = 0; i < _flowPictureArrTemp.count; i++) {
//                [self.flowPicture addObject:[_flowPictureArrTemp objectAtIndex:i]];
//            }
        //获得轮播图数组
        
//        self.flowPicture = self.flowPictureArrTemp;
//            [self.flowPicture addObject:[_flowPictureArrTemp objectAtIndex:0]];

//        NSLog(@"%ld", _flowPicture.count);
//        }
//        [_collectionView reloadData];
        _collectionView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        
        
        //获得游记数组
        NSArray *arr = [result objectForKey:@"elements"];
        for (NSDictionary *dic in arr) {
            NSString *str = [[dic objectForKey:@"type"] stringValue];
            if ([str isEqualToString:@"4"]) {
                [self.travelNoteArr addObject:dic];
            }
        }
        
        //            [self createCollectionView];
        //            [self createTableView];
        _collectionView.alpha = 1;
        _tableView.frame = CGRectMake(0, self.collectionView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height * 25 / 67* self.travelNoteArr.count);
        [_tableView reloadData];
        //        [self createTableView];
        //        _collectionView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height + _tableView.frame.size.height);
        [_HUD removeFromSuperview];
//                 NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scroll:) userInfo:nil repeats:YES];
        self.page.numberOfPages = _flowPicture.count - 2;
        self.page.currentPage = 0;
        self.url = @"http://api.breadtrip.com/v5/index/?next_start=";
        self.url = [self.url stringByAppendingString:[[result objectForKey:@"next_start"] stringValue]];
//        NSLog(@"%@", self.url);
        
        [_scrollView.header endRefreshing];
        [_scrollView.footer endRefreshing];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStyleDone target:self action:@selector(sousuo)];
        
    }];
    
    
}

- (void)getDataDOWN
{
    //通过遍历构造器获得数据
    [ZZHNetworkHandle getDataWithUrl:self.url completion:^(id result) {
        
        
//        NSLog(@"%@", result);
        //获得搜索数组
        //获得临时轮播图数组
        //获得轮播图数组
//        [self.flowPicture addObject:[_flowPictureArrTemp objectAtIndex:_flowPictureArrTemp.count -
        
//        if ([self.url isEqualToString:@"http://api.breadtrip.com/v5/index/?inext_start="]) {
//            self.flowPictureArrTemp = [[[[result objectForKey:@"elements"] objectAtIndex:0] objectForKey:@"data"] objectAtIndex:0];
//            self.searchArr = [result objectForKey:@"search_data"];
//            
//            for (NSInteger i = 0; i < _flowPictureArrTemp.count; i++) {
//                [self.flowPicture addObject:[_flowPictureArrTemp objectAtIndex:i]];
//            }
//            [self.flowPicture addObject:[_flowPictureArrTemp objectAtIndex:0]];
//            [self createPage];
//        }
        
        
        
        //获得游记数组
        NSArray *arr = [result objectForKey:@"elements"];
        for (NSDictionary *dic in arr) {
            NSString *str = [[dic objectForKey:@"type"] stringValue];
            if ([str isEqualToString:@"4"]) {
                [self.travelNoteArr addObject:dic];
            }
        }
        
//            [self createCollectionView];
//            [self createTableView];
        
//        [_collectionView reloadData];
        _tableView.frame = CGRectMake(0, self.collectionView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height * 25 / 67 * self.travelNoteArr.count );
        [_tableView reloadData];
//        [self createTableView];
//        _collectionView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height + _tableView.frame.size.height);
        [_HUD removeFromSuperview];
//         NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scroll:) userInfo:nil repeats:YES];
        self.url = @"http://api.breadtrip.com/v5/index/?next_start=";
        self.url = [self.url stringByAppendingString:[[result objectForKey:@"next_start"] stringValue]];
        NSLog(@"%@", self.url);
        [_scrollView.header endRefreshing];
        [_scrollView.footer endRefreshing];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(sousuo)];

      }];
   

}
//创建ScrollView
- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.showsVerticalScrollIndicator = 0;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    [_scrollView release];
}
//创建tableview
- (void)createTableView
{
    //创建tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.collectionView.frame.size.height, self.view.frame.size.width, 200 * SCREEN_Y) style:UITableViewStylePlain];
    //设置代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //取消分割线
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[ZZHIndexTravelTableViewCell class] forCellReuseIdentifier:@"table"];
    //加入上拉刷新
//    [_scrollView addHeaderWithTarget:self action:@selector(headerRefresh)];
//    //加入下拉刷新
//    [_scrollView addFooterWithTarget:self action:@selector(footerRefresh)];
    //加入主试图
    _tableView.scrollEnabled = NO;
    [self.scrollView addSubview:_tableView];
    [_tableView release];
}
//tableview row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"$@$@$@%ld", self.travelNoteArr.count);
    return self.travelNoteArr.count;
}
//tableviewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHIndexTravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"table" forIndexPath:indexPath];
//    [cell.backgroundImage sd_setImageWithURL:[[[[self.travelNoteArr objectAtIndex:indexPath.row] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"cover_image_default"]];
    ZZHTravel *temp = [[ZZHTravel alloc] initWithDic:[[[self.travelNoteArr objectAtIndex:indexPath.row] objectForKey:@"data"] objectAtIndex:0]];
    cell.travel = temp;
    cell.backgroundColor = [UIColor whiteColor];
    //被点击颜色
//    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
//    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.098 green:0.051 blue:0.116 alpha:1.000];
    
    return cell;
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height * 25 / 67;
}
//tableView点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZZHTravelNoteViewController *travelVC = [[[ZZHTravelNoteViewController alloc] init] autorelease];
    ZZHTravel *temp = [[ZZHTravel alloc] initWithDic:[[[self.travelNoteArr objectAtIndex:indexPath.row] objectForKey:@"data"] objectAtIndex:0]];
    travelVC.str = temp.name;
    travelVC.url = [NSString stringWithFormat:@"http://api.breadtrip.com/trips/%@", temp.id];
    [self.navigationController pushViewController:travelVC animated:YES];
}
//创建collectionView
- (void)createCollectionView
{
    //创建布局信息
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    //滑动方向
    flow.scrollDirection = 1;
    flow.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height / 3 - 17 * SCREEN_Y);
    //间距
    flow.minimumLineSpacing = 0;
    //创建对象
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height - 49* SCREEN_Y) / 3) collectionViewLayout:flow];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    //注册
    [_collectionView registerClass:[ZZHFlowCollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //滑动线消失
    _collectionView.showsHorizontalScrollIndicator = 0;
    //边缘滚动
    _collectionView.bounces = NO;
    [self.scrollView addSubview:_collectionView];
    [self createPage];
    [_collectionView release];
}
//collection item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.flowPicture.count;
}
//collectionCell创建
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHFlowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
//    [imageView sd_setImageWithURL:[self.flowPicture[indexPath.row] objectForKey:@"image_url"]];
//    [cell.contentView addSubview:imageView];
//    [cell.MyImageView sd_setImageWithURL:[self.flowPicture[indexPath.row] objectForKey:@"image_url"]];
    cell.MyImageView.image = [self.flowPicture objectAtIndex:indexPath.row];
    
    return cell;
}
//collection点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    ZZHFlowPictureViewController *flowVC = [[[ZZHFlowPictureViewController alloc] init] autorelease];
//    
//    if (indexPath.row !=4) {
//        
//        flowVC.str = [[_flowPictureArrTemp objectAtIndex:indexPath.row] objectForKey:@"html_url"];
//        [self.navigationController pushViewController:flowVC animated:YES];
//    }
    
    NEOADViewController *adVC= [[[NEOADViewController alloc]init]autorelease];
    [self.navigationController pushViewController:adVC animated:YES];
    
    
}
//创建pageviewController
- (void)createPage
{
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(130 *SCREEN_X, self.collectionView.frame.origin.y + (_collectionView.frame.size.height - 30 *SCREEN_Y)  , 100 *SCREEN_X, 30 *SCREEN_Y)];
    _page.numberOfPages = _flowPictureArrTemp.count;
    [_page addTarget:self action:@selector(page:) forControlEvents:UIControlEventValueChanged];
//    _page.backgroundColor =[UIColor redColor];
    [self.scrollView addSubview:_page];
    [_page release];
}
//点击
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    
    if (scrollView == _collectionView) {
    _page.currentPage = _collectionView.contentOffset.x / self.view.frame.size.width - 1;
    if (_collectionView.contentOffset.x == self.view.frame.size.width * (_flowPictureArrTemp.count + 1)) {
        _collectionView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        _page.currentPage = 0;
    }
    else if (_collectionView.contentOffset.x == 0){
        _collectionView.contentOffset = CGPointMake(self.view.frame.size.width * _flowPictureArrTemp.count, 0);
        _page.currentPage = _flowPictureArrTemp.count;
    }
}
}

- (void)page:(UIPageControl *)page
{
    [_collectionView setContentOffset:CGPointMake((_page.currentPage + 1)* self.view.frame.size.width, 0) animated:YES];
}

//- (void)headerRefresh
//{
//    [_tableView reloadData];
//    [_collectionView reloadData];
//    [_scrollView.header endRefreshing];
//    
//}

#pragma mark - searchBar

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
