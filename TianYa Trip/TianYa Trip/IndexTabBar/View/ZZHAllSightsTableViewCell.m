//
//  ZZHAllSightsTableViewCell.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/28.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHAllSightsTableViewCell.h"

@interface ZZHAllSightsTableViewCell ()


@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *visitLabel;
@property (nonatomic, retain) UILabel *tips;
@property (nonatomic, retain) UILabel *recommended_reasonLabel;


@end

@implementation ZZHAllSightsTableViewCell

- (void)dealloc
{
    [_coverImageView release];
    [_nameLabel release];
    [_visitLabel release];
    [_tips release];
    [_recommended_reasonLabel release];
    [super dealloc];
}
- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.coverImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.coverImageView];
        _coverImageView.layer.cornerRadius = 5;
        _coverImageView.clipsToBounds = YES;
//        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
//         _coverImageView.backgroundColor =[UIColor redColor];
        [_coverImageView release];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLabel];
       
        [_nameLabel release];
//        _nameLabel.backgroundColor =[UIColor redColor];
        self.recommended_reasonLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_recommended_reasonLabel];
        _recommended_reasonLabel.font = [UIFont systemFontOfSize:14];
        self.recommended_reasonLabel.numberOfLines = 2;
        [_recommended_reasonLabel release];
//         _recommended_reasonLabel.backgroundColor =[UIColor redColor];
        self.visitLabel = [[UILabel alloc] init];
        _visitLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_visitLabel];
        [_visitLabel release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.coverImageView.frame = CGRectMake(20*SCREEN_X, 20*SCREEN_Y, 100*SCREEN_X, 100*SCREEN_Y);
    self.nameLabel.frame = CGRectMake(130 *SCREEN_X, 20 *SCREEN_Y, SCREEN_WIDTH - 150 *SCREEN_X, 30 *SCREEN_Y);
    self.recommended_reasonLabel.frame = CGRectMake(130 *SCREEN_X, 50 *SCREEN_Y, _nameLabel.frame.size.width, 40 * SCREEN_Y);
    self.visitLabel.frame = CGRectMake(130 *SCREEN_X, 90 * SCREEN_Y, _nameLabel.frame.size.width, 30 *SCREEN_Y);
}

- (void)setZzhAll:(ZZHAllSights *)zzhAll
{
    if (_zzhAll != zzhAll) {
        [_zzhAll release];
        _zzhAll = [zzhAll retain];
    }
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:zzhAll.cover] placeholderImage:[UIImage imageNamed:@"占位图"]];
    self.nameLabel.text = zzhAll.name;
    self.recommended_reasonLabel.text  = zzhAll.recommended_reason;
    self.visitLabel.text = [NSString stringWithFormat:@"%@  人去过", zzhAll.visited_count];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
