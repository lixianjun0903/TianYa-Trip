//
//  ZZHsubTableViewCell.h
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/30.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHSUb.h"
@interface ZZHsubTableViewCell : UITableViewCell


@property (nonatomic, retain) ZZHSUb *sub;


+ (CGFloat)getHeightWithText:(NSString *)text;
@end
