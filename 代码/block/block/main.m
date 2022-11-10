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
    @autoreleasepool { // MRC

        __block MJPerson *person = [[MJPerson alloc] init];

        
        MJBlock block = [^{

            [person test];

        } copy];
        
 
        [person release];
        
        block();
        
        [block release];
        
        NSLog(@"Done");
    }
    return 0;
}
