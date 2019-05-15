//
//  CAHttpSessionManager.m
//  Zegobird
//
//  Created by 罗海雄 on 2019/3/15.
//  Copyright © 2019 xiaozhai. All rights reserved.
//

#import "CAHttpSessionManager.h"
#import "CAHttpTaskDelegate.h"
#import "CAWeakObjectContainer.h"

@interface CAHttpSessionManager()

///任务代理
@property(nonatomic, strong) NSMutableDictionary<NSNumber*, CAWeakObjectContainer*> *delegates;

///异步线程返回 有些解析可能比较耗时
@property(nonatomic, strong) dispatch_queue_t customCompletionQueue;

@end

@implementation CAHttpSessionManager

+ (instancetype)sharedManager
{
    static CAHttpSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CAHttpSessionManager new];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        self.requestSerializer.timeoutInterval = 15;
        self.customCompletionQueue = dispatch_queue_create("com.zegobird.http.customCompletionQueue", DISPATCH_QUEUE_CONCURRENT);
        self.completionQueue = self.customCompletionQueue;
        self.delegates = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:nil
                        downloadProgress:nil
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                           CAWeakObjectContainer *container = [self.delegates objectForKey:@(dataTask.taskIdentifier)];
                           if(container){
                               id<CAHttpTaskDelegate> delegate = container.weakObject;
                               if([delegate respondsToSelector:@selector(URLSessionDataTask:didCompleteWithData:error:)]){
                                   [delegate URLSessionDataTask:dataTask didCompleteWithData:responseObject error:error];
                               }
                               [self.delegates removeObjectForKey:@(dataTask.taskIdentifier)];
                           }
                       }];
    
    return dataTask;
}


- (void)addDelegate:(id<CAHttpTaskDelegate>) delegate forTask:(NSURLSessionTask*) task
{
    if(!delegate || !task)
        return;
    [_delegates setObject:[CAWeakObjectContainer containerWithObject:delegate] forKey:@(task.taskIdentifier)];
}

@end
