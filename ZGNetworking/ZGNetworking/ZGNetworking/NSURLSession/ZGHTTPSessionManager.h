//
//  ZGHTTPSessionManager.h
//  ZGNetworking
//
//  Created by Zong on 16/11/2.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGURLSessionManager.h"

@interface ZGHTTPSessionManager : ZGURLSessionManager

+ (nullable instancetype)defaultManager;

- (nullable NSURLSessionDataTask *)GET:(nonnull NSString *)URLString
                            parameters:(nullable NSDictionary *)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * __nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)GET:(nonnull NSString *)URLString
                            parameters:(nullable NSDictionary *)parameters
                               session:(nullable NSURLSession *)session
                               success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * __nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(nonnull NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * __nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(nonnull NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                                session:(nullable NSURLSession *)session
                                success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * __nullable task, NSError *error))failure;

@end
