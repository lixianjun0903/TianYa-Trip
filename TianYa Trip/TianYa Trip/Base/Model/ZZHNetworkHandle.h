//
//  ZZHNetworkHandle.h
//  TianYa Trip
//
//  Created by dlios on 15-5-14.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZHNetworkHandle : NSObject
+ (void)getDataWithUrl:(NSString *)str completion:(void(^)(id result))block;
+ (void)getDataWithUrl:(NSString *)str Cookie:(NSString *)cookie completion:(void (^)(id result))block;
+ (void)getDataWithUrl:(NSString *)str Cookie:(NSString *)cookie completion:(void (^)(id result))block error:(void (^)(id error1))error1;
@end
