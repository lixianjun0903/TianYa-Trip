//
//  ZZHDestination.h
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHBaseObject.h"

@interface ZZHDestination : ZZHBaseObject

@property(nonatomic, retain)NSString *title;//主题栏名
@property(nonatomic, retain)NSString *index;
@property(nonatomic, retain)NSString *more;
@property(nonatomic, retain)NSArray *dataArr;


-(instancetype)initWithDic:(NSDictionary *)dic;

@end
