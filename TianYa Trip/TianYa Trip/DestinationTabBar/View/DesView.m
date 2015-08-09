//
//  DesView.m
//  TianYa Trip
//
//  Created by BOSSNEO on 15/5/21.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "DesView.h"

@implementation DesView
- (void)dealloc
{
    [_label release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 40)];
        [self addSubview:self.label];
        self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightButton.frame = CGRectMake(SCREEN_WIDTH - 35, 5, 40, 40);
        [_rightButton setImage:[UIImage imageNamed:@"rightArrow"] forState:UIControlStateNormal];
        [self addSubview:self.rightButton];
    }
    return self;
}
-(void)setLabelText:(NSString *)text
{
    _label.text = text;
    _label.alpha = 0.7;
    _label.textColor = [UIColor colorWithWhite:0.298 alpha:1.000];
    _label.shadowColor = [UIColor colorWithWhite:0.298 alpha:1.000];
    _label.shadowOffset = CGSizeMake(0, 1.0);
    
}
@end
