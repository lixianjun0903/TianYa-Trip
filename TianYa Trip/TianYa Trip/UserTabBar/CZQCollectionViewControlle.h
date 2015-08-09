//
//  CZQCollectionViewControlle.h
//  TianYa Trip
//
//  Created by dlios on 15-5-22.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeDelegate <NSObject>

- (void) change:(NSString *)change;

@end

@interface CZQCollectionViewControlle : UIViewController
@property (nonatomic, assign) id<ChangeDelegate>delegate;
@property (nonatomic, retain) NSString *str;
@end
