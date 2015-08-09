//
//  ZZHSC.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/25.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHSC.h"

@implementation ZZHSC

- (void)dealloc
{
    [_name release];
    [_days release];
    [_url release];
    [_cover_image release];
    [super dealloc];
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.cover_image forKey:@"cover_image"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.cover_image = [aDecoder decodeObjectForKey:@"cover_image"];
    }
    return self;
}
@end
