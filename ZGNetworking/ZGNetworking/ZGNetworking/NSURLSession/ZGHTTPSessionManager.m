//
//  ZGHTTPSessionManager.m
//  ZGNetworking
//
//  Created by Zong on 16/11/2.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "ZGHTTPSessionManager.h"

@interface ZGHTTPSessionManager ()

@property (nonatomic, strong) ZGURLSessionManager *urlSessionManager;

@end

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



- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure
{
   return [self GET:URLString parameters:parameters session:[NSURLSession sharedSession] success:success failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters session:(NSURLSession *)session success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure
{
    if (URLString.length <= 0) {
        return nil;
    }
    
    NSString *fullUrlString = [self fullUrlStringWithURLString:URLString parameters:parameters];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:fullUrlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        ;;
    }];
    
    //    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure
{
    return [self POST:URLString parameters:parameters session:[NSURLSession sharedSession] success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters session:(NSURLSession *)session success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure
{
    if (URLString.length <= 0) {
        return nil;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[self paramsStringWithParameters:parameters] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        ;;
    }];
    
    //    [task resume];
    
    return task;
}



#pragma mark - util function
- (NSString *)paramsStringWithParameters:(NSDictionary *)parameters
{
    NSMutableString *mParamString = [NSMutableString string];
    
    NSArray *allKeys = parameters.allKeys;
    for (int i=0;i<allKeys.count;i++)
    {
        NSString *key = allKeys[i];
        id value = parameters[key];
        [mParamString appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        if (i < allKeys.count - 1) {
            [mParamString appendString:@"&"];
        }
    }
    
    return mParamString.copy;
}

- (NSString *)fullUrlStringWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    NSMutableString *mFullUrlString = [NSMutableString stringWithString:URLString];
    NSString *paramString = [self paramsStringWithParameters:parameters];
    
    if (paramString.length > 0) {
        [mFullUrlString appendString:@"?"];
        [mFullUrlString appendString:paramString];
    }

    return mFullUrlString.copy;
}


@end
