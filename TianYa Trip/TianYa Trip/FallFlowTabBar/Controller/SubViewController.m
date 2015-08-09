//
//  SubViewController.m
//  TianYa Trip
//
//  Created by BOSSNEO on 15/5/30.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "SubViewController.h"
#import "ZZHSUb.h"
#import "ZZHFallCollectionViewController.h"
#import "ZZHsubTableViewCell.h"
@interface SubViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UIImageView *myImageView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) CGFloat kImageOriginHight;
@property (nonatomic, retain) MBProgressHUD *HUD;
@end

@implementation SubViewController
- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_myImageView release];
    [_tableView release];
    [_HUD release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", self.webURL);
    self.arr = [NSMutableArray array];
    self.kImageOriginHight = 250 *SCREEN_Y;
    [self createTableView];
    [self createImageView];
    [self getData];
    [self createHUD];
    
}


- (void)createHUD
{
//    self.HUD= [[MBProgressHUD alloc] initWithView:self.view];
//    _HUD.dimBackground = YES;
//    _HUD.labelText = @"正在加载中";
//    [self.view addSubview:_HUD];
//    [_HUD show:YES];
//    [_HUD release];
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
- (void)getData
{
    [NetworkHandle getDataWithHttpsURL:self.webURL completion:^(id result) {
        self.arr = [result objectForKey:@"article_sections"];
        [self.arr removeLastObject];
        for (NSInteger i = 0 ; i < self.arr.count; i ++ ) {
            if ([[[self.arr objectAtIndex:i] objectForKey:@"description"]  isEqual: @""] && [[[self.arr objectAtIndex:i] objectForKey:@"image_url"]  isEqual: @""]) {
                [self.arr removeObject:[self.arr objectAtIndex:i]];
            }
        }
//        NSLog(@"%@", _arr);
        [_myImageView sd_setImageWithURL:[result objectForKey:@"image_url"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [_tableView reloadData];
        [_HUD removeFromSuperview];
    }];
}

- (void)createImageView
{
    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, - self.kImageOriginHight - 60 *SCREEN_Y,  self.tableView.frame.size.width, self.kImageOriginHight + 60 *SCREEN_Y)];
//    _myImageView.backgroundColor = [UIColor redColor];
//    _myImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView addSubview:_myImageView];
    [_myImageView release];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    //代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //注册
    [_tableView registerClass:[ZZHsubTableViewCell class] forCellReuseIdentifier:@"reuse"];
    self.tableView.contentInset = UIEdgeInsetsMake(self.kImageOriginHight, 0, 0, 0);
    _tableView.separatorStyle = 0;
    //加到主视图
    [self.view addSubview:_tableView];
    [_tableView release];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHsubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    ZZHSUb *zzhsub = [[ZZHSUb alloc] initWithDic:[_arr objectAtIndex:indexPath.row]];
    cell.sub = zzhsub;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZHSUb *zzhsub = [[ZZHSUb alloc] initWithDic:[_arr objectAtIndex:indexPath.row]];
    CGFloat fImage = 0;
    if ([zzhsub.image_width integerValue] != 0 && [zzhsub.image_height integerValue] != 0 && ![zzhsub.image_url isEqualToString:@""]) {
        
        fImage = (CGFloat)[zzhsub.image_height floatValue] / [zzhsub.image_width floatValue] *  self.view.frame.size.width - 20;
    }
    
    return fImage + [ZZHsubTableViewCell getHeightWithText:zzhsub.myDescription] + 20;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZZHFallCollectionViewController *zzhfall = [[ZZHFallCollectionViewController alloc] init];
//    ZZHSUb *zzhsub = [[ZZHSUb alloc] initWithDic:[_arr objectAtIndex:indexPath.row]];
//    zzhfall.sub = zzhsub;
    zzhfall.array = _arr;
    NSInteger index = indexPath.row;
    zzhfall.indexTemp = index;
    [self.navigationController pushViewController:zzhfall animated:YES];
    
    
}
//下拉放大
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    static NSInteger i = 0;
    //    if ((i = (scrollView.contentOffset.y + 60) / 3)) {
    //        self.navigationController.navigationBar.alpha = 0.1 * i ;
    //    }
    
    CGFloat yOffset  = scrollView.contentOffset.y;
//    NSLog(@"yOffset===%f",yOffset);
    CGFloat xOffset = (yOffset + self.kImageOriginHight)/2;
    if (yOffset < -self.kImageOriginHight) {
        CGRect f = self.myImageView.frame;
        f.origin.y = yOffset - 60 *SCREEN_Y ;
        f.size.height =  -yOffset + 60 *SCREEN_Y;
        f.origin.x = xOffset;
        f.size.width = self.view.frame.size.width + fabsf(xOffset)*2;
        self.myImageView.frame = f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
