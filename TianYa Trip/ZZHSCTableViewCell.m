//
//  ZZHSCTableViewCell.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/25.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHSCTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ZZHSCTableViewCell ()
@property (nonatomic, retain) UIImageView *MyImageView;
@property (nonatomic, retain) UILabel *label;

@end
@implementation ZZHSCTableViewCell


- (void)dealloc
{
    [_MyImageView release];
    [_label release];
    [super dealloc];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.MyImageView = [[UIImageView alloc] init];
        _MyImageView.layer.cornerRadius = 5;
        _MyImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.MyImageView];
        [_MyImageView release];
        
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:_label];
        _label.numberOfLines = 0;
        [_label release];
        
    }
    return  self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.MyImageView.frame = CGRectMake(10 *SCREEN_X, 10 *SCREEN_Y, 130 *SCREEN_X, 130 *SCREEN_Y);
    self.label.frame = CGRectMake(150 * SCREEN_X, 50 * SCREEN_Y, 210 *SCREEN_X, 50 * SCREEN_Y);
}


- (void)setZzhsc:(ZZHSC *)zzhsc
{
    if (_zzhsc != zzhsc) {
        [_zzhsc release];
        _zzhsc = [zzhsc retain];
    }
    [self.MyImageView sd_setImageWithURL:[NSURL URLWithString:zzhsc.cover_image]];
    self.label.text = zzhsc.name;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
