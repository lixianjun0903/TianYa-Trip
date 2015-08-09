//
//  NEOCountryList.h
//  TianYa Trip
//
//  Created by BOSSNEO on 15/5/23.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NEOCountryList : NSObject
@property (nonatomic, retain)NSString *imgURL;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *pageID;
@property (nonatomic, retain)NSString *pageType;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
