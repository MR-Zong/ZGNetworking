//
//  ZGURLResponseSerialization.m
//  ZGNetworking
//
//  Created by Zong on 16/11/2.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "ZGURLResponseSerialization.h"

@implementation ZGURLResponseSerialization

+ (id)objectWithData:(NSData *)data
{
    NSError *error;
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
}

@end
