//
//  ZGExampleViewController.m
//  ZGNetworking
//
//  Created by lizhi on 2019/5/14.
//  Copyright © 2019 XuZonggen. All rights reserved.
//

#import "ZGExampleViewController.h"

@interface ZGExampleViewController ()

@end

@implementation ZGExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlString = @"http://www.baidu.com/index";
    NSURL *url = [NSURL URLWithString:urlString relativeToURL:nil];
    NSLog(@"urlString %@, url %@",urlString,url);
}



@end
