//
//  ViewController.m
//  GCD
//
//  Created by xujian on 2017/2/13.
//  Copyright © 2017年 xujian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    dispatch_queue_t mySerialDispatchQueue;
    dispatch_queue_t myConcurrentDispatchQueue;
}

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
    [self testDelay];
}

- (void) testSerialDispatchQueue {
    // 创建一个串行队列
    mySerialDispatchQueue = dispatch_queue_create("com.xj.gcd.SerialDispatchQueue", NULL);
    dispatch_async(mySerialDispatchQueue, ^{
        NSLog(@"block on mySerialDispatchQueue");
    });
}

- (void) testConcurrentDispatchQueue {
    // 创建一个并行队列
    myConcurrentDispatchQueue = dispatch_queue_create("com.xj.gcd.ConcurrentDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
}

- (void) testDelay {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        NSLog(@"hello");
    });
}

dispatch_time_t getDispatchTimeByData(NSDate * date) {
    // 将 NSDate 转换成 dispatch_time_t
    NSTimeInterval interval;
    double second, subsecond;
    struct timespec time;
    dispatch_time_t milestone;
    
    interval = [date timeIntervalSince1970];
    subsecond = modf(interval, &second);
    time.tv_sec = second;
    time.tv_nsec = subsecond * NSEC_PER_SEC;
    milestone = dispatch_walltime(&time, 0);
    
    return milestone;
}

@end
