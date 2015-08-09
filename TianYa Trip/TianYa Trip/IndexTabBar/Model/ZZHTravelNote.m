//
//  ZZHTravelNote.m
//  TianYa Trip
//
//  Created by dlios on 15-5-15.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHTravelNote.h"

@interface ZZHBaseObject ()


@end

@implementation ZZHTravelNote

- (void)dealloc
{
    [_photo release];
    [_text release];
    [_local_time release];
    [_photo_info release];
    [super dealloc];
}



@end
