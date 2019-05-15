//
//  CAHttpMultiTasks.m
//  Zegobird
//
//  Created by 罗海雄 on 2019/3/14.
//  Copyright © 2019 xiaozhai. All rights reserved.
//

#import "CAHttpMultiTasks.h"
#import "CAHttpTask.h"
#import "CAHttpTaskDelegate.h"
#import "CAHttpSessionManager.h"
#import "NSObject+CAUtils.h"

@interface CAHttpMultiTasks()<CAHttpTaskDelegate>

///任务列表
@property(nonatomic, strong) NSMutableArray<NSURLSessionTask*> *tasks;

///是否有请求失败
@property(nonatomic, assign) BOOL hasFail;

///是否并发执行
@property(nonatomic, assign) BOOL concurrent;

///对应任务
@property(nonatomic, strong) NSMutableDictionary<NSString*, __kindof CAHttpTask*> *taskDictionary;

@end

@implementation CAHttpMultiTasks

///保存请求队列的单例
+ (NSMutableSet*)sharedContainers
{
    static NSMutableSet *sharedContainers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContainers = [NSMutableSet set];
    });
    
    return sharedContainers;
}

- (void)dealloc
{
    
}

- (instancetype)init
{
    self = [super init];
    if(self){
        
        self.tasks = [NSMutableArray array];
        self.taskDictionary = [NSMutableDictionary dictionary];
        self.shouldCancelAllTaskWhileOneFail = YES;
    }
    
    return self;
}

- (void)addTask:(CAHttpTask *)task
{
    [self addTask:task forKey:[task ca_nameOfClass]];
}

- (void)addTask:(CAHttpTask*) task forKey:(NSString *)key
{
    [self.taskDictionary setObject:task forKey:key];
    [self.tasks addObject:task.getURLSessionTask];
    [[CAHttpSessionManager sharedManager] addDelegate:self forTask:task.getURLSessionTask];
}


- (void)start
{
    self.concurrent = YES;
    [self startTask];
}

- (void)startSerially
{
    self.concurrent = NO;
    [self startTask];
}

- (void)cancelAllTasks
{
    for(NSURLSessionTask *task in self.tasks){
        [task cancel];
    }
    [self.tasks removeAllObjects];
    [self.taskDictionary removeAllObjects];
    
    [[CAHttpMultiTasks sharedContainers] removeObject:self];
}

- (__kindof CAHttpTask*)taskForKey:(NSString*) key
{
    return [self.taskDictionary objectForKey:key];
}

///开始任务
- (void)startTask
{
    [[CAHttpMultiTasks sharedContainers] addObject:self];
    self.hasFail = NO;
    
    if(self.concurrent){
        for(NSURLSessionTask *task in self.tasks){
            [task resume];
        }
    }else{
        [self startNextTask];
    }
}

///开始执行下一个任务 串行时用到
- (void)startNextTask
{
    NSURLSessionTask *task = [self.tasks firstObject];
    [task resume];
}

///删除任务
- (void)task:(NSURLSessionTask*) task didComplete:(BOOL) success
{
    [self.tasks removeObject:task];
    
    if(!success){
        self.hasFail = YES;
        if(self.shouldCancelAllTaskWhileOneFail){
            for(NSURLSessionTask *task in self.tasks){
                [task cancel];
            }
            [self.tasks removeAllObjects];
        }
    }
    
    if(self.tasks.count == 0){
        !self.completionHandler ?: self.completionHandler(self, self.hasFail);
        [self.taskDictionary removeAllObjects];
        [[CAHttpMultiTasks sharedContainers] removeObject:self];
        
    }else if (!self.concurrent){
        [self startNextTask];
    }
}

#pragma mark CAHttpTaskDelegate

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask didCompleteWithData:(NSDictionary *)data error:(NSError *)error
{
    dispatch_main_async_safe(^(void){
       
        [self task:dataTask didComplete:!error];
    });
}


@end
