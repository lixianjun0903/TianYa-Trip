//
//  NetworkHandle.m
//  UI_项目框架
//
//  Created by 王骊靬 on 5/8/15.
//  Copyright (c) 2015 www.lanou3g.com 蓝鸥科技. All rights reserved.
//

#import "NetworkHandle.h"
#import "AFNetworking.h"


@implementation NetworkHandle

+ (void)getDataWithURL:(NSString *)str completion:(void (^)(id result))block
{
    //字符串UTF8转码
    NSString *strURL = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 创建AFN网络请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置响应解析对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置响应数据支持类型
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil]];
    // AFN的GET请求
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GET请求成功");
        // 请求成功后返回的responseObject数据为NSData
        // 进行JSON解析
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result = %@", result);
        // 使用Block返回网络请求数据
        block(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 如果请求失败 返回失败信息
        NSLog(@"请求失败: %@", error);
    }];
}

+ (void)getDataWithHttpsURL:(NSString *)str completion:(void (^)(id result))block
{
    //字符串UTF8转码
    NSString *strURL = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 创建AFN网络请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置响应解析对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置响应数据支持类型
    //解析https接口时加上以下方法
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil]];
    // AFN的GET请求
    [manager GET:strURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GET请求成功");
        // 请求成功后返回的responseObject数据为NSData
        // 进行JSON解析
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result = %@", result);
        // 使用Block返回网络请求数据
        block(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 如果请求失败 返回失败信息
        NSLog(@"请求失败: %@", error);
    }];
}


+ (void)postDataWithURL:(NSString *)str parameters:(id)parameters completion:(void (^)(id result))block
{
    //字符串UTF8转码
    NSString *strURL = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 创建AFN网络请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置响应解析对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 支持全类型接口
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil]];
    // AFN的POST请求
    [manager POST:strURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"POST请求成功");
        // 请求成功后返回的responseObject数据为NSData
        // 进行JSON解析
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result = %@", result);
        // 使用Block返回网络请求数据
        block(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 如果请求失败 返回失败信息
        NSLog(@"请求失败: %@", error);
    }];
    
}

+ (void)startNetMonitoringWithCompletion:(void (^)(id result))block
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WIFI网络
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"无网络");
                NSDictionary *noWIFIDic = @{@"info":@"无网络,请检查手机能否上网!", @"infoImg":@"NoWIFI@2x.png"};
                block(noWIFIDic);
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"WiFi网络");
//                NSDictionary *WIFIDic = @{@"info":@"WIFI就是爽,上网不花钱!", @"infoImg":@"WIFI@2x.png"};
//                block(WIFIDic);
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"蜂窝数据网络");
                NSDictionary *liuliangDic = @{@"info":@"流量走风险,上网需谨慎!", @"infoImg":@"LiuLiang@2x.png"};
                block(liuliangDic);
                break;
            }
            default:
                break;
        }
        
    }];
    
}
@end
