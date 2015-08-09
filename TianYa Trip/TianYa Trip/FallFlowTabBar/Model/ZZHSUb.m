//
//  ZZHSUb.m
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/30.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHSUb.h"

@implementation ZZHSUb


- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
        self.myDescription = [dic objectForKey:@"description"];
    }
    return self;
}

@end
