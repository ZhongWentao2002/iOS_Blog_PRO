//
//  main.m
//  block
//
//  Created by Clutch Powers on 2022/11/7.
//

#import <Foundation/Foundation.h>

#import "MJPerson.h"

typedef void (^MJBlock)(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        MJPerson *person = [[MJPerson alloc] init];
        
        __unsafe_unretained MJPerson *weakPerson = person;
        
        person.block = ^{

            [weakPerson test];
        };
        
        person.block();
        
        NSLog(@"%d",[person retainCount]);
        
        [person release];
    }
    
    NSLog(@"Done");
    return 0;
}
