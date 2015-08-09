//
//  DesView.h
//  TianYa Trip
//
//  Created by BOSSNEO on 15/5/21.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesView : UICollectionReusableView

@property (nonatomic, retain)UILabel *label;
@property (nonatomic, retain)UIButton *rightButton;

-(instancetype)initWithFrame:(CGRect)frame;
-(void)setLabelText:(NSString *)text;

@end
