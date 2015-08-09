//
//  NEOCountryList.m
//  TianYa Trip
//
//  Created by BOSSNEO on 15/5/23.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "NEOCountryList.h"

@implementation NEOCountryList

- (void)dealloc
{
    [_imgURL release];
    [_name release];
    [_pageID release];
    [_pageType release];
    [super dealloc];
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];

    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(id)valueForKey:(NSString *)key
{
    return nil;
}


@end
