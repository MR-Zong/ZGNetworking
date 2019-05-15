//
//  CAHttpSessionManager.h
//  Zegobird
//
//  Created by 罗海雄 on 2019/3/15.
//  Copyright © 2019 xiaozhai. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol CAHttpTaskDelegate;

///默认的api请求管理
@interface CAHttpSessionManager : AFHTTPSessionManager

///单例
+ (instancetype)sharedManager;

///http请求
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

/**
 添加代理
 
 @param delegate 代理 
 @param task 对应任务
 */
- (void)addDelegate:(id<CAHttpTaskDelegate>) delegate forTask:(NSURLSessionTask*) task;

@end

