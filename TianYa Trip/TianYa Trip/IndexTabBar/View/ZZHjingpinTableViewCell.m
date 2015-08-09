//
//  ZZHjingpinTableViewCell.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/27.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHjingpinTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface ZZHjingpinTableViewCell ()
//背景图片
@property (nonatomic, retain) UIImageView *backgroundImage;
//游记名
@property (nonatomic, retain) UILabel *nameLabel;
//时间
@property (nonatomic, retain) UILabel *timeLabel;
//天数
@property (nonatomic, retain) UILabel *dayLabel;
//浏览次数
@property (nonatomic, retain) UILabel *lookLabel;
//国家
@property (nonatomic, retain) UILabel *countryLabel;
//用户
//用户头像
@property (nonatomic, retain) UIImageView *userImageView;
//用户昵称
@property (nonatomic, retain) UILabel *userNameLabel;
@end

@implementation ZZHjingpinTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = [UIColor colorWithRed:0.098 green:0.051 blue:0.116 alpha:1.000];
        
        //背景图片
        self.backgroundImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_backgroundImage];
        _backgroundImage.userInteractionEnabled = YES;
        _backgroundImage.layer.cornerRadius = 5;
        //剪切图片
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImage.clipsToBounds = YES;
        _backgroundImage.backgroundColor = [UIColor yellowColor];
        [_backgroundImage release];
        
        //名字
        self.nameLabel = [[UILabel alloc] init];
        [self.backgroundImage addSubview:_nameLabel];
        _nameLabel.shadowColor = [UIColor blackColor];
        _nameLabel.shadowOffset = CGSizeMake(1, 1);
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _nameLabel.textColor = [UIColor whiteColor];
        [_nameLabel release];
        //时间
        self.timeLabel = [[UILabel alloc] init];
        [self.backgroundImage addSubview:_timeLabel];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont fontWithName:
                           @"Helvetica-Bold" size:13];
        
        [_timeLabel release];
        //天数
        self.dayLabel = [[UILabel alloc] init];
        _dayLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        _dayLabel.textColor = [UIColor whiteColor];
        _dayLabel.shadowColor = [UIColor blackColor];
        _dayLabel.shadowOffset = CGSizeMake(1, 1);
        
        [self.backgroundImage addSubview:_dayLabel];
        
        [_dayLabel release];
        //浏览
        self.lookLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_lookLabel];
        _lookLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
        _lookLabel.textColor = [UIColor whiteColor];
        _lookLabel.shadowColor = [UIColor blackColor];
        _lookLabel.shadowOffset = CGSizeMake(1, 1);
        [_lookLabel release];
        //国家
        self.countryLabel = [[UILabel alloc] init];
        [self.backgroundImage addSubview:_countryLabel];
        _countryLabel.textColor = [UIColor whiteColor];
        _countryLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];;
        
        [_countryLabel release];
        
        //用户
        //用户头像
        self.userImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_userImageView];
        [_userImageView release];
        //用户名
        self.userNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_userImageView];
        [self.userNameLabel release];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], NSFontAttributeName, nil];
    CGSize size = CGSizeMake(335 * self.contentView.frame.size.width / 375, 500);
    CGRect rect = [_nameLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//    NSLog(@"%f", rect.size.height);
    _backgroundImage.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 20, self.contentView.frame.size.height - 10);
    _nameLabel.frame = CGRectMake(15, 10, 335 * self.contentView.frame.size.width / 375, rect.size.height);
    _timeLabel.frame = CGRectMake(15, rect.size.height + 5, 100 *SCREEN_X, 30);
    _dayLabel.frame = CGRectMake(15, rect.size.height + 5, 50 *SCREEN_X, 30);
//    _countryLabel.frame = CGRectMake(15, rect.size.height + 20, 150, 30);
    _lookLabel.frame = CGRectMake(15, 180 *SCREEN_Y, 200 *SCREEN_X, 30);
}


- (void)setJingpin:(ZZHjingpin *)jingpin
{
    if (_jingpin != nil) {
        [_jingpin release];
        _jingpin = [jingpin retain];
    }
    [_backgroundImage sd_setImageWithURL:[NSURL URLWithString:jingpin.cover_image] placeholderImage:[UIImage imageNamed:@"占位图"]];
    _nameLabel.text = jingpin.name;
//    _timeLabel.text = [NSString stringWithFormat:@"%@", jingpin.first_day];
    _dayLabel.text = [NSString stringWithFormat:@"%@天", jingpin.day_count];
    _lookLabel.text = [NSString stringWithFormat:@"%@足迹  %@喜欢", jingpin.waypoints, jingpin.recommendations];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
