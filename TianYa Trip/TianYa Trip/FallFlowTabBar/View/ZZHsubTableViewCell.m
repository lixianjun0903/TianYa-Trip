//
//  ZZHsubTableViewCell.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/30.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHsubTableViewCell.h"

@interface ZZHsubTableViewCell ()
@property (nonatomic, retain) UIImageView *myImageView;
@property (nonatomic, retain) UILabel *label;
@end
@implementation ZZHsubTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_myImageView];
        [_myImageView release];
        
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:_label];
        _label.font = [UIFont systemFontOfSize:15];
        _label.numberOfLines = 0;
        [_label release];
        
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}

+ (CGFloat)getHeightWithText:(NSString *)text
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
    CGSize size = CGSizeMake(SCREEN_WIDTH - 20, 1000);
    
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}


-(void)setSub:(ZZHSUb *)sub
{
    if (_sub != sub) {
        [_sub release];
        _sub = [sub retain];
    }

    
    CGFloat fImage = 0;
    if ([_sub.image_width integerValue] != 0 && [_sub.image_height integerValue] != 0 && ![_sub.image_url isEqualToString:@""]) {
        
        fImage = (CGFloat)[_sub.image_height floatValue] / [_sub.image_width floatValue] *  self.contentView.frame.size.width - 20;
    }
    
    NSLog(@"%f", fImage);
    
    
    _myImageView.frame = CGRectMake(10, 0, self.contentView.frame.size.width - 20, fImage);
    _label.frame = CGRectMake(10 , fImage + 10,  self.contentView.frame.size.width - 20, [[self class] getHeightWithText:_sub.myDescription]);
    [_myImageView sd_setImageWithURL:[NSURL URLWithString:sub.image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _label.text = sub.myDescription;
    
    
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
