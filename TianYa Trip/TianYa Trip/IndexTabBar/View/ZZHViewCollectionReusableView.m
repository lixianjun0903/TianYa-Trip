//
//  ZZHViewCollectionReusableView.m
//  ShareMusic
//
//  Created by 郑泽辉 on 15/6/10.
//  Copyright (c) 2015年 郑泽辉. All rights reserved.
//

#import "ZZHViewCollectionReusableView.h"

@implementation ZZHViewCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] init];
//        self.label.backgroundColor = [UIColor greenColor];
        _label.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.2];
        _label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = 1;
        [self addSubview:self.label];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame  = CGRectMake(0, 10 *SCREEN_Y, SCREEN_WIDTH, 40 *SCREEN_Y);
}


@end
