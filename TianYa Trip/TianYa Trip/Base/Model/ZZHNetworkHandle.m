//
//  ZZHNetworkHandle.m
//  TianYa Trip
//
//  Created by dlios on 15-5-14.
//  Copyright (c) 2015年 NeoTeam. All rights reserved.
//

#import "ZZHNetworkHandle.h"
#import "AFNetworking.h"
@implementation ZZHNetworkHandle

+ (void)getDataWithUrl:(NSString *)str completion:(void (^)(id result))block
{
    //创建AFN网络请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置响应解析对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置响应数据支持类型
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil]];
    //AFN的GET请求
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功");
        // 请求成功后返回的responseObject数据为NSData
        // 进行JSON解析
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        [result retain];
        block(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败:%@", error);
    }];
}

+ (void)getDataWithUrl:(NSString *)str Cookie:(NSString *)cookie completion:(void (^)(id result))block   {
    //字符串UTF8转码
    NSString *strURL = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //创建AFN网络请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置响应解析对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置响应数据支持类型
    [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:@"BreadTrip/5.0.0/zh" forHTTPHeaderField:@"User-Agent"];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil]];
    //AFN的GET请求
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功");
        // 请求成功后返回的responseObject数据为NSData
        // 进行JSON解析
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        [result retain];
        block(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败:%@", error);
        
        
    }];
}

+ (void)getDataWithUrl:(NSString *)str Cookie:(NSString *)cookie completion:(void (^)(id result))block  error:(void (^)(id error1))error1 {
    //创建AFN网络请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置响应解析对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置响应数据支持类型
    [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:@"BreadTrip/5.0.0/zh" forHTTPHeaderField:@"User-Agent"];

    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil]];
    //AFN的GET请求
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功");
        // 请求成功后返回的responseObject数据为NSData
        // 进行JSON解析
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        [result retain];
        block(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败:%@", error);
        error1(error);
       
    }];
}
@end
