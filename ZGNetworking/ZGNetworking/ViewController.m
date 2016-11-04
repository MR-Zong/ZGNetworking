//
//  ViewController.m
//  ZGNetworking
//
//  Created by 徐宗根 on 16/10/30.
//  Copyright © 2016年 XuZonggen. All rights reserved.
//

#import "ViewController.h"
#import "ZGNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getExample];
//    [self postExample];
}

- (void)getExample
{
    ZGHTTPSessionManager *manager = [ZGHTTPSessionManager defaultManager];
    NSString *urlString = @"http://www.baidu.com";
    NSDictionary *params = @{
                             @"a" : @"zong",
                             @"b" : @89.88,
                             @"c" : @YES
                             };
    [manager GET:urlString parameters:params success:nil failure:nil];
}

- (void)postExample
{
    ZGHTTPSessionManager *manager = [ZGHTTPSessionManager defaultManager];
    NSString *urlString = @"http://www.baidu.com";
    NSDictionary *params = @{
                             @"a" : @"zong",
                             @"b" : @89.88,
                             @"c" : @YES
                             };
    [manager POST:urlString parameters:params success:nil failure:nil];
}

@end
