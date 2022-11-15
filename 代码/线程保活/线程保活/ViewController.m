//
//  ViewController.m
//  线程保活
//
//  Created by Clutch Powers on 2022/11/16.
//

#import "ViewController.h"
#import "MJThread.h"

@interface ViewController ()

@property (nonatomic, strong) MJThread *thread;

@property (nonatomic, assign) BOOL STOP;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.STOP = NO;
    
    __weak typeof(self) weakSelf = self;
    
    // 利用指定的block来线程保活
    self.thread = [[MJThread alloc] initWithBlock:^{
        NSLog(@"thread is Running...");
        
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        
        while (weakSelf && !weakSelf.STOP) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"thread Closed"); // 执行到这，说明线程的任务执行完毕，线程即将销毁
    }];
    
    self.thread.name = @"Mythread";
    
    [self.thread start];
}

// 通过点击事件在子线程中调用子线程需要执行的代码
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.thread == nil) return;
    
    [self performSelector:@selector(execution) onThread:self.thread withObject:nil waitUntilDone:YES];
}

// 这里是子线程需要执行的代码
- (void)execution {
    
    NSLog(@"%s %@",__func__,[NSThread currentThread]);
}

- (void)stop {
    
    self.STOP = YES;
    
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    self.thread = nil;
}

- (void)dealloc {
    
    NSLog(@"VC-dealloc");
    
    [self performSelector:@selector(stop) onThread:self.thread withObject:nil waitUntilDone:YES];
    
}
- (IBAction)stopAction {
    if (self.thread == nil) return;
    
    [self performSelector:@selector(stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}
@end
