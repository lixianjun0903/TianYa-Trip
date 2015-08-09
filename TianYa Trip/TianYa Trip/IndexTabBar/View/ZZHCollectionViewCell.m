//
//  ZZHCollectionViewCell.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/22.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface ZZHCollectionViewCell ()
//@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, retain) NSDictionary *photo_info;
//@property (nonatomic, retain) UITextView *textView;
@end
@implementation ZZHCollectionViewCell

- (void)dealloc
{
    [_label release];
    [_view release];
    [_photo_info release];
    [_textView release];
    [_timeLabel release];
    [_imageView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        
        
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//        [self addGestureRecognizer:tap];
//        [tap release];
        
        
        //创建遮盖的视图
        self.view = [[UIView alloc] init];
        [self.contentView addSubview:_view];
        _view.backgroundColor = [UIColor blackColor];
        _view.alpha = 0.8;
        [_view release];
        
        //    //创建放置 text  timelabel 的滚动视图
//        self.scroll = [[UIScrollView alloc] init];
//        [self.view addSubview:_scroll];
////        _scroll.backgroundColor = [UIColor blueColor];
//            _scroll.backgroundColor = [UIColor blackColor];
////        _scroll.alpha = 0.5;
//        //text自适应高度
//     
//        //创建text label
//        self.label = [[UILabel alloc] init];
//        _label.numberOfLines = 0;
//        _label.textAlignment = NSTextAlignmentLeft;
//        _label.font = [UIFont systemFontOfSize:13];
//        _label.textColor = [UIColor whiteColor];
////        _label.backgroundColor = [UIColor grayColor];
//        [_scroll addSubview:_label];
        
        self.textView = [[UITextView alloc] init];
        [self.contentView addSubview:_textView];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.alpha = 0.8;
        _textView.editable = NO;
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.textColor = [UIColor whiteColor];
        [_textView release];
       
        //创建时间和地点label
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor blackColor];
//        _timeLabel.text = [NSString stringWithFormat:@"%@ %@", [[[[[_arr objectAtIndex:indexPath.section] objectForKey:@"waypoints"] objectAtIndex:indexPath.row] objectForKey:@"poi"] objectForKey:@"timezone"], [[[[_arr objectAtIndex:indexPath.section] objectForKey:@"waypoints"] objectAtIndex:indexPath.row] objectForKey:@"local_time"]];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel release];
//        [_scroll release];
        
        
    }
    return self;
}

//手势方法

+ (CGFloat)getHeightWithText:(NSString *)text
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, nil];
    CGSize size = CGSizeMake(SCREEN_WIDTH - 20 * SCREEN_X, 1000);
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}



- (void)setZZHC:(ZZHCollection *)ZZHC
{
    if (_ZZHC != ZZHC) {
        [_ZZHC release];
        _ZZHC = [ZZHC retain];
    }
    self.textView.text = ZZHC.text;
    if (ZZHC.timezone) {
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@  %@", ZZHC.timezone, ZZHC.local_time];
    }else{
        self.timeLabel.text = ZZHC.local_time;
    }
//    self.photo_info = [NSDictionary dictionary];
//    self.photo_info = ZZHC.photo_info;
    
    NSLog(@"%@", ZZHC.photo_info);

//    CGFloat fImage = [[ZZHC.photo_info objectForKey:@"h"] floatValue] / (CGFloat)[[ZZHC.photo_info objectForKey:@"w"] floatValue] * self.view.frame.size.width * SCREEN_Y;
    CGFloat f = [[self class] getHeightWithText:_label.text];

    self.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, f);
    
//    NSLog(@"f1 = !!!%f", fImage);
    NSLog(@"%f", [[self.photo_info objectForKey:@"h"] integerValue] / (CGFloat)[[self.photo_info objectForKey:@"w"] integerValue]);
    
    //图片frame
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:ZZHC.photo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    CGFloat fImage = [[_ZZHC.photo_info objectForKey:@"h"] integerValue] / (CGFloat)[[_ZZHC.photo_info objectForKey:@"w"] integerValue] * self.view.frame.size.width * SCREEN_Y;
    self.imageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, fImage);
    _imageView.center = self.contentView.center;
    //放置text的滚动视图
    //label放置的view

//    self.scroll.frame = CGRectMake(0, 490 *SCREEN_Y, self.contentView.frame.size.width, 120 *SCREEN_Y);
//    //自适应高度
//    self.label.frame = CGRectMake(10 *SCREEN_X, 0, _scroll.frame.size.width - 20 *SCREEN_X, f);
//    //可滑动大小
//    _scroll.contentSize = CGSizeMake(self.contentView.frame.size.width - 20 *SCREEN_X, _label.frame.size.height);
    self.textView.frame = CGRectMake(0, 500 *SCREEN_Y, self.contentView.frame.size.width, 120 *SCREEN_Y);
    
    self.timeLabel.frame = CGRectMake(0, self.textView.frame.size.height + _textView.frame.origin.y, self.contentView.frame.size.width, 44 *SCREEN_Y);
    
//    if (self.tap) {
//        _textView.hidden = YES;
//        _timeLabel.hidden = YES;
//    }else{
//        _textView.hidden = NO;
//        _timeLabel.hidden = NO;
//    }
}


@end
