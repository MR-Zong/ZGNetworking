//
//  CAHttpTask.h
//  Zegobird
//
//  Created by 罗海雄 on 2019/3/14.
//  Copyright © 2019 xiaozhai. All rights reserved.
//

#import <UIKit/UIKit.h>

///http请求方法
typedef NS_ENUM(NSInteger, CAHttpMethod){
    
    ///get
    CAHttpMethodGet,
    
    ///post
    CAHttpMethodPost,
};

///数据源
static NSString *const CAHttpData = @"datas";

///翻页起始页
static const int CAHttpFirstPage = 1;

NS_ASSUME_NONNULL_BEGIN

/**
 单个http请求任务 子类可重写对应的方法
 不需要添加一个属性来保持 strong ，任务开始后会添加到一个全局 队列中
 */
@interface CAHttpTask : NSObject

/**
 请求超时 由于NSURLSession创建后 不能修改超时时间，只能自己模拟一个请求超时用于某些特殊场景
 default is '0' 不使用这个字段
 */
@property(nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 是否需要传登录token default is 'NO'
 */
@property(nonatomic, assign) BOOL useLoginToken;

/**
 是否上传客户端类型 default is 'NO'
 */
@property(nonatomic, assign) BOOL useClientType;

/**
 是否正在执行
 */
@property(nonatomic, readonly) BOOL isExecuting;

/**
 是否暂停
 */
@property(nonatomic, readonly) BOOL isSuspended;

/*
 是否是自己取消
 */
@property(nonatomic, readonly) BOOL isCanceled;

/**
 是否是网络错误
 */
@property(nonatomic, readonly) BOOL isNetworkError;

/**
 是否请求成功
 */
@property(nonatomic, readonly) BOOL isApiSuccess;

/**
 成功回调
 */
@property(nonatomic, copy) void(^ _Nullable successHandler)(__kindof CAHttpTask * _Nonnull task);

/**
 将要调用失败回调
 */
@property(nonatomic, copy) void(^ _Nullable willFailHandler)(__kindof CAHttpTask * _Nonnull task);

/**
 失败回调
 */
@property(nonatomic, copy) void(^ _Nullable failHandler)(__kindof CAHttpTask * _Nonnull task);

/**
 请求链接 默认是电商app的接口域名
 */
- (nonnull NSString*)requestURL;

/**
 请求方法
 */
- (nonnull NSString*)requestMethod;

/**
 获取参数
 */
- (nullable NSMutableDictionary*)params;

/**
 获取文件
 */
- (nullable NSMutableDictionary*)files;

/**
 请求标识 默认返回类的名称
 */
@property(nonnull, nonatomic, copy) NSString *name;

/**
 默认get
 */
@property(nonatomic, assign) CAHttpMethod httpMethod;

/**
 结果
 */
@property(nonatomic, readonly) NSDictionary *resultDic;

/**
 原始最外层字典
 */
@property(nonatomic, readonly) NSDictionary *data;

/**
 提示的信息
 */
@property(nonatomic, copy) NSString *message;

/**
 api状态码
 */
@property(nonatomic, readonly) int code;

/**
 分页页码 大于0时使用
 */
@property(nonatomic, assign) int page;

/**
 每页数量 默认20，只有当 page > 0时才使用
 */
@property(nonatomic, assign) int count;

/**
 是否还有下一页
 */
@property(nonatomic, assign) BOOL hasMore;

/**
 额外信息，用来传值的
 */
@property(nonatomic, strong) NSDictionary *userInfo;

/**
 关联的view，用来显示 错误信息，loading
 */
@property(nonatomic, weak) UIView *view;

/**
 activity显示延迟 default 0.5
 */
@property(nonatomic, assign) NSTimeInterval loadingHUDDelay;

/**
 是否自动提示弹窗 default is no 优先提示
 */
@property(nonatomic, assign) BOOL shouldShowloadingHUD;

/**
 是否提示错误信息，default is no
 */
@property(nonatomic, assign) BOOL shouldAlertErrorMsg;

/**
 获取对应任务
 */
- (nonnull NSURLSessionDataTask*)getURLSessionTask;

#pragma mark- 回调

///请求开始
- (void)onStart NS_REQUIRES_SUPER;

/**
 请求成功 在这里解析数据
 @warning 这里是在异步线程调用的
 */
- (void)onSuccess NS_REQUIRES_SUPER;

///请求失败
- (void)onFail NS_REQUIRES_SUPER;

///请求完成 无论是 失败 成功 或者取消
- (void)onComplete NS_REQUIRES_SUPER;

///开始请求
- (void)start NS_REQUIRES_SUPER;

///取消
- (void)cancel NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
