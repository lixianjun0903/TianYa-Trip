//
//  ZZHFlowCollectionViewCell.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/26.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHFlowCollectionViewCell.h"

@implementation ZZHFlowCollectionViewCell

- (void)dealloc
{
    [_MyImageView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.MyImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_MyImageView];
        [_MyImageView release];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.MyImageView.frame = self.contentView.frame;
}
@end
