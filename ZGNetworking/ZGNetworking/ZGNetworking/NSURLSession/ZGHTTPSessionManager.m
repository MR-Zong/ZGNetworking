//
//  ZGHTTPSessionManager.m
//  ZGNetworking
//
//  Created by Zong on 16/11/2.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "ZGHTTPSessionManager.h"
#import "ZGURLRequestSerialization.h"
#import "ZGURLResponseSerialization.h"

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
    
    NSString *fullUrlString = [ZGURLRequestSerialization fullUrlStringWithURLString:URLString parameters:parameters];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullUrlString]];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(task,error);
            }
        }else {
            
            if (success) {
                success(task,[ZGURLResponseSerialization objectWithData:data]);
            }
        }
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
    request.HTTPBody = [[ZGURLRequestSerialization paramsStringWithParameters:parameters] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(task,error);
            }
        }else {
            
            if (success) {
                success(task,[ZGURLResponseSerialization objectWithData:data]);
            }
        }
    }];
    
    //    [task resume];
    
    return task;
}



@end
