//
//  ZZHBaseObject.h
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZHBaseObject : NSObject

/**
 *  KVC初始化
 *
 *  @param dic 接口的字典
 *
 *  @return
 */
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
