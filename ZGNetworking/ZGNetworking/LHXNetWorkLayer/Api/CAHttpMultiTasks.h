//
//  CAHttpMultiTasks.h
//  Zegobird
//
//  Created by 罗海雄 on 2019/3/14.
//  Copyright © 2019 xiaozhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CAHttpTask;

/**
 多任务处理
 */
@interface CAHttpMultiTasks : NSObject

/**
 当有一个任务失败时，是否取消所有任务 default is 'YES'
 */
@property(nonatomic, assign) BOOL shouldCancelAllTaskWhileOneFail;

/**
 所有任务完成回调 hasFail 是否有任务失败了
 */
@property(nonatomic, copy) void(^completionHandler)(CAHttpMultiTasks *tasks, BOOL hasFail);

/**
 添加任务 key 为className
 */
- (void)addTask:(CAHttpTask*) task;

/**
 添加任务
 
 @param task 对应任务，会通过 getURLSessionTask 添加
 不要需要调用 CAHttpTask 的start方法
 CAHttpTask中 onStart 方法将不会触发
 
 @param key 唯一标识符
 */
- (void)addTask:(CAHttpTask*) task forKey:(NSString*) key;

/**
 开始所有任务
 */
- (void)start;

/**
 串行执行所有任务，按照添加顺序来执行
 */
- (void)startSerially;

/**
 取消所有请求
 */
- (void)cancelAllTasks;

/**
 获取某个请求
 */
- (__kindof CAHttpTask*)taskForKey:(NSString*) key;

@end

