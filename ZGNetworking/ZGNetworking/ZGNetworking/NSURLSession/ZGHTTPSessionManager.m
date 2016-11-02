//
//  ZGHTTPSessionManager.m
//  ZGNetworking
//
//  Created by Zong on 16/11/2.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "ZGHTTPSessionManager.h"

@implementation ZGHTTPSessionManager

+ (instancetype)defaultManager
{
    static ZGHTTPSessionManager *_defaultHttpSessionManager_ = nil;
    if (!_defaultHttpSessionManager_) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _defaultHttpSessionManager_ = [[ZGHTTPSessionManager alloc] init];
        });
    }
    return _defaultHttpSessionManager_;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    return nil;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure
{
    return nil;
}

@end
