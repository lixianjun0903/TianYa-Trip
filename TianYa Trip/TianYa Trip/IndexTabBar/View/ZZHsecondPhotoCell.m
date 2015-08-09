//
//  ZZHsecondPhotoCell.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/27.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHsecondPhotoCell.h"

@implementation ZZHsecondPhotoCell

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.MyImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 300 * SCREEN_Y);
    self.MyImageView.center = self.contentView.center;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
