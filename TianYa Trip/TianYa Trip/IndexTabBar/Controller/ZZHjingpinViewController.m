//
//  ZZHjingpinViewController.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/26.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHjingpinViewController.h"
#import "ZZHjingpinTableViewCell.h"
#import "ZZHTravel.h"
#import "ZZHNetworkHandle.h"
#import "ZZHjingpin.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "ZZHTravelNoteViewController.h"
@interface ZZHjingpinViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *travelNoteArr;
@property (nonatomic, retain) NSString *tempStr;
@property (nonatomic, retain) MBProgressHUD *HUD;
@end

@implementation ZZHjingpinViewController

- (void)dealloc
{
    [_tableView release];
    [_str release];
    [_travelNoteArr release];
    [_tempStr release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tempStr = [self.str stringByAppendingString:@"/?start="];
    [self createHUD];
    [self createTableView];
    [self getData];
//    [_tableView addLegendFooterWithRefreshingBlock:^{
//        [self refresh];
//
//    }];
}



- (void)getData
{
    [ZZHNetworkHandle getDataWithUrl:self.str Cookie:@"bt_devid=i_9637109f377c2bf9ef66a5d9fb0029f0516d899027b696161b375dc02483b27dcc2530d0; Hm_lpvt_39ccc5353de4e1969b414e80e516d5a7=1432688767; Hm_lvt_39ccc5353de4e1969b414e80e516d5a7=1432614047,1432640467,1432641053,1432688327; sessionid=c077c014d41566e69d2e79e77fac674d" completion:^(id result) {
//        NSLog(@"%@", result);
        self.travelNoteArr = [NSMutableArray array];
        self.travelNoteArr = [result objectForKey:@"items"];
//        NSLog(@"%@", self.travelNoteArr);
        [_tableView reloadData];
#pragma mark - 判断
        if ([result objectForKey:@"next_start"] != [NSNull null]){
            
        self.str = [NSString stringWithFormat:@"%@%@", self.tempStr, [result objectForKey:@"next_start"]];
            [_tableView addLegendFooterWithRefreshingBlock:^{
                [self refresh];
                
            }];
        }
        if (_travelNoteArr.count == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120 *SCREEN_X, 90 *SCREEN_Y)];
            //            imageView.backgroundColor = [UIColor blackColor];
            imageView.center = self.view.center;
            imageView.image = [UIImage imageNamed:@"noinfo"];
            [self.view addSubview:imageView];
            [imageView release];
            
        }
        
        NSLog(@"%@", self.str);
        [_HUD removeFromSuperview];
        
    }];
}

//创建小菊花
- (void)createHUD
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.dimBackground = YES;
    _HUD.labelText = @"正在加载";
    [_HUD show:YES];
    [_HUD release];
}
- (void)refresh
{
    [ZZHNetworkHandle getDataWithUrl:self.str  completion:^(id result) {
        for (NSDictionary *dic in [result objectForKey:@"items"]) {
            [_travelNoteArr addObject:dic];
        }
        [self.tableView.footer endRefreshing];
        [_tableView reloadData];
        if ([result objectForKey:@"next_start"] != [NSNull null]) {
            self.str = [NSString stringWithFormat:@"%@%@", self.tempStr, [result objectForKey:@"next_start"]];
        }else{
        [self.tableView.footer noticeNoMoreData];
        }
    }];
}
- (void)createTableView
{
    //创建tableview对象
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 *SCREEN_Y) style:UITableViewStylePlain];
    //代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //注册
    [_tableView registerClass:[ZZHjingpinTableViewCell class] forCellReuseIdentifier:@"reuse"];
    //加到主视图
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.separatorStyle = 0;
    [self.view addSubview:_tableView];
    //释放
    [_tableView release];
}
//个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _travelNoteArr.count;
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHjingpinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
//    cell.backgroundColor = [UIColor yellowColor];
    ZZHjingpin *temp = [[ZZHjingpin alloc] initWithDic:[self.travelNoteArr objectAtIndex:indexPath.row]];
    cell.jingpin = temp;
     cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220 * SCREEN_Y;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZZHTravelNoteViewController *zzhTNVC = [[ZZHTravelNoteViewController alloc] init];
    zzhTNVC.url = [NSString stringWithFormat:@"http://api.breadtrip.com/trips/%@", [[_travelNoteArr objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:zzhTNVC animated:YES];
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
