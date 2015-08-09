//
//  ZZHsousuoViewController.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/28.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHsousuoViewController.h"
#import "ZZHNetworkHandle.h"
#import "ZZHAllSights.h"
#import "ZZHAllSightsTableViewCell.h"
#import "ZZHTravelDetailViewController.h"
#import "ZZHTravelNoteViewController.h"
@interface ZZHsousuoViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITableView *tableViewPlace;
@property (nonatomic, retain) NSMutableArray *placeArr;
@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) MBProgressHUD *hud;

@property (nonatomic, retain) UIImageView *imageView;
@end

@implementation ZZHsousuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.placeArr = [NSMutableArray array];
    self.array = [NSMutableArray array];
    NSLog(@"%@", self.url);
    [self createHUD];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120 *SCREEN_X, 90 *SCREEN_Y)];
    //                imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_imageView];
    _imageView.image = [UIImage imageNamed:@"noinfo"];
//    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.center = self.view.center;
    [_imageView release];
    [self.view bringSubviewToFront:_imageView];
//    if ([self.url containsString:@"哈"]) {
//        self.url = @"http://api.breadtrip.com/search/?key=中国&start=0";
//    }
    
    
    
    [self createTableView];
    [self getData];
//    [self createSearch];
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
    //@"http://api.breadtrip.com/search/?key=中国&start=0"
    //Cookie:@"bt_devid=i_9637109f377c2bf9ef66a5d9fb0029f0516d899027b696161b375dc02483b27dcc2530d0; Hm_lvt_39ccc5353de4e1969b414e80e516d5a7=1432640467,1432641053,1432688327,1432719710; sessionid=c077c014d41566e69d2e79e77fac674d"
    if (![self.url isEqualToString:@"http://api.breadtrip.com/search/?key="]) {
    [ZZHNetworkHandle getDataWithUrl:self.url Cookie:@"bt_devid=i_9637109f377c2bf9ef66a5d9fb0029f0516d899027b696161b375dc02483b27dcc2530d0; Hm_lvt_39ccc5353de4e1969b414e80e516d5a7=1432640467,1432641053,1432688327,1432719710; sessionid=c077c014d41566e69d2e79e77fac674d" completion:^(id result) {
//        NSLog(@"%@", [result objectForKey:@"places"]);
        [self.view bringSubviewToFront:_imageView];
        if ([[result objectForKey:@"places"] count] > 0) {
            [self.view sendSubviewToBack:_imageView];
            self.placeArr = [result objectForKey:@"places"];
            NSLog(@"!!!!!%ld", (unsigned long)_placeArr.count);
            self.array = [result objectForKey:@"trips"];
            [_tableViewPlace reloadData];
//            [_tableView reloadData];
//            [self createTableView];
            if (_array.count == 0) {
                [self.view bringSubviewToFront:_imageView];
            }
           
            NSLog(@"@!@!%@", self.placeArr);
        }else{
            [_placeArr removeAllObjects];
            [_tableViewPlace reloadData];
            [self.view bringSubviewToFront:_imageView];
//            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120 *SCREEN_X, 90 *SCREEN_Y)];
//            //                imageView.backgroundColor = [UIColor blackColor];
//            [self.view addSubview:_imageView];
//            _imageView.image = [UIImage imageNamed:@"noinfo"];
//            _imageView.center = self.view.center;
//            [_imageView release];
//            [self.view bringSubviewToFront:_imageView];
        }
        [_hud removeFromSuperview];
    }];
    }else{
        [self.view bringSubviewToFront:_imageView];
    }
}

//- (void)getDatathen
//{
//    //@"http://api.breadtrip.com/search/?key=中国&start=0"
//    [ZZHNetworkHandle getDataWithUrl:self.url Cookie:@"bt_devid=i_9637109f377c2bf9ef66a5d9fb0029f0516d899027b696161b375dc02483b27dcc2530d0; Hm_lvt_39ccc5353de4e1969b414e80e516d5a7=1432640467,1432641053,1432688327,1432719710; sessionid=c077c014d41566e69d2e79e77fac674d" completion:^(id result) {
//        //        NSLog(@"%@", [result objectForKey:@"places"]);
//        if ((NSArray *)[[result objectForKey:@"trips"] count] > 0 || [[result objectForKey:@"places"] count] > 0) {
//            [self.view sendSubviewToBack:_imageView];
//            self.placeArr = [result objectForKey:@"places"];
//            self.array = [result objectForKey:@"trips"];
//            [_tableView reloadData];
//            [_tableViewPlace reloadData];
//          
//            
//            NSLog(@"@!@!%@", self.array);
//        }else{
//            [_array removeAllObjects];
//            [_placeArr removeAllObjects];
//            
////            self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120 *SCREEN_X, 90 *SCREEN_Y)];
////            //                imageView.backgroundColor = [UIColor blackColor];
////            [self.view addSubview:_imageView];
////            _imageView.image = [UIImage imageNamed:@"noinfo"];
////            _imageView.center = self.view.center;
////            [_imageView release];
//            [self.view bringSubviewToFront:_imageView];
//        }
//        
//    }];
//}

-(void)viewWillAppear:(BOOL)animated
{
    [self createSearch];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_searchBar removeFromSuperview];
}


