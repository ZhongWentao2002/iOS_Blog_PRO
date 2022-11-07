//
//  main.m
//  block
//
//  Created by Clutch Powers on 2022/11/7.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    

    id obj;
    
    void(^block)(void) = [^{
        NSLog(@"Hello %@",obj);
    } copy];
    
    block();
    
    
    
    
    return 0;
}
