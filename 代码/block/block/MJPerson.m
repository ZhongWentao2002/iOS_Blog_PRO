//
//  MJPerson.m
//  block
//
//  Created by Clutch Powers on 2022/11/9.
//

#import "MJPerson.h"

@implementation MJPerson

- (void)test
{
    NSLog(@"TEST");
}

- (void)dealloc
{
    [super dealloc];
    NSLog(@"MJPerson -- dealloc");
}

@end
