//
//  ZZHSearchViewController.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/18.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHSearchViewController.h"
#import "ZZHTravelDetailViewController.h"
#import "ZZHsousuoViewController.h"
#import "ZZHViewCollectionReusableView.h"
@interface ZZHSearchViewController ()<UISearchBarDelegate, UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, retain)UISearchBar *searchBar;
@property (nonatomic, retain) UICollectionView *chinaCollectionView;
@property (nonatomic, retain) UICollectionView *foreignCollectionView;
@property (nonatomic, retain) NSArray *chinaArr;
@property (nonatomic, retain) NSArray *foreignArr;
@end

@implementation ZZHSearchViewController

- (void)dealloc
{
    _chinaCollectionView.dataSource = nil;
    _foreignCollectionView.dataSource = nil;
    [_searchBar release];
    [_chinaCollectionView release];
    [_foreignCollectionView release];
    [_chinaArr release];
    [_foreignArr release];
    [super dealloc];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self createSearch];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [self getData];
//    [self createView];
    [self createCollectionView];
    
}
//视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [self createSearch];
    //让searchBar成为第一响应者
    [_searchBar becomeFirstResponder];
}
//视图将要消失
- (void)viewDidDisappear:(BOOL)animated
{
    [_searchBar removeFromSuperview];
}
//点击view让searchBar失去第一响应者
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}
//获取数据
- (void)getData
{
    self.chinaArr = [NSArray array];
    self.chinaArr = @[[[self.array lastObject] objectForKey:@"elements"], [[_array objectAtIndex:0] objectForKey:@"elements"]];
//    self.foreignArr = [NSArray array];
//    self.foreignArr = [[_array objectAtIndex:0] objectForKey:@"elements"];
    
    
}
- (void)back
{
    [_searchBar removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


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
//    _searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _searchBar.placeholder = @"搜索目的地……";
    [self.navigationController.navigationBar addSubview:_searchBar];
    [_searchBar release];
}
//取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}
- (void)createView
{
    UILabel *chinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40 * SCREEN_Y)];
    [self.view addSubview:chinaLabel];
    chinaLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.2];
    chinaLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    chinaLabel.text = @"国内热门目的地";
    chinaLabel.textColor = [UIColor whiteColor];
    chinaLabel.textAlignment = 1;
    chinaLabel.backgroundColor = [UIColor grayColor];
    [chinaLabel release];
    
    UILabel *foreignLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 290 * SCREEN_Y, SCREEN_WIDTH, 40 * SCREEN_Y)];
    foreignLabel.text = @"国外热门目的地";
    foreignLabel.backgroundColor =[UIColor colorWithWhite:0.000 alpha:0.2];
    foreignLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    foreignLabel.textColor = [UIColor whiteColor];
    foreignLabel.textAlignment = 1;
    [self.view addSubview:foreignLabel];
    [foreignLabel release];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    ZZHsousuoViewController *ZZHsousuo = [[ZZHsousuoViewController alloc] init];
    NSString *str = [[[NSString alloc] init] autorelease];
    if ([_searchBar.text isEqualToString:@"哈哈"] || [_searchBar.text isEqualToString:@"哈"]) {
        str = @"哈尔滨";
    }else{
        str = _searchBar.text;
    }
    NSString *utf = str;
    NSLog(@"******%@", utf);
    utf = [utf stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~<>$€^•'.!/@#$%^&*()_+'\""];
    utf = [[utf componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    ZZHsousuo.url = [@"http://api.breadtrip.com/search/?key=" stringByAppendingString:utf];
//    ZZHsousuo.url = [@"http://api.breadtrip.com/search/?key=" stringByAppendingString:_searchBar.text];
    ZZHsousuo.str = _searchBar.text;
    [self.navigationController pushViewController:ZZHsousuo animated:YES];
}
- (void)createCollectionView
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    
        flow.itemSize = CGSizeMake(90 * self.view.frame.size.width/ 375, 30 * self.view.frame.size.height / 667);
    flow.sectionInset = UIEdgeInsetsMake(10 *SCREEN_Y, 30 *SCREEN_X, 10 *SCREEN_Y, 30 *SCREEN_X);
        flow.minimumInteritemSpacing = 10 * self.view.frame.size.width / 375;
    flow.minimumLineSpacing = 10 * self.view.frame.size.height/ 667;
    self.chinaCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flow];
    _chinaCollectionView.delegate = self;
    _chinaCollectionView.dataSource = self;
    [self.view addSubview:_chinaCollectionView];
//        _chinaCollectionView.contentInset = UIEdgeInsetsMake(0, 30 *SCREEN_X, 30 *SCREEN_Y, 30 *SCREEN_X);
    [_chinaCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    _chinaCollectionView.backgroundColor = [UIColor whiteColor];
    [_chinaCollectionView registerClass:[ZZHViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuseable"];
    
    

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

        return [[self.chinaArr objectAtIndex:section] count];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (collectionView == _chinaCollectionView) {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor redColor];
        UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.frame];
//        label.text = [[_chinaArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    label.text = [[[self.chinaArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    
        [cell.contentView addSubview:label];
        //边框宽度
        label.layer.borderWidth = 1;
        //锐角
        label.layer.cornerRadius = 10;
        //居中对齐
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithWhite:0.000 alpha:0.520];
        label.layer.backgroundColor = [UIColor colorWithWhite:0.533 alpha:0.1].CGColor;
        //边框颜色
        label.layer.borderColor = [UIColor colorWithWhite:0.500 alpha:0.540].CGColor;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar removeFromSuperview];
    ZZHTravelDetailViewController *zzhTDVC = [[[ZZHTravelDetailViewController alloc] init] autorelease];
    NSString *str = @"http://api.breadtrip.com/destination/place/";

    if (indexPath.section == 0) {
        zzhTDVC.url = [NSString stringWithFormat:@"%@/%@/%@", str, [[[_chinaArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"type"], [[[_chinaArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"id"]];
    }else if (indexPath.section == 1){
        zzhTDVC.url = [NSString stringWithFormat:@"%@/%@/%@", str, [[[_chinaArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"type"], [[[_chinaArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"id"]];
    }

    [self.navigationController pushViewController:zzhTDVC animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ZZHViewCollectionReusableView *reueable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuseable" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        reueable.label.text = @"国内热门目的地";
    }else{
        reueable.label.text = @"国外热门目的地";
    }
    return reueable;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {SCREEN_WIDTH,60 * SCREEN_Y};
    return size;
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
