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
    
}
- (IBAction)runGcd:(UIButton *)sender {
//    [self testSerialDispatchQueue];
//    [self testConcurrentDispatchQueue];
//    [self testDelay];
//    [self testDispatchQueueGroup];
    [self testDispatchSources];
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

- (void) testDispatchQueueGroup {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"hello1");
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"hello2");
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"hello3");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"main run");
    });
}

- (void) testDispatchApply {
    // 使用dispatch_apply 并行遍历数组
    NSArray * array = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_apply([array count], queue, ^(size_t index) {
            NSLog(@"%zu: %@",index,[array objectAtIndex:index]);
        });
    });
}

- (void) testDispatchSources {
    // 使用GCD进行重复执行
    NSTimeInterval period = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"hello");
    });
    dispatch_resume(timer);
}

@end
