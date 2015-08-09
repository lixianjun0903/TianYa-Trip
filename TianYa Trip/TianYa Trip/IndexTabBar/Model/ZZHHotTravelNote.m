//
//  ZZHHotTravelNote.m
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHHotTravelNote.h"

@implementation ZZHHotTravelNote

- (void)dealloc
{
    [_text release];
    [_photo_info release];
    [_photo release];
    [_local_time release];
    [_city release];
    [super dealloc];
}
@end
