//
//  ZZHCityOrSignsViewController.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/27.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHCityOrSignsViewController.h"
#import "ZZHNetworkHandle.h"
#import "ZZHPhotoCollectionViewCell.h"
#import "ZZHTravelDetailViewController.h"
#import "ZZHAllSightsTableViewCell.h"
#import "ZZHAllSights.h"
@interface ZZHCityOrSignsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) NSMutableArray *array1;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSString *temp;
@property (nonatomic, retain) NSString *temp1;
@property (nonatomic, retain) MBProgressHUD *hud;
@end

@implementation ZZHCityOrSignsViewController

- (void)dealloc
{
    [_array release];
    [_array1 release];
    [_collectionView release];
    [_tableView release];
    [_temp release];
    [_temp1 release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.temp = [self.str1 stringByAppendingString:@"/?start="];
    self.temp1 = [self.str2 stringByAppendingString:@"start="];
    NSLog(@"%@", self.str1);
    
//    [self createCollectionView];
    [self createTableView];
    [self createHUD];
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

- (void)refresh
{
//    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        NSLog(@"%@", self.str1);
//        if (self.array) {
//            [ZZHNetworkHandle getDataWithUrl:self.str1 completion:^(id result) {
//                for (NSDictionary *dic in [result objectForKey:@"items"]) {
//                    [self.array addObject:dic];
//                }
//                [_collectionView reloadData];
//                if (![[[result objectForKey:@"next_start"] stringValue] isEqualToString:@"null"]) {
//                    self.str1 = [self.temp stringByAppendingString:[[result objectForKey:@"next_start"] stringValue]];
//                }
//                [self.collectionView.footer endRefreshing];
//                
//            }];
//        }
//        if (self.array1) {
            [self.tableView addLegendFooterWithRefreshingBlock:^{
                
                [ZZHNetworkHandle getDataWithUrl:self.str2 completion:^(id result) {
                    for (NSDictionary *dic in [result objectForKey:@"items"]) {
                        [self.array1 addObject:dic];
                    }
                    [_tableView reloadData];
                    if ([result objectForKey:@"next_start"] != [NSNull null]) {
                        self.str1 = [NSString stringWithFormat:@"%@%@", self.temp1, [result objectForKey:@"next_start"]];
                       
                    }
                    [self.tableView.footer endRefreshing];
                    NSLog(@"aaa");
                }];
            }];
//        }
        
//    }];
}

- (void)getData
{
    NSLog(@"%@", self.str2);
//    [ZZHNetworkHandle getDataWithUrl:self.str1 Cookie:@"" completion:^(id result) {
//        self.array = [NSMutableArray array];
//        self.array = [result objectForKey:@"items"];
//        [_collectionView reloadData];
//        if (![[[result objectForKey:@"next_start"] stringValue] isEqualToString:@"null"]){
//        self.str1 = [self.temp stringByAppendingString:[[result objectForKey:@"next_start"] stringValue]];
//        }
//    } error:^(id error1) {
    
        [ZZHNetworkHandle getDataWithUrl:self.str2 Cookie:@"" completion:^(id result) {
            NSLog(@"DASDASD");
            self.array1 = [NSMutableArray array];
            self.array1 = [result objectForKey:@"items"];
//            NSLog(@"%ld", self.array1.count);
            [_tableView reloadData];
            
            if ([result objectForKey:@"next_start"] != [NSNull null]){
                //            self.str2 = [self.temp1 stringByAppendingString:[[result objectForKey:@"next_start"] stringValue]];
                self.str2 = [NSString stringWithFormat:@"%@%@", self.temp1, [result objectForKey:@"next_start"]];
                [self refresh];
            }
            if (_array1.count == 0) {
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120 *SCREEN_X, 90 *SCREEN_Y)];
                //                imageView.backgroundColor = [UIColor blackColor];
                [self.view addSubview:imageView];
                imageView.image = [UIImage imageNamed:@"noinfo"];
                imageView.center = self.view.center;
                [imageView release];
            }
            
            [_hud removeFromSuperview];
        
        } error:^(id error1) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120 *SCREEN_X, 90 *SCREEN_Y)];
            //            imageView.backgroundColor = [UIColor blackColor];
            imageView.center = self.view.center;
            imageView.image = [UIImage imageNamed:@"noinfo"];
            [self.view addSubview:imageView];
            [imageView release];
            [_hud removeFromSuperview];
        }];
//
//    }];
    
    
    
}
//创建集合视图
- (void)createCollectionView
{
    UICollectionViewFlowLayout *flow = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    flow.minimumInteritemSpacing = 5 *SCREEN_Y;
    flow.minimumLineSpacing = 5* SCREEN_X;
    flow.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - 10 *SCREEN_X, SCREEN_WIDTH / 2 - 10 *SCREEN_X);
        flow.sectionInset = UIEdgeInsetsMake(0, 7 * SCREEN_X, 0, 7 * SCREEN_X);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.contentInset = UIEdgeInsetsMake(0, 7 *SCREEN_X, 0, 7*SCREEN_X);
    [_collectionView registerClass:[ZZHPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    [self.view addSubview:_collectionView];
    [_collectionView release];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    [cell.MyImageView sd_setImageWithURL:[NSURL URLWithString:[[_array objectAtIndex:indexPath.row] objectForKey:@"cover"]]];
    cell.label.text = [[_array objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHTravelDetailViewController *zzhTDVC = [[ZZHTravelDetailViewController alloc] init];
    NSString *str = @"http://api.breadtrip.com/destination/place/";
    zzhTDVC.url = [NSString stringWithFormat:@"%@/%@/%@", str, [[_array objectAtIndex:indexPath.row] objectForKey:@"type"], [[_array objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    [self.navigationController pushViewController:zzhTDVC animated:YES];
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    [_tableView registerClass:[ZZHAllSightsTableViewCell class] forCellReuseIdentifier:@"reuse"];
    [self.view addSubview:_tableView];
    [_tableView release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHAllSightsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
//    cell.textLabel.text = [_array1[indexPath.row] objectForKey:@"name"];
    ZZHAllSights *temp = [[ZZHAllSights alloc] initWithDic:[_array1 objectAtIndex:indexPath.row]];
    cell.zzhAll = temp;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHTravelDetailViewController *zzhTDVC = [[ZZHTravelDetailViewController alloc] init];
    NSString *str = @"http://api.breadtrip.com/destination/place/";
    zzhTDVC.url = [NSString stringWithFormat:@"%@/%@/%@", str, [[_array1 objectAtIndex:indexPath.row] objectForKey:@"type"], [[_array1 objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    [self.navigationController pushViewController:zzhTDVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140 *SCREEN_Y;
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
