//
//  ZZHSC.h
//  TianYa Trip
//
//  Created by 郑泽辉 on 15/5/25.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHBaseObject.h"

@interface ZZHSC : ZZHBaseObject  <NSCoding>
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *days;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *cover_image;
@end
