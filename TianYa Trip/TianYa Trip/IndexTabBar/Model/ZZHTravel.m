//
//  ZZHTravel.m
//  TianYa Trip
//
//  Created by dlios on 15-5-15.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHTravel.h"

@implementation ZZHTravel

- (void)dealloc
{
    [_name release];
    [_popular_place_str release];
    [_first_day release];
    [_day_count release];
    [_cover_image release];
    [_user release];
    [_id release];
    [super dealloc];
}
@end
