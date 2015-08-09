//
//  ZZHHotTravelTableViewCell.h
//  TianYa Trip
//
//  Created by dlios on 15-5-16.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHHotTravelNote.h"
@interface ZZHHotTravelTableViewCell : UITableViewCell
@property (nonatomic, retain) ZZHHotTravelNote *HotTravelNote;

+ (CGFloat)getHeightWithText:(NSString *)text;
//+ (CGFloat)getHeightWithImage:(UIImage *)image;
@end
