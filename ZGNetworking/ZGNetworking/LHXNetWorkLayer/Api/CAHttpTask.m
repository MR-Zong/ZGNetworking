//
//  CAHttpTask.m
//  Zegobird
//
//  Created by 罗海雄 on 2019/3/14.
//  Copyright © 2019 xiaozhai. All rights reserved.
//

#import "CAHttpTask.h"
#import "CABaseConstant.h"
#import "CAHttpSessionManager.h"
#import "NSDictionary+CAUtils.h"
#import "CAApiConstant.h"

@implementation CAHttpTask
{
    ///当前任务
    NSURLSessionDataTask *_URLSessionTask;
}

///保存请求队列的单例
+ (NSMutableSet*)sharedTasks
{
    static NSMutableSet *sharedTasks = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTasks = [NSMutableSet set];
    });
    
    return sharedTasks;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        self.loadingHUDDelay = 0.5;
    }
    
    return self;
}

- (void)dealloc
{
    
}

#pragma mark 子类实现

- (nonnull NSString*)requestURL
{
    return [NSString stringWithFormat:@"%@/api/", CAApiConstant.mallApiDomain];
}

- (nonnull NSString*)requestMethod
{
    return @"";
}

- (nullable NSMutableDictionary*)params
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(self.useLoginToken){
        NSString *token = [CAUserModel sharedUser].token;
        if (![NSString isEmpty:token]) {
            params[@"token"] = token;
        }
    }
    
    if(self.useClientType){
        params[@"clientType"] = @"ios";
    }
    
    return params;
}

- (nullable NSMutableDictionary*)files
{
    return nil;
}

- (nullable NSArray<NSHTTPCookie*>*)cookies
{
    return nil;
}

- (nullable NSDictionary<NSString*, NSString*>*)headers
{
    return nil;
}

- (nonnull NSString*)name
{
    if(_name == nil){
        return NSStringFromClass([self class]);
    }
    
    return _name;
}

- (void)processParams:(nullable NSMutableDictionary*) params files:(nullable NSMutableDictionary*)files
{
    
}

- (BOOL)resultFromData:(nullable NSData*) data
{
    return YES;
}

#pragma mark handler

- (nonnull NSURLSessionDataTask*)getURLSessionTask
{
    if(!_URLSessionTask){

        @WeakObj(self)
        
        NSString *URLString = [[self requestURL] stringByAppendingPathComponent:self.requestMethod];;
        CAHttpSessionManager *manager = [CAHttpSessionManager sharedManager];
        
        _URLSessionTask = [manager dataTaskWithHTTPMethod:self.httpMethod == CAHttpMethodGet ? @"GET" : @"POST" URLString:URLString parameters:self.params success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
            
            [selfWeak onRequestSuccess:responseObject];
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            [selfWeak onRequestFail:error];
        }];
    }
    return _URLSessionTask;
}

///请求成功
- (void)onRequestSuccess:(NSDictionary*) dic
{
    if([dic isKindOfClass:[NSDictionary class]]){
        _data = dic;
        _code = [[dic ca_numberForKey:@"code"] intValue];
        if(_code == CAHttpCodeSuccess){
            _resultDic = [dic ca_dictionaryForKey:@"datas"];
            [self requestDidSuccess];
        }else{
            _message = [[dic ca_dictionaryForKey:@"datas"] ca_stringForKey:@"error"].zawgyiMyanmar;
            [self requestDidFail];
        }
    }else{
        [self requestDidFail];
    }
}

///请求成功
- (void)onRequestFail:(NSError*) error
{
    //是自己取消的
    if(self.isCanceled){
        return;
    }
    
    _isNetworkError = YES;
    [self requestDidFail];
}

#pragma mark status

- (BOOL)isExecuting
{
    return _URLSessionTask != nil && _URLSessionTask.state == NSURLSessionTaskStateRunning;
}

- (BOOL)isSuspended
{
    return _URLSessionTask != nil && _URLSessionTask.state == NSURLSessionTaskStateSuspended;
}

- (BOOL)isApiSuccess
{
    return _code == CAHttpCodeSuccess;
}

#pragma mark- 回调

///请求开始
- (void)onStart
{
    [[CAHttpTask sharedTasks] addObject:self];
    [self observeTimeout];
    if(self.shouldShowloadingHUD){
        if(self.view != nil){
            [self.view ca_showProgressWithText:nil delay:self.loadingHUDDelay];
        }
    }
}

///请求成功
- (void)onSuccess
{
    
}

///请求失败
- (void)onFail
{
    if(self.shouldAlertErrorMsg){
        if([self.requestMethod containsString:@"goods/"] ||
           [self.requestMethod containsString:@"version/"]) {
            
        }else{
            
            [SVProgressHUD dismiss];
            //服务端错误
            NSString *error = nil;
            if(_code == CAHttpCodeFail){
                error = self.message;
            }
            
            if([NSString isEmpty:error]){
                error = ASLocalizedString(@"Loading failed");
            }
            
            if(self.view){
                [self.view ca_showErrorWithText:error];
            }else{
                [[UIApplication sharedApplication].keyWindow ca_showErrorWithText:error];
            }
        }
    }
}

///请求完成
- (void)onComplete
{
    [self cancelTimeoutObserve];
    [self.view ca_dismissProgress];
    _URLSessionTask = nil;
    [[CAHttpTask sharedTasks] removeObject:self];
}

///超时
- (void)onTimeout
{
    if(self.isExecuting || self.isSuspended){
        _isCanceled = YES;
        [_URLSessionTask cancel];
        [self requestDidFail];
        NSLog(@"自己设定的请求超时 %@", _URLSessionTask.originalRequest.URL);
    }
}

#pragma mark timeout

///取消超时监听
- (void)cancelTimeoutObserve
{
    if(self.timeoutInterval){
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(onTimeout) object:nil];
    }
}

///监听超时
- (void)observeTimeout
{
    if(self.timeoutInterval > 0){
        [self performSelector:@selector(onTimeout) withObject:nil afterDelay:self.timeoutInterval];
    }
}

#pragma mark- public method

///开始请求
- (void)start
{
    if(self.isExecuting)
        return;
    
    [self getURLSessionTask];
    
    [self onStart];
    [_URLSessionTask resume];
}

///取消
- (void)cancel
{
    if(self.isSuspended || self.isExecuting){
        _isCanceled = YES;
        [_URLSessionTask cancel];
        [self onComplete];
    }
}

#pragma mark private method

- (void)requestDidSuccess
{
    [self onSuccess];
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        !selfWeak.successHandler ?: selfWeak.successHandler(selfWeak);
        [selfWeak onComplete];
    });
}

- (void)requestDidFail
{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        !selfWeak.willFailHandler ?: selfWeak.willFailHandler(selfWeak);
        [selfWeak onFail];
        !selfWeak.failHandler ?: selfWeak.failHandler(selfWeak);
        [selfWeak onComplete];
    });
}


@end
