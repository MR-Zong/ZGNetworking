//
//  CAHttpTaskDelegate.h
//  Zegobird
//
//  Created by 罗海雄 on 2019/3/15.
//  Copyright © 2019 xiaozhai. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 http 任务代理
 */
@protocol CAHttpTaskDelegate <NSObject>

@optional

/**
 请求任务完成
 
 @param dataTask 请求任务
 @param data 返回的数据
 @param error 错误
 */
- (void)URLSessionDataTask:(NSURLSessionDataTask*) dataTask didCompleteWithData:(NSDictionary*) data error:(NSError*) error;



@end
