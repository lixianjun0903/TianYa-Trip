//
//  ZZHCollectionViewCell.h
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/22.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHCollection.h"
@interface ZZHCollectionViewCell : UICollectionViewCell

//@property (nonatomic, retain) UIScrollView *scroll;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) ZZHCollection *ZZHC;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) BOOL tap;
+ (CGFloat)getHeightWithText:(NSString *)text;
@end
