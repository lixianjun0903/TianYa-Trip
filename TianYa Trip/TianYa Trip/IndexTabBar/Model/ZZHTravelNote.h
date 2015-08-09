//
//  ZZHTravelNote.h
//  TianYa Trip
//
//  Created by dlios on 15-5-15.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHBaseObject.h"

@interface ZZHTravelNote : ZZHBaseObject

@property (nonatomic, retain) NSString *photo;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *local_time;
@property (nonatomic, retain) NSDictionary *photo_info;
@end
