//
//  ZZHHotTravelNote.h
//  TianYa Trip
//
//  Created by dlios on 15-5-13.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHBaseObject.h"

@interface ZZHHotTravelNote : ZZHBaseObject
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *photo;
@property (nonatomic, retain) NSString *local_time;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSDictionary *photo_info;
@end
