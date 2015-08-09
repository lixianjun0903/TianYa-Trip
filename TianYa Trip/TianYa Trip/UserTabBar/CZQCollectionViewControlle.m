//
//  CZQCollectionViewControlle.m
//  TianYa Trip
//
//  Created by dlios on 15-5-22.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "CZQCollectionViewControlle.h"
#import "UIImageView+WebCache.h"
#import "ZZHSCTableViewCell.h"
#import "ZZHNetworkHandle.h"
#import "ZZHTravelNoteViewController.h"
#import "ZZHSC.h"
#define WIDTH self.view.frame.size.width / 375
#define HEIGHT self.view.frame.size.height / 667

@interface CZQCollectionViewControlle () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *arr;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) UIImageView *imageView;
@end

@implementation CZQCollectionViewControlle

- (void)dealloc
{
    [_tableView release];
    [_arr release];
    [_HUD release];
    [_imageView release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120 *SCREEN_X, 90 *SCREEN_Y)];
    //                imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_imageView];
    _imageView.image = [UIImage imageNamed:@"noinfo"];
    _imageView.center = self.view.center;
    [_imageView release];
    [self getData];
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
        _imageView.alpha = 0;
        [self createTableView];
        if (_arr.count == 0) {
            _imageView.alpha = 1;
            [self.view bringSubviewToFront:_imageView];
        }
    }
//    self.arr = [@[@"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0", @"0.0"] mutableCopy];
    /**
     背景图片
     */
//    UIImageView *image = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375 * WIDTH, 200 * HEIGHT)] autorelease];
//    //    image.backgroundColor = [UIColor cyanColor];
//    [image sd_setImageWithURL:[NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/6/1/2/2/6122598/200711/21/1195647806148.jpg"]] ;
//    _tableView.tableHeaderView = image;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}
- (void)getData
{
    //获取路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //plist路径
    NSString *plistPath = [[path stringByAppendingPathComponent:@"shoucang"] stringByAppendingPathComponent:@"shoucang1.plist"];
    self.arr = [NSMutableArray array];
    self.arr = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
    NSLog(@"!!!!%@", _arr);

}

#pragma mark -  创建tableView
- (void) createTableView
{
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 70 *SCREEN_Y, 375 * WIDTH, 667 * HEIGHT + 49 * HEIGHT) style:UITableViewStyleGrouped] autorelease];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1000;
    _tableView.rowHeight = 150 * HEIGHT;
    _tableView.bounces = YES;
    [self.view addSubview:_tableView];
    
}
#pragma mark -  控制每个区域显示的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
        
        return _arr.count;
    }else{
        return 10;
    }
}
#pragma mark -  根据行和区确定cell的显示样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *a = @"a";
    ZZHSCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:a];
    if (!cell) {
        cell = [[ZZHSCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:a];
    }
    if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
        
        ZZHSC *zzhsc = [[ZZHSC alloc] init];
        
        zzhsc = [_arr objectAtIndex:indexPath.row];
        cell.zzhsc = zzhsc;
    }
    return cell;
}
#pragma mark - 点击相应方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (_arr.count > 0) {
            
            ZZHTravelNoteViewController *hot = [[ZZHTravelNoteViewController alloc] init];
            ZZHSC *temp = [[ZZHSC alloc] init];
            temp = [_arr objectAtIndex:indexPath.row];
            hot.url = temp.url;
            [self.navigationController pushViewController:hot animated:YES];
        }
    
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    //调用父类
    [super setEditing:editing animated:animated];
    //允许编辑
    [_tableView setEditing:editing animated:animated];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //创建文件管理器
        NSFileManager *manager = [NSFileManager defaultManager];
        //获取路径
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //plist路径
        NSString *plistPath = [[path stringByAppendingPathComponent:@"shoucang"] stringByAppendingPathComponent:@"shoucang1.plist"];
        self.arr = [NSMutableArray array];
        self.arr = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        NSLog(@"!!!!%@", _arr);
        [self.arr removeObjectAtIndex:indexPath.row];
        [NSKeyedArchiver archiveRootObject:self.arr toFile:plistPath];
        [_tableView reloadData];
        if (self.arr.count == 0) {
            _imageView.alpha = 1;
            [self.view bringSubviewToFront:_imageView];
            [manager removeItemAtPath:plistPath error:nil];
        }
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
