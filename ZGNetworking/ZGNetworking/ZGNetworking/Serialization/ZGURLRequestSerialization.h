//
//  ZGURLRequestSerialization.h
//  ZGNetworking
//
//  Created by Zong on 16/11/2.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZGURLRequestSerialization : NSObject

+ (NSString *)paramsStringWithParameters:(NSDictionary *)parameters;
+ (NSString *)fullUrlStringWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters;

@end
