//
//  NetworkHandle.h
//  UI_项目框架
//
//  Created by 王骊靬 on 5/8/15.
//  Copyright (c) 2015 www.lanou3g.com 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHandle : NSObject
//AFN 异步GET封装方法
+ (void)getDataWithURL:(NSString *)str completion:(void(^)(id result))block;
//解析HTTPS
+ (void)getDataWithHttpsURL:(NSString *)str completion:(void (^)(id result))block;
//AFN 异步POST封装方法
+ (void)postDataWithURL:(NSString *)str parameters:(id)parameters completion:(void(^)(id result))block;

+ (void)startNetMonitoringWithCompletion:(void (^)(id result))block;

@end
