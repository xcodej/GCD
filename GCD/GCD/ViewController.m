//
//  ViewController.m
//  GCD
//
//  Created by xujian on 2017/2/13.
//  Copyright © 2017年 xujian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/**
 * Dispatch Queue有两种：
 * 等待现在执行中处理的串行队列(Serial Queue)
 * 不等待现在执行中处理的并行队列(Concurrent Dispatch Queue)
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self testSerialDispatchQueue];
    [self testConcurrentDispatchQueue];
}

- (void) testSerialDispatchQueue {
    // 创建一个串行队列
    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.xj.gcd.SerialDispatchQueue", NULL);
    dispatch_async(mySerialDispatchQueue, ^{
        NSLog(@"block on mySerialDispatchQueue");
    });
}

- (void) testConcurrentDispatchQueue {
    // 创建一个并行队列
    dispatch_queue_t myConcurrentDispatchQueue = dispatch_queue_create("com.xj.gcd.ConcurrentDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
}


@end
