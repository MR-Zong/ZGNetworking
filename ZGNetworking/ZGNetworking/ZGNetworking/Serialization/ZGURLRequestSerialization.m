//
//  ZGURLRequestSerialization.m
//  ZGNetworking
//
//  Created by Zong on 16/11/2.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "ZGURLRequestSerialization.h"

@implementation ZGURLRequestSerialization

+ (NSString *)paramsStringWithParameters:(NSDictionary *)parameters
{
    NSMutableString *mParamString = [NSMutableString string];
    
    NSArray *allKeys = parameters.allKeys;
    for (int i=0;i<allKeys.count;i++)
    {
        NSString *key = allKeys[i];
        id value = parameters[key];
        [mParamString appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        if (i < allKeys.count - 1) {
            [mParamString appendString:@"&"];
        }
    }
    
    return mParamString.copy;
}

+ (NSString *)fullUrlStringWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    NSMutableString *mFullUrlString = [NSMutableString stringWithString:URLString];
    NSString *paramString = [self paramsStringWithParameters:parameters];
    
    if (paramString.length > 0) {
        [mFullUrlString appendString:@"?"];
        [mFullUrlString appendString:paramString];
    }
    
    return mFullUrlString.copy;
}

@end
