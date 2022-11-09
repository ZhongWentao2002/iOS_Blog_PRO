//
//  main.m
//  block
//
//  Created by Clutch Powers on 2022/11/7.
//

#import <Foundation/Foundation.h>

#import "Person.h"

int main(int argc, const char * argv[]) {
    
        
    __block int a = 10;
    
    void(^block)(void) = ^{
        a = 20;
    };
    
    block();
    NSLog(@"%d",a);
    
    
    
    return 0;
}
