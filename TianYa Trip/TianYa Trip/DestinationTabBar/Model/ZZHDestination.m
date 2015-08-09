//
//  ZZHDestination.m
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHDestination.h"

@implementation ZZHDestination

- (void)dealloc
{
    [_title release];
    [_index release];
    [_more release];
    [_dataArr release];
    [super dealloc];
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        self.dataArr = [dic objectForKey:@"data"];//
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
