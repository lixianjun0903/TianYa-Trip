//
//  ZZHTravel.h
//  TianYa Trip
//
//  Created by dlios on 15-5-15.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHBaseObject.h"

@interface ZZHTravel : ZZHBaseObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *cover_image;
@property (nonatomic, retain) NSString *day_count;
@property (nonatomic, retain) NSString *first_day;
@property (nonatomic, retain) NSString *popular_place_str;
@property (nonatomic, retain) NSDictionary *user;
@property (nonatomic, retain) NSString *id;
@end
