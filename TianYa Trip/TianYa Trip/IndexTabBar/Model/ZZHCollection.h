//
//  ZZHCollection.h
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/22.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHBaseObject.h"

@interface ZZHCollection : ZZHBaseObject
@property (nonatomic, retain) NSString *photo;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *local_time;
@property (nonatomic, retain) NSString *timezone;
@property (nonatomic, retain) NSDictionary *photo_info;
@end