- (void)createTableView
{
    self.tableViewPlace = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    _tableViewPlace.delegate = self;
    _tableViewPlace.dataSource  = self;
    _tableViewPlace.separatorStyle = 0;
    _tableViewPlace.rowHeight = 80 * SCREEN_Y;
//    self.tableView.tableHeaderView = _tableViewPlace;
    [self.view addSubview:_tableViewPlace];
    [_tableViewPlace release];
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.rowHeight = 150;
//    _tableView.separatorStyle = 0;
////    [self.view addSubview:_tableView];
//    _tableViewPlace.tableFooterView = _tableView;
//    [_tableView release];
    
//    _tableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50 *SCREEN_Y * 9);
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == _tableView) {
//        if (_array.count == 0) {
//            return 0;
//        }else{
//        return _array.count;
//        }
//    }else{
//        if (_placeArr.count == 0) {
//            return 0;
//        }else{
////        NSLog(@"15435431634643");
//        return (unsigned long)_placeArr.count;
//        }
        if (_array.count == 0 || _placeArr.count == 0) {
            
            
            return 0;
            
            
        }else{
            
            
            return _placeArr.count;
        }
        
        
        
//        if (_array.count == 0) {
//            return 0;
//        }else{
//            if (_placeArr.count == 0) {
//                            return 0;
//                        }else{
//                //        NSLog(@"15435431634643");
//                        return (unsigned long)_placeArr.count;
//                        
//                        }}
//    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if ([tableView isEqual: _tableView]) {
//        ZZHAllSightsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
//        if (!cell) {
//            cell = [[ZZHAllSightsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuse"];
//        };
////        NSLog(@"as");
//        
//        ZZHAllSights *zzh = [[ZZHAllSights alloc] initWithDic:[_array objectAtIndex:indexPath.row]];
//        cell.zzhAll = zzh;
//        [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:[[_array objectAtIndex:indexPath.row] objectForKey:@"cover_image"]]];
//        return cell;
//}else if ([tableView isEqual: _tableViewPlace]) {
        UITableViewCell *placeCell = [tableView dequeueReusableCellWithIdentifier:@"place"];
        if (!placeCell) {
            placeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"place"];
        }
        placeCell.textLabel.text = [[_placeArr objectAtIndex:indexPath.row] objectForKey:@"name"];
        
            
    
            
        
        if ([[_placeArr objectAtIndex:indexPath.row] objectForKey:@"city"] != [NSNull null] && [[_placeArr objectAtIndex:indexPath.row] objectForKey:@"country"] != [NSNull null]) {
            if ([[_placeArr objectAtIndex:indexPath.row] objectForKey:@"city"] != nil && [[_placeArr objectAtIndex:indexPath.row] objectForKey:@"country"] != nil) {
                
                placeCell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@", [[[_placeArr objectAtIndex:indexPath.row] objectForKey:@"country"] objectForKey:@"name"], [[[_placeArr objectAtIndex:indexPath.row] objectForKey:@"city"] objectForKey:@"name"]];
            }else if ([[_placeArr objectAtIndex:indexPath.row] objectForKey:@"city"] == nil && [[_placeArr objectAtIndex:indexPath.row] objectForKey:@"country"] != nil){
                placeCell.detailTextLabel.text = [[[_placeArr objectAtIndex:indexPath.row] objectForKey:@"country"] objectForKey:@"name"];
                //            [placeCell.imageView  sd_setImageWithURL:[[[_placeArr objectAtIndex:indexPath.row] objectForKey:@"city"] objectForKey:@"icon"]];
            }else
            {
                //            [placeCell.imageView  sd_setImageWithURL:[[[_placeArr objectAtIndex:indexPath.row] objectForKey:@"country"] objectForKey:@"icon"]];
                
                placeCell.detailTextLabel.text = @"";
            }

//            [placeCell.imageView  sd_setImageWithURL:[[_placeArr objectAtIndex:indexPath.row] objectForKey:@"icon"]];
        }
//        NSLog(@"%@", placeCell.textLabel.text);
        return placeCell;
    
//else{
//        return nil;
//    }

}
//增加searchBar
- (void)createSearch
{
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    //    [self.view addSubview:view];
    //    view.backgroundColor = [UIColor blackColor];
    //    [view release];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(80 * self.view.frame.size.width / 375, 0, 300 * self.view.frame.size.width / 375, 44)];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    _searchBar.tintColor = [UIColor grayColor];
    _searchBar.text = self.str;
    _searchBar.placeholder = @"搜索目的地……";
    [self.navigationController.navigationBar addSubview:_searchBar];
    [_searchBar release];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    NSString *str = [[[NSString alloc] init] autorelease];
    if ([_searchBar.text isEqualToString:@"哈哈"] || [_searchBar.text isEqualToString:@"哈"]) {
        str = @"哈尔滨";
    }else{
        str = _searchBar.text;
    }
//    self.url = [@"http://api.breadtrip.com/search/?key=" stringByAppendingString:_searchBar.text];
    NSString *utf = str;
    NSLog(@"******%@", utf);
    utf = [utf stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~<>$€^•'.!/@#$%^&*()_+'\""];
    utf = [[utf componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    self.url = [@"http://api.breadtrip.com/search/?key=" stringByAppendingString:utf];
    [self getData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableViewPlace) {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZZHTravelDetailViewController *zzhTDVC = [[ZZHTravelDetailViewController alloc] init];
    NSString *str = @"http://api.breadtrip.com/destination/place/";
    zzhTDVC.url = [NSString stringWithFormat:@"%@/%@/%@", str, [[_placeArr objectAtIndex:indexPath.row] objectForKey:@"type"], [[_placeArr objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    [self.navigationController pushViewController:zzhTDVC animated:YES];
    }
    if (tableView == _tableView) {
        ZZHTravelNoteViewController *zzhTNVC = [[ZZHTravelNoteViewController alloc] init];
        zzhTNVC.url = [NSString stringWithFormat:@"http://api.breadtrip.com/trips/%@", [[_array objectAtIndex:indexPath.row] objectForKey:@"id"]];
        [self.navigationController pushViewController:zzhTNVC animated:YES];
    }
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
