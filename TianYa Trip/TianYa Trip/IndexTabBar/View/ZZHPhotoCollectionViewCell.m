//
//  ZZHPhotoCollectionViewCell.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/27.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHPhotoCollectionViewCell.h"

@interface ZZHPhotoCollectionViewCell ()


@end
@implementation ZZHPhotoCollectionViewCell

- (void)dealloc
{
    [_MyImageView release];
    [_label release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.MyImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_MyImageView];
        [_MyImageView release];
        
        self.label = [[UILabel alloc] init];
        [self.MyImageView addSubview:_label];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = 1;
//        _label.backgroundColor = [UIColor blackColor];
//        _label.alpha = 0.5;
        [_label release];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.MyImageView.frame = self.contentView.frame;
    self.label.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 40);
  
}
@end
